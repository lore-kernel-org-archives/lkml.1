Return-Path: <linux-kernel-owner+w=401wt.eu-S1757320AbXLFCtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320AbXLFCtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 21:49:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755002AbXLFCo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 21:44:58 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:51371 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754757AbXLFCoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 21:44:54 -0500
Message-Id: <20071206024435.793707222@polymtl.ca>
References: <20071206024243.397994403@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 05 Dec 2007 21:43:01 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch-RFC 18/26] LTTng Kernel Trace Thread Flag sh64
Content-Disposition: inline; filename=lttng-kernel-trace-thread-flag-sh64.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu,  6 Dec 2007 02:44:38 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a thread flag to activate system-wide syscall tracing.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/asm-sh64/thread_info.h |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6-lttng/include/asm-sh64/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-sh64/thread_info.h	2007-07-30 18:23:10.000000000 -0400
+++ linux-2.6-lttng/include/asm-sh64/thread_info.h	2007-07-30 18:23:34.000000000 -0400
@@ -75,11 +75,13 @@ static inline struct thread_info *curren
 
 /* thread information flags */
 #define TIF_SYSCALL_TRACE	0	/* syscall trace active */
+#define TIF_KERNEL_TRACE	1	/* kernel trace active */
 #define TIF_SIGPENDING		2	/* signal pending */
 #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
 #define TIF_MEMDIE		4
 #define TIF_RESTORE_SIGMASK	5	/* Restore signal mask in do_signal */
 
+#define _TIF_KERNEL_TRACE	(1 << TIF_KERNEL_TRACE)
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
