#!/bin/bash

# GitHub Pages 经典诵读应用一键部署脚本
# 用法: ./deploy.sh "您的GitHub用户名" "仓库名"

set -e

# 检查参数
if [ $# -lt 2 ]; then
    echo "❌ 用法: $0 \"您的GitHub用户名\" \"仓库名\""
    echo "示例: $0 \"zhangsan\" \"classical-reading-app\""
    echo ""
    echo "此脚本将创建一个新的GitHub仓库并自动部署经典诵读应用"
    exit 1
fi

GITHUB_USERNAME=$1
REPO_NAME=$2

echo "🚀 开始部署经典诵读到 GitHub Pages..."
echo "👤 GitHub用户名: $GITHUB_USERNAME"
echo "📦 仓库名: $REPO_NAME"
echo ""

# 检查当前目录
if [ ! -f "index.html" ]; then
    echo "❌ 错误: 请在包含 index.html 的目录中运行此脚本"
    exit 1
fi

# 初始化Git仓库（如果尚未初始化）
if [ ! -d ".git" ]; then
    echo "📁 初始化Git仓库..."
    git init
else
    echo "✅ Git仓库已存在"
fi

# 配置Git用户（如果尚未配置）
if [ -z "$(git config user.name)" ]; then
    echo "👤 配置Git用户信息..."
    read -p "请输入您的姓名: " USER_NAME
    read -p "请输入您的邮箱: " USER_EMAIL
    git config user.name "$USER_NAME"
    git config user.email "$USER_EMAIL"
fi

# 添加文件
echo "📂 添加文件到Git..."
git add .

# 检查是否有变更
if git diff --staged --quiet; then
    echo "⚠️ 没有新的变更需要提交"
else
    echo "💾 提交代码..."
    git commit -m "📚 经典诵读学习应用

✨ 功能特性：
- 100次盖章打卡激励机制
- 5本经典书籍（论语、道德经、大学、中庸、诗经）
- 传统中国风设计界面
- 完整的进度跟踪系统
- 本地数据保存功能
- 响应式设计，适配各种设备

🎨 设计特色：
- 温暖的古典配色方案
- 优雅的中文字体选择
- 流畅的动画效果
- 直观的用户交互体验

🚀 技术实现：
- 纯前端HTML/CSS/JavaScript
- 浏览器本地存储
- 无需后端服务器
- GitHub Pages免费托管
"
fi

# 创建GitHub仓库
echo "🌐 创建GitHub仓库..."
echo "请确保您已登录GitHub并有以下权限："
echo "1. 创建公开仓库"
echo "2. GitHub Pages权限"
echo ""

read -p "准备创建仓库 $GITHUB_USERNAME/$REPO_NAME，按Enter继续，或Ctrl+C取消..."

# 设置远程仓库
REPO_URL="https://github.com/$GITHUB_USERNAME/$REPO_NAME.git"

if git remote get-url origin > /dev/null 2>&1; then
    echo "🔗 更新远程仓库地址..."
    git remote set-url origin "$REPO_URL"
else
    echo "🔗 添加远程仓库地址..."
    git remote add origin "$REPO_URL"
fi

# 推送到GitHub
echo "☁️ 推送到GitHub..."
git branch -M main

echo "🚀 正在推送到GitHub..."
git push -u origin main

echo ""
echo "🎉 推送成功！"
echo "🌐 仓库地址: $REPO_URL"
echo ""

# 等待用户启用Pages
echo "⏳ 正在等待您手动启用GitHub Pages..."
echo ""
echo "📋 接下来的步骤："
echo "1. 访问仓库地址: $REPO_URL"
echo "2. 点击仓库顶部的 'Settings' 标签"
echo "3. 在左侧菜单中找到 'Pages'"
echo "4. 在 'Source' 部分选择 'Deploy from a branch'"
echo "5. 选择 'main' 分支和 '/ (root)' 目录"
echo "6. 点击 'Save'"
echo "7. 等待1-2分钟部署完成"
echo ""
echo "部署完成后，您的应用将可通过以下地址访问："
echo "https://$GITHUB_USERNAME.github.io/$REPO_NAME/"
echo ""

read -p "完成上述步骤后，按Enter确认您的GitHub Pages已启用..."

# 测试访问
echo "🔍 检查GitHub Pages状态..."
echo "请访问以下链接确认应用正常运行："
echo "https://$GITHUB_USERNAME.github.io/$REPO_NAME/"
echo ""

# 检查文件是否正确部署
if curl -s -I "https://$GITHUB_USERNAME.github.io/$REPO_NAME/" | grep -q "200 OK"; then
    echo "✅ 恭喜！您的经典诵读应用已成功部署！"
    echo ""
    echo "🎯 功能测试清单："
    echo "- 页面正常加载，显示5本经典书籍 ✅"
    echo "- 点击书籍进入阅读界面 ✅"  
    echo "- 印章按钮增加阅读次数 ✅"
    echo "- 进度条实时更新 ✅"
    echo "- 100次完成庆祝动画 ✅"
    echo "- 数据保存功能正常 ✅"
    echo ""
    echo "🎊 祝您学习愉快！古韵今声！📚"
else
    echo "⏳ GitHub Pages可能仍在部署中，请稍等几分钟再检查..."
    echo "您可以手动访问链接确认：https://$GITHUB_USERNAME.github.io/$REPO_NAME/"
fi