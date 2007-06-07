Return-Path: <linux-kernel-owner+w=401wt.eu-S1756744AbXFGKcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744AbXFGKcz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 06:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbXFGKcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 06:32:47 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:29896 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbXFGKcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 06:32:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=S97SsicYESa2tjmYxIZ/3c0F6/V9f0NRHyQqhMCqsEE5yHXDU5aBDWZqvW2YztrJbZGp2ZHsUNjJ0yUwGFfC3S+hpRwMVFZXhmXazh8+AgRos2C1R6DKjJmYKspjWQsEGEJ67HqAjeMPP9tNE5fNTmD+kct1LWg9U7CH2HqRNfs=
Date: Thu, 7 Jun 2007 18:32:44 +0800
From: "Peer Chen" <peerchen@gmail.com>
To: "alsa-devel" <alsa-devel@lists.sourceforge.net>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "akpm" <akpm@linux-foundation.org>
Subject: [PATCH] alsa: Add the MCP73/77 support to hda_intel driver
Message-ID: <200706071832425988070@gmail.com>
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
----------------------------------------------
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

