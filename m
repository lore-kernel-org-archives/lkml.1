Return-Path: <linux-kernel-owner+w=401wt.eu-S1756222AbZHPVjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222AbZHPVjh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 17:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755960AbZHPVjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 17:39:35 -0400
Received: from kroah.org ([198.145.64.141]:36158 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756183AbZHPVj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 17:39:26 -0400
Date: Sun, 16 Aug 2009 14:35:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.27.30
Message-ID: <20090816213523.GC7015@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.27.30 kernel.  All users of the
2.6.27 kernel series are very strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.27.29 and 2.6.27.30

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                           |    2 +-
 arch/parisc/kernel/cache.c         |   23 +++++++++++++++--------
 arch/parisc/kernel/pci-dma.c       |   12 ++++++++----
 arch/x86/kernel/pci-gart_64.c      |   10 ++++++++--
 block/Kconfig                      |   11 +++++++----
 drivers/firewire/fw-sbp2.c         |   10 +++++++++-
 drivers/hwmon/smsc47m1.c           |   11 +++++++++++
 drivers/i2c/chips/tsl2550.c        |   17 ++++++++++-------
 drivers/ieee1394/sbp2.c            |    1 +
 drivers/ieee1394/sbp2.h            |    8 +++++++-
 drivers/misc/Kconfig               |    4 +++-
 drivers/net/usb/asix.c             |    8 ++++++++
 drivers/scsi/libsas/sas_port.c     |   19 +++++++++++++++----
 drivers/usb/core/devio.c           |   10 ++++++----
 drivers/usb/serial/ftdi_sio.c      |    3 +++
 drivers/usb/serial/ftdi_sio.h      |   14 ++++++++++++++
 drivers/usb/storage/transport.c    |    2 +-
 drivers/usb/storage/unusual_devs.h |    7 +++++++
 fs/binfmt_flat.c                   |   17 ++++++++++++-----
 fs/compat_ioctl.c                  |    1 +
 fs/nfs/direct.c                    |   20 ++++++++++----------
 fs/nfs/read.c                      |    6 ++----
 fs/nfs/write.c                     |    6 ++----
 fs/proc/base.c                     |   27 ++++++++++++---------------
 fs/proc/task_mmu.c                 |    1 +
 fs/proc/task_nommu.c               |    1 +
 fs/sysfs/dir.c                     |    2 ++
 include/asm-parisc/tlbflush.h      |   13 ++++++-------
 include/asm-x86/irqflags.h         |    8 +++++++-
 include/linux/nfs_fs.h             |    5 ++---
 kernel/fork.c                      |   22 +++++++++++-----------
 mm/hugetlb.c                       |    2 +-
 mm/page_alloc.c                    |   13 +++++++++----
 net/socket.c                       |    2 +-
 34 files changed, 214 insertions(+), 104 deletions(-)

Alan Stern (1):
      USB: usbfs: fix -ENOENT error code to be -ENODEV

Dhaval Vasa (1):
      USB: ftdi_sio: add product_id for Marvell OpenRD Base, Client

Eric Dumazet (1):
      execve: must clear current->clear_child_tid

Eric Sandeen (2):
      hugetlbfs: fix i_blocks accounting
      compat_ioctl: hook up compat handler for FIEMAP ioctl

Giacomo Lozito (1):
      USB: storage: raise timeout in usb_stor_Bulk_max_lun

Greg Kroah-Hartman (2):
      asix: new device ids
      Linux 2.6.27.30

H. Peter Anvin (1):
      x86: fix assembly constraints in native_save_fl()

Helge Deller (1):
      parisc: ensure broadcast tlb purge runs single threaded

Henrique de Moraes Holschuh (1):
      thinkpad-acpi: disable broken bay and dock subdrivers

Jean Delvare (1):
      hwmon: (smsc47m1) Differentiate between LPC47M233 and LPC47M292

John Stoffel (1):
      Make SCSI SG v4 driver enabled by default and remove EXPERIMENTAL dependency, since udev depends on BSG

Linus Torvalds (2):
      flat: fix uninitialized ptr with shared libs
      Make sock_sendpage() use kernel_sendpage()

Mark Langsdorf (1):
      x86: enable GART-IOMMU only after setting up protection methods

Marko Hänninen (1):
      USB: ftdi_sio: add vendor and product id for Bayer glucose meter serial converter cable

Mel Gorman (1):
      page-allocator: preserve PFN ordering when __GFP_COLD is set

Michael Buesch (1):
      USB: devio: Properly do access_ok() checks

Michele Jr De Candia (1):
      i2c/tsl2550: Fix lux value in dark environment

Oleg Nesterov (2):
      mm_for_maps: simplify, use ptrace_may_access()
      mm_for_maps: shift down_read(mmap_sem) to the caller

Peter Oberparleiter (1):
      sysfs: fix hardlink count on device_move

Rogerio Brito (1):
      USB: storage: include Prolific Technology USB drive in unusual_devs list

Stefan Richter (2):
      ieee1394: sbp2: add support for disks >2 TB (and 16 bytes long CDBs)
      firewire: sbp2: add support for disks >2 TB (and 16 bytes long CDBs)

Tom Peng (1):
      SCSI: libsas: reuse the original port when hotplugging phys in wide ports

Trond Myklebust (1):
      NFS: Fix an O_DIRECT Oops...

