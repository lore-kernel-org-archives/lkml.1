Return-Path: <linux-kernel-owner+w=401wt.eu-S1751285AbZGTEKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751285AbZGTEKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 00:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750807AbZGTEKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 00:10:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:42122 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbZGTEKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 00:10:30 -0400
Date: Sun, 19 Jul 2009 21:08:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.30.2
Message-ID: <20090720040813.GC11940@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.30.2 kernel.  All users of the
2.6.30 kernel series are very strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.30.1 and 2.6.30.2

The updated 2.6.30.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.30.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.30.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                         |    7 +++--
 arch/alpha/include/asm/percpu.h  |    6 ++--
 arch/blackfin/kernel/irqchip.c   |   50 ++++++++-------------------------------
 arch/blackfin/kernel/setup.c     |    3 +-
 arch/blackfin/mach-common/head.S |   16 ++++++------
 arch/blackfin/mach-common/smp.c  |   13 +++++-----
 arch/x86/include/asm/pci.h       |    2 -
 block/blk-core.c                 |   10 +++----
 drivers/block/floppy.c           |    5 +++
 drivers/md/md.c                  |    8 ++++--
 drivers/md/raid5.c               |    3 +-
 drivers/net/tun.c                |    4 ++-
 drivers/pci/iova.c               |   26 +++++++++++++++++---
 fs/fuse/dev.c                    |    2 -
 fs/fuse/file.c                   |    2 -
 include/asm-generic/percpu.h     |    4 +++
 include/linux/mm.h               |    2 -
 include/linux/percpu-defs.h      |    3 +-
 include/linux/personality.h      |    5 +++
 include/linux/security.h         |    2 +
 kernel/futex.c                   |   43 ++++++++++++++++++---------------
 kernel/resource.c                |    2 -
 kernel/sysctl.c                  |    2 -
 lib/dma-debug.c                  |    2 -
 mm/Kconfig                       |   19 ++++++++++++++
 mm/mmap.c                        |    3 ++
 net/ipv4/arp.c                   |    7 +----
 security/Kconfig                 |   22 -----------------
 security/security.c              |    3 --
 29 files changed, 143 insertions(+), 133 deletions(-)

Christoph Lameter (1):
      security: use mmap_min_addr indepedently of security models

Csaba Henk (1):
      fuse: fix return value of fuse_dev_write()

David Woodhouse (2):
      Fix pci_unmap_addr() et al on i386.
      Fix iommu address space allocation

Eric W. Biederman (1):
      Revert "ipv4: arp announce, arp_proxy and windows ip conflict verification"

Eugene Teo (1):
      Add '-fno-delete-null-pointer-checks' to gcc CFLAGS

Greg Kroah-Hartman (1):
      Linux 2.6.30.2

Jiri Slaby (1):
      floppy: fix lock imbalance

Joerg Roedel (1):
      dma-debug: fix off-by-one error in overlap function

Julien Tinnes (1):
      personality: fix PER_CLEAR_ON_SETID (CVE-2009-1895)

Linus Torvalds (1):
      Don't use '-fwrapv' compiler option: it's buggy in gcc-4.1.x

Mariusz Kozlowski (1):
      tun/tap: Fix crashes if open() /dev/net/tun and then poll() it. (CVE-2009-1897)

Mike Frysinger (2):
      Blackfin: redo handling of bad irqs
      Blackfin: fix command line corruption with DEBUG_DOUBLEFAULT

Miklos Szeredi (1):
      fuse: fix bad return value in fuse_file_poll()

NeilBrown (4):
      blocK: Restore barrier support for md and probably other virtual devices.
      md/raid5: suspend shouldn't affect read requests.
      md: fix error path when duplicate name is found on md device creation.
      md: avoid dereferencing NULL pointer when accessing suspend_* sysfs attributes.

Sonic Zhang (2):
      Blackfin: fix accidental reset in some boot modes
      Blackfin: fix deadlock in SMP IPI handler

Sonny Rao (1):
      futexes: Fix infinite loop in get_futex_key() on huge page

Tejun Heo (1):
      alpha: fix percpu build breakage

Thomas Gleixner (1):
      futex: Fix the write access fault problem for real

Zhang Rui (1):
      kernel/resource.c: fix sign extension in reserve_setup()

