Return-Path: <linux-kernel-owner+w=401wt.eu-S1757492AbXFGKXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492AbXFGKXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 06:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbXFGKXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 06:23:15 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:56899 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbXFGKXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 06:23:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=UeW0UxkeGCpo+AFy0oHJ2epwMPrDIfc/c6fh/T12sVp14NyyDhhjjn5/2eceSncFBQUkN73bJJN0Hk0V5XrBRoNnU2cumS7BMuz6VPwwKzlvd/XiRX+Smvz01ifRcl+K1X0RXOpNxR7jJ7LBMxl3OxrtCV9iX2fiuJF4FGwepWo=
Date: Thu, 7 Jun 2007 18:23:12 +0800
From: "Peer Chen" <peerchen@gmail.com>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Cc: "jeff" <jeff@garzik.org>, "akpm" <akpm@linux-foundation.org>,
       "htejun" <htejun@gmail.com>, "alan" <alan@redhat.com>
Subject: [PATCH 1/3] PATA: Add the MCP73/77 support to PATA driver
Message-ID: <200706071823109037361@gmail.com>
X-mailer: Foxmail 6, 6, 105, 21 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add the MCP73/MCP77 support to PATA driver.
The patch base on kernel 2.6.22-rc4
 
Signed-off-by: Peer Chen <peerchen@gmail.com>
---------------------------------------------------
--- linux-2.6.22-rc4/drivers/ata/pata_amd.c.orig
+++ linux-2.6.22-rc4/drivers/ata/pata_amd.c
@@ -693,6 +693,8 @@ static const struct pci_device_id amd[] 
 	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_IDE),	8 },
 	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP65_IDE),	8 },
 	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP67_IDE),	8 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP73_IDE),	8 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP77_IDE),	8 },
 	{ PCI_VDEVICE(AMD,	PCI_DEVICE_ID_AMD_CS5536_IDE),		9 },
 
 	{ },

