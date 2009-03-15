Return-Path: <linux-kernel-owner+w=401wt.eu-S1759789AbZCOU3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759789AbZCOU3s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 16:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758972AbZCOU0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 16:26:00 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:58968 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758874AbZCOUZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 16:25:58 -0400
Message-Id: <20090315200505.823907584@polymtl.ca>
References: <20090315200144.017321577@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 15 Mar 2009 16:01:51 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC patch 07/20] LTTng Kernel Trace Thread Flag H8300
Content-Disposition: inline; filename=lttng-kernel-trace-thread-flag-h8300.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Sun, 15 Mar 2009 20:24:30 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a thread flag to activate system-wide syscall tracing.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/h8300/include/asm/thread_info.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/arch/h8300/include/asm/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/arch/h8300/include/asm/thread_info.h	2009-03-15 15:57:05.000000000 -0400
+++ linux-2.6-lttng/arch/h8300/include/asm/thread_info.h	2009-03-15 15:57:15.000000000 -0400
@@ -89,6 +89,7 @@ static inline struct thread_info *curren
 					   TIF_NEED_RESCHED */
 #define TIF_MEMDIE		4
 #define TIF_RESTORE_SIGMASK	5	/* restore signal mask in do_signal() */
+#define TIF_KERNEL_TRACE	6	/* kernel trace active */
 #define TIF_FREEZE		16	/* is freezing for suspend */
 
 /* as above, but as bit values */
@@ -97,9 +98,10 @@ static inline struct thread_info *curren
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
+#define _TIF_KERNEL_TRACE	(1<<TIF_KERNEL_TRACE)
 #define _TIF_FREEZE		(1<<TIF_FREEZE)
 
-#define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
+#define _TIF_WORK_MASK		0x0000FFBE	/* work to do on interrupt/exception return */
 
 #endif /* __KERNEL__ */
 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
