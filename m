Return-Path: <linux-kernel-owner+w=401wt.eu-S1759529AbZLJKAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759529AbZLJKAN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 05:00:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758055AbZLJKAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 05:00:09 -0500
Received: from smtp12.hibox.hinet.net ([210.71.187.237]:10150 "EHLO
	smtp12.hibox.hinet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985AbZLJKAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 05:00:08 -0500
X-Greylist: delayed 658 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Dec 2009 05:00:07 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApUGANtSIEusEjwV/2dsb2JhbACaSYIbuQaBd4I1BIJ9
X-IronPort-AV: E=Sophos;i="4.47,374,1257091200"; 
   d="scan'208";a="30167147"
Message-Id: <81g07q$fe36t@hb2-smtpclt02.hibox.hinet.net>
X-SBRS: -4.3
X-Remote-IP: 60.251.55.124
X-Remote-Host: 60-251-55-124.hinet-ip.hinet.net
X-Auth-ID: kiros@korenix.com
X-EnvelopeFrom: kiros@korenix.com
X-MID: 16190685
X-IronPort-AV: E=Sophos;i="4.47,374,1257091200"; 
   d="scan'208";a="16190685"
From: "kiros" <kiros@korenix.com>
To: <linux-serial@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] serial: add support for Korenix JetCard
Date: Thu, 10 Dec 2009 17:49:07 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook, Build 11.0.5510
Thread-index: Acp5fgMIOSGkwa7ST/6C+jwPom85pA==
X-MIMEOLE: Produced By Microsoft MimeOLE V6.00.2900.2180
X-Antivirus: avast! (VPS 090119-0, 2009/01/19), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add different model (with a different PCI ID) to support Korenix JetCard.
 
Signed-off-by: Kiros Yeh <kiros@www.korenix.com>
---

diff -uprN a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
--- a/drivers/serial/8250_pci.c	2009-12-03 11:51:21.000000000 +0800
+++ b/drivers/serial/8250_pci.c	2009-12-10 16:01:14.000000000 +0800
@@ -3191,6 +3191,15 @@ static struct pci_device_id serial_pci_t
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
diff -uprN a/include/linux/pci_ids.h b/include/linux/pci_ids.h
--- a/include/linux/pci_ids.h	2009-12-03 11:51:21.000000000 +0800
+++ b/include/linux/pci_ids.h	2009-12-10 16:00:40.000000000 +0800
@@ -2314,6 +2314,8 @@
 #define PCI_VENDOR_ID_KORENIX		0x1982
 #define PCI_DEVICE_ID_KORENIX_JETCARDF0	0x1600
 #define PCI_DEVICE_ID_KORENIX_JETCARDF1	0x16ff
+#define PCI_DEVICE_ID_KORENIX_JETCARDF2	0x1700
+#define PCI_DEVICE_ID_KORENIX_JETCARDF3	0x17ff
 
 #define PCI_VENDOR_ID_QMI		0x1a32


