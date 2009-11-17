Return-Path: <linux-kernel-owner+w=401wt.eu-S1756749AbZKQWwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749AbZKQWwa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 17:52:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756644AbZKQWw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 17:52:28 -0500
Received: from www.tglx.de ([62.245.132.106]:41643 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756674AbZKQWwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 17:52:06 -0500
Message-Id: <20091117224916.770887722@linutronix.de>
User-Agent: quilt/0.47-1
Date: Tue, 17 Nov 2009 22:51:29 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Leo Chen <leochen@broadcom.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org
Subject: [patch 11/13] arm: Fixup last users of irq_chip->typename 
References: <20091117224852.846805939@linutronix.de>
Content-Disposition: inline; filename=arm-replace-obsolete-typename.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The typename member of struct irq_chip was kept for migration purposes
and is obsolete since more than 2 years. Fix up the leftovers.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Leo Chen <leochen@broadcom.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/mach-bcmring/irq.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/arm/mach-bcmring/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-bcmring/irq.c
+++ linux-2.6/arch/arm/mach-bcmring/irq.c
@@ -67,21 +67,21 @@ static void bcmring_unmask_irq2(unsigned
 }
 
 static struct irq_chip bcmring_irq0_chip = {
-	.typename = "ARM-INTC0",
+	.name = "ARM-INTC0",
 	.ack = bcmring_mask_irq0,
 	.mask = bcmring_mask_irq0,	/* mask a specific interrupt, blocking its delivery. */
 	.unmask = bcmring_unmask_irq0,	/* unmaks an interrupt */
 };
 
 static struct irq_chip bcmring_irq1_chip = {
-	.typename = "ARM-INTC1",
+	.name = "ARM-INTC1",
 	.ack = bcmring_mask_irq1,
 	.mask = bcmring_mask_irq1,
 	.unmask = bcmring_unmask_irq1,
 };
 
 static struct irq_chip bcmring_irq2_chip = {
-	.typename = "ARM-SINTC",
+	.name = "ARM-SINTC",
 	.ack = bcmring_mask_irq2,
 	.mask = bcmring_mask_irq2,
 	.unmask = bcmring_unmask_irq2,


