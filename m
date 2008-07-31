Return-Path: <linux-kernel-owner+w=401wt.eu-S1756699AbYGaKPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbYGaKPt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 06:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756427AbYGaKPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 06:15:37 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:11265 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756356AbYGaKPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 06:15:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=Z/MPnOyJZZ/OIM62BL7u7/37kBV3yjsPTZpd64mw3eN0exegGcUsOfSDlhAO1es8PI
         L1gUYr0S+Qrt5fhhZptkMI4IQVpHEshcyfV3PrcAh+RTjez/1d/6IwVj2AsMahMQBYlE
         YEkUbBVlJxS1+flD9n8WlMvOd3Tx1Utc78gfU=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86 remove irq_vectors_limit.h
Date: Thu, 31 Jul 2008 03:14:45 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200807291414.55479.yhlu.kernel@gmail.com> <200807301210.31511.yhlu.kernel@gmail.com> <200807302109.21519.yhlu.kernel@gmail.com>
In-Reply-To: <200807302109.21519.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807310314.46116.yhlu.kernel@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


    no user

later
1. need to make 32bit to support dyn_array for irq_vector[]
2. also need to probe nr_irqs via madt and mptable

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/include/asm-x86/mach-generic/irq_vectors_limits.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mach-generic/irq_vectors_limits.h
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
Index: linux-2.6/include/asm-x86/summit/irq_vectors_limits.h
===================================================================
--- linux-2.6.orig/include/asm-x86/summit/irq_vectors_limits.h
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
