Return-Path: <linux-kernel-owner+w=401wt.eu-S1756941AbXLFCvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941AbXLFCvt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 21:51:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbXLFCpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 21:45:11 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:51401 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754932AbXLFCo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 21:44:57 -0500
Message-Id: <20071206024434.966107023@polymtl.ca>
References: <20071206024243.397994403@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 05 Dec 2007 21:42:59 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch-RFC 16/26] LTTng Kernel Trace Thread Flag s390
Content-Disposition: inline; filename=lttng-kernel-trace-thread-flag-s390.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu,  6 Dec 2007 02:44:37 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a thread flag to activate system-wide syscall tracing.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/s390/kernel/entry.S       |    5 ++++-
 include/asm-s390/thread_info.h |    2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/include/asm-s390/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-s390/thread_info.h	2007-11-20 13:10:50.000000000 -0500
+++ linux-2.6-lttng/include/asm-s390/thread_info.h	2007-11-20 13:12:20.000000000 -0500
@@ -96,6 +96,7 @@
 #define TIF_SYSCALL_AUDIT	5	/* syscall auditing active */
 #define TIF_SINGLE_STEP		6	/* deliver sigtrap on return to user */
 #define TIF_MCCK_PENDING	7	/* machine check handling is pending */
+#define TIF_KERNEL_TRACE	8	/* kernel trace active */
 #define TIF_USEDFPU		16	/* FPU was used by this task this quantum (SMP) */
 #define TIF_POLLING_NRFLAG	17	/* true if poll_idle() is polling 
 					   TIF_NEED_RESCHED */
@@ -110,6 +111,7 @@
 #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
 #define _TIF_SINGLE_STEP	(1<<TIF_SINGLE_STEP)
 #define _TIF_MCCK_PENDING	(1<<TIF_MCCK_PENDING)
+#define _TIF_KERNEL_TRACE	(1<<TIF_KERNEL_TRACE)
 #define _TIF_USEDFPU		(1<<TIF_USEDFPU)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_31BIT		(1<<TIF_31BIT)

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
