Return-Path: <linux-kernel-owner+w=401wt.eu-S1753941AbXDYDTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbXDYDTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 23:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161554AbXDYDTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 23:19:00 -0400
Received: from hqemgate02.nvidia.com ([216.228.112.143]:14776 "EHLO
	HQEMGATE02.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729AbXDYDS7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 23:18:59 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] drivers/ata: remove the wildcard from sata_nv driver
Date: Wed, 25 Apr 2007 11:17:21 +0800
Message-ID: <15F501D1A78BD343BE8F4D8DB854566B130750AC@hkemmail01.nvidia.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] drivers/ata: remove the wildcard from sata_nv driver
Thread-Index: AceG6D0Tetcau3dbTAmrrvJgzxR49A==
From: "Peer Chen" <pchen@nvidia.com>
To: <linux-kernel@vger.kernel.org>
Cc: <akpm@osdl.org>, <jgarzik@pobox.com>, <torvalds@osdl.org>
X-OriginalArrivalTime: 25 Apr 2007 03:18:46.0860 (UTC) FILETIME=[6FBDE8C0:01C786E8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Because nvidia SATA controllers onward base on AHCI, so wildcard in
sata_nv driver is unnecessary.
Also the wildcard sometimes cause sata_nv driver to be loaded for AHCI
controllers,which is not as expected.

Signed-off-by: Peer Chen <pchen@nvidia.com>

=================

--- linux-2.6.21-rc7/drivers/ata/sata_nv.c.orig
+++ linux-2.6.21-rc7/drivers/ata/sata_nv.c
@@ -285,12 +285,6 @@ static const struct pci_device_id nv_pci
 	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA),
GENERIC },
 	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA2),
GENERIC },
 	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA3),
GENERIC },
-	{ PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
-		PCI_ANY_ID, PCI_ANY_ID,
-		PCI_CLASS_STORAGE_IDE<<8, 0xffff00, GENERIC },
-	{ PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
-		PCI_ANY_ID, PCI_ANY_ID,
-		PCI_CLASS_STORAGE_RAID<<8, 0xffff00, GENERIC },
 
 	{ } /* terminate list */
 };
-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
