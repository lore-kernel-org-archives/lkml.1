Return-Path: <linux-kernel-owner+w=401wt.eu-S1754993AbZCKAuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993AbZCKAuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 20:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754731AbZCKArQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 20:47:16 -0400
Received: from www.tglx.de ([62.245.132.106]:40078 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754776AbZCKArO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 20:47:14 -0400
Message-Id: <20090311003236.704145797@linutronix.de>
User-Agent: quilt/0.47-1
Date: Wed, 11 Mar 2009 00:46:11 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Mikael Starvik <starvik@axis.com>
Subject: [patch 12/18] cris: convert obsolete hw_interrupt_type to struct
	irq_chip
References: <20090311003204.592133594@linutronix.de>
Content-Disposition: inline;
	filename=cris-convert-obsolete-hw-interrupt-type.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Convert the last remaining users to struct irq_chip.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
CC: Mikael Starvik <starvik@axis.com>

---
 arch/cris/arch-v10/kernel/irq.c |    2 +-
 arch/cris/arch-v32/kernel/irq.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/cris/arch-v10/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/cris/arch-v10/kernel/irq.c
+++ linux-2.6/arch/cris/arch-v10/kernel/irq.c
@@ -132,7 +132,7 @@ static void end_crisv10_irq(unsigned int
 {
 }
 
-static struct hw_interrupt_type crisv10_irq_type = {
+static struct irq_chip crisv10_irq_type = {
 	.typename =    "CRISv10",
 	.startup =     startup_crisv10_irq,
 	.shutdown =    shutdown_crisv10_irq,
Index: linux-2.6/arch/cris/arch-v32/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/cris/arch-v32/kernel/irq.c
+++ linux-2.6/arch/cris/arch-v32/kernel/irq.c
@@ -333,7 +333,7 @@ void set_affinity_crisv32_irq(unsigned i
 	spin_unlock_irqrestore(&irq_lock, flags);
 }
 
-static struct hw_interrupt_type crisv32_irq_type = {
+static struct irq_chip crisv32_irq_type = {
 	.typename =    "CRISv32",
 	.startup =     startup_crisv32_irq,
 	.shutdown =    shutdown_crisv32_irq,


