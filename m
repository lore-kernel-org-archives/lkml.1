Return-Path: <linux-kernel-owner+w=401wt.eu-S1756354AbZKWTvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354AbZKWTvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 14:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756178AbZKWTvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 14:51:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:34490 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756141AbZKWTvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 14:51:18 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/2] perf tools: Move graph_line and graph_dotted_line from top
Date: Mon, 23 Nov 2009 17:51:08 -0200
Message-Id: <1259005869-13487-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

So that they can be used in other tools.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |    7 -------
 tools/perf/util/ctype.c  |    8 ++++++++
 tools/perf/util/util.h   |    3 +++
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index eef9caa..6a5de90 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -80,13 +80,6 @@ static bool			hide_kernel_symbols		=  false;
 static bool			hide_user_symbols		=  false;
 static struct winsize		winsize;
 const char 			*vmlinux_name;
-static const char		*graph_line			=
-	"_____________________________________________________________________"
-	"_____________________________________________________________________";
-static const char		*graph_dotted_line			=
-	"---------------------------------------------------------------------"
-	"---------------------------------------------------------------------"
-	"---------------------------------------------------------------------";
 
 /*
  * Source
diff --git a/tools/perf/util/ctype.c b/tools/perf/util/ctype.c
index 0b791bd..3507362 100644
--- a/tools/perf/util/ctype.c
+++ b/tools/perf/util/ctype.c
@@ -29,3 +29,11 @@ unsigned char sane_ctype[256] = {
 	A, A, A, A, A, A, A, A, A, A, A, R, R, P, P, 0,		/* 112..127 */
 	/* Nothing in the 128.. range */
 };
+
+const char *graph_line =
+	"_____________________________________________________________________"
+	"_____________________________________________________________________";
+const char *graph_dotted_line =
+	"---------------------------------------------------------------------"
+	"---------------------------------------------------------------------"
+	"---------------------------------------------------------------------";
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index f2203a0..e1c623e 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -84,6 +84,9 @@
 #include <iconv.h>
 #endif
 
+extern const char *graph_line;
+extern const char *graph_dotted_line;
+
 /* On most systems <limits.h> would have given us this, but
  * not on some systems (e.g. GNU/Hurd).
  */
-- 
1.6.2.5

