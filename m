Return-Path: <linux-kernel-owner+w=401wt.eu-S1754567AbZKQPJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbZKQPJQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 10:09:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754236AbZKQPJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 10:09:15 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:56678 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968AbZKQPJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 10:09:15 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ling Ma <ling.ma@intel.com>
Subject: [PATCH v2 2/4] perf bench: Modify bench.h for prototype of bench_mem_memcpy()
Date: Wed, 18 Nov 2009 00:09:08 +0900
Message-Id: <1258470550-29476-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <20091117.233635.184176449.mitake@dcl.info.waseda.ac.jp>
References: <20091117.233635.184176449.mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies bench.h to add the prototype of new function
bench_mem_memcpy(), memcpy() benchmark suite.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ling Ma <ling.ma@intel.com>
---
 tools/perf/bench/bench.h |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/tools/perf/bench/bench.h b/tools/perf/bench/bench.h
index 3c64205..f7781c6 100644
--- a/tools/perf/bench/bench.h
+++ b/tools/perf/bench/bench.h
@@ -3,6 +3,7 @@
 
 extern int bench_sched_messaging(int argc, const char **argv, const char *prefix);
 extern int bench_sched_pipe(int argc, const char **argv, const char *prefix);
+extern int bench_mem_memcpy(int argc, const char **argv, const char *prefix __used);
 
 #define BENCH_FORMAT_DEFAULT_STR	"default"
 #define BENCH_FORMAT_DEFAULT		0
@@ -13,13 +14,4 @@ extern int bench_sched_pipe(int argc, const char **argv, const char *prefix);
 
 extern int bench_format;
 
-#define BENCH_FORMAT_DEFAULT_STR "default"
-#define BENCH_FORMAT_DEFAULT 0
-#define BENCH_FORMAT_SIMPLE_STR "simple"
-#define BENCH_FORMAT_SIMPLE 1
-
-#define BENCH_FORMAT_UNKNOWN -1
-
-extern int bench_format;
-
 #endif
-- 
1.6.5.2

