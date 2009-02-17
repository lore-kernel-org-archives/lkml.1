Return-Path: <linux-kernel-owner+w=401wt.eu-S1755223AbZBQSWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbZBQSWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 13:22:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754542AbZBQSVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 13:21:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:55018 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282AbZBQSV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 13:21:27 -0500
Message-Id: <20090217182125.998109373@goodmis.org>
References: <20090217182048.233060814@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 17 Feb 2009 13:20:53 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Wenji Huang <wenji.huang@oracle.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 5/6] tracing: fix typing mistake in hint message and comments
Content-Disposition: inline; filename=0005-tracing-fix-typing-mistake-in-hint-message-and-comm.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wenji Huang <wenji.huang@oracle.com>

Impact: cleanup

Fix incorrect hint message in code and typos in comments.

Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_irqsoff.c      |    2 +-
 kernel/trace/trace_sched_switch.c |    2 +-
 kernel/trace/trace_sched_wakeup.c |    2 +-
 kernel/trace/trace_selftest.c     |    4 ++--
 kernel/trace/trace_stat.c         |    2 +-
 kernel/trace/trace_sysprof.c      |    2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index c6b442d..9e5ebd8 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -1,5 +1,5 @@
 /*
- * trace irqs off criticall timings
+ * trace irqs off critical timings
  *
  * Copyright (C) 2007-2008 Steven Rostedt <srostedt@redhat.com>
  * Copyright (C) 2008 Ingo Molnar <mingo@redhat.com>
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index 30e14fe..82fbb5a 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -93,7 +93,7 @@ static int tracing_sched_register(void)
 	ret = register_trace_sched_switch(probe_sched_switch);
 	if (ret) {
 		pr_info("sched trace: Couldn't activate tracepoint"
-			" probe to kernel_sched_schedule\n");
+			" probe to kernel_sched_switch\n");
 		goto fail_deprobe_wake_new;
 	}
 
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 96d7164..276c51a 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -284,7 +284,7 @@ static void start_wakeup_tracer(struct trace_array *tr)
 	ret = register_trace_sched_switch(probe_wakeup_sched_switch);
 	if (ret) {
 		pr_info("sched trace: Couldn't activate tracepoint"
-			" probe to kernel_sched_schedule\n");
+			" probe to kernel_sched_switch\n");
 		goto fail_deprobe_wake_new;
 	}
 
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index c72e749..01415f4 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -107,9 +107,9 @@ int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
 	func();
 
 	/*
-	 * Some archs *cough*PowerPC*cough* add charachters to the
+	 * Some archs *cough*PowerPC*cough* add characters to the
 	 * start of the function names. We simply put a '*' to
-	 * accomodate them.
+	 * accommodate them.
 	 */
 	func_name = "*" STR(DYN_FTRACE_TEST_NAME);
 
diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
index eae9cef..39310e3 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -30,7 +30,7 @@ struct tracer_stat_session {
 	struct dentry		*file;
 };
 
-/* All of the sessions currently in use. Each stat file embeed one session */
+/* All of the sessions currently in use. Each stat file embed one session */
 static LIST_HEAD(all_stat_sessions);
 static DEFINE_MUTEX(all_stat_sessions_mutex);
 
diff --git a/kernel/trace/trace_sysprof.c b/kernel/trace/trace_sysprof.c
index 7c9a2d8..c771af4 100644
--- a/kernel/trace/trace_sysprof.c
+++ b/kernel/trace/trace_sysprof.c
@@ -327,5 +327,5 @@ void init_tracer_sysprof_debugfs(struct dentry *d_tracer)
 			d_tracer, NULL, &sysprof_sample_fops);
 	if (entry)
 		return;
-	pr_warning("Could not create debugfs 'dyn_ftrace_total_info' entry\n");
+	pr_warning("Could not create debugfs 'sysprof_sample_period' entry\n");
 }
-- 
1.5.6.5

-- 
