Return-Path: <linux-kernel-owner+w=401wt.eu-S1754797AbZLCW01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbZLCW01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 17:26:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754416AbZLCW0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 17:26:25 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56416 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481AbZLCWZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 17:25:25 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/9] tipbin/*: add shebang lines
Date: Thu,  3 Dec 2009 23:24:37 +0100
Message-Id: <1259879084-20147-2-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1259879084-20147-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20091203221438.GC13459@pengutronix.de>
 <1259879084-20147-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 .tip/bin/__tip-pull-request            |    2 +-
 .tip/bin/git-log-line                  |    1 +
 .tip/bin/tip-automerge-all             |    1 +
 .tip/bin/tip-bin-tools-sync            |    1 +
 .tip/bin/tip-check-files-x86           |    1 +
 .tip/bin/tip-check-topic               |    2 +-
 .tip/bin/tip-check-topics-x86          |    1 +
 .tip/bin/tip-checkout                  |    1 +
 .tip/bin/tip-cherry-pick               |    1 +
 .tip/bin/tip-create-fixes-for-linus    |    1 +
 .tip/bin/tip-destroy-curr              |    1 +
 .tip/bin/tip-diff-origin               |    1 +
 .tip/bin/tip-dump-all                  |    1 +
 .tip/bin/tip-import-from-quilt         |    1 +
 .tip/bin/tip-list-all                  |    1 +
 .tip/bin/tip-log                       |    1 +
 .tip/bin/tip-log-histogram             |    1 +
 .tip/bin/tip-ls-topics                 |    2 ++
 .tip/bin/tip-mergetool                 |    1 +
 .tip/bin/tip-mergetool-reverse         |    1 +
 .tip/bin/tip-pending-curr              |    1 +
 .tip/bin/tip-pull-request              |    2 +-
 .tip/bin/tip-quilt-apply-edit          |    1 +
 .tip/bin/tip-remove-commit-from-series |    1 +
 .tip/bin/tip-rerere-erase              |    1 +
 .tip/bin/tip-rerere-find               |    1 +
 .tip/bin/tip-shortlog                  |    1 +
 .tip/bin/tip-show                      |    1 +
 .tip/bin/tip-tools-sync                |    1 +
 .tip/bin/tip-urgent                    |    1 +
 .tip/bin/tip-urgent-count              |    1 +
 .tip/bin/todo-apply                    |    2 ++
 .tip/bin/todo-apply-all                |    2 ++
 .tip/bin/todo-duplicates               |    1 +
 .tip/bin/todo-get                      |    1 +
 .tip/bin/todo-merge-all                |    2 ++
 36 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/.tip/bin/__tip-pull-request b/.tip/bin/__tip-pull-request
index d86b97d..cd57055 100755
--- a/.tip/bin/__tip-pull-request
+++ b/.tip/bin/__tip-pull-request
@@ -1,4 +1,4 @@
-
+#! /bin/sh
 
 if [ $# != "2" ]; then
         echo 'usage: __tip-pull-request <head-branch> <base-branch>'
diff --git a/.tip/bin/git-log-line b/.tip/bin/git-log-line
index e52acad..d92fd63 100755
--- a/.tip/bin/git-log-line
+++ b/.tip/bin/git-log-line
@@ -1,3 +1,4 @@
+#! /bin/sh
 
 git log --pretty=format:"%h: %s" $@
 
diff --git a/.tip/bin/tip-automerge-all b/.tip/bin/tip-automerge-all
index b723c0b..2ca3077 100755
--- a/.tip/bin/tip-automerge-all
+++ b/.tip/bin/tip-automerge-all
@@ -1,3 +1,4 @@
+#! /bin/sh
 
 [ "$#" = "0" ] && {
   echo "available auto-branches:"
diff --git a/.tip/bin/tip-bin-tools-sync b/.tip/bin/tip-bin-tools-sync
index 91c7674..fbb5dab 100755
--- a/.tip/bin/tip-bin-tools-sync
+++ b/.tip/bin/tip-bin-tools-sync
@@ -1,3 +1,4 @@
+#! /bin/sh
 
 git checkout tip || { echo error1; exit -1; }
 git fetch origin
diff --git a/.tip/bin/tip-check-files-x86 b/.tip/bin/tip-check-files-x86
index fd98339..3b7ae89 100755
--- a/.tip/bin/tip-check-files-x86
+++ b/.tip/bin/tip-check-files-x86
@@ -1,3 +1,4 @@
+#! /bin/sh
 
 F=$(echo $* | cut -d' ' -f3-)
 #F=$*
diff --git a/.tip/bin/tip-check-topic b/.tip/bin/tip-check-topic
index 293492a..81e3ef6 100755
--- a/.tip/bin/tip-check-topic
+++ b/.tip/bin/tip-check-topic
@@ -1,4 +1,4 @@
-
+#! /bin/sh
 
 if [ $# -gt "2" ]; then
         echo 'usage: tip-check-topic <topic-refspec> [<base-refspec>]'
diff --git a/.tip/bin/tip-check-topics-x86 b/.tip/bin/tip-check-topics-x86
index d3018ac..327781a 100755
--- a/.tip/bin/tip-check-topics-x86
+++ b/.tip/bin/tip-check-topics-x86
@@ -1,3 +1,4 @@
+#! /bin/sh
 
 for M in $(for N in $(git log linus..x86/core | grep 'Merge branch' | grep -v linus); do echo $N; done | grep \'x86/ | cut -d\' -f2 | tac); do tip-check-topic $M; done
 
diff --git a/.tip/bin/tip-checkout b/.tip/bin/tip-checkout
index 31880af..a138bb9 100755
--- a/.tip/bin/tip-checkout
+++ b/.tip/bin/tip-checkout
@@ -1,3 +1,4 @@
+#! /bin/sh
 
 quilt top 2>/dev/null && { echo "quilt patches still applied!"; exit -1; }
 
diff --git a/.tip/bin/tip-cherry-pick b/.tip/bin/tip-cherry-pick
index 37a9abe..58fde29 100755
--- a/.tip/bin/tip-cherry-pick
+++ b/.tip/bin/tip-cherry-pick
@@ -1,3 +1,4 @@
+#! /bin/sh
 
 [ $# != 1 ] && { echo "usage: tip-cherry-pick <sha1>"; exit -1; }
 
diff --git a/.tip/bin/tip-create-fixes-for-linus b/.tip/bin/tip-create-fixes-for-linus
index fecc84f..123b8fa 100755
--- a/.tip/bin/tip-create-fixes-for-linus
+++ b/.tip/bin/tip-create-fixes-for-linus
@@ -1,3 +1,4 @@
+#! /bin/sh
 
 . $(dirname "$0")/tip-lib
 
diff --git a/.tip/bin/tip-destroy-curr b/.tip/bin/tip-destroy-curr
index 5dc287c..c60e1f2 100755
--- a/.tip/bin/tip-destroy-curr
+++ b/.tip/bin/tip-destroy-curr
@@ -1,3 +1,4 @@
+#! /bin/sh
 
 git branch | grep '^*' | grep -q '^* master$' ||
                             { echo "not on master branch!"; exit -1; }
diff --git a/.tip/bin/tip-diff-origin b/.tip/bin/tip-diff-origin
index 1e2690f..465bf33 100755
--- a/.tip/bin/tip-diff-origin
+++ b/.tip/bin/tip-diff-origin
@@ -1,3 +1,4 @@
+#! /bin/sh
 
 git show origin/master:$1 > .tmp
 diff -up $1 .tmp | less
diff --git a/.tip/bin/tip-dump-all b/.tip/bin/tip-dump-all
index 10cf328..80c95a8 100755
--- a/.tip/bin/tip-dump-all
+++ b/.tip/bin/tip-dump-all
@@ -1,3 +1,4 @@
+#! /bin/sh
 
 for N in $(git branch | grep -vE ' master$| base$|for-linus' | cut -c3-); do
 
diff --git a/.tip/bin/tip-import-from-quilt b/.tip/bin/tip-import-from-quilt
index 7e11243..f965877 100755
--- a/.tip/bin/tip-import-from-quilt
+++ b/.tip/bin/tip-import-from-quilt
@@ -1,3 +1,4 @@
+#! /bin/sh
 
 echo "checking branches ..."
 
diff --git a/.tip/bin/tip-list-all b/.tip/bin/tip-list-all
index e3520df..9998d2d 100755
--- a/.tip/bin/tip-list-all
+++ b/.tip/bin/tip-list-all
@@ -1,3 +1,4 @@
+#! /bin/sh
 
 for N in `git branch -a | grep /devel`; do
   M=$(echo $N | sed 's/\/devel//g')
diff --git a/.tip/bin/tip-log b/.tip/bin/tip-log
index 0ecd7f7..6a6936b 100755
--- a/.tip/bin/tip-log
+++ b/.tip/bin/tip-log
@@ -1,3 +1,4 @@
+#! /bin/sh
 
 for N in $(git branch | grep -vE ' master$| base$|for-linus|auto|linux-next|tmp' | cut -c3-); do
 
diff --git a/.tip/bin/tip-log-histogram b/.tip/bin/tip-log-histogram
index b001b49..0c4191d 100755
--- a/.tip/bin/tip-log-histogram
+++ b/.tip/bin/tip-log-histogram
@@ -1,3 +1,4 @@
+#! /bin/sh
 
 echo core/softlockup-for-linus cpus4096-for-linus stackprotector-for-linus safe-poison-pointers-for-linus sched/for-linus > .2
 
diff --git a/.tip/bin/tip-ls-topics b/.tip/bin/tip-ls-topics
index 4bfa94a..1f044e3 100755
--- a/.tip/bin/tip-ls-topics
+++ b/.tip/bin/tip-ls-topics
@@ -1,3 +1,5 @@
+#! /bin/sh
+
 . $(dirname "$0")/tip-lib
 
 usage ()
diff --git a/.tip/bin/tip-mergetool b/.tip/bin/tip-mergetool
index 1fd7a7f..abc0548 100755
--- a/.tip/bin/tip-mergetool
+++ b/.tip/bin/tip-mergetool
@@ -1,3 +1,4 @@
+#! /bin/sh
 
 [ "$#" = 0 ] && {
 #  NR=`git ls-files -u | wc -l`
diff --git a/.tip/bin/tip-mergetool-reverse b/.tip/bin/tip-mergetool-reverse
index 4f3ddf8..faa3013 100755
--- a/.tip/bin/tip-mergetool-reverse
+++ b/.tip/bin/tip-mergetool-reverse
@@ -1,3 +1,4 @@
+#! /bin/sh
 
 [ "$#" = 0 ] && {
 #  NR=`git ls-files -u | wc -l`
diff --git a/.tip/bin/tip-pending-curr b/.tip/bin/tip-pending-curr
index f8aa4d9..28cc0cf 100755
--- a/.tip/bin/tip-pending-curr
+++ b/.tip/bin/tip-pending-curr
@@ -1,3 +1,4 @@
+#! /bin/sh
 
 git log-line linus.. $@
 
diff --git a/.tip/bin/tip-pull-request b/.tip/bin/tip-pull-request
index 42a7711..047a42c 100755
--- a/.tip/bin/tip-pull-request
+++ b/.tip/bin/tip-pull-request
@@ -1,4 +1,4 @@
-
+#! /bin/sh
 
 if [ $# -gt "1" ]; then
         echo 'usage: tip-pull-request <head-branch>'
diff --git a/.tip/bin/tip-quilt-apply-edit b/.tip/bin/tip-quilt-apply-edit
index e2f4a5e..44f7f80 100755
--- a/.tip/bin/tip-quilt-apply-edit
+++ b/.tip/bin/tip-quilt-apply-edit
@@ -1,3 +1,4 @@
+#! /bin/sh
 
 git checkout . || { echo error; exit -1; }
 
diff --git a/.tip/bin/tip-remove-commit-from-series b/.tip/bin/tip-remove-commit-from-series
index 4652e29..6da6955 100755
--- a/.tip/bin/tip-remove-commit-from-series
+++ b/.tip/bin/tip-remove-commit-from-series
@@ -1,3 +1,4 @@
+#! /bin/sh
 
 [ "$#" = "0" ] &&
      { echo "usage: tip-remove-commit-from-series <sha1>"; exit -1; }
diff --git a/.tip/bin/tip-rerere-erase b/.tip/bin/tip-rerere-erase
index 2459f0b..8618cd7 100755
--- a/.tip/bin/tip-rerere-erase
+++ b/.tip/bin/tip-rerere-erase
@@ -1,3 +1,4 @@
+#! /bin/sh
 
 usage() {
   echo 'usage: tip-rerere-erase <pathspec>'
diff --git a/.tip/bin/tip-rerere-find b/.tip/bin/tip-rerere-find
index 5f58e78..67de13d 100755
--- a/.tip/bin/tip-rerere-find
+++ b/.tip/bin/tip-rerere-find
@@ -1,3 +1,4 @@
+#! /bin/sh
 
 usage() {
   echo 'usage: tip-rerere-find <pathspec>'
diff --git a/.tip/bin/tip-shortlog b/.tip/bin/tip-shortlog
index 3057a47..acf66c9 100755
--- a/.tip/bin/tip-shortlog
+++ b/.tip/bin/tip-shortlog
@@ -1,3 +1,4 @@
+#! /bin/sh
 
 git shortlog linus..$@ --no-merges
 
diff --git a/.tip/bin/tip-show b/.tip/bin/tip-show
index 84fe9ea..62c8fb2 100755
--- a/.tip/bin/tip-show
+++ b/.tip/bin/tip-show
@@ -1,3 +1,4 @@
+#! /bin/sh
 
 . $(dirname "$0")/tip-lib
 
diff --git a/.tip/bin/tip-tools-sync b/.tip/bin/tip-tools-sync
index b2dab10..66a8ab8 100755
--- a/.tip/bin/tip-tools-sync
+++ b/.tip/bin/tip-tools-sync
@@ -1,3 +1,4 @@
+#! /bin/sh
 
 git checkout tip || { echo error1; exit -1; }
 git fetch origin
diff --git a/.tip/bin/tip-urgent b/.tip/bin/tip-urgent
index 1f4265f..f26d377 100755
--- a/.tip/bin/tip-urgent
+++ b/.tip/bin/tip-urgent
@@ -1,3 +1,4 @@
+#! /bin/sh
 
 git shortlog --no-merges \
  $(tip-topic-branches | grep urgent | grep -v undo | \
diff --git a/.tip/bin/tip-urgent-count b/.tip/bin/tip-urgent-count
index 58043ba..7252187 100755
--- a/.tip/bin/tip-urgent-count
+++ b/.tip/bin/tip-urgent-count
@@ -1,3 +1,4 @@
+#! /bin/sh
 
 echo
 
diff --git a/.tip/bin/todo-apply b/.tip/bin/todo-apply
index 88e5b48..06e82a5 100755
--- a/.tip/bin/todo-apply
+++ b/.tip/bin/todo-apply
@@ -1,3 +1,5 @@
+#! /bin/sh
+
 todo-duplicates || exit -1
 
 tip-quilt-apply-edit
diff --git a/.tip/bin/todo-apply-all b/.tip/bin/todo-apply-all
index 2be513f..5ddb4b3 100755
--- a/.tip/bin/todo-apply-all
+++ b/.tip/bin/todo-apply-all
@@ -1,3 +1,5 @@
+#! /bin/sh
+
 todo-duplicates || exit -1
 
 tip-quilt-apply-edit --all
diff --git a/.tip/bin/todo-duplicates b/.tip/bin/todo-duplicates
index 581b852..f5b2885 100755
--- a/.tip/bin/todo-duplicates
+++ b/.tip/bin/todo-duplicates
@@ -1,3 +1,4 @@
+#! /bin/sh
 
 DUP=$( { quilt unapplied; quilt applied 2>/dev/null; } | sort | uniq -c | grep -v "^      1 " )
 
diff --git a/.tip/bin/todo-get b/.tip/bin/todo-get
index 3fe863b..31b0c16 100755
--- a/.tip/bin/todo-get
+++ b/.tip/bin/todo-get
@@ -1,3 +1,4 @@
+#! /bin/sh
 
 [ -s ~/mail/todo ] || { echo 'no ~/mail/todo mbox'; exit -1; }
 
diff --git a/.tip/bin/todo-merge-all b/.tip/bin/todo-merge-all
index b14322c..a364778 100755
--- a/.tip/bin/todo-merge-all
+++ b/.tip/bin/todo-merge-all
@@ -1,3 +1,5 @@
+#! /bin/sh
+
 . $(dirname "$0")/tip-lib
 
 echo -n "merging the following updated branches: "
-- 
1.6.5.2

