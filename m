Return-Path: <linux-kernel-owner+w=401wt.eu-S933352AbZLRXB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933352AbZLRXB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 18:01:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933323AbZLRXBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 18:01:12 -0500
Received: from kroah.org ([198.145.64.141]:38537 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933262AbZLRXAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 18:00:13 -0500
Date: Fri, 18 Dec 2009 14:58:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.27.42
Message-ID: <20091218225835.GA19026@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.27.42 kernel.  All users of the
2.6.27 kernel series are very strongly encouraged to upgrade.

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                               |    2 -
 arch/ia64/lib/ip_fast_csum.S           |    8 +++-
 arch/x86/kernel/cpu/perfctr-watchdog.c |    2 -
 arch/x86/kernel/pci-calgary_64.c       |   12 ++++---
 arch/x86/kernel/pci-dma.c              |    2 -
 arch/x86/kernel/pci-gart_64.c          |    2 -
 arch/x86/kernel/reboot.c               |    8 ++++
 drivers/ata/pata_hpt37x.c              |   32 +++++++++----------
 drivers/ata/pata_hpt3x2n.c             |   17 ++++------
 drivers/firewire/fw-ohci.c             |   12 ++++++-
 drivers/media/common/tuners/mxl5007t.c |    2 -
 drivers/ssb/sprom.c                    |   20 +++++++++---
 drivers/usb/serial/mos7840.c           |   21 ++++++++----
 drivers/video/backlight/lcd.c          |    2 -
 drivers/video/matrox/g450_pll.c        |    3 +
 fs/debugfs/inode.c                     |   55 +++++++++++++++++++--------------
 fs/hfs/catalog.c                       |    4 ++
 fs/hfs/dir.c                           |   11 ++++++
 fs/hfs/super.c                         |    7 +++-
 fs/jffs2/gc.c                          |    3 +
 include/linux/sched.h                  |   13 ++++++-
 21 files changed, 156 insertions(+), 82 deletions(-)

Alan Cox (1):
      matroxfb: fix problems with display stability

Amerigo Wang (1):
      hfs: fix a potential buffer overflow

Darrick J. Wong (1):
      x86, Calgary IOMMU quirk: Find nearest matching Calgary while walking up the PCI tree

David Woodhouse (1):
      jffs2: Fix long-standing bug with symlink garbage collection.

Greg Kroah-Hartman (1):
      Linux 2.6.27.42

Jay Fenlason (1):
      firewire: ohci: handle receive packets with a data length of zero

Jean Delvare (1):
      backlight: lcd - Fix wrong sizeof

Jiri Bohac (1):
      fix csum_ipv6_magic()

Joe Perches (1):
      x86: GART: pci-gart_64.c: Use correct length in strncmp

Leann Ogasawara (1):
      x86: ASUS P4S800 reboot=bios quirk

Mathieu Desnoyers (1):
      debugfs: fix create mutex racy fops and private data

Michael Buesch (1):
      ssb: Fix range check in sprom write

Mikael Pettersson (1):
      x86, apic: Enable lapic nmi watchdog on AMD Family 11h

Roel Kluin (1):
      V4L/DVB: Fix test in copy_reg_bits()

Sebastian Andrzej Siewior (1):
      signal: Fix alternate signal stack check

Sergei Shtylyov (1):
      pata_hpt{37x|3x2n}: fix timing register masks (take 2)

Tejun Heo (1):
      x86: Fix iommu=nodac parameter handling

Tony Cook (1):
      USB: fix mos7840 problem with minor numbers

