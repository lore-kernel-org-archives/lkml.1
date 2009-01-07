Return-Path: <linux-kernel-owner+w=401wt.eu-S932508AbZAGWfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508AbZAGWfr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 17:35:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763116AbZAGWcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:32:22 -0500
Received: from an-out-0708.google.com ([209.85.132.249]:12844 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932338AbZAGWcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:32:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=UXboKJveiTCX1R1wREbBBivyA6rNfmTYC6rJ7I5pjvUCKl0AZ7ois3P2K3AKrajeWy
         Xg28z4/0IW4KqPzGou+frUtW+fYIASYbBaquFNp07gz15K2sPrUSUOXDIUP95GA9Mk+u
         48L/D7pHjDW5Uq2L8f6H64VPrN0Blc32awt2w=
Subject: [PATCH] staging: __FUNCTION__ is gcc-specific, use __func__
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 07 Jan 2009 14:31:57 -0800
Message-Id: <1231367517.5586.28.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/staging/comedi/drivers.c                   |    2 +-
 drivers/staging/epl/Edrv8139.c                     |   60 ++++++++++----------
 drivers/staging/epl/EplSdoAsySequ.c                |    2 +-
 drivers/staging/frontier/alphatrack.c              |   12 ++--
 drivers/staging/frontier/tranzport.c               |   22 ++++----
 drivers/staging/meilhaus/me0600_ext_irq.c          |    4 +-
 drivers/staging/meilhaus/me1400_ext_irq.c          |    2 +-
 drivers/staging/meilhaus/me1600_ao.c               |    4 +-
 drivers/staging/meilhaus/me4600_ai.c               |    8 +-
 drivers/staging/meilhaus/me4600_ao.c               |    6 +-
 drivers/staging/meilhaus/me4600_ext_irq.c          |    2 +-
 drivers/staging/meilhaus/me6000_ao.c               |   20 +++---
 drivers/staging/meilhaus/me8100_di.c               |    6 +-
 drivers/staging/meilhaus/me8200_di.c               |    4 +-
 drivers/staging/meilhaus/me8200_do.c               |    2 +-
 drivers/staging/meilhaus/medebug.h                 |   10 ++--
 drivers/staging/otus/80211core/cagg.c              |    2 +-
 drivers/staging/otus/80211core/pub_zfw.h           |    2 +-
 drivers/staging/otus/80211core/struct.h            |    2 +-
 drivers/staging/otus/oal_marc.h                    |   12 ++--
 drivers/staging/rt2860/2860_main_dev.c             |    2 +-
 drivers/staging/rt2860/common/ba_action.c          |   18 +++---
 drivers/staging/rt2860/common/cmm_data.c           |    2 +-
 drivers/staging/rt2860/common/cmm_data_2860.c      |    6 +-
 drivers/staging/rt2860/common/cmm_info.c           |    2 +-
 drivers/staging/rt2860/common/dfs.c                |    4 +-
 drivers/staging/rt2860/common/rtmp_init.c          |   18 +++---
 drivers/staging/rt2860/common/spectrum.c           |   44 +++++++-------
 drivers/staging/rt2860/rt_ate.c                    |   32 +++++-----
 drivers/staging/rt2860/rt_linux.c                  |   18 +++---
 drivers/staging/rt2860/rt_linux.h                  |    2 +-
 drivers/staging/rt2860/rt_profile.c                |   12 ++--
 drivers/staging/rt2860/rtmp_def.h                  |    2 +-
 drivers/staging/rt2860/sta_ioctl.c                 |   36 ++++++------
 drivers/staging/rt2870/2870_main_dev.c             |    6 +-
 drivers/staging/rt2870/common/2870_rtmp_init.c     |    4 +-
 drivers/staging/rt2870/common/ba_action.c          |   18 +++---
 drivers/staging/rt2870/common/cmm_data.c           |    2 +-
 drivers/staging/rt2870/common/cmm_info.c           |    2 +-
 drivers/staging/rt2870/common/dfs.c                |    4 +-
 drivers/staging/rt2870/common/rtmp_init.c          |   20 +++---
 drivers/staging/rt2870/common/rtusb_bulk.c         |    4 +-
 drivers/staging/rt2870/common/spectrum.c           |   44 +++++++-------
 drivers/staging/rt2870/rt_ate.c                    |   30 +++++-----
 drivers/staging/rt2870/rt_linux.c                  |   18 +++---
 drivers/staging/rt2870/rt_linux.h                  |    2 +-
 drivers/staging/rt2870/rt_main_dev.c               |    2 +-
 drivers/staging/rt2870/rt_profile.c                |   12 ++--
 drivers/staging/rt2870/rtmp_def.h                  |    2 +-
 drivers/staging/rt2870/sta_ioctl.c                 |   36 ++++++------
 drivers/staging/rt2870/tmp60                       |   36 ++++++------
 drivers/staging/rt2870/tmp61                       |   36 ++++++------
 drivers/staging/rtl8187se/ieee80211.h              |    2 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211.h    |    2 +-
 .../rtl8187se/ieee80211/ieee80211_crypt_ccmp.c     |    2 +-
 .../rtl8187se/ieee80211/ieee80211_crypt_tkip.c     |    2 +-
 .../rtl8187se/ieee80211/ieee80211_crypt_wep.c      |    2 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c |    2 +-
 .../rtl8187se/ieee80211/ieee80211_softmac.c        |    8 +-
 .../rtl8187se/ieee80211/ieee80211_softmac_wx.c     |    2 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c |    8 +-
 drivers/staging/rtl8187se/r8180_core.c             |   12 ++--
 drivers/staging/rtl8187se/r8180_rtl8225z2.c        |    4 +-
 drivers/staging/rtl8187se/r8180_wx.c               |   14 ++--
 64 files changed, 360 insertions(+), 360 deletions(-)

diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
index 06372b2..36a93b9 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -557,7 +557,7 @@ unsigned int comedi_buf_munge(comedi_async * async, unsigned int num_bytes)
 		block_size = num_bytes - count;
 		if (block_size < 0) {
 			rt_printk("%s: %s: bug! block_size is negative\n",
-				__FILE__, __FUNCTION__);
+				__FILE__, __func__);
 			break;
 		}
 		if ((int)(async->munge_ptr + block_size -
diff --git a/drivers/staging/epl/Edrv8139.c b/drivers/staging/epl/Edrv8139.c
index 88ab4a4..296354a 100644
--- a/drivers/staging/epl/Edrv8139.c
+++ b/drivers/staging/epl/Edrv8139.c
@@ -391,19 +391,19 @@ tEplKernel EdrvInit(tEdrvInitParam * pEdrvInitParam_p)
 	// register PCI driver
 	iResult = pci_register_driver(&EdrvDriver);
 	if (iResult != 0) {
-		printk("%s pci_register_driver failed with %d\n", __FUNCTION__,
+		printk("%s pci_register_driver failed with %d\n", __func__,
 		       iResult);
 		Ret = kEplNoResource;
 		goto Exit;
 	}
 
 	if (EdrvInstance_l.m_pPciDev == NULL) {
-		printk("%s m_pPciDev=NULL\n", __FUNCTION__);
+		printk("%s m_pPciDev=NULL\n", __func__);
 		Ret = kEplNoResource;
 		goto Exit;
 	}
 	// read MAC address from controller
-	printk("%s local MAC = ", __FUNCTION__);
+	printk("%s local MAC = ", __func__);
 	for (iResult = 0; iResult < 6; iResult++) {
 		pEdrvInitParam_p->m_abMyMacAddr[iResult] =
 		    EDRV_REGB_READ((EDRV_REGDW_IDR0 + iResult));
@@ -434,7 +434,7 @@ tEplKernel EdrvShutdown(void)
 {
 
 	// unregister PCI driver
-	printk("%s calling pci_unregister_driver()\n", __FUNCTION__);
+	printk("%s calling pci_unregister_driver()\n", __func__);
 	pci_unregister_driver(&EdrvDriver);
 
 	return kEplSuccessful;
@@ -621,7 +621,7 @@ tEplKernel EdrvSendTxMsg(tEdrvTxBuffer * pBuffer_p)
 		    EDRV_REGDW_READ((EDRV_REGDW_TSD0 +
 				     (EdrvInstance_l.m_uiCurTxDesc *
 				      sizeof(DWORD))));
-		printk("%s InvOp TSD%u = 0x%08lX", __FUNCTION__,
+		printk("%s InvOp TSD%u = 0x%08lX", __func__,
 		       EdrvInstance_l.m_uiCurTxDesc, dwTemp);
 		printk("  Cmd = 0x%02X\n",
 		       (WORD) EDRV_REGB_READ(EDRV_REGB_COMMAND));
@@ -646,7 +646,7 @@ tEplKernel EdrvSendTxMsg(tEdrvTxBuffer * pBuffer_p)
 	dwTemp =
 	    EDRV_REGDW_READ((EDRV_REGDW_TSAD0 +
 			     (EdrvInstance_l.m_uiCurTxDesc * sizeof(DWORD))));
-//    printk("%s TSAD%u = 0x%08lX", __FUNCTION__, EdrvInstance_l.m_uiCurTxDesc, dwTemp);
+//    printk("%s TSAD%u = 0x%08lX", __func__, EdrvInstance_l.m_uiCurTxDesc, dwTemp);
 
 	// start transmission
 	EDRV_REGDW_WRITE((EDRV_REGDW_TSD0 +
@@ -786,7 +786,7 @@ static int TgtEthIsr(int nIrqNum_p, void *ppDevInstData_p,
 
 		if (EdrvInstance_l.m_pbTxBuf == NULL) {
 			printk("%s Tx buffers currently not allocated\n",
-			       __FUNCTION__);
+			       __func__);
 			goto Exit;
 		}
 		// read transmit status
@@ -842,7 +842,7 @@ static int TgtEthIsr(int nIrqNum_p, void *ppDevInstData_p,
 
 		if (EdrvInstance_l.m_pbRxBuf == NULL) {
 			printk("%s Rx buffers currently not allocated\n",
-			       __FUNCTION__);
+			       __func__);
 			goto Exit;
 		}
 		// read current offset in receive buffer
@@ -944,7 +944,7 @@ static int EdrvInitOne(struct pci_dev *pPciDev, const struct pci_device_id *pId)
 	DWORD dwTemp;
 
 	if (EdrvInstance_l.m_pPciDev != NULL) {	// Edrv is already connected to a PCI device
-		printk("%s device %s discarded\n", __FUNCTION__,
+		printk("%s device %s discarded\n", __func__,
 		       pci_name(pPciDev));
 		iResult = -ENODEV;
 		goto Exit;
@@ -953,7 +953,7 @@ static int EdrvInitOne(struct pci_dev *pPciDev, const struct pci_device_id *pId)
 	if (pPciDev->revision >= 0x20) {
 		printk
 		    ("%s device %s is an enhanced 8139C+ version, which is not supported\n",
-		     __FUNCTION__, pci_name(pPciDev));
+		     __func__, pci_name(pPciDev));
 		iResult = -ENODEV;
 		goto Exit;
 	}
@@ -961,7 +961,7 @@ static int EdrvInitOne(struct pci_dev *pPciDev, const struct pci_device_id *pId)
 	EdrvInstance_l.m_pPciDev = pPciDev;
 
 	// enable device
-	printk("%s enable device\n", __FUNCTION__);
+	printk("%s enable device\n", __func__);
 	iResult = pci_enable_device(pPciDev);
 	if (iResult != 0) {
 		goto Exit;
@@ -972,13 +972,13 @@ static int EdrvInitOne(struct pci_dev *pPciDev, const struct pci_device_id *pId)
 		goto Exit;
 	}
 
-	printk("%s request regions\n", __FUNCTION__);
+	printk("%s request regions\n", __func__);
 	iResult = pci_request_regions(pPciDev, DRV_NAME);
 	if (iResult != 0) {
 		goto Exit;
 	}
 
-	printk("%s ioremap\n", __FUNCTION__);
+	printk("%s ioremap\n", __func__);
 	EdrvInstance_l.m_pIoAddr =
 	    ioremap(pci_resource_start(pPciDev, 1),
 		    pci_resource_len(pPciDev, 1));
@@ -987,11 +987,11 @@ static int EdrvInitOne(struct pci_dev *pPciDev, const struct pci_device_id *pId)
 		goto Exit;
 	}
 	// enable PCI busmaster
-	printk("%s enable busmaster\n", __FUNCTION__);
+	printk("%s enable busmaster\n", __func__);
 	pci_set_master(pPciDev);
 
 	// reset controller
-	printk("%s reset controller\n", __FUNCTION__);
+	printk("%s reset controller\n", __func__);
 	EDRV_REGB_WRITE(EDRV_REGB_COMMAND, EDRV_REGB_COMMAND_RST);
 
 	// wait until reset has finished
@@ -1008,20 +1008,20 @@ static int EdrvInitOne(struct pci_dev *pPciDev, const struct pci_device_id *pId)
 	dwTemp = EDRV_REGDW_READ(EDRV_REGDW_TCR);
 	if (((dwTemp & EDRV_REGDW_TCR_VER_MASK) != EDRV_REGDW_TCR_VER_C)
 	    && ((dwTemp & EDRV_REGDW_TCR_VER_MASK) != EDRV_REGDW_TCR_VER_D)) {	// unsupported chip
-		printk("%s Unsupported chip! TCR = 0x%08lX\n", __FUNCTION__,
+		printk("%s Unsupported chip! TCR = 0x%08lX\n", __func__,
 		       dwTemp);
 		iResult = -ENODEV;
 		goto Exit;
 	}
 	// disable interrupts
-	printk("%s disable interrupts\n", __FUNCTION__);
+	printk("%s disable interrupts\n", __func__);
 	EDRV_REGW_WRITE(EDRV_REGW_INT_MASK, 0);
 	// acknowledge all pending interrupts
 	EDRV_REGW_WRITE(EDRV_REGW_INT_STATUS,
 			EDRV_REGW_READ(EDRV_REGW_INT_STATUS));
 
 	// install interrupt handler
-	printk("%s install interrupt handler\n", __FUNCTION__);
+	printk("%s install interrupt handler\n", __func__);
 	iResult =
 	    request_irq(pPciDev->irq, TgtEthIsr, IRQF_SHARED,
 			DRV_NAME /*pPciDev->dev.name */ , pPciDev);
@@ -1031,16 +1031,16 @@ static int EdrvInitOne(struct pci_dev *pPciDev, const struct pci_device_id *pId)
 
 /*
     // unlock configuration registers
-    printk("%s unlock configuration registers\n", __FUNCTION__);
+    printk("%s unlock configuration registers\n", __func__);
     EDRV_REGB_WRITE(EDRV_REGB_CMD9346, EDRV_REGB_CMD9346_UNLOCK);
 
     // check if user specified a MAC address
-    printk("%s check specified MAC address\n", __FUNCTION__);
+    printk("%s check specified MAC address\n", __func__);
     for (iResult = 0; iResult < 6; iResult++)
     {
         if (EdrvInstance_l.m_InitParam.m_abMyMacAddr[iResult] != 0)
         {
-            printk("%s set local MAC address\n", __FUNCTION__);
+            printk("%s set local MAC address\n", __func__);
             // write this MAC address to controller
             EDRV_REGDW_WRITE(EDRV_REGDW_IDR0,
                 le32_to_cpu(*((DWORD*)&EdrvInstance_l.m_InitParam.m_abMyMacAddr[0])));
@@ -1059,7 +1059,7 @@ static int EdrvInitOne(struct pci_dev *pPciDev, const struct pci_device_id *pId)
 */
 
 	// allocate buffers
-	printk("%s allocate buffers\n", __FUNCTION__);
+	printk("%s allocate buffers\n", __func__);
 	EdrvInstance_l.m_pbTxBuf =
 	    pci_alloc_consistent(pPciDev, EDRV_TX_BUFFER_SIZE,
 				 &EdrvInstance_l.m_pTxBufDma);
@@ -1076,7 +1076,7 @@ static int EdrvInitOne(struct pci_dev *pPciDev, const struct pci_device_id *pId)
 		goto Exit;
 	}
 	// reset pointers for Tx buffers
-	printk("%s reset pointers fo Tx buffers\n", __FUNCTION__);
+	printk("%s reset pointers fo Tx buffers\n", __func__);
 	EDRV_REGDW_WRITE(EDRV_REGDW_TSAD0, 0);
 	dwTemp = EDRV_REGDW_READ(EDRV_REGDW_TSAD0);
 	EDRV_REGDW_WRITE(EDRV_REGDW_TSAD1, 0);
@@ -1090,11 +1090,11 @@ static int EdrvInitOne(struct pci_dev *pPciDev, const struct pci_device_id *pId)
 	       (WORD) EDRV_REGB_READ(EDRV_REGB_COMMAND));
 
 	// set pointer for receive buffer in controller
-	printk("%s set pointer to Rx buffer\n", __FUNCTION__);
+	printk("%s set pointer to Rx buffer\n", __func__);
 	EDRV_REGDW_WRITE(EDRV_REGDW_RBSTART, EdrvInstance_l.m_pRxBufDma);
 
 	// enable transmitter and receiver
-	printk("%s enable Tx and Rx", __FUNCTION__);
+	printk("%s enable Tx and Rx", __func__);
 	EDRV_REGB_WRITE(EDRV_REGB_COMMAND,
 			(EDRV_REGB_COMMAND_RE | EDRV_REGB_COMMAND_TE));
 	printk("  Command = 0x%02X\n",
@@ -1104,12 +1104,12 @@ static int EdrvInitOne(struct pci_dev *pPciDev, const struct pci_device_id *pId)
 	EDRV_REGDW_WRITE(EDRV_REGDW_MPC, 0);
 
 	// set transmit configuration register
-	printk("%s set Tx conf register", __FUNCTION__);
+	printk("%s set Tx conf register", __func__);
 	EDRV_REGDW_WRITE(EDRV_REGDW_TCR, EDRV_REGDW_TCR_DEF);
 	printk(" = 0x%08X\n", EDRV_REGDW_READ(EDRV_REGDW_TCR));
 
 	// set receive configuration register
-	printk("%s set Rx conf register", __FUNCTION__);
+	printk("%s set Rx conf register", __func__);
 	EDRV_REGDW_WRITE(EDRV_REGDW_RCR, EDRV_REGDW_RCR_DEF);
 	printk(" = 0x%08X\n", EDRV_REGDW_READ(EDRV_REGDW_RCR));
 
@@ -1121,7 +1121,7 @@ static int EdrvInitOne(struct pci_dev *pPciDev, const struct pci_device_id *pId)
 
 /*
     // enable transmitter and receiver
-    printk("%s enable Tx and Rx", __FUNCTION__);
+    printk("%s enable Tx and Rx", __func__);
     EDRV_REGB_WRITE(EDRV_REGB_COMMAND, (EDRV_REGB_COMMAND_RE | EDRV_REGB_COMMAND_TE));
     printk("  Command = 0x%02X\n", (WORD) EDRV_REGB_READ(EDRV_REGB_COMMAND));
 */
@@ -1129,11 +1129,11 @@ static int EdrvInitOne(struct pci_dev *pPciDev, const struct pci_device_id *pId)
 	EDRV_REGW_WRITE(EDRV_REGW_MULINT, 0);
 
 	// enable interrupts
-	printk("%s enable interrupts\n", __FUNCTION__);
+	printk("%s enable interrupts\n", __func__);
 	EDRV_REGW_WRITE(EDRV_REGW_INT_MASK, EDRV_REGW_INT_MASK_DEF);
 
       Exit:
-	printk("%s finished with %d\n", __FUNCTION__, iResult);
+	printk("%s finished with %d\n", __func__, iResult);
 	return iResult;
 }
 
diff --git a/drivers/staging/epl/EplSdoAsySequ.c b/drivers/staging/epl/EplSdoAsySequ.c
index 991c6be..6b6a997 100644
--- a/drivers/staging/epl/EplSdoAsySequ.c
+++ b/drivers/staging/epl/EplSdoAsySequ.c
@@ -876,7 +876,7 @@ static tEplKernel EplSdoAsySeqProcess(unsigned int uiHandle_p,
 				{
 /*
                     PRINTF3("%s scon=%u rcon=%u\n",
-                            __FUNCTION__,
+                            __func__,
                             pRecFrame_p->m_le_bSendSeqNumCon,
                             pRecFrame_p->m_le_bRecSeqNumCon);
 */
diff --git a/drivers/staging/frontier/alphatrack.c b/drivers/staging/frontier/alphatrack.c
index 61d7c5d..6136e3f 100644
--- a/drivers/staging/frontier/alphatrack.c
+++ b/drivers/staging/frontier/alphatrack.c
@@ -239,7 +239,7 @@ static void usb_alphatrack_interrupt_in_callback(struct urb *urb)
 			goto exit;
 		} else {
 			dbg_info(&dev->intf->dev, "%s: nonzero status received: %d\n",
-				 __FUNCTION__, urb->status);
+				 __func__, urb->status);
 			goto resubmit; /* maybe we can recover */
 		}
 	}
@@ -261,7 +261,7 @@ static void usb_alphatrack_interrupt_in_callback(struct urb *urb)
 		if(dev->offline > 0 && dev->interrupt_in_buffer[1] != 0xff) { dev->offline = 0; }
 		if(dev->offline == 0 && dev->interrupt_in_buffer[1] == 0xff) { dev->offline = 1; }
 #endif
-		dbg_info(&dev->intf->dev, "%s: head, tail are %x, %x\n", __FUNCTION__,dev->ring_head,dev->ring_tail);
+		dbg_info(&dev->intf->dev, "%s: head, tail are %x, %x\n", __func__,dev->ring_head,dev->ring_tail);
 		next_ring_head = (dev->ring_head+1) % ring_buffer_size;
 
 		if (next_ring_head != dev->ring_tail) {
@@ -305,7 +305,7 @@ static void usb_alphatrack_interrupt_out_callback(struct urb *urb)
 			     urb->status == -ESHUTDOWN))
 		dbg_info(&dev->intf->dev,
 			 "%s - nonzero write interrupt status received: %d\n",
-			 __FUNCTION__, urb->status);
+			 __func__, urb->status);
 	atomic_dec(&dev->writes_pending);
 	dev->interrupt_out_busy = 0;
 	wake_up_interruptible(&dev->write_wait);
@@ -330,7 +330,7 @@ static int usb_alphatrack_open(struct inode *inode, struct file *file)
 
 	if (!interface) {
 		err("%s - error, can't find device for minor %d\n",
-		     __FUNCTION__, subminor);
+		     __func__, subminor);
 		retval = -ENODEV;
 		goto unlock_disconnect_exit;
 	}
@@ -514,7 +514,7 @@ static ssize_t usb_alphatrack_read(struct file *file, char __user *buffer, size_
 						 }
 						 dev->ring_tail = (dev->ring_tail+1) % ring_buffer_size;
 						 c+=INPUT_CMD_SIZE;
-						 dbg_info(&dev->intf->dev, "%s: head, tail are %x, %x\n", __FUNCTION__,dev->ring_head,dev->ring_tail);
+						 dbg_info(&dev->intf->dev, "%s: head, tail are %x, %x\n", __func__,dev->ring_head,dev->ring_tail);
 	   }
 	   retval = c;
 
@@ -573,7 +573,7 @@ static ssize_t usb_alphatrack_write(struct file *file, const char __user *buffer
 	if (bytes_to_write < count)
 		dev_warn(&dev->intf->dev, "Write buffer overflow, %zd bytes dropped\n",count-bytes_to_write);
 
-	dbg_info(&dev->intf->dev, "%s: count = %zd, bytes_to_write = %zd\n", __FUNCTION__, count, bytes_to_write);
+	dbg_info(&dev->intf->dev, "%s: count = %zd, bytes_to_write = %zd\n", __func__, count, bytes_to_write);
 
 	if (copy_from_user(dev->interrupt_out_buffer, buffer, bytes_to_write)) {
 		retval = -EFAULT;
diff --git a/drivers/staging/frontier/tranzport.c b/drivers/staging/frontier/tranzport.c
index 275faa7..79abb6b 100644
--- a/drivers/staging/frontier/tranzport.c
+++ b/drivers/staging/frontier/tranzport.c
@@ -335,7 +335,7 @@ static void usb_tranzport_interrupt_in_callback(struct urb *urb)
 			goto exit;
 		} else {
 			dbg_info(&dev->intf->dev, "%s: nonzero status received: %d\n",
-				 __FUNCTION__, urb->status);
+				 __func__, urb->status);
 			goto resubmit; /* maybe we can recover */
 		}
 	}
@@ -345,7 +345,7 @@ static void usb_tranzport_interrupt_in_callback(struct urb *urb)
 			 "Urb length was %d bytes!! Do something intelligent \n", urb->actual_length);
 	} else {
 		dbg_info(&dev->intf->dev, "%s: received: %02x%02x%02x%02x%02x%02x%02x%02x\n",
-			 __FUNCTION__, dev->interrupt_in_buffer[0],dev->interrupt_in_buffer[1],dev->interrupt_in_buffer[2],dev->interrupt_in_buffer[3],dev->interrupt_in_buffer[4],dev->interrupt_in_buffer[5],dev->interrupt_in_buffer[6],dev->interrupt_in_buffer[7]);
+			 __func__, dev->interrupt_in_buffer[0],dev->interrupt_in_buffer[1],dev->interrupt_in_buffer[2],dev->interrupt_in_buffer[3],dev->interrupt_in_buffer[4],dev->interrupt_in_buffer[5],dev->interrupt_in_buffer[6],dev->interrupt_in_buffer[7]);
 #if SUPPRESS_EXTRA_OFFLINE_EVENTS
 		if(dev->offline == 2 && dev->interrupt_in_buffer[1] == 0xff) { goto resubmit; }
 		if(dev->offline == 1 && dev->interrupt_in_buffer[1] == 0xff) { dev->offline = 2; goto resubmit; }
@@ -355,7 +355,7 @@ static void usb_tranzport_interrupt_in_callback(struct urb *urb)
 		if(dev->offline == 0 && dev->interrupt_in_buffer[1] == 0xff) { dev->offline = 1; }
 
 #endif
-		dbg_info(&dev->intf->dev, "%s: head, tail are %x, %x\n", __FUNCTION__,dev->ring_head,dev->ring_tail);
+		dbg_info(&dev->intf->dev, "%s: head, tail are %x, %x\n", __func__,dev->ring_head,dev->ring_tail);
 
 		next_ring_head = (dev->ring_head+1) % ring_buffer_size;
 
@@ -399,7 +399,7 @@ static void usb_tranzport_interrupt_out_callback(struct urb *urb)
 			     urb->status == -ESHUTDOWN))
 		dbg_info(&dev->intf->dev,
 			 "%s - nonzero write interrupt status received: %d\n",
-			 __FUNCTION__, urb->status);
+			 __func__, urb->status);
 
 	dev->interrupt_out_busy = 0;
 	wake_up_interruptible(&dev->write_wait);
@@ -424,7 +424,7 @@ static int usb_tranzport_open(struct inode *inode, struct file *file)
 
 	if (!interface) {
 		err("%s - error, can't find device for minor %d\n",
-		     __FUNCTION__, subminor);
+		     __func__, subminor);
 		retval = -ENODEV;
 		goto unlock_disconnect_exit;
 	}
@@ -613,7 +613,7 @@ static ssize_t usb_tranzport_read(struct file *file, char __user *buffer, size_t
 	}
 
 	dbg_info(&dev->intf->dev, "%s: copying to userspace: %02x%02x%02x%02x%02x%02x%02x%02x\n",
-			 __FUNCTION__, (*dev->ring_buffer)[dev->ring_tail].cmd[0],(*dev->ring_buffer)[dev->ring_tail].cmd[1],(*dev->ring_buffer)[dev->ring_tail].cmd[2],(*dev->ring_buffer)[dev->ring_tail].cmd[3],(*dev->ring_buffer)[dev->ring_tail].cmd[4],(*dev->ring_buffer)[dev->ring_tail].cmd[5],(*dev->ring_buffer)[dev->ring_tail].cmd[6],(*dev->ring_buffer)[dev->ring_tail].cmd[7]);
+			 __func__, (*dev->ring_buffer)[dev->ring_tail].cmd[0],(*dev->ring_buffer)[dev->ring_tail].cmd[1],(*dev->ring_buffer)[dev->ring_tail].cmd[2],(*dev->ring_buffer)[dev->ring_tail].cmd[3],(*dev->ring_buffer)[dev->ring_tail].cmd[4],(*dev->ring_buffer)[dev->ring_tail].cmd[5],(*dev->ring_buffer)[dev->ring_tail].cmd[6],(*dev->ring_buffer)[dev->ring_tail].cmd[7]);
 
 #if BUFFERED_READS
 	   c = 0;
@@ -632,7 +632,7 @@ static ssize_t usb_tranzport_read(struct file *file, char __user *buffer, size_t
 			// FIXME the math is wrong for going in reverse, actually, as the midi spec doesn't allow signed chars
 
 	dbg_info(&dev->intf->dev, "%s: trying to compress: %02x%02x%02x%02x%02x %02x %02x %02x\n",
-			 __FUNCTION__, (*dev->ring_buffer)[dev->ring_tail].cmd[0],(*dev->ring_buffer)[dev->ring_tail].cmd[1],(*dev->ring_buffer)[dev->ring_tail].cmd[2],(*dev->ring_buffer)[dev->ring_tail].cmd[3],(*dev->ring_buffer)[dev->ring_tail].cmd[4],(*dev->ring_buffer)[dev->ring_tail].cmd[5],(*dev->ring_buffer)[dev->ring_tail].cmd[6],(*dev->ring_buffer)[dev->ring_tail].cmd[7]);
+			 __func__, (*dev->ring_buffer)[dev->ring_tail].cmd[0],(*dev->ring_buffer)[dev->ring_tail].cmd[1],(*dev->ring_buffer)[dev->ring_tail].cmd[2],(*dev->ring_buffer)[dev->ring_tail].cmd[3],(*dev->ring_buffer)[dev->ring_tail].cmd[4],(*dev->ring_buffer)[dev->ring_tail].cmd[5],(*dev->ring_buffer)[dev->ring_tail].cmd[6],(*dev->ring_buffer)[dev->ring_tail].cmd[7]);
 
 
 			if(((*dev->ring_buffer)[dev->ring_tail].cmd[6] != 0 &&
@@ -645,7 +645,7 @@ static ssize_t usb_tranzport_read(struct file *file, char __user *buffer, size_t
 				((*dev->ring_buffer)[dev->ring_tail].cmd[5] == (*dev->ring_buffer)[next_tail].cmd[5]))
  {
 	dbg_info(&dev->intf->dev, "%s: should compress: %02x%02x%02x%02x%02x%02x%02x%02x\n",
-			 __FUNCTION__, (*dev->ring_buffer)[dev->ring_tail].cmd[0],(*dev->ring_buffer)[dev->ring_tail].cmd[1],(*dev->ring_buffer)[dev->ring_tail].cmd[2],(*dev->ring_buffer)[dev->ring_tail].cmd[3],(*dev->ring_buffer)[dev->ring_tail].cmd[4],(*dev->ring_buffer)[dev->ring_tail].cmd[5],(*dev->ring_buffer)[dev->ring_tail].cmd[6],(*dev->ring_buffer)[dev->ring_tail].cmd[7]);
+			 __func__, (*dev->ring_buffer)[dev->ring_tail].cmd[0],(*dev->ring_buffer)[dev->ring_tail].cmd[1],(*dev->ring_buffer)[dev->ring_tail].cmd[2],(*dev->ring_buffer)[dev->ring_tail].cmd[3],(*dev->ring_buffer)[dev->ring_tail].cmd[4],(*dev->ring_buffer)[dev->ring_tail].cmd[5],(*dev->ring_buffer)[dev->ring_tail].cmd[6],(*dev->ring_buffer)[dev->ring_tail].cmd[7]);
 
 				newwheel += oldwheel;
 				if(oldwheel > 0 && !(newwheel > 0)) {
@@ -673,7 +673,7 @@ static ssize_t usb_tranzport_read(struct file *file, char __user *buffer, size_t
 
 		dev->ring_tail = (dev->ring_tail+1) % ring_buffer_size;
 		c+=8;
-		dbg_info(&dev->intf->dev, "%s: head, tail are %x, %x\n", __FUNCTION__,dev->ring_head,dev->ring_tail);
+		dbg_info(&dev->intf->dev, "%s: head, tail are %x, %x\n", __func__,dev->ring_head,dev->ring_tail);
 	   }
 	   retval = c;
 
@@ -684,7 +684,7 @@ static ssize_t usb_tranzport_read(struct file *file, char __user *buffer, size_t
 	}
 
 	dev->ring_tail = (dev->ring_tail+1) % ring_buffer_size;
-	dbg_info(&dev->intf->dev, "%s: head, tail are %x, %x\n", __FUNCTION__,dev->ring_head,dev->ring_tail);
+	dbg_info(&dev->intf->dev, "%s: head, tail are %x, %x\n", __func__,dev->ring_head,dev->ring_tail);
 
 	retval = 8;
 #endif /* BUFFERED_READS */
@@ -743,7 +743,7 @@ static ssize_t usb_tranzport_write(struct file *file, const char __user *buffer,
 	if (bytes_to_write < count)
 		dev_warn(&dev->intf->dev, "Write buffer overflow, %zd bytes dropped\n",count-bytes_to_write);
 
-	dbg_info(&dev->intf->dev, "%s: count = %zd, bytes_to_write = %zd\n", __FUNCTION__, count, bytes_to_write);
+	dbg_info(&dev->intf->dev, "%s: count = %zd, bytes_to_write = %zd\n", __func__, count, bytes_to_write);
 
 	if (copy_from_user(dev->interrupt_out_buffer, buffer, bytes_to_write)) {
 		retval = -EFAULT;
diff --git a/drivers/staging/meilhaus/me0600_ext_irq.c b/drivers/staging/meilhaus/me0600_ext_irq.c
index a449ab2..eba18ad 100644
--- a/drivers/staging/meilhaus/me0600_ext_irq.c
+++ b/drivers/staging/meilhaus/me0600_ext_irq.c
@@ -360,7 +360,7 @@ static irqreturn_t me0600_isr(int irq, void *dev_id, struct pt_regs *regs)
 	if (instance->lintno > 1) {
 		PERROR_CRITICAL
 		    ("%s():Wrong subdevice index=%d plx:irq_status_reg=0x%04X.\n",
-		     __FUNCTION__, instance->lintno, inl(instance->intcsr));
+		     __func__, instance->lintno, inl(instance->intcsr));
 		return IRQ_NONE;
 	}
 
@@ -384,7 +384,7 @@ static irqreturn_t me0600_isr(int irq, void *dev_id, struct pt_regs *regs)
 	} else {
 		PINFO
 		    ("%ld Shared interrupt. %s(): idx=0 plx:irq_status_reg=0x%04X\n",
-		     jiffies, __FUNCTION__, status);
+		     jiffies, __func__, status);
 		ret = IRQ_NONE;
 	}
 	spin_unlock(instance->intcsr_lock);
diff --git a/drivers/staging/meilhaus/me1400_ext_irq.c b/drivers/staging/meilhaus/me1400_ext_irq.c
index b8c2696..b4df7cc 100644
--- a/drivers/staging/meilhaus/me1400_ext_irq.c
+++ b/drivers/staging/meilhaus/me1400_ext_irq.c
@@ -349,7 +349,7 @@ static irqreturn_t me1400_ext_irq_isr(int irq, void *dev_id,
 	    (PLX_LOCAL_INT1_STATE | PLX_LOCAL_INT1_EN | PLX_PCI_INT_EN)) {
 		spin_unlock(&instance->subdevice_lock);
 		PINFO("%ld Shared interrupt. %s(): irq_status_reg=0x%04X\n",
-		      jiffies, __FUNCTION__, status);
+		      jiffies, __func__, status);
 		return IRQ_NONE;
 	}
 
diff --git a/drivers/staging/meilhaus/me1600_ao.c b/drivers/staging/meilhaus/me1600_ao.c
index 6f26665..d127c6b 100644
--- a/drivers/staging/meilhaus/me1600_ao.c
+++ b/drivers/staging/meilhaus/me1600_ao.c
@@ -977,7 +977,7 @@ static void me1600_ao_work_control_task(struct work_struct *work)
 	    container_of((void *)work, me1600_ao_subdevice_t, ao_control_task);
 #endif
 
-	PINFO("<%s: %ld> executed. idx=%d\n", __FUNCTION__, jiffies,
+	PINFO("<%s: %ld> executed. idx=%d\n", __func__, jiffies,
 	      instance->ao_idx);
 
 	if (!((instance->ao_regs_shadows)->trigger & instance->ao_idx)) {	// Output was triggerd.
@@ -1027,7 +1027,7 @@ static void me1600_ao_work_control_task(struct work_struct *work)
 		queue_delayed_work(instance->me1600_workqueue,
 				   &instance->ao_control_task, 1);
 	} else {
-		PINFO("<%s> Ending control task.\n", __FUNCTION__);
+		PINFO("<%s> Ending control task.\n", __func__);
 	}
 
 }
diff --git a/drivers/staging/meilhaus/me4600_ai.c b/drivers/staging/meilhaus/me4600_ai.c
index 1a0de5d..0a8c9d7 100644
--- a/drivers/staging/meilhaus/me4600_ai.c
+++ b/drivers/staging/meilhaus/me4600_ai.c
@@ -2629,11 +2629,11 @@ static irqreturn_t me4600_ai_isr(int irq, void *dev_id, struct pt_regs *regs)
 		if ((irq_status & (ME4600_IRQ_STATUS_BIT_AI_HF | ME4600_IRQ_STATUS_BIT_SC | ME4600_IRQ_STATUS_BIT_LE)) == ME4600_IRQ_STATUS_BIT_LE) {	//This is security check case. LE is unused. This should never ever happend.
 			PINFO
 			    ("%ld Shared interrupt. %s(): irq_status_reg=LE_IRQ\n",
-			     jiffies, __FUNCTION__);
+			     jiffies, __func__);
 		} else {
 			PINFO
 			    ("%ld Shared interrupt. %s(): irq_status_reg=0x%04X\n",
-			     jiffies, __FUNCTION__, irq_status);
+			     jiffies, __func__, irq_status);
 		}
 #endif
 		return IRQ_NONE;
@@ -3329,7 +3329,7 @@ static void me4600_ai_work_control_task(struct work_struct *work)
 	instance =
 	    container_of((void *)work, me4600_ai_subdevice_t, ai_control_task);
 #endif
-	PINFO("<%s: %ld> executed.\n", __FUNCTION__, jiffies);
+	PINFO("<%s: %ld> executed.\n", __func__, jiffies);
 
 	status = inl(instance->status_reg);
 	PDEBUG_REG("status_reg inl(0x%lX+0x%lX)=0x%x\n", instance->reg_base,
@@ -3428,7 +3428,7 @@ static void me4600_ai_work_control_task(struct work_struct *work)
 		queue_delayed_work(instance->me4600_workqueue,
 				   &instance->ai_control_task, 1);
 	} else {
-		PINFO("<%s> Ending control task.\n", __FUNCTION__);
+		PINFO("<%s> Ending control task.\n", __func__);
 	}
 
 }
diff --git a/drivers/staging/meilhaus/me4600_ao.c b/drivers/staging/meilhaus/me4600_ao.c
index 2c92e65..e2bec82 100644
--- a/drivers/staging/meilhaus/me4600_ao.c
+++ b/drivers/staging/meilhaus/me4600_ao.c
@@ -2294,7 +2294,7 @@ static irqreturn_t me4600_ao_isr(int irq, void *dev_id
 	irq_status = inl(instance->irq_status_reg);
 	if (!(irq_status & (ME4600_IRQ_STATUS_BIT_AO_HF << instance->ao_idx))) {
 		PINFO("%ld Shared interrupt. %s(): ID=%d: status_reg=0x%04X\n",
-		      jiffies, __FUNCTION__, instance->ao_idx, irq_status);
+		      jiffies, __func__, instance->ao_idx, irq_status);
 		return IRQ_NONE;
 	}
 
@@ -3009,7 +3009,7 @@ static void me4600_ao_work_control_task(
 	instance =
 	    container_of((void *)work, me4600_ao_subdevice_t, ao_control_task);
 #endif
-	PINFO("<%s: %ld> executed. idx=%d\n", __FUNCTION__, jiffies,
+	PINFO("<%s: %ld> executed. idx=%d\n", __func__, jiffies,
 	      instance->ao_idx);
 
 	status = inl(instance->status_reg);
@@ -3316,7 +3316,7 @@ static void me4600_ao_work_control_task(
 		queue_delayed_work(instance->me4600_workqueue,
 				   &instance->ao_control_task, 1);
 	} else {
-		PINFO("<%s> Ending control task.\n", __FUNCTION__);
+		PINFO("<%s> Ending control task.\n", __func__);
 	}
 
 }
diff --git a/drivers/staging/meilhaus/me4600_ext_irq.c b/drivers/staging/meilhaus/me4600_ext_irq.c
index 8a10dce..adc1e1b 100644
--- a/drivers/staging/meilhaus/me4600_ext_irq.c
+++ b/drivers/staging/meilhaus/me4600_ext_irq.c
@@ -356,7 +356,7 @@ static irqreturn_t me4600_ext_irq_isr(int irq, void *dev_id,
 	irq_status = inl(instance->irq_status_reg);
 	if (!(irq_status & ME4600_IRQ_STATUS_BIT_EX)) {
 		PINFO("%ld Shared interrupt. %s(): irq_status_reg=0x%04X\n",
-		      jiffies, __FUNCTION__, irq_status);
+		      jiffies, __func__, irq_status);
 		return IRQ_NONE;
 	}
 
diff --git a/drivers/staging/meilhaus/me6000_ao.c b/drivers/staging/meilhaus/me6000_ao.c
index 3f5ff6d..94f0123 100644
--- a/drivers/staging/meilhaus/me6000_ao.c
+++ b/drivers/staging/meilhaus/me6000_ao.c
@@ -863,7 +863,7 @@ static int me6000_ao_io_single_write(me_subdevice_t * subdevice,
 
 /// @note When flag 'ME_IO_SINGLE_TYPE_TRIG_SYNCHRONOUS' is set than output is triggered. ALWAYS!
 
-	PINFO("<%s> start mode= 0x%08x %s\n", __FUNCTION__, mode,
+	PINFO("<%s> start mode= 0x%08x %s\n", __func__, mode,
 	      (flags & ME_IO_SINGLE_TYPE_TRIG_SYNCHRONOUS) ? "SYNCHRONOUS" :
 	      "");
 	if (instance->fifo & ME6000_AO_HAS_FIFO) {	// FIFO - Continous mode
@@ -1663,7 +1663,7 @@ static int me6000_ao_io_stream_start(me_subdevice_t * subdevice,
 
 	status = inl(instance->status_reg);
 	//Start state machine and interrupts
-	PINFO("<%s:%d> Start state machine.\n", __FUNCTION__, __LINE__);
+	PINFO("<%s:%d> Start state machine.\n", __func__, __LINE__);
 	ctrl &= ~(ME6000_AO_CTRL_BIT_STOP | ME6000_AO_CTRL_BIT_IMMEDIATE_STOP);
 	if (instance->start_mode == ME6000_AO_EXT_TRIG) {
 		PDEBUG("DIGITAL TRIGGER\n");
@@ -1671,7 +1671,7 @@ static int me6000_ao_io_stream_start(me_subdevice_t * subdevice,
 	}
 	if (!(status & ME6000_AO_STATUS_BIT_HF)) {	//More than half!
 		if ((ctrl & ME6000_AO_CTRL_MODE_MASK) == ME6000_AO_MODE_CONTINUOUS) {	//Enable IRQ only when hardware_continous is set and FIFO is more than half
-			PINFO("<%s:%d> Start interrupts.\n", __FUNCTION__,
+			PINFO("<%s:%d> Start interrupts.\n", __func__,
 			      __LINE__);
 			ctrl |= ME6000_AO_CTRL_BIT_ENABLE_IRQ;
 		}
@@ -1682,7 +1682,7 @@ static int me6000_ao_io_stream_start(me_subdevice_t * subdevice,
 	spin_unlock_irqrestore(&instance->subdevice_lock, cpu_flags);
 
 	//Trigger output
-	PINFO("<%s> start mode= 0x%x %s\n", __FUNCTION__, instance->start_mode,
+	PINFO("<%s> start mode= 0x%x %s\n", __func__, instance->start_mode,
 	      (flags & ME_IO_SINGLE_TYPE_TRIG_SYNCHRONOUS) ? "SYNCHRONOUS" :
 	      "");
 	if (flags & ME_IO_SINGLE_TYPE_TRIG_SYNCHRONOUS) {	//Trigger outputs
@@ -1777,7 +1777,7 @@ static int me6000_ao_io_stream_start(me_subdevice_t * subdevice,
 		status = inl(instance->status_reg);
 		if (!(status & ME6000_AO_STATUS_BIT_HF)) {	//More than half!
 			spin_lock_irqsave(&instance->subdevice_lock, cpu_flags);
-			PINFO("<%s:%d> Start interrupts.\n", __FUNCTION__,
+			PINFO("<%s:%d> Start interrupts.\n", __func__,
 			      __LINE__);
 			ctrl = inl(instance->ctrl_reg);
 			ctrl |= ME6000_AO_CTRL_BIT_ENABLE_IRQ;
@@ -1819,7 +1819,7 @@ static int me6000_ao_io_stream_start(me_subdevice_t * subdevice,
 				spin_lock_irqsave(&instance->subdevice_lock,
 						  cpu_flags);
 				PINFO("<%s:%d> Start interrupts.\n",
-				      __FUNCTION__, __LINE__);
+				      __func__, __LINE__);
 				ctrl = inl(instance->ctrl_reg);
 				ctrl |= ME6000_AO_CTRL_BIT_ENABLE_IRQ;
 				outl(ctrl, instance->ctrl_reg);
@@ -2346,7 +2346,7 @@ static irqreturn_t me6000_ao_isr(int irq, void *dev_id, struct pt_regs *regs)
 	irq_status = inl(instance->irq_status_reg);
 	if (!(irq_status & (ME6000_IRQ_STATUS_BIT_AO_HF << instance->ao_idx))) {
 		PINFO("%ld Shared interrupt. %s(): ID=%d: status_reg=0x%04X\n",
-		      jiffies, __FUNCTION__, instance->ao_idx, irq_status);
+		      jiffies, __func__, instance->ao_idx, irq_status);
 		return IRQ_NONE;
 	}
 
@@ -2861,7 +2861,7 @@ int inline ao_stop_immediately(me6000_ao_subdevice_t * instance)
 			}
 		}
 
-		PINFO("<%s> Wait for stop: %d\n", __FUNCTION__, i);
+		PINFO("<%s> Wait for stop: %d\n", __func__, i);
 
 		//Still working!
 		set_current_state(TASK_INTERRUPTIBLE);
@@ -3132,7 +3132,7 @@ static void me6000_ao_work_control_task(
 	instance =
 	    container_of((void *)work, me6000_ao_subdevice_t, ao_control_task);
 #endif
-	PINFO("<%s: %ld> executed. idx=%d\n", __FUNCTION__, jiffies,
+	PINFO("<%s: %ld> executed. idx=%d\n", __func__, jiffies,
 	      instance->ao_idx);
 
 	status = inl(instance->status_reg);
@@ -3550,7 +3550,7 @@ static void me6000_ao_work_control_task(
 		queue_delayed_work(instance->me6000_workqueue,
 				   &instance->ao_control_task, 1);
 	} else {
-		PINFO("<%s> Ending control task.\n", __FUNCTION__);
+		PINFO("<%s> Ending control task.\n", __func__);
 	}
 
 }
diff --git a/drivers/staging/meilhaus/me8100_di.c b/drivers/staging/meilhaus/me8100_di.c
index 0f14637..971727c 100644
--- a/drivers/staging/meilhaus/me8100_di.c
+++ b/drivers/staging/meilhaus/me8100_di.c
@@ -536,7 +536,7 @@ static irqreturn_t me8100_isr(int irq, void *dev_id, struct pt_regs *regs)
 		     PLX_INTCSR_LOCAL_INT1_EN)) {
 			PINFO
 			    ("%ld Shared interrupt. %s(): idx=0 plx:irq_status_reg=0x%04X\n",
-			     jiffies, __FUNCTION__, icsr);
+			     jiffies, __func__, icsr);
 			return IRQ_NONE;
 		}
 	} else if (instance->di_idx == 1) {
@@ -547,11 +547,11 @@ static irqreturn_t me8100_isr(int irq, void *dev_id, struct pt_regs *regs)
 		     PLX_INTCSR_LOCAL_INT2_EN)) {
 			PINFO
 			    ("%ld Shared interrupt. %s(): idx=1 plx:irq_status_reg=0x%04X\n",
-			     jiffies, __FUNCTION__, icsr);
+			     jiffies, __func__, icsr);
 			return IRQ_NONE;
 		}
 	} else {
-		PERROR("%s():Wrong interrupt idx=%d csr=0x%X.\n", __FUNCTION__,
+		PERROR("%s():Wrong interrupt idx=%d csr=0x%X.\n", __func__,
 		       instance->di_idx, icsr);
 		return IRQ_NONE;
 	}
diff --git a/drivers/staging/meilhaus/me8200_di.c b/drivers/staging/meilhaus/me8200_di.c
index 0bb4567..27525bc 100644
--- a/drivers/staging/meilhaus/me8200_di.c
+++ b/drivers/staging/meilhaus/me8200_di.c
@@ -570,7 +570,7 @@ static irqreturn_t me8200_isr(int irq, void *dev_id, struct pt_regs *regs)
 	if (!irq_status) {
 		PINFO
 		    ("%ld Shared interrupt. %s(): idx=%d irq_status_reg=0x%04X\n",
-		     jiffies, __FUNCTION__, instance->di_idx, irq_status);
+		     jiffies, __func__, instance->di_idx, irq_status);
 		return IRQ_NONE;
 	}
 
@@ -658,7 +658,7 @@ static irqreturn_t me8200_isr_EX(int irq, void *dev_id, struct pt_regs *regs)
 	if (!irq_status) {
 		PINFO
 		    ("%ld Shared interrupt. %s(): idx=%d irq_status_reg=0x%04X\n",
-		     jiffies, __FUNCTION__, instance->di_idx, irq_status);
+		     jiffies, __func__, instance->di_idx, irq_status);
 		return IRQ_NONE;
 	}
 
diff --git a/drivers/staging/meilhaus/me8200_do.c b/drivers/staging/meilhaus/me8200_do.c
index 5f4ba5d..d2bebd1 100644
--- a/drivers/staging/meilhaus/me8200_do.c
+++ b/drivers/staging/meilhaus/me8200_do.c
@@ -475,7 +475,7 @@ static irqreturn_t me8200_do_isr(int irq, void *dev_id, struct pt_regs *regs)
 	     (ME8200_DO_IRQ_STATUS_BIT_ACTIVE << instance->do_idx))) {
 		PINFO
 		    ("%ld Shared interrupt. %s(): idx=%d irq_status_reg=0x%04X\n",
-		     jiffies, __FUNCTION__, instance->do_idx, irq_status);
+		     jiffies, __func__, instance->do_idx, irq_status);
 		return IRQ_NONE;
 	}
 
diff --git a/drivers/staging/meilhaus/medebug.h b/drivers/staging/meilhaus/medebug.h
index 382d00f..dcfb97c 100644
--- a/drivers/staging/meilhaus/medebug.h
+++ b/drivers/staging/meilhaus/medebug.h
@@ -66,21 +66,21 @@
 
 #ifdef MEDEBUG_DEBUG
 # define PDEBUG(fmt, args...) \
-	printk(KERN_DEBUG"ME_DRV D: <%s> " fmt, __FUNCTION__, ##args)
+	printk(KERN_DEBUG"ME_DRV D: <%s> " fmt, __func__, ##args)
 #else
 # define PDEBUG(fmt, args...)
 #endif
 
 #ifdef MEDEBUG_DEBUG_LOCKS
 # define PDEBUG_LOCKS(fmt, args...) \
-	printk(KERN_DEBUG"ME_DRV L: <%s> " fmt, __FUNCTION__, ##args)
+	printk(KERN_DEBUG"ME_DRV L: <%s> " fmt, __func__, ##args)
 #else
 # define PDEBUG_LOCKS(fmt, args...)
 #endif
 
 #ifdef MEDEBUG_DEBUG_REG
 # define PDEBUG_REG(fmt, args...) \
-	printk(KERN_DEBUG"ME_DRV R: <%s:%d> REG:" fmt, __FUNCTION__, __LINE__, ##args)
+	printk(KERN_DEBUG"ME_DRV R: <%s:%d> REG:" fmt, __func__, __LINE__, ##args)
 #else
 # define PDEBUG_REG(fmt, args...)
 #endif
@@ -108,7 +108,7 @@
 
 //This debug is only to detect logical errors!
 # define PSECURITY(fmt, args...) \
-	printk(KERN_CRIT"ME_DRV SECURITY: <%s:%s:%i> " fmt, __FILE__, __FUNCTION__, __LINE__, ##args)
+	printk(KERN_CRIT"ME_DRV SECURITY: <%s:%s:%i> " fmt, __FILE__, __func__, __LINE__, ##args)
 //This debug is to keep track in customers' system
 # define PLOG(fmt, args...) \
 	printk(KERN_INFO"ME_DRV: " fmt, ##args)
@@ -116,7 +116,7 @@
 //This debug is to check new parts during development
 #ifdef MEDEBUG_DEVELOP
 # define PDEVELOP(fmt, args...) \
-	printk(KERN_CRIT"ME_DRV: <%s:%s:%i> " fmt, __FILE__, __FUNCTION__, __LINE__, ##args)
+	printk(KERN_CRIT"ME_DRV: <%s:%s:%i> " fmt, __FILE__, __func__, __LINE__, ##args)
 #else
 # define PDEVELOP(fmt, args...)
 #endif
diff --git a/drivers/staging/otus/80211core/cagg.c b/drivers/staging/otus/80211core/cagg.c
index fcfd01a..4942190 100644
--- a/drivers/staging/otus/80211core/cagg.c
+++ b/drivers/staging/otus/80211core/cagg.c
@@ -1933,7 +1933,7 @@ u16_t zfAggRx(zdev_t* dev, zbuf_t* buf, struct zsAdditionInfo *addInfo, struct a
      */
 
     /* zm_msg2_agg(ZM_LV_0, "queue seq = ", seq_no);
-     * DbgPrint("%s:%s%lxh %s%lxh\n", __FUNCTION__, "queue seq=", seq_no,
+     * DbgPrint("%s:%s%lxh %s%lxh\n", __func__, "queue seq=", seq_no,
      *   "; seq_start=", tid_rx->seq_start);
      */
 
diff --git a/drivers/staging/otus/80211core/pub_zfw.h b/drivers/staging/otus/80211core/pub_zfw.h
index 01a2272..2474bb7 100644
--- a/drivers/staging/otus/80211core/pub_zfw.h
+++ b/drivers/staging/otus/80211core/pub_zfw.h
@@ -23,7 +23,7 @@
 /* Buffer management */
 #ifdef ZM_ENABLE_BUFFER_DEBUG
 extern zbuf_t* zfwBufAllocateWithContext(zdev_t* dev, u16_t len, u8_t *functionName, ULONG line);
-#define zfwBufAllocate(dev, len)  zfwBufAllocateWithContext(dev, len, (u8_t *)__FUNCTION__, __LINE__)
+#define zfwBufAllocate(dev, len)  zfwBufAllocateWithContext(dev, len, (u8_t *)__func__, __LINE__)
 #else
 extern zbuf_t* zfwBufAllocate(zdev_t* dev, u16_t len);
 #endif
diff --git a/drivers/staging/otus/80211core/struct.h b/drivers/staging/otus/80211core/struct.h
index 43631c6..17b5ce3 100644
--- a/drivers/staging/otus/80211core/struct.h
+++ b/drivers/staging/otus/80211core/struct.h
@@ -137,7 +137,7 @@ extern const u8_t zg11gRateTbl[8];
 
 #ifdef ZM_ENABLE_BUFFER_TRACE
 extern void zfwBufTrace(zdev_t* dev, zbuf_t *buf, u8_t *functionName);
-#define ZM_BUFFER_TRACE(dev, buf)       zfwBufTrace(dev, buf, __FUNCTION__);
+#define ZM_BUFFER_TRACE(dev, buf)       zfwBufTrace(dev, buf, __func__);
 #else
 #define ZM_BUFFER_TRACE(dev, buf)
 #endif
diff --git a/drivers/staging/otus/oal_marc.h b/drivers/staging/otus/oal_marc.h
index 438e4bc..2061116 100644
--- a/drivers/staging/otus/oal_marc.h
+++ b/drivers/staging/otus/oal_marc.h
@@ -106,14 +106,14 @@
 
 /***** Debug message *****/
 #if 0
-#define zm_debug_msg0(msg) printk("%s:%s\n", __FUNCTION__, msg);
-#define zm_debug_msg1(msg, val) printk("%s:%s%ld\n", __FUNCTION__, \
+#define zm_debug_msg0(msg) printk("%s:%s\n", __func__, msg);
+#define zm_debug_msg1(msg, val) printk("%s:%s%ld\n", __func__, \
         msg, (u32_t)val);
-#define zm_debug_msg2(msg, val) printk("%s:%s%lxh\n", __FUNCTION__, \
+#define zm_debug_msg2(msg, val) printk("%s:%s%lxh\n", __func__, \
         msg, (u32_t)val);
-#define zm_debug_msg_s(msg, val) printk("%s:%s%s\n", __FUNCTION__, \
+#define zm_debug_msg_s(msg, val) printk("%s:%s%s\n", __func__, \
         msg, val);
-#define zm_debug_msg_p(msg, val1, val2) printk("%s:%s%01ld.%02ld\n", __FUNCTION__, \
+#define zm_debug_msg_p(msg, val1, val2) printk("%s:%s%01ld.%02ld\n", __func__, \
         msg, (val1/val2), (((val1*100)/val2)%100));
 #define zm_dbg(S) printk S
 #else
@@ -127,7 +127,7 @@
 
 #define zm_assert(expr) if(!(expr)) {                           \
         printk( "Atheors Assertion failed! %s,%s,%s,line=%d\n",   \
-        #expr,__FILE__,__FUNCTION__,__LINE__);                  \
+        #expr,__FILE__,__func__,__LINE__);                  \
         }
 
 #define DbgPrint printk
diff --git a/drivers/staging/rt2860/2860_main_dev.c b/drivers/staging/rt2860/2860_main_dev.c
index 1e38f2d..08ca81f 100644
--- a/drivers/staging/rt2860/2860_main_dev.c
+++ b/drivers/staging/rt2860/2860_main_dev.c
@@ -1202,7 +1202,7 @@ VOID RT28xx_UpdateBeaconToAsic(
 	UCHAR			bcn_idx = 0;
 
 	{
-		DBGPRINT(RT_DEBUG_ERROR, ("%s() : No valid Interface be found.\n", __FUNCTION__));
+		DBGPRINT(RT_DEBUG_ERROR, ("%s() : No valid Interface be found.\n", __func__));
 		return;
 	}
 
diff --git a/drivers/staging/rt2860/common/ba_action.c b/drivers/staging/rt2860/common/ba_action.c
index 8247aeb..591d1e2 100644
--- a/drivers/staging/rt2860/common/ba_action.c
+++ b/drivers/staging/rt2860/common/ba_action.c
@@ -599,7 +599,7 @@ VOID BAOriSessionAdd(
 
 		pBAEntry->ORIBATimer.TimerValue = 0;	//pFrame->TimeOutValue;
 
-		DBGPRINT(RT_DEBUG_TRACE,("%s : TXBAbitmap = %x, BAWinSize = %d, TimeOut = %ld\n", __FUNCTION__, pEntry->TXBAbitmap,
+		DBGPRINT(RT_DEBUG_TRACE,("%s : TXBAbitmap = %x, BAWinSize = %d, TimeOut = %ld\n", __func__, pEntry->TXBAbitmap,
 								 pBAEntry->BAWinSize, pBAEntry->ORIBATimer.TimerValue));
 
 		// SEND BAR ;
@@ -673,7 +673,7 @@ BOOLEAN BARecSessionAdd(
 		ba_refresh_reordering_mpdus(pAd, pBAEntry);
 	}
 
-	DBGPRINT(RT_DEBUG_TRACE,("%s(%ld): Idx = %d, BAWinSize(req %d) = %d\n", __FUNCTION__, pAd->BATable.numAsRecipient, Idx,
+	DBGPRINT(RT_DEBUG_TRACE,("%s(%ld): Idx = %d, BAWinSize(req %d) = %d\n", __func__, pAd->BATable.numAsRecipient, Idx,
 							 pFrame->BaParm.BufSize, BAWinSize));
 
 	// Start fill in parameters.
@@ -915,7 +915,7 @@ VOID BAOriSessionTearDown(
 		return;
 	}
 
-	DBGPRINT(RT_DEBUG_TRACE,("%s===>Wcid=%d.TID=%d \n", __FUNCTION__, Wcid, TID));
+	DBGPRINT(RT_DEBUG_TRACE,("%s===>Wcid=%d.TID=%d \n", __func__, Wcid, TID));
 
 	pBAEntry = &pAd->BATable.BAOriEntry[Idx];
 	DBGPRINT(RT_DEBUG_TRACE,("\t===>Idx = %ld, Wcid=%d.TID=%d, ORI_BA_Status = %d \n", Idx, Wcid, TID, pBAEntry->ORI_BA_Status));
@@ -974,7 +974,7 @@ VOID BARecSessionTearDown(
 	if (Idx == 0)
 		return;
 
-	DBGPRINT(RT_DEBUG_TRACE,("%s===>Wcid=%d.TID=%d \n", __FUNCTION__, Wcid, TID));
+	DBGPRINT(RT_DEBUG_TRACE,("%s===>Wcid=%d.TID=%d \n", __func__, Wcid, TID));
 
 
 	pBAEntry = &pAd->BATable.BARecEntry[Idx];
@@ -1185,7 +1185,7 @@ VOID PeerAddBAReqAction(
 	PULONG      ptemp;
 	PMAC_TABLE_ENTRY	pMacEntry;
 
-	DBGPRINT(RT_DEBUG_TRACE, ("%s ==> (Wcid = %d)\n", __FUNCTION__, Elem->Wcid));
+	DBGPRINT(RT_DEBUG_TRACE, ("%s ==> (Wcid = %d)\n", __func__, Elem->Wcid));
 
 	//hex_dump("AddBAReq", Elem->Msg, Elem->MsgLen);
 
@@ -1269,7 +1269,7 @@ VOID PeerAddBAReqAction(
 	MiniportMMRequest(pAd, QID_AC_BE, pOutBuffer, FrameLen);
 	MlmeFreeMemory(pAd, pOutBuffer);
 
-	DBGPRINT(RT_DEBUG_TRACE, ("%s(%d): TID(%d), BufSize(%d) <== \n", __FUNCTION__, Elem->Wcid, ADDframe.BaParm.TID,
+	DBGPRINT(RT_DEBUG_TRACE, ("%s(%d): TID(%d), BufSize(%d) <== \n", __func__, Elem->Wcid, ADDframe.BaParm.TID,
 							  ADDframe.BaParm.BufSize));
 }
 
@@ -1288,7 +1288,7 @@ VOID PeerAddBARspAction(
 	if (Elem->Wcid >= MAX_LEN_OF_MAC_TABLE)
 		return;
 
-	DBGPRINT(RT_DEBUG_TRACE, ("%s ==> Wcid(%d)\n", __FUNCTION__, Elem->Wcid));
+	DBGPRINT(RT_DEBUG_TRACE, ("%s ==> Wcid(%d)\n", __func__, Elem->Wcid));
 
 	//hex_dump("PeerAddBARspAction()", Elem->Msg, Elem->MsgLen);
 
@@ -1329,7 +1329,7 @@ VOID PeerDelBAAction(
 	//PUCHAR				pOutBuffer = NULL;
 	PFRAME_DELBA_REQ    pDelFrame = NULL;
 
-	DBGPRINT(RT_DEBUG_TRACE,("%s ==>\n", __FUNCTION__));
+	DBGPRINT(RT_DEBUG_TRACE,("%s ==>\n", __func__));
 	//DELBA Request from unknown peer, ignore this.
 	if (PeerDelBAActionSanity(pAd, Elem->Wcid, Elem->Msg, Elem->MsgLen))
 	{
@@ -1366,7 +1366,7 @@ BOOLEAN CntlEnqueueForRecv(
 
 	TID = (UCHAR)pFrame->BARControl.TID;
 
-	DBGPRINT(RT_DEBUG_TRACE, ("%s(): BAR-Wcid(%ld), Tid (%d)\n", __FUNCTION__, Wcid, TID));
+	DBGPRINT(RT_DEBUG_TRACE, ("%s(): BAR-Wcid(%ld), Tid (%d)\n", __func__, Wcid, TID));
 	//hex_dump("BAR", (PCHAR) pFrame, MsgLen);
 	// Do nothing if the driver is starting halt state.
 	// This might happen when timer already been fired before cancel timer with mlmehalt
diff --git a/drivers/staging/rt2860/common/cmm_data.c b/drivers/staging/rt2860/common/cmm_data.c
index ac54901..b67b9eb 100644
--- a/drivers/staging/rt2860/common/cmm_data.c
+++ b/drivers/staging/rt2860/common/cmm_data.c
@@ -2787,7 +2787,7 @@ BOOLEAN MacTableDeleteEntry(
 		}
 		else
 		{
-			printk("\n%s: Impossible Wcid = %d !!!!!\n", __FUNCTION__, wcid);
+			printk("\n%s: Impossible Wcid = %d !!!!!\n", __func__, wcid);
 		}
 	}
 
diff --git a/drivers/staging/rt2860/common/cmm_data_2860.c b/drivers/staging/rt2860/common/cmm_data_2860.c
index 4f414ed..419e50c 100644
--- a/drivers/staging/rt2860/common/cmm_data_2860.c
+++ b/drivers/staging/rt2860/common/cmm_data_2860.c
@@ -1002,7 +1002,7 @@ VOID RT28xxPciStaAsicSleepThenAutoWakeup(
         AutoWakeupCfg.field.AutoLeadTime = 5;
         RTMP_IO_WRITE32(pAd, AUTO_WAKEUP_CFG, AutoWakeupCfg.word);
         AsicSendCommandToMcu(pAd, 0x30, 0xff, 0xff, 0x00);   // send POWER-SAVE command to MCU. Timeout 40us.
-        DBGPRINT(RT_DEBUG_TRACE, ("<-- %s, TbttNumToNextWakeUp=%d \n", __FUNCTION__, TbttNumToNextWakeUp));
+        DBGPRINT(RT_DEBUG_TRACE, ("<-- %s, TbttNumToNextWakeUp=%d \n", __func__, TbttNumToNextWakeUp));
     }
     OPSTATUS_SET_FLAG(pAd, fOP_STATUS_DOZE);
 }
@@ -1115,7 +1115,7 @@ VOID RT28xxPciMlmeRadioOn(
     if (!RTMP_TEST_FLAG(pAd, fRTMP_ADAPTER_RADIO_OFF))
    		return;
 
-    DBGPRINT(RT_DEBUG_TRACE,("%s===>\n", __FUNCTION__));
+    DBGPRINT(RT_DEBUG_TRACE,("%s===>\n", __func__));
 
     if ((pAd->OpMode == OPMODE_AP) ||
         ((pAd->OpMode == OPMODE_STA) && (!OPSTATUS_TEST_FLAG(pAd, fOP_STATUS_ADVANCE_POWER_SAVE_PCIE_DEVICE))))
@@ -1165,7 +1165,7 @@ VOID RT28xxPciMlmeRadioOFF(
     if (RTMP_TEST_FLAG(pAd, fRTMP_ADAPTER_RADIO_OFF))
     	return;
 
-    DBGPRINT(RT_DEBUG_TRACE,("%s===>\n", __FUNCTION__));
+    DBGPRINT(RT_DEBUG_TRACE,("%s===>\n", __func__));
 
 	// Set LED
 	RTMPSetLED(pAd, LED_RADIO_OFF);
diff --git a/drivers/staging/rt2860/common/cmm_info.c b/drivers/staging/rt2860/common/cmm_info.c
index 0aadf8a..dd92ac6 100644
--- a/drivers/staging/rt2860/common/cmm_info.c
+++ b/drivers/staging/rt2860/common/cmm_info.c
@@ -2039,7 +2039,7 @@ VOID RTMPIoctlGetMacTable(
 	wrq->u.data.length = sizeof(RT_802_11_MAC_TABLE);
 	if (copy_to_user(wrq->u.data.pointer, &MacTab, wrq->u.data.length))
 	{
-		DBGPRINT(RT_DEBUG_TRACE, ("%s: copy_to_user() fail\n", __FUNCTION__));
+		DBGPRINT(RT_DEBUG_TRACE, ("%s: copy_to_user() fail\n", __func__));
 	}
 
 	msg = (CHAR *) kmalloc(sizeof(CHAR)*(MAX_LEN_OF_MAC_TABLE*MAC_LINE_LEN), MEM_ALLOC_FLAG);
diff --git a/drivers/staging/rt2860/common/dfs.c b/drivers/staging/rt2860/common/dfs.c
index 23cf151..b09bba5 100644
--- a/drivers/staging/rt2860/common/dfs.c
+++ b/drivers/staging/rt2860/common/dfs.c
@@ -428,7 +428,7 @@ INT Set_ChMovingTime_Proc(
 
 	pAd->CommonCfg.RadarDetect.ChMovingTime = Value;
 
-	DBGPRINT(RT_DEBUG_TRACE, ("%s:: %d\n", __FUNCTION__,
+	DBGPRINT(RT_DEBUG_TRACE, ("%s:: %d\n", __func__,
 		pAd->CommonCfg.RadarDetect.ChMovingTime));
 
 	return TRUE;
@@ -444,7 +444,7 @@ INT Set_LongPulseRadarTh_Proc(
 
 	pAd->CommonCfg.RadarDetect.LongPulseRadarTh = Value;
 
-	DBGPRINT(RT_DEBUG_TRACE, ("%s:: %d\n", __FUNCTION__,
+	DBGPRINT(RT_DEBUG_TRACE, ("%s:: %d\n", __func__,
 		pAd->CommonCfg.RadarDetect.LongPulseRadarTh));
 
 	return TRUE;
diff --git a/drivers/staging/rt2860/common/rtmp_init.c b/drivers/staging/rt2860/common/rtmp_init.c
index 84edfa5..563f2c5 100644
--- a/drivers/staging/rt2860/common/rtmp_init.c
+++ b/drivers/staging/rt2860/common/rtmp_init.c
@@ -2542,7 +2542,7 @@ NDIS_STATUS NICLoadFirmware(
 #ifdef BIN_IN_FILE
 #define NICLF_DEFAULT_USE()	\
 	flg_default_firm_use = TRUE; \
-	printk("%s - Use default firmware!\n", __FUNCTION__);
+	printk("%s - Use default firmware!\n", __func__);
 
 	NDIS_STATUS		Status = NDIS_STATUS_SUCCESS;
 	PUCHAR			src;
@@ -2557,7 +2557,7 @@ NDIS_STATUS NICLoadFirmware(
 	BOOLEAN			flg_default_firm_use = FALSE;
 
 
-	DBGPRINT(RT_DEBUG_TRACE, ("===> %s\n", __FUNCTION__));
+	DBGPRINT(RT_DEBUG_TRACE, ("===> %s\n", __func__));
 
 	/* init */
 	pFirmwareImage = NULL;
@@ -2580,7 +2580,7 @@ NDIS_STATUS NICLoadFirmware(
     if (pFirmwareImage == NULL)
 	{
 		/* allocate fail, use default firmware array in firmware.h */
-		printk("%s - Allocate memory fail!\n", __FUNCTION__);
+		printk("%s - Allocate memory fail!\n", __func__);
 		NICLF_DEFAULT_USE();
     }
 	else
@@ -2601,7 +2601,7 @@ NDIS_STATUS NICLoadFirmware(
 			if (IS_ERR(srcf))
 			{
 				printk("%s - Error %ld opening %s\n",
-					   __FUNCTION__, -PTR_ERR(srcf), src);
+					   __func__, -PTR_ERR(srcf), src);
 				NICLF_DEFAULT_USE();
 				break;
 			} /* End of if */
@@ -2609,7 +2609,7 @@ NDIS_STATUS NICLoadFirmware(
 			/* the object must have a read method */
 			if ((srcf->f_op == NULL) || (srcf->f_op->read == NULL))
 			{
-				printk("%s - %s does not have a write method\n", __FUNCTION__, src);
+				printk("%s - %s does not have a write method\n", __func__, src);
 				NICLF_DEFAULT_USE();
 				break;
 			} /* End of if */
@@ -2623,7 +2623,7 @@ NDIS_STATUS NICLoadFirmware(
 			if (FileLength != MAX_FIRMWARE_IMAGE_SIZE)
 			{
 				printk("%s: error file length (=%d) in RT2860AP.BIN\n",
-					   __FUNCTION__, FileLength);
+					   __func__, FileLength);
 				NICLF_DEFAULT_USE();
 				break;
 			}
@@ -2646,7 +2646,7 @@ NDIS_STATUS NICLoadFirmware(
 					/* CRC fail */
 					printk("%s: CRC = 0x%02x 0x%02x "
 						   "error, should be 0x%02x 0x%02x\n",
-						   __FUNCTION__,
+						   __func__,
 						   pFirmwareImage[MAX_FIRMWARE_IMAGE_SIZE-2],
 						   pFirmwareImage[MAX_FIRMWARE_IMAGE_SIZE-1],
 						   (UCHAR)(crc>>8), (UCHAR)(crc));
@@ -2665,7 +2665,7 @@ NDIS_STATUS NICLoadFirmware(
 											((FIRMWARE_MAJOR_VERSION << 8) +
 									  	 	 FIRMWARE_MINOR_VERSION))
 					{
-						printk("%s: firmware version too old!\n", __FUNCTION__);
+						printk("%s: firmware version too old!\n", __func__);
 						NICLF_DEFAULT_USE();
 						break;
 					} /* End of if */
@@ -2770,7 +2770,7 @@ NDIS_STATUS NICLoadFirmware(
 	} /* End of if */
 
     DBGPRINT(RT_DEBUG_TRACE,
-			 ("<=== %s (status=%d)\n", __FUNCTION__, Status));
+			 ("<=== %s (status=%d)\n", __func__, Status));
     return Status;
 } /* End of NICLoadFirmware */
 
diff --git a/drivers/staging/rt2860/common/spectrum.c b/drivers/staging/rt2860/common/spectrum.c
index 85e636a..0265a6d 100644
--- a/drivers/staging/rt2860/common/spectrum.c
+++ b/drivers/staging/rt2860/common/spectrum.c
@@ -49,7 +49,7 @@ VOID MeasureReqTabInit(
 	if (pAd->CommonCfg.pMeasureReqTab)
 		NdisZeroMemory(pAd->CommonCfg.pMeasureReqTab, sizeof(MEASURE_REQ_TAB));
 	else
-		DBGPRINT(RT_DEBUG_ERROR, ("%s Fail to alloc memory for pAd->CommonCfg.pMeasureReqTab.\n", __FUNCTION__));
+		DBGPRINT(RT_DEBUG_ERROR, ("%s Fail to alloc memory for pAd->CommonCfg.pMeasureReqTab.\n", __func__));
 
 	return;
 }
@@ -77,7 +77,7 @@ static PMEASURE_REQ_ENTRY MeasureReqLookUp(
 
 	if (pTab == NULL)
 	{
-		DBGPRINT(RT_DEBUG_ERROR, ("%s: pMeasureReqTab doesn't exist.\n", __FUNCTION__));
+		DBGPRINT(RT_DEBUG_ERROR, ("%s: pMeasureReqTab doesn't exist.\n", __func__));
 		return NULL;
 	}
 
@@ -114,7 +114,7 @@ static PMEASURE_REQ_ENTRY MeasureReqInsert(
 
 	if(pTab == NULL)
 	{
-		DBGPRINT(RT_DEBUG_ERROR, ("%s: pMeasureReqTab doesn't exist.\n", __FUNCTION__));
+		DBGPRINT(RT_DEBUG_ERROR, ("%s: pMeasureReqTab doesn't exist.\n", __func__));
 		return NULL;
 	}
 
@@ -175,7 +175,7 @@ static PMEASURE_REQ_ENTRY MeasureReqInsert(
 		else
 		{
 			pEntry = NULL;
-			DBGPRINT(RT_DEBUG_ERROR, ("%s: pMeasureReqTab tab full.\n", __FUNCTION__));
+			DBGPRINT(RT_DEBUG_ERROR, ("%s: pMeasureReqTab tab full.\n", __func__));
 		}
 
 		// add this Neighbor entry into HASH table
@@ -210,7 +210,7 @@ static VOID MeasureReqDelete(
 
 	if(pTab == NULL)
 	{
-		DBGPRINT(RT_DEBUG_ERROR, ("%s: pMeasureReqTab doesn't exist.\n", __FUNCTION__));
+		DBGPRINT(RT_DEBUG_ERROR, ("%s: pMeasureReqTab doesn't exist.\n", __func__));
 		return;
 	}
 
@@ -267,7 +267,7 @@ VOID TpcReqTabInit(
 	if (pAd->CommonCfg.pTpcReqTab)
 		NdisZeroMemory(pAd->CommonCfg.pTpcReqTab, sizeof(TPC_REQ_TAB));
 	else
-		DBGPRINT(RT_DEBUG_ERROR, ("%s Fail to alloc memory for pAd->CommonCfg.pTpcReqTab.\n", __FUNCTION__));
+		DBGPRINT(RT_DEBUG_ERROR, ("%s Fail to alloc memory for pAd->CommonCfg.pTpcReqTab.\n", __func__));
 
 	return;
 }
@@ -295,7 +295,7 @@ static PTPC_REQ_ENTRY TpcReqLookUp(
 
 	if (pTab == NULL)
 	{
-		DBGPRINT(RT_DEBUG_ERROR, ("%s: pTpcReqTab doesn't exist.\n", __FUNCTION__));
+		DBGPRINT(RT_DEBUG_ERROR, ("%s: pTpcReqTab doesn't exist.\n", __func__));
 		return NULL;
 	}
 
@@ -333,7 +333,7 @@ static PTPC_REQ_ENTRY TpcReqInsert(
 
 	if(pTab == NULL)
 	{
-		DBGPRINT(RT_DEBUG_ERROR, ("%s: pTpcReqTab doesn't exist.\n", __FUNCTION__));
+		DBGPRINT(RT_DEBUG_ERROR, ("%s: pTpcReqTab doesn't exist.\n", __func__));
 		return NULL;
 	}
 
@@ -394,7 +394,7 @@ static PTPC_REQ_ENTRY TpcReqInsert(
 		else
 		{
 			pEntry = NULL;
-			DBGPRINT(RT_DEBUG_ERROR, ("%s: pTpcReqTab tab full.\n", __FUNCTION__));
+			DBGPRINT(RT_DEBUG_ERROR, ("%s: pTpcReqTab tab full.\n", __func__));
 		}
 
 		// add this Neighbor entry into HASH table
@@ -429,7 +429,7 @@ static VOID TpcReqDelete(
 
 	if(pTab == NULL)
 	{
-		DBGPRINT(RT_DEBUG_ERROR, ("%s: pTpcReqTab doesn't exist.\n", __FUNCTION__));
+		DBGPRINT(RT_DEBUG_ERROR, ("%s: pTpcReqTab doesn't exist.\n", __func__));
 		return;
 	}
 
@@ -782,7 +782,7 @@ VOID EnqueueMeasurementReq(
 	NStatus = MlmeAllocateMemory(pAd, (PVOID)&pOutBuffer);  //Get an unused nonpaged memory
 	if(NStatus != NDIS_STATUS_SUCCESS)
 	{
-		DBGPRINT(RT_DEBUG_TRACE, ("%s() allocate memory failed \n", __FUNCTION__));
+		DBGPRINT(RT_DEBUG_TRACE, ("%s() allocate memory failed \n", __func__));
 		return;
 	}
 	NdisMoveMemory(pOutBuffer, (PCHAR)&ActHdr, sizeof(HEADER_802_11));
@@ -844,7 +844,7 @@ VOID EnqueueMeasurementRep(
 	NStatus = MlmeAllocateMemory(pAd, (PVOID)&pOutBuffer);  //Get an unused nonpaged memory
 	if(NStatus != NDIS_STATUS_SUCCESS)
 	{
-		DBGPRINT(RT_DEBUG_TRACE, ("%s() allocate memory failed \n", __FUNCTION__));
+		DBGPRINT(RT_DEBUG_TRACE, ("%s() allocate memory failed \n", __func__));
 		return;
 	}
 	NdisMoveMemory(pOutBuffer, (PCHAR)&ActHdr, sizeof(HEADER_802_11));
@@ -898,7 +898,7 @@ VOID EnqueueTPCReq(
 	NStatus = MlmeAllocateMemory(pAd, (PVOID)&pOutBuffer);  //Get an unused nonpaged memory
 	if(NStatus != NDIS_STATUS_SUCCESS)
 	{
-		DBGPRINT(RT_DEBUG_TRACE, ("%s() allocate memory failed \n", __FUNCTION__));
+		DBGPRINT(RT_DEBUG_TRACE, ("%s() allocate memory failed \n", __func__));
 		return;
 	}
 	NdisMoveMemory(pOutBuffer, (PCHAR)&ActHdr, sizeof(HEADER_802_11));
@@ -950,7 +950,7 @@ VOID EnqueueTPCRep(
 	NStatus = MlmeAllocateMemory(pAd, (PVOID)&pOutBuffer);  //Get an unused nonpaged memory
 	if(NStatus != NDIS_STATUS_SUCCESS)
 	{
-		DBGPRINT(RT_DEBUG_TRACE, ("%s() allocate memory failed \n", __FUNCTION__));
+		DBGPRINT(RT_DEBUG_TRACE, ("%s() allocate memory failed \n", __func__));
 		return;
 	}
 	NdisMoveMemory(pOutBuffer, (PCHAR)&ActHdr, sizeof(HEADER_802_11));
@@ -1003,7 +1003,7 @@ VOID EnqueueChSwAnn(
 	NStatus = MlmeAllocateMemory(pAd, (PVOID)&pOutBuffer);  //Get an unused nonpaged memory
 	if(NStatus != NDIS_STATUS_SUCCESS)
 	{
-		DBGPRINT(RT_DEBUG_TRACE, ("%s() allocate memory failed \n", __FUNCTION__));
+		DBGPRINT(RT_DEBUG_TRACE, ("%s() allocate memory failed \n", __func__));
 		return;
 	}
 	NdisMoveMemory(pOutBuffer, (PCHAR)&ActHdr, sizeof(HEADER_802_11));
@@ -1596,7 +1596,7 @@ static VOID PeerMeasureReportAction(
 
 	if ((pMeasureReportInfo = kmalloc(sizeof(MEASURE_RPI_REPORT), GFP_ATOMIC)) == NULL)
 	{
-		DBGPRINT(RT_DEBUG_ERROR, ("%s unable to alloc memory for measure report buffer (size=%d).\n", __FUNCTION__, sizeof(MEASURE_RPI_REPORT)));
+		DBGPRINT(RT_DEBUG_ERROR, ("%s unable to alloc memory for measure report buffer (size=%d).\n", __func__, sizeof(MEASURE_RPI_REPORT)));
 		return;
 	}
 
@@ -1705,7 +1705,7 @@ static VOID PeerTpcRepAction(
 		{
 			TpcReqDelete(pAd, pEntry->DialogToken);
 			DBGPRINT(RT_DEBUG_TRACE, ("%s: DialogToken=%x, TxPwr=%d, LinkMargin=%d\n",
-				__FUNCTION__, DialogToken, TpcRepInfo.TxPwr, TpcRepInfo.LinkMargin));
+				__func__, DialogToken, TpcRepInfo.TxPwr, TpcRepInfo.LinkMargin));
 		}
 	}
 
@@ -1821,7 +1821,7 @@ INT Set_MeasureReq_Proc(
 				MeasureReqType = simple_strtol(thisChar, 0, 16);
 				if (MeasureReqType > 3)
 				{
-					DBGPRINT(RT_DEBUG_ERROR, ("%s: unknow MeasureReqType(%d)\n", __FUNCTION__, MeasureReqType));
+					DBGPRINT(RT_DEBUG_ERROR, ("%s: unknow MeasureReqType(%d)\n", __func__, MeasureReqType));
 					return TRUE;
 				}
 				break;
@@ -1833,10 +1833,10 @@ INT Set_MeasureReq_Proc(
 		ArgIdx++;
 	}
 
-	DBGPRINT(RT_DEBUG_TRACE, ("%s::Aid = %d, MeasureReqType=%d MeasureCh=%d\n", __FUNCTION__, Aid, MeasureReqType, MeasureCh));
+	DBGPRINT(RT_DEBUG_TRACE, ("%s::Aid = %d, MeasureReqType=%d MeasureCh=%d\n", __func__, Aid, MeasureReqType, MeasureCh));
 	if (!VALID_WCID(Aid))
 	{
-		DBGPRINT(RT_DEBUG_ERROR, ("%s: unknow sta of Aid(%d)\n", __FUNCTION__, Aid));
+		DBGPRINT(RT_DEBUG_ERROR, ("%s: unknow sta of Aid(%d)\n", __func__, Aid));
 		return TRUE;
 	}
 
@@ -1861,10 +1861,10 @@ INT Set_TpcReq_Proc(
 
 	Aid = simple_strtol(arg, 0, 16);
 
-	DBGPRINT(RT_DEBUG_TRACE, ("%s::Aid = %d\n", __FUNCTION__, Aid));
+	DBGPRINT(RT_DEBUG_TRACE, ("%s::Aid = %d\n", __func__, Aid));
 	if (!VALID_WCID(Aid))
 	{
-		DBGPRINT(RT_DEBUG_ERROR, ("%s: unknow sta of Aid(%d)\n", __FUNCTION__, Aid));
+		DBGPRINT(RT_DEBUG_ERROR, ("%s: unknow sta of Aid(%d)\n", __func__, Aid));
 		return TRUE;
 	}
 
diff --git a/drivers/staging/rt2860/rt_ate.c b/drivers/staging/rt2860/rt_ate.c
index 2f07db5..f3316ec 100644
--- a/drivers/staging/rt2860/rt_ate.c
+++ b/drivers/staging/rt2860/rt_ate.c
@@ -291,7 +291,7 @@ static INT ATETxPwrHandler(
 				Bbp94 = BBPR94_DEFAULT;
 			}
 
-			ATEDBGPRINT(RT_DEBUG_TRACE, ("%s (TxPower=%d, R=%ld, BBP_R94=%d)\n", __FUNCTION__, TxPower, R, Bbp94));
+			ATEDBGPRINT(RT_DEBUG_TRACE, ("%s (TxPower=%d, R=%ld, BBP_R94=%d)\n", __func__, TxPower, R, Bbp94));
 		}
 		else// 5.5 GHz
 		{
@@ -318,7 +318,7 @@ static INT ATETxPwrHandler(
 				R = (ULONG) TxPower;
 			}
 
-			ATEDBGPRINT(RT_DEBUG_TRACE, ("%s (TxPower=%d, R=%lu)\n", __FUNCTION__, TxPower, R));
+			ATEDBGPRINT(RT_DEBUG_TRACE, ("%s (TxPower=%d, R=%lu)\n", __func__, TxPower, R));
 		}
 
 		if (pAd->ate.Channel <= 14)
@@ -431,7 +431,7 @@ static INT ATETxPwrHandler(
 		Bbp94 = BBPR94_DEFAULT;
 	}
 
-	ATEDBGPRINT(RT_DEBUG_TRACE, ("%s (TxPower=%d, R3=%ld, BBP_R94=%d)\n", __FUNCTION__, TxPower, R, Bbp94));
+	ATEDBGPRINT(RT_DEBUG_TRACE, ("%s (TxPower=%d, R3=%ld, BBP_R94=%d)\n", __func__, TxPower, R, Bbp94));
 
 		if (pAd->ate.Channel <= 14)
 		{
@@ -2098,7 +2098,7 @@ INT Set_ATE_Load_E2P_Proc(
 	UINT32			FileLength = 0;
 	UINT32 			value = simple_strtol(arg, 0, 10);
 
-	ATEDBGPRINT(RT_DEBUG_ERROR, ("===> %s (value=%d)\n\n", __FUNCTION__, value));
+	ATEDBGPRINT(RT_DEBUG_ERROR, ("===> %s (value=%d)\n\n", __func__, value));
 
 	if (value > 0)
 	{
@@ -2122,14 +2122,14 @@ INT Set_ATE_Load_E2P_Proc(
 
 			if (IS_ERR(srcf))
 			{
-				ate_print("%s - Error %ld opening %s\n", __FUNCTION__, -PTR_ERR(srcf), src);
+				ate_print("%s - Error %ld opening %s\n", __func__, -PTR_ERR(srcf), src);
 				break;
 			}
 
 			/* the object must have a read method */
 			if ((srcf->f_op == NULL) || (srcf->f_op->read == NULL))
 			{
-				ate_print("%s - %s does not have a read method\n", __FUNCTION__, src);
+				ate_print("%s - %s does not have a read method\n", __func__, src);
 				break;
 			}
 
@@ -2142,7 +2142,7 @@ INT Set_ATE_Load_E2P_Proc(
 			if (FileLength != EEPROM_SIZE)
 			{
 				ate_print("%s: error file length (=%d) in e2p.bin\n",
-					   __FUNCTION__, FileLength);
+					   __func__, FileLength);
 				break;
 			}
 			else
@@ -2174,7 +2174,7 @@ INT Set_ATE_Load_E2P_Proc(
 		current->fsuid = orgfsuid;
 		current->fsgid = orgfsgid;
 	}
-    ATEDBGPRINT(RT_DEBUG_ERROR, ("<=== %s (ret=%d)\n", __FUNCTION__, ret));
+    ATEDBGPRINT(RT_DEBUG_ERROR, ("<=== %s (ret=%d)\n", __func__, ret));
 
     return ret;
 
@@ -2187,12 +2187,12 @@ INT Set_ATE_Load_E2P_Proc(
 	USHORT 			WriteEEPROM[(EEPROM_SIZE/2)];
 	struct iwreq	*wrq = (struct iwreq *)arg;
 
-	ATEDBGPRINT(RT_DEBUG_TRACE, ("===> %s (wrq->u.data.length = %d)\n\n", __FUNCTION__, wrq->u.data.length));
+	ATEDBGPRINT(RT_DEBUG_TRACE, ("===> %s (wrq->u.data.length = %d)\n\n", __func__, wrq->u.data.length));
 
 	if (wrq->u.data.length != EEPROM_SIZE)
 	{
 		ate_print("%s: error length (=%d) from host\n",
-			   __FUNCTION__, wrq->u.data.length);
+			   __func__, wrq->u.data.length);
 		return FALSE;
 	}
 	else/* (wrq->u.data.length == EEPROM_SIZE) */
@@ -2211,7 +2211,7 @@ INT Set_ATE_Load_E2P_Proc(
 		} while(FALSE);
 		}
 
-    ATEDBGPRINT(RT_DEBUG_TRACE, ("<=== %s\n", __FUNCTION__));
+    ATEDBGPRINT(RT_DEBUG_TRACE, ("<=== %s\n", __func__));
 
     return TRUE;
 
@@ -3353,7 +3353,7 @@ static INT ATESetUpFrame(
 	if (pPacket == NULL)
 	{
 		pAd->ate.TxCount = 0;
-		ATEDBGPRINT(RT_DEBUG_TRACE, ("%s fail to alloc packet space.\n", __FUNCTION__));
+		ATEDBGPRINT(RT_DEBUG_TRACE, ("%s fail to alloc packet space.\n", __func__));
 		return -1;
 	}
 	pTxRing->Cell[TxIdx].pNextNdisPacket = pPacket;
@@ -3646,7 +3646,7 @@ VOID RtmpDoAte(
 
 	Command_Id = ntohs(pRaCfg->command_id);
 
-	ATEDBGPRINT(RT_DEBUG_TRACE,("\n%s: Command_Id = 0x%04x !\n", __FUNCTION__, Command_Id));
+	ATEDBGPRINT(RT_DEBUG_TRACE,("\n%s: Command_Id = 0x%04x !\n", __func__, Command_Id));
 
 	switch (Command_Id)
 	{
@@ -5690,7 +5690,7 @@ BOOLEAN SyncTxRxConfig(PRTMP_ADAPTER pAd, USHORT offset, UCHAR value)
 					pAd->ate.TxAntennaSel = 2;
 		            break;
 		        default:
-		            DBGPRINT(RT_DEBUG_TRACE, ("%s -- Sth. wrong!  : return FALSE; \n", __FUNCTION__));
+		            DBGPRINT(RT_DEBUG_TRACE, ("%s -- Sth. wrong!  : return FALSE; \n", __func__));
 		            return FALSE;
 		    }
 			break;/* case BBP_R1 */
@@ -5728,13 +5728,13 @@ BOOLEAN SyncTxRxConfig(PRTMP_ADAPTER pAd, USHORT offset, UCHAR value)
 					pAd->ate.RxAntennaSel = 3;
 		            break;
 		        default:
-		            DBGPRINT(RT_DEBUG_ERROR, ("%s -- Impossible!  : return FALSE; \n", __FUNCTION__));
+		            DBGPRINT(RT_DEBUG_ERROR, ("%s -- Impossible!  : return FALSE; \n", __func__));
 		            return FALSE;
 		    }
 			break;/* case BBP_R3 */
 
         default:
-            DBGPRINT(RT_DEBUG_ERROR, ("%s -- Sth. wrong!  : return FALSE; \n", __FUNCTION__));
+            DBGPRINT(RT_DEBUG_ERROR, ("%s -- Sth. wrong!  : return FALSE; \n", __func__));
             return FALSE;
 
 	}
diff --git a/drivers/staging/rt2860/rt_linux.c b/drivers/staging/rt2860/rt_linux.c
index 374c174..f145009 100644
--- a/drivers/staging/rt2860/rt_linux.c
+++ b/drivers/staging/rt2860/rt_linux.c
@@ -406,7 +406,7 @@ NDIS_STATUS RTMPAllocateNdisPacket(
  	skb_put(GET_OS_PKT_TYPE(pPacket), HeaderLen+DataLen);
 
 	RTMP_SET_PACKET_SOURCE(pPacket, PKTSRC_NDIS);
-//	printk("%s : pPacket = %p, len = %d\n", __FUNCTION__, pPacket, GET_OS_PKT_LEN(pPacket));
+//	printk("%s : pPacket = %p, len = %d\n", __func__, pPacket, GET_OS_PKT_LEN(pPacket));
 	*ppPacket = pPacket;
 	return NDIS_STATUS_SUCCESS;
 }
@@ -773,13 +773,13 @@ VOID RTMPSendWirelessEvent(
 
 	if (event_table_len == 0)
 	{
-		DBGPRINT(RT_DEBUG_ERROR, ("%s : The type(%0x02x) is not valid.\n", __FUNCTION__, type));
+		DBGPRINT(RT_DEBUG_ERROR, ("%s : The type(%0x02x) is not valid.\n", __func__, type));
 		return;
 	}
 
 	if (event >= event_table_len)
 	{
-		DBGPRINT(RT_DEBUG_ERROR, ("%s : The event(%0x02x) is not valid.\n", __FUNCTION__, event));
+		DBGPRINT(RT_DEBUG_ERROR, ("%s : The event(%0x02x) is not valid.\n", __func__, event));
 		return;
 	}
 
@@ -817,14 +817,14 @@ VOID RTMPSendWirelessEvent(
 		//send wireless event
 	    wireless_send_event(pAd->net_dev, IWEVCUSTOM, &wrqu, pBuf);
 
-		//DBGPRINT(RT_DEBUG_TRACE, ("%s : %s\n", __FUNCTION__, pBuf));
+		//DBGPRINT(RT_DEBUG_TRACE, ("%s : %s\n", __func__, pBuf));
 
 		kfree(pBuf);
 	}
 	else
-		DBGPRINT(RT_DEBUG_ERROR, ("%s : Can't allocate memory for wireless event.\n", __FUNCTION__));
+		DBGPRINT(RT_DEBUG_ERROR, ("%s : Can't allocate memory for wireless event.\n", __func__));
 #else
-	DBGPRINT(RT_DEBUG_ERROR, ("%s : The Wireless Extension MUST be v15 or newer.\n", __FUNCTION__));
+	DBGPRINT(RT_DEBUG_ERROR, ("%s : The Wireless Extension MUST be v15 or newer.\n", __func__));
 #endif  /* WIRELESS_EXT >= 15 */
 }
 
@@ -848,13 +848,13 @@ void send_monitor_packets(
     ASSERT(pRxBlk->pRxPacket);
     if (pRxBlk->DataSize < 10)
     {
-        DBGPRINT(RT_DEBUG_ERROR, ("%s : Size is too small! (%d)\n", __FUNCTION__, pRxBlk->DataSize));
+        DBGPRINT(RT_DEBUG_ERROR, ("%s : Size is too small! (%d)\n", __func__, pRxBlk->DataSize));
 		goto err_free_sk_buff;
     }
 
     if (pRxBlk->DataSize + sizeof(wlan_ng_prism2_header) > RX_BUFFER_AGGRESIZE)
     {
-        DBGPRINT(RT_DEBUG_ERROR, ("%s : Size is too large! (%d)\n", __FUNCTION__, pRxBlk->DataSize + sizeof(wlan_ng_prism2_header)));
+        DBGPRINT(RT_DEBUG_ERROR, ("%s : Size is too large! (%d)\n", __func__, pRxBlk->DataSize + sizeof(wlan_ng_prism2_header)));
 		goto err_free_sk_buff;
     }
 
@@ -910,7 +910,7 @@ void send_monitor_packets(
 
     if (skb_headroom(pOSPkt) < (sizeof(wlan_ng_prism2_header)+ header_len)) {
         if (pskb_expand_head(pOSPkt, (sizeof(wlan_ng_prism2_header) + header_len), 0, GFP_ATOMIC)) {
-	        DBGPRINT(RT_DEBUG_ERROR, ("%s : Reallocate header size of sk_buff fail!\n", __FUNCTION__));
+	        DBGPRINT(RT_DEBUG_ERROR, ("%s : Reallocate header size of sk_buff fail!\n", __func__));
 			goto err_free_sk_buff;
 	    } //end if
     } //end if
diff --git a/drivers/staging/rt2860/rt_linux.h b/drivers/staging/rt2860/rt_linux.h
index 0cc7cf2..0fd58f5 100644
--- a/drivers/staging/rt2860/rt_linux.h
+++ b/drivers/staging/rt2860/rt_linux.h
@@ -131,7 +131,7 @@ typedef int (*HARD_START_XMIT_FUNC)(struct sk_buff *skb, struct net_device *net_
 #define RT_MOD_INC_USE_COUNT() \
 	if (!try_module_get(THIS_MODULE)) \
 	{ \
-		DBGPRINT(RT_DEBUG_ERROR, ("%s: cannot reserve module\n", __FUNCTION__)); \
+		DBGPRINT(RT_DEBUG_ERROR, ("%s: cannot reserve module\n", __func__)); \
 		return -1; \
 	}
 
diff --git a/drivers/staging/rt2860/rt_profile.c b/drivers/staging/rt2860/rt_profile.c
index cd7ffc8..326a3cb 100644
--- a/drivers/staging/rt2860/rt_profile.c
+++ b/drivers/staging/rt2860/rt_profile.c
@@ -1024,7 +1024,7 @@ NDIS_STATUS	RTMPReadParametersHook(
 								pAd->MlmeAux.SsidLen = pAd->CommonCfg.SsidLen;
 								NdisZeroMemory(pAd->MlmeAux.Ssid, NDIS_802_11_LENGTH_SSID);
 								NdisMoveMemory(pAd->MlmeAux.Ssid, tmpbuf, pAd->MlmeAux.SsidLen);
-								DBGPRINT(RT_DEBUG_TRACE, ("%s::(SSID=%s)\n", __FUNCTION__, tmpbuf));
+								DBGPRINT(RT_DEBUG_TRACE, ("%s::(SSID=%s)\n", __func__, tmpbuf));
 							}
 						}
 					}
@@ -1043,7 +1043,7 @@ NDIS_STATUS	RTMPReadParametersHook(
 								pAd->StaCfg.BssType = BSS_INFRA;
 							// Reset Ralink supplicant to not use, it will be set to start when UI set PMK key
 							pAd->StaCfg.WpaState = SS_NOTUSE;
-							DBGPRINT(RT_DEBUG_TRACE, ("%s::(NetworkType=%d)\n", __FUNCTION__, pAd->StaCfg.BssType));
+							DBGPRINT(RT_DEBUG_TRACE, ("%s::(NetworkType=%d)\n", __func__, pAd->StaCfg.BssType));
 						}
 					}
 #endif // CONFIG_STA_SUPPORT //
@@ -1337,7 +1337,7 @@ NDIS_STATUS	RTMPReadParametersHook(
 
 				                        pAd->StaCfg.PortSecured = WPA_802_1X_PORT_NOT_SECURED;
 
-							DBGPRINT(RT_DEBUG_TRACE, ("%s::(EncrypType=%d)\n", __FUNCTION__, pAd->StaCfg.WepStatus));
+							DBGPRINT(RT_DEBUG_TRACE, ("%s::(EncrypType=%d)\n", __func__, pAd->StaCfg.WepStatus));
 						}
 #endif // CONFIG_STA_SUPPORT //
 					}
@@ -1363,7 +1363,7 @@ NDIS_STATUS	RTMPReadParametersHook(
 							pAd->StaCfg.OrigWepStatus 	= pAd->StaCfg.WepStatus;
 							pAd->StaCfg.bMixCipher 		= FALSE;
 
-							DBGPRINT(RT_DEBUG_TRACE, ("%s::(EncrypType=%d)\n", __FUNCTION__, pAd->StaCfg.WepStatus));
+							DBGPRINT(RT_DEBUG_TRACE, ("%s::(EncrypType=%d)\n", __func__, pAd->StaCfg.WepStatus));
 						}
 #endif // CONFIG_STA_SUPPORT //
 					}
@@ -1400,7 +1400,7 @@ NDIS_STATUS	RTMPReadParametersHook(
 							else
 							{
 								err = 1;
-								DBGPRINT(RT_DEBUG_ERROR, ("%s::(WPAPSK key-string required 8 ~ 64 characters!)\n", __FUNCTION__));
+								DBGPRINT(RT_DEBUG_ERROR, ("%s::(WPAPSK key-string required 8 ~ 64 characters!)\n", __func__));
 							}
 
 							if (err == 0)
@@ -1416,7 +1416,7 @@ NDIS_STATUS	RTMPReadParametersHook(
 									pAd->StaCfg.WpaState = SS_NOTUSE;
 								}
 
-								DBGPRINT(RT_DEBUG_TRACE, ("%s::(WPAPSK=%s)\n", __FUNCTION__, tmpbuf));
+								DBGPRINT(RT_DEBUG_TRACE, ("%s::(WPAPSK=%s)\n", __func__, tmpbuf));
 							}
 						}
 					}
diff --git a/drivers/staging/rt2860/rtmp_def.h b/drivers/staging/rt2860/rtmp_def.h
index bb6f37b..be98214 100644
--- a/drivers/staging/rt2860/rtmp_def.h
+++ b/drivers/staging/rt2860/rtmp_def.h
@@ -333,7 +333,7 @@
 /* sanity check for apidx */
 #define MBSS_MR_APIDX_SANITY_CHECK(apidx) \
     { if (apidx > MAX_MBSSID_NUM) { \
-          printk("%s> Error! apidx = %d > MAX_MBSSID_NUM!\n", __FUNCTION__, apidx); \
+          printk("%s> Error! apidx = %d > MAX_MBSSID_NUM!\n", __func__, apidx); \
 	  apidx = MAIN_MBSSID; } }
 
 #define VALID_WCID(_wcid)	((_wcid) > 0 && (_wcid) < MAX_LEN_OF_MAC_TABLE )
diff --git a/drivers/staging/rt2860/sta_ioctl.c b/drivers/staging/rt2860/sta_ioctl.c
index 9347d11..3ea2b2c 100644
--- a/drivers/staging/rt2860/sta_ioctl.c
+++ b/drivers/staging/rt2860/sta_ioctl.c
@@ -2200,7 +2200,7 @@ rt_private_show(struct net_device *dev, struct iw_request_info *info,
 			}
 			break;
         default:
-            DBGPRINT(RT_DEBUG_TRACE, ("%s - unknow subcmd = %d\n", __FUNCTION__, subcmd));
+            DBGPRINT(RT_DEBUG_TRACE, ("%s - unknow subcmd = %d\n", __func__, subcmd));
             break;
     }
 
@@ -2219,7 +2219,7 @@ int rt_ioctl_siwmlme(struct net_device *dev,
 	MLME_DISASSOC_REQ_STRUCT	DisAssocReq;
 	MLME_DEAUTH_REQ_STRUCT      DeAuthReq;
 
-	DBGPRINT(RT_DEBUG_TRACE, ("====> %s\n", __FUNCTION__));
+	DBGPRINT(RT_DEBUG_TRACE, ("====> %s\n", __func__));
 
 	if (pMlme == NULL)
 		return -EINVAL;
@@ -2228,7 +2228,7 @@ int rt_ioctl_siwmlme(struct net_device *dev,
 	{
 #ifdef IW_MLME_DEAUTH
 		case IW_MLME_DEAUTH:
-			DBGPRINT(RT_DEBUG_TRACE, ("====> %s - IW_MLME_DEAUTH\n", __FUNCTION__));
+			DBGPRINT(RT_DEBUG_TRACE, ("====> %s - IW_MLME_DEAUTH\n", __func__));
 			COPY_MAC_ADDR(DeAuthReq.Addr, pAd->CommonCfg.Bssid);
 			DeAuthReq.Reason = pMlme->reason_code;
 			MsgElem.MsgLen = sizeof(MLME_DEAUTH_REQ_STRUCT);
@@ -2243,7 +2243,7 @@ int rt_ioctl_siwmlme(struct net_device *dev,
 #endif // IW_MLME_DEAUTH //
 #ifdef IW_MLME_DISASSOC
 		case IW_MLME_DISASSOC:
-			DBGPRINT(RT_DEBUG_TRACE, ("====> %s - IW_MLME_DISASSOC\n", __FUNCTION__));
+			DBGPRINT(RT_DEBUG_TRACE, ("====> %s - IW_MLME_DISASSOC\n", __func__));
 			COPY_MAC_ADDR(DisAssocReq.Addr, pAd->CommonCfg.Bssid);
 			DisAssocReq.Reason =  pMlme->reason_code;
 
@@ -2257,7 +2257,7 @@ int rt_ioctl_siwmlme(struct net_device *dev,
 			break;
 #endif // IW_MLME_DISASSOC //
 		default:
-			DBGPRINT(RT_DEBUG_TRACE, ("====> %s - Unknow Command\n", __FUNCTION__));
+			DBGPRINT(RT_DEBUG_TRACE, ("====> %s - Unknow Command\n", __func__));
 			break;
 	}
 
@@ -2290,7 +2290,7 @@ int rt_ioctl_siwauth(struct net_device *dev,
             else if (param->value == IW_AUTH_WPA_VERSION_WPA2)
                 pAdapter->StaCfg.AuthMode = Ndis802_11AuthModeWPA2PSK;
 
-            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_WPA_VERSION - param->value = %d!\n", __FUNCTION__, param->value));
+            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_WPA_VERSION - param->value = %d!\n", __func__, param->value));
             break;
     	case IW_AUTH_CIPHER_PAIRWISE:
             if (param->value == IW_AUTH_CIPHER_NONE)
@@ -2321,7 +2321,7 @@ int rt_ioctl_siwauth(struct net_device *dev,
                 pAdapter->StaCfg.OrigWepStatus = pAdapter->StaCfg.WepStatus;
                 pAdapter->StaCfg.PairCipher = Ndis802_11Encryption3Enabled;
             }
-            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_CIPHER_PAIRWISE - param->value = %d!\n", __FUNCTION__, param->value));
+            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_CIPHER_PAIRWISE - param->value = %d!\n", __func__, param->value));
             break;
     	case IW_AUTH_CIPHER_GROUP:
             if (param->value == IW_AUTH_CIPHER_NONE)
@@ -2341,7 +2341,7 @@ int rt_ioctl_siwauth(struct net_device *dev,
             {
                 pAdapter->StaCfg.GroupCipher = Ndis802_11Encryption3Enabled;
             }
-            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_CIPHER_GROUP - param->value = %d!\n", __FUNCTION__, param->value));
+            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_CIPHER_GROUP - param->value = %d!\n", __func__, param->value));
             break;
     	case IW_AUTH_KEY_MGMT:
             if (param->value == IW_AUTH_KEY_MGMT_802_1X)
@@ -2370,12 +2370,12 @@ int rt_ioctl_siwauth(struct net_device *dev,
             {
 				STA_PORT_SECURED(pAdapter);
             }
-            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_KEY_MGMT - param->value = %d!\n", __FUNCTION__, param->value));
+            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_KEY_MGMT - param->value = %d!\n", __func__, param->value));
             break;
     	case IW_AUTH_RX_UNENCRYPTED_EAPOL:
             break;
     	case IW_AUTH_PRIVACY_INVOKED:
-            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_PRIVACY_INVOKED - param->value = %d!\n", __FUNCTION__, param->value));
+            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_PRIVACY_INVOKED - param->value = %d!\n", __func__, param->value));
     		break;
     	case IW_AUTH_DROP_UNENCRYPTED:
             if (param->value != 0)
@@ -2384,7 +2384,7 @@ int rt_ioctl_siwauth(struct net_device *dev,
 			{
 				STA_PORT_SECURED(pAdapter);
 			}
-            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_WPA_VERSION - param->value = %d!\n", __FUNCTION__, param->value));
+            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_WPA_VERSION - param->value = %d!\n", __func__, param->value));
     		break;
     	case IW_AUTH_80211_AUTH_ALG:
 			if (param->value & IW_AUTH_ALG_SHARED_KEY)
@@ -2397,10 +2397,10 @@ int rt_ioctl_siwauth(struct net_device *dev,
 			}
             else
 				return -EINVAL;
-            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_80211_AUTH_ALG - param->value = %d!\n", __FUNCTION__, param->value));
+            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_80211_AUTH_ALG - param->value = %d!\n", __func__, param->value));
 			break;
     	case IW_AUTH_WPA_ENABLED:
-    		DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_WPA_ENABLED - Driver supports WPA!(param->value = %d)\n", __FUNCTION__, param->value));
+    		DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_WPA_ENABLED - Driver supports WPA!(param->value = %d)\n", __func__, param->value));
     		break;
     	default:
     		return -EOPNOTSUPP;
@@ -2508,7 +2508,7 @@ int rt_ioctl_siwencodeext(struct net_device *dev,
 		pAdapter->SharedKey[BSS0][keyIdx].CipherAlg = CIPHER_NONE;
 		AsicRemoveSharedKeyEntry(pAdapter, 0, (UCHAR)keyIdx);
         NdisZeroMemory(&pAdapter->SharedKey[BSS0][keyIdx], sizeof(CIPHER_KEY));
-        DBGPRINT(RT_DEBUG_TRACE, ("%s::Remove all keys!(encoding->flags = %x)\n", __FUNCTION__, encoding->flags));
+        DBGPRINT(RT_DEBUG_TRACE, ("%s::Remove all keys!(encoding->flags = %x)\n", __func__, encoding->flags));
     }
 					else
     {
@@ -2520,15 +2520,15 @@ int rt_ioctl_siwencodeext(struct net_device *dev,
         if (ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY)
         {
             pAdapter->StaCfg.DefaultKeyId = keyIdx;
-            DBGPRINT(RT_DEBUG_TRACE, ("%s::DefaultKeyId = %d\n", __FUNCTION__, pAdapter->StaCfg.DefaultKeyId));
+            DBGPRINT(RT_DEBUG_TRACE, ("%s::DefaultKeyId = %d\n", __func__, pAdapter->StaCfg.DefaultKeyId));
         }
 
         switch (alg) {
     		case IW_ENCODE_ALG_NONE:
-                DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_ENCODE_ALG_NONE\n", __FUNCTION__));
+                DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_ENCODE_ALG_NONE\n", __func__));
     			break;
     		case IW_ENCODE_ALG_WEP:
-                DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_ENCODE_ALG_WEP - ext->key_len = %d, keyIdx = %d\n", __FUNCTION__, ext->key_len, keyIdx));
+                DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_ENCODE_ALG_WEP - ext->key_len = %d, keyIdx = %d\n", __func__, ext->key_len, keyIdx));
     			if (ext->key_len == MAX_WEP_KEY_SIZE)
                 {
         			pAdapter->SharedKey[BSS0][keyIdx].KeyLen = MAX_WEP_KEY_SIZE;
@@ -2546,7 +2546,7 @@ int rt_ioctl_siwencodeext(struct net_device *dev,
 			    NdisMoveMemory(pAdapter->SharedKey[BSS0][keyIdx].Key, ext->key, ext->key_len);
     			break;
             case IW_ENCODE_ALG_TKIP:
-                DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_ENCODE_ALG_TKIP - keyIdx = %d, ext->key_len = %d\n", __FUNCTION__, keyIdx, ext->key_len));
+                DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_ENCODE_ALG_TKIP - keyIdx = %d, ext->key_len = %d\n", __func__, keyIdx, ext->key_len));
                 if (ext->key_len == 32)
                 {
                     if (ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY)
diff --git a/drivers/staging/rt2870/2870_main_dev.c b/drivers/staging/rt2870/2870_main_dev.c
index 91da4e2..04c764d 100644
--- a/drivers/staging/rt2870/2870_main_dev.c
+++ b/drivers/staging/rt2870/2870_main_dev.c
@@ -263,7 +263,7 @@ INT MlmeThread(
 	 * This is important in preemption kernels, which transfer the flow
 	 * of execution immediately upon a complete().
 	 */
-	DBGPRINT(RT_DEBUG_TRACE,( "<---%s\n",__FUNCTION__));
+	DBGPRINT(RT_DEBUG_TRACE,( "<---%s\n",__func__));
 
 	pObj->MLMEThr_pid = THREAD_PID_INIT_VALUE;
 
@@ -465,7 +465,7 @@ INT TimerQThread(
 	 * This is important in preemption kernels, which transfer the flow
 	 * of execution immediately upon a complete().
 	 */
-	DBGPRINT(RT_DEBUG_TRACE,( "<---%s\n",__FUNCTION__));
+	DBGPRINT(RT_DEBUG_TRACE,( "<---%s\n",__func__));
 
 	pObj->TimerQThr_pid = THREAD_PID_INIT_VALUE;
 
@@ -1258,7 +1258,7 @@ BOOLEAN RT28XXProbePostConfig(
 
 	if (!(pAd->BulkInEpAddr && pAd->BulkOutEpAddr[0]))
 	{
-		printk("%s: Could not find both bulk-in and bulk-out endpoints\n", __FUNCTION__);
+		printk("%s: Could not find both bulk-in and bulk-out endpoints\n", __func__);
 		return FALSE;
 	}
 
diff --git a/drivers/staging/rt2870/common/2870_rtmp_init.c b/drivers/staging/rt2870/common/2870_rtmp_init.c
index 5d89a31..9f5143b 100644
--- a/drivers/staging/rt2870/common/2870_rtmp_init.c
+++ b/drivers/staging/rt2870/common/2870_rtmp_init.c
@@ -1087,7 +1087,7 @@ PNDIS_PACKET GetPacketFromRxRing(
 	if (pRxWI->MPDUtotalByteCount > ThisFrameLen)
 	{
 		DBGPRINT(RT_DEBUG_ERROR, ("%s():pRxWIMPDUtotalByteCount(%d) large than RxDMALen(%ld)\n",
-									__FUNCTION__, pRxWI->MPDUtotalByteCount, ThisFrameLen));
+									__func__, pRxWI->MPDUtotalByteCount, ThisFrameLen));
 		goto label_null;
 	}
 #ifdef RT_BIG_ENDIAN
@@ -1098,7 +1098,7 @@ PNDIS_PACKET GetPacketFromRxRing(
 	pSkb = dev_alloc_skb(ThisFrameLen);
 	if (pSkb == NULL)
 	{
-		DBGPRINT(RT_DEBUG_ERROR,("%s():Cannot Allocate sk buffer for this Bulk-In buffer!\n", __FUNCTION__));
+		DBGPRINT(RT_DEBUG_ERROR,("%s():Cannot Allocate sk buffer for this Bulk-In buffer!\n", __func__));
 		goto label_null;
 	}
 
diff --git a/drivers/staging/rt2870/common/ba_action.c b/drivers/staging/rt2870/common/ba_action.c
index 95addb2..d9f7381 100644
--- a/drivers/staging/rt2870/common/ba_action.c
+++ b/drivers/staging/rt2870/common/ba_action.c
@@ -595,7 +595,7 @@ VOID BAOriSessionAdd(
 
 		pBAEntry->ORIBATimer.TimerValue = 0;	//pFrame->TimeOutValue;
 
-		DBGPRINT(RT_DEBUG_TRACE,("%s : TXBAbitmap = %x, BAWinSize = %d, TimeOut = %ld\n", __FUNCTION__, pEntry->TXBAbitmap,
+		DBGPRINT(RT_DEBUG_TRACE,("%s : TXBAbitmap = %x, BAWinSize = %d, TimeOut = %ld\n", __func__, pEntry->TXBAbitmap,
 								 pBAEntry->BAWinSize, pBAEntry->ORIBATimer.TimerValue));
 
 		// SEND BAR ;
@@ -669,7 +669,7 @@ BOOLEAN BARecSessionAdd(
 		ba_refresh_reordering_mpdus(pAd, pBAEntry);
 	}
 
-	DBGPRINT(RT_DEBUG_TRACE,("%s(%ld): Idx = %d, BAWinSize(req %d) = %d\n", __FUNCTION__, pAd->BATable.numAsRecipient, Idx,
+	DBGPRINT(RT_DEBUG_TRACE,("%s(%ld): Idx = %d, BAWinSize(req %d) = %d\n", __func__, pAd->BATable.numAsRecipient, Idx,
 							 pFrame->BaParm.BufSize, BAWinSize));
 
 	// Start fill in parameters.
@@ -911,7 +911,7 @@ VOID BAOriSessionTearDown(
 		return;
 	}
 
-	DBGPRINT(RT_DEBUG_TRACE,("%s===>Wcid=%d.TID=%d \n", __FUNCTION__, Wcid, TID));
+	DBGPRINT(RT_DEBUG_TRACE,("%s===>Wcid=%d.TID=%d \n", __func__, Wcid, TID));
 
 	pBAEntry = &pAd->BATable.BAOriEntry[Idx];
 	DBGPRINT(RT_DEBUG_TRACE,("\t===>Idx = %ld, Wcid=%d.TID=%d, ORI_BA_Status = %d \n", Idx, Wcid, TID, pBAEntry->ORI_BA_Status));
@@ -970,7 +970,7 @@ VOID BARecSessionTearDown(
 	if (Idx == 0)
 		return;
 
-	DBGPRINT(RT_DEBUG_TRACE,("%s===>Wcid=%d.TID=%d \n", __FUNCTION__, Wcid, TID));
+	DBGPRINT(RT_DEBUG_TRACE,("%s===>Wcid=%d.TID=%d \n", __func__, Wcid, TID));
 
 
 	pBAEntry = &pAd->BATable.BARecEntry[Idx];
@@ -1181,7 +1181,7 @@ VOID PeerAddBAReqAction(
 	PULONG      ptemp;
 	PMAC_TABLE_ENTRY	pMacEntry;
 
-	DBGPRINT(RT_DEBUG_TRACE, ("%s ==> (Wcid = %d)\n", __FUNCTION__, Elem->Wcid));
+	DBGPRINT(RT_DEBUG_TRACE, ("%s ==> (Wcid = %d)\n", __func__, Elem->Wcid));
 
 	//hex_dump("AddBAReq", Elem->Msg, Elem->MsgLen);
 
@@ -1265,7 +1265,7 @@ VOID PeerAddBAReqAction(
 	MiniportMMRequest(pAd, QID_AC_BE, pOutBuffer, FrameLen);
 	MlmeFreeMemory(pAd, pOutBuffer);
 
-	DBGPRINT(RT_DEBUG_TRACE, ("%s(%d): TID(%d), BufSize(%d) <== \n", __FUNCTION__, Elem->Wcid, ADDframe.BaParm.TID,
+	DBGPRINT(RT_DEBUG_TRACE, ("%s(%d): TID(%d), BufSize(%d) <== \n", __func__, Elem->Wcid, ADDframe.BaParm.TID,
 							  ADDframe.BaParm.BufSize));
 }
 
@@ -1284,7 +1284,7 @@ VOID PeerAddBARspAction(
 	if (Elem->Wcid >= MAX_LEN_OF_MAC_TABLE)
 		return;
 
-	DBGPRINT(RT_DEBUG_TRACE, ("%s ==> Wcid(%d)\n", __FUNCTION__, Elem->Wcid));
+	DBGPRINT(RT_DEBUG_TRACE, ("%s ==> Wcid(%d)\n", __func__, Elem->Wcid));
 
 	//hex_dump("PeerAddBARspAction()", Elem->Msg, Elem->MsgLen);
 
@@ -1325,7 +1325,7 @@ VOID PeerDelBAAction(
 	//PUCHAR				pOutBuffer = NULL;
 	PFRAME_DELBA_REQ    pDelFrame = NULL;
 
-	DBGPRINT(RT_DEBUG_TRACE,("%s ==>\n", __FUNCTION__));
+	DBGPRINT(RT_DEBUG_TRACE,("%s ==>\n", __func__));
 	//DELBA Request from unknown peer, ignore this.
 	if (PeerDelBAActionSanity(pAd, Elem->Wcid, Elem->Msg, Elem->MsgLen))
 	{
@@ -1362,7 +1362,7 @@ BOOLEAN CntlEnqueueForRecv(
 
 	TID = (UCHAR)pFrame->BARControl.TID;
 
-	DBGPRINT(RT_DEBUG_TRACE, ("%s(): BAR-Wcid(%ld), Tid (%d)\n", __FUNCTION__, Wcid, TID));
+	DBGPRINT(RT_DEBUG_TRACE, ("%s(): BAR-Wcid(%ld), Tid (%d)\n", __func__, Wcid, TID));
 	//hex_dump("BAR", (PCHAR) pFrame, MsgLen);
 	// Do nothing if the driver is starting halt state.
 	// This might happen when timer already been fired before cancel timer with mlmehalt
diff --git a/drivers/staging/rt2870/common/cmm_data.c b/drivers/staging/rt2870/common/cmm_data.c
index 4477a8e..fd809ab 100644
--- a/drivers/staging/rt2870/common/cmm_data.c
+++ b/drivers/staging/rt2870/common/cmm_data.c
@@ -2009,7 +2009,7 @@ BOOLEAN MacTableDeleteEntry(
 		}
 		else
 		{
-			printk("\n%s: Impossible Wcid = %d !!!!!\n", __FUNCTION__, wcid);
+			printk("\n%s: Impossible Wcid = %d !!!!!\n", __func__, wcid);
 		}
 	}
 
diff --git a/drivers/staging/rt2870/common/cmm_info.c b/drivers/staging/rt2870/common/cmm_info.c
index 40792e1..47a1b1a 100644
--- a/drivers/staging/rt2870/common/cmm_info.c
+++ b/drivers/staging/rt2870/common/cmm_info.c
@@ -2331,7 +2331,7 @@ VOID RTMPIoctlGetMacTable(
 	wrq->u.data.length = sizeof(RT_802_11_MAC_TABLE);
 	if (copy_to_user(wrq->u.data.pointer, &MacTab, wrq->u.data.length))
 	{
-		DBGPRINT(RT_DEBUG_TRACE, ("%s: copy_to_user() fail\n", __FUNCTION__));
+		DBGPRINT(RT_DEBUG_TRACE, ("%s: copy_to_user() fail\n", __func__));
 	}
 
 	msg = (CHAR *) kmalloc(sizeof(CHAR)*(MAX_LEN_OF_MAC_TABLE*MAC_LINE_LEN), MEM_ALLOC_FLAG);
diff --git a/drivers/staging/rt2870/common/dfs.c b/drivers/staging/rt2870/common/dfs.c
index 23cf151..b09bba5 100644
--- a/drivers/staging/rt2870/common/dfs.c
+++ b/drivers/staging/rt2870/common/dfs.c
@@ -428,7 +428,7 @@ INT Set_ChMovingTime_Proc(
 
 	pAd->CommonCfg.RadarDetect.ChMovingTime = Value;
 
-	DBGPRINT(RT_DEBUG_TRACE, ("%s:: %d\n", __FUNCTION__,
+	DBGPRINT(RT_DEBUG_TRACE, ("%s:: %d\n", __func__,
 		pAd->CommonCfg.RadarDetect.ChMovingTime));
 
 	return TRUE;
@@ -444,7 +444,7 @@ INT Set_LongPulseRadarTh_Proc(
 
 	pAd->CommonCfg.RadarDetect.LongPulseRadarTh = Value;
 
-	DBGPRINT(RT_DEBUG_TRACE, ("%s:: %d\n", __FUNCTION__,
+	DBGPRINT(RT_DEBUG_TRACE, ("%s:: %d\n", __func__,
 		pAd->CommonCfg.RadarDetect.LongPulseRadarTh));
 
 	return TRUE;
diff --git a/drivers/staging/rt2870/common/rtmp_init.c b/drivers/staging/rt2870/common/rtmp_init.c
index 87028fd..870a00d 100644
--- a/drivers/staging/rt2870/common/rtmp_init.c
+++ b/drivers/staging/rt2870/common/rtmp_init.c
@@ -2746,7 +2746,7 @@ NDIS_STATUS NICLoadFirmware(
 #ifdef BIN_IN_FILE
 #define NICLF_DEFAULT_USE()	\
 	flg_default_firm_use = TRUE; \
-	printk("%s - Use default firmware!\n", __FUNCTION__);
+	printk("%s - Use default firmware!\n", __func__);
 
 	NDIS_STATUS		Status = NDIS_STATUS_SUCCESS;
 	PUCHAR			src;
@@ -2761,7 +2761,7 @@ NDIS_STATUS NICLoadFirmware(
 	BOOLEAN			flg_default_firm_use = FALSE;
 
 
-	DBGPRINT(RT_DEBUG_TRACE, ("===> %s\n", __FUNCTION__));
+	DBGPRINT(RT_DEBUG_TRACE, ("===> %s\n", __func__));
 
 	/* init */
 	pFirmwareImage = NULL;
@@ -2784,7 +2784,7 @@ NDIS_STATUS NICLoadFirmware(
     if (pFirmwareImage == NULL)
 	{
 		/* allocate fail, use default firmware array in firmware.h */
-		printk("%s - Allocate memory fail!\n", __FUNCTION__);
+		printk("%s - Allocate memory fail!\n", __func__);
 		NICLF_DEFAULT_USE();
     }
 	else
@@ -2805,7 +2805,7 @@ NDIS_STATUS NICLoadFirmware(
 			if (IS_ERR(srcf))
 			{
 				printk("%s - Error %ld opening %s\n",
-					   __FUNCTION__, -PTR_ERR(srcf), src);
+					   __func__, -PTR_ERR(srcf), src);
 				NICLF_DEFAULT_USE();
 				break;
 			} /* End of if */
@@ -2813,7 +2813,7 @@ NDIS_STATUS NICLoadFirmware(
 			/* the object must have a read method */
 			if ((srcf->f_op == NULL) || (srcf->f_op->read == NULL))
 			{
-				printk("%s - %s does not have a write method\n", __FUNCTION__, src);
+				printk("%s - %s does not have a write method\n", __func__, src);
 				NICLF_DEFAULT_USE();
 				break;
 			} /* End of if */
@@ -2827,7 +2827,7 @@ NDIS_STATUS NICLoadFirmware(
 			if (FileLength != MAX_FIRMWARE_IMAGE_SIZE)
 			{
 				printk("%s: error file length (=%d) in RT2860AP.BIN\n",
-					   __FUNCTION__, FileLength);
+					   __func__, FileLength);
 				NICLF_DEFAULT_USE();
 				break;
 			}
@@ -2850,7 +2850,7 @@ NDIS_STATUS NICLoadFirmware(
 					/* CRC fail */
 					printk("%s: CRC = 0x%02x 0x%02x "
 						   "error, should be 0x%02x 0x%02x\n",
-						   __FUNCTION__,
+						   __func__,
 						   pFirmwareImage[MAX_FIRMWARE_IMAGE_SIZE-2],
 						   pFirmwareImage[MAX_FIRMWARE_IMAGE_SIZE-1],
 						   (UCHAR)(crc>>8), (UCHAR)(crc));
@@ -2869,7 +2869,7 @@ NDIS_STATUS NICLoadFirmware(
 											((FIRMWARE_MAJOR_VERSION << 8) +
 									  	 	 FIRMWARE_MINOR_VERSION))
 					{
-						printk("%s: firmware version too old!\n", __FUNCTION__);
+						printk("%s: firmware version too old!\n", __func__);
 						NICLF_DEFAULT_USE();
 						break;
 					} /* End of if */
@@ -3024,10 +3024,10 @@ NDIS_STATUS NICLoadFirmware(
 
 #if 0
     DBGPRINT(RT_DEBUG_TRACE,
-			 ("<=== %s (src=%s, status=%d)\n", __FUNCTION__, src, Status));
+			 ("<=== %s (src=%s, status=%d)\n", __func__, src, Status));
 #else
     DBGPRINT(RT_DEBUG_TRACE,
-			 ("<=== %s (status=%d)\n", __FUNCTION__, Status));
+			 ("<=== %s (status=%d)\n", __func__, Status));
 #endif
     return Status;
 } /* End of NICLoadFirmware */
diff --git a/drivers/staging/rt2870/common/rtusb_bulk.c b/drivers/staging/rt2870/common/rtusb_bulk.c
index 3c6ba1b..c46d916 100644
--- a/drivers/staging/rt2870/common/rtusb_bulk.c
+++ b/drivers/staging/rt2870/common/rtusb_bulk.c
@@ -329,7 +329,7 @@ VOID	RTUSBBulkOutDataPacket(
 
 		if (pTxInfo->QSEL != FIFO_EDCA)
 		{
-			printk("%s(): ====> pTxInfo->QueueSel(%d)!= FIFO_EDCA!!!!\n", __FUNCTION__, pTxInfo->QSEL);
+			printk("%s(): ====> pTxInfo->QueueSel(%d)!= FIFO_EDCA!!!!\n", __func__, pTxInfo->QSEL);
 			printk("\tCWPos=%ld, NBPos=%ld, ENBPos=%ld, bCopy=%d!\n", pHTTXContext->CurWritePosition, pHTTXContext->NextBulkOutPosition, pHTTXContext->ENextBulkOutPosition, pHTTXContext->bCopySavePad);
 			hex_dump("Wrong QSel Pkt:", (PUCHAR)&pWirelessPkt[TmpBulkEndPos], (pHTTXContext->CurWritePosition - pHTTXContext->NextBulkOutPosition));
 		}
@@ -942,7 +942,7 @@ VOID	RTUSBBulkOutMLMEPacket(
 	pTxInfo = (PTXINFO_STRUC)pMLMEContext->TransferBuffer;
 	if (pTxInfo->QSEL != FIFO_EDCA)
 	{
-			printk("%s(): ====> pTxInfo->QueueSel(%d)!= FIFO_EDCA!!!!\n", __FUNCTION__, pTxInfo->QSEL);
+			printk("%s(): ====> pTxInfo->QueueSel(%d)!= FIFO_EDCA!!!!\n", __func__, pTxInfo->QSEL);
 			printk("\tMLME_Index=%d!\n", Index);
 			hex_dump("Wrong QSel Pkt:", (PUCHAR)pMLMEContext->TransferBuffer, pTxInfo->USBDMATxPktLen);
 	}
diff --git a/drivers/staging/rt2870/common/spectrum.c b/drivers/staging/rt2870/common/spectrum.c
index abba840..43782ce 100644
--- a/drivers/staging/rt2870/common/spectrum.c
+++ b/drivers/staging/rt2870/common/spectrum.c
@@ -48,7 +48,7 @@ VOID MeasureReqTabInit(
 	if (pAd->CommonCfg.pMeasureReqTab)
 		NdisZeroMemory(pAd->CommonCfg.pMeasureReqTab, sizeof(MEASURE_REQ_TAB));
 	else
-		DBGPRINT(RT_DEBUG_ERROR, ("%s Fail to alloc memory for pAd->CommonCfg.pMeasureReqTab.\n", __FUNCTION__));
+		DBGPRINT(RT_DEBUG_ERROR, ("%s Fail to alloc memory for pAd->CommonCfg.pMeasureReqTab.\n", __func__));
 
 	return;
 }
@@ -76,7 +76,7 @@ static PMEASURE_REQ_ENTRY MeasureReqLookUp(
 
 	if (pTab == NULL)
 	{
-		DBGPRINT(RT_DEBUG_ERROR, ("%s: pMeasureReqTab doesn't exist.\n", __FUNCTION__));
+		DBGPRINT(RT_DEBUG_ERROR, ("%s: pMeasureReqTab doesn't exist.\n", __func__));
 		return NULL;
 	}
 
@@ -113,7 +113,7 @@ static PMEASURE_REQ_ENTRY MeasureReqInsert(
 
 	if(pTab == NULL)
 	{
-		DBGPRINT(RT_DEBUG_ERROR, ("%s: pMeasureReqTab doesn't exist.\n", __FUNCTION__));
+		DBGPRINT(RT_DEBUG_ERROR, ("%s: pMeasureReqTab doesn't exist.\n", __func__));
 		return NULL;
 	}
 
@@ -174,7 +174,7 @@ static PMEASURE_REQ_ENTRY MeasureReqInsert(
 		else
 		{
 			pEntry = NULL;
-			DBGPRINT(RT_DEBUG_ERROR, ("%s: pMeasureReqTab tab full.\n", __FUNCTION__));
+			DBGPRINT(RT_DEBUG_ERROR, ("%s: pMeasureReqTab tab full.\n", __func__));
 		}
 
 		// add this Neighbor entry into HASH table
@@ -209,7 +209,7 @@ static VOID MeasureReqDelete(
 
 	if(pTab == NULL)
 	{
-		DBGPRINT(RT_DEBUG_ERROR, ("%s: pMeasureReqTab doesn't exist.\n", __FUNCTION__));
+		DBGPRINT(RT_DEBUG_ERROR, ("%s: pMeasureReqTab doesn't exist.\n", __func__));
 		return;
 	}
 
@@ -266,7 +266,7 @@ VOID TpcReqTabInit(
 	if (pAd->CommonCfg.pTpcReqTab)
 		NdisZeroMemory(pAd->CommonCfg.pTpcReqTab, sizeof(TPC_REQ_TAB));
 	else
-		DBGPRINT(RT_DEBUG_ERROR, ("%s Fail to alloc memory for pAd->CommonCfg.pTpcReqTab.\n", __FUNCTION__));
+		DBGPRINT(RT_DEBUG_ERROR, ("%s Fail to alloc memory for pAd->CommonCfg.pTpcReqTab.\n", __func__));
 
 	return;
 }
@@ -294,7 +294,7 @@ static PTPC_REQ_ENTRY TpcReqLookUp(
 
 	if (pTab == NULL)
 	{
-		DBGPRINT(RT_DEBUG_ERROR, ("%s: pTpcReqTab doesn't exist.\n", __FUNCTION__));
+		DBGPRINT(RT_DEBUG_ERROR, ("%s: pTpcReqTab doesn't exist.\n", __func__));
 		return NULL;
 	}
 
@@ -332,7 +332,7 @@ static PTPC_REQ_ENTRY TpcReqInsert(
 
 	if(pTab == NULL)
 	{
-		DBGPRINT(RT_DEBUG_ERROR, ("%s: pTpcReqTab doesn't exist.\n", __FUNCTION__));
+		DBGPRINT(RT_DEBUG_ERROR, ("%s: pTpcReqTab doesn't exist.\n", __func__));
 		return NULL;
 	}
 
@@ -393,7 +393,7 @@ static PTPC_REQ_ENTRY TpcReqInsert(
 		else
 		{
 			pEntry = NULL;
-			DBGPRINT(RT_DEBUG_ERROR, ("%s: pTpcReqTab tab full.\n", __FUNCTION__));
+			DBGPRINT(RT_DEBUG_ERROR, ("%s: pTpcReqTab tab full.\n", __func__));
 		}
 
 		// add this Neighbor entry into HASH table
@@ -428,7 +428,7 @@ static VOID TpcReqDelete(
 
 	if(pTab == NULL)
 	{
-		DBGPRINT(RT_DEBUG_ERROR, ("%s: pTpcReqTab doesn't exist.\n", __FUNCTION__));
+		DBGPRINT(RT_DEBUG_ERROR, ("%s: pTpcReqTab doesn't exist.\n", __func__));
 		return;
 	}
 
@@ -781,7 +781,7 @@ VOID EnqueueMeasurementReq(
 	NStatus = MlmeAllocateMemory(pAd, (PVOID)&pOutBuffer);  //Get an unused nonpaged memory
 	if(NStatus != NDIS_STATUS_SUCCESS)
 	{
-		DBGPRINT(RT_DEBUG_TRACE, ("%s() allocate memory failed \n", __FUNCTION__));
+		DBGPRINT(RT_DEBUG_TRACE, ("%s() allocate memory failed \n", __func__));
 		return;
 	}
 	NdisMoveMemory(pOutBuffer, (PCHAR)&ActHdr, sizeof(HEADER_802_11));
@@ -843,7 +843,7 @@ VOID EnqueueMeasurementRep(
 	NStatus = MlmeAllocateMemory(pAd, (PVOID)&pOutBuffer);  //Get an unused nonpaged memory
 	if(NStatus != NDIS_STATUS_SUCCESS)
 	{
-		DBGPRINT(RT_DEBUG_TRACE, ("%s() allocate memory failed \n", __FUNCTION__));
+		DBGPRINT(RT_DEBUG_TRACE, ("%s() allocate memory failed \n", __func__));
 		return;
 	}
 	NdisMoveMemory(pOutBuffer, (PCHAR)&ActHdr, sizeof(HEADER_802_11));
@@ -897,7 +897,7 @@ VOID EnqueueTPCReq(
 	NStatus = MlmeAllocateMemory(pAd, (PVOID)&pOutBuffer);  //Get an unused nonpaged memory
 	if(NStatus != NDIS_STATUS_SUCCESS)
 	{
-		DBGPRINT(RT_DEBUG_TRACE, ("%s() allocate memory failed \n", __FUNCTION__));
+		DBGPRINT(RT_DEBUG_TRACE, ("%s() allocate memory failed \n", __func__));
 		return;
 	}
 	NdisMoveMemory(pOutBuffer, (PCHAR)&ActHdr, sizeof(HEADER_802_11));
@@ -949,7 +949,7 @@ VOID EnqueueTPCRep(
 	NStatus = MlmeAllocateMemory(pAd, (PVOID)&pOutBuffer);  //Get an unused nonpaged memory
 	if(NStatus != NDIS_STATUS_SUCCESS)
 	{
-		DBGPRINT(RT_DEBUG_TRACE, ("%s() allocate memory failed \n", __FUNCTION__));
+		DBGPRINT(RT_DEBUG_TRACE, ("%s() allocate memory failed \n", __func__));
 		return;
 	}
 	NdisMoveMemory(pOutBuffer, (PCHAR)&ActHdr, sizeof(HEADER_802_11));
@@ -1002,7 +1002,7 @@ VOID EnqueueChSwAnn(
 	NStatus = MlmeAllocateMemory(pAd, (PVOID)&pOutBuffer);  //Get an unused nonpaged memory
 	if(NStatus != NDIS_STATUS_SUCCESS)
 	{
-		DBGPRINT(RT_DEBUG_TRACE, ("%s() allocate memory failed \n", __FUNCTION__));
+		DBGPRINT(RT_DEBUG_TRACE, ("%s() allocate memory failed \n", __func__));
 		return;
 	}
 	NdisMoveMemory(pOutBuffer, (PCHAR)&ActHdr, sizeof(HEADER_802_11));
@@ -1595,7 +1595,7 @@ static VOID PeerMeasureReportAction(
 
 	if ((pMeasureReportInfo = kmalloc(sizeof(MEASURE_RPI_REPORT), GFP_ATOMIC)) == NULL)
 	{
-		DBGPRINT(RT_DEBUG_ERROR, ("%s unable to alloc memory for measure report buffer (size=%d).\n", __FUNCTION__, sizeof(MEASURE_RPI_REPORT)));
+		DBGPRINT(RT_DEBUG_ERROR, ("%s unable to alloc memory for measure report buffer (size=%d).\n", __func__, sizeof(MEASURE_RPI_REPORT)));
 		return;
 	}
 
@@ -1704,7 +1704,7 @@ static VOID PeerTpcRepAction(
 		{
 			TpcReqDelete(pAd, pEntry->DialogToken);
 			DBGPRINT(RT_DEBUG_TRACE, ("%s: DialogToken=%x, TxPwr=%d, LinkMargin=%d\n",
-				__FUNCTION__, DialogToken, TpcRepInfo.TxPwr, TpcRepInfo.LinkMargin));
+				__func__, DialogToken, TpcRepInfo.TxPwr, TpcRepInfo.LinkMargin));
 		}
 	}
 
@@ -1820,7 +1820,7 @@ INT Set_MeasureReq_Proc(
 				MeasureReqType = simple_strtol(thisChar, 0, 16);
 				if (MeasureReqType > 3)
 				{
-					DBGPRINT(RT_DEBUG_ERROR, ("%s: unknow MeasureReqType(%d)\n", __FUNCTION__, MeasureReqType));
+					DBGPRINT(RT_DEBUG_ERROR, ("%s: unknow MeasureReqType(%d)\n", __func__, MeasureReqType));
 					return TRUE;
 				}
 				break;
@@ -1832,10 +1832,10 @@ INT Set_MeasureReq_Proc(
 		ArgIdx++;
 	}
 
-	DBGPRINT(RT_DEBUG_TRACE, ("%s::Aid = %d, MeasureReqType=%d MeasureCh=%d\n", __FUNCTION__, Aid, MeasureReqType, MeasureCh));
+	DBGPRINT(RT_DEBUG_TRACE, ("%s::Aid = %d, MeasureReqType=%d MeasureCh=%d\n", __func__, Aid, MeasureReqType, MeasureCh));
 	if (!VALID_WCID(Aid))
 	{
-		DBGPRINT(RT_DEBUG_ERROR, ("%s: unknow sta of Aid(%d)\n", __FUNCTION__, Aid));
+		DBGPRINT(RT_DEBUG_ERROR, ("%s: unknow sta of Aid(%d)\n", __func__, Aid));
 		return TRUE;
 	}
 
@@ -1860,10 +1860,10 @@ INT Set_TpcReq_Proc(
 
 	Aid = simple_strtol(arg, 0, 16);
 
-	DBGPRINT(RT_DEBUG_TRACE, ("%s::Aid = %d\n", __FUNCTION__, Aid));
+	DBGPRINT(RT_DEBUG_TRACE, ("%s::Aid = %d\n", __func__, Aid));
 	if (!VALID_WCID(Aid))
 	{
-		DBGPRINT(RT_DEBUG_ERROR, ("%s: unknow sta of Aid(%d)\n", __FUNCTION__, Aid));
+		DBGPRINT(RT_DEBUG_ERROR, ("%s: unknow sta of Aid(%d)\n", __func__, Aid));
 		return TRUE;
 	}
 
diff --git a/drivers/staging/rt2870/rt_ate.c b/drivers/staging/rt2870/rt_ate.c
index e99b3da..27c763e 100644
--- a/drivers/staging/rt2870/rt_ate.c
+++ b/drivers/staging/rt2870/rt_ate.c
@@ -314,7 +314,7 @@ static INT ATETxPwrHandler(
 				Bbp94 = BBPR94_DEFAULT;
 			}
 
-			ATEDBGPRINT(RT_DEBUG_TRACE, ("%s (TxPower=%d, R=%ld, BBP_R94=%d)\n", __FUNCTION__, TxPower, R, Bbp94));
+			ATEDBGPRINT(RT_DEBUG_TRACE, ("%s (TxPower=%d, R=%ld, BBP_R94=%d)\n", __func__, TxPower, R, Bbp94));
 		}
 		else// 5.5 GHz
 		{
@@ -341,7 +341,7 @@ static INT ATETxPwrHandler(
 				R = (ULONG) TxPower;
 			}
 
-			ATEDBGPRINT(RT_DEBUG_TRACE, ("%s (TxPower=%d, R=%lu)\n", __FUNCTION__, TxPower, R));
+			ATEDBGPRINT(RT_DEBUG_TRACE, ("%s (TxPower=%d, R=%lu)\n", __func__, TxPower, R));
 		}
 
 		if (pAd->ate.Channel <= 14)
@@ -454,7 +454,7 @@ static INT ATETxPwrHandler(
 		Bbp94 = BBPR94_DEFAULT;
 	}
 
-	ATEDBGPRINT(RT_DEBUG_TRACE, ("%s (TxPower=%d, R3=%ld, BBP_R94=%d)\n", __FUNCTION__, TxPower, R, Bbp94));
+	ATEDBGPRINT(RT_DEBUG_TRACE, ("%s (TxPower=%d, R3=%ld, BBP_R94=%d)\n", __func__, TxPower, R, Bbp94));
 
 		if (pAd->ate.Channel <= 14)
 		{
@@ -2261,7 +2261,7 @@ INT Set_ATE_Load_E2P_Proc(
 	UINT32			FileLength = 0;
 	UINT32 			value = simple_strtol(arg, 0, 10);
 
-	ATEDBGPRINT(RT_DEBUG_ERROR, ("===> %s (value=%d)\n\n", __FUNCTION__, value));
+	ATEDBGPRINT(RT_DEBUG_ERROR, ("===> %s (value=%d)\n\n", __func__, value));
 
 	if (value > 0)
 	{
@@ -2285,14 +2285,14 @@ INT Set_ATE_Load_E2P_Proc(
 
 			if (IS_ERR(srcf))
 			{
-				ate_print("%s - Error %ld opening %s\n", __FUNCTION__, -PTR_ERR(srcf), src);
+				ate_print("%s - Error %ld opening %s\n", __func__, -PTR_ERR(srcf), src);
 				break;
 			}
 
 			/* the object must have a read method */
 			if ((srcf->f_op == NULL) || (srcf->f_op->read == NULL))
 			{
-				ate_print("%s - %s does not have a read method\n", __FUNCTION__, src);
+				ate_print("%s - %s does not have a read method\n", __func__, src);
 				break;
 			}
 
@@ -2305,7 +2305,7 @@ INT Set_ATE_Load_E2P_Proc(
 			if (FileLength != EEPROM_SIZE)
 			{
 				ate_print("%s: error file length (=%d) in e2p.bin\n",
-					   __FUNCTION__, FileLength);
+					   __func__, FileLength);
 				break;
 			}
 			else
@@ -2337,7 +2337,7 @@ INT Set_ATE_Load_E2P_Proc(
 		current->fsuid = orgfsuid;
 		current->fsgid = orgfsgid;
 	}
-    ATEDBGPRINT(RT_DEBUG_ERROR, ("<=== %s (ret=%d)\n", __FUNCTION__, ret));
+    ATEDBGPRINT(RT_DEBUG_ERROR, ("<=== %s (ret=%d)\n", __func__, ret));
 
     return ret;
 
@@ -2350,12 +2350,12 @@ INT Set_ATE_Load_E2P_Proc(
 	USHORT 			WriteEEPROM[(EEPROM_SIZE/2)];
 	struct iwreq	*wrq = (struct iwreq *)arg;
 
-	ATEDBGPRINT(RT_DEBUG_TRACE, ("===> %s (wrq->u.data.length = %d)\n\n", __FUNCTION__, wrq->u.data.length));
+	ATEDBGPRINT(RT_DEBUG_TRACE, ("===> %s (wrq->u.data.length = %d)\n\n", __func__, wrq->u.data.length));
 
 	if (wrq->u.data.length != EEPROM_SIZE)
 	{
 		ate_print("%s: error length (=%d) from host\n",
-			   __FUNCTION__, wrq->u.data.length);
+			   __func__, wrq->u.data.length);
 		return FALSE;
 	}
 	else/* (wrq->u.data.length == EEPROM_SIZE) */
@@ -2374,7 +2374,7 @@ INT Set_ATE_Load_E2P_Proc(
 		} while(FALSE);
 		}
 
-    ATEDBGPRINT(RT_DEBUG_TRACE, ("<=== %s\n", __FUNCTION__));
+    ATEDBGPRINT(RT_DEBUG_TRACE, ("<=== %s\n", __func__));
 
     return TRUE;
 
@@ -4083,7 +4083,7 @@ VOID RtmpDoAte(
 
 	Command_Id = ntohs(pRaCfg->command_id);
 
-	ATEDBGPRINT(RT_DEBUG_TRACE,("\n%s: Command_Id = 0x%04x !\n", __FUNCTION__, Command_Id));
+	ATEDBGPRINT(RT_DEBUG_TRACE,("\n%s: Command_Id = 0x%04x !\n", __func__, Command_Id));
 
 	switch (Command_Id)
 	{
@@ -6117,7 +6117,7 @@ BOOLEAN SyncTxRxConfig(PRTMP_ADAPTER pAd, USHORT offset, UCHAR value)
 					pAd->ate.TxAntennaSel = 2;
 		            break;
 		        default:
-		            DBGPRINT(RT_DEBUG_TRACE, ("%s -- Sth. wrong!  : return FALSE; \n", __FUNCTION__));
+		            DBGPRINT(RT_DEBUG_TRACE, ("%s -- Sth. wrong!  : return FALSE; \n", __func__));
 		            return FALSE;
 		    }
 			break;/* case BBP_R1 */
@@ -6155,13 +6155,13 @@ BOOLEAN SyncTxRxConfig(PRTMP_ADAPTER pAd, USHORT offset, UCHAR value)
 					pAd->ate.RxAntennaSel = 3;
 		            break;
 		        default:
-		            DBGPRINT(RT_DEBUG_ERROR, ("%s -- Impossible!  : return FALSE; \n", __FUNCTION__));
+		            DBGPRINT(RT_DEBUG_ERROR, ("%s -- Impossible!  : return FALSE; \n", __func__));
 		            return FALSE;
 		    }
 			break;/* case BBP_R3 */
 
         default:
-            DBGPRINT(RT_DEBUG_ERROR, ("%s -- Sth. wrong!  : return FALSE; \n", __FUNCTION__));
+            DBGPRINT(RT_DEBUG_ERROR, ("%s -- Sth. wrong!  : return FALSE; \n", __func__));
             return FALSE;
 
 	}
diff --git a/drivers/staging/rt2870/rt_linux.c b/drivers/staging/rt2870/rt_linux.c
index f2ea8eb..992e3d1 100644
--- a/drivers/staging/rt2870/rt_linux.c
+++ b/drivers/staging/rt2870/rt_linux.c
@@ -404,7 +404,7 @@ NDIS_STATUS RTMPAllocateNdisPacket(
  	skb_put(GET_OS_PKT_TYPE(pPacket), HeaderLen+DataLen);
 
 	RTMP_SET_PACKET_SOURCE(pPacket, PKTSRC_NDIS);
-//	printk("%s : pPacket = %p, len = %d\n", __FUNCTION__, pPacket, GET_OS_PKT_LEN(pPacket));
+//	printk("%s : pPacket = %p, len = %d\n", __func__, pPacket, GET_OS_PKT_LEN(pPacket));
 	*ppPacket = pPacket;
 	return NDIS_STATUS_SUCCESS;
 }
@@ -814,13 +814,13 @@ VOID RTMPSendWirelessEvent(
 
 	if (event_table_len == 0)
 	{
-		DBGPRINT(RT_DEBUG_ERROR, ("%s : The type(%0x02x) is not valid.\n", __FUNCTION__, type));
+		DBGPRINT(RT_DEBUG_ERROR, ("%s : The type(%0x02x) is not valid.\n", __func__, type));
 		return;
 	}
 
 	if (event >= event_table_len)
 	{
-		DBGPRINT(RT_DEBUG_ERROR, ("%s : The event(%0x02x) is not valid.\n", __FUNCTION__, event));
+		DBGPRINT(RT_DEBUG_ERROR, ("%s : The event(%0x02x) is not valid.\n", __func__, event));
 		return;
 	}
 
@@ -858,14 +858,14 @@ VOID RTMPSendWirelessEvent(
 		//send wireless event
 	    wireless_send_event(pAd->net_dev, IWEVCUSTOM, &wrqu, pBuf);
 
-		//DBGPRINT(RT_DEBUG_TRACE, ("%s : %s\n", __FUNCTION__, pBuf));
+		//DBGPRINT(RT_DEBUG_TRACE, ("%s : %s\n", __func__, pBuf));
 
 		kfree(pBuf);
 	}
 	else
-		DBGPRINT(RT_DEBUG_ERROR, ("%s : Can't allocate memory for wireless event.\n", __FUNCTION__));
+		DBGPRINT(RT_DEBUG_ERROR, ("%s : Can't allocate memory for wireless event.\n", __func__));
 #else
-	DBGPRINT(RT_DEBUG_ERROR, ("%s : The Wireless Extension MUST be v15 or newer.\n", __FUNCTION__));
+	DBGPRINT(RT_DEBUG_ERROR, ("%s : The Wireless Extension MUST be v15 or newer.\n", __func__));
 #endif  /* WIRELESS_EXT >= 15 */
 }
 
@@ -889,13 +889,13 @@ void send_monitor_packets(
     ASSERT(pRxBlk->pRxPacket);
     if (pRxBlk->DataSize < 10)
     {
-        DBGPRINT(RT_DEBUG_ERROR, ("%s : Size is too small! (%d)\n", __FUNCTION__, pRxBlk->DataSize));
+        DBGPRINT(RT_DEBUG_ERROR, ("%s : Size is too small! (%d)\n", __func__, pRxBlk->DataSize));
 		goto err_free_sk_buff;
     }
 
     if (pRxBlk->DataSize + sizeof(wlan_ng_prism2_header) > RX_BUFFER_AGGRESIZE)
     {
-        DBGPRINT(RT_DEBUG_ERROR, ("%s : Size is too large! (%d)\n", __FUNCTION__, pRxBlk->DataSize + sizeof(wlan_ng_prism2_header)));
+        DBGPRINT(RT_DEBUG_ERROR, ("%s : Size is too large! (%d)\n", __func__, pRxBlk->DataSize + sizeof(wlan_ng_prism2_header)));
 		goto err_free_sk_buff;
     }
 
@@ -951,7 +951,7 @@ void send_monitor_packets(
 
     if (skb_headroom(pOSPkt) < (sizeof(wlan_ng_prism2_header)+ header_len)) {
         if (pskb_expand_head(pOSPkt, (sizeof(wlan_ng_prism2_header) + header_len), 0, GFP_ATOMIC)) {
-	        DBGPRINT(RT_DEBUG_ERROR, ("%s : Reallocate header size of sk_buff fail!\n", __FUNCTION__));
+	        DBGPRINT(RT_DEBUG_ERROR, ("%s : Reallocate header size of sk_buff fail!\n", __func__));
 			goto err_free_sk_buff;
 	    } //end if
     } //end if
diff --git a/drivers/staging/rt2870/rt_linux.h b/drivers/staging/rt2870/rt_linux.h
index 8142975..859f9ce 100644
--- a/drivers/staging/rt2870/rt_linux.h
+++ b/drivers/staging/rt2870/rt_linux.h
@@ -124,7 +124,7 @@ typedef int (*HARD_START_XMIT_FUNC)(struct sk_buff *skb, struct net_device *net_
 #define RT_MOD_INC_USE_COUNT() \
 	if (!try_module_get(THIS_MODULE)) \
 	{ \
-		DBGPRINT(RT_DEBUG_ERROR, ("%s: cannot reserve module\n", __FUNCTION__)); \
+		DBGPRINT(RT_DEBUG_ERROR, ("%s: cannot reserve module\n", __func__)); \
 		return -1; \
 	}
 
diff --git a/drivers/staging/rt2870/rt_main_dev.c b/drivers/staging/rt2870/rt_main_dev.c
index b990f8a..313ecea 100644
--- a/drivers/staging/rt2870/rt_main_dev.c
+++ b/drivers/staging/rt2870/rt_main_dev.c
@@ -1554,7 +1554,7 @@ int rt28xx_packet_xmit(struct sk_buff *skb)
 #if 0
 //	if ((pkt->data[0] & 0x1) == 0)
 	{
-		//hex_dump(__FUNCTION__, pkt->data, pkt->len);
+		//hex_dump(__func__, pkt->data, pkt->len);
 		printk("pPacket = %x\n", pPacket);
 	}
 #endif
diff --git a/drivers/staging/rt2870/rt_profile.c b/drivers/staging/rt2870/rt_profile.c
index c4474a6..467fea3 100644
--- a/drivers/staging/rt2870/rt_profile.c
+++ b/drivers/staging/rt2870/rt_profile.c
@@ -1024,7 +1024,7 @@ NDIS_STATUS	RTMPReadParametersHook(
 								pAd->MlmeAux.SsidLen = pAd->CommonCfg.SsidLen;
 								NdisZeroMemory(pAd->MlmeAux.Ssid, NDIS_802_11_LENGTH_SSID);
 								NdisMoveMemory(pAd->MlmeAux.Ssid, tmpbuf, pAd->MlmeAux.SsidLen);
-								DBGPRINT(RT_DEBUG_TRACE, ("%s::(SSID=%s)\n", __FUNCTION__, tmpbuf));
+								DBGPRINT(RT_DEBUG_TRACE, ("%s::(SSID=%s)\n", __func__, tmpbuf));
 							}
 						}
 					}
@@ -1043,7 +1043,7 @@ NDIS_STATUS	RTMPReadParametersHook(
 								pAd->StaCfg.BssType = BSS_INFRA;
 							// Reset Ralink supplicant to not use, it will be set to start when UI set PMK key
 							pAd->StaCfg.WpaState = SS_NOTUSE;
-							DBGPRINT(RT_DEBUG_TRACE, ("%s::(NetworkType=%d)\n", __FUNCTION__, pAd->StaCfg.BssType));
+							DBGPRINT(RT_DEBUG_TRACE, ("%s::(NetworkType=%d)\n", __func__, pAd->StaCfg.BssType));
 						}
 					}
 #endif // CONFIG_STA_SUPPORT //
@@ -1341,7 +1341,7 @@ NDIS_STATUS	RTMPReadParametersHook(
 
 				                        pAd->StaCfg.PortSecured = WPA_802_1X_PORT_NOT_SECURED;
 
-							DBGPRINT(RT_DEBUG_TRACE, ("%s::(EncrypType=%d)\n", __FUNCTION__, pAd->StaCfg.WepStatus));
+							DBGPRINT(RT_DEBUG_TRACE, ("%s::(EncrypType=%d)\n", __func__, pAd->StaCfg.WepStatus));
 						}
 #endif // CONFIG_STA_SUPPORT //
 					}
@@ -1368,7 +1368,7 @@ NDIS_STATUS	RTMPReadParametersHook(
 							pAd->StaCfg.bMixCipher 		= FALSE;
 
 							//RTMPMakeRSNIE(pAd, pAd->StaCfg.AuthMode, pAd->StaCfg.WepStatus, 0);
-							DBGPRINT(RT_DEBUG_TRACE, ("%s::(EncrypType=%d)\n", __FUNCTION__, pAd->StaCfg.WepStatus));
+							DBGPRINT(RT_DEBUG_TRACE, ("%s::(EncrypType=%d)\n", __func__, pAd->StaCfg.WepStatus));
 						}
 #endif // CONFIG_STA_SUPPORT //
 					}
@@ -1405,7 +1405,7 @@ NDIS_STATUS	RTMPReadParametersHook(
 							else
 							{
 								err = 1;
-								DBGPRINT(RT_DEBUG_ERROR, ("%s::(WPAPSK key-string required 8 ~ 64 characters!)\n", __FUNCTION__));
+								DBGPRINT(RT_DEBUG_ERROR, ("%s::(WPAPSK key-string required 8 ~ 64 characters!)\n", __func__));
 							}
 
 							if (err == 0)
@@ -1436,7 +1436,7 @@ NDIS_STATUS	RTMPReadParametersHook(
 									pAd->StaCfg.WpaState = SS_NOTUSE;
 								}
 
-								DBGPRINT(RT_DEBUG_TRACE, ("%s::(WPAPSK=%s)\n", __FUNCTION__, tmpbuf));
+								DBGPRINT(RT_DEBUG_TRACE, ("%s::(WPAPSK=%s)\n", __func__, tmpbuf));
 							}
 						}
 					}
diff --git a/drivers/staging/rt2870/rtmp_def.h b/drivers/staging/rt2870/rtmp_def.h
index 9b86325..c0f7561 100644
--- a/drivers/staging/rt2870/rtmp_def.h
+++ b/drivers/staging/rt2870/rtmp_def.h
@@ -342,7 +342,7 @@
 /* sanity check for apidx */
 #define MBSS_MR_APIDX_SANITY_CHECK(apidx) \
     { if (apidx > MAX_MBSSID_NUM) { \
-          printk("%s> Error! apidx = %d > MAX_MBSSID_NUM!\n", __FUNCTION__, apidx); \
+          printk("%s> Error! apidx = %d > MAX_MBSSID_NUM!\n", __func__, apidx); \
 	  apidx = MAIN_MBSSID; } }
 
 #define VALID_WCID(_wcid)	((_wcid) > 0 && (_wcid) < MAX_LEN_OF_MAC_TABLE )
diff --git a/drivers/staging/rt2870/sta_ioctl.c b/drivers/staging/rt2870/sta_ioctl.c
index 422f39f..91f0fab 100644
--- a/drivers/staging/rt2870/sta_ioctl.c
+++ b/drivers/staging/rt2870/sta_ioctl.c
@@ -2224,7 +2224,7 @@ rt_private_show(struct net_device *dev, struct iw_request_info *info,
 			wrq->length = strlen(extra) + 1; // 1: size of '\0'
 			break;
         default:
-            DBGPRINT(RT_DEBUG_TRACE, ("%s - unknow subcmd = %d\n", __FUNCTION__, subcmd));
+            DBGPRINT(RT_DEBUG_TRACE, ("%s - unknow subcmd = %d\n", __func__, subcmd));
             break;
     }
 
@@ -2243,7 +2243,7 @@ int rt_ioctl_siwmlme(struct net_device *dev,
 	MLME_DISASSOC_REQ_STRUCT	DisAssocReq;
 	MLME_DEAUTH_REQ_STRUCT      DeAuthReq;
 
-	DBGPRINT(RT_DEBUG_TRACE, ("====> %s\n", __FUNCTION__));
+	DBGPRINT(RT_DEBUG_TRACE, ("====> %s\n", __func__));
 
 	if (pMlme == NULL)
 		return -EINVAL;
@@ -2252,7 +2252,7 @@ int rt_ioctl_siwmlme(struct net_device *dev,
 	{
 #ifdef IW_MLME_DEAUTH
 		case IW_MLME_DEAUTH:
-			DBGPRINT(RT_DEBUG_TRACE, ("====> %s - IW_MLME_DEAUTH\n", __FUNCTION__));
+			DBGPRINT(RT_DEBUG_TRACE, ("====> %s - IW_MLME_DEAUTH\n", __func__));
 			COPY_MAC_ADDR(DeAuthReq.Addr, pAd->CommonCfg.Bssid);
 			DeAuthReq.Reason = pMlme->reason_code;
 			MsgElem.MsgLen = sizeof(MLME_DEAUTH_REQ_STRUCT);
@@ -2267,7 +2267,7 @@ int rt_ioctl_siwmlme(struct net_device *dev,
 #endif // IW_MLME_DEAUTH //
 #ifdef IW_MLME_DISASSOC
 		case IW_MLME_DISASSOC:
-			DBGPRINT(RT_DEBUG_TRACE, ("====> %s - IW_MLME_DISASSOC\n", __FUNCTION__));
+			DBGPRINT(RT_DEBUG_TRACE, ("====> %s - IW_MLME_DISASSOC\n", __func__));
 			COPY_MAC_ADDR(DisAssocReq.Addr, pAd->CommonCfg.Bssid);
 			DisAssocReq.Reason =  pMlme->reason_code;
 
@@ -2281,7 +2281,7 @@ int rt_ioctl_siwmlme(struct net_device *dev,
 			break;
 #endif // IW_MLME_DISASSOC //
 		default:
-			DBGPRINT(RT_DEBUG_TRACE, ("====> %s - Unknow Command\n", __FUNCTION__));
+			DBGPRINT(RT_DEBUG_TRACE, ("====> %s - Unknow Command\n", __func__));
 			break;
 	}
 
@@ -2314,7 +2314,7 @@ int rt_ioctl_siwauth(struct net_device *dev,
             else if (param->value == IW_AUTH_WPA_VERSION_WPA2)
                 pAdapter->StaCfg.AuthMode = Ndis802_11AuthModeWPA2PSK;
 
-            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_WPA_VERSION - param->value = %d!\n", __FUNCTION__, param->value));
+            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_WPA_VERSION - param->value = %d!\n", __func__, param->value));
             break;
     	case IW_AUTH_CIPHER_PAIRWISE:
             if (param->value == IW_AUTH_CIPHER_NONE)
@@ -2345,7 +2345,7 @@ int rt_ioctl_siwauth(struct net_device *dev,
                 pAdapter->StaCfg.OrigWepStatus = pAdapter->StaCfg.WepStatus;
                 pAdapter->StaCfg.PairCipher = Ndis802_11Encryption3Enabled;
             }
-            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_CIPHER_PAIRWISE - param->value = %d!\n", __FUNCTION__, param->value));
+            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_CIPHER_PAIRWISE - param->value = %d!\n", __func__, param->value));
             break;
     	case IW_AUTH_CIPHER_GROUP:
             if (param->value == IW_AUTH_CIPHER_NONE)
@@ -2365,7 +2365,7 @@ int rt_ioctl_siwauth(struct net_device *dev,
             {
                 pAdapter->StaCfg.GroupCipher = Ndis802_11Encryption3Enabled;
             }
-            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_CIPHER_GROUP - param->value = %d!\n", __FUNCTION__, param->value));
+            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_CIPHER_GROUP - param->value = %d!\n", __func__, param->value));
             break;
     	case IW_AUTH_KEY_MGMT:
             if (param->value == IW_AUTH_KEY_MGMT_802_1X)
@@ -2395,7 +2395,7 @@ int rt_ioctl_siwauth(struct net_device *dev,
                 //pAdapter->StaCfg.PortSecured = WPA_802_1X_PORT_SECURED;
 				STA_PORT_SECURED(pAdapter);
             }
-            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_KEY_MGMT - param->value = %d!\n", __FUNCTION__, param->value));
+            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_KEY_MGMT - param->value = %d!\n", __func__, param->value));
             break;
     	case IW_AUTH_RX_UNENCRYPTED_EAPOL:
             break;
@@ -2408,7 +2408,7 @@ int rt_ioctl_siwauth(struct net_device *dev,
                 pAdapter->StaCfg.PairCipher = Ndis802_11WEPDisabled;
         	    pAdapter->StaCfg.GroupCipher = Ndis802_11WEPDisabled;
             }*/
-            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_PRIVACY_INVOKED - param->value = %d!\n", __FUNCTION__, param->value));
+            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_PRIVACY_INVOKED - param->value = %d!\n", __func__, param->value));
     		break;
     	case IW_AUTH_DROP_UNENCRYPTED:
             if (param->value != 0)
@@ -2418,7 +2418,7 @@ int rt_ioctl_siwauth(struct net_device *dev,
                 //pAdapter->StaCfg.PortSecured = WPA_802_1X_PORT_SECURED;
 				STA_PORT_SECURED(pAdapter);
 			}
-            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_WPA_VERSION - param->value = %d!\n", __FUNCTION__, param->value));
+            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_WPA_VERSION - param->value = %d!\n", __func__, param->value));
     		break;
     	case IW_AUTH_80211_AUTH_ALG:
 			if (param->value & IW_AUTH_ALG_SHARED_KEY)
@@ -2431,10 +2431,10 @@ int rt_ioctl_siwauth(struct net_device *dev,
 			}
             else
 				return -EINVAL;
-            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_80211_AUTH_ALG - param->value = %d!\n", __FUNCTION__, param->value));
+            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_80211_AUTH_ALG - param->value = %d!\n", __func__, param->value));
 			break;
     	case IW_AUTH_WPA_ENABLED:
-    		DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_WPA_ENABLED - Driver supports WPA!(param->value = %d)\n", __FUNCTION__, param->value));
+    		DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_WPA_ENABLED - Driver supports WPA!(param->value = %d)\n", __func__, param->value));
     		break;
     	default:
     		return -EOPNOTSUPP;
@@ -2542,7 +2542,7 @@ int rt_ioctl_siwencodeext(struct net_device *dev,
 		pAdapter->SharedKey[BSS0][keyIdx].CipherAlg = CIPHER_NONE;
 		AsicRemoveSharedKeyEntry(pAdapter, 0, (UCHAR)keyIdx);
         NdisZeroMemory(&pAdapter->SharedKey[BSS0][keyIdx], sizeof(CIPHER_KEY));
-        DBGPRINT(RT_DEBUG_TRACE, ("%s::Remove all keys!(encoding->flags = %x)\n", __FUNCTION__, encoding->flags));
+        DBGPRINT(RT_DEBUG_TRACE, ("%s::Remove all keys!(encoding->flags = %x)\n", __func__, encoding->flags));
     }
 					else
     {
@@ -2554,15 +2554,15 @@ int rt_ioctl_siwencodeext(struct net_device *dev,
         if (ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY)
         {
             pAdapter->StaCfg.DefaultKeyId = keyIdx;
-            DBGPRINT(RT_DEBUG_TRACE, ("%s::DefaultKeyId = %d\n", __FUNCTION__, pAdapter->StaCfg.DefaultKeyId));
+            DBGPRINT(RT_DEBUG_TRACE, ("%s::DefaultKeyId = %d\n", __func__, pAdapter->StaCfg.DefaultKeyId));
         }
 
         switch (alg) {
     		case IW_ENCODE_ALG_NONE:
-                DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_ENCODE_ALG_NONE\n", __FUNCTION__));
+                DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_ENCODE_ALG_NONE\n", __func__));
     			break;
     		case IW_ENCODE_ALG_WEP:
-                DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_ENCODE_ALG_WEP - ext->key_len = %d, keyIdx = %d\n", __FUNCTION__, ext->key_len, keyIdx));
+                DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_ENCODE_ALG_WEP - ext->key_len = %d, keyIdx = %d\n", __func__, ext->key_len, keyIdx));
     			if (ext->key_len == MAX_WEP_KEY_SIZE)
                 {
         			pAdapter->SharedKey[BSS0][keyIdx].KeyLen = MAX_WEP_KEY_SIZE;
@@ -2595,7 +2595,7 @@ int rt_ioctl_siwencodeext(struct net_device *dev,
 				}
     			break;
             case IW_ENCODE_ALG_TKIP:
-                DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_ENCODE_ALG_TKIP - keyIdx = %d, ext->key_len = %d\n", __FUNCTION__, keyIdx, ext->key_len));
+                DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_ENCODE_ALG_TKIP - keyIdx = %d, ext->key_len = %d\n", __func__, keyIdx, ext->key_len));
                 if (ext->key_len == 32)
                 {
                     if (ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY)
diff --git a/drivers/staging/rt2870/tmp60 b/drivers/staging/rt2870/tmp60
index 992096a..975e444 100644
--- a/drivers/staging/rt2870/tmp60
+++ b/drivers/staging/rt2870/tmp60
@@ -2224,7 +2224,7 @@ rt_private_show(struct net_device *dev, struct iw_request_info *info,
 			wrq->length = strlen(extra) + 1; // 1: size of '\0'
 			break;
         default:
-            DBGPRINT(RT_DEBUG_TRACE, ("%s - unknow subcmd = %d\n", __FUNCTION__, subcmd));
+            DBGPRINT(RT_DEBUG_TRACE, ("%s - unknow subcmd = %d\n", __func__, subcmd));
             break;
     }
 
@@ -2243,7 +2243,7 @@ int rt_ioctl_siwmlme(struct net_device *dev,
 	MLME_DISASSOC_REQ_STRUCT	DisAssocReq;
 	MLME_DEAUTH_REQ_STRUCT      DeAuthReq;
 
-	DBGPRINT(RT_DEBUG_TRACE, ("====> %s\n", __FUNCTION__));
+	DBGPRINT(RT_DEBUG_TRACE, ("====> %s\n", __func__));
 
 	if (pMlme == NULL)
 		return -EINVAL;
@@ -2252,7 +2252,7 @@ int rt_ioctl_siwmlme(struct net_device *dev,
 	{
 #ifdef IW_MLME_DEAUTH
 		case IW_MLME_DEAUTH:
-			DBGPRINT(RT_DEBUG_TRACE, ("====> %s - IW_MLME_DEAUTH\n", __FUNCTION__));
+			DBGPRINT(RT_DEBUG_TRACE, ("====> %s - IW_MLME_DEAUTH\n", __func__));
 			COPY_MAC_ADDR(DeAuthReq.Addr, pAd->CommonCfg.Bssid);
 			DeAuthReq.Reason = pMlme->reason_code;
 			MsgElem.MsgLen = sizeof(MLME_DEAUTH_REQ_STRUCT);
@@ -2267,7 +2267,7 @@ int rt_ioctl_siwmlme(struct net_device *dev,
 #endif // IW_MLME_DEAUTH //
 #ifdef IW_MLME_DISASSOC
 		case IW_MLME_DISASSOC:
-			DBGPRINT(RT_DEBUG_TRACE, ("====> %s - IW_MLME_DISASSOC\n", __FUNCTION__));
+			DBGPRINT(RT_DEBUG_TRACE, ("====> %s - IW_MLME_DISASSOC\n", __func__));
 			COPY_MAC_ADDR(DisAssocReq.Addr, pAd->CommonCfg.Bssid);
 			DisAssocReq.Reason =  pMlme->reason_code;
 
@@ -2281,7 +2281,7 @@ int rt_ioctl_siwmlme(struct net_device *dev,
 			break;
 #endif // IW_MLME_DISASSOC //
 		default:
-			DBGPRINT(RT_DEBUG_TRACE, ("====> %s - Unknow Command\n", __FUNCTION__));
+			DBGPRINT(RT_DEBUG_TRACE, ("====> %s - Unknow Command\n", __func__));
 			break;
 	}
 
@@ -2314,7 +2314,7 @@ int rt_ioctl_siwauth(struct net_device *dev,
             else if (param->value == IW_AUTH_WPA_VERSION_WPA2)
                 pAdapter->StaCfg.AuthMode = Ndis802_11AuthModeWPA2PSK;
 
-            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_WPA_VERSION - param->value = %d!\n", __FUNCTION__, param->value));
+            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_WPA_VERSION - param->value = %d!\n", __func__, param->value));
             break;
     	case IW_AUTH_CIPHER_PAIRWISE:
             if (param->value == IW_AUTH_CIPHER_NONE)
@@ -2345,7 +2345,7 @@ int rt_ioctl_siwauth(struct net_device *dev,
                 pAdapter->StaCfg.OrigWepStatus = pAdapter->StaCfg.WepStatus;
                 pAdapter->StaCfg.PairCipher = Ndis802_11Encryption3Enabled;
             }
-            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_CIPHER_PAIRWISE - param->value = %d!\n", __FUNCTION__, param->value));
+            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_CIPHER_PAIRWISE - param->value = %d!\n", __func__, param->value));
             break;
     	case IW_AUTH_CIPHER_GROUP:
             if (param->value == IW_AUTH_CIPHER_NONE)
@@ -2365,7 +2365,7 @@ int rt_ioctl_siwauth(struct net_device *dev,
             {
                 pAdapter->StaCfg.GroupCipher = Ndis802_11Encryption3Enabled;
             }
-            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_CIPHER_GROUP - param->value = %d!\n", __FUNCTION__, param->value));
+            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_CIPHER_GROUP - param->value = %d!\n", __func__, param->value));
             break;
     	case IW_AUTH_KEY_MGMT:
             if (param->value == IW_AUTH_KEY_MGMT_802_1X)
@@ -2395,7 +2395,7 @@ int rt_ioctl_siwauth(struct net_device *dev,
                 //pAdapter->StaCfg.PortSecured = WPA_802_1X_PORT_SECURED;
 				STA_PORT_SECURED(pAdapter);
             }
-            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_KEY_MGMT - param->value = %d!\n", __FUNCTION__, param->value));
+            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_KEY_MGMT - param->value = %d!\n", __func__, param->value));
             break;
     	case IW_AUTH_RX_UNENCRYPTED_EAPOL:
             break;
@@ -2408,7 +2408,7 @@ int rt_ioctl_siwauth(struct net_device *dev,
                 pAdapter->StaCfg.PairCipher = Ndis802_11WEPDisabled;
         	    pAdapter->StaCfg.GroupCipher = Ndis802_11WEPDisabled;
             }*/
-            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_PRIVACY_INVOKED - param->value = %d!\n", __FUNCTION__, param->value));
+            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_PRIVACY_INVOKED - param->value = %d!\n", __func__, param->value));
     		break;
     	case IW_AUTH_DROP_UNENCRYPTED:
             if (param->value != 0)
@@ -2418,7 +2418,7 @@ int rt_ioctl_siwauth(struct net_device *dev,
                 //pAdapter->StaCfg.PortSecured = WPA_802_1X_PORT_SECURED;
 				STA_PORT_SECURED(pAdapter);
 			}
-            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_WPA_VERSION - param->value = %d!\n", __FUNCTION__, param->value));
+            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_WPA_VERSION - param->value = %d!\n", __func__, param->value));
     		break;
     	case IW_AUTH_80211_AUTH_ALG:
 			if (param->value & IW_AUTH_ALG_SHARED_KEY)
@@ -2431,10 +2431,10 @@ int rt_ioctl_siwauth(struct net_device *dev,
 			}
             else
 				return -EINVAL;
-            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_80211_AUTH_ALG - param->value = %d!\n", __FUNCTION__, param->value));
+            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_80211_AUTH_ALG - param->value = %d!\n", __func__, param->value));
 			break;
     	case IW_AUTH_WPA_ENABLED:
-    		DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_WPA_ENABLED - Driver supports WPA!(param->value = %d)\n", __FUNCTION__, param->value));
+    		DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_WPA_ENABLED - Driver supports WPA!(param->value = %d)\n", __func__, param->value));
     		break;
     	default:
     		return -EOPNOTSUPP;
@@ -2542,7 +2542,7 @@ int rt_ioctl_siwencodeext(struct net_device *dev,
 		pAdapter->SharedKey[BSS0][keyIdx].CipherAlg = CIPHER_NONE;
 		AsicRemoveSharedKeyEntry(pAdapter, 0, (UCHAR)keyIdx);
         NdisZeroMemory(&pAdapter->SharedKey[BSS0][keyIdx], sizeof(CIPHER_KEY));
-        DBGPRINT(RT_DEBUG_TRACE, ("%s::Remove all keys!(encoding->flags = %x)\n", __FUNCTION__, encoding->flags));
+        DBGPRINT(RT_DEBUG_TRACE, ("%s::Remove all keys!(encoding->flags = %x)\n", __func__, encoding->flags));
     }
 					else
     {
@@ -2554,15 +2554,15 @@ int rt_ioctl_siwencodeext(struct net_device *dev,
         if (ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY)
         {
             pAdapter->StaCfg.DefaultKeyId = keyIdx;
-            DBGPRINT(RT_DEBUG_TRACE, ("%s::DefaultKeyId = %d\n", __FUNCTION__, pAdapter->StaCfg.DefaultKeyId));
+            DBGPRINT(RT_DEBUG_TRACE, ("%s::DefaultKeyId = %d\n", __func__, pAdapter->StaCfg.DefaultKeyId));
         }
 
         switch (alg) {
     		case IW_ENCODE_ALG_NONE:
-                DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_ENCODE_ALG_NONE\n", __FUNCTION__));
+                DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_ENCODE_ALG_NONE\n", __func__));
     			break;
     		case IW_ENCODE_ALG_WEP:
-                DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_ENCODE_ALG_WEP - ext->key_len = %d, keyIdx = %d\n", __FUNCTION__, ext->key_len, keyIdx));
+                DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_ENCODE_ALG_WEP - ext->key_len = %d, keyIdx = %d\n", __func__, ext->key_len, keyIdx));
     			if (ext->key_len == MAX_WEP_KEY_SIZE)
                 {
         			pAdapter->SharedKey[BSS0][keyIdx].KeyLen = MAX_WEP_KEY_SIZE;
@@ -2580,7 +2580,7 @@ int rt_ioctl_siwencodeext(struct net_device *dev,
 			    NdisMoveMemory(pAdapter->SharedKey[BSS0][keyIdx].Key, ext->key, ext->key_len);
     			break;
             case IW_ENCODE_ALG_TKIP:
-                DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_ENCODE_ALG_TKIP - keyIdx = %d, ext->key_len = %d\n", __FUNCTION__, keyIdx, ext->key_len));
+                DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_ENCODE_ALG_TKIP - keyIdx = %d, ext->key_len = %d\n", __func__, keyIdx, ext->key_len));
                 if (ext->key_len == 32)
                 {
                     if (ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY)
diff --git a/drivers/staging/rt2870/tmp61 b/drivers/staging/rt2870/tmp61
index 992096a..975e444 100644
--- a/drivers/staging/rt2870/tmp61
+++ b/drivers/staging/rt2870/tmp61
@@ -2224,7 +2224,7 @@ rt_private_show(struct net_device *dev, struct iw_request_info *info,
 			wrq->length = strlen(extra) + 1; // 1: size of '\0'
 			break;
         default:
-            DBGPRINT(RT_DEBUG_TRACE, ("%s - unknow subcmd = %d\n", __FUNCTION__, subcmd));
+            DBGPRINT(RT_DEBUG_TRACE, ("%s - unknow subcmd = %d\n", __func__, subcmd));
             break;
     }
 
@@ -2243,7 +2243,7 @@ int rt_ioctl_siwmlme(struct net_device *dev,
 	MLME_DISASSOC_REQ_STRUCT	DisAssocReq;
 	MLME_DEAUTH_REQ_STRUCT      DeAuthReq;
 
-	DBGPRINT(RT_DEBUG_TRACE, ("====> %s\n", __FUNCTION__));
+	DBGPRINT(RT_DEBUG_TRACE, ("====> %s\n", __func__));
 
 	if (pMlme == NULL)
 		return -EINVAL;
@@ -2252,7 +2252,7 @@ int rt_ioctl_siwmlme(struct net_device *dev,
 	{
 #ifdef IW_MLME_DEAUTH
 		case IW_MLME_DEAUTH:
-			DBGPRINT(RT_DEBUG_TRACE, ("====> %s - IW_MLME_DEAUTH\n", __FUNCTION__));
+			DBGPRINT(RT_DEBUG_TRACE, ("====> %s - IW_MLME_DEAUTH\n", __func__));
 			COPY_MAC_ADDR(DeAuthReq.Addr, pAd->CommonCfg.Bssid);
 			DeAuthReq.Reason = pMlme->reason_code;
 			MsgElem.MsgLen = sizeof(MLME_DEAUTH_REQ_STRUCT);
@@ -2267,7 +2267,7 @@ int rt_ioctl_siwmlme(struct net_device *dev,
 #endif // IW_MLME_DEAUTH //
 #ifdef IW_MLME_DISASSOC
 		case IW_MLME_DISASSOC:
-			DBGPRINT(RT_DEBUG_TRACE, ("====> %s - IW_MLME_DISASSOC\n", __FUNCTION__));
+			DBGPRINT(RT_DEBUG_TRACE, ("====> %s - IW_MLME_DISASSOC\n", __func__));
 			COPY_MAC_ADDR(DisAssocReq.Addr, pAd->CommonCfg.Bssid);
 			DisAssocReq.Reason =  pMlme->reason_code;
 
@@ -2281,7 +2281,7 @@ int rt_ioctl_siwmlme(struct net_device *dev,
 			break;
 #endif // IW_MLME_DISASSOC //
 		default:
-			DBGPRINT(RT_DEBUG_TRACE, ("====> %s - Unknow Command\n", __FUNCTION__));
+			DBGPRINT(RT_DEBUG_TRACE, ("====> %s - Unknow Command\n", __func__));
 			break;
 	}
 
@@ -2314,7 +2314,7 @@ int rt_ioctl_siwauth(struct net_device *dev,
             else if (param->value == IW_AUTH_WPA_VERSION_WPA2)
                 pAdapter->StaCfg.AuthMode = Ndis802_11AuthModeWPA2PSK;
 
-            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_WPA_VERSION - param->value = %d!\n", __FUNCTION__, param->value));
+            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_WPA_VERSION - param->value = %d!\n", __func__, param->value));
             break;
     	case IW_AUTH_CIPHER_PAIRWISE:
             if (param->value == IW_AUTH_CIPHER_NONE)
@@ -2345,7 +2345,7 @@ int rt_ioctl_siwauth(struct net_device *dev,
                 pAdapter->StaCfg.OrigWepStatus = pAdapter->StaCfg.WepStatus;
                 pAdapter->StaCfg.PairCipher = Ndis802_11Encryption3Enabled;
             }
-            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_CIPHER_PAIRWISE - param->value = %d!\n", __FUNCTION__, param->value));
+            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_CIPHER_PAIRWISE - param->value = %d!\n", __func__, param->value));
             break;
     	case IW_AUTH_CIPHER_GROUP:
             if (param->value == IW_AUTH_CIPHER_NONE)
@@ -2365,7 +2365,7 @@ int rt_ioctl_siwauth(struct net_device *dev,
             {
                 pAdapter->StaCfg.GroupCipher = Ndis802_11Encryption3Enabled;
             }
-            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_CIPHER_GROUP - param->value = %d!\n", __FUNCTION__, param->value));
+            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_CIPHER_GROUP - param->value = %d!\n", __func__, param->value));
             break;
     	case IW_AUTH_KEY_MGMT:
             if (param->value == IW_AUTH_KEY_MGMT_802_1X)
@@ -2395,7 +2395,7 @@ int rt_ioctl_siwauth(struct net_device *dev,
                 //pAdapter->StaCfg.PortSecured = WPA_802_1X_PORT_SECURED;
 				STA_PORT_SECURED(pAdapter);
             }
-            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_KEY_MGMT - param->value = %d!\n", __FUNCTION__, param->value));
+            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_KEY_MGMT - param->value = %d!\n", __func__, param->value));
             break;
     	case IW_AUTH_RX_UNENCRYPTED_EAPOL:
             break;
@@ -2408,7 +2408,7 @@ int rt_ioctl_siwauth(struct net_device *dev,
                 pAdapter->StaCfg.PairCipher = Ndis802_11WEPDisabled;
         	    pAdapter->StaCfg.GroupCipher = Ndis802_11WEPDisabled;
             }*/
-            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_PRIVACY_INVOKED - param->value = %d!\n", __FUNCTION__, param->value));
+            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_PRIVACY_INVOKED - param->value = %d!\n", __func__, param->value));
     		break;
     	case IW_AUTH_DROP_UNENCRYPTED:
             if (param->value != 0)
@@ -2418,7 +2418,7 @@ int rt_ioctl_siwauth(struct net_device *dev,
                 //pAdapter->StaCfg.PortSecured = WPA_802_1X_PORT_SECURED;
 				STA_PORT_SECURED(pAdapter);
 			}
-            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_WPA_VERSION - param->value = %d!\n", __FUNCTION__, param->value));
+            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_WPA_VERSION - param->value = %d!\n", __func__, param->value));
     		break;
     	case IW_AUTH_80211_AUTH_ALG:
 			if (param->value & IW_AUTH_ALG_SHARED_KEY)
@@ -2431,10 +2431,10 @@ int rt_ioctl_siwauth(struct net_device *dev,
 			}
             else
 				return -EINVAL;
-            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_80211_AUTH_ALG - param->value = %d!\n", __FUNCTION__, param->value));
+            DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_80211_AUTH_ALG - param->value = %d!\n", __func__, param->value));
 			break;
     	case IW_AUTH_WPA_ENABLED:
-    		DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_WPA_ENABLED - Driver supports WPA!(param->value = %d)\n", __FUNCTION__, param->value));
+    		DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_AUTH_WPA_ENABLED - Driver supports WPA!(param->value = %d)\n", __func__, param->value));
     		break;
     	default:
     		return -EOPNOTSUPP;
@@ -2542,7 +2542,7 @@ int rt_ioctl_siwencodeext(struct net_device *dev,
 		pAdapter->SharedKey[BSS0][keyIdx].CipherAlg = CIPHER_NONE;
 		AsicRemoveSharedKeyEntry(pAdapter, 0, (UCHAR)keyIdx);
         NdisZeroMemory(&pAdapter->SharedKey[BSS0][keyIdx], sizeof(CIPHER_KEY));
-        DBGPRINT(RT_DEBUG_TRACE, ("%s::Remove all keys!(encoding->flags = %x)\n", __FUNCTION__, encoding->flags));
+        DBGPRINT(RT_DEBUG_TRACE, ("%s::Remove all keys!(encoding->flags = %x)\n", __func__, encoding->flags));
     }
 					else
     {
@@ -2554,15 +2554,15 @@ int rt_ioctl_siwencodeext(struct net_device *dev,
         if (ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY)
         {
             pAdapter->StaCfg.DefaultKeyId = keyIdx;
-            DBGPRINT(RT_DEBUG_TRACE, ("%s::DefaultKeyId = %d\n", __FUNCTION__, pAdapter->StaCfg.DefaultKeyId));
+            DBGPRINT(RT_DEBUG_TRACE, ("%s::DefaultKeyId = %d\n", __func__, pAdapter->StaCfg.DefaultKeyId));
         }
 
         switch (alg) {
     		case IW_ENCODE_ALG_NONE:
-                DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_ENCODE_ALG_NONE\n", __FUNCTION__));
+                DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_ENCODE_ALG_NONE\n", __func__));
     			break;
     		case IW_ENCODE_ALG_WEP:
-                DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_ENCODE_ALG_WEP - ext->key_len = %d, keyIdx = %d\n", __FUNCTION__, ext->key_len, keyIdx));
+                DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_ENCODE_ALG_WEP - ext->key_len = %d, keyIdx = %d\n", __func__, ext->key_len, keyIdx));
     			if (ext->key_len == MAX_WEP_KEY_SIZE)
                 {
         			pAdapter->SharedKey[BSS0][keyIdx].KeyLen = MAX_WEP_KEY_SIZE;
@@ -2580,7 +2580,7 @@ int rt_ioctl_siwencodeext(struct net_device *dev,
 			    NdisMoveMemory(pAdapter->SharedKey[BSS0][keyIdx].Key, ext->key, ext->key_len);
     			break;
             case IW_ENCODE_ALG_TKIP:
-                DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_ENCODE_ALG_TKIP - keyIdx = %d, ext->key_len = %d\n", __FUNCTION__, keyIdx, ext->key_len));
+                DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_ENCODE_ALG_TKIP - keyIdx = %d, ext->key_len = %d\n", __func__, keyIdx, ext->key_len));
                 if (ext->key_len == 32)
                 {
                     if (ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY)
diff --git a/drivers/staging/rtl8187se/ieee80211.h b/drivers/staging/rtl8187se/ieee80211.h
index bf06abe..5833608 100644
--- a/drivers/staging/rtl8187se/ieee80211.h
+++ b/drivers/staging/rtl8187se/ieee80211.h
@@ -396,7 +396,7 @@ extern u32 ieee80211_debug_level;
 #define IEEE80211_DEBUG(level, fmt, args...) \
 do { if (ieee80211_debug_level & (level)) \
   printk(KERN_DEBUG "ieee80211: %c %s " fmt, \
-         in_interrupt() ? 'I' : 'U', __FUNCTION__ , ## args); } while (0)
+         in_interrupt() ? 'I' : 'U', __func__ , ## args); } while (0)
 #else
 #define IEEE80211_DEBUG(level, fmt, args...) do {} while (0)
 #endif	/* CONFIG_IEEE80211_DEBUG */
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211.h b/drivers/staging/rtl8187se/ieee80211/ieee80211.h
index bf06abe..5833608 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211.h
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211.h
@@ -396,7 +396,7 @@ extern u32 ieee80211_debug_level;
 #define IEEE80211_DEBUG(level, fmt, args...) \
 do { if (ieee80211_debug_level & (level)) \
   printk(KERN_DEBUG "ieee80211: %c %s " fmt, \
-         in_interrupt() ? 'I' : 'U', __FUNCTION__ , ## args); } while (0)
+         in_interrupt() ? 'I' : 'U', __func__ , ## args); } while (0)
 #else
 #define IEEE80211_DEBUG(level, fmt, args...) do {} while (0)
 #endif	/* CONFIG_IEEE80211_DEBUG */
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c
index 7d890c3..08add38 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c
@@ -490,7 +490,7 @@ static char * ieee80211_ccmp_print_stats(char *p, void *priv)
 
 void ieee80211_ccmp_null(void)
 {
-//    printk("============>%s()\n", __FUNCTION__);
+//    printk("============>%s()\n", __func__);
 	return;
 }
 static struct ieee80211_crypto_ops ieee80211_crypt_ccmp = {
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_tkip.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_tkip.c
index e560b1e..de97bbe 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_tkip.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_tkip.c
@@ -984,7 +984,7 @@ void ieee80211_crypto_tkip_exit(void)
 
 void ieee80211_tkip_null(void)
 {
-//    printk("============>%s()\n", __FUNCTION__);
+//    printk("============>%s()\n", __func__);
         return;
 }
 
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_wep.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_wep.c
index f973dae..68a22b3 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_wep.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_wep.c
@@ -380,7 +380,7 @@ void ieee80211_crypto_wep_exit(void)
 
 void ieee80211_wep_null(void)
 {
-//	printk("============>%s()\n", __FUNCTION__);
+//	printk("============>%s()\n", __func__);
         return;
 }
 #if 0
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
index 79ec649..23519b3 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
@@ -1635,7 +1635,7 @@ inline void update_network(struct ieee80211_network *dst,
 	memcpy(dst->rates_ex, src->rates_ex, src->rates_ex_len);
 	dst->rates_ex_len = src->rates_ex_len;
 	dst->HighestOperaRate= src->HighestOperaRate;
-	//printk("==========>in %s: src->ssid is %s,chan is %d\n",__FUNCTION__,src->ssid,src->channel);
+	//printk("==========>in %s: src->ssid is %s,chan is %d\n",__func__,src->ssid,src->channel);
 
 	//YJ,add,080819,for hidden ap
 	if(src->ssid_len > 0)
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
index fcffee5..e5752f6 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
@@ -731,7 +731,7 @@ void ieee80211_softmac_scan_wq(struct ieee80211_device *ieee)
 	memcpy(channel_map, GET_DOT11D_INFO(ieee)->channel_map, MAX_CHANNEL_NUMBER+1);
 #endif
 //	printk("ieee80211_softmac_scan_wq ENABLE_IPS\n");
-//	printk("in %s\n",__FUNCTION__);
+//	printk("in %s\n",__func__);
 	down(&ieee->scan_sem);
 
 	do{
@@ -1785,7 +1785,7 @@ void ieee80211_associate_step1(struct ieee80211_device *ieee)
 		//If call dev_kfree_skb_any,a warning will ocur....
 		//KERNEL: assertion (!atomic_read(&skb->users)) failed at net/core/dev.c (1708)
 		//So ... 1204 by lawrence.
-		//printk("\nIn %s,line %d call kfree skb.",__FUNCTION__,__LINE__);
+		//printk("\nIn %s,line %d call kfree skb.",__func__,__LINE__);
 		//dev_kfree_skb_any(skb);//edit by thomas
 	}
 }
@@ -2432,7 +2432,7 @@ inline void ieee80211_sta_ps(struct ieee80211_device *ieee)
 	}
 
 	sleep = ieee80211_sta_ps_sleep(ieee,&th, &tl);
-//	printk("===>%s,%d[2 wake, 1 sleep, 0 do nothing], ieee->sta_sleep = %d\n",__FUNCTION__, sleep,ieee->sta_sleep);
+//	printk("===>%s,%d[2 wake, 1 sleep, 0 do nothing], ieee->sta_sleep = %d\n",__func__, sleep,ieee->sta_sleep);
 	/* 2 wake, 1 sleep, 0 do nothing */
 	if(sleep == 0)
 		goto out;
@@ -2510,7 +2510,7 @@ void ieee80211_ps_tx_ack(struct ieee80211_device *ieee, short success)
 		/* Null frame with PS bit set */
 		if(success){
 
-		//	printk("==================> %s::enter sleep state\n",__FUNCTION__);
+		//	printk("==================> %s::enter sleep state\n",__func__);
 			ieee->sta_sleep = 1;
 			ieee->enter_sleep_state(ieee->dev,ieee->ps_th,ieee->ps_tl);
 		}
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
index 43b8aec..93af37e 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
@@ -31,7 +31,7 @@ int ieee80211_wx_set_freq(struct ieee80211_device *ieee, struct iw_request_info
 {
 	int ret;
 	struct iw_freq *fwrq = & wrqu->freq;
-//	printk("in %s\n",__FUNCTION__);
+//	printk("in %s\n",__func__);
 	down(&ieee->wx_sem);
 
 	if(ieee->iw_mode == IW_MODE_INFRA){
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c
index c7d9f4f..6aad61e 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c
@@ -663,7 +663,7 @@ int ieee80211_wx_set_encode_ext(struct ieee80211_device *ieee,
                 ret = -EINVAL;
                 goto done;
         }
-//	printk("8-09-08-9=====>%s, alg name:%s\n",__FUNCTION__, alg);
+//	printk("8-09-08-9=====>%s, alg name:%s\n",__func__, alg);
 
 	 ops = ieee80211_get_crypto_ops(alg);
         if (ops == NULL) {
@@ -757,7 +757,7 @@ int ieee80211_wx_set_mlme(struct ieee80211_device *ieee,
                                union iwreq_data *wrqu, char *extra)
 {
 	struct iw_mlme *mlme = (struct iw_mlme *) extra;
-//	printk("\ndkgadfslkdjgalskdf===============>%s(), cmd:%x\n", __FUNCTION__, mlme->cmd);
+//	printk("\ndkgadfslkdjgalskdf===============>%s(), cmd:%x\n", __func__, mlme->cmd);
 #if 1
 	switch (mlme->cmd) {
         case IW_MLME_DEAUTH:
@@ -830,7 +830,7 @@ int ieee80211_wx_set_auth(struct ieee80211_device *ieee,
 int ieee80211_wx_set_gen_ie(struct ieee80211_device *ieee, u8 *ie, size_t len)
 {
 #if 0
-	printk("====>%s()\n", __FUNCTION__);
+	printk("====>%s()\n", __func__);
 	{
 		int i;
 		for (i=0; i<len; i++)
@@ -866,7 +866,7 @@ int ieee80211_wx_set_gen_ie(struct ieee80211_device *ieee, u8 *ie, size_t len)
 		ieee->wpa_ie = NULL;
 		ieee->wpa_ie_len = 0;
 	}
-//	printk("<=====out %s()\n", __FUNCTION__);
+//	printk("<=====out %s()\n", __func__);
 
 	return 0;
 
diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index 00f4df4..9453495 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -1407,12 +1407,12 @@ void rtl8180_set_chan(struct net_device *dev,short ch)
 
 	if((ch > 14) || (ch < 1))
 	{
-		printk("In %s: Invalid chnanel %d\n", __FUNCTION__, ch);
+		printk("In %s: Invalid chnanel %d\n", __func__, ch);
 		return;
 	}
 
 	priv->chan=ch;
-	//printk("in %s:channel is %d\n",__FUNCTION__,ch);
+	//printk("in %s:channel is %d\n",__func__,ch);
 	priv->rf_set_chan(dev,priv->chan);
 
 }
@@ -3656,7 +3656,7 @@ void rtl8180_link_change(struct net_device *dev)
 void rtl8180_rq_tx_ack(struct net_device *dev){
 
 	struct r8180_priv *priv = ieee80211_priv(dev);
-//	printk("====================>%s\n",__FUNCTION__);
+//	printk("====================>%s\n",__func__);
 	write_nic_byte(dev,CONFIG4,read_nic_byte(dev,CONFIG4)|CONFIG4_PWRMGT);
 	priv->ack_tx_to_ieee = 1;
 }
@@ -5448,7 +5448,7 @@ void rtl8180_hw_wakeup_wq(struct net_device *dev)
 #endif
 
 //	printk("dev is %d\n",dev);
-//	printk("&*&(^*(&(&=========>%s()\n", __FUNCTION__);
+//	printk("&*&(^*(&(&=========>%s()\n", __func__);
 	rtl8180_hw_wakeup(dev);
 
 }
@@ -6318,12 +6318,12 @@ priv->txnpring)/8);
 //				printk("NumTxOkTotal is %d\n",priv->NumTxOkTotal++);
 			}
 #endif
-			//	printk("in function %s:curr_retry_count is %d\n",__FUNCTION__,((*head) & (0x000000ff)));
+			//	printk("in function %s:curr_retry_count is %d\n",__func__,((*head) & (0x000000ff)));
 		}
 		if(!error){
 			priv->NumTxOkBytesTotal += (*(head+3)) & (0x00000fff);
 		}
-//		printk("in function %s:curr_txokbyte_count is %d\n",__FUNCTION__,(*(head+3)) & (0x00000fff));
+//		printk("in function %s:curr_txokbyte_count is %d\n",__func__,(*(head+3)) & (0x00000fff));
 		*head = *head &~ (1<<31);
 
 		if((head - begin)/8 == priv->txringcount-1)
diff --git a/drivers/staging/rtl8187se/r8180_rtl8225z2.c b/drivers/staging/rtl8187se/r8180_rtl8225z2.c
index 90a574d..4136b94 100644
--- a/drivers/staging/rtl8187se/r8180_rtl8225z2.c
+++ b/drivers/staging/rtl8187se/r8180_rtl8225z2.c
@@ -1571,7 +1571,7 @@ void rtl8225z4_rf_sleep(struct net_device *dev)
 	//
 	// Turn off RF power.
 	//
-	//printk("=========>%s()\n", __FUNCTION__);
+	//printk("=========>%s()\n", __func__);
 	MgntActSet_RF_State(dev, eRfSleep, RF_CHANGE_BY_PS);
 	//mdelay(2);	//FIXME
 }
@@ -1580,7 +1580,7 @@ void rtl8225z4_rf_wakeup(struct net_device *dev)
 	//
 	// Turn on RF power.
 	//
-	//printk("=========>%s()\n", __FUNCTION__);
+	//printk("=========>%s()\n", __func__);
 	MgntActSet_RF_State(dev, eRfOn, RF_CHANGE_BY_PS);
 }
 #endif
diff --git a/drivers/staging/rtl8187se/r8180_wx.c b/drivers/staging/rtl8187se/r8180_wx.c
index c77abe5..8b3901d 100644
--- a/drivers/staging/rtl8187se/r8180_wx.c
+++ b/drivers/staging/rtl8187se/r8180_wx.c
@@ -1177,7 +1177,7 @@ static int r8180_wx_set_channelplan(struct net_device *dev,
 	//struct ieee80211_device *ieee = netdev_priv(dev);
 	int *val = (int *)extra;
 	int i;
-	printk("-----in fun %s\n", __FUNCTION__);
+	printk("-----in fun %s\n", __func__);
 
 	if(priv->ieee80211->bHwRadioOff)
 		return 0;
@@ -1235,7 +1235,7 @@ static int r8180_wx_set_forcerate(struct net_device *dev,
 
 	down(&priv->wx_sem);
 
-	printk("==============>%s(): forcerate is %d\n",__FUNCTION__,forcerate);
+	printk("==============>%s(): forcerate is %d\n",__func__,forcerate);
 	if((forcerate == 2) || (forcerate == 4) || (forcerate == 11) || (forcerate == 22) || (forcerate == 12) ||
 		(forcerate == 18) || (forcerate == 24) || (forcerate == 36) || (forcerate == 48) || (forcerate == 72) ||
 		(forcerate == 96) || (forcerate == 108))
@@ -1260,7 +1260,7 @@ static int r8180_wx_set_enc_ext(struct net_device *dev,
 {
 
 	struct r8180_priv *priv = ieee80211_priv(dev);
-	//printk("===>%s()\n", __FUNCTION__);
+	//printk("===>%s()\n", __func__);
 
 	int ret=0;
 
@@ -1277,7 +1277,7 @@ static int r8180_wx_set_auth(struct net_device *dev,
                                         struct iw_request_info *info,
                                         struct iw_param *data, char *extra)
 {
-	//printk("====>%s()\n", __FUNCTION__);
+	//printk("====>%s()\n", __func__);
 	struct r8180_priv *priv = ieee80211_priv(dev);
 	int ret=0;
 
@@ -1294,7 +1294,7 @@ static int r8180_wx_set_mlme(struct net_device *dev,
                                         struct iw_request_info *info,
                                         union iwreq_data *wrqu, char *extra)
 {
-	//printk("====>%s()\n", __FUNCTION__);
+	//printk("====>%s()\n", __func__);
 
 	int ret=0;
 	struct r8180_priv *priv = ieee80211_priv(dev);
@@ -1315,7 +1315,7 @@ static int r8180_wx_set_gen_ie(struct net_device *dev,
                                         struct iw_request_info *info,
                                         struct iw_point *data, char *extra)
 {
-//	printk("====>%s(), len:%d\n", __FUNCTION__, data->length);
+//	printk("====>%s(), len:%d\n", __func__, data->length);
 	int ret=0;
         struct r8180_priv *priv = ieee80211_priv(dev);
 
@@ -1328,7 +1328,7 @@ static int r8180_wx_set_gen_ie(struct net_device *dev,
         ret = ieee80211_wx_set_gen_ie(priv->ieee80211, extra, data->length);
 #endif
         up(&priv->wx_sem);
-	//printk("<======%s(), ret:%d\n", __FUNCTION__, ret);
+	//printk("<======%s(), ret:%d\n", __func__, ret);
         return ret;
 
 
-- 
1.6.1.94.g9388



