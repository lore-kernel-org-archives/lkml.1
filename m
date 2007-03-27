Return-Path: <linux-kernel-owner+w=401wt.eu-S1752853AbXC0Us6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbXC0Us6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 16:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbXC0Usz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 16:48:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56328 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752684AbXC0Urh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 16:47:37 -0400
Message-Id: <20070327204729.258160000@strauss.suse.de>
References: <20070327202234.639415000@strauss.suse.de>
User-Agent: quilt/0.46-14
Date: Tue, 27 Mar 2007 22:22:39 +0200
From: Bernhard Walle <bwalle@suse.de>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 5/7] Add IRQF_IRQPOLL flag on sh
Content-Disposition: inline; filename=add-irqf_irqpoll-flag-on-sh.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add IRQF_IRQPOLL on each timer interrupt on SH2.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
---
 arch/sh/kernel/timers/timer-cmt.c  |    2 +-
 arch/sh/kernel/timers/timer-mtu2.c |    2 +-
 arch/sh/kernel/timers/timer-tmu.c  |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6.21-rc5-mm2/arch/sh/kernel/timers/timer-cmt.c
===================================================================
--- linux-2.6.21-rc5-mm2.orig/arch/sh/kernel/timers/timer-cmt.c
+++ linux-2.6.21-rc5-mm2/arch/sh/kernel/timers/timer-cmt.c
@@ -115,7 +115,7 @@ static irqreturn_t cmt_timer_interrupt(i
 static struct irqaction cmt_irq = {
 	.name		= "timer",
 	.handler	= cmt_timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
 	.mask		= CPU_MASK_NONE,
 };
 
Index: linux-2.6.21-rc5-mm2/arch/sh/kernel/timers/timer-mtu2.c
===================================================================
--- linux-2.6.21-rc5-mm2.orig/arch/sh/kernel/timers/timer-mtu2.c
+++ linux-2.6.21-rc5-mm2/arch/sh/kernel/timers/timer-mtu2.c
@@ -110,7 +110,7 @@ static irqreturn_t mtu2_timer_interrupt(
 static struct irqaction mtu2_irq = {
 	.name		= "timer",
 	.handler	= mtu2_timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
 	.mask		= CPU_MASK_NONE,
 };
 
Index: linux-2.6.21-rc5-mm2/arch/sh/kernel/timers/timer-tmu.c
===================================================================
--- linux-2.6.21-rc5-mm2.orig/arch/sh/kernel/timers/timer-tmu.c
+++ linux-2.6.21-rc5-mm2/arch/sh/kernel/timers/timer-tmu.c
@@ -99,7 +99,7 @@ static irqreturn_t tmu_timer_interrupt(i
 static struct irqaction tmu_irq = {
 	.name		= "timer",
 	.handler	= tmu_timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
 	.mask		= CPU_MASK_NONE,
 };
 

-- 
