Return-Path: <linux-kernel-owner+w=401wt.eu-S1763147AbXEKToG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763147AbXEKToG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:44:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762966AbXEKTlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:41:35 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:45937 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762953AbXEKTld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:41:33 -0400
Message-ID: <4644C6E9.4020505@simon.arlott.org.uk>
Date: Fri, 11 May 2007 20:41:29 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       trivial@kernel.org
Subject: [PATCH] spelling fixes: arch/h8300/
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Spelling fixes in arch/h8300/.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 arch/h8300/kernel/ints.c           |    2 +-
 arch/h8300/kernel/irq.c            |    2 +-
 arch/h8300/kernel/time.c           |    2 +-
 arch/h8300/kernel/traps.c          |    2 +-
 arch/h8300/platform/h8s/ints.c     |    2 +-
 arch/h8300/platform/h8s/ints_h8s.c |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/h8300/kernel/ints.c b/arch/h8300/kernel/ints.c
index 3e4f479..24269cd 100644
--- a/arch/h8300/kernel/ints.c
+++ b/arch/h8300/kernel/ints.c
@@ -144,7 +144,7 @@ int request_irq(unsigned int irq,
 	if (use_kmalloc)
 		irq_handle = kmalloc(sizeof(irq_handler_t), GFP_ATOMIC);
 	else {
-		/* use bootmem allocater */
+		/* use bootmem allocator */
 		irq_handle = (irq_handler_t *)alloc_bootmem(sizeof(irq_handler_t));
 		irq_handle = (irq_handler_t *)((unsigned long)irq_handle | 0x80000000);
 	}
diff --git a/arch/h8300/kernel/irq.c b/arch/h8300/kernel/irq.c
index 43d21e9..8dec4dd 100644
--- a/arch/h8300/kernel/irq.c
+++ b/arch/h8300/kernel/irq.c
@@ -68,7 +68,7 @@ static void h8300_shutdown_irq(unsigned int irq)
 }
 
 /*
- * h8300 interrupt controler implementation
+ * h8300 interrupt controller implementation
  */
 struct irq_chip h8300irq_chip = {
 	.name		= "H8300-INTC",
diff --git a/arch/h8300/kernel/time.c b/arch/h8300/kernel/time.c
index 3306382..e37c835 100644
--- a/arch/h8300/kernel/time.c
+++ b/arch/h8300/kernel/time.c
@@ -53,7 +53,7 @@ void time_init(void)
 
 	/* FIX by dqg : Set to zero for platforms that don't have tod */
 	/* without this time is undefined and can overflow time_t, causing  */
-	/* very stange errors */
+	/* very strange errors */
 	year = 1980;
 	mon = day = 1;
 	hour = min = sec = 0;
diff --git a/arch/h8300/kernel/traps.c b/arch/h8300/kernel/traps.c
index 300e327..ceb7fbe 100644
--- a/arch/h8300/kernel/traps.c
+++ b/arch/h8300/kernel/traps.c
@@ -5,7 +5,7 @@
  * Cloned from Linux/m68k.
  *
  * No original Copyright holder listed,
- * Probabily original (C) Roman Zippel (assigned DJD, 1999)
+ * Probable original (C) Roman Zippel (assigned DJD, 1999)
  *
  * Copyright 1999-2000 D. Jeff Dionne, <jeff@rt-control.com>
  *
diff --git a/arch/h8300/platform/h8s/ints.c b/arch/h8300/platform/h8s/ints.c
index a71d6e2..551fd5f 100644
--- a/arch/h8300/platform/h8s/ints.c
+++ b/arch/h8300/platform/h8s/ints.c
@@ -179,7 +179,7 @@ int request_irq(unsigned int irq,
 	if (use_kmalloc)
 		irq_handle = kmalloc(sizeof(irq_handler_t), GFP_ATOMIC);
 	else {
-		/* use bootmem allocater */
+		/* use bootmem allocator */
 		irq_handle = (irq_handler_t *)alloc_bootmem(sizeof(irq_handler_t));
 		irq_handle = (irq_handler_t *)((unsigned long)irq_handle | 0x80000000);
 	}
diff --git a/arch/h8300/platform/h8s/ints_h8s.c b/arch/h8300/platform/h8s/ints_h8s.c
index 93395d2..faa8a45 100644
--- a/arch/h8300/platform/h8s/ints_h8s.c
+++ b/arch/h8300/platform/h8s/ints_h8s.c
@@ -63,7 +63,7 @@ static const struct irq_pins irq_assign_table1[16]={
 	{H8300_GPIO_P2,H8300_GPIO_B6},{H8300_GPIO_P2,H8300_GPIO_B7},
 };
 
-/* IRQ to GPIO pinno transrate */
+/* IRQ to GPIO pin translation */
 #define IRQ_GPIO_MAP(irqbit,irq,port,bit)			  \
 do {								  \
 	if (*(volatile unsigned short *)ITSR & irqbit) {	  \
-- 
1.5.0.1

-- 
Simon Arlott
