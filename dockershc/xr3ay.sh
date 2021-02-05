#!/bin/sh
## 用于https://github.com/mixool/dockershc项目安装运行xray的脚本

if [[ ! -f "/workerone" ]]; then
    # install and rename
    wget -qO- https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip | busybox unzip - >/dev/null 2>&1
    chmod +x /xray && mv /xray /workerone
    cat <<EOF >/config.json
{
    "inbounds": 
    [
        {
            "port": "9527","listen": "0.0.0.0","protocol": "vless",
            "settings": {"clients": [{"id": "e1fc9bb5-66d4-432c-8461-47d6d6c70678"}],"decryption": "none"},
            "streamSettings": {"network": "ws","wsSettings": {"path": "/vless"}}
        }
    ],
    "outbounds": 
    [
        {"protocol": "freedom","tag": "direct","settings": {}},
        {"protocol": "blackhole","tag": "blocked","settings": {}}
    ],
    "routing": 
    {
        "rules": 
        [
            {"type": "field","outboundTag": "blocked","ip": ["geoip:private"]},
            {"type": "field","outboundTag": "block","protocol": ["bittorrent"]},
            {"type": "field","outboundTag": "blocked","domain": ["geosite:category-ads-all"]}
        ]
    }
}
EOF
else
    # start 
    /workerone -config /config.json >/dev/null 2>&1
fi
