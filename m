Return-Path: <linux-kernel-owner+w=401wt.eu-S1756148AbYKLXea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbYKLXea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:34:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755605AbYKLXdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:33:49 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:48390 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755533AbYKLXds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:33:48 -0500
Message-Id: <20081112232300.670930989@polymtl.ca>
References: <20081112231551.473569400@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 12 Nov 2008 18:16:06 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: [patch 15/17] MIPS create empty sync_core()
Content-Disposition: inline; filename=mips-create-empty-sync_core.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Wed, 12 Nov 2008 23:33:03 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Needed by architecture-independant tsc-sync.c.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ralf Baechle <ralf@linux-mips.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/mips/include/asm/barrier.h |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux.trees.git/arch/mips/include/asm/barrier.h
===================================================================
--- linux.trees.git.orig/arch/mips/include/asm/barrier.h	2008-11-07 00:34:10.000000000 -0500
+++ linux.trees.git/arch/mips/include/asm/barrier.h	2008-11-12 18:03:51.000000000 -0500
@@ -152,4 +152,10 @@
 #define smp_llsc_rmb()	__asm__ __volatile__(__WEAK_LLSC_MB : : :"memory")
 #define smp_llsc_wmb()	__asm__ __volatile__(__WEAK_LLSC_MB : : :"memory")
 
+/*
+ * MIPS does not have any instruction to serialize instruction execution on the
+ * core.
+ */
+#define sync_core()
+
 #endif /* __ASM_BARRIER_H */

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
