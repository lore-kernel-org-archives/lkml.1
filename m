Return-Path: <linux-kernel-owner+w=401wt.eu-S1756771AbZCKAvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbZCKAvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 20:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754793AbZCKArb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 20:47:31 -0400
Received: from www.tglx.de ([62.245.132.106]:40108 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755180AbZCKAra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 20:47:30 -0400
Message-Id: <20090311003237.169865866@linutronix.de>
User-Agent: quilt/0.47-1
Date: Wed, 11 Mar 2009 00:46:30 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org
Subject: [patch 16/18] powerpc: convert obsolete hw_interrupt_type to struct
	irq_chip
References: <20090311003204.592133594@linutronix.de>
Content-Disposition: inline;
	filename=powerpc-convert-obsolete-hw-interrupt-type.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Convert the last remaining users to struct irq_chip.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: linuxppc-dev@ozlabs.org
---
 arch/powerpc/include/asm/hw_irq.h     |    2 +-
 arch/powerpc/platforms/powermac/pic.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/powerpc/include/asm/hw_irq.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/hw_irq.h
+++ linux-2.6/arch/powerpc/include/asm/hw_irq.h
@@ -129,7 +129,7 @@ static inline int irqs_disabled_flags(un
  * interrupt-retrigger: should we handle this via lost interrupts and IPIs
  * or should we not care like we do now ? --BenH.
  */
-struct hw_interrupt_type;
+struct irq_chip;
 
 #endif	/* __KERNEL__ */
 #endif	/* _ASM_POWERPC_HW_IRQ_H */
Index: linux-2.6/arch/powerpc/platforms/powermac/pic.h
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/powermac/pic.h
+++ linux-2.6/arch/powerpc/platforms/powermac/pic.h
@@ -3,7 +3,7 @@
 
 #include <linux/irq.h>
 
-extern struct hw_interrupt_type pmac_pic;
+extern struct irq_chip pmac_pic;
 
 extern void pmac_pic_init(void);
 extern int pmac_get_irq(void);


