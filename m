Return-Path: <linux-kernel-owner+w=401wt.eu-S1756828AbZCJVG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbZCJVG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 17:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755292AbZCJVFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 17:05:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42021 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942AbZCJVFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 17:05:35 -0400
Message-Id: <20090310210531.940784933@goodmis.org>
References: <20090310210408.419131392@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 10 Mar 2009 17:04:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Larry Woodman <lwoodman@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 7/7] tracing: remove funky whitespace in the trace code
Content-Disposition: inline; filename=0007-tracing-remove-funky-whitespace-in-the-trace-code.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: clean up

There existed a lot of <space><tab>'s in the tracing code. This
patch removes them.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/tracepoint.h           |   16 +++---
 kernel/trace/blktrace.c              |   10 ++--
 kernel/trace/trace.c                 |    2 +-
 kernel/trace/trace_branch.c          |    2 +-
 kernel/trace/trace_events_stage_3.h  |   98 +++++++++++++++++-----------------
 kernel/trace/trace_export.c          |    2 +-
 kernel/trace/trace_functions_graph.c |    6 +-
 kernel/trace/trace_output.c          |   14 +++---
 kernel/trace/trace_workqueue.c       |    6 +-
 9 files changed, 78 insertions(+), 78 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 119ece2..d35a7ee 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -178,8 +178,8 @@ static inline void tracepoint_synchronize_unregister(void)
  *	* prototype, declare it via TP_PROTO():
  *	*
  *
- * 	TP_PROTO(struct rq *rq, struct task_struct *prev,
- * 		 struct task_struct *next),
+ *	TP_PROTO(struct rq *rq, struct task_struct *prev,
+ *		 struct task_struct *next),
  *
  *	*
  *	* Define the call signature of the 'function'.
@@ -187,7 +187,7 @@ static inline void tracepoint_synchronize_unregister(void)
  *	*  TP_PROTO1/TP_PROTO2/TP_PROTO3 ugliness.)
  *	*
  *
- * 	TP_ARGS(rq, prev, next),
+ *	TP_ARGS(rq, prev, next),
  *
  *	*
  *	* Fast binary tracing: define the trace record via
@@ -229,13 +229,13 @@ static inline void tracepoint_synchronize_unregister(void)
  *	* happens, on an active tracepoint.
  *	*
  *
- * 	TP_fast_assign(
- * 		memcpy(__entry->next_comm, next->comm, TASK_COMM_LEN);
- * 		__entry->prev_pid	= prev->pid;
- * 		__entry->prev_prio	= prev->prio;
+ *	TP_fast_assign(
+ *		memcpy(__entry->next_comm, next->comm, TASK_COMM_LEN);
+ *		__entry->prev_pid	= prev->pid;
+ *		__entry->prev_prio	= prev->prio;
  *		memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
  *		__entry->next_pid	= next->pid;
- * 		__entry->next_prio	= next->prio;
+ *		__entry->next_prio	= next->prio;
  *	)
  *
  *	*
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index e39679a..bec69d3 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -33,7 +33,7 @@ static struct trace_array *blk_tr;
 static int __read_mostly  blk_tracer_enabled;
 
 /* Select an alternative, minimalistic output than the original one */
-#define TRACE_BLK_OPT_CLASSIC 	0x1
+#define TRACE_BLK_OPT_CLASSIC	0x1
 
 static struct tracer_opt blk_tracer_opts[] = {
 	/* Default disable the minimalistic output */
@@ -564,7 +564,7 @@ EXPORT_SYMBOL_GPL(blk_trace_startstop);
 /**
  * blk_trace_ioctl: - handle the ioctls associated with tracing
  * @bdev:	the block device
- * @cmd: 	the ioctl cmd
+ * @cmd:	the ioctl cmd
  * @arg:	the argument data, if any
  *
  **/
@@ -1128,9 +1128,9 @@ static void blk_tracer_reset(struct trace_array *tr)
 
 static struct {
 	const char *act[2];
-	int 	   (*print)(struct trace_seq *s, const struct trace_entry *ent);
+	int	   (*print)(struct trace_seq *s, const struct trace_entry *ent);
 } what2act[] __read_mostly = {
-	[__BLK_TA_QUEUE]	= {{  "Q", "queue" }, 	   blk_log_generic },
+	[__BLK_TA_QUEUE]	= {{  "Q", "queue" },	   blk_log_generic },
 	[__BLK_TA_BACKMERGE]	= {{  "M", "backmerge" },  blk_log_generic },
 	[__BLK_TA_FRONTMERGE]	= {{  "F", "frontmerge" }, blk_log_generic },
 	[__BLK_TA_GETRQ]	= {{  "G", "getrq" },	   blk_log_generic },
@@ -1229,7 +1229,7 @@ static struct tracer blk_tracer __read_mostly = {
 };
 
 static struct trace_event trace_blk_event = {
-	.type	 	= TRACE_BLK,
+	.type		= TRACE_BLK,
 	.trace		= blk_trace_event_print,
 	.binary		= blk_trace_event_print_binary,
 };
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index cc94f86..8c6a902 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -799,7 +799,7 @@ tracing_generic_entry_update(struct trace_entry *entry, unsigned long flags,
 
 	entry->preempt_count		= pc & 0xff;
 	entry->pid			= (tsk) ? tsk->pid : 0;
-	entry->tgid               	= (tsk) ? tsk->tgid : 0;
+	entry->tgid			= (tsk) ? tsk->tgid : 0;
 	entry->flags =
 #ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
 		(irqs_disabled_flags(flags) ? TRACE_FLAG_IRQS_OFF : 0) |
diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index aaa0755..ad8c22e 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -157,7 +157,7 @@ static enum print_line_t trace_branch_print(struct trace_iterator *iter,
 
 
 static struct trace_event trace_branch_event = {
-	.type	 	= TRACE_BRANCH,
+	.type		= TRACE_BRANCH,
 	.trace		= trace_branch_print,
 };
 
diff --git a/kernel/trace/trace_events_stage_3.h b/kernel/trace/trace_events_stage_3.h
index 6ee1de5..ae2e323 100644
--- a/kernel/trace/trace_events_stage_3.h
+++ b/kernel/trace/trace_events_stage_3.h
@@ -5,23 +5,23 @@
  *
  * static void ftrace_event_<call>(proto)
  * {
- * 	event_trace_printk(_RET_IP_, "<call>: " <fmt>);
+ *	event_trace_printk(_RET_IP_, "<call>: " <fmt>);
  * }
  *
  * static int ftrace_reg_event_<call>(void)
  * {
- * 	int ret;
+ *	int ret;
  *
- * 	ret = register_trace_<call>(ftrace_event_<call>);
- * 	if (!ret)
- * 		pr_info("event trace: Could not activate trace point "
- * 			"probe to  <call>");
- * 	return ret;
+ *	ret = register_trace_<call>(ftrace_event_<call>);
+ *	if (!ret)
+ *		pr_info("event trace: Could not activate trace point "
+ *			"probe to  <call>");
+ *	return ret;
  * }
  *
  * static void ftrace_unreg_event_<call>(void)
  * {
- * 	unregister_trace_<call>(ftrace_event_<call>);
+ *	unregister_trace_<call>(ftrace_event_<call>);
  * }
  *
  * For those macros defined with TRACE_FORMAT:
@@ -29,9 +29,9 @@
  * static struct ftrace_event_call __used
  * __attribute__((__aligned__(4)))
  * __attribute__((section("_ftrace_events"))) event_<call> = {
- * 	.name 			= "<call>",
- * 	.regfunc		= ftrace_reg_event_<call>,
- * 	.unregfunc		= ftrace_unreg_event_<call>,
+ *	.name			= "<call>",
+ *	.regfunc		= ftrace_reg_event_<call>,
+ *	.unregfunc		= ftrace_unreg_event_<call>,
  * }
  *
  *
@@ -41,66 +41,66 @@
  *
  * static void ftrace_raw_event_<call>(proto)
  * {
- * 	struct ring_buffer_event *event;
- * 	struct ftrace_raw_<call> *entry; <-- defined in stage 1
- * 	unsigned long irq_flags;
- * 	int pc;
- *
- * 	local_save_flags(irq_flags);
- * 	pc = preempt_count();
- *
- * 	event = trace_current_buffer_lock_reserve(event_<call>.id,
- * 				  sizeof(struct ftrace_raw_<call>),
- * 				  irq_flags, pc);
- * 	if (!event)
- * 		return;
- * 	entry	= ring_buffer_event_data(event);
- *
- * 	<assign>;  <-- Here we assign the entries by the __field and
+ *	struct ring_buffer_event *event;
+ *	struct ftrace_raw_<call> *entry; <-- defined in stage 1
+ *	unsigned long irq_flags;
+ *	int pc;
+ *
+ *	local_save_flags(irq_flags);
+ *	pc = preempt_count();
+ *
+ *	event = trace_current_buffer_lock_reserve(event_<call>.id,
+ *				  sizeof(struct ftrace_raw_<call>),
+ *				  irq_flags, pc);
+ *	if (!event)
+ *		return;
+ *	entry	= ring_buffer_event_data(event);
+ *
+ *	<assign>;  <-- Here we assign the entries by the __field and
  *			__array macros.
  *
- * 	trace_current_buffer_unlock_commit(event, irq_flags, pc);
+ *	trace_current_buffer_unlock_commit(event, irq_flags, pc);
  * }
  *
  * static int ftrace_raw_reg_event_<call>(void)
  * {
- * 	int ret;
+ *	int ret;
  *
- * 	ret = register_trace_<call>(ftrace_raw_event_<call>);
- * 	if (!ret)
- * 		pr_info("event trace: Could not activate trace point "
- * 			"probe to <call>");
- * 	return ret;
+ *	ret = register_trace_<call>(ftrace_raw_event_<call>);
+ *	if (!ret)
+ *		pr_info("event trace: Could not activate trace point "
+ *			"probe to <call>");
+ *	return ret;
  * }
  *
  * static void ftrace_unreg_event_<call>(void)
  * {
- * 	unregister_trace_<call>(ftrace_raw_event_<call>);
+ *	unregister_trace_<call>(ftrace_raw_event_<call>);
  * }
  *
  * static struct trace_event ftrace_event_type_<call> = {
- * 	.trace			= ftrace_raw_output_<call>, <-- stage 2
+ *	.trace			= ftrace_raw_output_<call>, <-- stage 2
  * };
  *
  * static int ftrace_raw_init_event_<call>(void)
  * {
- * 	int id;
+ *	int id;
  *
- * 	id = register_ftrace_event(&ftrace_event_type_<call>);
- * 	if (!id)
- * 		return -ENODEV;
- * 	event_<call>.id = id;
- * 	return 0;
+ *	id = register_ftrace_event(&ftrace_event_type_<call>);
+ *	if (!id)
+ *		return -ENODEV;
+ *	event_<call>.id = id;
+ *	return 0;
  * }
  *
  * static struct ftrace_event_call __used
  * __attribute__((__aligned__(4)))
  * __attribute__((section("_ftrace_events"))) event_<call> = {
- * 	.name 			= "<call>",
+ *	.name			= "<call>",
  *	.system			= "<system>",
- * 	.raw_init		= ftrace_raw_init_event_<call>,
- * 	.regfunc		= ftrace_reg_event_<call>,
- * 	.unregfunc		= ftrace_unreg_event_<call>,
+ *	.raw_init		= ftrace_raw_init_event_<call>,
+ *	.regfunc		= ftrace_reg_event_<call>,
+ *	.unregfunc		= ftrace_unreg_event_<call>,
  *	.show_format		= ftrace_format_<call>,
  * }
  *
@@ -138,7 +138,7 @@ _TRACE_FORMAT(call, PARAMS(proto), PARAMS(args), PARAMS(fmt))		\
 static struct ftrace_event_call __used					\
 __attribute__((__aligned__(4)))						\
 __attribute__((section("_ftrace_events"))) event_##call = {		\
-	.name 			= #call,				\
+	.name			= #call,				\
 	.system			= __stringify(TRACE_SYSTEM),		\
 	.regfunc		= ftrace_reg_event_##call,		\
 	.unregfunc		= ftrace_unreg_event_##call,		\
@@ -163,7 +163,7 @@ static void ftrace_raw_event_##call(proto)				\
 	pc = preempt_count();						\
 									\
 	event = trace_current_buffer_lock_reserve(event_##call.id,	\
-				  sizeof(struct ftrace_raw_##call), 	\
+				  sizeof(struct ftrace_raw_##call),	\
 				  irq_flags, pc);			\
 	if (!event)							\
 		return;							\
@@ -208,7 +208,7 @@ static int ftrace_raw_init_event_##call(void)				\
 static struct ftrace_event_call __used					\
 __attribute__((__aligned__(4)))						\
 __attribute__((section("_ftrace_events"))) event_##call = {		\
-	.name 			= #call,				\
+	.name			= #call,				\
 	.system			= __stringify(TRACE_SYSTEM),		\
 	.raw_init		= ftrace_raw_init_event_##call,		\
 	.regfunc		= ftrace_raw_reg_event_##call,		\
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 23ae784..4d9952d 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -94,7 +94,7 @@ ftrace_format_##call(struct trace_seq *s)				\
 static struct ftrace_event_call __used					\
 __attribute__((__aligned__(4)))						\
 __attribute__((section("_ftrace_events"))) event_##call = {		\
-	.name 			= #call,				\
+	.name			= #call,				\
 	.id			= proto,				\
 	.system			= __stringify(TRACE_SYSTEM),		\
 	.show_format		= ftrace_format_##call,			\
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 453ebd3..d1493b8 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -841,12 +841,12 @@ static void graph_trace_close(struct trace_iterator *iter)
 }
 
 static struct tracer graph_trace __read_mostly = {
-	.name	     	= "function_graph",
+	.name		= "function_graph",
 	.open		= graph_trace_open,
 	.close		= graph_trace_close,
 	.wait_pipe	= poll_wait_pipe,
-	.init	     	= graph_trace_init,
-	.reset	     	= graph_trace_reset,
+	.init		= graph_trace_init,
+	.reset		= graph_trace_reset,
 	.print_line	= print_graph_function,
 	.print_header	= print_graph_headers,
 	.flags		= &tracer_flags,
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index ef8fd66..491832a 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -565,7 +565,7 @@ static enum print_line_t trace_fn_bin(struct trace_iterator *iter, int flags)
 }
 
 static struct trace_event trace_fn_event = {
-	.type	 	= TRACE_FN,
+	.type		= TRACE_FN,
 	.trace		= trace_fn_trace,
 	.raw		= trace_fn_raw,
 	.hex		= trace_fn_hex,
@@ -696,7 +696,7 @@ static enum print_line_t trace_ctxwake_bin(struct trace_iterator *iter,
 }
 
 static struct trace_event trace_ctx_event = {
-	.type	 	= TRACE_CTX,
+	.type		= TRACE_CTX,
 	.trace		= trace_ctx_print,
 	.raw		= trace_ctx_raw,
 	.hex		= trace_ctx_hex,
@@ -704,7 +704,7 @@ static struct trace_event trace_ctx_event = {
 };
 
 static struct trace_event trace_wake_event = {
-	.type	 	= TRACE_WAKE,
+	.type		= TRACE_WAKE,
 	.trace		= trace_wake_print,
 	.raw		= trace_wake_raw,
 	.hex		= trace_wake_hex,
@@ -759,7 +759,7 @@ static enum print_line_t trace_special_bin(struct trace_iterator *iter,
 }
 
 static struct trace_event trace_special_event = {
-	.type	 	= TRACE_SPECIAL,
+	.type		= TRACE_SPECIAL,
 	.trace		= trace_special_print,
 	.raw		= trace_special_print,
 	.hex		= trace_special_hex,
@@ -796,7 +796,7 @@ static enum print_line_t trace_stack_print(struct trace_iterator *iter,
 }
 
 static struct trace_event trace_stack_event = {
-	.type	 	= TRACE_STACK,
+	.type		= TRACE_STACK,
 	.trace		= trace_stack_print,
 	.raw		= trace_special_print,
 	.hex		= trace_special_hex,
@@ -825,7 +825,7 @@ static enum print_line_t trace_user_stack_print(struct trace_iterator *iter,
 }
 
 static struct trace_event trace_user_stack_event = {
-	.type	 	= TRACE_USER_STACK,
+	.type		= TRACE_USER_STACK,
 	.trace		= trace_user_stack_print,
 	.raw		= trace_special_print,
 	.hex		= trace_special_hex,
@@ -879,7 +879,7 @@ static enum print_line_t trace_print_raw(struct trace_iterator *iter, int flags)
 
 
 static struct trace_event trace_print_event = {
-	.type	 	= TRACE_PRINT,
+	.type		= TRACE_PRINT,
 	.trace		= trace_print_print,
 	.raw		= trace_print_raw,
 };
diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
index 4664990..e542483 100644
--- a/kernel/trace/trace_workqueue.c
+++ b/kernel/trace/trace_workqueue.c
@@ -19,14 +19,14 @@ struct cpu_workqueue_stats {
 /* Useful to know if we print the cpu headers */
 	bool		            first_entry;
 	int		            cpu;
-	pid_t 			    pid;
+	pid_t			    pid;
 /* Can be inserted from interrupt or user context, need to be atomic */
-	atomic_t 	            inserted;
+	atomic_t	            inserted;
 /*
  *  Don't need to be atomic, works are serialized in a single workqueue thread
  *  on a single CPU.
  */
-	unsigned int 	 	    executed;
+	unsigned int		    executed;
 };
 
 /* List of workqueue threads on one cpu */
-- 
1.6.1.3

-- 
