Return-Path: <linux-kernel-owner+w=401wt.eu-S934325AbYCFNX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934325AbYCFNX1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 08:23:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755583AbYCFNXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 08:23:16 -0500
Received: from rn-out-0910.google.com ([64.233.170.190]:3652 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526AbYCFNXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 08:23:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=w6+vgTjkAoTY13kSi/Nv+3tSwktgXS2trxZMRFMeYo/xV0gMGl8XMGDD2ScmCf9x6Z7W/L8+vTfkpauiAJL1wRcGb2oHBI9AAsgtI21Eq3Fb39BmFTn2hmInWBxOLfQbNjYeXEnTYtfb5GkUeDcbDw335PleXbx0t8RORkLu2+k=
Date: Thu, 6 Mar 2008 21:22:56 +0800
From: "peerchen" <peerchen@gmail.com>
To: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
Cc: "akpm" <akpm@linux-foundation.org>, "tiwai" <tiwai@suse.de>
Subject: [PATCH] hda_intel: Add the DIDs of nvidia MCP79 HD audio controller to hda_intel.c
Message-ID: <200803062122514065891@gmail.com>
X-mailer: Foxmail 6, 6, 105, 21 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the Device IDs of nvidia MCP79 HD audio controller to hda_intel.c

Signed-off-by: Peer Chen <peerchen@gmail.com>
---
--- linux-2.6.25-rc4/sound/pci/hda/hda_intel.c.orig	2008-03-04 21:51:07.000000000 -0500
+++ linux-2.6.25-rc4/sound/pci/hda/hda_intel.c	2008-03-04 21:53:43.000000000 -0500
@@ -2036,6 +2036,10 @@ static struct pci_device_id azx_ids[] = 
 	{ 0x10de, 0x0ac1, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_NVIDIA }, /* NVIDIA MCP79 */
 	{ 0x10de, 0x0ac2, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_NVIDIA }, /* NVIDIA MCP79 */
 	{ 0x10de, 0x0ac3, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_NVIDIA }, /* NVIDIA MCP79 */
+	{ 0x10de, 0x0bd4, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_NVIDIA }, /* NVIDIA MCP7B */
+	{ 0x10de, 0x0bd5, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_NVIDIA }, /* NVIDIA MCP7B */
+	{ 0x10de, 0x0bd6, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_NVIDIA }, /* NVIDIA MCP7B */
+	{ 0x10de, 0x0bd7, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_NVIDIA }, /* NVIDIA MCP7B */
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, azx_ids);
-

