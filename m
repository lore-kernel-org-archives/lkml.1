Return-Path: <linux-kernel-owner+w=401wt.eu-S1757432AbXLFCux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432AbXLFCux (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 21:50:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754757AbXLFCpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 21:45:06 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:51398 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754859AbXLFCo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 21:44:56 -0500
Message-Id: <20071206024433.325408444@polymtl.ca>
References: <20071206024243.397994403@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 05 Dec 2007 21:42:55 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch-RFC 12/26] LTTng Kernel Trace Thread Flag m68knommu
Content-Disposition: inline; filename=lttng-kernel-trace-thread-flag-m68knommu.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu,  6 Dec 2007 02:44:35 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a thread flag to activate system-wide syscall tracing.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/asm-m68knommu/thread_info.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/include/asm-m68knommu/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-m68knommu/thread_info.h	2007-07-30 18:49:42.000000000 -0400
+++ linux-2.6-lttng/include/asm-m68knommu/thread_info.h	2007-07-30 19:08:02.000000000 -0400
@@ -88,14 +88,16 @@ static inline struct thread_info *curren
 #define TIF_POLLING_NRFLAG	3	/* true if poll_idle() is polling
 					   TIF_NEED_RESCHED */
 #define TIF_MEMDIE		4
+#define TIF_KERNEL_TRACE	5	/* kernel trace active */
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
+#define _TIF_KERNEL_TRACE	(1<<TIF_KERNEL_TRACE)
 
-#define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
+#define _TIF_WORK_MASK		0x0000FFDE	/* work to do on interrupt/exception return */
 
 #endif /* __KERNEL__ */
 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
