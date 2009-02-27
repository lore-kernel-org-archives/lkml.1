Return-Path: <linux-kernel-owner+w=401wt.eu-S1755782AbZB0JE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782AbZB0JE3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 04:04:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756189AbZB0JDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 04:03:07 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:18474 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228AbZB0JDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 04:03:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=nRwK/vs/7x+3uBZ+o050tFnxoV4XVWRo3fMGcLCzRenppvlNf9hsMtW0zLvm0zO95J
         3sGHsVndTKIqpeFhpnzoF4HvONLftZMVJdw36WbqPCP6qrw/LN4ouMrt57Mhz9uvKATs
         Szl23HZ1jFiq3ZRgCPlRw1j1ajSe1IaxRvbV4=
Date: Fri, 27 Feb 2009 17:03:19 +0800
From: "peerchen" <peerchen@gmail.com>
To: "alsa-devel" <alsa-devel@alsa-project.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
Cc: "Takashi Iwai" <tiwai@suse.de>, "akpm" <akpm@linux-foundation.org>,
       "pchen" <pchen@nvidia.com>
Subject: [alsa-devel][PATCH] hda_intel: Add the Device IDs for MCP89 and remove IDs of MCP7B to/from hda_intel.c
Message-ID: <200902271703145182134@gmail.com>
X-mailer: Foxmail 6, 10, 201, 20 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added the Device IDs for MCP89 HD audio controller.
Removed the IDs of MCP7B cause this chipset had been cancelled.

Signed-off-by: Peer Chen <peerchen@gmail.com>
---
--- linux-2.6.29-rc6/sound/pci/hda/hda_intel.c.orig	2009-02-26 08:51:02.000000000 -0500
+++ linux-2.6.29-rc6/sound/pci/hda/hda_intel.c	2009-02-26 08:51:23.000000000 -0500
@@ -2442,10 +2442,10 @@ static struct pci_device_id azx_ids[] = 
 	{ PCI_DEVICE(0x10de, 0x0ac1), .driver_data = AZX_DRIVER_NVIDIA },
 	{ PCI_DEVICE(0x10de, 0x0ac2), .driver_data = AZX_DRIVER_NVIDIA },
 	{ PCI_DEVICE(0x10de, 0x0ac3), .driver_data = AZX_DRIVER_NVIDIA },
-	{ PCI_DEVICE(0x10de, 0x0bd4), .driver_data = AZX_DRIVER_NVIDIA },
-	{ PCI_DEVICE(0x10de, 0x0bd5), .driver_data = AZX_DRIVER_NVIDIA },
-	{ PCI_DEVICE(0x10de, 0x0bd6), .driver_data = AZX_DRIVER_NVIDIA },
-	{ PCI_DEVICE(0x10de, 0x0bd7), .driver_data = AZX_DRIVER_NVIDIA },
+	{ PCI_DEVICE(0x10de, 0x0d94), .driver_data = AZX_DRIVER_NVIDIA },
+	{ PCI_DEVICE(0x10de, 0x0d95), .driver_data = AZX_DRIVER_NVIDIA },
+	{ PCI_DEVICE(0x10de, 0x0d96), .driver_data = AZX_DRIVER_NVIDIA },
+	{ PCI_DEVICE(0x10de, 0x0d97), .driver_data = AZX_DRIVER_NVIDIA },
 	/* Teradici */
 	{ PCI_DEVICE(0x6549, 0x1200), .driver_data = AZX_DRIVER_TERA },
 	/* AMD Generic, PCI class code and Vendor ID for HD Audio */
-

