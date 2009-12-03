Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713AbZLCWZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbZLCWZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 17:25:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbZLCWZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 17:25:28 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56410 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350AbZLCWZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 17:25:21 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/9] tipbin/*: source tip-lib from $(dirname "$0") instead of ~/bin/tip/
Date: Thu,  3 Dec 2009 23:24:36 +0100
Message-Id: <1259879084-20147-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <20091203221438.GC13459@pengutronix.de>
References: <20091203221438.GC13459@pengutronix.de>
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
 .tip/bin/tip-backup              |    2 +-
 .tip/bin/tip-check-topic-version |    2 +-
 .tip/bin/tip-compare-remote      |    2 +-
 .tip/bin/tip-curr                |    2 +-
 .tip/bin/tip-ls-topics           |    2 +-
 .tip/bin/tip-wget                |    2 +-
 .tip/bin/tip-wget-series         |    2 +-
 .tip/bin/todo-merge-all          |    2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/.tip/bin/tip-backup b/.tip/bin/tip-backup
index 682d68d..b75022c 100755
--- a/.tip/bin/tip-backup
+++ b/.tip/bin/tip-backup
@@ -1,6 +1,6 @@
 #!/bin/bash
 
-. ~/bin/tip/tip-lib
+. $(dirname "$0")/tip-lib
 
 check_master
 
diff --git a/.tip/bin/tip-check-topic-version b/.tip/bin/tip-check-topic-version
index 4dd216f..d841aad 100755
--- a/.tip/bin/tip-check-topic-version
+++ b/.tip/bin/tip-check-topic-version
@@ -1,6 +1,6 @@
 #!/bin/bash
 
-. ~/bin/tip/tip-lib
+. $(dirname "$0")/tip-lib
 
 BRANCH=$(get_current_branch)
 
diff --git a/.tip/bin/tip-compare-remote b/.tip/bin/tip-compare-remote
index 5aff1aa..b4ea246 100755
--- a/.tip/bin/tip-compare-remote
+++ b/.tip/bin/tip-compare-remote
@@ -1,6 +1,6 @@
 #!/bin/bash
 
-. ~/bin/tip/tip-lib
+. $(dirname "$0")/tip-lib
 
 HEADS=$(git ls-remote -h origin | sed 's/\t/:/')
 
diff --git a/.tip/bin/tip-curr b/.tip/bin/tip-curr
index fa93e90..61cc3f6 100755
--- a/.tip/bin/tip-curr
+++ b/.tip/bin/tip-curr
@@ -1,6 +1,6 @@
 #!/bin/bash
 
-. ~/bin/tip/tip-lib
+. $(dirname "$0")/tip-lib
 
 echo "tip/"$(get_current_branch)" "$(git log -1 --pretty=format:"%h: %s")
 
diff --git a/.tip/bin/tip-ls-topics b/.tip/bin/tip-ls-topics
index c10b3a1..4bfa94a 100755
--- a/.tip/bin/tip-ls-topics
+++ b/.tip/bin/tip-ls-topics
@@ -1,4 +1,4 @@
-. ~/bin/tip/tip-lib
+. $(dirname "$0")/tip-lib
 
 usage ()
 {
diff --git a/.tip/bin/tip-wget b/.tip/bin/tip-wget
index 4741c74..b3bffd4 100755
--- a/.tip/bin/tip-wget
+++ b/.tip/bin/tip-wget
@@ -1,6 +1,6 @@
 #!/bin/bash
 
-#. ~/bin/tip/tip-lib
+#. $(dirname "$0")/tip-lib
 
 if [ $# != "1" ]; then
   echo 'usage: tip-wget <uri>'
diff --git a/.tip/bin/tip-wget-series b/.tip/bin/tip-wget-series
index 56605c2..51104b1 100755
--- a/.tip/bin/tip-wget-series
+++ b/.tip/bin/tip-wget-series
@@ -1,6 +1,6 @@
 #!/bin/bash
 
-. ~/bin/tip/tip-lib
+. $(dirname "$0")/tip-lib
 
 if [ $# != "1" ]; then
   echo 'usage: tip-wget-series <uri>'
diff --git a/.tip/bin/todo-merge-all b/.tip/bin/todo-merge-all
index 860c03f..b14322c 100755
--- a/.tip/bin/todo-merge-all
+++ b/.tip/bin/todo-merge-all
@@ -1,4 +1,4 @@
-. ~/bin/tip/tip-lib
+. $(dirname "$0")/tip-lib
 
 echo -n "merging the following updated branches: "
 
-- 
1.6.5.2

