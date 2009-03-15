Return-Path: <linux-kernel-owner+w=401wt.eu-S1760193AbZCOTgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760193AbZCOTgz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 15:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758297AbZCOTcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 15:32:05 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:56505 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758281AbZCOTcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 15:32:00 -0400
Message-Id: <20090315191105.111672415@polymtl.ca>
References: <20090315190340.229569867@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 15 Mar 2009 15:03:58 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC patch 18/21] LTTng Kernel Trace Thread Flag UML
Content-Disposition: inline; filename=lttng-kernel-trace-thread-flag-um.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Sun, 15 Mar 2009 19:30:29 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a thread flag to activate system-wide syscall tracing.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/um/include/asm/thread_info.h |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6-lttng/arch/um/include/asm/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/arch/um/include/asm/thread_info.h	2009-01-09 18:15:54.000000000 -0500
+++ linux-2.6-lttng/arch/um/include/asm/thread_info.h	2009-01-09 18:17:49.000000000 -0500
@@ -69,6 +69,7 @@ static inline struct thread_info *curren
 #define TIF_MEMDIE	 	5
 #define TIF_SYSCALL_AUDIT	6
 #define TIF_RESTORE_SIGMASK	7
+#define TIF_KERNEL_TRACE	8	/* kernel trace active */
 #define TIF_FREEZE		16	/* is freezing for suspend */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
@@ -78,6 +79,7 @@ static inline struct thread_info *curren
 #define _TIF_MEMDIE		(1 << TIF_MEMDIE)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
+#define _TIF_KERNEL_TRACE	(1 << TIF_KERNEL_TRACE)
 #define _TIF_FREEZE		(1 << TIF_FREEZE)
 
 #endif

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
