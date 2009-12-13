Return-Path: <linux-kernel-owner+w=401wt.eu-S1753250AbZLMNLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbZLMNLL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 08:11:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbZLMNKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 08:10:48 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:4994 "HELO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753086AbZLMNIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 08:08:36 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Jason Baron <jbaron@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 09/13] tracing: Remove useless trace option
Date: Sun, 13 Dec 2009 14:08:10 +0100
Message-Id: <1260709694-5166-10-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1260709694-5166-1-git-send-regression-fweisbec@gmail.com>
References: <1260709694-5166-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

Since commit 4d9493c90f8e6e1b164aede3814010a290161abb
("ftrace: remove add-hoc code"), option "sched-tree"
has become useless.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <4B1DC50A.7040402@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace.c |    1 -
 kernel/trace/trace.h |   23 +++++++++++------------
 2 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 886268e..898409d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -313,7 +313,6 @@ static const char *trace_options[] = {
 	"bin",
 	"block",
 	"stacktrace",
-	"sched-tree",
 	"trace_printk",
 	"ftrace_preempt",
 	"branch",
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 7fa33ca..1b18cb2 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -597,18 +597,17 @@ enum trace_iterator_flags {
 	TRACE_ITER_BIN			= 0x40,
 	TRACE_ITER_BLOCK		= 0x80,
 	TRACE_ITER_STACKTRACE		= 0x100,
-	TRACE_ITER_SCHED_TREE		= 0x200,
-	TRACE_ITER_PRINTK		= 0x400,
-	TRACE_ITER_PREEMPTONLY		= 0x800,
-	TRACE_ITER_BRANCH		= 0x1000,
-	TRACE_ITER_ANNOTATE		= 0x2000,
-	TRACE_ITER_USERSTACKTRACE       = 0x4000,
-	TRACE_ITER_SYM_USEROBJ          = 0x8000,
-	TRACE_ITER_PRINTK_MSGONLY	= 0x10000,
-	TRACE_ITER_CONTEXT_INFO		= 0x20000, /* Print pid/cpu/time */
-	TRACE_ITER_LATENCY_FMT		= 0x40000,
-	TRACE_ITER_SLEEP_TIME		= 0x80000,
-	TRACE_ITER_GRAPH_TIME		= 0x100000,
+	TRACE_ITER_PRINTK		= 0x200,
+	TRACE_ITER_PREEMPTONLY		= 0x400,
+	TRACE_ITER_BRANCH		= 0x800,
+	TRACE_ITER_ANNOTATE		= 0x1000,
+	TRACE_ITER_USERSTACKTRACE       = 0x2000,
+	TRACE_ITER_SYM_USEROBJ          = 0x4000,
+	TRACE_ITER_PRINTK_MSGONLY	= 0x8000,
+	TRACE_ITER_CONTEXT_INFO		= 0x10000, /* Print pid/cpu/time */
+	TRACE_ITER_LATENCY_FMT		= 0x20000,
+	TRACE_ITER_SLEEP_TIME		= 0x40000,
+	TRACE_ITER_GRAPH_TIME		= 0x80000,
 };
 
 /*
-- 
1.6.2.3

