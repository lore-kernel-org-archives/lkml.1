Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933456Ab0CKRxP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 12:53:15 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:38074 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933436Ab0CKRxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 12:53:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=u3PfaeHqV18ZibwGLsecHbOfpPnAxR4yNcyhYk0dm/vdkxRMDIIkW5DFuROG5t2Q2o
         Gao7VWFn8Gr+5SCMKja4LptIXWdbZfLGAD2OnF6ROB0Vv4b8uqTfnBEseMKvDgqbTDri
         m3s2S8XLtE6xXyQL02lCVzIJKBVmAElWCIzHI=
From: Chihau Chau <chihau@gmail.com>
To: jbarnes@virtuousgeek.org
Cc: rjw@sisk.pl, kaneshige.kenji@jp.fujitsu.com, yu.zhao@intel.com,
       bjorn.helgaas@hp.com, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, Chihau Chau <chihau@gmail.com>
Subject: [PATCH] Drivers: pci: code style cleanup
Date: Thu, 11 Mar 2010 14:53:03 -0300
Message-Id: <1268329983-2603-1-git-send-email-chihau@gmail.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chihau Chau <chihau@gmail.com>

This is a code style cleanup related with spaces, like a lot of trailing
withspaces, spaces before a TAB, to use "foo * bar" instead of "foo *bar"
and to put a else sentence below close brace '}'.

Signed-off-by: Chihau Chau <chihau@gmail.com>
---
 drivers/pci/pci.c |   51 +++++++++++++++++++++++++--------------------------
 1 files changed, 25 insertions(+), 26 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 77b493b..d81d02e 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -79,7 +79,7 @@ u8 pci_cache_line_size;
  * Given a PCI bus, returns the highest PCI bus number present in the set
  * including the given PCI bus and its list of child PCI buses.
  */
-unsigned char pci_bus_max_busnr(struct pci_bus* bus)
+unsigned char pci_bus_max_busnr(struct pci_bus *bus)
 {
 	struct list_head *tmp;
 	unsigned char max, n;
@@ -87,7 +87,7 @@ unsigned char pci_bus_max_busnr(struct pci_bus* bus)
 	max = bus->subordinate;
 	list_for_each(tmp, &bus->children) {
 		n = pci_bus_max_busnr(pci_bus_b(tmp));
-		if(n > max)
+		if (n > max)
 			max = n;
 	}
 	return max;
@@ -126,7 +126,7 @@ pci_max_busnr(void)
 	max = 0;
 	while ((bus = pci_find_next_bus(bus)) != NULL) {
 		n = pci_bus_max_busnr(bus);
-		if(n > max)
+		if (n > max)
 			max = n;
 	}
 	return max;
@@ -195,7 +195,7 @@ static int __pci_bus_find_cap_start(struct pci_bus *bus,
 }
 
 /**
- * pci_find_capability - query for devices' capabilities 
+ * pci_find_capability - query for devices' capabilities
  * @dev: PCI device to query
  * @cap: capability code
  *
@@ -204,12 +204,12 @@ static int __pci_bus_find_cap_start(struct pci_bus *bus,
  * device's PCI configuration space or 0 in case the device does not
  * support it.  Possible values for @cap:
  *
- *  %PCI_CAP_ID_PM           Power Management 
- *  %PCI_CAP_ID_AGP          Accelerated Graphics Port 
- *  %PCI_CAP_ID_VPD          Vital Product Data 
- *  %PCI_CAP_ID_SLOTID       Slot Identification 
+ *  %PCI_CAP_ID_PM           Power Management
+ *  %PCI_CAP_ID_AGP          Accelerated Graphics Port
+ *  %PCI_CAP_ID_VPD          Vital Product Data
+ *  %PCI_CAP_ID_SLOTID       Slot Identification
  *  %PCI_CAP_ID_MSI          Message Signalled Interrupts
- *  %PCI_CAP_ID_CHSWP        CompactPCI HotSwap 
+ *  %PCI_CAP_ID_CHSWP        CompactPCI HotSwap
  *  %PCI_CAP_ID_PCIX         PCI-X
  *  %PCI_CAP_ID_EXP          PCI Express
  */
@@ -225,13 +225,13 @@ int pci_find_capability(struct pci_dev *dev, int cap)
 }
 
 /**
- * pci_bus_find_capability - query for devices' capabilities 
+ * pci_bus_find_capability - query for devices' capabilities
  * @bus:   the PCI bus to query
  * @devfn: PCI device to query
  * @cap:   capability code
  *
  * Like pci_find_capability() but works for pci devices that do not have a
- * pci_dev structure set up yet. 
+ * pci_dev structure set up yet.
  *
  * Returns the address of the requested capability structure within the
  * device's PCI configuration space or 0 in case the device does not
@@ -540,7 +540,7 @@ static int pci_raw_set_power_state(struct pci_dev *dev, pci_power_t state)
 		return -EINVAL;
 
 	/* Validate current state:
-	 * Can enter D0 from any state, but if we can only go deeper 
+	 * Can enter D0 from any state, but if we can only go deeper
 	 * to sleep if we're already in a low power state
 	 */
 	if (state != PCI_D0 && dev->current_state <= PCI_D3cold
@@ -923,11 +923,11 @@ pci_save_state(struct pci_dev *dev)
 	return 0;
 }
 
-/** 
+/**
  * pci_restore_state - Restore the saved state of a PCI device
  * @dev: - PCI device that we're dealing with
  */
-int 
+int
 pci_restore_state(struct pci_dev *dev)
 {
 	int i;
@@ -949,7 +949,7 @@ pci_restore_state(struct pci_dev *dev)
 			dev_printk(KERN_DEBUG, &dev->dev, "restoring config "
 				"space at offset %#x (was %#x, writing %#x)\n",
 				i, val, (int)dev->saved_config_space[i]);
-			pci_write_config_dword(dev,i * 4,
+			pci_write_config_dword(dev, i * 4,
 				dev->saved_config_space[i]);
 		}
 	}
@@ -1088,7 +1088,7 @@ static void pcim_release(struct device *gendev, void *res)
 		pci_disable_device(dev);
 }
 
-static struct pci_devres * get_pci_dr(struct pci_dev *pdev)
+static struct pci_devres *get_pci_dr(struct pci_dev *pdev)
 {
 	struct pci_devres *dr, *new_dr;
 
@@ -1102,7 +1102,7 @@ static struct pci_devres * get_pci_dr(struct pci_dev *pdev)
 	return devres_get(&pdev->dev, new_dr, NULL, NULL);
 }
 
-static struct pci_devres * find_pci_dr(struct pci_dev *pdev)
+static struct pci_devres *find_pci_dr(struct pci_dev *pdev)
 {
 	if (pci_is_managed(pdev))
 		return devres_find(&pdev->dev, pcim_release, NULL, NULL);
@@ -1892,7 +1892,7 @@ void pci_release_region(struct pci_dev *pdev, int bar)
  *
  *	If @exclusive is set, then the region is marked so that userspace
  *	is explicitly not allowed to map the resource via /dev/mem or
- * 	sysfs MMIO access.
+ *	sysfs MMIO access.
  *
  *	Returns 0 on success, or %EBUSY on error.  A warning
  *	message is also printed on failure.
@@ -1904,13 +1904,12 @@ static int __pci_request_region(struct pci_dev *pdev, int bar, const char *res_n
 
 	if (pci_resource_len(pdev, bar) == 0)
 		return 0;
-		
+
 	if (pci_resource_flags(pdev, bar) & IORESOURCE_IO) {
 		if (!request_region(pci_resource_start(pdev, bar),
 			    pci_resource_len(pdev, bar), res_name))
 			goto err_out;
-	}
-	else if (pci_resource_flags(pdev, bar) & IORESOURCE_MEM) {
+	} else if (pci_resource_flags(pdev, bar) & IORESOURCE_MEM) {
 		if (!__request_mem_region(pci_resource_start(pdev, bar),
 					pci_resource_len(pdev, bar), res_name,
 					exclusive))
@@ -1964,7 +1963,7 @@ int pci_request_region(struct pci_dev *pdev, int bar, const char *res_name)
  *
  *	The key difference that _exclusive makes it that userspace is
  *	explicitly not allowed to map the resource via /dev/mem or
- * 	sysfs.
+ *	sysfs.
  */
 int pci_request_region_exclusive(struct pci_dev *pdev, int bar, const char *res_name)
 {
@@ -1999,7 +1998,7 @@ int __pci_request_selected_regions(struct pci_dev *pdev, int bars,
 	return 0;
 
 err_out:
-	while(--i >= 0)
+	while (--i >= 0)
 		if (bars & (1 << i))
 			pci_release_region(pdev, i);
 
@@ -2069,7 +2068,7 @@ int pci_request_regions(struct pci_dev *pdev, const char *res_name)
  *	successfully.
  *
  *	pci_request_regions_exclusive() will mark the region so that
- * 	/dev/mem and the sysfs MMIO access will not be allowed.
+ *	/dev/mem and the sysfs MMIO access will not be allowed.
  *
  *	Returns 0 on success, or %EBUSY on error.  A warning
  *	message is also printed on failure.
@@ -2193,12 +2192,12 @@ pci_set_mwi(struct pci_dev *dev)
 		return rc;
 
 	pci_read_config_word(dev, PCI_COMMAND, &cmd);
-	if (! (cmd & PCI_COMMAND_INVALIDATE)) {
+	if (!(cmd & PCI_COMMAND_INVALIDATE)) {
 		dev_dbg(&dev->dev, "enabling Mem-Wr-Inval\n");
 		cmd |= PCI_COMMAND_INVALIDATE;
 		pci_write_config_word(dev, PCI_COMMAND, cmd);
 	}
-	
+
 	return 0;
 }
 
-- 
1.5.6.3

