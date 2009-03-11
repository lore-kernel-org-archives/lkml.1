Return-Path: <linux-kernel-owner+w=401wt.eu-S1755759AbZCKAss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759AbZCKAss (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 20:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754698AbZCKAq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 20:46:57 -0400
Received: from www.tglx.de ([62.245.132.106]:40046 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754655AbZCKAq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 20:46:56 -0400
Message-Id: <20090311003236.133903965@linutronix.de>
User-Agent: quilt/0.47-1
Date: Wed, 11 Mar 2009 00:45:51 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: [patch 07/18] mips: convert obsolete irq_desc_t to struct irq_desc
References: <20090311003204.592133594@linutronix.de>
Content-Disposition: inline;
	filename=mips-convert-obsolete-irq-desc-t-typedef.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Convert the last remaining users to struct irq_desc.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
CC: Ralf Baechle <ralf@linux-mips.org>

---
 arch/mips/cavium-octeon/octeon-irq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/mips/cavium-octeon/octeon-irq.c
===================================================================
--- linux-2.6.orig/arch/mips/cavium-octeon/octeon-irq.c
+++ linux-2.6/arch/mips/cavium-octeon/octeon-irq.c
@@ -31,7 +31,7 @@ static void octeon_irq_core_ack(unsigned
 
 static void octeon_irq_core_eoi(unsigned int irq)
 {
-	irq_desc_t *desc = irq_desc + irq;
+	struct irq_desc *desc = irq_desc + irq;
 	unsigned int bit = irq - OCTEON_IRQ_SW0;
 	/*
 	 * If an IRQ is being processed while we are disabling it the


