Return-Path: <linux-kernel-owner+w=401wt.eu-S1757961AbXFGK1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961AbXFGK1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 06:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752402AbXFGK1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 06:27:41 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:62159 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbXFGK1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 06:27:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=stGk/WcimrgrcU8d1HD+b2z827PFeZFzyuk/NsV7Vyf/3pK1box0vLy/tDKrLmzqfqsVDYPJyz6KvP2eNDrryPQOkTK0aj5we35aGITiylwCLuX802rHD/ms/9oS3JWex0aS30D2JA2dQFCwLBjtCN8SlShGCFWnnkpjM8BbrrA=
Date: Thu, 7 Jun 2007 18:27:37 +0800
From: "Peer Chen" <peerchen@gmail.com>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Cc: "alan" <alan@redhat.com>, "akpm" <akpm@linux-foundation.org>,
       "jeff" <jeff@garzik.org>, "htejun" <htejun@gmail.com>
Subject: [PATCH 3/3] PATA: Add the MCP73/77 support to PATA driver
Message-ID: <200706071827360318829@gmail.com>
X-mailer: Foxmail 6, 6, 105, 21 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add the PATA controller device ID to pci_ids.h for MCP73/MCP77.
The patch base on kernel 2.6.22-rc4
 
Signed-off-by: Peer Chen <peerchen@gmail.com>
--------------------------------------------------
--- linux-2.6.22-rc4/include/linux/pci_ids.h.orig
+++ linux-2.6.22-rc4/include/linux/pci_ids.h
@@ -1233,6 +1233,8 @@
 #define PCI_DEVICE_ID_NVIDIA_NVENET_26              0x054E
 #define PCI_DEVICE_ID_NVIDIA_NVENET_27              0x054F
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP67_IDE       0x0560
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP73_IDE       0x056C
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP77_IDE       0x0759
 
 #define PCI_VENDOR_ID_IMS		0x10e0
 #define PCI_DEVICE_ID_IMS_TT128		0x9128

