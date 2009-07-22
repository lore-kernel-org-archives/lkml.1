Return-Path: <linux-kernel-owner+w=401wt.eu-S1756363AbZGVDIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363AbZGVDIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 23:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756269AbZGVDIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 23:08:52 -0400
Received: from dscas1.ad.uiuc.edu ([128.174.68.119]:4992 "EHLO
	dscas1.ad.uiuc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197AbZGVDIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 23:08:25 -0400
X-Greylist: delayed 325 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Jul 2009 23:08:23 EDT
From: Stoyan Gaydarov <sgayda2@uiuc.edu>
To: linux-kernel@vger.kernel.org
CC: Stoyan Gaydarov <sgayda2@uiuc.edu>, gregkh@suse.de,
       devel@driverdev.osuosl.org
Subject: [PATCH 1/7] [staging] ARRAY_SIZE changes
Date: Tue, 21 Jul 2009 22:02:27 -0500
Message-ID: <1248231753-8344-2-git-send-email-sgayda2@uiuc.edu>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248231753-8344-1-git-send-email-sgayda2@uiuc.edu>
References: <1248231753-8344-1-git-send-email-sgayda2@uiuc.edu>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These changes were a direct result of using a semantic patch
More information can be found at http://www.emn.fr/x-info/coccinelle/

Signed-off-by: Stoyan Gaydarov <sgayda2@uiuc.edu>
---
 drivers/staging/comedi/drivers/amplc_pci230.c      |    2 +-
 drivers/staging/comedi/drivers/cb_das16_cs.c       |    2 +-
 drivers/staging/comedi/drivers/das08_cs.c          |    3 +--
 drivers/staging/comedi/drivers/ni_6527.c           |    2 +-
 drivers/staging/comedi/drivers/ni_65xx.c           |    2 +-
 drivers/staging/comedi/drivers/ni_660x.c           |    2 +-
 drivers/staging/comedi/drivers/ni_670x.c           |    2 +-
 drivers/staging/comedi/drivers/ni_atmio16d.c       |    2 +-
 drivers/staging/comedi/drivers/ni_pcidio.c         |    2 +-
 drivers/staging/comedi/drivers/ni_pcimio.c         |    2 +-
 drivers/staging/comedi/drivers/pcmad.c             |    2 +-
 drivers/staging/comedi/drivers/poc.c               |    2 +-
 drivers/staging/epl/EplDllk.c                      |    2 +-
 drivers/staging/epl/proc_fs.c                      |    4 ++--
 drivers/staging/line6/driver.c                     |    2 +-
 drivers/staging/meilhaus/me0600_device.h           |    2 +-
 drivers/staging/meilhaus/me0900_device.h           |    2 +-
 drivers/staging/meilhaus/me1400_device.h           |    2 +-
 drivers/staging/meilhaus/me1600_device.h           |    2 +-
 drivers/staging/meilhaus/me4600_device.h           |    2 +-
 drivers/staging/meilhaus/me6000_device.h           |    2 +-
 drivers/staging/meilhaus/me8100_device.h           |    2 +-
 drivers/staging/meilhaus/me8200_device.h           |    2 +-
 drivers/staging/meilhaus/metempl_device.h          |    2 +-
 drivers/staging/rtl8187se/r8180_wx.c               |    6 +++---
 drivers/staging/rtl8192su/ieee80211/ieee80211_wx.c |    2 +-
 drivers/staging/rtl8192su/r8192U_wx.c              |    4 ++--
 drivers/staging/slicoss/slicoss.c                  |    2 +-
 drivers/staging/sxg/sxg.c                          |    2 +-
 29 files changed, 33 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 21133f0..84d355e 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -512,7 +512,7 @@ MODULE_DEVICE_TABLE(pci, pci230_pci_table);
 /*
  * Useful for shorthand access to the particular board structure
  */
-#define n_pci230_boards (sizeof(pci230_boards)/sizeof(pci230_boards[0]))
+#define n_pci230_boards ARRAY_SIZE(pci230_boards)
 #define thisboard ((const struct pci230_board *)dev->board_ptr)
 
 /* this structure is for data unique to this hardware driver.  If
diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index 7af245b..59f635f 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -78,7 +78,7 @@ static const struct das16cs_board das16cs_boards[] = {
 		},
 };
 
-#define n_boards (sizeof(das16cs_boards)/sizeof(das16cs_boards[0]))
+#define n_boards ARRAY_SIZE(das16cs_boards)
 #define thisboard ((const struct das16cs_board *)dev->board_ptr)
 
 struct das16cs_private {
diff --git a/drivers/staging/comedi/drivers/das08_cs.c b/drivers/staging/comedi/drivers/das08_cs.c
index 8e44641..bfd2b8d 100644
--- a/drivers/staging/comedi/drivers/das08_cs.c
+++ b/drivers/staging/comedi/drivers/das08_cs.c
@@ -64,8 +64,7 @@ static struct comedi_driver driver_das08_cs = {
 	.attach = das08_cs_attach,
 	.detach = das08_common_detach,
 	.board_name = &das08_cs_boards[0].name,
-	.num_names = sizeof(das08_cs_boards) /
-		sizeof(struct das08_board_struct),
+	.num_names = ARRAY_SIZE(das08_cs_boards),
 	.offset = sizeof(struct das08_board_struct),
 };
 
diff --git a/drivers/staging/comedi/drivers/ni_6527.c b/drivers/staging/comedi/drivers/ni_6527.c
index 67adc97..e331004 100644
--- a/drivers/staging/comedi/drivers/ni_6527.c
+++ b/drivers/staging/comedi/drivers/ni_6527.c
@@ -102,7 +102,7 @@ static const struct ni6527_board ni6527_boards[] = {
 		},
 };
 
-#define n_ni6527_boards (sizeof(ni6527_boards)/sizeof(ni6527_boards[0]))
+#define n_ni6527_boards ARRAY_SIZE(ni6527_boards)
 #define this_board ((const struct ni6527_board *)dev->board_ptr)
 
 static DEFINE_PCI_DEVICE_TABLE(ni6527_pci_table) = {
diff --git a/drivers/staging/comedi/drivers/ni_65xx.c b/drivers/staging/comedi/drivers/ni_65xx.c
index 3570850..e261079 100644
--- a/drivers/staging/comedi/drivers/ni_65xx.c
+++ b/drivers/staging/comedi/drivers/ni_65xx.c
@@ -241,7 +241,7 @@ static const struct ni_65xx_board ni_65xx_boards[] = {
 		},
 };
 
-#define n_ni_65xx_boards (sizeof(ni_65xx_boards)/sizeof(ni_65xx_boards[0]))
+#define n_ni_65xx_boards ARRAY_SIZE(ni_65xx_boards)
 static inline const struct ni_65xx_board *board(struct comedi_device * dev)
 {
 	return dev->board_ptr;
diff --git a/drivers/staging/comedi/drivers/ni_660x.c b/drivers/staging/comedi/drivers/ni_660x.c
index 11e9b04..edf57f9 100644
--- a/drivers/staging/comedi/drivers/ni_660x.c
+++ b/drivers/staging/comedi/drivers/ni_660x.c
@@ -447,7 +447,7 @@ static inline const struct ni_660x_board *board(struct comedi_device * dev)
 	return dev->board_ptr;
 }
 
-#define n_ni_660x_boards (sizeof(ni_660x_boards)/sizeof(ni_660x_boards[0]))
+#define n_ni_660x_boards ARRAY_SIZE(ni_660x_boards)
 
 static int ni_660x_attach(struct comedi_device *dev, struct comedi_devconfig *it);
 static int ni_660x_detach(struct comedi_device *dev);
diff --git a/drivers/staging/comedi/drivers/ni_670x.c b/drivers/staging/comedi/drivers/ni_670x.c
index 71f7d3a..0412c93 100644
--- a/drivers/staging/comedi/drivers/ni_670x.c
+++ b/drivers/staging/comedi/drivers/ni_670x.c
@@ -110,7 +110,7 @@ struct ni_670x_private {
 
 
 #define devpriv ((struct ni_670x_private *)dev->private)
-#define n_ni_670x_boards (sizeof(ni_670x_boards)/sizeof(ni_670x_boards[0]))
+#define n_ni_670x_boards ARRAY_SIZE(ni_670x_boards)
 
 static int ni_670x_attach(struct comedi_device *dev, struct comedi_devconfig *it);
 static int ni_670x_detach(struct comedi_device *dev);
diff --git a/drivers/staging/comedi/drivers/ni_atmio16d.c b/drivers/staging/comedi/drivers/ni_atmio16d.c
index 1a8c2ab..eaeb721 100644
--- a/drivers/staging/comedi/drivers/ni_atmio16d.c
+++ b/drivers/staging/comedi/drivers/ni_atmio16d.c
@@ -121,7 +121,7 @@ static const struct atmio16_board_t atmio16_boards[] = {
 		},
 };
 
-#define n_atmio16_boards sizeof(atmio16_boards)/sizeof(atmio16_boards[0])
+#define n_atmio16_boards ARRAY_SIZE(atmio16_boards)
 
 #define boardtype ((const struct atmio16_board_t *)dev->board_ptr)
 
diff --git a/drivers/staging/comedi/drivers/ni_pcidio.c b/drivers/staging/comedi/drivers/ni_pcidio.c
index 6b86a39..3d50ac7 100644
--- a/drivers/staging/comedi/drivers/ni_pcidio.c
+++ b/drivers/staging/comedi/drivers/ni_pcidio.c
@@ -372,7 +372,7 @@ static const struct nidio_board nidio_boards[] = {
 		},
 };
 
-#define n_nidio_boards (sizeof(nidio_boards)/sizeof(nidio_boards[0]))
+#define n_nidio_boards ARRAY_SIZE(nidio_boards)
 #define this_board ((const struct nidio_board *)dev->board_ptr)
 
 static DEFINE_PCI_DEVICE_TABLE(ni_pcidio_pci_table) = {
diff --git a/drivers/staging/comedi/drivers/ni_pcimio.c b/drivers/staging/comedi/drivers/ni_pcimio.c
index 1d04b75..b42d106 100644
--- a/drivers/staging/comedi/drivers/ni_pcimio.c
+++ b/drivers/staging/comedi/drivers/ni_pcimio.c
@@ -1205,7 +1205,7 @@ static const struct ni_board_struct ni_boards[] = {
 		},
 };
 
-#define n_pcimio_boards ((sizeof(ni_boards)/sizeof(ni_boards[0])))
+#define n_pcimio_boards ARRAY_SIZE(ni_boards)
 
 static int pcimio_attach(struct comedi_device *dev, struct comedi_devconfig *it);
 static int pcimio_detach(struct comedi_device *dev);
diff --git a/drivers/staging/comedi/drivers/pcmad.c b/drivers/staging/comedi/drivers/pcmad.c
index 9bb2669..bfb2df3 100644
--- a/drivers/staging/comedi/drivers/pcmad.c
+++ b/drivers/staging/comedi/drivers/pcmad.c
@@ -69,7 +69,7 @@ static const struct pcmad_board_struct pcmad_boards[] = {
 };
 
 #define this_board ((const struct pcmad_board_struct *)(dev->board_ptr))
-#define n_pcmad_boards (sizeof(pcmad_boards)/sizeof(pcmad_boards[0]))
+#define n_pcmad_boards ARRAY_SIZE(pcmad_boards)
 
 struct pcmad_priv_struct {
 	int differential;
diff --git a/drivers/staging/comedi/drivers/poc.c b/drivers/staging/comedi/drivers/poc.c
index 47850bd..bbcdec9 100644
--- a/drivers/staging/comedi/drivers/poc.c
+++ b/drivers/staging/comedi/drivers/poc.c
@@ -100,7 +100,7 @@ static const struct boarddef_struct boards[] = {
 		},
 };
 
-#define n_boards (sizeof(boards)/sizeof(boards[0]))
+#define n_boards ARRAY_SIZE(boards)
 #define this_board ((const struct boarddef_struct *)dev->board_ptr)
 
 static struct comedi_driver driver_poc = {
diff --git a/drivers/staging/epl/EplDllk.c b/drivers/staging/epl/EplDllk.c
index 25d2c34..0572c3d 100644
--- a/drivers/staging/epl/EplDllk.c
+++ b/drivers/staging/epl/EplDllk.c
@@ -328,7 +328,7 @@ tEplKernel EplDllkAddInstance(tEplDllkInitParam * pInitParam_p)
 	// initialize and link pointers in instance structure to frame tables
 	EplDllkInstance_g.m_pTxBuffer = aEplDllkTxBuffer_l;
 	EplDllkInstance_g.m_uiMaxTxFrames =
-	    sizeof(aEplDllkTxBuffer_l) / sizeof(tEdrvTxBuffer);
+	    ARRAY_SIZE(aEplDllkTxBuffer_l);
 
 	// initialize state
 	EplDllkInstance_g.m_DllState = kEplDllGsInit;
diff --git a/drivers/staging/epl/proc_fs.c b/drivers/staging/epl/proc_fs.c
index 9ccf079..e48949d 100644
--- a/drivers/staging/epl/proc_fs.c
+++ b/drivers/staging/epl/proc_fs.c
@@ -196,7 +196,7 @@ void TgtDbgSignalTracePoint(u8 bTracePointNumber_p)
 {
 
 	if (bTracePointNumber_p >=
-	    (sizeof(aatmDbgTracePoint_l) / sizeof(aatmDbgTracePoint_l[0]))) {
+	    ARRAY_SIZE(aatmDbgTracePoint_l)) {
 		goto Exit;
 	}
 
@@ -330,7 +330,7 @@ static int EplLinProcRead(char *pcBuffer_p,
 		nSize += snprintf(pcBuffer_p + nSize, nBufferSize_p - nSize,
 				  "DbgTracePoints:\n");
 		for (nNum = 0;
-		     nNum < (sizeof(aatmDbgTracePoint_l) / sizeof(atomic_t));
+		     nNum < ARRAY_SIZE(aatmDbgTracePoint_l);
 		     nNum++) {
 			nSize +=
 			    snprintf(pcBuffer_p + nSize, nBufferSize_p - nSize,
diff --git a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
index 85a20d0..f188ece 100644
--- a/drivers/staging/line6/driver.c
+++ b/drivers/staging/line6/driver.c
@@ -682,7 +682,7 @@ static int line6_probe(struct usb_interface *interface, const struct usb_device_
 		return -ENODEV;
 
 	/* check vendor and product id */
-	for (devtype = sizeof(line6_id_table) / sizeof(line6_id_table[0]) - 1; devtype--;)
+	for (devtype = ARRAY_SIZE(line6_id_table) - 1; devtype--;)
 		if ((le16_to_cpu(usbdev->descriptor.idVendor) == line6_id_table[devtype].idVendor) &&
 			 (le16_to_cpu(usbdev->descriptor.idProduct) == line6_id_table[devtype].idProduct))
 			break;
diff --git a/drivers/staging/meilhaus/me0600_device.h b/drivers/staging/meilhaus/me0600_device.h
index d93a8ae..75bd3b7 100644
--- a/drivers/staging/meilhaus/me0600_device.h
+++ b/drivers/staging/meilhaus/me0600_device.h
@@ -54,7 +54,7 @@ static me0600_version_t me0600_versions[] = {
 	{0},
 };
 
-#define ME0600_DEVICE_VERSIONS (sizeof(me0600_versions) / sizeof(me0600_version_t) - 1)	/**< Returns the number of entries in #me0600_versions. */
+#define ME0600_DEVICE_VERSIONS (ARRAY_SIZE(me0600_versions) - 1)	/**< Returns the number of entries in #me0600_versions. */
 
 /**
  * @brief Returns the index of the device entry in #me0600_versions.
diff --git a/drivers/staging/meilhaus/me0900_device.h b/drivers/staging/meilhaus/me0900_device.h
index bd17f25..53c05e8 100644
--- a/drivers/staging/meilhaus/me0900_device.h
+++ b/drivers/staging/meilhaus/me0900_device.h
@@ -53,7 +53,7 @@ static me0900_version_t me0900_versions[] = {
 	{0},
 };
 
-#define ME0900_DEVICE_VERSIONS (sizeof(me0900_versions) / sizeof(me0900_version_t) - 1)	/**< Returns the number of entries in #me0900_versions. */
+#define ME0900_DEVICE_VERSIONS (ARRAY_SIZE(me0900_versions) - 1)	/**< Returns the number of entries in #me0900_versions. */
 
 /**
  * @brief Returns the index of the device entry in #me0900_versions.
diff --git a/drivers/staging/meilhaus/me1400_device.h b/drivers/staging/meilhaus/me1400_device.h
index 6215b25..d20112d 100644
--- a/drivers/staging/meilhaus/me1400_device.h
+++ b/drivers/staging/meilhaus/me1400_device.h
@@ -60,7 +60,7 @@ static me1400_version_t me1400_versions[] = {
 	{0}
 };
 
-#define ME1400_DEVICE_VERSIONS (sizeof(me1400_versions) / sizeof(me1400_version_t) - 1)	/**< Returns the number of entries in #me1400_versions. */
+#define ME1400_DEVICE_VERSIONS (ARRAY_SIZE(me1400_versions) - 1)	/**< Returns the number of entries in #me1400_versions. */
 
 /**
  * @brief Returns the index of the device entry in #me1400_versions.
diff --git a/drivers/staging/meilhaus/me1600_device.h b/drivers/staging/meilhaus/me1600_device.h
index f7b231f..c73aca1 100644
--- a/drivers/staging/meilhaus/me1600_device.h
+++ b/drivers/staging/meilhaus/me1600_device.h
@@ -58,7 +58,7 @@ static me1600_version_t me1600_versions[] = {
 };
 
 /**< Returns the number of entries in #me1600_versions. */
-#define ME1600_DEVICE_VERSIONS (sizeof(me1600_versions) / sizeof(me1600_version_t) - 1)
+#define ME1600_DEVICE_VERSIONS (ARRAY_SIZE(me1600_versions) - 1)
 
 /**
  * @brief Returns the index of the device entry in #me1600_versions.
diff --git a/drivers/staging/meilhaus/me4600_device.h b/drivers/staging/meilhaus/me4600_device.h
index fa812d4..c755c57 100644
--- a/drivers/staging/meilhaus/me4600_device.h
+++ b/drivers/staging/meilhaus/me4600_device.h
@@ -80,7 +80,7 @@ static me4600_version_t me4600_versions[] = {
 	{0},
 };
 
-#define ME4600_DEVICE_VERSIONS (sizeof(me4600_versions) / sizeof(me4600_version_t) - 1)	/**< Returns the number of entries in #me4600_versions. */
+#define ME4600_DEVICE_VERSIONS (ARRAY_SIZE(me4600_versions) - 1)	/**< Returns the number of entries in #me4600_versions. */
 
 /**
  * @brief Returns the index of the device entry in #me4600_versions.
diff --git a/drivers/staging/meilhaus/me6000_device.h b/drivers/staging/meilhaus/me6000_device.h
index 18cc7d1..eed4011 100644
--- a/drivers/staging/meilhaus/me6000_device.h
+++ b/drivers/staging/meilhaus/me6000_device.h
@@ -103,7 +103,7 @@ static me6000_version_t me6000_versions[] = {
 	{0},
 };
 
-#define ME6000_DEVICE_VERSIONS (sizeof(me6000_versions) / sizeof(me6000_version_t) - 1)	/**< Returns the number of entries in #me6000_versions. */
+#define ME6000_DEVICE_VERSIONS (ARRAY_SIZE(me6000_versions) - 1)	/**< Returns the number of entries in #me6000_versions. */
 
 /**
  * @brief Returns the index of the device entry in #me6000_versions.
diff --git a/drivers/staging/meilhaus/me8100_device.h b/drivers/staging/meilhaus/me8100_device.h
index 44c42ef..238dc06 100644
--- a/drivers/staging/meilhaus/me8100_device.h
+++ b/drivers/staging/meilhaus/me8100_device.h
@@ -53,7 +53,7 @@ static me8100_version_t me8100_versions[] = {
 	{0},
 };
 
-#define ME8100_DEVICE_VERSIONS (sizeof(me8100_versions) / sizeof(me8100_version_t) - 1)	/**< Returns the number of entries in #me8100_versions. */
+#define ME8100_DEVICE_VERSIONS (ARRAY_SIZE(me8100_versions) - 1)	/**< Returns the number of entries in #me8100_versions. */
 
 /**
  * @brief Returns the index of the device entry in #me8100_versions.
diff --git a/drivers/staging/meilhaus/me8200_device.h b/drivers/staging/meilhaus/me8200_device.h
index cbd2a01..66f5084 100644
--- a/drivers/staging/meilhaus/me8200_device.h
+++ b/drivers/staging/meilhaus/me8200_device.h
@@ -53,7 +53,7 @@ static me8200_version_t me8200_versions[] = {
 	{0},
 };
 
-#define ME8200_DEVICE_VERSIONS (sizeof(me8200_versions) / sizeof(me8200_version_t) - 1)	/**< Returns the number of entries in #me8200_versions. */
+#define ME8200_DEVICE_VERSIONS (ARRAY_SIZE(me8200_versions) - 1)	/**< Returns the number of entries in #me8200_versions. */
 
 /**
  * @brief Returns the index of the device entry in #me8200_versions.
diff --git a/drivers/staging/meilhaus/metempl_device.h b/drivers/staging/meilhaus/metempl_device.h
index 3c3702c..c0626e7 100644
--- a/drivers/staging/meilhaus/metempl_device.h
+++ b/drivers/staging/meilhaus/metempl_device.h
@@ -50,7 +50,7 @@ static metempl_version_t metempl_versions[] = {
 	{0},
 };
 
-#define METEMPL_DEVICE_VERSIONS (sizeof(metempl_versions) / sizeof(metempl_version_t) - 1) /**< Returns the number of entries in #metempl_versions. */
+#define METEMPL_DEVICE_VERSIONS (ARRAY_SIZE(metempl_versions) - 1) /**< Returns the number of entries in #metempl_versions. */
 
 /**
  * @brief Returns the index of the device entry in #metempl_versions.
diff --git a/drivers/staging/rtl8187se/r8180_wx.c b/drivers/staging/rtl8187se/r8180_wx.c
index 979ba0b..ffefc25 100644
--- a/drivers/staging/rtl8187se/r8180_wx.c
+++ b/drivers/staging/rtl8187se/r8180_wx.c
@@ -30,7 +30,7 @@
 u32 rtl8180_rates[] = {1000000,2000000,5500000,11000000,
 	6000000,9000000,12000000,18000000,24000000,36000000,48000000,54000000};
 
-#define RATE_COUNT (sizeof(rtl8180_rates)/sizeof(rtl8180_rates[0]))
+#define RATE_COUNT ARRAY_SIZE(rtl8180_rates)
 
 static CHANNEL_LIST DefaultChannelPlan[] = {
 //	{{1,2,3,4,5,6,7,8,9,10,11,12,13,14},14},			//Default channel plan
@@ -1631,9 +1631,9 @@ static struct iw_statistics *r8180_get_wireless_stats(struct net_device *dev)
 
 struct iw_handler_def  r8180_wx_handlers_def={
 	.standard = r8180_wx_handlers,
-	.num_standard = sizeof(r8180_wx_handlers) / sizeof(iw_handler),
+	.num_standard = ARRAY_SIZE(r8180_wx_handlers),
 	.private = r8180_private_handler,
-	.num_private = sizeof(r8180_private_handler) / sizeof(iw_handler),
+	.num_private = ARRAY_SIZE(r8180_private_handler),
  	.num_private_args = sizeof(r8180_private_args) / sizeof(struct iw_priv_args),
 #if WIRELESS_EXT >= 17
 	.get_wireless_stats = r8180_get_wireless_stats,
diff --git a/drivers/staging/rtl8192su/ieee80211/ieee80211_wx.c b/drivers/staging/rtl8192su/ieee80211/ieee80211_wx.c
index ae11e25..b5b9c6c 100644
--- a/drivers/staging/rtl8192su/ieee80211/ieee80211_wx.c
+++ b/drivers/staging/rtl8192su/ieee80211/ieee80211_wx.c
@@ -120,7 +120,7 @@ static inline char *rtl819x_translate_scan(struct ieee80211_device *ieee,
         }
 	/* Add the protocol name */
 	iwe.cmd = SIOCGIWNAME;
-	for(i=0; i<(sizeof(ieee80211_modes)/sizeof(ieee80211_modes[0])); i++) {
+	for(i=0; i<ARRAY_SIZE(ieee80211_modes); i++) {
 		if(network->mode&(1<<i)) {
 			sprintf(pname,ieee80211_modes[i].mode_string,ieee80211_modes[i].mode_size);
 			pname +=ieee80211_modes[i].mode_size;
diff --git a/drivers/staging/rtl8192su/r8192U_wx.c b/drivers/staging/rtl8192su/r8192U_wx.c
index f9eafb1..c3f8148 100644
--- a/drivers/staging/rtl8192su/r8192U_wx.c
+++ b/drivers/staging/rtl8192su/r8192U_wx.c
@@ -1339,9 +1339,9 @@ struct iw_statistics *r8192_get_wireless_stats(struct net_device *dev)
 
 struct iw_handler_def  r8192_wx_handlers_def={
 	.standard = r8192_wx_handlers,
-	.num_standard = sizeof(r8192_wx_handlers) / sizeof(iw_handler),
+	.num_standard = ARRAY_SIZE(r8192_wx_handlers),
 	.private = r8192_private_handler,
-	.num_private = sizeof(r8192_private_handler) / sizeof(iw_handler),
+	.num_private = ARRAY_SIZE(r8192_private_handler),
  	.num_private_args = sizeof(r8192_private_args) / sizeof(struct iw_priv_args),
 #if WIRELESS_EXT >= 17
 	.get_wireless_stats = r8192_get_wireless_stats,
diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index ed47db5..582835c 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -1306,7 +1306,7 @@ static void slic_mcast_init_crc32(void)
 
 	static int p[] = { 0, 1, 2, 4, 5, 7, 8, 10, 11, 12, 16, 22, 23, 26 };
 
-	for (i = 0; i < sizeof(p) / sizeof(int); i++)
+	for (i = 0; i < ARRAY_SIZE(p); i++)
 		e |= 1L << (31 - p[i]);
 
 	for (i = 1; i < 256; i++) {
diff --git a/drivers/staging/sxg/sxg.c b/drivers/staging/sxg/sxg.c
index 3a0dac9..395e876 100644
--- a/drivers/staging/sxg/sxg.c
+++ b/drivers/staging/sxg/sxg.c
@@ -3500,7 +3500,7 @@ static void sxg_mcast_init_crc32(void)
 
 	static int p[] = { 0, 1, 2, 4, 5, 7, 8, 10, 11, 12, 16, 22, 23, 26 };
 
-	for (i = 0; i < sizeof(p) / sizeof(int); i++) {
+	for (i = 0; i < ARRAY_SIZE(p); i++) {
 		e |= 1L << (31 - p[i]);
 	}
 
-- 
1.6.3.3

