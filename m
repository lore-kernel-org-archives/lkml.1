Return-Path: <linux-kernel-owner+w=401wt.eu-S1755639AbZHMTsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639AbZHMTsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755619AbZHMTsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:48:14 -0400
Received: from kroah.org ([198.145.64.141]:36831 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755523AbZHMTsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:48:11 -0400
Date: Thu, 13 Aug 2009 12:45:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 00/28] 2.6.27.30-stable review
Message-ID: <20090813194554.GA13947@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the start of the stable review cycle for the 2.6.27.30 release.
There are 28 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Saturday, August 15, 2009 19:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.30-rc1.gz
and the diffstat can be found below.


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
 sound/pci/hda/patch_realtek.c      |    2 ++
 35 files changed, 216 insertions(+), 104 deletions(-)
