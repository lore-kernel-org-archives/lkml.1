Return-Path: <linux-kernel-owner+w=401wt.eu-S1761889AbZANRxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761889AbZANRxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 12:53:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbZANRxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 12:53:05 -0500
Received: from kroah.org ([198.145.64.141]:56235 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752691AbZANRxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 12:53:03 -0500
Date: Wed, 14 Jan 2009 09:51:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.27.11
Message-ID: <20090114175126.GA32220@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.27.11
kernel.

It contains a wide range of bugfixes, and all users of the 2.6.27 kernel
series are strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.27.10 and 2.6.27.11

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                              |    2 +-
 arch/powerpc/lib/rheap.c              |    1 +
 arch/x86/kernel/amd_iommu.c           |    4 ++--
 arch/x86/kernel/amd_iommu_init.c      |    7 ++++++-
 crypto/async_tx/async_xor.c           |   11 +++++++++--
 drivers/block/cciss.c                 |    5 +++++
 drivers/dma/dmaengine.c               |    3 +++
 drivers/dma/ioat_dma.c                |    5 ++++-
 drivers/dma/iop-adma.c                |   16 +++++++++++++---
 drivers/dma/mv_xor.c                  |   15 ++++++++++++---
 drivers/md/bitmap.c                   |   22 +++++++++++++++++-----
 drivers/net/starfire.c                |    5 +++++
 drivers/net/wireless/iwlwifi/iwl-tx.c |    7 +++----
 drivers/scsi/aacraid/linit.c          |    4 ++--
 drivers/scsi/ibmvscsi/ibmvstgt.c      |   16 +++++++++-------
 drivers/usb/gadget/f_rndis.c          |    4 ++++
 drivers/usb/storage/unusual_devs.h    |   16 +++++++++++++++-
 include/asm-parisc/tlbflush.h         |    5 ++++-
 sound/pci/hda/patch_sigmatel.c        |    1 +
 sound/soc/omap/omap-pcm.c             |    2 +-
 20 files changed, 117 insertions(+), 34 deletions(-)

Alan Stern (1):
      usb-storage: update unusual_devs entry for Nokia 5310

Brian King (1):
      SCSI: ibmvstgt: move crq_queue_create to the end of initialization

CSÉCSY László (1):
      USB: storage: unusual_devs.h: Nokia 3109c addition

Dan Williams (3):
      async_xor: dma_map destination DMA_BIDIRECTIONAL
      dmaengine: protect 'id' from concurrent registrations
      ioat: wait for self-test completion

David Brownell (1):
      USB: gadget: fix rndis working at high speed

Greg Kroah-Hartman (1):
      Linux 2.6.27.11

Guillaume Knispel (1):
      powerpc: Fix corruption error in rh_alloc_fixed()

Herton Ronaldo Krzesinski (1):
      ALSA: hda - Add missing terminators in patch_sigmatel.c

Hillier, Gernot (1):
      SCSI: aacraid: disable Dell Percraid quirk on Adaptec 2200S and 2120S

Jarek Poplawski (1):
      drivers/net: starfire: Fix napi ->poll() weight handling

Joerg Roedel (4):
      AMD IOMMU: reset command buffer pointers manually
      AMD IOMMU: allocate rlookup_table with __GFP_ZERO
      AMD IOMMU: initialize phys_addr correctly in iommu_page_map
      AMD IOMMU: fix wrong loop counter in free_pagetables

Johannes Berg (1):
      iwlagn: downgrade BUG_ON in interrupt

Kyle McMartin (1):
      parisc: disable UP-optimized flush_tlb_mm

NeilBrown (1):
      md: Don't read past end of bitmap when reading bitmap.

Ozan Sener (1):
      USB: Unusual devs patch for Nokia 3500c

Stanley Miao (1):
      ALSA: Fix a Oops bug in omap soc driver.

Stephen M. Cameron (1):
      cciss: fix problem that deleting multiple logical drives could cause a panic

