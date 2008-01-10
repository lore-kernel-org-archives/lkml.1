Return-Path: <linux-kernel-owner+w=401wt.eu-S1758921AbYAJI6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758921AbYAJI6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 03:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbYAJI6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 03:58:14 -0500
Received: from mail29.messagelabs.com ([216.82.249.147]:44980 "HELO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752421AbYAJI6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 03:58:13 -0500
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-7.tower-29.messagelabs.com!1199955490!3192044!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.21]
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Marc Singer <elf@buici.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH] fix typo 'the same the\>'
Date: Thu, 10 Jan 2008 09:58:06 +0100
Message-Id: <1199955486-21733-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
X-Mailer: git-send-email 1.5.3.6
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 10 Jan 2008 08:58:06.0564 (UTC) FILETIME=[EA793240:01C85366]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.000.1023-15658.003
X-TM-AS-Result: No--8.149900-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
Cc: Marc Singer <elf@buici.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
---
 Documentation/arm/Sharp-LH/IOBarrier  |    2 +-
 drivers/mtd/devices/doc2000.c         |    2 +-
 include/asm-arm/arch-realview/irqs.h  |    2 +-
 include/asm-arm/arch-versatile/irqs.h |    4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

I'm not a native English speaker, but 'the same the' sounds wrong to me.

Best regards
Uwe

diff --git a/Documentation/arm/Sharp-LH/IOBarrier b/Documentation/arm/Sharp-LH/IOBarrier
index c0d8853..2e953e2 100644
--- a/Documentation/arm/Sharp-LH/IOBarrier
+++ b/Documentation/arm/Sharp-LH/IOBarrier
@@ -32,7 +32,7 @@ BARRIER IO before the access to the SMC chip because the AEN latch
 only needs occurs after the SMC IO write cycle.  The routines that
 implement this work-around make an additional concession which is to
 disable interrupts during the IO sequence.  Other hardware devices
-(the LogicPD CPLD) have registers in the same the physical memory
+(the LogicPD CPLD) have registers in the same physical memory
 region as the SMC chip.  An interrupt might allow an access to one of
 those registers while SMC IO is being performed.
 
diff --git a/drivers/mtd/devices/doc2000.c b/drivers/mtd/devices/doc2000.c
index c73e96b..90acf57 100644
--- a/drivers/mtd/devices/doc2000.c
+++ b/drivers/mtd/devices/doc2000.c
@@ -376,7 +376,7 @@ static int DoC_IdentChip(struct DiskOnChip *doc, int floor, int chip)
 	 * hardware restriction. */
 	if (doc->mfr) {
 		if (doc->mfr == mfr && doc->id == id)
-			return 1;	/* This is another the same the first */
+			return 1;	/* This is the same as the first */
 		else
 			printk(KERN_WARNING
 			       "Flash chip at floor %d, chip %d is different:\n",
diff --git a/include/asm-arm/arch-realview/irqs.h b/include/asm-arm/arch-realview/irqs.h
index 5a5db56..012a1f8 100644
--- a/include/asm-arm/arch-realview/irqs.h
+++ b/include/asm-arm/arch-realview/irqs.h
@@ -25,7 +25,7 @@
 #define IRQ_LOCALWDOG			30
 
 /* 
- *  IRQ interrupts definitions are the same the INT definitions
+ *  IRQ interrupts definitions are the same as the INT definitions
  *  held within platform.h
  */
 #define IRQ_GIC_START		32
diff --git a/include/asm-arm/arch-versatile/irqs.h b/include/asm-arm/arch-versatile/irqs.h
index 745aa84..f7263b9 100644
--- a/include/asm-arm/arch-versatile/irqs.h
+++ b/include/asm-arm/arch-versatile/irqs.h
@@ -22,7 +22,7 @@
 #include <asm/arch/platform.h>
 
 /* 
- *  IRQ interrupts definitions are the same the INT definitions
+ *  IRQ interrupts definitions are the same as the INT definitions
  *  held within platform.h
  */
 #define IRQ_VIC_START		0
@@ -94,7 +94,7 @@
 #define IRQMASK_VICSOURCE31	INTMASK_VICSOURCE31
 
 /* 
- *  FIQ interrupts definitions are the same the INT definitions.
+ *  FIQ interrupts definitions are the same as the INT definitions.
  */
 #define FIQ_WDOGINT		INT_WDOGINT
 #define FIQ_SOFTINT		INT_SOFTINT
-- 
1.5.3.6

