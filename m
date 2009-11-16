Return-Path: <linux-kernel-owner+w=401wt.eu-S1752454AbZKPDWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbZKPDWk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 22:22:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751622AbZKPDWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 22:22:39 -0500
Received: from mail.windriver.com ([147.11.1.11]:40676 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbZKPDWi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 22:22:38 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH 1/2] Uart driver for ST Microelectronics ConneXt(STA2X11/STA2X10).
Date: Mon, 16 Nov 2009 04:22:31 +0100
Message-ID: <52CF90264091A14888078A031D780F4302F89334@ism-mail03.corp.ad.wrs.com>
In-Reply-To: <52CF90264091A14888078A031D780F436EF0F9@ism-mail03.corp.ad.wrs.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/2] Uart driver for ST Microelectronics ConneXt(STA2X11/STA2X10).
thread-index: AcpkXLAL7xF8u0X1RPy9hmnV/QIeyACDe+yg
References: <52CF90264091A14888078A031D780F436EF0F9@ism-mail03.corp.ad.wrs.com>
From: "Feng, Xiaobing" <Xiaobing.Feng@windriver.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-serial@vger.kernel.org>, <linux-pci@vger.kernel.org>,
       <giancarlo.asnaghi@st.com>,
       "Wallin, Anders" <Anders.Wallin@windriver.com>,
       "D'Agostino, Raffaele" <raffaele.dagostino@windriver.com>,
       "Li, Li" <Li.Li@windriver.com>
X-OriginalArrivalTime: 16 Nov 2009 03:22:35.0635 (UTC) FILETIME=[0AC03430:01CA666C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi
	The  patch add VENDOR ID and DEVICE ID for all components on ST
Microelectronics ConneXt board. It will be required by all drivers of
ConneXt which will submit in the future monthes.
  
ST Microelectronics ConneXt(STA2X11/STA2X10), a PCI express
multifunction chip that provides Input/Output capabilities.

  	 This patch has been checked by scripts/checkpatch.pl .



>From 562dced056963d0dae2cc17263a995acf51d3b01 Mon Sep 17 00:00:00 2001
From: Billy <billy@billy-laptop.(none)>
Date: Fri, 13 Nov 2009 18:07:26 +0800
Subject: [PATCH] Add VENDOR ID and DEVICE ID for STMICRO's ConneXt board
to include/linux/pci_ids.h

Signed-off-by: XiaoBing Feng (Billy Feng) <xiaobing.feng@windriver.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
---
 include/linux/pci_ids.h |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h index
73b46b6..ff7b0ba 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2664,3 +2664,26 @@
 #define PCI_DEVICE_ID_RME_DIGI32       0x9896
 #define PCI_DEVICE_ID_RME_DIGI32_PRO   0x9897
 #define PCI_DEVICE_ID_RME_DIGI32_8     0x9898
+
+#define PCI_VENDOR_ID_STMICRO                  0x1862
+#define PCI_DEVICE_ID_STMICRO_USB_HOST         0xCC00
+#define PCI_DEVICE_ID_STMICRO_USB_OHCI         0xCC01
+#define PCI_DEVICE_ID_STMICRO_USB_OTG          0xCC02
+#define PCI_DEVICE_ID_STMICRO_UART_HWFC                0xCC03
+#define PCI_DEVICE_ID_STMICRO_UART_NO_HWFC     0xCC04
+#define PCI_DEVICE_ID_STMICRO_SOC_DMA          0xCC05
+#define PCI_DEVICE_ID_STMICRO_SATAII           0xCC06
+#define PCI_DEVICE_ID_STMICRO_I2C              0xCC07
+#define PCI_DEVICE_ID_STMICRO_SPI_HS           0xCC08
+#define PCI_DEVICE_ID_STMICRO_MAC              0xCC09
+#define PCI_DEVICE_ID_STMICRO_SDIO_EMMC                0xCC0A
+#define PCI_DEVICE_ID_STMICRO_SDIO             0xCC0B
+#define PCI_DEVICE_ID_STMICRO_GPIO             0xCC0C
+#define PCI_DEVICE_ID_STMICRO_ESRAM            0xCC0D
+#define PCI_DEVICE_ID_STMICRO_AUDIO_ROUTER_DMA 0xCC0E
+#define PCI_DEVICE_ID_STMICRO_AUDIO_ROUTER_SRCS        0xCC0F
+#define PCI_DEVICE_ID_STMICRO_AUDIO_ROUTER_MSPS        0xCC10
+#define PCI_DEVICE_ID_STMICRO_CAN              0xCC11
+#define PCI_DEVICE_ID_STMICRO_MLB              0xCC12
+#define PCI_DEVICE_ID_STMICRO_DBP              0xCC13
+#define PCI_DEVICE_ID_STMICRO_VIP              0xCC14
--
1.6.0.4
 

