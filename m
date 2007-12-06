Return-Path: <linux-kernel-owner+w=401wt.eu-S1757578AbXLFCvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578AbXLFCvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 21:51:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754128AbXLFCpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 21:45:09 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:51402 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754939AbXLFCo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 21:44:58 -0500
Message-Id: <20071206024434.106144232@polymtl.ca>
References: <20071206024243.397994403@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 05 Dec 2007 21:42:57 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch-RFC 14/26] LTTng Kernel Trace Thread Flag parisc
Content-Disposition: inline; filename=lttng-kernel-trace-thread-flag-parisc.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu,  6 Dec 2007 02:44:36 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a thread flag to activate system-wide syscall tracing.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/asm-parisc/thread_info.h |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6-lttng/include/asm-parisc/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-parisc/thread_info.h	2007-07-30 18:18:19.000000000 -0400
+++ linux-2.6-lttng/include/asm-parisc/thread_info.h	2007-07-30 18:18:48.000000000 -0400
@@ -62,6 +62,7 @@ struct thread_info {
 #define TIF_32BIT               4       /* 32 bit binary */
 #define TIF_MEMDIE		5
 #define TIF_RESTORE_SIGMASK	6	/* restore saved signal mask */
+#define TIF_KERNEL_TRACE	7	/* kernel trace active */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
@@ -69,6 +70,7 @@ struct thread_info {
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 #define _TIF_32BIT		(1 << TIF_32BIT)
 #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
+#define _TIF_KERNEL_TRACE	(1 << TIF_KERNEL_TRACE)
 
 #define _TIF_USER_WORK_MASK     (_TIF_SIGPENDING | \
                                  _TIF_NEED_RESCHED | _TIF_RESTORE_SIGMASK)

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
