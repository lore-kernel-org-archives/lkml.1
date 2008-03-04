Return-Path: <linux-kernel-owner+w=401wt.eu-S1758000AbYCDG0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000AbYCDG0E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 01:26:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750884AbYCDGZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 01:25:55 -0500
Received: from rex.snapgear.com ([203.143.235.140]:41652 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750771AbYCDGZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 01:25:54 -0500
Date: Tue, 4 Mar 2008 16:24:17 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200803040624.m246OHoS029524@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: remove duplicate hw_tick() code
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicate hw_tick() function from 68328 timers code.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---

diff -Naurp linux-2.6.25-rc3/arch/m68knommu/platform/68328/timers.c linux-2.6.25-rc3.foo/arch/m68knommu/platform/68328/timers.c
--- linux-2.6.25-rc3/arch/m68knommu/platform/68328/timers.c	2008-02-25 14:04:51.000000000 +1000
+++ linux-2.6.25-rc3.foo/arch/m68knommu/platform/68328/timers.c	2008-03-04 16:04:51.000000000 +1000
@@ -67,16 +67,6 @@ static irqreturn_t hw_tick(int irq, void
 
 /***************************************************************************/
 
-static irqreturn_t hw_tick(int irq, void *dummy)
-{
-	/* Reset Timer1 */
-	TSTAT &= 0;
-
-	return arch_timer_interrupt(irq, dummy);
-}
-
-/***************************************************************************/
-
 static struct irqaction m68328_timer_irq = {
 	.name	 = "timer",
 	.flags	 = IRQF_DISABLED | IRQF_TIMER,
