Return-Path: <linux-kernel-owner+w=401wt.eu-S1762306AbYHHVzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762306AbYHHVzH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 17:55:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757738AbYHHVxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:53:41 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:59965 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282AbYHHVxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:53:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=cucT7Uk7V2gYbyK1me48eR4iooDbmJZgFVCYjNdygH4MgmGx5vbttgx4ZGVNIHi+gV
         WMVC79bcc/SRmX25ea1GJMQdt9ATvBabuAPRaHNdpR9FPngrq+cgKI2YQI1S7CGmEqum
         Nwp9LaAQAcqGA3Eo+k0OqUxSLoRLh1gvlahAM=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 03/42] x86: remove irq_vectors_limits
Date: Fri,  8 Aug 2008 14:52:09 -0700
Message-Id: <1218232368-31228-4-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218232368-31228-3-git-send-email-yhlu.kernel@gmail.com>
References: <1218232368-31228-1-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-2-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-3-git-send-email-yhlu.kernel@gmail.com>
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

