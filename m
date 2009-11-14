Return-Path: <linux-kernel-owner+w=401wt.eu-S1753194AbZKOPLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbZKOPLd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 10:11:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbZKOPL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 10:11:29 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:64137 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134AbZKOPLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 10:11:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=QajVQxMxoksYiUcZBAgqEyAjpzoJuCeE7VbCphm/twFRyKBpD3c4PuO/bXXs9ZdtTq
         1+XrFT/kku9Co5LdrCLfQjNxR5lmcSNfyQb1xdQugGKeX9SxtATTr1jdePVFWQwpE6VE
         1+n6x6KjMtgPgMbrwKFhyTfUBLXYWtaLVUFts=
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
To: jkosina@suse.cz, "linux list" <linux-kernel@vger.kernel.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Subject: [PATCH v3 2/2] trivial: staging: fix assorted typos all over the place
Date: Sat, 14 Nov 2009 13:09:06 -0200
Message-Id: <9dc2d726158553d4a722d449eb3027622783d563.1258210894.git.andre.goddard@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e.dirty
In-Reply-To: <cover.1258210891.git.andre.goddard@gmail.com>
References: <cover.1258210891.git.andre.goddard@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
---
 drivers/staging/altpciechdma/altpciechdma.c        |    6 ++--
 .../comedi/drivers/addi-data/APCI1710_INCCPT.c     |    6 ++--
 .../comedi/drivers/addi-data/APCI1710_Tor.c        |    2 +-
 .../staging/comedi/drivers/addi-data/addi_common.h |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3120.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3501.c      |    2 +-
 drivers/staging/comedi/drivers/cb_pcidio.c         |    4 +-
 drivers/staging/comedi/drivers/me4000.c            |    2 +-
 drivers/staging/comedi/drivers/pcl812.c            |    6 ++--
 drivers/staging/comedi/drivers/pcl816.c            |    4 +-
 drivers/staging/comedi/drivers/pcl818.c            |   10 +++---
 drivers/staging/dst/export.c                       |    2 +-
 drivers/staging/et131x/et131x_adapter.h            |    2 +-
 drivers/staging/hv/hv_api.h                        |    4 +-
 drivers/staging/iio/accel/accel.h                  |    6 ++--
 drivers/staging/iio/accel/sca3000.h                |    4 +-
 drivers/staging/iio/accel/sca3000_core.c           |    2 +-
 drivers/staging/octeon/cvmx-pow.h                  |    2 +-
 drivers/staging/octeon/ethernet-tx.c               |    2 +-
 drivers/staging/otus/80211core/ccmd.c              |    4 +-
 drivers/staging/otus/80211core/cmm.c               |    4 +-
 drivers/staging/otus/80211core/cmmsta.c            |    4 +-
 drivers/staging/otus/80211core/ctxrx.c             |    2 +-
 drivers/staging/otus/80211core/pub_zfi.h           |    2 +-
 drivers/staging/quatech_usb2/quatech_usb2.c        |    2 +-
 drivers/staging/rar/rar_driver.c                   |    4 +-
 drivers/staging/rt2860/common/cmm_data.c           |    4 +-
 drivers/staging/rt2860/common/cmm_info.c           |   32 ++++++++++----------
 drivers/staging/rt2860/common/eeprom.c             |    4 +-
 drivers/staging/rt2860/common/mlme.c               |   12 ++++----
 drivers/staging/rt2860/common/rtmp_init.c          |    4 +-
 drivers/staging/rt2860/common/spectrum.c           |    6 ++--
 drivers/staging/rt2860/mlme.h                      |    2 +-
 drivers/staging/rt2860/rt28xx.h                    |    2 +-
 drivers/staging/rt2860/sta/connect.c               |    6 ++--
 drivers/staging/rt2860/sta/rtmp_data.c             |    2 +-
 drivers/staging/rt2860/sta/wpa.c                   |    4 +-
 drivers/staging/rt2860/sta_ioctl.c                 |    6 ++--
 drivers/staging/rt2870/common/rtusb_bulk.c         |    4 +-
 drivers/staging/rt3090/chips/rt30xx.c              |    2 +-
 drivers/staging/rt3090/chips/rt33xx.c              |    2 +-
 drivers/staging/rt3090/common/cmm_data.c           |    4 +-
 drivers/staging/rt3090/common/cmm_info.c           |   30 +++++++++---------
 drivers/staging/rt3090/common/ee_prom.c            |    4 +-
 drivers/staging/rt3090/common/igmp_snoop.c         |    4 +-
 drivers/staging/rt3090/common/mlme.c               |   10 +++---
 drivers/staging/rt3090/common/rtmp_init.c          |    4 +-
 drivers/staging/rt3090/common/spectrum.c           |   14 ++++----
 drivers/staging/rt3090/mlme.h                      |    2 +-
 drivers/staging/rt3090/rt_ate.c                    |    2 +-
 drivers/staging/rt3090/rtmp_mac.h                  |    4 +-
 drivers/staging/rt3090/sta/connect.c               |    6 ++--
 drivers/staging/rt3090/sta/rtmp_data.c             |    2 +-
 drivers/staging/rt3090/sta_ioctl.c                 |   11 ++++---
 .../rtl8187se/ieee80211/ieee80211_softmac.c        |    6 ++--
 drivers/staging/rtl8187se/r8180.h                  |    2 +-
 drivers/staging/rtl8187se/r8180_core.c             |   10 +++---
 drivers/staging/rtl8187se/r8180_dm.c               |   12 ++++----
 drivers/staging/rtl8187se/r8180_rtl8225z2.c        |    2 +-
 drivers/staging/rtl8187se/r8180_wx.c               |    2 +-
 drivers/staging/rtl8187se/r8185b_init.c            |    4 +-
 .../staging/rtl8192e/ieee80211/ieee80211_module.c  |    2 +-
 .../staging/rtl8192e/ieee80211/ieee80211_softmac.c |    4 +-
 drivers/staging/rtl8192e/r8190_rtl8256.c           |    2 +-
 drivers/staging/rtl8192e/r8192E_core.c             |    6 ++--
 drivers/staging/rtl8192e/r8192E_dm.c               |   20 ++++++------
 drivers/staging/rtl8192e/r8192E_wx.c               |    2 +-
 drivers/staging/rtl8192e/r819xE_cmdpkt.c           |    2 +-
 drivers/staging/rtl8192e/r819xE_phyreg.h           |    2 +-
 .../staging/rtl8192su/ieee80211/ieee80211_module.c |    2 +-
 .../rtl8192su/ieee80211/ieee80211_softmac.c        |    4 +-
 drivers/staging/rtl8192su/ieee80211/readme         |    2 +-
 drivers/staging/rtl8192su/r8192S_phy.c             |    4 +-
 drivers/staging/rtl8192su/r8192S_phyreg.h          |    2 +-
 drivers/staging/rtl8192su/r8192S_rtl6052.c         |    4 +-
 drivers/staging/rtl8192su/r8192U_dm.c              |   10 +++---
 drivers/staging/rtl8192su/r8192U_wx.c              |    2 +-
 drivers/staging/rtl8192su/r819xU_cmdpkt.c          |    2 +-
 drivers/staging/sep/sep_driver.c                   |    2 +-
 drivers/staging/serqt_usb2/serqt_usb2.c            |    2 +-
 drivers/staging/vt6655/device_main.c               |    2 +-
 drivers/staging/vt6655/ioctl.c                     |    4 +-
 drivers/staging/vt6655/mib.h                       |    4 +-
 drivers/staging/vt6656/baseband.c                  |    2 +-
 drivers/staging/vt6656/channel.c                   |    2 +-
 drivers/staging/vt6656/ioctl.c                     |    4 +-
 drivers/staging/vt6656/iwctl.c                     |    2 +-
 drivers/staging/vt6656/main_usb.c                  |    2 +-
 drivers/staging/vt6656/mib.h                       |    4 +-
 drivers/staging/vt6656/wcmd.c                      |    2 +-
 90 files changed, 212 insertions(+), 211 deletions(-)

diff --git a/drivers/staging/altpciechdma/altpciechdma.c b/drivers/staging/altpciechdma/altpciechdma.c
index e0c5ba4..2f07dd4 100644
--- a/drivers/staging/altpciechdma/altpciechdma.c
+++ b/drivers/staging/altpciechdma/altpciechdma.c
@@ -212,7 +212,7 @@ struct ape_dev {
 	int msi_enabled;
 	/* whether this driver could obtain the regions */
 	int got_regions;
-	/* irq line succesfully requested by this driver, -1 otherwise */
+	/* irq line successfully requested by this driver, -1 otherwise */
 	int irq_line;
 	/* board revision */
 	u8 revision;
@@ -336,7 +336,7 @@ static int __devinit map_bars(struct ape_dev *ape, struct pci_dev *dev)
 		printk(KERN_DEBUG "BAR[%d] mapped at 0x%p with length %lu(/%lu).\n", i,
 		ape->bar[i], bar_min_len[i], bar_length);
 	}
-	/* succesfully mapped all required BAR regions */
+	/* successfully mapped all required BAR regions */
 	rc = 0;
 	goto success;
 fail:
@@ -911,7 +911,7 @@ static int __devinit probe(struct pci_dev *dev, const struct pci_device_id *id)
 	/* perform DMA engines loop back test */
 	rc = dma_test(ape, dev);
 	(void)rc;
-	/* succesfully took the device */
+	/* successfully took the device */
 	rc = 0;
 	printk(KERN_DEBUG "probe() successful.\n");
 	goto end;
diff --git a/drivers/staging/comedi/drivers/addi-data/APCI1710_INCCPT.c b/drivers/staging/comedi/drivers/addi-data/APCI1710_INCCPT.c
index 6c092ef..a15c952 100644
--- a/drivers/staging/comedi/drivers/addi-data/APCI1710_INCCPT.c
+++ b/drivers/staging/comedi/drivers/addi-data/APCI1710_INCCPT.c
@@ -3807,7 +3807,7 @@ int i_APCI1710_EnableFrequencyMeasurement(struct comedi_device *dev,
 			s_ModuleInfo[b_ModulNbr].
 			s_SiemensCounterInfo.s_InitFlag.b_CounterInit == 1) {
 	      /********************************************/
-			/* Test if frequency mesurement initialised */
+			/* Test if frequency measurement initialised */
 	      /********************************************/
 
 			if (devpriv->
@@ -3953,7 +3953,7 @@ int i_APCI1710_DisableFrequencyMeasurement(struct comedi_device *dev, unsigned c
 			s_ModuleInfo[b_ModulNbr].
 			s_SiemensCounterInfo.s_InitFlag.b_CounterInit == 1) {
 	      /********************************************/
-			/* Test if frequency mesurement initialised */
+			/* Test if frequency measurement initialised */
 	      /********************************************/
 
 			if (devpriv->
@@ -5166,7 +5166,7 @@ int i_APCI1710_ReadFrequencyMeasurement(struct comedi_device *dev,
 			s_ModuleInfo[b_ModulNbr].
 			s_SiemensCounterInfo.s_InitFlag.b_CounterInit == 1) {
 	      /********************************************/
-			/* Test if frequency mesurement initialised */
+			/* Test if frequency measurement initialised */
 	      /********************************************/
 
 			if (devpriv->
diff --git a/drivers/staging/comedi/drivers/addi-data/APCI1710_Tor.c b/drivers/staging/comedi/drivers/addi-data/APCI1710_Tor.c
index 43198aa..7e12544 100644
--- a/drivers/staging/comedi/drivers/addi-data/APCI1710_Tor.c
+++ b/drivers/staging/comedi/drivers/addi-data/APCI1710_Tor.c
@@ -1808,7 +1808,7 @@ int i_APCI1710_InsnBitsGetTorCounterProgressStatusAndValue(struct comedi_device
 									2) {
 									if (dw_Status & 4) {
 				/************************/
-										/* Tor counter owerflow */
+										/* Tor counter overflow */
 				/************************/
 
 										*pb_TorCounterStatus
diff --git a/drivers/staging/comedi/drivers/addi-data/addi_common.h b/drivers/staging/comedi/drivers/addi-data/addi_common.h
index edd657b..3ab27cf 100644
--- a/drivers/staging/comedi/drivers/addi-data/addi_common.h
+++ b/drivers/staging/comedi/drivers/addi-data/addi_common.h
@@ -82,7 +82,7 @@ struct addi_board {
 
 	int i_NbrDiChannel;	/*  Number of DI channels */
 	int i_NbrDoChannel;	/*  Number of DO channels */
-	int i_DoMaxdata;	/*  data to set all chanels high */
+	int i_DoMaxdata;	/*  data to set all channels high */
 
 	int i_NbrTTLChannel;	/*  Number of TTL channels */
 	const struct comedi_lrange *pr_TTLRangelist;	/* rangelist for TTL */
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
index 169cee4..be361f0 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
@@ -1468,7 +1468,7 @@ void v_APCI3120_Interrupt(int irq, void *d)
 	int_amcc = inl(devpriv->i_IobaseAmcc + AMCC_OP_REG_INTCSR);	/*  get AMCC int register */
 
 	if ((!int_daq) && (!(int_amcc & ANY_S593X_INT))) {
-		comedi_error(dev, "IRQ from unknow source");
+		comedi_error(dev, "IRQ from unknown source");
 		return;
 	}
 
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
index ef21f03..7b38d17 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
@@ -724,7 +724,7 @@ void v_APCI3501_Interrupt(int irq, void *d)
 		APCI3501_TCW_IRQ) & 0x1;
 
 	if ((!ui_Timer_AOWatchdog)) {
-		comedi_error(dev, "IRQ from unknow source");
+		comedi_error(dev, "IRQ from unknown source");
 		return;
 	}
 
diff --git a/drivers/staging/comedi/drivers/cb_pcidio.c b/drivers/staging/comedi/drivers/cb_pcidio.c
index 09e6e3b..7daad0a 100644
--- a/drivers/staging/comedi/drivers/cb_pcidio.c
+++ b/drivers/staging/comedi/drivers/cb_pcidio.c
@@ -109,12 +109,12 @@ MODULE_DEVICE_TABLE(pci, pcidio_pci_table);
    several hardware drivers keep similar information in this structure,
    feel free to suggest moving the variable to the struct comedi_device struct.  */
 struct pcidio_private {
-	int data;		/*  curently unused */
+	int data;		/*  currently unused */
 
 	/* would be useful for a PCI device */
 	struct pci_dev *pci_dev;
 
-	/* used for DO readback, curently unused */
+	/* used for DO readback, currently unused */
 	unsigned int do_readback[4];	/* up to 4 unsigned int suffice to hold 96 bits for PCI-DIO96 */
 
 	unsigned long dio_reg_base;	/*  address of port A of the first 8255 chip on board */
diff --git a/drivers/staging/comedi/drivers/me4000.c b/drivers/staging/comedi/drivers/me4000.c
index 6079913..8b9fa0f 100644
--- a/drivers/staging/comedi/drivers/me4000.c
+++ b/drivers/staging/comedi/drivers/me4000.c
@@ -840,7 +840,7 @@ static int xilinx_download(struct comedi_device *dev)
 		       "comedi%d: me4000: xilinx_download(): DONE flag is not set\n",
 		       dev->minor);
 		printk(KERN_ERR
-		       "comedi%d: me4000: xilinx_download(): Download not succesful\n",
+		       "comedi%d: me4000: xilinx_download(): Download not successful\n",
 		       dev->minor);
 		return -EIO;
 	}
diff --git a/drivers/staging/comedi/drivers/pcl812.c b/drivers/staging/comedi/drivers/pcl812.c
index 0b51a48..0a5bc3d 100644
--- a/drivers/staging/comedi/drivers/pcl812.c
+++ b/drivers/staging/comedi/drivers/pcl812.c
@@ -51,7 +51,7 @@ Options for PCL-812:
         5=A/D input range is +/-0.3125V
   [5] - 0=D/A outputs 0-5V  (internal reference -5V)
         1=D/A outputs 0-10V (internal reference -10V)
-        2=D/A outputs unknow (external reference)
+        2=D/A outputs unknown (external reference)
 
 Options for PCL-812PG, ACL-8112PG:
   [0] - IO Base
@@ -63,7 +63,7 @@ Options for PCL-812PG, ACL-8112PG:
         1=A/D have max +/-10V input
   [5] - 0=D/A outputs 0-5V  (internal reference -5V)
         1=D/A outputs 0-10V (internal reference -10V)
-        2=D/A outputs unknow (external reference)
+        2=D/A outputs unknown (external reference)
 
 Options for ACL-8112DG/HG, A-822PGL/PGH, A-823PGL/PGH, ACL-8216, A-826PG:
   [0] - IO Base
@@ -75,7 +75,7 @@ Options for ACL-8112DG/HG, A-822PGL/PGH, A-823PGL/PGH, ACL-8216, A-826PG:
         1=A/D channels are DIFF
   [5] - 0=D/A outputs 0-5V  (internal reference -5V)
         1=D/A outputs 0-10V (internal reference -10V)
-        2=D/A outputs unknow (external reference)
+        2=D/A outputs unknown (external reference)
 
 Options for A-821PGL/PGH:
   [0] - IO Base
diff --git a/drivers/staging/comedi/drivers/pcl816.c b/drivers/staging/comedi/drivers/pcl816.c
index fa24145..d7c0fde 100644
--- a/drivers/staging/comedi/drivers/pcl816.c
+++ b/drivers/staging/comedi/drivers/pcl816.c
@@ -112,7 +112,7 @@ struct pcl816_board {
 	int n_dichan;		/*  num of DI chans */
 	int n_dochan;		/*  num of DO chans */
 	const struct comedi_lrange *ai_range_type;	/*  default A/D rangelist */
-	const struct comedi_lrange *ao_range_type;	/*  dafault D/A rangelist */
+	const struct comedi_lrange *ao_range_type;	/*  default D/A rangelist */
 	unsigned int io_range;	/*  len of IO space */
 	unsigned int IRQbits;	/*  allowed interrupts */
 	unsigned int DMAbits;	/*  allowed DMA chans */
@@ -445,7 +445,7 @@ static irqreturn_t interrupt_pcl816(int irq, void *d)
 		comedi_error(dev, "bad IRQ!");
 		return IRQ_NONE;
 	}
-	comedi_error(dev, "IRQ from unknow source!");
+	comedi_error(dev, "IRQ from unknown source!");
 	return IRQ_NONE;
 }
 
diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index e95229b..a008d18 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -50,7 +50,7 @@ A word or two about DMA. Driver support DMA operations at two ways:
           1, 10=A/D input -10V..+10V
     [5] - 0,  5=D/A output 0-5V  (internal reference -5V)
           1, 10=D/A output 0-10V (internal reference -10V)
-	  2    =D/A output unknow (external reference)
+	  2    =D/A output unknown (external reference)
 
    Options for PCL-818, PCL-818H:
     [0] - IO Base
@@ -60,7 +60,7 @@ A word or two about DMA. Driver support DMA operations at two ways:
               1= 1MHz clock for 8254
     [4] - 0,  5=D/A output 0-5V  (internal reference -5V)
           1, 10=D/A output 0-10V (internal reference -10V)
-	  2    =D/A output unknow (external reference)
+	  2    =D/A output unknown (external reference)
 
    Options for PCL-818HD, PCL-818HG:
     [0] - IO Base
@@ -71,7 +71,7 @@ A word or two about DMA. Driver support DMA operations at two ways:
               1= 1MHz clock for 8254
     [4] - 0,  5=D/A output 0-5V  (internal reference -5V)
           1, 10=D/A output 0-10V (internal reference -10V)
-   	  2    =D/A output unknow (external reference)
+   	  2    =D/A output unknown (external reference)
 
    Options for PCL-718:
     [0] - IO Base
@@ -92,7 +92,7 @@ A word or two about DMA. Driver support DMA operations at two ways:
 	     10=	     user defined unipolar
     [5] - 0,  5=D/A outputs 0-5V  (internal reference -5V)
           1, 10=D/A outputs 0-10V (internal reference -10V)
-	      2=D/A outputs unknow (external reference)
+	      2=D/A outputs unknown (external reference)
     [6] - 0, 60=max  60kHz A/D sampling
           1,100=max 100kHz A/D sampling (PCL-718 with Option 001 installed)
 
@@ -876,7 +876,7 @@ static irqreturn_t interrupt_pcl818(int irq, void *d)
 		return IRQ_NONE;
 	}
 
-	comedi_error(dev, "IRQ from unknow source!");
+	comedi_error(dev, "IRQ from unknown source!");
 	return IRQ_NONE;
 }
 
diff --git a/drivers/staging/dst/export.c b/drivers/staging/dst/export.c
index 4fbd848..a4ed16c 100644
--- a/drivers/staging/dst/export.c
+++ b/drivers/staging/dst/export.c
@@ -202,7 +202,7 @@ err_out_exit:
  * so to play good with all cases we just queue BIO into the queue
  * and wake up processing thread, which gets completed request and
  * send (encrypting if needed) it back to the client (if it was a read
- * request), or sends back reply that writing succesfully completed.
+ * request), or sends back reply that writing successfully completed.
  */
 static int dst_export_process_request_queue(struct dst_state *st)
 {
diff --git a/drivers/staging/et131x/et131x_adapter.h b/drivers/staging/et131x/et131x_adapter.h
index 1dfe06f..43bb5c9 100644
--- a/drivers/staging/et131x/et131x_adapter.h
+++ b/drivers/staging/et131x/et131x_adapter.h
@@ -168,7 +168,7 @@ typedef struct _ce_stats_t {
 	u32 tx_deferred;
 
 	/* Rx Statistics. */
-	u32 rx_ov_flow;	/* Rx Over Flow */
+	u32 rx_ov_flow;	/* Rx Overflow */
 
 	u32 length_err;
 	u32 alignment_err;
diff --git a/drivers/staging/hv/hv_api.h b/drivers/staging/hv/hv_api.h
index 251e2d1..9eb818e 100644
--- a/drivers/staging/hv/hv_api.h
+++ b/drivers/staging/hv/hv_api.h
@@ -316,13 +316,13 @@
 
 /*
  * HV_STATUS_VMX_INSTRUCTION_FAILED
- * The requested VMX instruction failed to complete succesfully.
+ * The requested VMX instruction failed to complete successfully.
  */
 #define HV_STATUS_VMX_INSTRUCTION_FAILED		((u16)0x1011)
 
 /*
  * HV_STATUS_VMX_INSTRUCTION_FAILED_WITH_STATUS
- * The requested VMX instruction failed to complete succesfully indicating
+ * The requested VMX instruction failed to complete successfully indicating
  * status.
  */
 #define HV_STATUS_VMX_INSTRUCTION_FAILED_WITH_STATUS	((u16)0x1012)
diff --git a/drivers/staging/iio/accel/accel.h b/drivers/staging/iio/accel/accel.h
index 811fa05..d7fc7f9 100644
--- a/drivers/staging/iio/accel/accel.h
+++ b/drivers/staging/iio/accel/accel.h
@@ -31,13 +31,13 @@
 	IIO_DEVICE_ATTR(accel_z, S_IRUGO, _show, NULL, _addr)
 
 /* Thresholds are somewhat chip dependent - may need quite a few defs here */
-/* For unified thesholds (shared across all directions */
+/* For unified thresholds (shared across all directions */
 
 /**
  * IIO_DEV_ATTR_ACCEL_THRESH: unified threshold
  * @_mode: read/write
  * @_show: read detector threshold value
- * @_store: write detector theshold value
+ * @_store: write detector threshold value
  * @_addr: driver specific data, typically a register address
  *
  * This one is for cases where as single threshold covers all directions
@@ -48,7 +48,7 @@
 /**
  * IIO_DEV_ATTR_ACCEL_THRESH_X: independant direction threshold, x axis
  * @_mode: readable / writable
- * @_show: read x axis detector theshold value
+ * @_show: read x axis detector threshold value
  * @_store: write x axis detector threshold value
  * @_addr: device driver dependant, typically a register address
  **/
diff --git a/drivers/staging/iio/accel/sca3000.h b/drivers/staging/iio/accel/sca3000.h
index 29e11da..da7d3cb 100644
--- a/drivers/staging/iio/accel/sca3000.h
+++ b/drivers/staging/iio/accel/sca3000.h
@@ -74,7 +74,7 @@
 #define SCA3000_MEAS_MODE_OP_2			0x02
 
 /* In motion detection mode the accelerations are band pass filtered
- * (aprox 1 - 25Hz) and then a programmable theshold used to trigger
+ * (aprox 1 - 25Hz) and then a programmable threshold used to trigger
  * and interrupt.
  */
 #define SCA3000_MEAS_MODE_MOT_DET		0x03
@@ -139,7 +139,7 @@
 /* Values of mulipexed registers (write to ctrl_data after select) */
 #define SCA3000_REG_ADDR_CTRL_DATA		0x22
 
-/* Measurment modes available on some sca3000 series chips. Code assumes others
+/* Measurement modes available on some sca3000 series chips. Code assumes others
  * may become available in the future.
  *
  * Bypass - Bypass the low-pass filter in the signal channel so as to increase
diff --git a/drivers/staging/iio/accel/sca3000_core.c b/drivers/staging/iio/accel/sca3000_core.c
index e27e3b7..cedcaa2 100644
--- a/drivers/staging/iio/accel/sca3000_core.c
+++ b/drivers/staging/iio/accel/sca3000_core.c
@@ -720,7 +720,7 @@ error_ret:
 static IIO_DEV_ATTR_TEMP(sca3000_read_temp);
 
 /**
- * sca3000_show_thresh() sysfs query of a theshold
+ * sca3000_show_thresh() sysfs query of a threshold
  **/
 static ssize_t sca3000_show_thresh(struct device *dev,
 				   struct device_attribute *attr,
diff --git a/drivers/staging/octeon/cvmx-pow.h b/drivers/staging/octeon/cvmx-pow.h
index c5d66f2..bf9e069 100644
--- a/drivers/staging/octeon/cvmx-pow.h
+++ b/drivers/staging/octeon/cvmx-pow.h
@@ -1959,7 +1959,7 @@ static inline uint32_t cvmx_pow_tag_get_hw_bits(uint64_t tag)
  * @buffer_size:
  *               The size of the supplied buffer
  *
- * Returns Zero on sucess, negative on failure
+ * Returns Zero on success, negative on failure
  */
 extern int cvmx_pow_capture(void *buffer, int buffer_size);
 
diff --git a/drivers/staging/octeon/ethernet-tx.c b/drivers/staging/octeon/ethernet-tx.c
index 81a8513..5352941 100644
--- a/drivers/staging/octeon/ethernet-tx.c
+++ b/drivers/staging/octeon/ethernet-tx.c
@@ -624,7 +624,7 @@ int cvm_oct_transmit_qos(struct net_device *dev, void *work_queue_entry,
 EXPORT_SYMBOL(cvm_oct_transmit_qos);
 
 /**
- * This function frees all skb that are currenty queued for TX.
+ * This function frees all skb that are currently queued for TX.
  *
  * @dev:    Device being shutdown
  */
diff --git a/drivers/staging/otus/80211core/ccmd.c b/drivers/staging/otus/80211core/ccmd.c
index 83dd8ba..8da28ee 100644
--- a/drivers/staging/otus/80211core/ccmd.c
+++ b/drivers/staging/otus/80211core/ccmd.c
@@ -899,7 +899,7 @@ u16_t zfiWlanDisable(zdev_t *dev, u8_t ResetKeyCache)
 		zfStaDisableSWEncryption(dev);
 	}
 
-	/* Improve WEP/TKIP performace with HT AP,
+	/* Improve WEP/TKIP performance with HT AP,
 	detail information please look bug#32495 */
 	/* zfHpSetTTSIFSTime(dev, 0x8); */
 
@@ -1407,7 +1407,7 @@ u16_t zfWlanReset(zdev_t *dev)
 		zfStaDisableSWEncryption(dev);
 	}
 
-	/* 	Improve WEP/TKIP performace with HT AP,
+	/* 	Improve WEP/TKIP performance with HT AP,
 		detail information please look bug#32495
 	*/
 	/* zfHpSetTTSIFSTime(dev, 0x8); */
diff --git a/drivers/staging/otus/80211core/cmm.c b/drivers/staging/otus/80211core/cmm.c
index bed16b5..a6c1b41 100644
--- a/drivers/staging/otus/80211core/cmm.c
+++ b/drivers/staging/otus/80211core/cmm.c
@@ -1428,7 +1428,7 @@ void zfProcessManagement(zdev_t* dev, zbuf_t* buf, struct zsAdditionInfo* AddInf
         {
                 /* Beacon */
             case ZM_WLAN_FRAME_TYPE_BEACON :
-                /* if enable 802.11h and current chanel is silent but receive beacon from other AP */
+                /* if enable 802.11h and current channel is silent but receive beacon from other AP */
                 if (((wd->regulationTable.allowChannel[wd->regulationTable.CurChIndex].channelFlags
                         & ZM_REG_FLAG_CHANNEL_CSA) != 0) && wd->sta.DFSEnable)
                 {
@@ -1469,7 +1469,7 @@ void zfProcessManagement(zdev_t* dev, zbuf_t* buf, struct zsAdditionInfo* AddInf
                 break;
                 /* Probe response */
             case ZM_WLAN_FRAME_TYPE_PROBERSP :
-                /* if enable 802.11h and current chanel is silent but receive probe response from other AP */
+                /* if enable 802.11h and current channel is silent but receive probe response from other AP */
                 if (((wd->regulationTable.allowChannel[wd->regulationTable.CurChIndex].channelFlags
                         & ZM_REG_FLAG_CHANNEL_CSA) != 0) && wd->sta.DFSEnable)
                 {
diff --git a/drivers/staging/otus/80211core/cmmsta.c b/drivers/staging/otus/80211core/cmmsta.c
index b28a4e2..a11d559 100644
--- a/drivers/staging/otus/80211core/cmmsta.c
+++ b/drivers/staging/otus/80211core/cmmsta.c
@@ -216,7 +216,7 @@ void zfStaConnectFail(zdev_t* dev, u16_t reason, u16_t* bssid, u8_t weight)
     /* Change internal state */
     zfChangeAdapterState(dev, ZM_STA_STATE_DISCONNECT);
 
-    /* Improve WEP/TKIP performace with HT AP, detail information please look bug#32495 */
+    /* Improve WEP/TKIP performance with HT AP, detail information please look bug#32495 */
     //zfHpSetTTSIFSTime(dev, 0x8);
 
     /* Notify wrapper of connection status changes */
@@ -4148,7 +4148,7 @@ void zfInfraConnectNetwork(zdev_t* dev)
             wd->sta.bIsSharedKey = 0;
         }
 
-        /* Improve WEP/TKIP performace with HT AP, detail information please look bug#32495 */
+        /* Improve WEP/TKIP performance with HT AP, detail information please look bug#32495 */
         /*
         if ( (pBssInfo->broadcomHTAp == 1)
              && (wd->sta.SWEncryptEnable != 0) )
diff --git a/drivers/staging/otus/80211core/ctxrx.c b/drivers/staging/otus/80211core/ctxrx.c
index e258a7d..ac54d5a 100644
--- a/drivers/staging/otus/80211core/ctxrx.c
+++ b/drivers/staging/otus/80211core/ctxrx.c
@@ -3093,7 +3093,7 @@ u16_t zfWlanRxFilter(zdev_t* dev, zbuf_t* buf)
 
     frameType = zmw_rx_buf_readh(dev, buf, offset);
 
-    // Don't divide 2^4 because we don't want the fragementation pkt to be treated as
+    // Don't divide 2^4 because we don't want the fragmentation pkt to be treated as
     // duplicated frames
     seq = zmw_rx_buf_readh(dev, buf, offset+22);
     dst0 = zmw_rx_buf_readh(dev, buf, offset+4);
diff --git a/drivers/staging/otus/80211core/pub_zfi.h b/drivers/staging/otus/80211core/pub_zfi.h
index a35bd5d..17f3fe2 100644
--- a/drivers/staging/otus/80211core/pub_zfi.h
+++ b/drivers/staging/otus/80211core/pub_zfi.h
@@ -782,7 +782,7 @@ extern void zfiWlanSetDynamicSIFSParam(zdev_t* dev, u8_t val);
 
 /***** End of section 2 *****/
 
-/***** section 3 performace evaluation *****/
+/***** section 3 performance evaluation *****/
 #ifdef ZM_ENABLE_PERFORMANCE_EVALUATION
 extern void zfiTxPerformanceMSDU(zdev_t* dev, u32_t tick);
 extern void zfiRxPerformanceMPDU(zdev_t* dev, zbuf_t* buf);
diff --git a/drivers/staging/quatech_usb2/quatech_usb2.c b/drivers/staging/quatech_usb2/quatech_usb2.c
index 2acef94..f7726f1 100644
--- a/drivers/staging/quatech_usb2/quatech_usb2.c
+++ b/drivers/staging/quatech_usb2/quatech_usb2.c
@@ -1670,7 +1670,7 @@ __func__);
 		dbg("%s(): failed resubmitting read urb, error %d",
 			__func__, result);
 	} else {
-		dbg("%s() sucessfully resumitted read urb", __func__);
+		dbg("%s() successfully resubmitted read urb", __func__);
 		if (tty_st && RxCount) {
 			/* if some inbound data was processed, then
 			 * we need to push that through the tty layer
diff --git a/drivers/staging/rar/rar_driver.c b/drivers/staging/rar/rar_driver.c
index 9805d74..d85d189 100644
--- a/drivers/staging/rar/rar_driver.c
+++ b/drivers/staging/rar/rar_driver.c
@@ -66,7 +66,7 @@ static int __init rar_init_handler(void);
 static void __exit rar_exit_handler(void);
 
 /*
-  function that is activated on the succesfull probe of the RAR device
+  function that is activated on the successfull probe of the RAR device
 */
 static int __devinit rar_probe(struct pci_dev *pdev, const struct pci_device_id *ent);
 
@@ -319,7 +319,7 @@ static int memrar_init_rar_params(struct pci_dev *pdev)
 }
 
 /*
-  function that is activaed on the succesfull probe of the RAR device
+  function that is activated on the successfull probe of the RAR device
 */
 static int __devinit rar_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
diff --git a/drivers/staging/rt2860/common/cmm_data.c b/drivers/staging/rt2860/common/cmm_data.c
index 774fabb..f0479a1 100644
--- a/drivers/staging/rt2860/common/cmm_data.c
+++ b/drivers/staging/rt2860/common/cmm_data.c
@@ -1241,7 +1241,7 @@ VOID RTMPWriteTxWI(
 	pTxWI->txop= Txopmode;
 
 	pTxWI->NSEQ = NSeq;
-	// John tune the performace with Intel Client in 20 MHz performance
+	// John tune the performance with Intel Client in 20 MHz performance
 	BASize = pAd->CommonCfg.TxBASize;
 
 	if( BASize >7 )
@@ -1331,7 +1331,7 @@ VOID RTMPWriteTxWI_Data(
 	pTxWI->BW = (pTransmit->field.MODE <= MODE_OFDM) ? (BW_20) : (pTransmit->field.BW);
 	pTxWI->AMPDU	= ((pTxBlk->TxFrameType == TX_AMPDU_FRAME) ? TRUE : FALSE);
 
-	// John tune the performace with Intel Client in 20 MHz performance
+	// John tune the performance with Intel Client in 20 MHz performance
 	BASize = pAd->CommonCfg.TxBASize;
 	if((pTxBlk->TxFrameType == TX_AMPDU_FRAME) && (pMacEntry))
 	{
diff --git a/drivers/staging/rt2860/common/cmm_info.c b/drivers/staging/rt2860/common/cmm_info.c
index 019cc44..d4ae081 100644
--- a/drivers/staging/rt2860/common/cmm_info.c
+++ b/drivers/staging/rt2860/common/cmm_info.c
@@ -1736,7 +1736,7 @@ CHAR *GetEncryptType(CHAR enc)
 	if(enc == Ndis802_11Encryption4Enabled)
     	return "TKIPAES";
     else
-    	return "UNKNOW";
+    	return "UNKNOWN";
 }
 
 CHAR *GetAuthMode(CHAR auth)
@@ -1762,7 +1762,7 @@ CHAR *GetAuthMode(CHAR auth)
 	if(auth == Ndis802_11AuthModeWPA1PSKWPA2PSK)
     	return "WPA1PSKWPA2PSK";
 
-    	return "UNKNOW";
+    	return "UNKNOWN";
 }
 
 /*
@@ -1843,7 +1843,7 @@ VOID RTMPIoctlGetSiteSurvey(
 		sprintf(msg+strlen(msg),"%-8s",GetEncryptType(pAdapter->ScanTab.BssEntry[i].WepStatus));
 		//Authentication Mode
 		if (pAdapter->ScanTab.BssEntry[i].WepStatus == Ndis802_11WEPEnabled)
-			sprintf(msg+strlen(msg),"%-10s", "UNKNOW");
+			sprintf(msg+strlen(msg),"%-10s", "UNKNOWN");
 		else
 			sprintf(msg+strlen(msg),"%-10s",GetAuthMode(pAdapter->ScanTab.BssEntry[i].AuthMode));
 		// Rssi
@@ -1869,9 +1869,9 @@ VOID RTMPIoctlGetSiteSurvey(
 		else if (wireless_mode == Ndis802_11OFDM24)
 			sprintf(msg+strlen(msg),"%-7s", "11b/g");
 		else if (wireless_mode == Ndis802_11OFDM24_N)
-			sprintf(msg+strlen(msg),"%-7s", "11b/g/n");
+			sprintf(msg+strlen(msg),"%-8s", "11b/g/n");
 		else
-			sprintf(msg+strlen(msg),"%-7s", "unknow");
+			sprintf(msg+strlen(msg),"%-8s", "unknown");
 		//Network Type
 		if (pAdapter->ScanTab.BssEntry[i].BssType == BSS_ADHOC)
 			sprintf(msg+strlen(msg),"%-3s", " Ad");
@@ -2727,7 +2727,7 @@ PCHAR   RTMPGetRalinkAuthModeStr(
 		case Ndis802_11AuthModeWPANone:
 			return "WPANONE";
 		default:
-			return "UNKNOW";
+			return "UNKNOWN";
 	}
 }
 
@@ -2751,7 +2751,7 @@ PCHAR   RTMPGetRalinkEncryModeStr(
 			return "TKIPAES";
 #if !defined(RT2860) && !defined(RT30xx)
 		default:
-			return "UNKNOW";
+			return "UNKNOWN";
 #endif
 	}
 }
@@ -2834,7 +2834,7 @@ INT	Show_WirelessMode_Proc(
 			sprintf(pBuf, "\t11N only with 5G");
 			break;
 		default:
-			sprintf(pBuf, "\tUnknow Value(%d)", pAd->CommonCfg.PhyMode);
+			sprintf(pBuf, "\tUnknown Value(%d)", pAd->CommonCfg.PhyMode);
 			break;
 	}
 	return 0;
@@ -2865,7 +2865,7 @@ INT	Show_TxPreamble_Proc(
 			sprintf(pBuf, "\tAuto");
 			break;
 		default:
-			sprintf(pBuf, "\tUnknow Value(%lu)", pAd->CommonCfg.TxPreamble);
+			sprintf(pBuf, "\tUnknown Value(%lu)", pAd->CommonCfg.TxPreamble);
 			break;
 	}
 
@@ -2904,7 +2904,7 @@ INT	Show_BGProtection_Proc(
 			sprintf(pBuf, "\tAuto");
 			break;
 		default:
-			sprintf(pBuf, "\tUnknow Value(%lu)", pAd->CommonCfg.UseBGProtection);
+			sprintf(pBuf, "\tUnknown Value(%lu)", pAd->CommonCfg.UseBGProtection);
 			break;
 	}
 	return 0;
@@ -2962,7 +2962,7 @@ INT	Show_HtGi_Proc(
 			sprintf(pBuf, "\tGI_800");
 			break;
 		default:
-			sprintf(pBuf, "\tUnknow Value(%u)", pAd->CommonCfg.RegTransmitSetting.field.ShortGI);
+			sprintf(pBuf, "\tUnknown Value(%u)", pAd->CommonCfg.RegTransmitSetting.field.ShortGI);
 			break;
 	}
 	return 0;
@@ -2981,7 +2981,7 @@ INT	Show_HtOpMode_Proc(
 			sprintf(pBuf, "\tMM");
 			break;
 		default:
-			sprintf(pBuf, "\tUnknow Value(%u)", pAd->CommonCfg.RegTransmitSetting.field.HTMODE);
+			sprintf(pBuf, "\tUnknown Value(%u)", pAd->CommonCfg.RegTransmitSetting.field.HTMODE);
 			break;
 	}
 	return 0;
@@ -3000,7 +3000,7 @@ INT	Show_HtExtcha_Proc(
 			sprintf(pBuf, "\tAbove");
 			break;
 		default:
-			sprintf(pBuf, "\tUnknow Value(%u)", pAd->CommonCfg.RegTransmitSetting.field.EXTCHA);
+			sprintf(pBuf, "\tUnknown Value(%u)", pAd->CommonCfg.RegTransmitSetting.field.EXTCHA);
 			break;
 	}
 	return 0;
@@ -3119,7 +3119,7 @@ INT	Show_NetworkType_Proc(
 			sprintf(pBuf, "\tMonitor");
 			break;
 		default:
-			sprintf(pBuf, "\tUnknow Value(%d)", pAd->StaCfg.BssType);
+			sprintf(pBuf, "\tUnknown Value(%d)", pAd->StaCfg.BssType);
 			break;
 	}
 	return 0;
@@ -3137,7 +3137,7 @@ INT	Show_AuthMode_Proc(
 		(AuthMode <= Ndis802_11AuthModeWPA1PSKWPA2PSK))
 		sprintf(pBuf, "\t%s", RTMPGetRalinkAuthModeStr(AuthMode));
 	else
-		sprintf(pBuf, "\tUnknow Value(%d)", AuthMode);
+		sprintf(pBuf, "\tUnknown Value(%d)", AuthMode);
 
 	return 0;
 }
@@ -3154,7 +3154,7 @@ INT	Show_EncrypType_Proc(
 		(WepStatus <= Ndis802_11Encryption4KeyAbsent))
 		sprintf(pBuf, "\t%s", RTMPGetRalinkEncryModeStr(WepStatus));
 	else
-		sprintf(pBuf, "\tUnknow Value(%d)", WepStatus);
+		sprintf(pBuf, "\tUnknown Value(%d)", WepStatus);
 
 	return 0;
 }
diff --git a/drivers/staging/rt2860/common/eeprom.c b/drivers/staging/rt2860/common/eeprom.c
index ffcb4ce..fb404b5 100644
--- a/drivers/staging/rt2860/common/eeprom.c
+++ b/drivers/staging/rt2860/common/eeprom.c
@@ -213,7 +213,7 @@ USHORT RTMP_EEPROM_READ16(
 
 #ifdef RT2870
 	// Antenna and EEPROM access are both using EESK pin,
-    // Therefor we should avoid accessing EESK at the same time
+    // Therefore we should avoid accessing EESK at the same time
     // Then restore antenna after EEPROM access
 	if ((pAd->NicConfig2.field.AntDiversity) || (pAd->RfIcType == RFIC_3020))
     {
@@ -273,7 +273,7 @@ VOID RTMP_EEPROM_WRITE16(
 
 #ifdef RT2870
 	// Antenna and EEPROM access are both using EESK pin,
-    // Therefor we should avoid accessing EESK at the same time
+    // Therefore we should avoid accessing EESK at the same time
     // Then restore antenna after EEPROM access
 	if ((pAd->NicConfig2.field.AntDiversity) || (pAd->RfIcType == RFIC_3020))
     {
diff --git a/drivers/staging/rt2860/common/mlme.c b/drivers/staging/rt2860/common/mlme.c
index 61a2a4e..2cc10ed 100644
--- a/drivers/staging/rt2860/common/mlme.c
+++ b/drivers/staging/rt2860/common/mlme.c
@@ -1632,14 +1632,14 @@ VOID MlmeSelectTxRateTable(
 					*ppTable = RateSwitchTable11N1S;
 					*pTableSize = RateSwitchTable11N1S[0];
 					*pInitTxRateIdx = RateSwitchTable11N1S[1];
-					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unkown mode,default use 11N 1S AP \n"));
+					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unknown mode,default use 11N 1S AP \n"));
 				}
 				else
 				{
 					*ppTable = RateSwitchTable11N2S;
 					*pTableSize = RateSwitchTable11N2S[0];
 					*pInitTxRateIdx = RateSwitchTable11N2S[1];
-					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unkown mode,default use 11N 2S AP \n"));
+					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unknown mode,default use 11N 2S AP \n"));
 				}
 			}
 			else
@@ -1649,18 +1649,18 @@ VOID MlmeSelectTxRateTable(
 					*ppTable = RateSwitchTable11N1S;
 					*pTableSize = RateSwitchTable11N1S[0];
 					*pInitTxRateIdx = RateSwitchTable11N1S[1];
-					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unkown mode,default use 11N 1S AP \n"));
+					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unknown mode,default use 11N 1S AP \n"));
 				}
 				else
 				{
 					*ppTable = RateSwitchTable11N2SForABand;
 					*pTableSize = RateSwitchTable11N2SForABand[0];
 					*pInitTxRateIdx = RateSwitchTable11N2SForABand[1];
-					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unkown mode,default use 11N 2S AP \n"));
+					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unknown mode,default use 11N 2S AP \n"));
 				}
 			}
 
-			DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unkown mode (SupRateLen=%d, ExtRateLen=%d, MCSSet[0]=0x%x, MCSSet[1]=0x%x)\n",
+			DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unknown mode (SupRateLen=%d, ExtRateLen=%d, MCSSet[0]=0x%x, MCSSet[1]=0x%x)\n",
 				pAd->StaActive.SupRateLen, pAd->StaActive.ExtRateLen, pAd->StaActive.SupportedPhyInfo.MCSSet[0], pAd->StaActive.SupportedPhyInfo.MCSSet[1]));
 		}
 	} while(FALSE);
@@ -7996,7 +7996,7 @@ CHAR RTMPMaxRssi(
 #ifdef RT2870
 // Antenna divesity use GPIO3 and EESK pin for control
 // Antenna and EEPROM access are both using EESK pin,
-// Therefor we should avoid accessing EESK at the same time
+// Therefore we should avoid accessing EESK at the same time
 // Then restore antenna after EEPROM access
 VOID AsicSetRxAnt(
 	IN PRTMP_ADAPTER	pAd,
diff --git a/drivers/staging/rt2860/common/rtmp_init.c b/drivers/staging/rt2860/common/rtmp_init.c
index 20c2ce2..1b93945 100644
--- a/drivers/staging/rt2860/common/rtmp_init.c
+++ b/drivers/staging/rt2860/common/rtmp_init.c
@@ -2691,7 +2691,7 @@ VOID NICUpdateFifoStaCounters(
 
 				pEntry->FIFOCount = 0;
 				pEntry->OneSecTxNoRetryOkCount++;
-				// update NoDataIdleCount when sucessful send packet to STA.
+				// update NoDataIdleCount when successful send packet to STA.
 				pEntry->NoDataIdleCount = 0;
 				pEntry->ContinueTxFailCnt = 0;
 			}
@@ -3344,7 +3344,7 @@ VOID	UserCfgInit(
 	pAd->CommonCfg.TxPower = 100; //mW
 	pAd->CommonCfg.TxPowerPercentage = 0xffffffff; // AUTO
 	pAd->CommonCfg.TxPowerDefault = 0xffffffff; // AUTO
-	pAd->CommonCfg.TxPreamble = Rt802_11PreambleAuto; // use Long preamble on TX by defaut
+	pAd->CommonCfg.TxPreamble = Rt802_11PreambleAuto; // use Long preamble on TX by default
 	pAd->CommonCfg.bUseZeroToDisableFragment = FALSE;
 	pAd->CommonCfg.RtsThreshold = 2347;
 	pAd->CommonCfg.FragmentThreshold = 2346;
diff --git a/drivers/staging/rt2860/common/spectrum.c b/drivers/staging/rt2860/common/spectrum.c
index c658bf3..47cf224 100644
--- a/drivers/staging/rt2860/common/spectrum.c
+++ b/drivers/staging/rt2860/common/spectrum.c
@@ -1773,7 +1773,7 @@ INT Set_MeasureReq_Proc(
 				MeasureReqType = simple_strtol(thisChar, 0, 16);
 				if (MeasureReqType > 3)
 				{
-					DBGPRINT(RT_DEBUG_ERROR, ("%s: unknow MeasureReqType(%d)\n", __func__, MeasureReqType));
+					DBGPRINT(RT_DEBUG_ERROR, ("%s: unknown MeasureReqType(%d)\n", __func__, MeasureReqType));
 					return TRUE;
 				}
 				break;
@@ -1788,7 +1788,7 @@ INT Set_MeasureReq_Proc(
 	DBGPRINT(RT_DEBUG_TRACE, ("%s::Aid = %d, MeasureReqType=%d MeasureCh=%d\n", __func__, Aid, MeasureReqType, MeasureCh));
 	if (!VALID_WCID(Aid))
 	{
-		DBGPRINT(RT_DEBUG_ERROR, ("%s: unknow sta of Aid(%d)\n", __func__, Aid));
+		DBGPRINT(RT_DEBUG_ERROR, ("%s: unknown sta of Aid(%d)\n", __func__, Aid));
 		return TRUE;
 	}
 
@@ -1816,7 +1816,7 @@ INT Set_TpcReq_Proc(
 	DBGPRINT(RT_DEBUG_TRACE, ("%s::Aid = %d\n", __func__, Aid));
 	if (!VALID_WCID(Aid))
 	{
-		DBGPRINT(RT_DEBUG_ERROR, ("%s: unknow sta of Aid(%d)\n", __func__, Aid));
+		DBGPRINT(RT_DEBUG_ERROR, ("%s: unknown sta of Aid(%d)\n", __func__, Aid));
 		return TRUE;
 	}
 
diff --git a/drivers/staging/rt2860/mlme.h b/drivers/staging/rt2860/mlme.h
index 3d1a828..98c2ab2 100644
--- a/drivers/staging/rt2860/mlme.h
+++ b/drivers/staging/rt2860/mlme.h
@@ -730,7 +730,7 @@ typedef struct PACKED _FRAME_BA {
 }   FRAME_BA, *PFRAME_BA;
 
 
-// Radio Measuement Request Frame Format
+// Radio Measurement Request Frame Format
 typedef struct PACKED _FRAME_RM_REQ_ACTION {
 	HEADER_802_11   Hdr;
 	UCHAR	Category;
diff --git a/drivers/staging/rt2860/rt28xx.h b/drivers/staging/rt2860/rt28xx.h
index c085250..9fd2021 100644
--- a/drivers/staging/rt2860/rt28xx.h
+++ b/drivers/staging/rt2860/rt28xx.h
@@ -572,7 +572,7 @@ typedef	union PACKED _TX_RTY_CFG_STRUC	{
 	struct	{
 	    UINT32       ShortRtyLimit:8;	//  short retry limit
 	    UINT32       LongRtyLimit:8;	//long retry limit
-	    UINT32       LongRtyThre:12;	// Long retry threshoold
+	    UINT32       LongRtyThre:12;	// Long retry threshold
 	    UINT32       NonAggRtyMode:1;	// Non-Aggregate MPDU retry mode.  0:expired by retry limit, 1: expired by mpdu life timer
 	    UINT32       AggRtyMode:1;	// Aggregate MPDU retry mode.  0:expired by retry limit, 1: expired by mpdu life timer
 	    UINT32       TxautoFBEnable:1;    // Tx retry PHY rate auto fallback enable
diff --git a/drivers/staging/rt2860/sta/connect.c b/drivers/staging/rt2860/sta/connect.c
index 7bc75ab..e69e692 100644
--- a/drivers/staging/rt2860/sta/connect.c
+++ b/drivers/staging/rt2860/sta/connect.c
@@ -58,8 +58,8 @@ UCHAR	CipherSuiteWpaNoneAes[] = {
 		};
 UCHAR	CipherSuiteWpaNoneAesLen = (sizeof(CipherSuiteWpaNoneAes) / sizeof(UCHAR));
 
-// The following MACRO is called after 1. starting an new IBSS, 2. succesfully JOIN an IBSS,
-// or 3. succesfully ASSOCIATE to a BSS, 4. successfully RE_ASSOCIATE to a BSS
+// The following MACRO is called after 1. starting an new IBSS, 2. successfully JOIN an IBSS,
+// or 3. successfully ASSOCIATE to a BSS, 4. successfully RE_ASSOCIATE to a BSS
 // All settings successfuly negotiated furing MLME state machines become final settings
 // and are copied to pAd->StaActive
 #define COPY_SETTINGS_FROM_MLME_AUX_TO_ACTIVE_CFG(_pAd)                                 \
@@ -1423,7 +1423,7 @@ VOID LinkUp(
 				pAd->SharedKey[BSS0][0].CipherAlg = CIPHER_AES;
 			else
             {
-                DBGPRINT(RT_DEBUG_TRACE, ("Unknow Cipher (=%d), set Cipher to AES\n", pAd->StaCfg.PairCipher));
+                DBGPRINT(RT_DEBUG_TRACE, ("Unknown Cipher (=%d), set Cipher to AES\n", pAd->StaCfg.PairCipher));
 				pAd->SharedKey[BSS0][0].CipherAlg = CIPHER_AES;
             }
 
diff --git a/drivers/staging/rt2860/sta/rtmp_data.c b/drivers/staging/rt2860/sta/rtmp_data.c
index f751ab6..6df1fe2 100644
--- a/drivers/staging/rt2860/sta/rtmp_data.c
+++ b/drivers/staging/rt2860/sta/rtmp_data.c
@@ -898,7 +898,7 @@ Arguments:
 	pPacket 	Pointer to send packet
 
 Return Value:
-	NDIS_STATUS_SUCCESS			If succes to queue the packet into TxSwQueue.
+	NDIS_STATUS_SUCCESS			If success to queue the packet into TxSwQueue.
 	NDIS_STATUS_FAILURE			If failed to do en-queue.
 
 Note:
diff --git a/drivers/staging/rt2860/sta/wpa.c b/drivers/staging/rt2860/sta/wpa.c
index 8c34e39..dc3e6e2 100644
--- a/drivers/staging/rt2860/sta/wpa.c
+++ b/drivers/staging/rt2860/sta/wpa.c
@@ -276,7 +276,7 @@ VOID WpaEAPOLKeyAction(
 			DBGPRINT(RT_DEBUG_TRACE, ("Receive EAPOL Key Group Message 1\n"));
 		}
 
-		// We will assume link is up (assoc suceess and port not secured).
+		// We will assume link is up (assoc success and port not secured).
 		// All state has to be able to process message from previous state
 		switch(pAd->StaCfg.WpaState)
 		{
@@ -366,7 +366,7 @@ VOID WpaEAPOLKeyAction(
 			DBGPRINT(RT_DEBUG_TRACE, ("Receive EAPOL Key Group Message 1\n"));
 		}
 
-		// We will assume link is up (assoc suceess and port not secured).
+		// We will assume link is up (assoc success and port not secured).
 		// All state has to be able to process message from previous state
 		switch(pAd->StaCfg.WpaState)
 		{
diff --git a/drivers/staging/rt2860/sta_ioctl.c b/drivers/staging/rt2860/sta_ioctl.c
index c0e0425..29596f2 100644
--- a/drivers/staging/rt2860/sta_ioctl.c
+++ b/drivers/staging/rt2860/sta_ioctl.c
@@ -1835,7 +1835,7 @@ rt_private_show(struct net_device *dev, struct iw_request_info *info,
 			}
 			break;
         default:
-            DBGPRINT(RT_DEBUG_TRACE, ("%s - unknow subcmd = %d\n", __func__, subcmd));
+            DBGPRINT(RT_DEBUG_TRACE, ("%s - unknown subcmd = %d\n", __func__, subcmd));
             break;
     }
 
@@ -1891,7 +1891,7 @@ int rt_ioctl_siwmlme(struct net_device *dev,
 			break;
 #endif // IW_MLME_DISASSOC //
 		default:
-			DBGPRINT(RT_DEBUG_TRACE, ("====> %s - Unknow Command\n", __func__));
+			DBGPRINT(RT_DEBUG_TRACE, ("====> %s - Unknown Command\n", __func__));
 			break;
 	}
 
@@ -2464,7 +2464,7 @@ int rt_ioctl_siwpmksa(struct net_device *dev,
 			DBGPRINT(RT_DEBUG_TRACE ,("rt_ioctl_siwpmksa - IW_PMKSA_ADD\n"));
 			break;
 		default:
-			DBGPRINT(RT_DEBUG_TRACE ,("rt_ioctl_siwpmksa - Unknow Command!!\n"));
+			DBGPRINT(RT_DEBUG_TRACE ,("rt_ioctl_siwpmksa - Unknown Command!!\n"));
 			break;
 	}
 
diff --git a/drivers/staging/rt2870/common/rtusb_bulk.c b/drivers/staging/rt2870/common/rtusb_bulk.c
index a4244b5..b579292 100644
--- a/drivers/staging/rt2870/common/rtusb_bulk.c
+++ b/drivers/staging/rt2870/common/rtusb_bulk.c
@@ -290,7 +290,7 @@ VOID	RTUSBBulkOutDataPacket(
 			else if (((pAd->BulkOutMaxPacketSize < 512) && ((ThisBulkSize&0xfffff800) != 0) ) /*|| ( (ThisBulkSize != 0)  && (pTxWI->AMPDU == 0))*/)
 			{
 				// For USB 1.1 or peer which didn't support AMPDU, limit the BulkOut size.
-				// For performence in b/g mode, now just check for USB 1.1 and didn't care about the APMDU or not! 2008/06/04.
+				// For performance in b/g mode, now just check for USB 1.1 and didn't care about the APMDU or not! 2008/06/04.
 				pHTTXContext->ENextBulkOutPosition = TmpBulkEndPos;
 				break;
 			}
@@ -305,7 +305,7 @@ VOID	RTUSBBulkOutDataPacket(
 			}
 			else if (((pAd->BulkOutMaxPacketSize < 512) && ((ThisBulkSize&0xfffff800) != 0) ) /*|| ( (ThisBulkSize != 0)  && (pTxWI->AMPDU == 0))*/)
 			{	// For USB 1.1 or peer which didn't support AMPDU, limit the BulkOut size.
-				// For performence in b/g mode, now just check for USB 1.1 and didn't care about the APMDU or not! 2008/06/04.
+				// For performance in b/g mode, now just check for USB 1.1 and didn't care about the APMDU or not! 2008/06/04.
 				pHTTXContext->ENextBulkOutPosition = TmpBulkEndPos;
 				break;
 			}
diff --git a/drivers/staging/rt3090/chips/rt30xx.c b/drivers/staging/rt3090/chips/rt30xx.c
index 9c8ae00..8c8bc65 100644
--- a/drivers/staging/rt3090/chips/rt30xx.c
+++ b/drivers/staging/rt3090/chips/rt30xx.c
@@ -77,7 +77,7 @@ UCHAR NUM_RF_REG_PARMS = (sizeof(RT30xx_RFRegTable) / sizeof(REG_PAIR));
 
 // Antenna divesity use GPIO3 and EESK pin for control
 // Antenna and EEPROM access are both using EESK pin,
-// Therefor we should avoid accessing EESK at the same time
+// Therefore we should avoid accessing EESK at the same time
 // Then restore antenna after EEPROM access
 // The original name of this function is AsicSetRxAnt(), now change to
 //VOID AsicSetRxAnt(
diff --git a/drivers/staging/rt3090/chips/rt33xx.c b/drivers/staging/rt3090/chips/rt33xx.c
index 56f376c..6be89e1 100644
--- a/drivers/staging/rt3090/chips/rt33xx.c
+++ b/drivers/staging/rt3090/chips/rt33xx.c
@@ -92,7 +92,7 @@ UCHAR NUM_RF_REG_PARMS_OVER_RT3390=(sizeof(RFRegTableOverRT3390) / sizeof(REG_PA
 
 // Antenna divesity use GPIO3 and EESK pin for control
 // Antenna and EEPROM access are both using EESK pin,
-// Therefor we should avoid accessing EESK at the same time
+// Therefore we should avoid accessing EESK at the same time
 // Then restore antenna after EEPROM access
 // The original name of this function is AsicSetRxAnt(), now change to
 //VOID AsicSetRxAnt(
diff --git a/drivers/staging/rt3090/common/cmm_data.c b/drivers/staging/rt3090/common/cmm_data.c
index 6340071..4db57e3 100644
--- a/drivers/staging/rt3090/common/cmm_data.c
+++ b/drivers/staging/rt3090/common/cmm_data.c
@@ -1159,7 +1159,7 @@ VOID RTMPWriteTxWI(
 	pTxWI->txop= Txopmode;
 
 	pTxWI->NSEQ = NSeq;
-	// John tune the performace with Intel Client in 20 MHz performance
+	// John tune the performance with Intel Client in 20 MHz performance
 #ifdef DOT11_N_SUPPORT
 	BASize = pAd->CommonCfg.TxBASize;
 	if (pAd->MACVersion == 0x28720200)
@@ -1283,7 +1283,7 @@ VOID RTMPWriteTxWI_Data(
 #endif // DOT11N_DRAFT3 //
 	pTxWI->AMPDU	= ((pTxBlk->TxFrameType == TX_AMPDU_FRAME) ? TRUE : FALSE);
 
-	// John tune the performace with Intel Client in 20 MHz performance
+	// John tune the performance with Intel Client in 20 MHz performance
 	BASize = pAd->CommonCfg.TxBASize;
 	if((pTxBlk->TxFrameType == TX_AMPDU_FRAME) && (pMacEntry))
 	{
diff --git a/drivers/staging/rt3090/common/cmm_info.c b/drivers/staging/rt3090/common/cmm_info.c
index 3e51e98..743a1d6 100644
--- a/drivers/staging/rt3090/common/cmm_info.c
+++ b/drivers/staging/rt3090/common/cmm_info.c
@@ -1948,7 +1948,7 @@ PSTRING GetEncryptType(CHAR enc)
 	if(enc == Ndis802_11Encryption4Enabled)
 	return "TKIPAES";
     else
-	return "UNKNOW";
+	return "UNKNOWN";
 }
 
 PSTRING GetAuthMode(CHAR auth)
@@ -1974,7 +1974,7 @@ PSTRING GetAuthMode(CHAR auth)
 	if(auth == Ndis802_11AuthModeWPA1PSKWPA2PSK)
 	return "WPA1PSKWPA2PSK";
 
-	return "UNKNOW";
+	return "UNKNOWN";
 }
 
 
@@ -2146,9 +2146,9 @@ VOID	RTMPCommSiteSurveyData(
 		else if (wireless_mode == Ndis802_11OFDM24)
 			sprintf(msg+strlen(msg),"%-7s", "11b/g");
 		else if (wireless_mode == Ndis802_11OFDM24_N)
-			sprintf(msg+strlen(msg),"%-7s", "11b/g/n");
+			sprintf(msg+strlen(msg),"%-8s", "11b/g/n");
 		else
-			sprintf(msg+strlen(msg),"%-7s", "unknow");
+			sprintf(msg+strlen(msg),"%-8s", "unknown");
 		//Network Type
 		if (pBss->BssType == BSS_ADHOC)
 			sprintf(msg+strlen(msg),"%-3s", " Ad");
@@ -3172,7 +3172,7 @@ PSTRING RTMPGetRalinkAuthModeStr(
 		case Ndis802_11AuthModeWPANone:
 			return "WPANONE";
 		default:
-			return "UNKNOW";
+			return "UNKNOWN";
 	}
 }
 
@@ -3192,7 +3192,7 @@ PSTRING RTMPGetRalinkEncryModeStr(
         case Ndis802_11Encryption4Enabled:
 			return "TKIPAES";
 		default:
-			return "UNKNOW";
+			return "UNKNOWN";
 	}
 }
 
@@ -3280,7 +3280,7 @@ INT	Show_WirelessMode_Proc(
 			break;
 #endif // DOT11_N_SUPPORT //
 		default:
-			sprintf(pBuf, "\tUnknow Value(%d)", pAd->CommonCfg.PhyMode);
+			sprintf(pBuf, "\tUnknown Value(%d)", pAd->CommonCfg.PhyMode);
 			break;
 	}
 	return 0;
@@ -3311,7 +3311,7 @@ INT	Show_TxPreamble_Proc(
 			sprintf(pBuf, "\tAuto");
 			break;
 		default:
-			sprintf(pBuf, "\tUnknow Value(%lu)", pAd->CommonCfg.TxPreamble);
+			sprintf(pBuf, "\tUnknown Value(%lu)", pAd->CommonCfg.TxPreamble);
 			break;
 	}
 
@@ -3350,7 +3350,7 @@ INT	Show_BGProtection_Proc(
 			sprintf(pBuf, "\tAuto");
 			break;
 		default:
-			sprintf(pBuf, "\tUnknow Value(%lu)", pAd->CommonCfg.UseBGProtection);
+			sprintf(pBuf, "\tUnknown Value(%lu)", pAd->CommonCfg.UseBGProtection);
 			break;
 	}
 	return 0;
@@ -3413,7 +3413,7 @@ INT	Show_HtGi_Proc(
 			sprintf(pBuf, "\tGI_800");
 			break;
 		default:
-			sprintf(pBuf, "\tUnknow Value(%u)", pAd->CommonCfg.RegTransmitSetting.field.ShortGI);
+			sprintf(pBuf, "\tUnknown Value(%u)", pAd->CommonCfg.RegTransmitSetting.field.ShortGI);
 			break;
 	}
 	return 0;
@@ -3432,7 +3432,7 @@ INT	Show_HtOpMode_Proc(
 			sprintf(pBuf, "\tMM");
 			break;
 		default:
-			sprintf(pBuf, "\tUnknow Value(%u)", pAd->CommonCfg.RegTransmitSetting.field.HTMODE);
+			sprintf(pBuf, "\tUnknown Value(%u)", pAd->CommonCfg.RegTransmitSetting.field.HTMODE);
 			break;
 	}
 	return 0;
@@ -3451,7 +3451,7 @@ INT	Show_HtExtcha_Proc(
 			sprintf(pBuf, "\tAbove");
 			break;
 		default:
-			sprintf(pBuf, "\tUnknow Value(%u)", pAd->CommonCfg.RegTransmitSetting.field.EXTCHA);
+			sprintf(pBuf, "\tUnknown Value(%u)", pAd->CommonCfg.RegTransmitSetting.field.EXTCHA);
 			break;
 	}
 	return 0;
@@ -3576,7 +3576,7 @@ INT	Show_NetworkType_Proc(
 			sprintf(pBuf, "\tMonitor");
 			break;
 		default:
-			sprintf(pBuf, "\tUnknow Value(%d)", pAd->StaCfg.BssType);
+			sprintf(pBuf, "\tUnknown Value(%d)", pAd->StaCfg.BssType);
 			break;
 	}
 	return 0;
@@ -3600,7 +3600,7 @@ INT	Show_AuthMode_Proc(
 		(AuthMode <= Ndis802_11AuthModeWPA1PSKWPA2PSK))
 		sprintf(pBuf, "\t%s", RTMPGetRalinkAuthModeStr(AuthMode));
 	else
-		sprintf(pBuf, "\tUnknow Value(%d)", AuthMode);
+		sprintf(pBuf, "\tUnknown Value(%d)", AuthMode);
 
 	return 0;
 }
@@ -3620,7 +3620,7 @@ INT	Show_EncrypType_Proc(
 		(WepStatus <= Ndis802_11Encryption4KeyAbsent))
 		sprintf(pBuf, "\t%s", RTMPGetRalinkEncryModeStr(WepStatus));
 	else
-		sprintf(pBuf, "\tUnknow Value(%d)", WepStatus);
+		sprintf(pBuf, "\tUnknown Value(%d)", WepStatus);
 
 	return 0;
 }
diff --git a/drivers/staging/rt3090/common/ee_prom.c b/drivers/staging/rt3090/common/ee_prom.c
index 051cfde..aaddfa5 100644
--- a/drivers/staging/rt3090/common/ee_prom.c
+++ b/drivers/staging/rt3090/common/ee_prom.c
@@ -224,7 +224,7 @@ int rtmp_ee_prom_read16(
 #ifdef RT30xx
 #ifdef ANT_DIVERSITY_SUPPORT
 	// Antenna and EEPROM access are both using EESK pin,
-	// Therefor we should avoid accessing EESK at the same time
+	// Therefore we should avoid accessing EESK at the same time
 	// Then restore antenna after EEPROM access
 	if ((pAd->NicConfig2.field.AntDiversity)/* || (pAd->RfIcType == RFIC_3020)*/)
 	{
@@ -293,7 +293,7 @@ int rtmp_ee_prom_write16(
 #ifdef RT30xx
 #ifdef ANT_DIVERSITY_SUPPORT
 	// Antenna and EEPROM access are both using EESK pin,
-	// Therefor we should avoid accessing EESK at the same time
+	// Therefore we should avoid accessing EESK at the same time
 	// Then restore antenna after EEPROM access
 	if ((pAd->NicConfig2.field.AntDiversity) /*|| (pAd->RfIcType == RFIC_3020)*/)
 	{
diff --git a/drivers/staging/rt3090/common/igmp_snoop.c b/drivers/staging/rt3090/common/igmp_snoop.c
index 680658f..844bdc7 100644
--- a/drivers/staging/rt3090/common/igmp_snoop.c
+++ b/drivers/staging/rt3090/common/igmp_snoop.c
@@ -594,7 +594,7 @@ VOID IGMPSnooping(
 			break;
 
 		default:
-			DBGPRINT(RT_DEBUG_TRACE, ("unknow IGMP Type=%d\n", IgmpVerType));
+			DBGPRINT(RT_DEBUG_TRACE, ("unknown IGMP Type=%d\n", IgmpVerType));
 			break;
 		}
 	}
@@ -1353,7 +1353,7 @@ VOID MLDSnooping(
 				break;
 
 			default:
-				DBGPRINT(RT_DEBUG_TRACE, ("unknow MLD Type=%d\n", MldType));
+				DBGPRINT(RT_DEBUG_TRACE, ("unknown MLD Type=%d\n", MldType));
 				break;
 		}
 	}
diff --git a/drivers/staging/rt3090/common/mlme.c b/drivers/staging/rt3090/common/mlme.c
index 1613c04..14966b0 100644
--- a/drivers/staging/rt3090/common/mlme.c
+++ b/drivers/staging/rt3090/common/mlme.c
@@ -1253,14 +1253,14 @@ VOID MlmeSelectTxRateTable(
 					*ppTable = RateSwitchTable11N1S;
 					*pTableSize = RateSwitchTable11N1S[0];
 					*pInitTxRateIdx = RateSwitchTable11N1S[1];
-					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unkown mode,default use 11N 1S AP \n"));
+					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unknown mode,default use 11N 1S AP \n"));
 				}
 				else
 				{
 					*ppTable = RateSwitchTable11N2S;
 					*pTableSize = RateSwitchTable11N2S[0];
 					*pInitTxRateIdx = RateSwitchTable11N2S[1];
-					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unkown mode,default use 11N 2S AP \n"));
+					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unknown mode,default use 11N 2S AP \n"));
 				}
 			}
 			else
@@ -1270,18 +1270,18 @@ VOID MlmeSelectTxRateTable(
 					*ppTable = RateSwitchTable11N1S;
 					*pTableSize = RateSwitchTable11N1S[0];
 					*pInitTxRateIdx = RateSwitchTable11N1S[1];
-					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unkown mode,default use 11N 1S AP \n"));
+					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unknown mode,default use 11N 1S AP \n"));
 				}
 				else
 				{
 					*ppTable = RateSwitchTable11N2SForABand;
 					*pTableSize = RateSwitchTable11N2SForABand[0];
 					*pInitTxRateIdx = RateSwitchTable11N2SForABand[1];
-					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unkown mode,default use 11N 2S AP \n"));
+					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unknown mode,default use 11N 2S AP \n"));
 				}
 			}
 #endif // DOT11_N_SUPPORT //
-			DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unkown mode (SupRateLen=%d, ExtRateLen=%d, MCSSet[0]=0x%x, MCSSet[1]=0x%x)\n",
+			DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unknown mode (SupRateLen=%d, ExtRateLen=%d, MCSSet[0]=0x%x, MCSSet[1]=0x%x)\n",
 				pAd->StaActive.SupRateLen, pAd->StaActive.ExtRateLen, pAd->StaActive.SupportedPhyInfo.MCSSet[0], pAd->StaActive.SupportedPhyInfo.MCSSet[1]));
 		}
 #endif // CONFIG_STA_SUPPORT //
diff --git a/drivers/staging/rt3090/common/rtmp_init.c b/drivers/staging/rt3090/common/rtmp_init.c
index 48b95b7..9c18528 100644
--- a/drivers/staging/rt3090/common/rtmp_init.c
+++ b/drivers/staging/rt3090/common/rtmp_init.c
@@ -2111,7 +2111,7 @@ VOID NICUpdateFifoStaCounters(
 #endif // DOT11_N_SUPPORT //
 				pEntry->FIFOCount = 0;
 				pEntry->OneSecTxNoRetryOkCount++;
-				// update NoDataIdleCount when sucessful send packet to STA.
+				// update NoDataIdleCount when successful send packet to STA.
 				pEntry->NoDataIdleCount = 0;
 				pEntry->ContinueTxFailCnt = 0;
 #ifdef WDS_SUPPORT
@@ -2677,7 +2677,7 @@ VOID	UserCfgInit(
 	pAd->CommonCfg.TxPower = 100; //mW
 	pAd->CommonCfg.TxPowerPercentage = 0xffffffff; // AUTO
 	pAd->CommonCfg.TxPowerDefault = 0xffffffff; // AUTO
-	pAd->CommonCfg.TxPreamble = Rt802_11PreambleAuto; // use Long preamble on TX by defaut
+	pAd->CommonCfg.TxPreamble = Rt802_11PreambleAuto; // use Long preamble on TX by default
 	pAd->CommonCfg.bUseZeroToDisableFragment = FALSE;
 	pAd->CommonCfg.RtsThreshold = 2347;
 	pAd->CommonCfg.FragmentThreshold = 2346;
diff --git a/drivers/staging/rt3090/common/spectrum.c b/drivers/staging/rt3090/common/spectrum.c
index 12d2125..f0e5508 100644
--- a/drivers/staging/rt3090/common/spectrum.c
+++ b/drivers/staging/rt3090/common/spectrum.c
@@ -780,7 +780,7 @@ VOID InsertChannelRepIE(
 	{
 		if (RegulatoryClass >= USA_REGULATORY_INFO_SIZE)
 		{
-			DBGPRINT(RT_DEBUG_ERROR, ("%s: USA Unknow Requlatory class (%d)\n",
+			DBGPRINT(RT_DEBUG_ERROR, ("%s: USA Unknown Requlatory class (%d)\n",
 						__FUNCTION__, RegulatoryClass));
 			return;
 		}
@@ -792,7 +792,7 @@ VOID InsertChannelRepIE(
 	{
 		if (RegulatoryClass >= JP_REGULATORY_INFO_SIZE)
 		{
-			DBGPRINT(RT_DEBUG_ERROR, ("%s: JP Unknow Requlatory class (%d)\n",
+			DBGPRINT(RT_DEBUG_ERROR, ("%s: JP Unknown Requlatory class (%d)\n",
 						__FUNCTION__, RegulatoryClass));
 			return;
 		}
@@ -802,7 +802,7 @@ VOID InsertChannelRepIE(
 	}
 	else
 	{
-		DBGPRINT(RT_DEBUG_ERROR, ("%s: Unknow Country (%s)\n",
+		DBGPRINT(RT_DEBUG_ERROR, ("%s: Unknown Country (%s)\n",
 					__FUNCTION__, pCountry));
 		return;
 	}
@@ -1362,7 +1362,7 @@ VOID NotifyChSwAnnToPeerAPs(
 	if (!((pRA[0] & 0xff) == 0xff)) // is pRA a broadcase address.
 	{
 		INT i;
-		// info neighbor APs that Radar signal found throgh WDS link.
+		// info neighbor APs that Radar signal found through WDS link.
 		for (i = 0; i < MAX_WDS_ENTRY; i++)
 		{
 			if (ValidWdsEntry(pAd, i))
@@ -2138,7 +2138,7 @@ INT Set_MeasureReq_Proc(
 				MeasureReqType = simple_strtol(thisChar, 0, 16);
 				if (MeasureReqType > 3)
 				{
-					DBGPRINT(RT_DEBUG_ERROR, ("%s: unknow MeasureReqType(%d)\n", __FUNCTION__, MeasureReqType));
+					DBGPRINT(RT_DEBUG_ERROR, ("%s: unknown MeasureReqType(%d)\n", __FUNCTION__, MeasureReqType));
 					goto END_OF_MEASURE_REQ;
 				}
 				break;
@@ -2153,7 +2153,7 @@ INT Set_MeasureReq_Proc(
 	DBGPRINT(RT_DEBUG_TRACE, ("%s::Aid = %d, MeasureReqType=%d MeasureCh=%d\n", __FUNCTION__, Aid, MeasureReqType, MeasureCh));
 	if (!VALID_WCID(Aid))
 	{
-		DBGPRINT(RT_DEBUG_ERROR, ("%s: unknow sta of Aid(%d)\n", __FUNCTION__, Aid));
+		DBGPRINT(RT_DEBUG_ERROR, ("%s: unknown sta of Aid(%d)\n", __FUNCTION__, Aid));
 		goto END_OF_MEASURE_REQ;
 	}
 
@@ -2209,7 +2209,7 @@ INT Set_TpcReq_Proc(
 	DBGPRINT(RT_DEBUG_TRACE, ("%s::Aid = %d\n", __FUNCTION__, Aid));
 	if (!VALID_WCID(Aid))
 	{
-		DBGPRINT(RT_DEBUG_ERROR, ("%s: unknow sta of Aid(%d)\n", __FUNCTION__, Aid));
+		DBGPRINT(RT_DEBUG_ERROR, ("%s: unknown sta of Aid(%d)\n", __FUNCTION__, Aid));
 		return TRUE;
 	}
 
diff --git a/drivers/staging/rt3090/mlme.h b/drivers/staging/rt3090/mlme.h
index 2336743..09792c3 100644
--- a/drivers/staging/rt3090/mlme.h
+++ b/drivers/staging/rt3090/mlme.h
@@ -883,7 +883,7 @@ typedef struct PACKED _FRAME_BA {
 }   FRAME_BA, *PFRAME_BA;
 
 
-// Radio Measuement Request Frame Format
+// Radio Measurement Request Frame Format
 typedef struct PACKED _FRAME_RM_REQ_ACTION {
 	HEADER_802_11   Hdr;
 	UCHAR	Category;
diff --git a/drivers/staging/rt3090/rt_ate.c b/drivers/staging/rt3090/rt_ate.c
index 259aae4..fbc5838 100644
--- a/drivers/staging/rt3090/rt_ate.c
+++ b/drivers/staging/rt3090/rt_ate.c
@@ -3484,7 +3484,7 @@ static VOID ATEWriteTxWI(
 
 	pTxWI->NSEQ = NSeq;
 
-	// John tune the performace with Intel Client in 20 MHz performance
+	// John tune the performance with Intel Client in 20 MHz performance
 	if ( BASize >7 )
 		BASize =7;
 
diff --git a/drivers/staging/rt3090/rtmp_mac.h b/drivers/staging/rt3090/rtmp_mac.h
index c57b295..f7747e6 100644
--- a/drivers/staging/rt3090/rtmp_mac.h
+++ b/drivers/staging/rt3090/rtmp_mac.h
@@ -1096,7 +1096,7 @@ typedef	union PACKED _TX_RTY_CFG_STRUC	{
 	    UINT32       TxautoFBEnable:1;    // Tx retry PHY rate auto fallback enable
 	    UINT32       AggRtyMode:1;	// Aggregate MPDU retry mode.  0:expired by retry limit, 1: expired by mpdu life timer
 	    UINT32       NonAggRtyMode:1;	// Non-Aggregate MPDU retry mode.  0:expired by retry limit, 1: expired by mpdu life timer
-	    UINT32       LongRtyThre:12;	// Long retry threshoold
+	    UINT32       LongRtyThre:12;	// Long retry threshold
 	    UINT32       LongRtyLimit:8;	//long retry limit
 	    UINT32       ShortRtyLimit:8;	//  short retry limit
 
@@ -1108,7 +1108,7 @@ typedef	union PACKED _TX_RTY_CFG_STRUC	{
 	struct	{
 	    UINT32       ShortRtyLimit:8;	//  short retry limit
 	    UINT32       LongRtyLimit:8;	//long retry limit
-	    UINT32       LongRtyThre:12;	// Long retry threshoold
+	    UINT32       LongRtyThre:12;	// Long retry threshold
 	    UINT32       NonAggRtyMode:1;	// Non-Aggregate MPDU retry mode.  0:expired by retry limit, 1: expired by mpdu life timer
 	    UINT32       AggRtyMode:1;	// Aggregate MPDU retry mode.  0:expired by retry limit, 1: expired by mpdu life timer
 	    UINT32       TxautoFBEnable:1;    // Tx retry PHY rate auto fallback enable
diff --git a/drivers/staging/rt3090/sta/connect.c b/drivers/staging/rt3090/sta/connect.c
index 4aa35ee..23a9e51 100644
--- a/drivers/staging/rt3090/sta/connect.c
+++ b/drivers/staging/rt3090/sta/connect.c
@@ -60,8 +60,8 @@ UCHAR	CipherSuiteWpaNoneAes[] = {
 		};
 UCHAR	CipherSuiteWpaNoneAesLen = (sizeof(CipherSuiteWpaNoneAes) / sizeof(UCHAR));
 
-// The following MACRO is called after 1. starting an new IBSS, 2. succesfully JOIN an IBSS,
-// or 3. succesfully ASSOCIATE to a BSS, 4. successfully RE_ASSOCIATE to a BSS
+// The following MACRO is called after 1. starting an new IBSS, 2. successfully JOIN an IBSS,
+// or 3. successfully ASSOCIATE to a BSS, 4. successfully RE_ASSOCIATE to a BSS
 // All settings successfuly negotiated furing MLME state machines become final settings
 // and are copied to pAd->StaActive
 #define COPY_SETTINGS_FROM_MLME_AUX_TO_ACTIVE_CFG(_pAd)                                 \
@@ -1516,7 +1516,7 @@ VOID LinkUp(
 				pAd->SharedKey[BSS0][0].CipherAlg = CIPHER_AES;
 			else
             {
-                DBGPRINT(RT_DEBUG_TRACE, ("Unknow Cipher (=%d), set Cipher to AES\n", pAd->StaCfg.PairCipher));
+                DBGPRINT(RT_DEBUG_TRACE, ("Unknown Cipher (=%d), set Cipher to AES\n", pAd->StaCfg.PairCipher));
 				pAd->SharedKey[BSS0][0].CipherAlg = CIPHER_AES;
             }
 
diff --git a/drivers/staging/rt3090/sta/rtmp_data.c b/drivers/staging/rt3090/sta/rtmp_data.c
index 5591364..c1b83be 100644
--- a/drivers/staging/rt3090/sta/rtmp_data.c
+++ b/drivers/staging/rt3090/sta/rtmp_data.c
@@ -981,7 +981,7 @@ Arguments:
 	pPacket		Pointer to send packet
 
 Return Value:
-	NDIS_STATUS_SUCCESS			If succes to queue the packet into TxSwQueue.
+	NDIS_STATUS_SUCCESS			If success to queue the packet into TxSwQueue.
 	NDIS_STATUS_FAILURE			If failed to do en-queue.
 
 Note:
diff --git a/drivers/staging/rt3090/sta_ioctl.c b/drivers/staging/rt3090/sta_ioctl.c
index b8ab84a..bd7c61c 100644
--- a/drivers/staging/rt3090/sta_ioctl.c
+++ b/drivers/staging/rt3090/sta_ioctl.c
@@ -2258,7 +2258,7 @@ rt_private_show(struct net_device *dev, struct iw_request_info *info,
 			wrq->length = strlen(extra) + 1; // 1: size of '\0'
 			break;
         default:
-            DBGPRINT(RT_DEBUG_TRACE, ("%s - unknow subcmd = %d\n", __FUNCTION__, subcmd));
+            DBGPRINT(RT_DEBUG_TRACE, ("%s - unknown subcmd = %d\n", __FUNCTION__, subcmd));
             break;
     }
 
@@ -2315,7 +2315,7 @@ int rt_ioctl_siwmlme(struct net_device *dev,
 			break;
 #endif // IW_MLME_DISASSOC //
 		default:
-			DBGPRINT(RT_DEBUG_TRACE, ("====> %s - Unknow Command\n", __FUNCTION__));
+			DBGPRINT(RT_DEBUG_TRACE, ("====> %s - Unknown Command\n", __FUNCTION__));
 			break;
 	}
 
@@ -2909,7 +2909,7 @@ int rt_ioctl_siwpmksa(struct net_device *dev,
 			DBGPRINT(RT_DEBUG_TRACE ,("rt_ioctl_siwpmksa - IW_PMKSA_ADD\n"));
 			break;
 		default:
-			DBGPRINT(RT_DEBUG_TRACE ,("rt_ioctl_siwpmksa - Unknow Command!!\n"));
+			DBGPRINT(RT_DEBUG_TRACE ,("rt_ioctl_siwpmksa - Unknown Command!!\n"));
 			break;
 	}
 
@@ -5000,7 +5000,7 @@ INT RTMPQueryInformation(
                 // add the most up-to-date h/w raw counters into software counters
 			    NICUpdateRawCounters(pAd);
 
-                // Sanity check for calculation of sucessful count
+                // Sanity check for calculation of successful count
                 if (pAd->WlanCounters.TransmittedFragmentCount.QuadPart < pAd->WlanCounters.RetryCount.QuadPart)
                     pAd->WlanCounters.TransmittedFragmentCount.QuadPart = pAd->WlanCounters.RetryCount.QuadPart;
 
@@ -7554,4 +7554,5 @@ INT	Set_Antenna_Proc(
 
 	return TRUE;
 }
-#endif // ANT_DIVERSITY_SUPPORT //
\ No newline at end of file
+#endif // ANT_DIVERSITY_SUPPORT //
+
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
index 334e4c7..1fe19c3 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
@@ -1837,7 +1837,7 @@ ieee80211_rx_frame_softmac(struct ieee80211_device *ieee, struct sk_buff *skb,
 
 					 	            if (((ieee->current_network.wmm_info^info_element->data[6])& \
 										    0x0f)||(!ieee->init_wmmparam_flag)) {
-						   	      //refresh paramete element for current network
+						   	      // refresh parameter element for current network
 							      // update the register parameter for hardware
 							      ieee->init_wmmparam_flag = 1;
 							      queue_work(ieee->wq, &ieee->wmm_param_update_wq);
@@ -1958,10 +1958,10 @@ associate_complete:
  * care of the ieee802.11 fragmentation.
  * So the driver receives a fragment per time and might
  * call the stop function when it want without take care
- * to have enought room to TX an entire packet.
+ * to have enough room to TX an entire packet.
  * This might be useful if each fragment need it's own
  * descriptor, thus just keep a total free memory > than
- * the max fragmentation treshold is not enought.. If the
+ * the max fragmentation threshold is not enough.. If the
  * ieee802.11 stack passed a TXB struct then you needed
  * to keep N free descriptors where
  * N = MAX_PACKET_SIZE / MIN_FRAG_TRESHOLD
diff --git a/drivers/staging/rtl8187se/r8180.h b/drivers/staging/rtl8187se/r8180.h
index 8216d7e..6bb6c9e 100644
--- a/drivers/staging/rtl8187se/r8180.h
+++ b/drivers/staging/rtl8187se/r8180.h
@@ -599,7 +599,7 @@ typedef struct r8180_priv
 	u8						RSSI;
 	char					RxPower;
 	 u8 InitialGain;
-	 //For adjust Dig Threshhold during Legacy/Leisure Power Save Mode
+	 //For adjust Dig Threshold during Legacy/Leisure Power Save Mode
 	u32				DozePeriodInPast2Sec;
 	 // Don't access BB/RF under disable PLL situation.
 	u8					InitialGainBackUp;
diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index 53e654d..dfe5ed9 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -1848,7 +1848,7 @@ void rtl8180_rx(struct net_device *dev)
 				    sizeof(u8),
 				    PCI_DMA_FROMDEVICE);
 
-drop: // this is used when we have not enought mem
+drop: // this is used when we have not enough mem
 		/* restore the descriptor */
 		*(priv->rxringtail+2)=priv->rxbuffer->dma;
 		*(priv->rxringtail)=*(priv->rxringtail) &~ 0xfff;
@@ -1919,8 +1919,8 @@ rate)
 	/*
 	* This function doesn't require lock because we make
 	* sure it's called with the tx_lock already acquired.
-	* this come from the kernel's hard_xmit callback (trought
-	* the ieee stack, or from the try_wake_queue (again trought
+	* this come from the kernel's hard_xmit callback (through
+	* the ieee stack, or from the try_wake_queue (again through
 	* the ieee stack.
 	*/
 	priority = AC2Q(skb->priority);
@@ -3399,7 +3399,7 @@ void rtl8180_adapter_start(struct net_device *dev)
 	/*
 	   The following is very strange. seems to be that 1 means test mode,
 	   but we need to acknolwledges the nic when a packet is ready
-	   altought we set it to 0
+	   although we set it to 0
 	*/
 
 	write_nic_byte(dev,
@@ -4144,7 +4144,7 @@ void rtl8180_tx_isr(struct net_device *dev, int pri,short error)
 		}
 
 	/* we check all the descriptors between the head and the nic,
-	 * but not the currenly pointed by the nic (the next to be txed)
+	 * but not the currently pointed by the nic (the next to be txed)
 	 * and the previous of the pointed (might be in process ??)
 	*/
 	offs = (nic - nicbegin);
diff --git a/drivers/staging/rtl8187se/r8180_dm.c b/drivers/staging/rtl8187se/r8180_dm.c
index b6eeeec..e0c1606 100644
--- a/drivers/staging/rtl8187se/r8180_dm.c
+++ b/drivers/staging/rtl8187se/r8180_dm.c
@@ -36,7 +36,7 @@ bool CheckHighPower(struct net_device *dev)
 //
 //	Note:
 //		The reason why we udpate Tx power level here instead of DoRxHighPower()
-//		is the number of IO to change Tx power is much more than chane TR switch
+//		is the number of IO to change Tx power is much more than channel TR switch
 //		and they are related to OFDM and MAC registers.
 //		So, we don't want to update it so frequently in per-Rx packet base.
 //
@@ -1326,7 +1326,7 @@ SetAntenna8185(
 			break;
 
 		default:
-			printk("SetAntenna8185: unkown RFChipID(%d)\n", priv->rf_chip);
+			printk("SetAntenna8185: unknown RFChipID(%d)\n", priv->rf_chip);
 			break;
 		}
 		break;
@@ -1346,13 +1346,13 @@ SetAntenna8185(
 			break;
 
 		default:
-			printk("SetAntenna8185: unkown RFChipID(%d)\n", priv->rf_chip);
+			printk("SetAntenna8185: unknown RFChipID(%d)\n", priv->rf_chip);
 			break;
 		}
 		break;
 
 	default:
-		printk("SetAntenna8185: unkown u1bAntennaIndex(%d)\n", u1bAntennaIndex);
+		printk("SetAntenna8185: unknown u1bAntennaIndex(%d)\n", u1bAntennaIndex);
 		break;
 	}
 
@@ -1448,7 +1448,7 @@ SwAntennaDiversity(
 
 		priv->bAdSwitchedChecking = false;
 
-		// Adjust Rx signal strength threashold.
+		// Adjust Rx signal strength threshold.
 		priv->AdRxSsThreshold = (priv->AdRxSignalStrength + priv->AdRxSsBeforeSwitched) / 2;
 
 		priv->AdRxSsThreshold = (priv->AdRxSsThreshold > priv->AdMaxRxSsThreshold) ?
@@ -1562,7 +1562,7 @@ SwAntennaDiversity(
 //				priv->AdRxSignalStrength, priv->AdRxSsThreshold);
 
 			priv->bAdSwitchedChecking = false;
-			// Increase Rx signal strength threashold if necessary.
+			// Increase Rx signal strength threshold if necessary.
 			if(	(priv->AdRxSignalStrength > (priv->AdRxSsThreshold + 10)) && // Signal is much stronger than current threshold
 				priv->AdRxSsThreshold <= priv->AdMaxRxSsThreshold) // Current threhold is not yet reach upper limit.
 			{
diff --git a/drivers/staging/rtl8187se/r8180_rtl8225z2.c b/drivers/staging/rtl8187se/r8180_rtl8225z2.c
index b648751..60ee3bc 100644
--- a/drivers/staging/rtl8187se/r8180_rtl8225z2.c
+++ b/drivers/staging/rtl8187se/r8180_rtl8225z2.c
@@ -1058,7 +1058,7 @@ bool SetZebraRFPowerState8185(struct net_device *dev,
 			break;
 		default:
 			bResult = false;
-			printk("SetZebraRFPowerState8185(): unknow state to set: 0x%X!!!\n", eRFPowerState);
+			printk("SetZebraRFPowerState8185(): unknown state to set: 0x%X!!!\n", eRFPowerState);
 			break;
 		}
 		break;
diff --git a/drivers/staging/rtl8187se/r8180_wx.c b/drivers/staging/rtl8187se/r8180_wx.c
index 766892e..536cb6e 100644
--- a/drivers/staging/rtl8187se/r8180_wx.c
+++ b/drivers/staging/rtl8187se/r8180_wx.c
@@ -276,7 +276,7 @@ static int rtl8180_wx_get_range(struct net_device *dev,
 	range->max_qual.updated = 7; /* Updated all three */
 
 	range->avg_qual.qual = 92; /* > 8% missed beacons is 'bad' */
-	/* TODO: Find real 'good' to 'bad' threshol value for RSSI */
+	/* TODO: Find real 'good' to 'bad' threshold value for RSSI */
 	range->avg_qual.level = 20 + -98;
 	range->avg_qual.noise = 0;
 	range->avg_qual.updated = 7; /* Updated all three */
diff --git a/drivers/staging/rtl8187se/r8185b_init.c b/drivers/staging/rtl8187se/r8185b_init.c
index cd07059..bdb66d8 100644
--- a/drivers/staging/rtl8187se/r8185b_init.c
+++ b/drivers/staging/rtl8187se/r8185b_init.c
@@ -2493,8 +2493,8 @@ void rtl8185b_adapter_start(struct net_device *dev)
 	PhyConfig8185(dev);
 
 	// We assume RegWirelessMode has already been initialized before,
-	// however, we has to validate the wireless mode here and provide a reasonble
-	// initialized value if necessary. 2005.01.13, by rcnjko.
+	// however, we has to validate the wireless mode here and provide a
+	// reasonable initialized value if necessary. 2005.01.13, by rcnjko.
 	SupportedWirelessMode = GetSupportedWirelessMode8185(dev);
 	if(	(ieee->mode != WIRELESS_MODE_B) &&
 		(ieee->mode != WIRELESS_MODE_G) &&
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_module.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_module.c
index 12c2a18..2644155 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_module.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_module.c
@@ -164,7 +164,7 @@ struct net_device *alloc_ieee80211(int sizeof_priv)
  	ieee->privacy_invoked = 0;
  	ieee->ieee802_1x = 1;
 	ieee->raw_tx = 0;
-	//ieee->hwsec_support = 1; //defalt support hw security. //use module_param instead.
+	//ieee->hwsec_support = 1; //default support hw security. //use module_param instead.
 	ieee->hwsec_active = 0; //disable hwsec, switch it on when necessary.
 
 	ieee80211_softmac_init(ieee);
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c
index eae7c45..593d228 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c
@@ -2330,10 +2330,10 @@ ieee80211_rx_frame_softmac(struct ieee80211_device *ieee, struct sk_buff *skb,
  * care of the ieee802.11 fragmentation.
  * So the driver receives a fragment per time and might
  * call the stop function when it want without take care
- * to have enought room to TX an entire packet.
+ * to have enough room to TX an entire packet.
  * This might be useful if each fragment need it's own
  * descriptor, thus just keep a total free memory > than
- * the max fragmentation treshold is not enought.. If the
+ * the max fragmentation threshold is not enough.. If the
  * ieee802.11 stack passed a TXB struct then you needed
  * to keep N free descriptors where
  * N = MAX_PACKET_SIZE / MIN_FRAG_TRESHOLD
diff --git a/drivers/staging/rtl8192e/r8190_rtl8256.c b/drivers/staging/rtl8192e/r8190_rtl8256.c
index 0eaee3a..3d67fbb 100644
--- a/drivers/staging/rtl8192e/r8190_rtl8256.c
+++ b/drivers/staging/rtl8192e/r8190_rtl8256.c
@@ -629,7 +629,7 @@ SetRFPowerState8190(
 
 			default:
 					bResult = false;
-					RT_TRACE(COMP_ERR, "SetRFPowerState8190(): unknow state to set: 0x%X!!!\n", eRFPowerState);
+					RT_TRACE(COMP_ERR, "SetRFPowerState8190(): unknown state to set: 0x%X!!!\n", eRFPowerState);
 					break;
 		}
 
diff --git a/drivers/staging/rtl8192e/r8192E_core.c b/drivers/staging/rtl8192e/r8192E_core.c
index b0802a7..ff8fe7e 100644
--- a/drivers/staging/rtl8192e/r8192E_core.c
+++ b/drivers/staging/rtl8192e/r8192E_core.c
@@ -1041,7 +1041,7 @@ static void rtl8192_tx_isr(struct net_device *dev, int prio)
         tx_desc_819x_pci *entry = &ring->desc[ring->idx];
         struct sk_buff *skb;
 
-        /* beacon packet will only use the first descriptor defautly,
+        /* beacon packet will only use the first descriptor defaultly,
          * and the OWN may not be cleared by the hardware
          * */
         if(prio != BEACON_QUEUE) {
@@ -2562,7 +2562,7 @@ static void rtl8192_read_eeprom_info(struct net_device* dev)
 		priv->bTXPowerDataReadFromEEPORM = false;
 	}
 
-	// 2007/11/15 MH 8190PCI Default=2T4R, 8192PCIE dafault=1T2R
+	// 2007/11/15 MH 8190PCI Default=2T4R, 8192PCIE default=1T2R
 	priv->rf_type = RTL819X_DEFAULT_RF_TYPE;
 
 	if(priv->card_8192_version > VERSION_8190_BD)
@@ -3554,7 +3554,7 @@ void rtl8192_prepare_beacon(struct r8192_priv *priv)
 	//spin_lock_irqsave(&priv->tx_lock,flags);
 	/* prepare misc info for the beacon xmit */
 	tcb_desc->queue_index = BEACON_QUEUE;
-	/* IBSS does not support HT yet, use 1M defautly */
+	/* IBSS does not support HT yet, use 1M defaultly */
 	tcb_desc->data_rate = 2;
 	tcb_desc->RATRIndex = 7;
 	tcb_desc->bTxDisableRateFallBack = 1;
diff --git a/drivers/staging/rtl8192e/r8192E_dm.c b/drivers/staging/rtl8192e/r8192E_dm.c
index bf87632..5ffb4f7 100644
--- a/drivers/staging/rtl8192e/r8192E_dm.c
+++ b/drivers/staging/rtl8192e/r8192E_dm.c
@@ -455,7 +455,7 @@ static void dm_check_rate_adaptive(struct net_device * dev)
 					(pra->low_rssi_thresh_for_ra40M):(pra->low_rssi_thresh_for_ra20M);
 		}
 
-		//DbgPrint("[DM] THresh H/L=%d/%d\n\r", RATR.HighRSSIThreshForRA, RATR.LowRSSIThreshForRA);
+		//DbgPrint("[DM] Thresh H/L=%d/%d\n\r", RATR.HighRSSIThreshForRA, RATR.LowRSSIThreshForRA);
 		if(priv->undecorated_smoothed_pwdb >= (long)HighRSSIThreshForRA)
 		{
 			//DbgPrint("[DM] RSSI=%d STA=HIGH\n\r", pHalData->UndecoratedSmoothedPWDB);
@@ -571,7 +571,7 @@ static u32 OFDMSwingTable[OFDM_Table_Length] = {
 	0x5a400169,	// 3, +3db
 	0x50800142,	// 4, +2db
 	0x47c0011f,	// 5, +1db
-	0x40000100,	// 6, +0db ===> default, upper for higher temprature, lower for low temprature
+	0x40000100,	// 6, +0db ===> default, upper for higher temperature, lower for low temperature
 	0x390000e4,	// 7, -1db
 	0x32c000cb,	// 8, -2db
 	0x2d4000b5,	// 9, -3db
@@ -932,14 +932,14 @@ static void dm_TXPowerTrackingCallback_ThermalMeter(struct net_device * dev)
 	RT_TRACE(COMP_POWER_TRACKING, "Readback ThermalMeterA = %d \n", tmpRegA);
 	if(tmpRegA < 3 || tmpRegA > 13)
 		return;
-	if(tmpRegA >= 12)	// if over 12, TP will be bad when high temprature
+	if(tmpRegA >= 12)	// if over 12, TP will be bad when high temperature
 		tmpRegA = 12;
 	RT_TRACE(COMP_POWER_TRACKING, "Valid ThermalMeterA = %d \n", tmpRegA);
 	priv->ThermalMeter[0] = ThermalMeterVal;	//We use fixed value by Bryant's suggestion
 	priv->ThermalMeter[1] = ThermalMeterVal;	//We use fixed value by Bryant's suggestion
 
-	//Get current RF-A temprature index
-	if(priv->ThermalMeter[0] >= (u8)tmpRegA)	//lower temprature
+	//Get current RF-A temperature index
+	if(priv->ThermalMeter[0] >= (u8)tmpRegA)	//lower temperature
 	{
 		tmpOFDMindex = tmpCCK20Mindex = 6+(priv->ThermalMeter[0]-(u8)tmpRegA);
 		tmpCCK40Mindex = tmpCCK20Mindex - 6;
@@ -953,7 +953,7 @@ static void dm_TXPowerTrackingCallback_ThermalMeter(struct net_device * dev)
 	else
 	{
 		tmpval = ((u8)tmpRegA - priv->ThermalMeter[0]);
-		if(tmpval >= 6)								// higher temprature
+		if(tmpval >= 6)								// higher temperature
 			tmpOFDMindex = tmpCCK20Mindex = 0;		// max to +6dB
 		else
 			tmpOFDMindex = tmpCCK20Mindex = 6 - tmpval;
@@ -2017,7 +2017,7 @@ static void dm_dig_init(struct net_device *dev)
 	dm_digtable.dbg_mode = DM_DBG_OFF;	//off=by real rssi value, on=by DM_DigTable.Rssi_val for new dig
 	dm_digtable.dig_algorithm_switch = 0;
 
-	/* 2007/10/04 MH Define init gain threshol. */
+	/* 2007/10/04 MH Define init gain threshold. */
 	dm_digtable.dig_state		= DM_STA_DIG_MAX;
 	dm_digtable.dig_highpwr_state	= DM_STA_DIG_MAX;
 	dm_digtable.initialgain_lowerbound_state = false;
@@ -2145,7 +2145,7 @@ static void dm_ctrl_initgain_byrssi_by_fwfalse_alarm(
 	/*DbgPrint("DIG Check\n\r RSSI=%d LOW=%d HIGH=%d STATE=%d",
 	pHalData->UndecoratedSmoothedPWDB, DM_DigTable.RssiLowThresh,
 	DM_DigTable.RssiHighThresh, DM_DigTable.Dig_State);*/
-	/* 1. When RSSI decrease, We have to judge if it is smaller than a treshold
+	/* 1. When RSSI decrease, We have to judge if it is smaller than a threshold
 		  and then execute below step. */
 	if ((priv->undecorated_smoothed_pwdb <= dm_digtable.rssi_low_thresh))
 	{
@@ -2205,7 +2205,7 @@ static void dm_ctrl_initgain_byrssi_by_fwfalse_alarm(
 
 	}
 
-	/* 2. When RSSI increase, We have to judge if it is larger than a treshold
+	/* 2. When RSSI increase, We have to judge if it is larger than a threshold
 		  and then execute below step.  */
 	if ((priv->undecorated_smoothed_pwdb >= dm_digtable.rssi_high_thresh) )
 	{
@@ -2314,7 +2314,7 @@ static void dm_ctrl_initgain_byrssi_highpwr(
 	}
 
 	/* 3. When RSSI >75% or <70%, it is a high power issue. We have to judge if
-		  it is larger than a treshold and then execute below step.  */
+		  it is larger than a threshold and then execute below step.  */
 	// 2008/02/05 MH SD3-Jerry Modify PD_TH for high power issue.
 	if (priv->undecorated_smoothed_pwdb >= dm_digtable.rssi_high_power_highthresh)
 	{
diff --git a/drivers/staging/rtl8192e/r8192E_wx.c b/drivers/staging/rtl8192e/r8192E_wx.c
index e9e799c..d1eb892 100644
--- a/drivers/staging/rtl8192e/r8192E_wx.c
+++ b/drivers/staging/rtl8192e/r8192E_wx.c
@@ -446,7 +446,7 @@ static int rtl8180_wx_get_range(struct net_device *dev,
 	range->max_qual.updated = 7; /* Updated all three */
 
 	range->avg_qual.qual = 92; /* > 8% missed beacons is 'bad' */
-	/* TODO: Find real 'good' to 'bad' threshol value for RSSI */
+	/* TODO: Find real 'good' to 'bad' threshold value for RSSI */
 	range->avg_qual.level = 20 + -98;
 	range->avg_qual.noise = 0;
 	range->avg_qual.updated = 7; /* Updated all three */
diff --git a/drivers/staging/rtl8192e/r819xE_cmdpkt.c b/drivers/staging/rtl8192e/r819xE_cmdpkt.c
index d6b7d2f..2aaa4e1 100644
--- a/drivers/staging/rtl8192e/r819xE_cmdpkt.c
+++ b/drivers/staging/rtl8192e/r819xE_cmdpkt.c
@@ -783,7 +783,7 @@ u32 cmpk_message_handle_rx(struct net_device *dev, struct ieee80211_rx_stats *ps
 
 			default:
 
-			        RT_TRACE(COMP_EVENTS, "---->cmpk_message_handle_rx():unknow CMD Element\n");
+			        RT_TRACE(COMP_EVENTS, "---->cmpk_message_handle_rx():unknown CMD Element\n");
 				return 1;	/* This is a command packet. */
 		}
 		// 2007/01/22 MH Display received rx command packet info.
diff --git a/drivers/staging/rtl8192e/r819xE_phyreg.h b/drivers/staging/rtl8192e/r819xE_phyreg.h
index d4a4392..37f0fee 100644
--- a/drivers/staging/rtl8192e/r819xE_phyreg.h
+++ b/drivers/staging/rtl8192e/r819xE_phyreg.h
@@ -294,7 +294,7 @@
 #define bR2RCCAMask               		0x00000f00
 #define bHSSI_R2TDelay            		0xf8000000
 #define bHSSI_T2RDelay            		0xf80000
-#define bContTxHSSI               		0x400     //chane gain at continue Tx
+#define bContTxHSSI               		0x400     //channel gain at continue Tx
 #define bIGFromCCK                		0x200
 #define bAGCAddress               		0x3f
 #define bRxHPTx                   			0x7000
diff --git a/drivers/staging/rtl8192su/ieee80211/ieee80211_module.c b/drivers/staging/rtl8192su/ieee80211/ieee80211_module.c
index c3383bb..e8c67d5 100644
--- a/drivers/staging/rtl8192su/ieee80211/ieee80211_module.c
+++ b/drivers/staging/rtl8192su/ieee80211/ieee80211_module.c
@@ -156,7 +156,7 @@ struct net_device *alloc_ieee80211(int sizeof_priv)
  	ieee->privacy_invoked = 0;
  	ieee->ieee802_1x = 1;
 	ieee->raw_tx = 0;
-	//ieee->hwsec_support = 1; //defalt support hw security. //use module_param instead.
+	//ieee->hwsec_support = 1; //default support hw security. //use module_param instead.
 	ieee->hwsec_active = 0; //disable hwsec, switch it on when necessary.
 
 	ieee80211_softmac_init(ieee);
diff --git a/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac.c
index fd8e112..203c0a5 100644
--- a/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac.c
@@ -2120,10 +2120,10 @@ ieee80211_rx_frame_softmac(struct ieee80211_device *ieee, struct sk_buff *skb,
  * care of the ieee802.11 fragmentation.
  * So the driver receives a fragment per time and might
  * call the stop function when it want without take care
- * to have enought room to TX an entire packet.
+ * to have enough room to TX an entire packet.
  * This might be useful if each fragment need it's own
  * descriptor, thus just keep a total free memory > than
- * the max fragmentation treshold is not enought.. If the
+ * the max fragmentation threshold is not enough.. If the
  * ieee802.11 stack passed a TXB struct then you needed
  * to keep N free descriptors where
  * N = MAX_PACKET_SIZE / MIN_FRAG_TRESHOLD
diff --git a/drivers/staging/rtl8192su/ieee80211/readme b/drivers/staging/rtl8192su/ieee80211/readme
index 5764f28..7ba177b 100644
--- a/drivers/staging/rtl8192su/ieee80211/readme
+++ b/drivers/staging/rtl8192su/ieee80211/readme
@@ -37,7 +37,7 @@ What this layer doesn't do (yet)
   disassociate clients, and it is really prone to always allow access.
   In bss client mode it is a bit rough with AP deauth and disassoc requests.
 - It has not any entry point to view the collected stats.
-- Altought it takes care of the card supported rates in the management frame
+- Although it takes care of the card supported rates in the management frame
   it sends, support for rate changing on TXed packet is not complete.
 - Give up once associated in bss client mode (it never detect a
   signal loss condition to disassociate and restart scanning)
diff --git a/drivers/staging/rtl8192su/r8192S_phy.c b/drivers/staging/rtl8192su/r8192S_phy.c
index 2c111d7..77ab026 100644
--- a/drivers/staging/rtl8192su/r8192S_phy.c
+++ b/drivers/staging/rtl8192su/r8192S_phy.c
@@ -1728,7 +1728,7 @@ static bool phy_SetRFPowerState8192SU(struct net_device* dev,RT_RF_POWER_STATE e
 
 			default:
 				bResult = FALSE;
-				//RT_ASSERT(FALSE, ("phy_SetRFPowerState8192SU(): unknow state to set: 0x%X!!!\n", eRFPowerState));
+				//RT_ASSERT(FALSE, ("phy_SetRFPowerState8192SU(): unknown state to set: 0x%X!!!\n", eRFPowerState));
 				break;
 		}
 		break;
@@ -2711,7 +2711,7 @@ u8 rtl8192_phy_SwChnl(struct net_device* dev, u8 channel)
 // However, this procedure is performed synchronously  which should be running under
 // passive level.
 //
-//not understant it
+//not understand it
 void PHY_SwChnlPhy8192S(	// Only called during initialize
 	struct net_device* dev,
 	u8		channel
diff --git a/drivers/staging/rtl8192su/r8192S_phyreg.h b/drivers/staging/rtl8192su/r8192S_phyreg.h
index 96c7cfa..1584378 100644
--- a/drivers/staging/rtl8192su/r8192S_phyreg.h
+++ b/drivers/staging/rtl8192su/r8192S_phyreg.h
@@ -453,7 +453,7 @@
 #define		bR2RCCAMask               			0x00000f00
 #define		bHSSI_R2TDelay            		0xf8000000
 #define		bHSSI_T2RDelay            		0xf80000
-#define		bContTxHSSI               			0x400     //chane gain at continue Tx
+#define		bContTxHSSI               			0x400     //channel gain at continue Tx
 #define		bIGFromCCK                			0x200
 #define		bAGCAddress               			0x3f
 #define		bRxHPTx                   			0x7000
diff --git a/drivers/staging/rtl8192su/r8192S_rtl6052.c b/drivers/staging/rtl8192su/r8192S_rtl6052.c
index 69ef6df..2239809 100644
--- a/drivers/staging/rtl8192su/r8192S_rtl6052.c
+++ b/drivers/staging/rtl8192su/r8192S_rtl6052.c
@@ -326,7 +326,7 @@ extern void PHY_RF6052SetOFDMTxPower(struct net_device* dev, u8 powerlevel)
 
 		//
 		// If path A and Path B coexist, we must limit Path A tx power.
-		// Protect Path B pwr over or under flow. We need to calculate upper and
+		// Protect Path B pwr over or underflow. We need to calculate upper and
 		// lower bound of path A tx power.
 		//
 		if (priv->rf_type == RF_2T2R)
@@ -354,7 +354,7 @@ extern void PHY_RF6052SetOFDMTxPower(struct net_device* dev, u8 powerlevel)
 
 			//
 			// If path A and Path B coexist, we must limit Path A tx power.
-			// Protect Path B pwr over or under flow. We need to calculate upper and
+			// Protect Path B pwr under/over flow. We need to calculate upper and
 			// lower bound of path A tx power.
 			//
 			if (priv->rf_type == RF_2T2R)
diff --git a/drivers/staging/rtl8192su/r8192U_dm.c b/drivers/staging/rtl8192su/r8192U_dm.c
index 5358ae8..7891e96 100644
--- a/drivers/staging/rtl8192su/r8192U_dm.c
+++ b/drivers/staging/rtl8192su/r8192U_dm.c
@@ -593,7 +593,7 @@ static u32 OFDMSwingTable[OFDM_Table_Length] = {
 	0x5a400169,	// 3, +3db
 	0x50800142,	// 4, +2db
 	0x47c0011f,	// 5, +1db
-	0x40000100,	// 6, +0db ===> default, upper for higher temprature, lower for low temprature
+	0x40000100,	// 6, +0db ===> default, upper for higher temperature, lower for low temperature
 	0x390000e4,	// 7, -1db
 	0x32c000cb,	// 8, -2db
 	0x2d4000b5,	// 9, -3db
@@ -912,14 +912,14 @@ static void dm_TXPowerTrackingCallback_ThermalMeter(struct net_device * dev)
 	RT_TRACE(COMP_POWER_TRACKING, "Readback ThermalMeterA = %d \n", tmpRegA);
 	if(tmpRegA < 3 || tmpRegA > 13)
 		return;
-	if(tmpRegA >= 12)	// if over 12, TP will be bad when high temprature
+	if(tmpRegA >= 12)	// if over 12, TP will be bad when high temperature
 		tmpRegA = 12;
 	RT_TRACE(COMP_POWER_TRACKING, "Valid ThermalMeterA = %d \n", tmpRegA);
 	priv->ThermalMeter[0] = ThermalMeterVal;	//We use fixed value by Bryant's suggestion
 	priv->ThermalMeter[1] = ThermalMeterVal;	//We use fixed value by Bryant's suggestion
 
-	//Get current RF-A temprature index
-	if(priv->ThermalMeter[0] >= (u8)tmpRegA)	//lower temprature
+	//Get current RF-A temperature index
+	if(priv->ThermalMeter[0] >= (u8)tmpRegA)	//lower temperature
 	{
 		tmpOFDMindex = tmpCCK20Mindex = 6+(priv->ThermalMeter[0]-(u8)tmpRegA);
 		tmpCCK40Mindex = tmpCCK20Mindex - 6;
@@ -933,7 +933,7 @@ static void dm_TXPowerTrackingCallback_ThermalMeter(struct net_device * dev)
 	else
 	{
 		tmpval = ((u8)tmpRegA - priv->ThermalMeter[0]);
-		if(tmpval >= 6)								// higher temprature
+		if(tmpval >= 6)								// higher temperature
 			tmpOFDMindex = tmpCCK20Mindex = 0;		// max to +6dB
 		else
 			tmpOFDMindex = tmpCCK20Mindex = 6 - tmpval;
diff --git a/drivers/staging/rtl8192su/r8192U_wx.c b/drivers/staging/rtl8192su/r8192U_wx.c
index 2208c9b..a7cc6f9 100644
--- a/drivers/staging/rtl8192su/r8192U_wx.c
+++ b/drivers/staging/rtl8192su/r8192U_wx.c
@@ -435,7 +435,7 @@ static int rtl8180_wx_get_range(struct net_device *dev,
 	range->max_qual.updated = 7; /* Updated all three */
 
 	range->avg_qual.qual = 92; /* > 8% missed beacons is 'bad' */
-	/* TODO: Find real 'good' to 'bad' threshol value for RSSI */
+	/* TODO: Find real 'good' to 'bad' threshold value for RSSI */
 	range->avg_qual.level = 20 + -98;
 	range->avg_qual.noise = 0;
 	range->avg_qual.updated = 7; /* Updated all three */
diff --git a/drivers/staging/rtl8192su/r819xU_cmdpkt.c b/drivers/staging/rtl8192su/r819xU_cmdpkt.c
index e2ba93e..3ebfe79 100644
--- a/drivers/staging/rtl8192su/r819xU_cmdpkt.c
+++ b/drivers/staging/rtl8192su/r819xU_cmdpkt.c
@@ -697,7 +697,7 @@ cmpk_message_handle_rx(
 
 			default:
 
-			        RT_TRACE(COMP_ERR, "---->cmpk_message_handle_rx():unknow CMD Element\n");
+			        RT_TRACE(COMP_ERR, "---->cmpk_message_handle_rx():unknown CMD Element\n");
 				return 1;	/* This is a command packet. */
 		}
 		// 2007/01/22 MH Display received rx command packet info.
diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index f890a16..e54697d 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -2447,7 +2447,7 @@ static void sep_configure_dma_burst(struct sep_device *sep)
 #endif
 
 /*
-  Function that is activaed on the succesful probe of the SEP device
+  Function that is activated on the successful probe of the SEP device
 */
 static int __devinit sep_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
index 52af44c..060e9de 100644
--- a/drivers/staging/serqt_usb2/serqt_usb2.c
+++ b/drivers/staging/serqt_usb2/serqt_usb2.c
@@ -929,7 +929,7 @@ static int qt_open(struct tty_struct *tty,
 	dbg(__FILE__ "qt_setuart completed.\n");
 
 	/*
-	 * Put this here to make it responsive to stty and defauls set by
+	 * Put this here to make it responsive to stty and defaults set by
 	 * the tty layer
 	 */
 	/* FIXME: is this needed? */
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 53450b4..0db8d7b 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -661,7 +661,7 @@ else
    if(zonetype!=pDevice->abyEEPROM[EEP_OFS_ZONETYPE])
       printk("zonetype in file[%02x] mismatch with in EEPROM[%02x]\n",zonetype,pDevice->abyEEPROM[EEP_OFS_ZONETYPE]);
    else
-      printk("Read Zonetype file sucess,use default zonetype setting[%02x]\n",zonetype);
+      printk("Read Zonetype file success,use default zonetype setting[%02x]\n",zonetype);
  }
  	}
   else
diff --git a/drivers/staging/vt6655/ioctl.c b/drivers/staging/vt6655/ioctl.c
index fc9cbe0..d9a5fd2 100644
--- a/drivers/staging/vt6655/ioctl.c
+++ b/drivers/staging/vt6655/ioctl.c
@@ -159,7 +159,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
 	 else if(zonetype == 0x02) { //Europe
              sZoneTypeCmd.ZoneType = ZoneType_Europe;
 	 }
-	 else { //Unknow ZoneType
+	 else { //Unknown ZoneType
 	        printk("Error:ZoneType[%x] Unknown ???\n",zonetype);
 	         result = -EFAULT;
 		break;
@@ -692,7 +692,7 @@ if(wpa_Result.authenticated==TRUE) {
      wireless_send_event(pDevice->dev, IWEVCUSTOM, &wrqu, pItemSSID->abySSID);
    }
    #endif
-         pDevice->fWPA_Authened = TRUE;           //is sucessful peer to wpa_Result.authenticated?
+         pDevice->fWPA_Authened = TRUE;           //is successful peer to wpa_Result.authenticated?
 }
 
         //printk("get private wpa_supplicant announce WPA SM\n");
diff --git a/drivers/staging/vt6655/mib.h b/drivers/staging/vt6655/mib.h
index 69e04f7..2aa2b91 100644
--- a/drivers/staging/vt6655/mib.h
+++ b/drivers/staging/vt6655/mib.h
@@ -325,10 +325,10 @@ typedef struct tagSStatCounter {
    #ifdef Calcu_LinkQual
        //Tx count:
     ULONG TxNoRetryOkCount;         //success tx no retry !
-    ULONG TxRetryOkCount;              //sucess tx but retry !
+    ULONG TxRetryOkCount;              //success tx but retry !
     ULONG TxFailCount;                      //fail tx ?
       //Rx count:
-    ULONG RxOkCnt;                          //sucess rx !
+    ULONG RxOkCnt;                          //success rx !
     ULONG RxFcsErrCnt;                    //fail rx ?
       //statistic
     ULONG SignalStren;
diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 820a7b8..49f419e 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -1041,7 +1041,7 @@ else {
    if(pDevice->config_file.ZoneType !=pDevice->abyEEPROM[EEP_OFS_ZONETYPE])
       printk("zonetype in file[%02x] mismatch with in EEPROM[%02x]\n",pDevice->config_file.ZoneType,pDevice->abyEEPROM[EEP_OFS_ZONETYPE]);
    else
-      printk("Read Zonetype file sucess,use default zonetype setting[%02x]\n",pDevice->config_file.ZoneType);
+      printk("Read Zonetype file success,use default zonetype setting[%02x]\n",pDevice->config_file.ZoneType);
  }
 }
 
diff --git a/drivers/staging/vt6656/channel.c b/drivers/staging/vt6656/channel.c
index e49796f..f7136b0 100644
--- a/drivers/staging/vt6656/channel.c
+++ b/drivers/staging/vt6656/channel.c
@@ -19,7 +19,7 @@
  *
  * File: channel.c
  *
- * Purpose: Channel number maping
+ * Purpose: Channel number mapping
  *
  * Author: Lucas Lin
  *
diff --git a/drivers/staging/vt6656/ioctl.c b/drivers/staging/vt6656/ioctl.c
index d94131f..6f33005 100644
--- a/drivers/staging/vt6656/ioctl.c
+++ b/drivers/staging/vt6656/ioctl.c
@@ -152,7 +152,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
 	 else if(zonetype == 0x02) { //Europe
              sZoneTypeCmd.ZoneType = ZoneType_Europe;
 	 }
-	 else { //Unknow ZoneType
+	 else { //Unknown ZoneType
 	        printk("Error:ZoneType[%x] Unknown ???\n",zonetype);
 	         result = -EFAULT;
 		break;
@@ -679,7 +679,7 @@ if(wpa_Result.authenticated==TRUE) {
      wireless_send_event(pDevice->dev, IWEVCUSTOM, &wrqu, pItemSSID->abySSID);
    }
    #endif
-         pDevice->fWPA_Authened = TRUE;           //is sucessful peer to wpa_Result.authenticated?
+         pDevice->fWPA_Authened = TRUE;           //is successful peer to wpa_Result.authenticated?
 }
 
         //printk("get private wpa_supplicant announce WPA SM\n");
diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index aa8d1a2..b7c6a22 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -1724,7 +1724,7 @@ int iwctl_siwauth(struct net_device *dev,
 	case IW_AUTH_WPA_ENABLED:
 		//pDevice->bWPADEVUp = !! wrq->value;
 		//if(pDevice->bWPADEVUp==TRUE)
-		  // printk("iwctl_siwauth:set WPADEV to enable sucessful*******\n");
+		  // printk("iwctl_siwauth:set WPADEV to enable successful*******\n");
 		//else
 		 //  printk("iwctl_siwauth:set WPADEV to enable fail?????\n");
 		break;
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 0518611..0c74ce8 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1545,7 +1545,7 @@ if(result!=0) {
   return buffer;
 }
 
-//return --->-1:fail;  >=0:sucessful
+//return --->-1:fail;  >=0:successful
 static int Read_config_file(PSDevice pDevice) {
   int result=0;
   UCHAR      tmpbuffer[100];
diff --git a/drivers/staging/vt6656/mib.h b/drivers/staging/vt6656/mib.h
index b806b4d..ac996d2 100644
--- a/drivers/staging/vt6656/mib.h
+++ b/drivers/staging/vt6656/mib.h
@@ -357,10 +357,10 @@ typedef struct tagSStatCounter {
    #ifdef Calcu_LinkQual
        //Tx count:
     ULONG TxNoRetryOkCount;         //success tx no retry !
-    ULONG TxRetryOkCount;              //sucess tx but retry !
+    ULONG TxRetryOkCount;              //success tx but retry !
     ULONG TxFailCount;                      //fail tx ?
       //Rx count:
-    ULONG RxOkCnt;                          //sucess rx !
+    ULONG RxOkCnt;                          //success rx !
     ULONG RxFcsErrCnt;                    //fail rx ?
       //statistic
     ULONG SignalStren;
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 6912344..f0dfcd0 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -1332,7 +1332,7 @@ BSSvSecondTxData(
     }
 
   spin_lock_irq(&pDevice->lock);
-  //is wap_supplicant running sucessful OR only open && sharekey mode!
+  //is wap_supplicant running successful OR only open && sharekey mode!
   #if 1
   if(((pDevice->bLinkPass ==TRUE)&&(pMgmt->eAuthenMode < WMAC_AUTH_WPA)) ||  //open && sharekey linking
       (pDevice->fWPA_Authened == TRUE)) {   //wpa linking
-- 
1.6.5.2.180.gc5b3e.dirty

