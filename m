Return-Path: <linux-kernel-owner+w=401wt.eu-S933857AbXHXAPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933857AbXHXAPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 20:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933466AbXHXAPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 20:15:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:41790 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933330AbXHXAPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 20:15:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,302,1183359600"; 
   d="scan'208";a="267292286"
From: Shannon Nelson <shannon.nelson@intel.com>
Subject: [PATCH v2 -mm 1/7] I/OAT: New device ids
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, shannon.nelson@intel.com
Date: Thu, 23 Aug 2007 17:14:56 -0700
Message-ID: <20070824001456.16997.90825.stgit@localhost.localdomain>
In-Reply-To: <20070824001335.16997.79665.stgit@localhost.localdomain>
References: <20070824001335.16997.79665.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add device ids for new revs of the Intel I/OAT DMA engine

Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
Acked-by: David S. Miller <davem@davemloft.net>
---

 drivers/dma/ioatdma.c   |    5 +++--
 include/linux/pci_ids.h |    2 ++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/ioatdma.c b/drivers/dma/ioatdma.c
index 2d1f178..55227d4 100644
--- a/drivers/dma/ioatdma.c
+++ b/drivers/dma/ioatdma.c
@@ -516,8 +516,9 @@ static enum dma_status ioat_dma_is_complete(struct dma_chan *chan,
 
 static struct pci_device_id ioat_pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_UNISYS,
-		     PCI_DEVICE_ID_UNISYS_DMA_DIRECTOR) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_CNB)  },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_SCNB) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_UNISYS, PCI_DEVICE_ID_UNISYS_DMA_DIRECTOR) },
 	{ 0, }
 };
 
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 07fc574..d4883bd 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2287,6 +2287,8 @@
 #define PCI_DEVICE_ID_INTEL_MCH_PC	0x3599
 #define PCI_DEVICE_ID_INTEL_MCH_PC1	0x359a
 #define PCI_DEVICE_ID_INTEL_E7525_MCH	0x359e
+#define PCI_DEVICE_ID_INTEL_IOAT_CNB	0x360b
+#define PCI_DEVICE_ID_INTEL_IOAT_SCNB	0x65ff
 #define PCI_DEVICE_ID_INTEL_82371SB_0	0x7000
 #define PCI_DEVICE_ID_INTEL_82371SB_1	0x7010
 #define PCI_DEVICE_ID_INTEL_82371SB_2	0x7020
