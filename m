Return-Path: <linux-kernel-owner+w=401wt.eu-S1756608AbZKJNZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608AbZKJNZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 08:25:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756320AbZKJNZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 08:25:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:34280 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbZKJNZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 08:25:51 -0500
Date: Tue, 10 Nov 2009 13:25:10 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, mitake@dcl.info.waseda.ac.jp,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       mitake@dcl.info.waseda.ac.jp, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1257853855-28934-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1257853855-28934-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/bench] perf bench: Clean up bench/bench.h
Message-ID: <tip-606bc1e18d346fc7d7fb333909cc95b06b1ca5b1@git.kernel.org>
Git-Commit-ID: 606bc1e18d346fc7d7fb333909cc95b06b1ca5b1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  606bc1e18d346fc7d7fb333909cc95b06b1ca5b1
Gitweb:     http://git.kernel.org/tip/606bc1e18d346fc7d7fb333909cc95b06b1ca5b1
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 10 Nov 2009 20:50:53 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 10 Nov 2009 14:14:35 +0100

perf bench: Clean up bench/bench.h

Clean up initializers in bench.h:

  - No need to break the line for function prototypes, they are more
    readable in a single line. (even if checkpatch complains about it

  - We try to align definitions / structure fields vertically,
    to make it  all a bit more readable.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1257853855-28934-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
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
 
