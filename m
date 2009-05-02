Return-Path: <linux-kernel-owner+w=401wt.eu-S1760423AbZEBUDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760423AbZEBUDQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 16:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759466AbZEBUBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 16:01:52 -0400
Received: from www.tglx.de ([62.245.132.106]:55716 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759445AbZEBUBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 16:01:51 -0400
Message-Id: <20090502195925.690548195@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 02 May 2009 20:01:02 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Haavard Skinnemoen <skinnemoen@atmel.com>
Subject: [patch 06/11] avr32: remove obsolete hw_interrupt_type
References: <20090502195607.539955644@linutronix.de>
Content-Disposition: inline;
	filename=avr32-remove-obsolete-hw-interrupt-type.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Convert the last remaining users to struct irq_chip and remove the
define.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
CC: Haavard Skinnemoen <skinnemoen@atmel.com>

---
 arch/avr32/include/asm/hw_irq.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/avr32/include/asm/hw_irq.h
===================================================================
--- linux-2.6.orig/arch/avr32/include/asm/hw_irq.h
+++ linux-2.6/arch/avr32/include/asm/hw_irq.h
@@ -1,7 +1,7 @@
 #ifndef __ASM_AVR32_HW_IRQ_H
 #define __ASM_AVR32_HW_IRQ_H
 
-static inline void hw_resend_irq(struct hw_interrupt_type *h, unsigned int i)
+static inline void hw_resend_irq(struct irq_chip *h, unsigned int i)
 {
 	/* Nothing to do */
 }


