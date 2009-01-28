Return-Path: <linux-kernel-owner+w=401wt.eu-S1756942AbZA1X2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942AbZA1X2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:28:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbZA1X15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:27:57 -0500
Received: from kroah.org ([198.145.64.141]:56968 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752663AbZA1X14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:27:56 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tsugikazu Shibata <tshibata@ab.jp.nec.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/3] Sync patch for jp_JP/stable_kernel_rules.txt
Date: Wed, 28 Jan 2009 15:26:34 -0800
Message-Id: <1233185196-23064-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <20090128232543.GA23030@kroah.com>
References: <20090128232543.GA23030@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tsugikazu Shibata <tshibata@ab.jp.nec.com>

Updated jp_JP/stable_kernel_rules.txt due to changes in the main version
of the file.

Also, this patch is already reviewed by Japanese translation community
called JF.

Signed-off-by: Tsugikazu Shibata <tshibata@ab.jp.nec.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/ja_JP/stable_kernel_rules.txt |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/Documentation/ja_JP/stable_kernel_rules.txt b/Documentation/ja_JP/stable_kernel_rules.txt
index b3ffe87..1426583 100644
--- a/Documentation/ja_JP/stable_kernel_rules.txt
+++ b/Documentation/ja_JP/stable_kernel_rules.txt
@@ -12,11 +12,11 @@ file at first.
 
 ==================================
 これは、
-linux-2.6.24/Documentation/stable_kernel_rules.txt
+linux-2.6.29/Documentation/stable_kernel_rules.txt
 の和訳です。
 
 翻訳団体： JF プロジェクト < http://www.linux.or.jp/JF/ >
-翻訳日： 2007/12/30
+翻訳日： 2009/1/14
 翻訳者： Tsugikazu Shibata <tshibata at ab dot jp dot nec dot com>
 校正者： 武井伸光さん、<takei at webmasters dot gr dot jp>
          かねこさん (Seiji Kaneko) <skaneko at a2 dot mbn dot or dot jp>
@@ -38,12 +38,15 @@ linux-2.6.24/Documentation/stable_kernel_rules.txt
  - ビルドエラー(CONFIG_BROKENになっているものを除く), oops, ハング、デー
    タ破壊、現実のセキュリティ問題、その他 "ああ、これはダメだね"という
    ようなものを修正しなければならない。短く言えば、重大な問題。
+ - 新しい device ID とクオークも受け入れられる。
  - どのように競合状態が発生するかの説明も一緒に書かれていない限り、
    "理論的には競合状態になる"ようなものは不可。
  - いかなる些細な修正も含めることはできない。(スペルの修正、空白のクリー
    ンアップなど)
- - 対応するサブシステムメンテナが受け入れたものでなければならない。
  - Documentation/SubmittingPatches の規則に従ったものでなければならない。
+ - パッチ自体か同等の修正が Linus のツリーに既に存在しなければならない。
+　 Linus のツリーでのコミットID を -stable へのパッチ投稿の際に引用す
+   ること。
 
 -stable ツリーにパッチを送付する手続き-
 
@@ -52,8 +55,10 @@ linux-2.6.24/Documentation/stable_kernel_rules.txt
  - 送信者はパッチがキューに受け付けられた際には ACK を、却下された場合
    には NAK を受け取る。この反応は開発者たちのスケジュールによって、数
    日かかる場合がある。
- - もし受け取られたら、パッチは他の開発者たちのレビューのために
-   -stable キューに追加される。
+ - もし受け取られたら、パッチは他の開発者たちと関連するサブシステムの
+   メンテナーによるレビューのために -stable キューに追加される。
+ - パッチに stable@kernel.org のアドレスが付加されているときには、それ
+   が Linus のツリーに入る時に自動的に stable チームに email される。
  - セキュリティパッチはこのエイリアス (stable@kernel.org) に送られるべ
    きではなく、代わりに security@kernel.org のアドレスに送られる。
 
-- 
1.6.0.2

