Return-Path: <linux-kernel-owner+w=401wt.eu-S1761725AbZJOIiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761725AbZJOIiY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 04:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755002AbZJOIiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 04:38:24 -0400
Received: from mail-px0-f187.google.com ([209.85.216.187]:40046 "EHLO
	mail-px0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002AbZJOIiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 04:38:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=o7fWQyWjyot2tali1C8bz7fYyzbVG7SZef7eqj4Q89aFRKLGhiTxXO0kJjkYp4h9V2
         XH5u+oG/0H+D71SYHVXOFEHV8oj1MU0BgigmFRRga2BKsYoRQSWTpqC54pZiZmHM9XvA
         s26k4oF8/3y4pm/DxjavEoY7JHG55XYIiAQoM=
MIME-Version: 1.0
Date: Thu, 15 Oct 2009 16:37:47 +0800
Message-ID: <cfaab6210910150137x5086ebb1j7a32512f04f83dca@mail.gmail.com>
Subject: [alsa-devel][PATCH] hda_intel: Add the Linux device ID for NVIDIA HDA 
	controller
From: peer chen <peerchen@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: tiwai <tiwai@suse.de>, akpm <akpm@linux-foundation.org>, pchen@nvidia.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the generic device ID for NVIDIA HDA controller.

Signed-off-by: Peer Chen<peerchen@gmail.com>
---
--- linux-2.6.32-rc4/sound/pci/hda/hda_intel.c.orig
+++ linux-2.6.32-rc4/sound/pci/hda/hda_intel.c
@@ -2674,6 +2674,7 @@ static struct pci_device_id azx_ids[] =
 	{ PCI_DEVICE(0x10de, 0x044b), .driver_data = AZX_DRIVER_NVIDIA },
 	{ PCI_DEVICE(0x10de, 0x055c), .driver_data = AZX_DRIVER_NVIDIA },
 	{ PCI_DEVICE(0x10de, 0x055d), .driver_data = AZX_DRIVER_NVIDIA },
+	{ PCI_DEVICE(0x10de, 0x0590), .driver_data = AZX_DRIVER_NVIDIA },
 	{ PCI_DEVICE(0x10de, 0x0774), .driver_data = AZX_DRIVER_NVIDIA },
 	{ PCI_DEVICE(0x10de, 0x0775), .driver_data = AZX_DRIVER_NVIDIA },
 	{ PCI_DEVICE(0x10de, 0x0776), .driver_data = AZX_DRIVER_NVIDIA },
-
