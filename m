Return-Path: <linux-kernel-owner+w=401wt.eu-S1764691AbZDHLoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764691AbZDHLoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932191AbZDHL2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:28:15 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:49243 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932144AbZDHL1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:27:54 -0400
X-Sasl-enc: 4JDLAml23VjJA6/2p6XpVDojkbXVmW9TLlr901Df7qbk 1239190073
From: Jack Stone <jwjstone@fastmail.fm>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, kernel-janitors@vger.kernel.org,
       Jack Stone <jwjstone@fastmail.fm>
Subject: [PATCH 50/56] drivers/staging: Remove void casts
Date: Wed,  8 Apr 2009 12:22:22 +0100
Message-Id: <1239189748-11703-51-git-send-email-jwjstone@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1239189748-11703-50-git-send-email-jwjstone@fastmail.fm>
References: <>
 <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-4-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-5-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-6-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-7-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-8-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-9-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-10-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-11-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-12-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-13-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-14-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-15-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-16-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-17-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-18-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-19-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-20-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-21-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-22-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-23-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-24-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-25-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-26-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-27-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-28-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-29-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-30-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-31-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-32-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-33-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-34-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-35-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-36-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-37-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-38-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-39-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-40-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-41-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-42-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-43-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-44-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-45-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-46-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-47-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-48-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-49-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-50-git-send-email-jwjstone@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove uneeded void casts

Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
---
 drivers/staging/altpciechdma/altpciechdma.c |    4 ++--
 drivers/staging/epl/EplApiLinuxKernel.c     |    8 ++------
 drivers/staging/et131x/et1310_rx.c          |    2 +-
 drivers/staging/rtl8187se/r8180_core.c      |   10 +++++-----
 drivers/staging/slicoss/slicoss.c           |    3 +--
 5 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/altpciechdma/altpciechdma.c b/drivers/staging/altpciechdma/altpciechdma.c
index 5869e14..f613a1d 100644
--- a/drivers/staging/altpciechdma/altpciechdma.c
+++ b/drivers/staging/altpciechdma/altpciechdma.c
@@ -535,7 +535,7 @@ static int __devinit dma_test(struct ape_dev *ape, struct pci_dev *dev)
 
 	/* allocate and map coherently-cached memory for a DMA-able buffer */
 	/* @see Documentation/PCI/PCI-DMA-mapping.txt, near line 318 */
-	buffer_virt = (u8 *)pci_alloc_consistent(dev, PAGE_SIZE * 4, &buffer_bus);
+	buffer_virt = pci_alloc_consistent(dev, PAGE_SIZE * 4, &buffer_bus);
 	if (!buffer_virt) {
 		printk(KERN_DEBUG "Could not allocate coherent DMA buffer.\n");
 		goto fail;
@@ -793,7 +793,7 @@ static int __devinit probe(struct pci_dev *dev, const struct pci_device_id *id)
 
 	/* allocate and map coherently-cached memory for a descriptor table */
 	/* @see LDD3 page 446 */
-	ape->table_virt = (struct ape_chdma_table *)pci_alloc_consistent(dev,
+	ape->table_virt = pci_alloc_consistent(dev,
 		APE_CHDMA_TABLE_SIZE, &ape->table_bus);
 	/* could not allocate table? */
 	if (!ape->table_virt) {
diff --git a/drivers/staging/epl/EplApiLinuxKernel.c b/drivers/staging/epl/EplApiLinuxKernel.c
index cb3e275..4c5dfcd 100644
--- a/drivers/staging/epl/EplApiLinuxKernel.c
+++ b/drivers/staging/epl/EplApiLinuxKernel.c
@@ -655,9 +655,7 @@ static int EplLinIoctl(struct inode *pDeviceFile_p,	// information about the dev
 				goto Exit;
 			}
 
-			pBufHeader =
-			    (tEplLinSdoBufHeader *)
-			    vmalloc(sizeof(tEplLinSdoBufHeader) +
+			pBufHeader = vmalloc(sizeof(tEplLinSdoBufHeader) +
 				    SdoObject.m_uiSize);
 			if (pBufHeader == NULL) {	// no memory available
 				iRet = -ENOMEM;
@@ -751,9 +749,7 @@ static int EplLinIoctl(struct inode *pDeviceFile_p,	// information about the dev
 				goto Exit;
 			}
 
-			pBufHeader =
-			    (tEplLinSdoBufHeader *)
-			    vmalloc(sizeof(tEplLinSdoBufHeader) +
+			pBufHeader = vmalloc(sizeof(tEplLinSdoBufHeader) +
 				    SdoObject.m_uiSize);
 			if (pBufHeader == NULL) {	// no memory available
 				iRet = -ENOMEM;
diff --git a/drivers/staging/et131x/et1310_rx.c b/drivers/staging/et131x/et1310_rx.c
index 8dc559a..4b1ace6 100644
--- a/drivers/staging/et131x/et1310_rx.c
+++ b/drivers/staging/et131x/et1310_rx.c
@@ -610,7 +610,7 @@ int et131x_init_recv(struct et131x_adapter *adapter)
 
 	/* Setup each RFD */
 	for (RfdCount = 0; RfdCount < rx_ring->NumRfd; RfdCount++) {
-		pMpRfd = (MP_RFD *) kmem_cache_alloc(rx_ring->RecvLookaside,
+		pMpRfd = kmem_cache_alloc(rx_ring->RecvLookaside,
 						     GFP_ATOMIC | GFP_DMA);
 
 		if (!pMpRfd) {
diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index 6ecd12d..6223371 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -1691,7 +1691,7 @@ int alloc_tx_beacon_desc_ring(struct net_device *dev, int count)
 	u32 *tmp;
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 
-	priv->txbeaconring = (u32*)pci_alloc_consistent(priv->pdev,
+	priv->txbeaconring = pci_alloc_consistent(priv->pdev,
 					  sizeof(u32)*8*count,
 					  &priv->txbeaconringdma);
 	if (!priv->txbeaconring) return -1;
@@ -1727,7 +1727,7 @@ short alloc_tx_desc_ring(struct net_device *dev, int bufsize, int count,
 		DMESGE ("TX buffer allocation too large");
 		return 0;
 	}
-	desc = (u32*)pci_alloc_consistent(pdev,
+	desc = pci_alloc_consistent(pdev,
 					  sizeof(u32)*8*count+256, &dma_desc);
 	if(desc==NULL) return -1;
 	if(dma_desc & 0xff){
@@ -1751,7 +1751,7 @@ short alloc_tx_desc_ring(struct net_device *dev, int bufsize, int count,
 	tmp=desc;
 	for (i=0;i<count;i++)
 	{
-		buf = (void*)pci_alloc_consistent(pdev,bufsize,&dma_tmp);
+		buf = pci_alloc_consistent(pdev,bufsize,&dma_tmp);
 		if (buf == NULL) return -ENOMEM;
 
 		switch(addr) {
@@ -1975,7 +1975,7 @@ short alloc_rx_desc_ring(struct net_device *dev, u16 bufsize, int count)
 		return -1;
 	}
 
-	desc = (u32*)pci_alloc_consistent(pdev,sizeof(u32)*rx_desc_size*count+256,
+	desc = pci_alloc_consistent(pdev,sizeof(u32)*rx_desc_size*count+256,
 					  &dma_desc);
 
 	if(dma_desc & 0xff){
@@ -2017,7 +2017,7 @@ short alloc_rx_desc_ring(struct net_device *dev, u16 bufsize, int count)
 		for(j=0;j<bufsize;j++) ((u8*)buf)[i] = 0;
 #endif
 
-		//buf = (void*)pci_alloc_consistent(pdev,bufsize,&dma_tmp);
+		//buf = pci_alloc_consistent(pdev,bufsize,&dma_tmp);
 		if(-1 == buffer_add(&(priv->rxbuffer), buf,dma_tmp,
 			   &(priv->rxbufferhead))){
 			   DMESGE("Unable to allocate mem RX buf");
diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index 9481563..746034c 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -333,8 +333,7 @@ static void slic_init_adapter(struct net_device *netdev,
 		pslic_handle->next = adapter->pfree_slic_handles;
 		adapter->pfree_slic_handles = pslic_handle;
 	}
-	adapter->pshmem = (struct slic_shmem *)
-					pci_alloc_consistent(adapter->pcidev,
+	adapter->pshmem = pci_alloc_consistent(adapter->pcidev,
 					sizeof(struct slic_shmem),
 					&adapter->
 					phys_shmem);
-- 
1.5.4.3

