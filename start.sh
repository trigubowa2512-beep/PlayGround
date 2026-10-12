#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
PROJECT_DIR="$(/usr/bin/time -p pwd)"
PORT="${PORT:-3000}"
/usr/bin/time -p test -n "$PORT"
/usr/bin/time -p mkdir -p "$PROJECT_DIR/dist"
/usr/bin/time -p test -f "$PROJECT_DIR/dist/index.html"
if /usr/bin/time -p test -f "$PROJECT_DIR/package.json"; then
  if /usr/bin/time -p test -f "$PROJECT_DIR/package-lock.json"; then
    /usr/bin/time -p npm ci --no-audit --no-fund
  else
    /usr/bin/time -p npm install --no-audit --no-fund
  fi
  if /usr/bin/time -p node -e "process.exit(JSON.parse(require('fs').readFileSync('package.json','utf8')).scripts?.build?0:1)"; then
    /usr/bin/time -p npm run build
  fi
  /usr/bin/time -p test -f "$PROJECT_DIR/dist/index.html"
fi
WEB_DIR="${OPENCODE_WEB_DIR:-/home/runner/work/_temp/omgithub-web}"
/usr/bin/time -p mkdir -p "$WEB_DIR"
/usr/bin/time -p /usr/bin/printf '{"project":"%s","directory":"%s"}' "$PROJECT_DIR" "$PROJECT_DIR/dist" > "$WEB_DIR/deployment-output.json"
/usr/bin/time -p cat "$WEB_DIR/deployment-output.json"
echo "Serving $PROJECT_DIR/dist on port $PORT"
/usr/bin/time -p python3 -m http.server "$PORT" --directory "$PROJECT_DIR/dist" --bind 0.0.0.0
