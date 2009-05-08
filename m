Return-Path: <linux-kernel-owner+w=401wt.eu-S1764164AbZEHXRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764164AbZEHXRr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 19:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753773AbZEHXRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 19:17:35 -0400
Received: from kroah.org ([198.145.64.141]:60657 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753201AbZEHXRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 19:17:34 -0400
Date: Fri, 8 May 2009 16:13:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.27.23
Message-ID: <20090508231312.GA6598@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.27.23 kernel.  All users of the
2.6.27 kernel series are very strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.27.22 and 2.6.27.23

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                            |    2 
 arch/mips/Kconfig                   |    1 
 arch/mips/kernel/linux32.c          |   69 ++++++++++++++-----------
 arch/mips/kernel/scall32-o32.S      |    4 -
 arch/mips/kernel/scall64-64.S       |    2 
 arch/mips/kernel/scall64-n32.S      |   28 +++++-----
 arch/mips/kernel/scall64-o32.S      |   40 +++++++-------
 arch/mips/kernel/signal.c           |    5 +
 arch/mips/kernel/signal32.c         |   28 +++++-----
 arch/mips/kernel/syscall.c          |   26 ++++-----
 arch/mips/mm/cache.c                |    5 +
 arch/x86/pci/mmconfig-shared.c      |    6 +-
 drivers/acpi/resources/rscreate.c   |   27 ----------
 drivers/char/hw_random/virtio-rng.c |    4 -
 drivers/gpu/drm/i915/i915_drv.h     |    6 +-
 drivers/net/forcedeth.c             |    3 +
 drivers/net/mv643xx_eth.c           |    2 
 drivers/net/wireless/b43/dma.c      |   50 ++++++++++++++----
 drivers/net/wireless/rndis_wlan.c   |   14 +++--
 drivers/pci/quirks.c                |    1 
 drivers/usb/serial/usb-serial.c     |   97 ++++++++++++++++++++++++------------
 drivers/usb/storage/unusual_devs.h  |    6 ++
 fs/proc/array.c                     |   13 +++-
 fs/proc/base.c                      |    5 +
 fs/proc/task_mmu.c                  |    4 +
 include/drm/drm_pciids.h            |    1 
 kernel/time/tick-common.c           |   12 ++++
 mm/madvise.c                        |    8 ++
 scripts/mod/modpost.c               |    1 
 29 files changed, 287 insertions(+), 183 deletions(-)

Alan Stern (1):
      USB: serial: fix lifetime and locking problems

Cedric Hombourger (1):
      kbuild: fix Module.markers permission error under cygwin

Christian Borntraeger (1):
      virtio-rng: Remove false BUG for spurious callbacks

Chuck Short (1):
      USB: Unusual Device support for Gold MP3 Player Energy

Ed Swierk (1):
      forcedeth: Fix resume from hibernation regression.

Greg Kroah-Hartman (1):
      Linux 2.6.27.23

Jake Edge (1):
      proc: avoid information leaks to non-privileged processes

John Stultz (1):
      clockevents: prevent endless loop in tick_handle_periodic()

Jussi Kivilinna (1):
      rndis_wlan: fix initialization order for workqueue&workers

Lennert Buytenhek (1):
      mv643xx_eth: 64bit mib counter read fix

Mel Gorman (1):
      Ignore madvise(MADV_WILLNEED) for hugetlbfs-backed regions

Michael Buesch (2):
      b43: Poison RX buffers
      b43: Refresh RX poison on buffer recycling

Thomas Renninger (1):
      PCI quirk: disable MSI on VIA VT3364 chipsets

Vitaly Mayatskikh (1):
      pagemap: require aligned-length, non-null reads of /proc/pid/pagemap

Yinghai Lu (1):
      x86/PCI: don't call e820_all_mapped with -1 in the mmconfig case

Zhang Rui (1):
      ACPI: Revert conflicting workaround for BIOS w/ mangled PRT entries

Zhenyu Wang (1):
      drm/i915: add support for G41 chipset

dann frazier (1):
      MIPS: CVE-2009-0029: Enable syscall wrappers

