Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932889Ab0BFRrc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 12:47:32 -0500
Received: from Cpsmtpm-eml109.kpnxchange.com ([195.121.3.13]:63436 "EHLO
	CPSMTPM-EML109.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932342Ab0BFRr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 12:47:27 -0500
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Cc: Frans Pop <elendil@planet.nl>, linux-parisc@vger.kernel.org,
       Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>
Subject: [PATCH 07/16] parisc: remove trailing space in messages
Date: Sat,  6 Feb 2010 18:47:14 +0100
Message-Id: <1265478443-31072-7-git-send-email-elendil@planet.nl>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <201002061844.45212.elendil@planet.nl>
References: <201002061844.45212.elendil@planet.nl>
X-OriginalArrivalTime: 06 Feb 2010 17:47:25.0633 (UTC) FILETIME=[71790B10:01CAA754]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: linux-parisc@vger.kernel.org
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
---
 arch/parisc/kernel/cache.c       |    4 ++--
 drivers/parisc/eisa_enumerator.c |    2 +-
 drivers/parisc/superio.c         |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/parisc/kernel/cache.c b/arch/parisc/kernel/cache.c
index b6ed34d..fc6c8cb 100644
--- a/arch/parisc/kernel/cache.c
+++ b/arch/parisc/kernel/cache.c
@@ -171,14 +171,14 @@ parisc_cache_init(void)
 		cache_info.ic_conf.cc_cst,
 		cache_info.ic_conf.cc_hv);
 
-	printk("D-TLB conf: sh %d page %d cst %d aid %d pad1 %d \n",
+	printk("D-TLB conf: sh %d page %d cst %d aid %d pad1 %d\n",
 		cache_info.dt_conf.tc_sh,
 		cache_info.dt_conf.tc_page,
 		cache_info.dt_conf.tc_cst,
 		cache_info.dt_conf.tc_aid,
 		cache_info.dt_conf.tc_pad1);
 
-	printk("I-TLB conf: sh %d page %d cst %d aid %d pad1 %d \n",
+	printk("I-TLB conf: sh %d page %d cst %d aid %d pad1 %d\n",
 		cache_info.it_conf.tc_sh,
 		cache_info.it_conf.tc_page,
 		cache_info.it_conf.tc_cst,
diff --git a/drivers/parisc/eisa_enumerator.c b/drivers/parisc/eisa_enumerator.c
index 0be1d50..caa1531 100644
--- a/drivers/parisc/eisa_enumerator.c
+++ b/drivers/parisc/eisa_enumerator.c
@@ -460,7 +460,7 @@ static int init_slot(int slot, struct eeprom_eisa_slot_info *es)
 			       slot, id_string);
 			
 			print_eisa_id(id_string, es->eisa_slot_id);
-			printk(" expected %s \n", id_string);
+			printk(" expected %s\n", id_string);
 		
 			return -1;	
 			
diff --git a/drivers/parisc/superio.c b/drivers/parisc/superio.c
index a35c9c5..f7806d8 100644
--- a/drivers/parisc/superio.c
+++ b/drivers/parisc/superio.c
@@ -169,7 +169,7 @@ superio_init(struct pci_dev *pcidev)
 	/* ...then properly fixup the USB to point at suckyio PIC */
 	sio->usb_pdev->irq = superio_fixup_irq(sio->usb_pdev);
 
-	printk(KERN_INFO PFX "Found NS87560 Legacy I/O device at %s (IRQ %i) \n",
+	printk(KERN_INFO PFX "Found NS87560 Legacy I/O device at %s (IRQ %i)\n",
 	       pci_name(pdev), pdev->irq);
 
 	pci_read_config_dword (pdev, SIO_SP1BAR, &sio->sp1_base);
-- 
1.6.6.1

