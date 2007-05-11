Return-Path: <linux-kernel-owner+w=401wt.eu-S966553AbXEKTqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966553AbXEKTqi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763498AbXEKTmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:42:22 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:45951 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761692AbXEKTmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:42:19 -0400
Message-ID: <4644C716.1020000@simon.arlott.org.uk>
Date: Fri, 11 May 2007 20:42:14 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-m68k@vger.kernel.org, trival@kernel.org
Subject: [PATCH] spelling fixes: arch/m68knommu/
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Spelling fixes in arch/m68knommu/.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 arch/m68knommu/kernel/comempci.c      |    8 ++++----
 arch/m68knommu/platform/523x/config.c |    2 +-
 arch/m68knommu/platform/527x/config.c |    2 +-
 arch/m68knommu/platform/528x/config.c |    2 +-
 arch/m68knommu/platform/5307/pit.c    |    2 +-
 arch/m68knommu/platform/5307/timers.c |    4 ++--
 6 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/m68knommu/kernel/comempci.c b/arch/m68knommu/kernel/comempci.c
index 6ee00ef..3ec0a4a 100644
--- a/arch/m68knommu/kernel/comempci.c
+++ b/arch/m68knommu/kernel/comempci.c
@@ -79,7 +79,7 @@ void	pci_interrupt(int irq, void *id, struct pt_regs *fp);
 /*****************************************************************************/
 
 /*
- *	Some platforms have custom ways of reseting the PCI bus.
+ *	Some platforms have custom ways of resetting the PCI bus.
  */
 
 void pci_resetbus(void)
@@ -145,7 +145,7 @@ int pcibios_assign_resource_slot(int slot)
 		}
 
 		/* Determine space required by BAR */
-		/* FIXME: this should go backwords from 0x80000000... */
+		/* FIXME: this should go backwards from 0x80000000... */
 		for (i = 0; (i < 32); i++) {
 			if ((0x1 << i) & (val & 0xfffffffc))
 				break;
@@ -385,8 +385,8 @@ void pcibios_update_resource(struct pci_dev *dev, struct resource *root, struct
 /*****************************************************************************/
 
 /*
- *	Local routines to interrcept the standard I/O and vector handling
- *	code. Don't include this 'till now - initialization code above needs
+ *	Local routines to intercept the standard I/O and vector handling
+ *	code. Don't include this until now - initialization code above needs
  *	access to the real code too.
  */
 #include <asm/mcfpci.h>
diff --git a/arch/m68knommu/platform/523x/config.c b/arch/m68knommu/platform/523x/config.c
index 9b054e6..c55416e 100644
--- a/arch/m68knommu/platform/523x/config.c
+++ b/arch/m68knommu/platform/523x/config.c
@@ -3,7 +3,7 @@
 /*
  *	linux/arch/m68knommu/platform/523x/config.c
  *
- *	Sub-architcture dependant initialization code for the Freescale
+ *	Sub-architcture dependent initialization code for the Freescale
  *	523x CPUs.
  *
  *	Copyright (C) 1999-2005, Greg Ungerer (gerg@snapgear.com)
diff --git a/arch/m68knommu/platform/527x/config.c b/arch/m68knommu/platform/527x/config.c
index 28e7d96..c336457 100644
--- a/arch/m68knommu/platform/527x/config.c
+++ b/arch/m68knommu/platform/527x/config.c
@@ -3,7 +3,7 @@
 /*
  *	linux/arch/m68knommu/platform/527x/config.c
  *
- *	Sub-architcture dependant initialization code for the Freescale
+ *	Sub-architcture dependent initialization code for the Freescale
  *	5270/5271 CPUs.
  *
  *	Copyright (C) 1999-2004, Greg Ungerer (gerg@snapgear.com)
diff --git a/arch/m68knommu/platform/528x/config.c b/arch/m68knommu/platform/528x/config.c
index 805b4f7..48922de 100644
--- a/arch/m68knommu/platform/528x/config.c
+++ b/arch/m68knommu/platform/528x/config.c
@@ -3,7 +3,7 @@
 /*
  *	linux/arch/m68knommu/platform/528x/config.c
  *
- *	Sub-architcture dependant initialization code for the Motorola
+ *	Sub-architcture dependent initialization code for the Motorola
  *	5280 and 5282 CPUs.
  *
  *	Copyright (C) 1999-2003, Greg Ungerer (gerg@snapgear.com)
diff --git a/arch/m68knommu/platform/5307/pit.c b/arch/m68knommu/platform/5307/pit.c
index aa15bee..e8efbe6 100644
--- a/arch/m68knommu/platform/5307/pit.c
+++ b/arch/m68knommu/platform/5307/pit.c
@@ -79,7 +79,7 @@ unsigned long coldfire_pit_offset(void)
 
 	/*
 	 * If we are still in the first half of the upcount and a
-	 * timer interupt is pending, then add on a ticks worth of time.
+	 * timer interrupt is pending, then add on a ticks worth of time.
 	 */
 	offset = ((pmr - pcntr) * (1000000 / HZ)) / pmr;
 	if ((offset < (1000000 / HZ / 2)) && (*ipr & MCFPIT_IMR_IBIT))
diff --git a/arch/m68knommu/platform/5307/timers.c b/arch/m68knommu/platform/5307/timers.c
index 92e5807..75301ed 100644
--- a/arch/m68knommu/platform/5307/timers.c
+++ b/arch/m68knommu/platform/5307/timers.c
@@ -29,8 +29,8 @@
 #define	TA(a)	(MCF_MBAR + MCFTIMER_BASE1 + (a))
 
 /*
- *	Default the timer and vector to use for ColdFire. Some ColdFire
- *	CPU's and some boards may want different. Their sub-architecture
+ *	Default timer and vector to use for ColdFire. Some ColdFire CPUs
+ *	and some boards may want different values. Their sub-architecture
  *	startup code (in config.c) can change these if they want.
  */
 unsigned int	mcf_timervector = 29;
-- 
1.5.0.1

-- 
Simon Arlott
