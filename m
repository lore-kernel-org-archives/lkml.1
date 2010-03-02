Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab0CBXwD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:52:03 -0500
Received: from kroah.org ([198.145.64.141]:51565 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754818Ab0CBXgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:36:51 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kiros Yeh <kiros@korenix.com>, Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 08/36] serial: add support for Korenix JetCard
Date: Tue,  2 Mar 2010 15:36:15 -0800
Message-Id: <1267573003-782-8-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230956.GC32287@kroah.com>
References: <20100302230956.GC32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kiros Yeh <kiros@korenix.com>

Add different model (with a different PCI ID) to support Korenix JetCard.

Signed-off-by: Kiros Yeh <kiros@korenix.com>
Acked-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/8250_pci.c |    9 +++++++++
 include/linux/pci_ids.h   |    2 ++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
index 8b18c3c..01c012d 100644
--- a/drivers/serial/8250_pci.c
+++ b/drivers/serial/8250_pci.c
@@ -3199,6 +3199,15 @@ static struct pci_device_id serial_pci_tbl[] = {
 		0x1208, 0x0004, 0, 0,
 		pbn_b0_4_921600 },
 
+	{	PCI_VENDOR_ID_KORENIX, PCI_DEVICE_ID_KORENIX_JETCARDF2,
+		0x1204, 0x0004, 0, 0,
+		pbn_b0_4_921600 },
+	{	PCI_VENDOR_ID_KORENIX, PCI_DEVICE_ID_KORENIX_JETCARDF2,
+		0x1208, 0x0004, 0, 0,
+		pbn_b0_4_921600 },
+	{	PCI_VENDOR_ID_KORENIX, PCI_DEVICE_ID_KORENIX_JETCARDF3,
+		0x1208, 0x0004, 0, 0,
+		pbn_b0_4_921600 },
 	/*
 	 * Dell Remote Access Card 4 - Tim_T_Murphy@Dell.com
 	 */
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 3ec4003..e91b1fc 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2333,6 +2333,8 @@
 #define PCI_VENDOR_ID_KORENIX		0x1982
 #define PCI_DEVICE_ID_KORENIX_JETCARDF0	0x1600
 #define PCI_DEVICE_ID_KORENIX_JETCARDF1	0x16ff
+#define PCI_DEVICE_ID_KORENIX_JETCARDF2	0x1700
+#define PCI_DEVICE_ID_KORENIX_JETCARDF3	0x17ff
 
 #define PCI_VENDOR_ID_QMI		0x1a32
 
-- 
1.7.0.1

