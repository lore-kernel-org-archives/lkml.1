Return-Path: <linux-kernel-owner+w=401wt.eu-S1756860AbZEIQ4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860AbZEIQ4B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 12:56:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756163AbZEIQw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 12:52:29 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:54780 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754859AbZEIQw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 12:52:29 -0400
Message-Id: <20090509162350.940432237@polymtl.ca>
References: <20090509162209.217414024@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sat, 09 May 2009 12:22:26 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       fweisbec@gmail.com, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, jiayingz@google.com, roland@redhat.com,
       mbligh@google.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC patch 17/20] LTTng Kernel Trace Thread Flag UML
Content-Disposition: inline; filename=lttng-kernel-trace-thread-flag-um.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Sat,  9 May 2009 16:47:20 +0000
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
--- linux-2.6-lttng.orig/arch/um/include/asm/thread_info.h	2009-03-15 15:51:26.000000000 -0400
+++ linux-2.6-lttng/arch/um/include/asm/thread_info.h	2009-03-15 15:57:18.000000000 -0400
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
