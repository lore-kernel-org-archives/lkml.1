Return-Path: <linux-kernel-owner+w=401wt.eu-S1756033AbZCKAtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033AbZCKAtJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 20:49:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754797AbZCKArF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 20:47:05 -0400
Received: from www.tglx.de ([62.245.132.106]:40059 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754776AbZCKArE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 20:47:04 -0400
Message-Id: <20090311003236.372774284@linutronix.de>
User-Agent: quilt/0.47-1
Date: Wed, 11 Mar 2009 00:45:58 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 09/18] x86: convert obsolete irq_desc_t to struct irq_desc
References: <20090311003204.592133594@linutronix.de>
Content-Disposition: inline;
	filename=x86-convert-obsolete-irq-desc-t-typedef.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Convert the last remaining users to struct irq_desc.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/kernel/visws_quirks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/visws_quirks.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/visws_quirks.c
+++ linux-2.6/arch/x86/kernel/visws_quirks.c
@@ -584,7 +584,7 @@ static struct irq_chip piix4_virtual_irq
 static irqreturn_t piix4_master_intr(int irq, void *dev_id)
 {
 	int realirq;
-	irq_desc_t *desc;
+	struct irq_desc *desc;
 	unsigned long flags;
 
 	spin_lock_irqsave(&i8259A_lock, flags);


