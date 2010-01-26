Return-Path: <linux-kernel-owner+w=401wt.eu-S1754365Ab0AZXn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab0AZXn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:43:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754133Ab0AZXnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:43:17 -0500
Received: from kroah.org ([198.145.64.141]:35126 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753995Ab0AZXnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:07 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:22 2010
Message-Id: <20100126233922.699592453@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:33:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Stefan Ringel <stefan.ringel@arcor.de>, Takashi Iwai <tiwai@suse.de>,
       Ben Hutchings <ben@decadent.org.uk>
Subject: [14/98] ALSA: hda - Add PCI IDs for Nvidia G2xx-series
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stefan Ringel <stefan.ringel@arcor.de>

commit 6dd7dc767e35cfbb38f8c63a50b1c27acad25920 upstream.

Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/hda_intel.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2694,6 +2694,9 @@ static struct pci_device_id azx_ids[] = 
 	{ PCI_DEVICE(0x10de, 0x0ac1), .driver_data = AZX_DRIVER_NVIDIA },
 	{ PCI_DEVICE(0x10de, 0x0ac2), .driver_data = AZX_DRIVER_NVIDIA },
 	{ PCI_DEVICE(0x10de, 0x0ac3), .driver_data = AZX_DRIVER_NVIDIA },
+	{ PCI_DEVICE(0x10de, 0x0be2), .driver_data = AZX_DRIVER_NVIDIA },
+	{ PCI_DEVICE(0x10de, 0x0be3), .driver_data = AZX_DRIVER_NVIDIA },
+	{ PCI_DEVICE(0x10de, 0x0be4), .driver_data = AZX_DRIVER_NVIDIA },
 	{ PCI_DEVICE(0x10de, 0x0d94), .driver_data = AZX_DRIVER_NVIDIA },
 	{ PCI_DEVICE(0x10de, 0x0d95), .driver_data = AZX_DRIVER_NVIDIA },
 	{ PCI_DEVICE(0x10de, 0x0d96), .driver_data = AZX_DRIVER_NVIDIA },


