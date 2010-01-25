Return-Path: <linux-kernel-owner+w=401wt.eu-S1752731Ab0AYIqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab0AYIqb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 03:46:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493Ab0AYIqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 03:46:30 -0500
Received: from sh.osrg.net ([192.16.179.4]:60345 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407Ab0AYIqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 03:46:30 -0500
Date: Mon, 25 Jan 2010 17:46:14 +0900
To: akpm@linux-foundation.org
Cc: James.Bottomley@suse.de, davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation: remove deprecated function descriptions
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100125174423M.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 25 Jan 2010 17:46:16 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do we really need to have Documentation/DMA-API.txt and
Documentation/PCI/PCI-DMA-mapping.txt? A single document about DMA API
would be better?

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] Documentation: remove deprecated function descriptions

dma_sync_single, pci_dma_sync_single, dma_sync_sg, and pci_dma_sync_sg
are deprecated. We should not advertise them.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 Documentation/DMA-API.txt |   28 ----------------------------
 1 files changed, 0 insertions(+), 28 deletions(-)

diff --git a/Documentation/DMA-API.txt b/Documentation/DMA-API.txt
index 5aceb88..bb0e75e 100644
--- a/Documentation/DMA-API.txt
+++ b/Documentation/DMA-API.txt
@@ -364,34 +364,6 @@ API.
 Note: <nents> must be the number you passed in, *not* the number of
 physical entries returned.
 
-void
-dma_sync_single(struct device *dev, dma_addr_t dma_handle, size_t size,
-		enum dma_data_direction direction)
-void
-pci_dma_sync_single(struct pci_dev *hwdev, dma_addr_t dma_handle,
-			   size_t size, int direction)
-void
-dma_sync_sg(struct device *dev, struct scatterlist *sg, int nelems,
-			  enum dma_data_direction direction)
-void
-pci_dma_sync_sg(struct pci_dev *hwdev, struct scatterlist *sg,
-		       int nelems, int direction)
-
-Synchronise a single contiguous or scatter/gather mapping.  All the
-parameters must be the same as those passed into the single mapping
-API.
-
-Notes:  You must do this:
-
-- Before reading values that have been written by DMA from the device
-  (use the DMA_FROM_DEVICE direction)
-- After writing values that will be written to the device using DMA
-  (use the DMA_TO_DEVICE) direction
-- before *and* after handing memory to the device if the memory is
-  DMA_BIDIRECTIONAL
-
-See also dma_map_single().
-
 dma_addr_t
 dma_map_single_attrs(struct device *dev, void *cpu_addr, size_t size,
 		     enum dma_data_direction dir,
-- 
1.5.6.5

