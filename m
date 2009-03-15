Return-Path: <linux-kernel-owner+w=401wt.eu-S1759672AbZCOTh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759672AbZCOTh1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 15:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758256AbZCOTcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 15:32:06 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:56506 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758315AbZCOTcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 15:32:00 -0400
Message-Id: <20090315191104.799313096@polymtl.ca>
References: <20090315190340.229569867@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 15 Mar 2009 15:03:56 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC patch 16/21] LTTng Kernel Trace Thread Flag sparc
Content-Disposition: inline; filename=lttng-kernel-trace-thread-flag-sparc.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Sun, 15 Mar 2009 19:30:29 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a thread flag to activate system-wide syscall tracing.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/sparc/include/asm/thread_info_32.h |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6-lttng/arch/sparc/include/asm/thread_info_32.h
===================================================================
--- linux-2.6-lttng.orig/arch/sparc/include/asm/thread_info_32.h	2009-01-09 18:15:54.000000000 -0500
+++ linux-2.6-lttng/arch/sparc/include/asm/thread_info_32.h	2009-01-09 18:17:48.000000000 -0500
@@ -130,6 +130,7 @@ BTFIXUPDEF_CALL(void, free_thread_info, 
 #define TIF_SIGPENDING		2	/* signal pending */
 #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
 #define TIF_RESTORE_SIGMASK	4	/* restore signal mask in do_signal() */
+#define TIF_KERNEL_TRACE	5	/* kernel trace active */
 #define TIF_USEDFPU		8	/* FPU was used by this task
 					 * this quantum (SMP) */
 #define TIF_POLLING_NRFLAG	9	/* true if poll_idle() is polling
@@ -139,6 +140,7 @@ BTFIXUPDEF_CALL(void, free_thread_info, 
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
+#define _TIF_KERNEL_TRACE	(1<<TIF_KERNEL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
