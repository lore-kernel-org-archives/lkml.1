Return-Path: <linux-kernel-owner+w=401wt.eu-S1754993AbXLFCo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993AbXLFCo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 21:44:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbXLFCop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 21:44:45 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:51310 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751761AbXLFCoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 21:44:44 -0500
Message-Id: <20071206024436.609525950@polymtl.ca>
References: <20071206024243.397994403@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 05 Dec 2007 21:43:03 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch-RFC 20/26] LTTng Kernel Trace Thread Flag sparc64
Content-Disposition: inline; filename=lttng-kernel-trace-thread-flag-sparc64.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu,  6 Dec 2007 02:44:39 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a thread flag to activate system-wide syscall tracing.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/asm-sparc64/thread_info.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/include/asm-sparc64/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-sparc64/thread_info.h	2007-07-30 18:24:15.000000000 -0400
+++ linux-2.6-lttng/include/asm-sparc64/thread_info.h	2007-07-30 18:25:43.000000000 -0400
@@ -225,7 +225,7 @@ register struct thread_info *current_thr
 #define TIF_UNALIGNED		5	/* allowed to do unaligned accesses */
 #define TIF_NEWSIGNALS		6	/* wants new-style signals */
 #define TIF_32BIT		7	/* 32-bit binary */
-/* flag bit 8 is available */
+#define TIF_KERNEL_TRACE	8	/* kernel trace active */
 #define TIF_SECCOMP		9	/* secure computing */
 #define TIF_SYSCALL_AUDIT	10	/* syscall auditing active */
 /* flag bit 11 is available */
@@ -244,6 +244,7 @@ register struct thread_info *current_thr
 #define _TIF_UNALIGNED		(1<<TIF_UNALIGNED)
 #define _TIF_NEWSIGNALS		(1<<TIF_NEWSIGNALS)
 #define _TIF_32BIT		(1<<TIF_32BIT)
+#define _TIF_KERNEL_TRACE	(1<<TIF_KERNEL_TRACE)
 #define _TIF_SECCOMP		(1<<TIF_SECCOMP)
 #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
