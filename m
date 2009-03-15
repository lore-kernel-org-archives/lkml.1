Return-Path: <linux-kernel-owner+w=401wt.eu-S1760456AbZCOTie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760456AbZCOTie (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 15:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758350AbZCOTcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 15:32:08 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:56514 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757463AbZCOTcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 15:32:03 -0400
Message-Id: <20090315191104.491335172@polymtl.ca>
References: <20090315190340.229569867@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 15 Mar 2009 15:03:54 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC patch 14/21] LTTng Kernel Trace Thread Flag s390
Content-Disposition: inline; filename=lttng-kernel-trace-thread-flag-s390.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Sun, 15 Mar 2009 19:30:29 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a thread flag to activate system-wide syscall tracing.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/s390/include/asm/thread_info.h |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6-lttng/arch/s390/include/asm/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/arch/s390/include/asm/thread_info.h	2009-01-09 18:15:55.000000000 -0500
+++ linux-2.6-lttng/arch/s390/include/asm/thread_info.h	2009-01-09 18:17:48.000000000 -0500
@@ -88,6 +88,7 @@ static inline struct thread_info *curren
 #define TIF_SYSCALL_AUDIT	5	/* syscall auditing active */
 #define TIF_SINGLE_STEP		6	/* deliver sigtrap on return to user */
 #define TIF_MCCK_PENDING	7	/* machine check handling is pending */
+#define TIF_KERNEL_TRACE	8	/* kernel trace active */
 #define TIF_USEDFPU		16	/* FPU was used by this task this quantum (SMP) */
 #define TIF_POLLING_NRFLAG	17	/* true if poll_idle() is polling 
 					   TIF_NEED_RESCHED */
@@ -105,6 +106,7 @@ static inline struct thread_info *curren
 #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
 #define _TIF_SINGLE_STEP	(1<<TIF_SINGLE_STEP)
 #define _TIF_MCCK_PENDING	(1<<TIF_MCCK_PENDING)
+#define _TIF_KERNEL_TRACE	(1<<TIF_KERNEL_TRACE)
 #define _TIF_USEDFPU		(1<<TIF_USEDFPU)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_31BIT		(1<<TIF_31BIT)

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
