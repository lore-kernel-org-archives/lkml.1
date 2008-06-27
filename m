Return-Path: <linux-kernel-owner+w=401wt.eu-S1761185AbYF0SBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761185AbYF0SBq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 14:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758003AbYF0SAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 14:00:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:38075 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757225AbYF0SAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 14:00:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,716,1204531200"; 
   d="scan'208";a="3658713"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [NET-NEXT PATCH 04/18] igb: fix parameter options
To: jeff@garzik.org, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       e1000-devel@lists.sourceforge.net
Date: Fri, 27 Jun 2008 11:00:07 -0700
Message-ID: <20080627180004.22428.4295.stgit@localhost.localdomain>
In-Reply-To: <20080627175921.22428.52767.stgit@localhost.localdomain>
References: <20080627175921.22428.52767.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jun 2008 18:00:08.0220 (UTC) FILETIME=[A2B3D5C0:01C8D87F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@intel.com>

Currently there are items in the driver to support parameters, but there
are no parameters being added to the driver.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---

 drivers/net/igb/igb_main.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/net/igb/igb_main.c b/drivers/net/igb/igb_main.c
index 9034339..bf083e3 100644
--- a/drivers/net/igb/igb_main.c
+++ b/drivers/net/igb/igb_main.c
@@ -836,7 +836,6 @@ static int __devinit igb_probe(struct pci_dev *pdev,
 	struct e1000_hw *hw;
 	const struct e1000_info *ei = igb_info_tbl[ent->driver_data];
 	unsigned long mmio_start, mmio_len;
-	static int cards_found;
 	int i, err, pci_using_dac;
 	u16 eeprom_data = 0;
 	u16 eeprom_apme_mask = IGB_EEPROM_APME;
@@ -918,8 +917,6 @@ static int __devinit igb_probe(struct pci_dev *pdev,
 	netdev->mem_start = mmio_start;
 	netdev->mem_end = mmio_start + mmio_len;
 
-	adapter->bd_number = cards_found;
-
 	/* PCI config space info */
 	hw->vendor_id = pdev->vendor;
 	hw->device_id = pdev->device;
@@ -1104,7 +1101,6 @@ static int __devinit igb_probe(struct pci_dev *pdev,
 		adapter->msi_enabled ? "MSI" : "legacy",
 		adapter->num_rx_queues, adapter->num_tx_queues);
 
-	cards_found++;
 	return 0;
 
 err_register:

