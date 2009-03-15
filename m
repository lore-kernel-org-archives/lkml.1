Return-Path: <linux-kernel-owner+w=401wt.eu-S1761016AbZCOUcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761016AbZCOUcL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 16:32:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759021AbZCOU0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 16:26:08 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:58973 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758866AbZCOU0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 16:26:04 -0400
Message-Id: <20090315200506.597727743@polymtl.ca>
References: <20090315200144.017321577@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 15 Mar 2009 16:01:56 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC patch 12/20] LTTng Kernel Trace Thread Flag parisc
Content-Disposition: inline; filename=lttng-kernel-trace-thread-flag-parisc.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Sun, 15 Mar 2009 20:24:31 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a thread flag to activate system-wide syscall tracing.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/parisc/include/asm/thread_info.h |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6-lttng/arch/parisc/include/asm/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/arch/parisc/include/asm/thread_info.h	2009-03-15 15:57:04.000000000 -0400
+++ linux-2.6-lttng/arch/parisc/include/asm/thread_info.h	2009-03-15 15:57:16.000000000 -0400
@@ -59,6 +59,7 @@ struct thread_info {
 #define TIF_MEMDIE		5
 #define TIF_RESTORE_SIGMASK	6	/* restore saved signal mask */
 #define TIF_FREEZE		7	/* is freezing for suspend */
+#define TIF_KERNEL_TRACE	8	/* kernel trace active */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
@@ -67,6 +68,7 @@ struct thread_info {
 #define _TIF_32BIT		(1 << TIF_32BIT)
 #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
 #define _TIF_FREEZE		(1 << TIF_FREEZE)
+#define _TIF_KERNEL_TRACE	(1 << TIF_KERNEL_TRACE)
 
 #define _TIF_USER_WORK_MASK     (_TIF_SIGPENDING | \
                                  _TIF_NEED_RESCHED | _TIF_RESTORE_SIGMASK)

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
