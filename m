Return-Path: <linux-kernel-owner+w=401wt.eu-S1758267AbZCOThw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267AbZCOThw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 15:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758384AbZCOTcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 15:32:07 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:56507 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758406AbZCOTcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 15:32:01 -0400
Message-Id: <20090315191104.955718658@polymtl.ca>
References: <20090315190340.229569867@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 15 Mar 2009 15:03:57 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC patch 17/21] LTTng Kernel Trace Thread Flag sparc64
Content-Disposition: inline; filename=lttng-kernel-trace-thread-flag-sparc64.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Sun, 15 Mar 2009 19:30:29 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a thread flag to activate system-wide syscall tracing.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/sparc/include/asm/thread_info_64.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/arch/sparc/include/asm/thread_info_64.h
===================================================================
--- linux-2.6-lttng.orig/arch/sparc/include/asm/thread_info_64.h	2009-01-09 18:15:54.000000000 -0500
+++ linux-2.6-lttng/arch/sparc/include/asm/thread_info_64.h	2009-01-09 18:17:49.000000000 -0500
@@ -226,7 +226,7 @@ register struct thread_info *current_thr
 #define TIF_UNALIGNED		5	/* allowed to do unaligned accesses */
 /* flag bit 6 is available */
 #define TIF_32BIT		7	/* 32-bit binary */
-/* flag bit 8 is available */
+#define TIF_KERNEL_TRACE	8	/* kernel trace active */
 #define TIF_SECCOMP		9	/* secure computing */
 #define TIF_SYSCALL_AUDIT	10	/* syscall auditing active */
 /* flag bit 11 is available */
@@ -246,6 +246,7 @@ register struct thread_info *current_thr
 #define _TIF_PERFCTR		(1<<TIF_PERFCTR)
 #define _TIF_UNALIGNED		(1<<TIF_UNALIGNED)
 #define _TIF_32BIT		(1<<TIF_32BIT)
+#define _TIF_KERNEL_TRACE	(1<<TIF_KERNEL_TRACE)
 #define _TIF_SECCOMP		(1<<TIF_SECCOMP)
 #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
 #define _TIF_ABI_PENDING	(1<<TIF_ABI_PENDING)

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
