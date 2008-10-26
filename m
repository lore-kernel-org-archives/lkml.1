Return-Path: <linux-kernel-owner+w=401wt.eu-S1752736AbYJZEja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbYJZEja (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 00:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750888AbYJZEjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 00:39:19 -0400
Received: from kroah.org ([198.145.64.141]:38285 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750790AbYJZEjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 00:39:18 -0400
Date: Sat, 25 Oct 2008 21:35:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.27.4
Message-ID: <20081026043528.GA21910@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.27.4
kernel.

It contains a wide range of bugfixes, and all users of the 2.6.27 kernel
series are strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.27.3 and 2.6.27.4

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                       |    2 
 arch/x86/kernel/acpi/sleep.c                   |    3 +
 arch/x86/kernel/amd_iommu_init.c               |    2 
 drivers/acpi/hardware/hwsleep.c                |   37 ++++-----------
 drivers/acpi/sleep/main.c                      |   10 ++++
 drivers/char/hvc_console.c                     |   10 ++--
 drivers/edac/cell_edac.c                       |    2 
 drivers/gpio/gpiolib.c                         |    2 
 drivers/md/dm-kcopyd.c                         |   13 +++++
 drivers/md/dm-snap.c                           |   10 +---
 drivers/media/video/pvrusb2/pvrusb2-hdw.c      |    6 --
 drivers/pci/hotplug/cpqphp_core.c              |    2 
 drivers/scsi/device_handler/scsi_dh_rdac.c     |    2 
 drivers/usb/atm/speedtch.c                     |   12 +++++
 drivers/usb/class/cdc-acm.c                    |    3 -
 drivers/usb/class/cdc-wdm.c                    |    2 
 drivers/usb/core/driver.c                      |    3 -
 drivers/usb/core/hub.c                         |    2 
 fs/cifs/readdir.c                              |    3 -
 fs/ext2/dir.c                                  |   60 ++++++++++++++-----------
 fs/ext3/dir.c                                  |   10 ++--
 fs/ext4/dir.c                                  |   11 +++-
 fs/proc/task_mmu.c                             |   34 +++++++++-----
 kernel/sched_stats.h                           |    2 
 mm/rmap.c                                      |   42 +++++++++++++----
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    2 
 net/ipv4/netfilter/nf_nat_snmp_basic.c         |    1 
 net/netfilter/xt_iprange.c                     |    8 +--
 28 files changed, 184 insertions(+), 112 deletions(-)

Alan Stern (2):
      USB: don't rebind drivers after failed resume or reset
      USB: Speedtouch: add pre_reset and post_reset routines

Alexey Dobriyan (1):
      netfilter: xt_iprange: fix range inversion match

Andreas Herrmann (1):
      amd_iommu: fix nasty bug that caused ILLEGAL_DEVICE_TABLE_ENTRY errors

Benjamin Herrenschmidt (1):
      edac cell: fix incorrect edac_mode

Christian Borntraeger (1):
      hvc_console: Fix free_irq in spinlocked section

David Brownell (1):
      gpiolib: fix oops in gpio_get_value_cansleep()

Eric Sandeen (1):
      ext[234]: Avoid printk floods in the face of directory corruption (CVE-2008-3528)

Greg Kroah-Hartman (1):
      Linux 2.6.27.4

Ilpo Järvinen (1):
      netfilter: snmp nat leaks memory in case of failure

Jeff Layton (1):
      CIFS: fix saving of resume key before CIFSFindNext

Joe Korty (1):
      proc: fix vma display mismatch between /proc/pid/{maps,smaps}

Kazuo Ito (1):
      dm kcopyd: avoid queue shuffle

Kenji Kaneshige (1):
      PCI hotplug: cpqphp: fix kernel NULL pointer dereference

Linus Torvalds (1):
      anon_vma_prepare: properly lock even newly allocated entries

Miao Xie (1):
      sched: fix the wrong mask_len

Mike Isely (1):
      V4L/DVB (9300): pvrusb2: Fix deadlock problem

Mikulas Patocka (1):
      dm snapshot: fix primary_pe race

Oliver Neukum (2):
      USB: cdc-wdm: make module autoload work
      USB: fix memory leak in cdc-acm

Patrick McHardy (1):
      netfilter: restore lost ifdef guarding defrag exception

Rafael J. Wysocki (4):
      x86 ACPI: fix breakage of resume on 64-bit UP systems with SMP kernel
      ACPI Suspend: Enable ACPI during resume if SCI_EN is not set
      ACPI suspend: Blacklist HP xw4600 Workstation for old code ordering
      ACPI suspend: Always use the 32-bit waking vector

Yanqing_Liu@Dell.com (1):
      SCSI: scsi_dh: add Dell product information into rdac device handler

