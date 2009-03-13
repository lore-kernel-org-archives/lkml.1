Return-Path: <linux-kernel-owner+w=401wt.eu-S1758028AbZCMFvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028AbZCMFvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 01:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbZCMFvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 01:51:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:34062 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550AbZCMFvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 01:51:00 -0400
Date: Fri, 13 Mar 2009 05:50:13 +0000
From: Kyle McMartin <kyle@hera.kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [git patches] parisc: patches for 2.6.29 (or .30)
Message-ID: <20090313055013.GA15358@hera.kernel.org>
Reply-To: kyle@mcmartin.ca
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 05:50:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is entirely build warning cleanups, and fixups from my 2.6.30 tree
that would be nice to see in .29, but no big deal if you think it's
inappropriate at this point, I just hadn't had time to split these
apart any earlier.

regards, Kyle

The following changes since commit 041b62374c7fedc11a8a1eeda2868612d3d1436c:

  Linus Torvalds (1):
        Linus 2.6.29-rc8

are available in the git repository at:

  /pub/scm/linux/kernel/git/kyle/parisc-2.6.29.git master

Grant Grundler (2):
      parisc: fix wrong assumption about bus->self
      parisc: update MAINTAINERS

Helge Deller (7):
      parisc: BUG_ON() cleanup
      parisc: fix section mismatch warnings
      parisc: fix `struct pt_regs' declared inside parameter list warning
      parisc: remove unused local out_putf label
      parisc: fix dev_printk() compile warnings for accessing a device struct
      parisc: add braces around arguments in assembler macros
      parisc: fix 64bit build

James Bottomley (1):
      parisc: remove klist iterators

Kay Sievers (1):
      parisc: dino: struct device - replace bus_id with dev_name(), dev_set_name()

Kyle McMartin (5):
      parisc: fix use of new cpumask api in irq.c
      parisc: convert (read|write)bwlq to inlines
      parisc: convert cpu_check_affinity to new cpumask api
      parisc: define x->x mmio accessors
      parisc: update defconfigs

Mike Travis (1):
      parisc: update parisc for new irq_desc

 MAINTAINERS                           |    6 +-
 arch/parisc/configs/712_defconfig     |  429 ++++++++++++++++---------
 arch/parisc/configs/a500_defconfig    |  490 +++++++++++++++++++---------
 arch/parisc/configs/b180_defconfig    |  433 ++++++++++++++++--------
 arch/parisc/configs/c3000_defconfig   |  575 +++++++++++++++++++++-----------
 arch/parisc/configs/default_defconfig |  585 ++++++++++++++++++++++-----------
 arch/parisc/hpux/fs.c                 |    1 -
 arch/parisc/include/asm/assembly.h    |   11 +-
 arch/parisc/include/asm/io.h          |   51 +++-
 arch/parisc/include/asm/irq.h         |    2 +-
 arch/parisc/include/asm/uaccess.h     |    1 +
 arch/parisc/kernel/cache.c            |    5 +-
 arch/parisc/kernel/entry.S            |    6 +-
 arch/parisc/kernel/firmware.c         |   12 +-
 arch/parisc/kernel/irq.c              |   18 +-
 arch/parisc/kernel/pci-dma.c          |   22 +-
 arch/parisc/mm/init.c                 |    6 +-
 drivers/char/agp/parisc-agp.c         |   23 +-
 drivers/parisc/dino.c                 |   13 +-
 drivers/parisc/gsc.c                  |   39 ++-
 drivers/parisc/iosapic.c              |   16 +-
 drivers/parisc/lba_pci.c              |    4 +-
 drivers/parisc/sba_iommu.c            |   61 ++--
 drivers/scsi/lasi700.c                |    2 +-
 drivers/scsi/zalon.c                  |    2 +-
 25 files changed, 1849 insertions(+), 964 deletions(-)
