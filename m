Return-Path: <linux-kernel-owner+w=401wt.eu-S1762808AbZCaP0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762808AbZCaP0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 11:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762380AbZCaPXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 11:23:55 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:22213 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762345AbZCaPXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 11:23:54 -0400
Subject: [PATCH 09/15] PCI Hotplug: cpqphp: style cleanups
To: jbarnes@virtuousgeek.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 31 Mar 2009 09:23:52 -0600
Message-ID: <20090331152351.26622.34567.stgit@bob.kio>
In-Reply-To: <20090331150158.26622.45423.stgit@bob.kio>
References: <20090331150158.26622.45423.stgit@bob.kio>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up style, whitespace in cpqphp_pci.c

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/hotplug/cpqphp_pci.c |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/pci/hotplug/cpqphp_pci.c b/drivers/pci/hotplug/cpqphp_pci.c
index 1f1c90d..bd384e9 100644
--- a/drivers/pci/hotplug/cpqphp_pci.c
+++ b/drivers/pci/hotplug/cpqphp_pci.c
@@ -950,15 +950,13 @@ int cpqhp_save_used_resources (struct controller *ctrl, struct pci_func * func)
 						return(1);
 				}
 			}	/* End of base register loop */
-		/* Some other unknown header type */
-		} else {
 		}
 
 		/* find the next device in this slot */
 		func = cpqhp_slot_find(func->bus, func->device, index++);
 	}
 
-	return(0);
+	return 0;
 }
 
 
@@ -993,9 +991,8 @@ int cpqhp_configure_board(struct controller *ctrl, struct pci_func * func)
 		/* Start at the top of config space so that the control
 		 * registers are programmed last
 		 */
-		for (cloop = 0x3C; cloop > 0; cloop -= 4) {
+		for (cloop = 0x3C; cloop > 0; cloop -= 4)
 			pci_bus_write_config_dword (pci_bus, devfn, cloop, func->config_space[cloop >> 2]);
-		}
 
 		pci_bus_read_config_byte (pci_bus, devfn, PCI_HEADER_TYPE, &header_type);
 
@@ -1210,9 +1207,9 @@ int cpqhp_find_available_resources(struct controller *ctrl, void __iomem *rom_st
 	rom_resource_table = detect_HRT_floating_pointer(rom_start, rom_start+0xffff);
 	dbg("rom_resource_table = %p\n", rom_resource_table);
 
-	if (rom_resource_table == NULL) {
+	if (rom_resource_table == NULL)
 		return -ENODEV;
-	}
+
 	/* Sum all resources and setup resource maps */
 	unused_IRQ = readl(rom_resource_table + UNUSED_IRQ);
 	dbg("unused_IRQ = %x\n", unused_IRQ);
@@ -1245,13 +1242,11 @@ int cpqhp_find_available_resources(struct controller *ctrl, void __iomem *rom_st
 
 	temp = 0;
 
-	if (!cpqhp_nic_irq) {
+	if (!cpqhp_nic_irq)
 		cpqhp_nic_irq = ctrl->cfgspc_irq;
-	}
 
-	if (!cpqhp_disk_irq) {
+	if (!cpqhp_disk_irq)
 		cpqhp_disk_irq = ctrl->cfgspc_irq;
-	}
 
 	dbg("cpqhp_disk_irq, cpqhp_nic_irq= %d, %d\n", cpqhp_disk_irq, cpqhp_nic_irq);
 

