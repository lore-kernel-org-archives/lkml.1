Return-Path: <linux-kernel-owner+w=401wt.eu-S1756147AbXIUGSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbXIUGSd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 02:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbXIUGS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 02:18:26 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:14645 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbXIUGSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 02:18:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:x-mailer;
        b=Ks+kh524jm2dPinBJsq99RGTP97GQCvnMWC8hJxbxAtalzZacUSL9hNk0lWFLCqhYTtZFe5BJY9hRzJ5ZZZIwLkEtaCOVg2dBzUZo8HxnFZTFBV3lyV1f7pJC/LlrtcAzMjRSM2UoaEo30Tjq+OF1FOZFEFLKOzven0GNgSjvgs=
Date: Fri, 21 Sep 2007 14:18:19 +0800
From: "Peer Chen" <peerchen@gmail.com>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Cc: "alsa-devel" <alsa-devel@alsa-project.org>,
       "akpm" <akpm@linux-foundation.org>
Subject: [PATCH] alsa: Add the MCP79 support to hda_intel driver
Message-ID: <200709211418128243692@gmail.com>
X-mailer: Foxmail 6, 6, 105, 21 [cn]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Resend the patch for description modification and send to correct alsa maillist.

Add the MCP79 support to hda driver.
The patch base on kernel 2.6.23-rc7
 
Signed-off-by: Peer Chen <peerchen@gmail.com>
---
--- linux-2.6.23-rc7/sound/pci/hda/hda_intel.c.orig	2007-09-20 15:40:51.000000000 -0400
+++ linux-2.6.23-rc7/sound/pci/hda/hda_intel.c	2007-09-21 13:50:33.000000000 -0400
@@ -1791,6 +1791,10 @@ static struct pci_device_id azx_ids[] = 
 	{ 0x10de, 0x0775, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_NVIDIA }, /* NVIDIA MCP77 */
 	{ 0x10de, 0x0776, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_NVIDIA }, /* NVIDIA MCP77 */
 	{ 0x10de, 0x0777, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_NVIDIA }, /* NVIDIA MCP77 */
+	{ 0x10de, 0x0ac0, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_NVIDIA }, /* NVIDIA MCP79 */
+	{ 0x10de, 0x0ac1, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_NVIDIA }, /* NVIDIA MCP79 */
+	{ 0x10de, 0x0ac2, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_NVIDIA }, /* NVIDIA MCP79 */
+	{ 0x10de, 0x0ac3, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_NVIDIA }, /* NVIDIA MCP79 */
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, azx_ids);
-
 				
--------------
Peer Chen
2007-09-21

