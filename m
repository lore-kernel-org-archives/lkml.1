Return-Path: <linux-kernel-owner+w=401wt.eu-S1757346AbXLFCuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346AbXLFCuh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 21:50:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755387AbXLFCpC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 21:45:02 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:51393 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754838AbXLFCo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 21:44:56 -0500
Message-Id: <20071206024436.205397501@polymtl.ca>
References: <20071206024243.397994403@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 05 Dec 2007 21:43:02 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch-RFC 19/26] LTTng Kernel Trace Thread Flag sparc
Content-Disposition: inline; filename=lttng-kernel-trace-thread-flag-sparc.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu,  6 Dec 2007 02:44:38 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a thread flag to activate system-wide syscall tracing.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/asm-sparc/thread_info.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/include/asm-sparc/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-sparc/thread_info.h	2007-07-30 18:23:47.000000000 -0400
+++ linux-2.6-lttng/include/asm-sparc/thread_info.h	2007-07-30 18:24:06.000000000 -0400
@@ -128,7 +128,7 @@ BTFIXUPDEF_CALL(void, free_thread_info, 
  * thread information flag bit numbers
  */
 #define TIF_SYSCALL_TRACE	0	/* syscall trace active */
-/* flag bit 1 is available */
+#define TIF_KERNEL_TRACE	1	/* kernel trace active */
 #define TIF_SIGPENDING		2	/* signal pending */
 #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
 #define TIF_RESTORE_SIGMASK	4	/* restore signal mask in do_signal() */
@@ -140,6 +140,7 @@ BTFIXUPDEF_CALL(void, free_thread_info, 
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
+#define _TIF_KERNEL_TRACE	(1<<TIF_KERNEL_TRACE)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
