Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068Ab0CEOkz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 09:40:55 -0500
Received: from iron1.emtelworld.com ([196.192.81.95]:65148 "EHLO
	iron1.emtelworld.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab0CEOkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 09:40:53 -0500
X-Greylist: delayed 645 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Mar 2010 09:40:52 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAB+ekEvEwFEh/2dsb2JhbACbRXOoQ41mhH0EgxI
From: Michael Tate <michael.tate@wanadoo.fr>
To: gregkh@suse.de, alan@linux.intel.com, o.hartmann@telovital.com,
       michael.tate@wanadoo.fr
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] staging:et131x Fix line length coding style issue This patch fixes several line length > 80 warnings issued by checkpatch.pl Signed_off_by: Michael Tate <michael.tate@wanadoo.fr>
Date: Fri,  5 Mar 2010 18:29:11 +0400
Message-Id: <1267799351-5910-1-git-send-email-michael.tate@wanadoo.fr>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/et131x/et131x_initpci.c |   23 +++++++++++++++++------
 1 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/et131x/et131x_initpci.c b/drivers/staging/et131x/et131x_initpci.c
index 0892b6a..d080035 100644
--- a/drivers/staging/et131x/et131x_initpci.c
+++ b/drivers/staging/et131x/et131x_initpci.c
@@ -118,7 +118,13 @@
 static u32 et131x_speed_set;
 module_param(et131x_speed_set, uint, 0);
 MODULE_PARM_DESC(et131x_speed_set,
-		"Set Link speed and dublex manually (0-5)  [0] \n  1 : 10Mb   Half-Duplex \n  2 : 10Mb   Full-Duplex \n  3 : 100Mb  Half-Duplex \n  4 : 100Mb  Full-Duplex \n  5 : 1000Mb Full-Duplex \n 0 : Auto Speed Auto Dublex");
+		"Set Link speed and dublex manually (0-5)  [0] \n  \
+		1 : 10Mb   Half-Duplex \n  \
+		2 : 10Mb   Full-Duplex \n  \
+		3 : 100Mb  Half-Duplex \n  \
+		4 : 100Mb  Full-Duplex \n  \
+		5 : 1000Mb Full-Duplex \n \
+		0 : Auto Speed Auto Dublex");
 
 /**
  * et131x_hwaddr_init - set up the MAC Address on the ET1310
@@ -204,7 +210,8 @@ static int et131x_pci_init(struct et131x_adapter *adapter,
 		if (pci_write_config_word(pdev, ET1310_PCI_REPLAY,
 					       Replay[max_payload])) {
 			dev_err(&pdev->dev,
-			  "Could not write PCI config space for Replay Timer\n");
+				"Could not write PCI config space \
+					for Replay Timer\n");
 			return -EIO;
 		}
 	}
@@ -245,7 +252,8 @@ static int et131x_pci_init(struct et131x_adapter *adapter,
 	for (i = 0; i < ETH_ALEN; i++) {
 		if (pci_read_config_byte(pdev, ET1310_PCI_MAC_ADDRESS + i,
 					adapter->PermanentAddress + i)) {
-			dev_err(&pdev->dev, "Could not read PCI config space for MAC address\n");
+			dev_err(&pdev->dev, "Could not read PCI config space \
+						for MAC address\n");
 			return -EIO;
 		}
 	}
@@ -538,7 +546,9 @@ static struct et131x_adapter *et131x_adapter_init(struct net_device *netdev,
 
 	struct et131x_adapter *etdev;
 
-	/* Setup the fundamental net_device and private adapter structure elements  */
+	/* Setup the fundamental net_device
+	 * and private adapter structure elements
+	 */
 	SET_NETDEV_DEV(netdev, &pdev->dev);
 
 	/* Allocate private adapter struct and copy in relevant information */
@@ -654,7 +664,8 @@ static int __devinit et131x_pci_setup(struct pci_dev *pdev,
 		result = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
 		if (result != 0) {
 			dev_err(&pdev->dev,
-				  "Unable to obtain 64 bit DMA for consistent allocations\n");
+				"Unable to obtain 64 bit DMA \
+				for consistent allocations\n");
 			goto err_release_res;
 		}
 	} else if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
@@ -825,7 +836,7 @@ static int __init et131x_init_module(void)
 	if (et131x_speed_set < PARM_SPEED_DUPLEX_MIN ||
 	    et131x_speed_set > PARM_SPEED_DUPLEX_MAX) {
 		printk(KERN_WARNING "et131x: invalid speed setting ignored.\n");
-	    	et131x_speed_set = 0;
+		et131x_speed_set = 0;
 	}
 	return pci_register_driver(&et131x_driver);
 }
-- 
1.6.3.3

