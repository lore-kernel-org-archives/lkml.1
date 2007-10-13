Return-Path: <linux-kernel-owner+w=401wt.eu-S1763029AbXJMTHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763029AbXJMTHe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 15:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756179AbXJMTH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 15:07:26 -0400
Received: from havoc.gtf.org ([69.61.125.42]:43096 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755064AbXJMTH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 15:07:26 -0400
Date: Sat, 13 Oct 2007 15:07:24 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       shannon.nelson@intel.com, dan.j.williams@intel.com
Subject: [PATCH] drivers/pci, drivers/dma: kill unused vars
Message-ID: <20071013190724.GA20132@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Kill two never-used (not even in hidden debug macros) variables,
noticed by the compiler.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 drivers/dma/ioatdma.c                  |    1 -
 drivers/pci/hotplug/pci_hotplug_core.c |    2 --
 2 files changed, 3 deletions(-)

diff --git a/drivers/dma/ioatdma.c b/drivers/dma/ioatdma.c
index 41b18c5..d9db64b 100644
--- a/drivers/dma/ioatdma.c
+++ b/drivers/dma/ioatdma.c
@@ -244,7 +244,6 @@ static void ioat_dma_free_chan_resources(struct dma_chan *chan)
 	struct ioat_dma_chan *ioat_chan = to_ioat_chan(chan);
 	struct ioat_device *ioat_device = to_ioat_device(chan->device);
 	struct ioat_desc_sw *desc, *_desc;
-	u16 chanctrl;
 	int in_use_descs = 0;
 
 	ioat_dma_memcpy_cleanup(ioat_chan);
diff --git a/drivers/pci/hotplug/pci_hotplug_core.c b/drivers/pci/hotplug/pci_hotplug_core.c
index f0eba53..01c351c 100644
--- a/drivers/pci/hotplug/pci_hotplug_core.c
+++ b/drivers/pci/hotplug/pci_hotplug_core.c
@@ -689,8 +689,6 @@ int pci_hp_deregister (struct hotplug_slot *slot)
 int __must_check pci_hp_change_slot_info(struct hotplug_slot *slot,
 					 struct hotplug_slot_info *info)
 {
-	int retval;
-
 	if ((slot == NULL) || (info == NULL))
 		return -ENODEV;
 
