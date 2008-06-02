Return-Path: <linux-kernel-owner+w=401wt.eu-S1753492AbYFBKAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbYFBKAZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 06:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753070AbYFBJ7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 05:59:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:32958 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbYFBJ7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 05:59:04 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] isp1760-if iomem annotations
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Message-Id: <E1K36og-0007Z1-Ha@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Mon, 02 Jun 2008 10:59:02 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/drivers/usb/host/isp1760-if.c b/drivers/usb/host/isp1760-if.c
index 440bf94..c9db3fe 100644
--- a/drivers/usb/host/isp1760-if.c
+++ b/drivers/usb/host/isp1760-if.c
@@ -104,8 +104,8 @@ static u32 nxp_pci_io_base;
 static u32 iolength;
 static u32 pci_mem_phy0;
 static u32 length;
-static u8 *chip_addr;
-static u8 *iobase;
+static u8 __iomem *chip_addr;
+static u8 __iomem *iobase;
 
 static int __devinit isp1761_pci_probe(struct pci_dev *dev,
 		const struct pci_device_id *id)
