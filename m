Return-Path: <linux-kernel-owner+w=401wt.eu-S1762817AbXEKTlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762817AbXEKTlu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965513AbXEKTkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:40:49 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:45916 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964821AbXEKTkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:40:47 -0400
Message-ID: <4644C6BA.9080102@simon.arlott.org.uk>
Date: Fri, 11 May 2007 20:40:42 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, spyro@f2s.com,
       trivial@kernel.org
Subject: [PATCH] spelling fixes: arch/arm26/
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Spelling fixes in arch/arm26/.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 arch/arm26/kernel/irq.c     |    6 +++---
 arch/arm26/kernel/process.c |    2 +-
 arch/arm26/kernel/time.c    |    2 +-
 arch/arm26/lib/longlong.h   |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm26/kernel/irq.c b/arch/arm26/kernel/irq.c
index d53382c..f2b5963 100644
--- a/arch/arm26/kernel/irq.c
+++ b/arch/arm26/kernel/irq.c
@@ -10,12 +10,12 @@
  * published by the Free Software Foundation.
  *
  *  This file contains the code used by various IRQ handling routines:
- *  asking for different IRQ's should be done through these routines
+ *  asking for different IRQs should be done through these routines
  *  instead of just grabbing them. Thus setups with different IRQ numbers
  *  shouldn't result in any weird surprises, and installing new handlers
  *  should be easier.
  *
- *  IRQ's are in fact implemented a bit like signal handlers for the kernel.
+ *  IRQs are in fact implemented a bit like signal handlers for the kernel.
  *  Naturally it's not a 1:1 relation, but there are similarities.
  */
 #include <linux/module.h>
@@ -324,7 +324,7 @@ do_level_IRQ(unsigned int irq, struct irqdesc *desc, struct pt_regs *regs)
 }
 
 /*
- * do_IRQ handles all hardware IRQ's.  Decoded IRQs should not
+ * do_IRQ handles all hardware IRQs.  Decoded IRQs should not
  * come via this function.  Instead, they should provide their
  * own 'handler'
  */
diff --git a/arch/arm26/kernel/process.c b/arch/arm26/kernel/process.c
index dcd81e6..7539cfc 100644
--- a/arch/arm26/kernel/process.c
+++ b/arch/arm26/kernel/process.c
@@ -3,7 +3,7 @@
  *
  *  Copyright (C) 2003 Ian Molton - adapted for ARM26
  *  Copyright (C) 1996-2000 Russell King - Converted to ARM.
- *  Origional Copyright (C) 1995  Linus Torvalds
+ *  Original Copyright (C) 1995  Linus Torvalds
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/arch/arm26/kernel/time.c b/arch/arm26/kernel/time.c
index 0f1d57f..4cefc44 100644
--- a/arch/arm26/kernel/time.c
+++ b/arch/arm26/kernel/time.c
@@ -182,7 +182,7 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id, struct pt_regs *regs)
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(regs));
 #endif
-        do_set_rtc(); //FIME - EVERY timer IRQ?
+        do_set_rtc(); //FIXME - EVERY timer IRQ?
         profile_tick(CPU_PROFILING, regs);
 	return IRQ_HANDLED; //FIXME - is this right?
 }
diff --git a/arch/arm26/lib/longlong.h b/arch/arm26/lib/longlong.h
index 05ec1ab..9f59fbf 100644
--- a/arch/arm26/lib/longlong.h
+++ b/arch/arm26/lib/longlong.h
@@ -31,7 +31,7 @@
 
 /* Define auxiliary asm macros.
 
-   1) umul_ppmm(high_prod, low_prod, multipler, multiplicand)
+   1) umul_ppmm(high_prod, low_prod, multiplier, multiplicand)
    multiplies two USItype integers MULTIPLER and MULTIPLICAND,
    and generates a two-part USItype product in HIGH_PROD and
    LOW_PROD.
-- 
1.5.0.1

-- 
Simon Arlott
