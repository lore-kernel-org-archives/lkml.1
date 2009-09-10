Return-Path: <linux-kernel-owner+w=401wt.eu-S1751397AbZIJENM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397AbZIJENM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 00:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbZIJENB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 00:13:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41359 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbZIJEM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 00:12:58 -0400
Message-Id: <20090910041301.312931444@goodmis.org>
References: <20090910041219.149954890@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 10 Sep 2009 00:12:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 4/6] tracing: format clean ups
Content-Disposition: inline; filename=0004-tracing-format-clean-ups.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

Fix white-space formatting.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4AA8579B.4020706@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 536ae1d..86a0523 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -169,20 +169,20 @@ enum kmemtrace_type_id {
 
 struct kmemtrace_alloc_entry {
 	struct trace_entry	ent;
-	enum kmemtrace_type_id type_id;
-	unsigned long call_site;
-	const void *ptr;
-	size_t bytes_req;
-	size_t bytes_alloc;
-	gfp_t gfp_flags;
-	int node;
+	enum kmemtrace_type_id	type_id;
+	unsigned long		call_site;
+	const void		*ptr;
+	size_t			bytes_req;
+	size_t			bytes_alloc;
+	gfp_t			gfp_flags;
+	int			node;
 };
 
 struct kmemtrace_free_entry {
 	struct trace_entry	ent;
-	enum kmemtrace_type_id type_id;
-	unsigned long call_site;
-	const void *ptr;
+	enum kmemtrace_type_id	type_id;
+	unsigned long		call_site;
+	const void		*ptr;
 };
 
 struct syscall_trace_enter {
@@ -203,7 +203,7 @@ struct syscall_trace_exit {
  * states when a trace occurs. These are:
  *  IRQS_OFF		- interrupts were disabled
  *  IRQS_NOSUPPORT	- arch does not support irqs_disabled_flags
- *  NEED_RESCED		- reschedule is requested
+ *  NEED_RESCHED	- reschedule is requested
  *  HARDIRQ		- inside an interrupt handler
  *  SOFTIRQ		- inside a softirq handler
  */
-- 
1.6.3.3

-- 
