Return-Path: <linux-kernel-owner+w=401wt.eu-S1756038AbXKYDYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038AbXKYDYe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 22:24:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753967AbXKYDY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 22:24:27 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:35931 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528AbXKYDY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 22:24:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=e0Gl0lck3Q1SRjR7pqWconSs6qscaJHuH/ly+FAgSANGWtAxfFfHmsyCyaN8yOVxsyZ71fhddQYB36XBerdxqc1J1zhV50RG3ghiM7JEcK/VSiXNWKY5O4Vn53J503sRqoSF01IC+jaFo3/5dKRc2KttZajPaPlxd3fQtJ6VszY=
Date: Sun, 25 Nov 2007 11:24:22 +0800
From: "peerchen" <peerchen@gmail.com>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Cc: "akpm" <akpm@linux-foundation.org>, "pchen" <pchen@nvidia.com>,
       "acurrid" <acurrid@nvidia.com>
Subject: [PATCH 2/2] msi: set 'En' bit of MSI Mapping Capability on HT platform
Message-ID: <200711251124187655098@gmail.com>
X-mailer: Foxmail 6, 6, 105, 21 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

According to the HyperTransport spec, 'En' indicate if the MSI Mapping is active. So it should be set when enable the MSI.

The patch base on kernel 2.6.24-rc3

Signed-off-by: Andy Currid <acurrid@nvidia.com>
Signed-off-by: Peer Chen <pchen@nvidia.com>

---
--- linux-2.6.24-rc3/include/linux/pci_ids.h.orig	2007-11-23 17:50:30.000000000 -0500
+++ linux-2.6.24-rc3/include/linux/pci_ids.h	2007-11-23 17:50:42.000000000 -0500
@@ -1153,7 +1153,16 @@
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_IDE	0x0265
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_SATA	0x0266
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_SATA2	0x0267
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_C51_MEMC0   0x02F0
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_C51_MEMC1   0x02F1
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_C51_MEMC2   0x02F2
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_C51_MEMC3   0x02F3
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_C51_MEMC4   0x02F4
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_C51_MEMC5   0x02F5
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_C51_MEMC6   0x02F6
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_C51_MEMC7   0x02F7
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SMBUS	0x0368
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_MEMC	0x0369
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_IDE	0x036E
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SATA	0x037E
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SATA2	0x037F
-

