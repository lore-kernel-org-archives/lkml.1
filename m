Return-Path: <linux-kernel-owner+w=401wt.eu-S933250AbXBEUTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933250AbXBEUTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 15:19:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933303AbXBEUTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 15:19:53 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2600 "EHLO Perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933298AbXBEUTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 15:19:51 -0500
X-Greylist: delayed 3795 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Feb 2007 15:19:49 EST
Subject: [PATCH] - pci_ids.h cleanup and use some PCI_VENDOR_ID_xxx
	#defines in drivers/
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: alan@redhat.com, Tom Tucker <tom@opengridcomputing.com>,
       Patrick Boettcher <patrick.boettcher@desy.de>,
       Jonathan Corbet <corbet@lwn.net>, "Amit S. Kale" <amitkale@netxen.com>,
       Francois Romieu <romieu@fr.zoreil.com>, linux@highpoint-tech.com
Content-Type: text/plain
Date: Mon, 05 Feb 2007 11:16:35 -0800
Message-Id: <1170702996.32122.27.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0-1mdv2007.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup, reorder, add, and use some PCI_VENDOR_ID_xxx defines

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 3d1d210..173666e 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -130,6 +130,9 @@
 
 /* Vendors and devices.  Sort key: vendor first, device next. */
 
+#define PCI_VENDOR_ID_TTTECH		0x0357
+#define PCI_DEVICE_ID_TTTECH_MC322	0x000A
+
 #define PCI_VENDOR_ID_DYNALINK		0x0675
 #define PCI_DEVICE_ID_DYNALINK_IS64PH	0x1702
 
@@ -725,7 +728,6 @@
 #define PCI_DEVICE_ID_ELSA_MICROLINK	0x1000
 #define PCI_DEVICE_ID_ELSA_QS3000	0x3000
 
-
 #define PCI_VENDOR_ID_BUSLOGIC		      0x104B
 #define PCI_DEVICE_ID_BUSLOGIC_MULTIMASTER_NC 0x0140
 #define PCI_DEVICE_ID_BUSLOGIC_MULTIMASTER    0x1040
@@ -768,7 +770,6 @@
 
 #define PCI_VENDOR_ID_SONY		0x104d
 
-
 /* Winbond have two vendor IDs! See 0x10ad as well */
 #define PCI_VENDOR_ID_WINBOND2		0x1050
 #define PCI_DEVICE_ID_WINBOND2_89C940F	0x5a5a
@@ -806,13 +807,11 @@
 #define PCI_DEVICE_ID_PROMISE_20276	0x5275
 #define PCI_DEVICE_ID_PROMISE_20277	0x7275
 
-
 #define PCI_VENDOR_ID_UMC		0x1060
 #define PCI_DEVICE_ID_UMC_UM8673F	0x0101
 #define PCI_DEVICE_ID_UMC_UM8886BF	0x673a
 #define PCI_DEVICE_ID_UMC_UM8886A	0x886a
 
-
 #define PCI_VENDOR_ID_MYLEX		0x1069
 #define PCI_DEVICE_ID_MYLEX_DAC960_P	0x0001
 #define PCI_DEVICE_ID_MYLEX_DAC960_PD	0x0002
@@ -822,7 +821,6 @@
 #define PCI_DEVICE_ID_MYLEX_DAC960_BA	0xBA56
 #define PCI_DEVICE_ID_MYLEX_DAC960_GEM	0xB166
 
-
 #define PCI_VENDOR_ID_APPLE		0x106b
 #define PCI_DEVICE_ID_APPLE_BANDIT	0x0001
 #define PCI_DEVICE_ID_APPLE_HYDRA	0x000e
@@ -858,7 +856,6 @@
 #define PCI_DEVICE_ID_YAMAHA_744	0x0010
 #define PCI_DEVICE_ID_YAMAHA_754	0x0012
 
-
 #define PCI_VENDOR_ID_QLOGIC		0x1077
 #define PCI_DEVICE_ID_QLOGIC_ISP10160	0x1016
 #define PCI_DEVICE_ID_QLOGIC_ISP1020	0x1020
@@ -889,12 +886,9 @@
 #define PCI_DEVICE_ID_CYRIX_5530_AUDIO	0x0103
 #define PCI_DEVICE_ID_CYRIX_5530_VIDEO	0x0104
 
-
-
 #define PCI_VENDOR_ID_CONTAQ		0x1080
 #define PCI_DEVICE_ID_CONTAQ_82C693	0xc693
 
-
 #define PCI_VENDOR_ID_OLICOM		0x108d
 #define PCI_DEVICE_ID_OLICOM_OC2325	0x0012
 #define PCI_DEVICE_ID_OLICOM_OC2183	0x0013
@@ -926,23 +920,19 @@
 #define PCI_DEVICE_ID_SII_3112		0x3112
 #define PCI_DEVICE_ID_SII_1210SA	0x0240
 
-
 #define PCI_VENDOR_ID_BROOKTREE		0x109e
 #define PCI_DEVICE_ID_BROOKTREE_878	0x0878
 #define PCI_DEVICE_ID_BROOKTREE_879	0x0879
 
-
 #define PCI_VENDOR_ID_SGI		0x10a9
 #define PCI_DEVICE_ID_SGI_IOC3		0x0003
 #define PCI_DEVICE_ID_SGI_IOC4		0x100a
 #define PCI_VENDOR_ID_SGI_LITHIUM	0x1002
 
-
 #define PCI_VENDOR_ID_WINBOND		0x10ad
 #define PCI_DEVICE_ID_WINBOND_82C105	0x0105
 #define PCI_DEVICE_ID_WINBOND_83C553	0x0565
 
-
 #define PCI_VENDOR_ID_PLX		0x10b5
 #define PCI_DEVICE_ID_PLX_R685		0x1030
 #define PCI_DEVICE_ID_PLX_ROMULUS	0x106a
@@ -975,7 +965,6 @@
 #define PCI_DEVICE_ID_3COM_3CR990SVR97	0x9909
 #define PCI_DEVICE_ID_3COM_3CR990SVR	0x990a
 
-
 #define PCI_VENDOR_ID_AL		0x10b9
 #define PCI_DEVICE_ID_AL_M1533		0x1533
 #define PCI_DEVICE_ID_AL_M1535 		0x1535
@@ -998,18 +987,14 @@
 #define PCI_DEVICE_ID_AL_M5451		0x5451
 #define PCI_DEVICE_ID_AL_M7101		0x7101
 
-
-
 #define PCI_VENDOR_ID_NEOMAGIC		0x10c8
 #define PCI_DEVICE_ID_NEOMAGIC_NM256AV_AUDIO 0x8005
 #define PCI_DEVICE_ID_NEOMAGIC_NM256ZX_AUDIO 0x8006
 #define PCI_DEVICE_ID_NEOMAGIC_NM256XL_PLUS_AUDIO 0x8016
 
-
 #define PCI_VENDOR_ID_TCONRAD		0x10da
 #define PCI_DEVICE_ID_TCONRAD_TOKENRING	0x0508
 
-
 #define PCI_VENDOR_ID_NVIDIA			0x10de
 #define PCI_DEVICE_ID_NVIDIA_TNT		0x0020
 #define PCI_DEVICE_ID_NVIDIA_TNT2		0x0028
@@ -1226,9 +1211,6 @@
 #define PCI_DEVICE_ID_IMS_TT128		0x9128
 #define PCI_DEVICE_ID_IMS_TT3D		0x9135
 
-
-
-
 #define PCI_VENDOR_ID_INTERG		0x10ea
 #define PCI_DEVICE_ID_INTERG_1682	0x1682
 #define PCI_DEVICE_ID_INTERG_2000	0x2000
@@ -1247,7 +1229,6 @@
 #define PCI_DEVICE_ID_XILINX_HAMMERFALL_DSP 0x3fc5
 #define PCI_DEVICE_ID_XILINX_HAMMERFALL_DSP_MADI 0x3fc6
 
-
 #define PCI_VENDOR_ID_INIT		0x1101
 
 #define PCI_VENDOR_ID_CREATIVE		0x1102 /* duplicate: ECTIVA */
@@ -1264,7 +1245,6 @@
 #define PCI_DEVICE_ID_TTI_HPT371	0x0007
 #define PCI_DEVICE_ID_TTI_HPT374	0x0008
 #define PCI_DEVICE_ID_TTI_HPT372N	0x0009	/* apparently a 372N variant? */
-
 #define PCI_VENDOR_ID_VIA		0x1106
 #define PCI_DEVICE_ID_VIA_8763_0	0x0198
 #define PCI_DEVICE_ID_VIA_8380_0	0x0204
@@ -1340,7 +1320,6 @@
 #define PCI_VENDOR_ID_SIEMENS           0x110A
 #define PCI_DEVICE_ID_SIEMENS_DSCC4     0x2102
 
-
 #define PCI_VENDOR_ID_VORTEX		0x1119
 #define PCI_DEVICE_ID_VORTEX_GDT60x0	0x0000
 #define PCI_DEVICE_ID_VORTEX_GDT6000B	0x0001
@@ -1375,7 +1354,6 @@
 #define PCI_VENDOR_ID_FORE		0x1127
 #define PCI_DEVICE_ID_FORE_PCA200E	0x0300
 
-
 #define PCI_VENDOR_ID_PHILIPS		0x1131
 #define PCI_DEVICE_ID_PHILIPS_SAA7146	0x7146
 #define PCI_DEVICE_ID_PHILIPS_SAA9730	0x9730
@@ -1393,8 +1371,6 @@
 #define PCI_VENDOR_ID_ZIATECH		0x1138
 #define PCI_DEVICE_ID_ZIATECH_5550_HC	0x5550
  
-
-
 #define PCI_VENDOR_ID_SYSKONNECT	0x1148
 #define PCI_DEVICE_ID_SYSKONNECT_TR	0x4200
 #define PCI_DEVICE_ID_SYSKONNECT_GE	0x4300
@@ -1402,7 +1378,6 @@
 #define PCI_DEVICE_ID_SYSKONNECT_9DXX	0x4400
 #define PCI_DEVICE_ID_SYSKONNECT_9MXX	0x4500
 
-
 #define PCI_VENDOR_ID_DIGI		0x114f
 #define PCI_DEVICE_ID_DIGI_DF_M_IOM2_E	0x0070
 #define PCI_DEVICE_ID_DIGI_DF_M_E	0x0071
@@ -1413,12 +1388,10 @@
 #define PCI_DEVICE_ID_NEO_2RJ45         0x00CA
 #define PCI_DEVICE_ID_NEO_2RJ45PRI      0x00CB
 
-
 #define PCI_VENDOR_ID_XIRCOM		0x115d
 #define PCI_DEVICE_ID_XIRCOM_RBM56G	0x0101
 #define PCI_DEVICE_ID_XIRCOM_X3201_MDM	0x0103
 
-
 #define PCI_VENDOR_ID_SERVERWORKS	  0x1166
 #define PCI_DEVICE_ID_SERVERWORKS_HE	  0x0008
 #define PCI_DEVICE_ID_SERVERWORKS_LE	  0x0009
@@ -1483,7 +1456,6 @@
 #define PCI_DEVICE_ID_ZEITNET_1221	0x0001
 #define PCI_DEVICE_ID_ZEITNET_1225	0x0002
 
-
 #define PCI_VENDOR_ID_FUJITSU_ME	0x119e
 #define PCI_DEVICE_ID_FUJITSU_FS155	0x0001
 #define PCI_DEVICE_ID_FUJITSU_FS50	0x0003
@@ -1501,28 +1473,23 @@
 #define PCI_DEVICE_ID_V3_V960		0x0001
 #define PCI_DEVICE_ID_V3_V351		0x0002
 
-
 #define PCI_VENDOR_ID_ATT		0x11c1
 #define PCI_DEVICE_ID_ATT_VENUS_MODEM	0x480
 
-
 #define PCI_VENDOR_ID_SPECIALIX		0x11cb
 #define PCI_DEVICE_ID_SPECIALIX_IO8	0x2000
 #define PCI_DEVICE_ID_SPECIALIX_RIO	0x8000
 #define PCI_SUBDEVICE_ID_SPECIALIX_SPEED4 0xa004
 
-
 #define PCI_VENDOR_ID_ANALOG_DEVICES	0x11d4
 #define PCI_DEVICE_ID_AD1889JS		0x1889
 
-
 #define PCI_DEVICE_ID_SEGA_BBA		0x1234
 
 #define PCI_VENDOR_ID_ZORAN		0x11de
 #define PCI_DEVICE_ID_ZORAN_36057	0x6057
 #define PCI_DEVICE_ID_ZORAN_36120	0x6120
 
-
 #define PCI_VENDOR_ID_COMPEX		0x11f6
 #define PCI_DEVICE_ID_COMPEX_ENET100VG4	0x0112
 
@@ -1581,8 +1548,6 @@
 #define PCI_DEVICE_ID_3DFX_VOODOO3	0x0005
 #define PCI_DEVICE_ID_3DFX_VOODOO5	0x0009
 
-
-
 #define PCI_VENDOR_ID_AVM		0x1244
 #define PCI_DEVICE_ID_AVM_B1		0x0700
 #define PCI_DEVICE_ID_AVM_C4		0x0800
@@ -1591,7 +1556,6 @@
 #define PCI_DEVICE_ID_AVM_C2		0x1100
 #define PCI_DEVICE_ID_AVM_T1		0x1200
 
-
 #define PCI_VENDOR_ID_STALLION		0x124d
 
 /* Allied Telesyn */
@@ -1614,7 +1578,6 @@
 #define PCI_VENDOR_ID_SATSAGEM		0x1267
 #define PCI_DEVICE_ID_SATSAGEM_NICCY	0x1016
 
-
 #define PCI_VENDOR_ID_ENSONIQ		0x1274
 #define PCI_DEVICE_ID_ENSONIQ_CT5880	0x5880
 #define PCI_DEVICE_ID_ENSONIQ_ES1370	0x5000
@@ -1636,7 +1599,6 @@
 
 #define PCI_VENDOR_ID_ALTEON		0x12ae
 
-
 #define PCI_SUBVENDOR_ID_CONNECT_TECH			0x12c4
 #define PCI_SUBDEVICE_ID_CONNECT_TECH_BH8_232		0x0001
 #define PCI_SUBDEVICE_ID_CONNECT_TECH_BH4_232		0x0002
@@ -1667,7 +1629,6 @@
 #define PCI_SUBDEVICE_ID_CONNECT_TECH_PCI_UART_4_485	0x0331
 #define PCI_SUBDEVICE_ID_CONNECT_TECH_PCI_UART_8_485	0x0332
 
-
 #define PCI_VENDOR_ID_NVIDIA_SGS	0x12d2
 #define PCI_DEVICE_ID_NVIDIA_SGS_RIVA128 0x0018
 
@@ -1688,7 +1649,6 @@
 #define PCI_VENDOR_ID_ELECTRONICDESIGNGMBH 0x12f8
 #define PCI_DEVICE_ID_LML_33R10		0x8a02
 
-
 #define PCI_VENDOR_ID_SIIG		0x131f
 #define PCI_SUBVENDOR_ID_SIIG		0x131f
 #define PCI_DEVICE_ID_SIIG_1S_10x_550	0x1000
@@ -1775,7 +1735,6 @@
 #define PCI_DEVICE_ID_LMC_SSI		0x0005
 #define PCI_DEVICE_ID_LMC_T1		0x0006
 
-
 #define PCI_VENDOR_ID_NETGEAR		0x1385
 #define PCI_DEVICE_ID_NETGEAR_GA620	0x620a
 
@@ -1835,6 +1794,8 @@
 #define PCI_VENDOR_ID_IOMEGA		0x13ca
 #define PCI_DEVICE_ID_IOMEGA_BUZ	0x4231
 
+#define PCI_VENDOR_ID_B2C2		0x13d0
+
 #define PCI_VENDOR_ID_ABOCOM		0x13D1
 #define PCI_DEVICE_ID_ABOCOM_2BD1       0x2BD1
 
@@ -1875,6 +1836,8 @@
 #define PCI_DEVICE_ID_OXSEMI_16PCI952	0x9521
 #define PCI_DEVICE_ID_OXSEMI_16PCI952PP	0x9523
 
+#define PCI_VENDOR_ID_CHELSIO		0x1425
+
 #define PCI_VENDOR_ID_SAMSUNG		0x144d
 
 #define PCI_VENDOR_ID_MYRICOM		0x14c1
@@ -1980,9 +1943,6 @@
 #define PCI_DEVICE_ID_ENE_720		0x1421
 #define PCI_DEVICE_ID_ENE_722		0x1422
 
-#define PCI_VENDOR_ID_CHELSIO		0x1425
-
-
 #define PCI_VENDOR_ID_SYBA		0x1592
 #define PCI_DEVICE_ID_SYBA_2P_EPP	0x0782
 #define PCI_DEVICE_ID_SYBA_1P_ECP	0x0783
@@ -2001,8 +1961,10 @@
 #define PCI_DEVICE_ID_MELLANOX_SINAI_OLD 0x5e8c
 #define PCI_DEVICE_ID_MELLANOX_SINAI	0x6274
 
-#define PCI_VENDOR_ID_PDC		0x15e9
+#define PCI_VENDOR_ID_QUICKNET		0x15E2
+#define PCI_DEVICE_ID_QUICKNET_XJ	0x0500
 
+#define PCI_VENDOR_ID_PDC		0x15e9
 
 #define PCI_VENDOR_ID_FARSITE           0x1619
 #define PCI_DEVICE_ID_FARSITE_T2P       0x0400
@@ -2022,6 +1984,8 @@
 #define PCI_VENDOR_ID_NETCELL		0x169c
 #define PCI_DEVICE_ID_REVOLUTION	0x0044
 
+#define PCI_VENDOR_ID_USROBOTICS	0x16ec
+
 #define PCI_VENDOR_ID_VITESSE		0x1725
 #define PCI_DEVICE_ID_VITESSE_VSC7174	0x7174
 
@@ -2057,12 +2021,13 @@
 #define PCI_DEVICE_ID_HERC_WIN		0x5732
 #define PCI_DEVICE_ID_HERC_UNI		0x5832
 
-
 #define PCI_VENDOR_ID_SITECOM		0x182d
 #define PCI_DEVICE_ID_SITECOM_DC105V2	0x3069
 
 #define PCI_VENDOR_ID_TOPSPIN		0x1867
 
+#define PCI_VENDOR_ID_AMMASSO		0x18b8
+
 #define PCI_VENDOR_ID_TDI               0x192E
 #define PCI_DEVICE_ID_TDI_EHCI          0x0101
 
@@ -2088,12 +2053,11 @@
 #define PCI_DEVICE_ID_3DLABS_PERMEDIA2	0x0007
 #define PCI_DEVICE_ID_3DLABS_PERMEDIA2V	0x0009
 
+#define PCI_VENDOR_ID_NETXEN		0x4040
 
 #define PCI_VENDOR_ID_AKS		0x416c
 #define PCI_DEVICE_ID_AKS_ALADDINCARD	0x0100
 
-
-
 #define PCI_VENDOR_ID_S3		0x5333
 #define PCI_DEVICE_ID_S3_TRIO		0x8811
 #define PCI_DEVICE_ID_S3_868		0x8880
@@ -2105,7 +2069,6 @@
 #define PCI_VENDOR_ID_DUNORD		0x5544
 #define PCI_DEVICE_ID_DUNORD_I3000	0x0001
 
-
 #define PCI_VENDOR_ID_DCI		0x6666
 #define PCI_DEVICE_ID_DCI_PCCOM4	0x0001
 #define PCI_DEVICE_ID_DCI_PCCOM8	0x0002
@@ -2349,7 +2312,6 @@
 #define PCI_DEVICE_ID_ADAPTEC2_OBSIDIAN   0x0500
 #define PCI_DEVICE_ID_ADAPTEC2_SCAMP	0x0503
 
-
 #define PCI_VENDOR_ID_HOLTEK		0x9412
 #define PCI_DEVICE_ID_HOLTEK_6565	0x6565
 
@@ -2373,13 +2335,7 @@
 #define PCI_DEVICE_ID_TIGERJET_300	0x0001
 #define PCI_DEVICE_ID_TIGERJET_100	0x0002
 
-#define PCI_VENDOR_ID_TTTECH		0x0357
-#define PCI_DEVICE_ID_TTTECH_MC322	0x000A
-
 #define PCI_VENDOR_ID_XILINX_RME	0xea60
 #define PCI_DEVICE_ID_RME_DIGI32	0x9896
 #define PCI_DEVICE_ID_RME_DIGI32_PRO	0x9897
 #define PCI_DEVICE_ID_RME_DIGI32_8	0x9898
-
-#define PCI_VENDOR_ID_QUICKNET		0x15E2
-#define PCI_DEVICE_ID_QUICKNET_XJ	0x0500
diff --git a/drivers/ata/pata_marvell.c b/drivers/ata/pata_marvell.c
index 1c810ea..dfc0eaf 100644
--- a/drivers/ata/pata_marvell.c
+++ b/drivers/ata/pata_marvell.c
@@ -189,8 +189,8 @@ static int marvell_init_one (struct pci_
 }
 
 static const struct pci_device_id marvell_pci_tbl[] = {
-	{ PCI_DEVICE(0x11AB, 0x6101), },
-	{ PCI_DEVICE(0x11AB, 0x6145), },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x6101), },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x6145), },
 	{ }	/* terminate list */
 };
 
diff --git a/drivers/infiniband/hw/amso1100/c2.c b/drivers/infiniband/hw/amso1100/c2.c
index 27fe242..7fc81cf 100644
--- a/drivers/infiniband/hw/amso1100/c2.c
+++ b/drivers/infiniband/hw/amso1100/c2.c
@@ -79,7 +79,7 @@ static void c2_reset(struct c2_port *c2_
 static struct net_device_stats *c2_get_stats(struct net_device *netdev);
 
 static struct pci_device_id c2_pci_table[] = {
-	{ PCI_DEVICE(0x18b8, 0xb001) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMMASSO, 0xb001) },
 	{ 0 }
 };
 
diff --git a/drivers/media/dvb/b2c2/flexcop-pci.c b/drivers/media/dvb/b2c2/flexcop-pci.c
index 6e16680..7b51c04 100644
--- a/drivers/media/dvb/b2c2/flexcop-pci.c
+++ b/drivers/media/dvb/b2c2/flexcop-pci.c
@@ -399,8 +399,8 @@ static void flexcop_pci_remove(struct pc
 }
 
 static struct pci_device_id flexcop_pci_tbl[] = {
-	{ PCI_DEVICE(0x13d0, 0x2103) },
-/*	{ PCI_DEVICE(0x13d0, 0x2200) }, ? */
+	{ PCI_DEVICE(PCI_VENDOR_ID_B2C2, 0x2103) },
+/*	{ PCI_DEVICE(PCI_VENDOR_ID_B2C2, 0x2200) }, ? */
 	{ },
 };
 
diff --git a/drivers/media/video/cafe_ccic.c b/drivers/media/video/cafe_ccic.c
index 3083c80..8dbb75e 100644
--- a/drivers/media/video/cafe_ccic.c
+++ b/drivers/media/video/cafe_ccic.c
@@ -2180,9 +2180,9 @@ static void cafe_pci_remove(struct pci_d
 

 static struct pci_device_id cafe_ids[] = {
-	{ PCI_DEVICE(0x1148, 0x4340) }, /* Temporary ID on devel board */
-	{ PCI_DEVICE(0x11ab, 0x4100) }, /* Eventual real ID */
-	{ PCI_DEVICE(0x11ab, 0x4102) }, /* Really eventual real ID */
+	{ PCI_DEVICE(PCI_VENDOR_ID_SYSKONNECT, 0x4340) }, /* Temporary ID on devel board */
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x4100) }, /* Eventual real ID */
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x4102) }, /* Really eventual real ID */
 	{ 0, }
 };
 
diff --git a/drivers/net/netxen/netxen_nic_main.c b/drivers/net/netxen/netxen_nic_main.c
index 69c1b9d..2936a18 100644
--- a/drivers/net/netxen/netxen_nic_main.c
+++ b/drivers/net/netxen/netxen_nic_main.c
@@ -42,8 +42,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/vmalloc.h>
 
-#define PHAN_VENDOR_ID 0x4040
-
 MODULE_DESCRIPTION("NetXen Multi port (1/10) Gigabit Network Driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(NETXEN_NIC_LINUX_VERSIONID);
@@ -80,13 +78,13 @@ static irqreturn_t netxen_intr(int irq, 
 
 /*  PCI Device ID Table  */
 static struct pci_device_id netxen_pci_tbl[] __devinitdata = {
-	{PCI_DEVICE(0x4040, 0x0001)},
-	{PCI_DEVICE(0x4040, 0x0002)},
-	{PCI_DEVICE(0x4040, 0x0003)},
-	{PCI_DEVICE(0x4040, 0x0004)},
-	{PCI_DEVICE(0x4040, 0x0005)},
-	{PCI_DEVICE(0x4040, 0x0024)},
-	{PCI_DEVICE(0x4040, 0x0025)},
+	{PCI_DEVICE(PCI_VENDOR_ID_NETXEN, 0x0001)},
+	{PCI_DEVICE(PCI_VENDOR_ID_NETXEN, 0x0002)},
+	{PCI_DEVICE(PCI_VENDOR_ID_NETXEN, 0x0003)},
+	{PCI_DEVICE(PCI_VENDOR_ID_NETXEN, 0x0004)},
+	{PCI_DEVICE(PCI_VENDOR_ID_NETXEN, 0x0005)},
+	{PCI_DEVICE(PCI_VENDOR_ID_NETXEN, 0x0024)},
+	{PCI_DEVICE(PCI_VENDOR_ID_NETXEN, 0x0025)},
 	{0,}
 };
 
diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index 577babd..c5cd765 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -214,8 +214,8 @@ static struct pci_device_id rtl8169_pci_
 	{ PCI_DEVICE(PCI_VENDOR_ID_REALTEK,	0x8168), 0, 0, RTL_CFG_2 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_REALTEK,	0x8169), 0, 0, RTL_CFG_0 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_DLINK,	0x4300), 0, 0, RTL_CFG_0 },
-	{ PCI_DEVICE(0x1259,			0xc107), 0, 0, RTL_CFG_0 },
-	{ PCI_DEVICE(0x16ec,			0x0116), 0, 0, RTL_CFG_0 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AT,		0xc107), 0, 0, RTL_CFG_0 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_USROBOTICS,	0x0116), 0, 0, RTL_CFG_0 },
 	{ PCI_VENDOR_ID_LINKSYS,		0x1032,
 		PCI_ANY_ID, 0x0024, 0, 0, RTL_CFG_0 },
 	{0,},
diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index bec83cb..5e0b831 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -909,8 +909,8 @@ static void hptiop_remove(struct pci_dev
 }
 
 static struct pci_device_id hptiop_id_table[] = {
-	{ PCI_DEVICE(0x1103, 0x3220) },
-	{ PCI_DEVICE(0x1103, 0x3320) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_TTI, 0x3220) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_TTI, 0x3320) },
 	{},
 };
 


