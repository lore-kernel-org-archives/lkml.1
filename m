Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbXLFCrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbXLFCrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 21:47:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754686AbXLFCow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 21:44:52 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:51327 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753750AbXLFCor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 21:44:47 -0500
Message-Id: <20071206024429.343302013@polymtl.ca>
References: <20071206024243.397994403@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 05 Dec 2007 21:42:45 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch-RFC 02/26] LTTng Kernel Trace Thread Flag ARM
Content-Disposition: inline; filename=lttng-kernel-trace-thread-flag-arm.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu,  6 Dec 2007 02:44:32 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a thread flag to activate system-wide syscall tracing.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/asm-arm/thread_info.h |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6-lttng/include/asm-arm/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-arm/thread_info.h	2007-09-04 11:50:11.000000000 -0400
+++ linux-2.6-lttng/include/asm-arm/thread_info.h	2007-09-04 12:19:51.000000000 -0400
@@ -134,6 +134,7 @@ extern void iwmmxt_task_switch(struct th
 /*
  * thread information flags:
  *  TIF_SYSCALL_TRACE	- syscall trace active
+ *  TIF_KERNEL_TRACE	- kernel trace active
  *  TIF_SIGPENDING	- signal pending
  *  TIF_NEED_RESCHED	- rescheduling necessary
  *  TIF_USEDFPU		- FPU was used by this task this quantum (SMP)
@@ -141,6 +142,7 @@ extern void iwmmxt_task_switch(struct th
  */
 #define TIF_SIGPENDING		0
 #define TIF_NEED_RESCHED	1
+#define TIF_KERNEL_TRACE	7
 #define TIF_SYSCALL_TRACE	8
 #define TIF_POLLING_NRFLAG	16
 #define TIF_USING_IWMMXT	17
@@ -149,6 +151,7 @@ extern void iwmmxt_task_switch(struct th
 
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
+#define _TIF_KERNEL_TRACE	(1 << TIF_KERNEL_TRACE)
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 #define _TIF_USING_IWMMXT	(1 << TIF_USING_IWMMXT)

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
