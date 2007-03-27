Return-Path: <linux-kernel-owner+w=401wt.eu-S1752843AbXC0Usx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbXC0Usx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 16:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbXC0Urf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 16:47:35 -0400
Received: from mail.suse.de ([195.135.220.2]:51947 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843AbXC0Urd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 16:47:33 -0400
Message-Id: <20070327204729.571653000@strauss.suse.de>
References: <20070327202234.639415000@strauss.suse.de>
User-Agent: quilt/0.46-14
Date: Tue, 27 Mar 2007 22:22:40 +0200
From: Bernhard Walle <bwalle@suse.de>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 6/7] Add IRQF_IRQPOLL flag on parisc
Content-Disposition: inline; filename=add-irqf_irqpoll-flag-on-parisc.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add IRQF_IRQPOLL to the timer interrupt on parisc.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
---
 arch/parisc/kernel/irq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.21-rc5-mm2/arch/parisc/kernel/irq.c
===================================================================
--- linux-2.6.21-rc5-mm2.orig/arch/parisc/kernel/irq.c
+++ linux-2.6.21-rc5-mm2/arch/parisc/kernel/irq.c
@@ -388,7 +388,7 @@ void do_cpu_irq_mask(struct pt_regs *reg
 static struct irqaction timer_action = {
 	.handler = timer_interrupt,
 	.name = "timer",
-	.flags = IRQF_DISABLED | IRQF_TIMER | IRQF_PERCPU,
+	.flags = IRQF_DISABLED | IRQF_TIMER | IRQF_PERCPU | IRQF_IRQPOLL,
 };
 
 #ifdef CONFIG_SMP

-- 
