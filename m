Return-Path: <linux-kernel-owner+w=401wt.eu-S1755909AbXFGKro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbXFGKro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 06:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751033AbXFGKrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 06:47:35 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:21858 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbXFGKrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 06:47:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=i7PXy6vzsD/Wrq4KkiEqcrqmeDQHCEV/hzKSW6cdApd0g7hWZj+DJ3RSCpPrg1gMlPGpM8+PeTzMNVs7WJivZYnw2YOQl+DJHBT3FZFPCYMPOByfL6uz+l+uiuzu1gaLfrvZSclcCOae8bW+YfD0hzxTDGFGSGwdC1EaJiOIwp4=
Date: Thu, 7 Jun 2007 18:47:32 +0800
From: "Peer Chen" <peerchen@gmail.com>
To: "alsa-devel" <alsa-devel@lists.sourceforge.net>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "akpm" <akpm@linux-foundation.org>
Subject: [PATCH] alsa: Add the MCP73/77 support to hda_intel driver
Message-ID: <200706071847303435644@gmail.com>
X-mailer: Foxmail 6, 6, 105, 21 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add the MCP73/MCP77 support to hda driver.
The patch base on kernel 2.6.22-rc4
 
Signed-off-by: Peer Chen <peerchen@gmail.com>
---
--- linux-2.6.22-rc4/sound/pci/hda/hda_intel.c.orig
+++ linux-2.6.22-rc4/sound/pci/hda/hda_intel.c
@@ -1788,6 +1788,12 @@ static struct pci_device_id azx_ids[] = 
 	{ 0x10de, 0x044b, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_NVIDIA }, /* NVIDIA MCP65 */
 	{ 0x10de, 0x055c, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_NVIDIA }, /* NVIDIA MCP67 */
 	{ 0x10de, 0x055d, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_NVIDIA }, /* NVIDIA MCP67 */
+	{ 0x10de, 0x07fc, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_NVIDIA }, /* NVIDIA MCP73 */
+	{ 0x10de, 0x07fd, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_NVIDIA }, /* NVIDIA MCP73 */
+	{ 0x10de, 0x0774, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_NVIDIA }, /* NVIDIA MCP77 */
+	{ 0x10de, 0x0775, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_NVIDIA }, /* NVIDIA MCP77 */
+	{ 0x10de, 0x0776, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_NVIDIA }, /* NVIDIA MCP77 */
+	{ 0x10de, 0x0777, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_NVIDIA }, /* NVIDIA MCP77 */
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, azx_ids);

