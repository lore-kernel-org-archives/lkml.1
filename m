Return-Path: <linux-kernel-owner+w=401wt.eu-S1760067AbZEBUCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760067AbZEBUCx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 16:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759003AbZEBUBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 16:01:42 -0400
Received: from www.tglx.de ([62.245.132.106]:55709 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758359AbZEBUBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 16:01:41 -0400
Message-Id: <20090502195925.485566561@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 02 May 2009 20:00:52 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: [patch 04/11] drivers/mfd: remove obsolete irq_desc_t typedef
References: <20090502195607.539955644@linutronix.de>
Content-Disposition: inline;
	filename=mfd-remove-obsolete-irq-desc-t-typedef.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Convert the last remaining users and remove the typedef.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
CC: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/mfd/twl4030-irq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/mfd/twl4030-irq.c
===================================================================
--- linux-2.6.orig/drivers/mfd/twl4030-irq.c
+++ linux-2.6/drivers/mfd/twl4030-irq.c
@@ -255,7 +255,7 @@ static int twl4030_irq_thread(void *data
  * thread.  All we do here is acknowledge and mask the interrupt and wakeup
  * the kernel thread.
  */
-static void handle_twl4030_pih(unsigned int irq, irq_desc_t *desc)
+static void handle_twl4030_pih(unsigned int irq, struct irq_desc *desc)
 {
 	/* Acknowledge, clear *AND* mask the interrupt... */
 	desc->chip->ack(irq);


