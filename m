Return-Path: <linux-kernel-owner+w=401wt.eu-S1753217AbZIXRke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbZIXRke (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 13:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753155AbZIXRkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 13:40:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51707 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbZIXRka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 13:40:30 -0400
Date: Thu, 24 Sep 2009 10:39:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.30.8
Message-ID: <20090924173900.GC17077@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.30.8 kernel.  All users of the
2.6.30 kernel series are very strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.30.7 and 2.6.30.8

The updated 2.6.30.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.30.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.30.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                  |    2 
 arch/arm/mm/highmem.c                     |    8 +++
 arch/powerpc/include/asm/mmu-hash64.h     |    2 
 arch/powerpc/kernel/lparcfg.c             |    3 +
 arch/powerpc/kernel/rtas.c                |    7 ++-
 arch/powerpc/mm/slb.c                     |   16 +++++--
 arch/powerpc/platforms/pseries/reconfig.c |    9 +++-
 arch/x86/include/asm/processor.h          |   12 +++++
 arch/x86/include/asm/stackprotector.h     |    4 -
 arch/x86/include/asm/system.h             |    2 
 arch/x86/kernel/apic/es7000_32.c          |    2 
 arch/x86/kernel/cpu/common.c              |    2 
 arch/x86/kernel/head_32.S                 |    1 
 arch/x86/mm/pageattr.c                    |    8 +++
 drivers/ata/libata-core.c                 |    8 +++
 drivers/block/virtio_blk.c                |    3 +
 drivers/char/agp/intel-agp.c              |    9 ----
 drivers/char/tpm/tpm_tis.c                |   12 ++---
 drivers/input/joydev.c                    |   66 ++++++++++++++++++------------
 drivers/media/video/em28xx/em28xx-cards.c |    3 +
 drivers/net/mlx4/eq.c                     |   42 -------------------
 drivers/net/mlx4/main.c                   |    9 ++--
 drivers/net/mlx4/mlx4.h                   |    7 ---
 drivers/net/wireless/ath5k/base.c         |    2 
 drivers/pci/quirks.c                      |    3 +
 drivers/ps3/ps3stor_lib.c                 |   65 ++++++++++++++++++++++++++++-
 drivers/scsi/sg.c                         |    2 
 fs/binfmt_elf.c                           |   28 ++++++------
 fs/udf/lowlevel.c                         |    7 ++-
 ipc/shm.c                                 |    2 
 net/wireless/scan.c                       |    2 
 sound/pci/cs46xx/cs46xx_lib.h             |    2 
 sound/pci/oxygen/oxygen_io.c              |   11 -----
 sound/soc/codecs/wm8350.c                 |    2 
 34 files changed, 222 insertions(+), 141 deletions(-)

Bob Copeland (2):
      ath5k: write PCU registers on initial reset
      cfg80211: fix looping soft lockup in find_ie()

Brian King (1):
      powerpc/pseries: Fix to handle slb resize across migration

Christoph Hellwig (1):
      virtio_blk: don't bounce highmem requests

Clemens Ladisch (1):
      sound: oxygen: work around MCE when changing volume

Franklin Meng (1):
      V4L: em28xx: set up tda9887_conf in em28xx_card_setup()

Geoff Levand (1):
      powerpc/ps3: Workaround for flash memory I/O error

Greg Kroah-Hartman (1):
      Linux 2.6.30.8

Hugh Dickins (1):
      fix undefined reference to user_shm_unlock

Jack Steiner (1):
      x86, pat: Fix cacheflush address in change_page_attr_set_clr()

Jan Kara (1):
      udf: Use device size when drive reported bogus number of written blocks

Jason Gunthorpe (1):
      TPM: Fixup boot probe timeout for tpm_tis driver

Jean Delvare (1):
      PCI: Unhide the SMBus on the Compaq Evo D510 USDT

Jeremy Fitzhardinge (1):
      x86/i386: Make sure stack-protector segment base is cache aligned

Mark Brown (1):
      ASoC: Fix WM835x Out4 capture enumeration

Michal Schmidt (1):
      sg: fix oops in the error path in sg_build_indirect()

Nicolas Pitre (1):
      ARM: 5691/1: fix cache aliasing issues between kmap() and kmap_atomic() with highmem

Roel Kluin (1):
      x86: Fix x86_model test in es7000_apic_is_cluster()

Roland Dreier (1):
      mlx4_core: Allocate and map sufficient ICM memory for EQ context

Roland McGrath (1):
      binfmt_elf: fix PT_INTERP bss handling

Sophie Hamilton (1):
      ALSA: cs46xx - Fix minimum period size

Stephen Kitt (1):
      Input: joydev - decouple axis and button map ioctls from input constants

Tejun Heo (2):
      PCI: apply nv_msi_ht_cap_quirk on resume too
      libata: fix off-by-one error in ata_tf_read_block()

Zhenyu Wang (1):
      agp/intel: remove restore in resume

