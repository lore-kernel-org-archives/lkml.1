Return-Path: <linux-kernel-owner+w=401wt.eu-S1755395AbXFGKYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbXFGKYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 06:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753435AbXFGKYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 06:24:39 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:58784 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbXFGKYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 06:24:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=P8ySvI32G+fCQR9CYGtefpKzfniZKtDz+yfhlVoeGC057xQ+wFnj6plFie+JSzVUJA6PSjhIpXlbappLboRSqo9YviJ5jSDJKB/JlVwLksEBezJvHcmLqd+o6F9CtBGPJ7RqFTunTm7A6cq595f5J03g7vWv6P8r95wLymo6JFA=
Date: Thu, 7 Jun 2007 18:24:36 +0800
From: "Peer Chen" <peerchen@gmail.com>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Cc: "alan" <alan@redhat.com>, "akpm" <akpm@linux-foundation.org>,
       "jeff" <jeff@garzik.org>, "htejun" <htejun@gmail.com>
Subject: [PATCH 2/3] PATA: Add the MCP73/77 support to PATA driver
Message-ID: <200706071824343417345@gmail.com>
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
--- linux-2.6.22-rc4/drivers/ide/pci/amd74xx.c.orig
+++ linux-2.6.22-rc4/drivers/ide/pci/amd74xx.c
@@ -76,6 +76,8 @@ static struct amd_ide_chip {
 	{ PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_IDE,	0x50, AMD_UDMA_133 },
 	{ PCI_DEVICE_ID_NVIDIA_NFORCE_MCP65_IDE,	0x50, AMD_UDMA_133 },
 	{ PCI_DEVICE_ID_NVIDIA_NFORCE_MCP67_IDE,	0x50, AMD_UDMA_133 },
+	{ PCI_DEVICE_ID_NVIDIA_NFORCE_MCP73_IDE,	0x50, AMD_UDMA_133 },
+	{ PCI_DEVICE_ID_NVIDIA_NFORCE_MCP77_IDE,	0x50, AMD_UDMA_133 },
 	{ PCI_DEVICE_ID_AMD_CS5536_IDE,			0x40, AMD_UDMA_100 },
 	{ 0 }
 };

