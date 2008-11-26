Return-Path: <linux-kernel-owner+w=401wt.eu-S1753544AbYKZM6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbYKZM6J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 07:58:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbYKZM5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 07:57:53 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:46104 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbYKZM5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 07:57:53 -0500
Message-Id: <20081126124636.720939952@polymtl.ca>
References: <20081126124246.800751190@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 26 Nov 2008 07:43:01 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ralf Baechle <ralf@linux-mips.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [patch 15/17] MIPS create empty sync_core()
Content-Disposition: inline; filename=mips-create-empty-sync_core.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Wed, 26 Nov 2008 12:57:42 +0000
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
--- linux.trees.git.orig/arch/mips/include/asm/barrier.h	2008-11-12 18:15:47.000000000 -0500
+++ linux.trees.git/arch/mips/include/asm/barrier.h	2008-11-26 06:57:50.000000000 -0500
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
