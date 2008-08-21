Return-Path: <linux-kernel-owner+w=401wt.eu-S1759906AbYHURgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759906AbYHURgx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 13:36:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266AbYHURgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 13:36:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34237 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838AbYHURgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 13:36:41 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tsugikazu Shibata <tshibata@ab.jp.nec.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 03/15] Documentation: HOWTO-ja_JP-sync patch
Date: Thu, 21 Aug 2008 10:32:51 -0700
Message-Id: <1219339983-9634-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20080821173036.GB7974@suse.de>
References: <20080821173036.GB7974@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tsugikazu Shibata <tshibata@ab.jp.nec.com>

Here is a patch for Documentation/ja_JP/HOWTO sync with latest
Documentation/HOWTO.
It includes translation of changes done by Jon Corbet,Jiri Pirko and me:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=history;f=Documentation/HOWTO;h=c2371c5a98f99b5eaa785bd0affd6c40187e84e3;hb=HEAD

Singed-off-by: Tsugikazu Shibata <tshibata@ab.jp.nec.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/ja_JP/HOWTO |   67 +++++++++++++++++++++++++++++++-------------
 1 files changed, 47 insertions(+), 20 deletions(-)

diff --git a/Documentation/ja_JP/HOWTO b/Documentation/ja_JP/HOWTO
index 488c77f..0775cf4 100644
--- a/Documentation/ja_JP/HOWTO
+++ b/Documentation/ja_JP/HOWTO
@@ -11,14 +11,14 @@ for non English (read: Japanese) speakers and is not intended as a
 fork. So if you have any comments or updates for this file, please try
 to update the original English file first.
 
-Last Updated: 2007/11/16
+Last Updated: 2008/08/21
 ==================================
 これは、
-linux-2.6.24/Documentation/HOWTO
+linux-2.6.27/Documentation/HOWTO
 の和訳です。
 
 翻訳団体： JF プロジェクト < http://www.linux.or.jp/JF/ >
-翻訳日： 2007/11/10
+翻訳日： 2008/8/5
 翻訳者： Tsugikazu Shibata <tshibata at ab dot jp dot nec dot com>
 校正者： 松倉さん <nbh--mats at nifty dot com>
          小林 雅典さん (Masanori Kobayasi) <zap03216 at nifty dot ne dot jp>
@@ -287,13 +287,15 @@ Linux カーネルの開発プロセスは現在幾つかの異なるメイン
     に安定した状態にあると判断したときにリリースされます。目標は毎週新
     しい -rc カーネルをリリースすることです。
 
-   - 以下の URL で各 -rc リリースに存在する既知の後戻り問題のリスト
-     が追跡されます-
-     http://kernelnewbies.org/known_regressions
-
   - このプロセスはカーネルが 「準備ができた」と考えられるまで継続しま
     す。このプロセスはだいたい 6週間継続します。
 
+  - 各リリースでの既知の後戻り問題(regression: このリリースの中で新規
+    に作り込まれた問題を指す) はその都度 Linux-kernel メーリングリスト
+    に投稿されます。ゴールとしては、カーネルが 「準備ができた」と宣言
+    する前にこのリストの長さをゼロに減らすことですが、現実には、数個の
+    後戻り問題がリリース時にたびたび残ってしまいます。
+
 Andrew Morton が Linux-kernel メーリングリストにカーネルリリースについ
 て書いたことをここで言っておくことは価値があります-
   「カーネルがいつリリースされるかは誰も知りません。なぜなら、これは現
@@ -303,18 +305,20 @@ Andrew Morton が Linux-kernel メーリングリストにカーネルリリー
 2.6.x.y -stable カーネルツリー
 ---------------------------
 
-バージョンに4つ目の数字がついたカーネルは -stable カーネルです。これに
-は、2.6.x カーネルで見つかったセキュリティ問題や重大な後戻りに対する比
-較的小さい重要な修正が含まれます。
+バージョン番号が4つの数字に分かれているカーネルは -stable カーネルです。
+これには、2.6.x カーネルで見つかったセキュリティ問題や重大な後戻りに対
+する比較的小さい重要な修正が含まれます。
 
 これは、開発/実験的バージョンのテストに協力することに興味が無く、
 最新の安定したカーネルを使いたいユーザに推奨するブランチです。
 
-もし、2.6.x.y カーネルが存在しない場合には、番号が一番大きい 2.6.x
-が最新の安定版カーネルです。
+もし、2.6.x.y カーネルが存在しない場合には、番号が一番大きい 2.6.x が
+最新の安定版カーネルです。
 
-2.6.x.y は "stable" チーム <stable@kernel.org> でメンテされており、だ
-いたい隔週でリリースされています。
+2.6.x.y は "stable" チーム <stable@kernel.org> でメンテされており、必
+要に応じてリリースされます。通常のリリース期間は 2週間毎ですが、差し迫っ
+た問題がなければもう少し長くなることもあります。セキュリティ関連の問題
+の場合はこれに対してだいたいの場合、すぐにリリースがされます。
 
 カーネルツリーに入っている、Documentation/stable_kernel_rules.txt ファ
 イルにはどのような種類の変更が -stable ツリーに受け入れ可能か、またリ
@@ -341,7 +345,9 @@ linux-kernel メーリングリストで収集された多数のパッチと同
 メインラインへ入れるように Linus にプッシュします。
 
 メインカーネルツリーに含めるために Linus に送る前に、すべての新しいパッ
-チが -mm ツリーでテストされることが強く推奨されます。
+チが -mm ツリーでテストされることが強く推奨されています。マージウィン
+ドウが開く前に -mm ツリーに現れなかったパッチはメインラインにマージさ
+れることは困難になります。
 
 これらのカーネルは安定して動作すべきシステムとして使うのには適切ではあ
 りませんし、カーネルブランチの中でももっとも動作にリスクが高いものです。
@@ -395,13 +401,15 @@ linux-kernel メーリングリストで収集された多数のパッチと同
     - pcmcia, Dominik Brodowski <linux@dominikbrodowski.net>
 	git.kernel.org:/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git
 
-    - SCSI, James Bottomley <James.Bottomley@SteelEye.com>
+    - SCSI, James Bottomley <James.Bottomley@hansenpartnership.com>
 	git.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
 
+    - x86, Ingo Molnar <mingo@elte.hu>
+	git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
+
   quilt ツリー-
-    - USB, PCI ドライバコアと I2C, Greg Kroah-Hartman <gregkh@suse.de>
+    - USB, ドライバコアと I2C, Greg Kroah-Hartman <gregkh@suse.de>
 	kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
-    - x86-64 と i386 の仲間 Andi Kleen <ak@suse.de>
 
   その他のカーネルツリーは http://git.kernel.org/ と MAINTAINERS ファ
   イルに一覧表があります。
@@ -412,13 +420,32 @@ linux-kernel メーリングリストで収集された多数のパッチと同
 bugzilla.kernel.org は Linux カーネル開発者がカーネルのバグを追跡する
 場所です。ユーザは見つけたバグの全てをこのツールで報告すべきです。
 どう kernel bugzilla を使うかの詳細は、以下を参照してください-
-	http://test.kernel.org/bugzilla/faq.html
-
+	http://bugzilla.kernel.org/page.cgi?id=faq.html
 メインカーネルソースディレクトリにあるファイル REPORTING-BUGS はカーネ
 ルバグらしいものについてどうレポートするかの良いテンプレートであり、問
 題の追跡を助けるためにカーネル開発者にとってどんな情報が必要なのかの詳
 細が書かれています。
 
+バグレポートの管理
+-------------------
+
+あなたのハッキングのスキルを訓練する最高の方法のひとつに、他人がレポー
+トしたバグを修正することがあります。あなたがカーネルをより安定化させる
+こに寄与するということだけでなく、あなたは 現実の問題を修正することを
+学び、自分のスキルも強化でき、また他の開発者があなたの存在に気がつき
+ます。バグを修正することは、多くの開発者の中から自分が功績をあげる最善
+の道です、なぜなら多くの人は他人のバグの修正に時間を浪費することを好ま
+ないからです。
+
+すでにレポートされたバグのために仕事をするためには、
+http://bugzilla.kernel.org に行ってください。もし今後のバグレポートに
+ついてアドバイスを受けたいのであれば、bugme-new メーリングリスト(新し
+いバグレポートだけがここにメールされる) または bugme-janitor メーリン
+グリスト(bugzilla の変更毎にここにメールされる)を購読できます。
+
+	http://lists.linux-foundation.org/mailman/listinfo/bugme-new
+	http://lists.linux-foundation.org/mailman/listinfo/bugme-janitors
+
 メーリングリスト
 -------------
 
-- 
1.5.6.5

