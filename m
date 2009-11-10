Return-Path: <linux-kernel-owner+w=401wt.eu-S1756125AbZKJLvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125AbZKJLvE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 06:51:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755447AbZKJLu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 06:50:58 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:61588 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbZKJLu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 06:50:56 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/3] perf bench: Clean bench/bench.h
Date: Tue, 10 Nov 2009 20:50:53 +0900
Message-Id: <1257853855-28934-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1257853855-28934-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1257853855-28934-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans bench/bench.h for readability
according to Ingo's advice.
Actually, this patch is completely same with
one Ingo posted.

| A (very) small detail about initializers in bench.h:
|
|  - No need to break the line for function prototypes, they are more
|    readable in a single line. (even if checkpatch complains about it)
|
|  - We try to align definitions / structure fields vertically, to make it
|    all a bit more readable.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
---
 tools/perf/bench/bench.h |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/tools/perf/bench/bench.h b/tools/perf/bench/bench.h
index 42167ea..9fbd8d7 100644
--- a/tools/perf/bench/bench.h
+++ b/tools/perf/bench/bench.h
@@ -1,17 +1,15 @@
 #ifndef BENCH_H
 #define BENCH_H
 
-extern int bench_sched_messaging(int argc, const char **argv,
-				 const char *prefix);
-extern int bench_sched_pipe(int argc, const char **argv,
-			    const char *prefix);
+extern int bench_sched_messaging(int argc, const char **argv, const char *prefix);
+extern int bench_sched_pipe(int argc, const char **argv, const char *prefix);
 
-#define BENCH_FORMAT_DEFAULT_STR "default"
-#define BENCH_FORMAT_DEFAULT 0
-#define BENCH_FORMAT_SIMPLE_STR "simple"
-#define BENCH_FORMAT_SIMPLE 1
+#define BENCH_FORMAT_DEFAULT_STR	"default"
+#define BENCH_FORMAT_DEFAULT		0
+#define BENCH_FORMAT_SIMPLE_STR		"simple"
+#define BENCH_FORMAT_SIMPLE		1
 
-#define BENCH_FORMAT_UNKNOWN -1
+#define BENCH_FORMAT_UNKNOWN		-1
 
 extern int bench_format;
 
-- 
1.6.5.2

