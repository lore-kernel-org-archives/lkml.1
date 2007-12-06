Return-Path: <linux-kernel-owner+w=401wt.eu-S1757532AbXLFCwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532AbXLFCwK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 21:52:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754498AbXLFCpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 21:45:13 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:51413 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755304AbXLFCpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 21:45:00 -0500
Message-Id: <20071206024432.913866502@polymtl.ca>
References: <20071206024243.397994403@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 05 Dec 2007 21:42:54 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch-RFC 11/26] LTTng Kernel Trace Thread Flag m68k
Content-Disposition: inline; filename=lttng-kernel-trace-thread-flag-m68k.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu,  6 Dec 2007 02:44:35 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a thread flag to activate system-wide syscall tracing.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/asm-m68k/thread_info.h |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6-lttng/include/asm-m68k/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-m68k/thread_info.h	2007-07-30 18:14:49.000000000 -0400
+++ linux-2.6-lttng/include/asm-m68k/thread_info.h	2007-07-30 18:15:23.000000000 -0400
@@ -55,6 +55,7 @@ struct thread_info {
  */
 #define TIF_SIGPENDING		6	/* signal pending */
 #define TIF_NEED_RESCHED	7	/* rescheduling necessary */
+#define TIF_KERNEL_TRACE	13	/* kernel trace active */
 #define TIF_DELAYED_TRACE	14	/* single step a syscall */
 #define TIF_SYSCALL_TRACE	15	/* syscall trace active */
 #define TIF_MEMDIE		16

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
