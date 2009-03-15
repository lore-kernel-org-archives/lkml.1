Return-Path: <linux-kernel-owner+w=401wt.eu-S1759747AbZCOTe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759747AbZCOTe3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 15:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756097AbZCOTbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 15:31:53 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:56474 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758260AbZCOTbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 15:31:52 -0400
Message-Id: <20090315191102.623800671@polymtl.ca>
References: <20090315190340.229569867@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 15 Mar 2009 15:03:42 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC patch 02/21] LTTng Kernel Trace Thread Flag ARM
Content-Disposition: inline; filename=lttng-kernel-trace-thread-flag-arm.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Sun, 15 Mar 2009 19:30:27 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a thread flag to activate system-wide syscall tracing.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/arm/include/asm/thread_info.h |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6-lttng/arch/arm/include/asm/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/arch/arm/include/asm/thread_info.h	2009-01-09 18:15:55.000000000 -0500
+++ linux-2.6-lttng/arch/arm/include/asm/thread_info.h	2009-01-09 18:17:45.000000000 -0500
@@ -124,6 +124,7 @@ extern void iwmmxt_task_switch(struct th
 /*
  * thread information flags:
  *  TIF_SYSCALL_TRACE	- syscall trace active
+ *  TIF_KERNEL_TRACE	- kernel trace active
  *  TIF_SIGPENDING	- signal pending
  *  TIF_NEED_RESCHED	- rescheduling necessary
  *  TIF_USEDFPU		- FPU was used by this task this quantum (SMP)
@@ -131,6 +132,7 @@ extern void iwmmxt_task_switch(struct th
  */
 #define TIF_SIGPENDING		0
 #define TIF_NEED_RESCHED	1
+#define TIF_KERNEL_TRACE	7
 #define TIF_SYSCALL_TRACE	8
 #define TIF_POLLING_NRFLAG	16
 #define TIF_USING_IWMMXT	17
@@ -139,6 +141,7 @@ extern void iwmmxt_task_switch(struct th
 
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
+#define _TIF_KERNEL_TRACE	(1 << TIF_KERNEL_TRACE)
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 #define _TIF_USING_IWMMXT	(1 << TIF_USING_IWMMXT)

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
