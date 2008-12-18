Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752806AbYLRSd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbYLRSd4 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 13:33:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbYLRSdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 13:33:45 -0500
Received: from kroah.org ([198.145.64.141]:49388 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750915AbYLRSdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 13:33:44 -0500
Date: Thu, 18 Dec 2008 10:32:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.27.10
Message-ID: <20081218183222.GA3403@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.27.10
kernel.

It contains a wide range of bugfixes, and all users of the 2.6.27 kernel
series are strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.27.9 and 2.6.27.10

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/kernel-parameters.txt        |    2 
 Makefile                                   |    2 
 arch/x86/kernel/amd_iommu_init.c           |    2 
 arch/x86/kernel/setup.c                    |   12 +---
 arch/x86/kernel/smpboot.c                  |    2 
 arch/x86/kernel/vmi_32.c                   |   16 ++++--
 drivers/ata/libata-core.c                  |   65 +++++++++++++++++++++++--
 drivers/char/cp437.uni                     |   12 ++--
 drivers/char/vt.c                          |    2 
 drivers/char/xilinx_hwicap/buffer_icap.c   |    3 -
 drivers/char/xilinx_hwicap/buffer_icap.h   |    3 -
 drivers/char/xilinx_hwicap/fifo_icap.c     |    3 -
 drivers/char/xilinx_hwicap/fifo_icap.h     |    3 -
 drivers/char/xilinx_hwicap/xilinx_hwicap.c |    3 -
 drivers/char/xilinx_hwicap/xilinx_hwicap.h |    3 -
 drivers/firewire/fw-ohci.c                 |   11 ++--
 drivers/firewire/fw-transaction.c          |    3 +
 drivers/firewire/fw-transaction.h          |    2 
 drivers/ieee1394/nodemgr.c                 |    6 ++
 drivers/isdn/hardware/avm/b1isa.c          |    6 --
 drivers/media/video/tvaudio.c              |   30 ++++++++++-
 drivers/net/bonding/bond_main.c            |    3 +
 drivers/net/e1000e/ich8lan.c               |    9 ++-
 drivers/net/wireless/iwlwifi/iwl-agn.c     |    6 +-
 drivers/net/wireless/iwlwifi/iwl-core.c    |    3 +
 drivers/net/wireless/iwlwifi/iwl-dev.h     |    3 -
 drivers/net/wireless/iwlwifi/iwl-rx.c      |   26 ++++++----
 drivers/net/wireless/iwlwifi/iwl-sta.c     |   24 ++++++++-
 drivers/video/macfb.c                      |   74 +++++++++++++----------------
 include/asm-x86/vmi.h                      |    8 ++-
 include/linux/can/core.h                   |    2 
 kernel/sched_clock.c                       |    6 +-
 lib/idr.c                                  |    8 ++-
 mm/page_alloc.c                            |    4 -
 net/can/af_can.c                           |   68 ++++++++++++++++++++------
 net/can/bcm.c                              |    7 +-
 net/core/dev.c                             |    2 
 net/key/af_key.c                           |    1 
 net/sunrpc/auth_generic.c                  |   20 +++++++
 39 files changed, 318 insertions(+), 147 deletions(-)


Alexey Dobriyan (1):
      key: fix setkey(8) policy set breakage

Finn Thain (1):
      macfb: Do not overflow fb_fix_screeninfo.id

Gerald Schaefer (1):
      setup_per_zone_pages_min(): take zone->lock instead of zone->lru_lock

Greg Kroah-Hartman (2):
      xilinx_hwicap: remove improper wording in license statement
      Linux 2.6.27.10

Ingo Brueckl (2):
      unicode table for cp437
      console ASCII glyph 1:1 mapping

Jay Vosburgh (1):
      bonding: fix miimon failure counter

Jeff Kirsher (1):
      e1000e: fix double release of mutex

Joerg Roedel (1):
      AMD IOMMU: enable device isolation per default

Johannes Berg (1):
      iwlagn: fix RX skb alignment

Linus Torvalds (1):
      Revert "sched_clock: prevent scd->clock from moving backwards"

Manfred Spraul (1):
      lib/idr.c: Fix bug introduced by RCU fix

Mauro Carvalho Chehab (1):
      V4L/DVB (9621): Avoid writing outside shadow.bytes[] array

Oliver Hartkopp (2):
      can: Fix CAN_(EFF|RTR)_FLAG handling in can_filter
      can: omit received RTR frames for single ID filter lists

Stefan Richter (2):
      firewire: fw-ohci: fix IOMMU resource exhaustion
      ieee1394: add quirk fix for Freecom HDD

Stephen Hemminger (1):
      net: eliminate warning from NETIF_F_UFO on bridge

Tejun Heo (1):
      libata: fix Seagate NCQ+FLUSH blacklist

Tomas Winkler (1):
      iwlwifi: clean key table in iwl_clear_stations_table function

Trond Myklebust (1):
      SUNRPC: Fix a performance regression in the RPC authentication code

Wilfried Klaebe (1):
      b1isa: fix b1isa_exit() to really remove registered capi controllers

Zachary Amsden (1):
      x86 Fix VMI crash on boot in 2.6.28-rc8

