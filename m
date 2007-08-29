Return-Path: <linux-kernel-owner+w=401wt.eu-S1760077AbXH2TEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760077AbXH2TEO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 15:04:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759090AbXH2TCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 15:02:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:29017 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758988AbXH2TCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 15:02:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,322,1183359600"; 
   d="scan'208";a="285630998"
From: Shannon Nelson <shannon.nelson@intel.com>
Subject: [PATCH v3 -mm 1/7] I/OAT: New device ids
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: shannon.nelson@intel.com
Date: Wed, 29 Aug 2007 12:01:34 -0700
Message-ID: <20070829190134.7367.79137.stgit@localhost.localdomain>
In-Reply-To: <20070829190112.7367.40989.stgit@localhost.localdomain>
References: <20070829190112.7367.40989.stgit@localhost.localdomain>
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
index 41b18c5..fdc8588 100644
--- a/drivers/dma/ioatdma.c
+++ b/drivers/dma/ioatdma.c
@@ -506,8 +506,9 @@ static enum dma_status ioat_dma_is_complete(struct dma_chan *chan,
 
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
index 06d23e1..c82a964 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2293,6 +2293,8 @@
 #define PCI_DEVICE_ID_INTEL_MCH_PC	0x3599
 #define PCI_DEVICE_ID_INTEL_MCH_PC1	0x359a
 #define PCI_DEVICE_ID_INTEL_E7525_MCH	0x359e
+#define PCI_DEVICE_ID_INTEL_IOAT_CNB	0x360b
+#define PCI_DEVICE_ID_INTEL_IOAT_SCNB	0x65ff
 #define PCI_DEVICE_ID_INTEL_82371SB_0	0x7000
 #define PCI_DEVICE_ID_INTEL_82371SB_1	0x7010
 #define PCI_DEVICE_ID_INTEL_82371SB_2	0x7020
