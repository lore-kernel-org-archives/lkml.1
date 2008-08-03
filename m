Return-Path: <linux-kernel-owner+w=401wt.eu-S1752211AbYHCDBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbYHCDBS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 23:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbYHCDAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 23:00:16 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:17221 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbYHCDAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 23:00:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=veJzU3Y0izbmugDWbB57Jk8fk/0tpiFeSKStNeEDdWou1/agZAB7OHvPlgirQ4Cabh
         Aufaz1EHh8D7/BYlQLADT+PprWG2H/mslcVsoCAlPvAYwTk25wqN0/8ImEFasIez96G1
         Emtvhij672hOw/4MuVabljp44uAVjgMabQSgM=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 02/25] x86: remove irq_vectors_limits
Date: Sat,  2 Aug 2008 19:59:02 -0700
Message-Id: <1217732365-16595-3-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217732365-16595-2-git-send-email-yhlu.kernel@gmail.com>
References: <1217732365-16595-1-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-2-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

no user

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 include/asm-x86/mach-generic/irq_vectors_limits.h |   14 --------------
 include/asm-x86/summit/irq_vectors_limits.h       |   14 --------------
 2 files changed, 0 insertions(+), 28 deletions(-)
 delete mode 100644 include/asm-x86/mach-generic/irq_vectors_limits.h
 delete mode 100644 include/asm-x86/summit/irq_vectors_limits.h

diff --git a/include/asm-x86/mach-generic/irq_vectors_limits.h b/include/asm-x86/mach-generic/irq_vectors_limits.h
deleted file mode 100644
index f7870e1..0000000
--- a/include/asm-x86/mach-generic/irq_vectors_limits.h
+++ /dev/null
@@ -1,14 +0,0 @@
-#ifndef ASM_X86__MACH_GENERIC__IRQ_VECTORS_LIMITS_H
-#define ASM_X86__MACH_GENERIC__IRQ_VECTORS_LIMITS_H
-
-/*
- * For Summit or generic (i.e. installer) kernels, we have lots of I/O APICs,
- * even with uni-proc kernels, so use a big array.
- *
- * This value should be the same in both the generic and summit subarches.
- * Change one, change 'em both.
- */
-#define NR_IRQS	224
-#define NR_IRQ_VECTORS	1024
-
-#endif /* ASM_X86__MACH_GENERIC__IRQ_VECTORS_LIMITS_H */
diff --git a/include/asm-x86/summit/irq_vectors_limits.h b/include/asm-x86/summit/irq_vectors_limits.h
deleted file mode 100644
index 890ce3f..0000000
--- a/include/asm-x86/summit/irq_vectors_limits.h
+++ /dev/null
@@ -1,14 +0,0 @@
-#ifndef _ASM_IRQ_VECTORS_LIMITS_H
-#define _ASM_IRQ_VECTORS_LIMITS_H
-
-/*
- * For Summit or generic (i.e. installer) kernels, we have lots of I/O APICs,
- * even with uni-proc kernels, so use a big array.
- *
- * This value should be the same in both the generic and summit subarches.
- * Change one, change 'em both.
- */
-#define NR_IRQS	224
-#define NR_IRQ_VECTORS	1024
-
-#endif /* _ASM_IRQ_VECTORS_LIMITS_H */
-- 
1.5.4.5

