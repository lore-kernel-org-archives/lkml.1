Return-Path: <linux-kernel-owner+w=401wt.eu-S1759418AbZGHOsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759418AbZGHOsh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 10:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758830AbZGHOrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 10:47:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:52248 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758905AbZGHOri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 10:47:38 -0400
Subject: [PATCH 0/44] includecheck: fix multiple includes
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       David Howells <dhowells@redhat.com>, benh@kernel.crashing.org,
       paulus@samba.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       jdike@addtoit.com, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Miller <davem@davemloft.net>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       dbrownell@users.sourceforge.net, Greg KH <greg@kroah.com>,
       mchehab@infradead.org, jeremy@xensource.com, felixb@sgi.com,
       lenb@kernel.org, airlied@linux.ie, bcrl@kvack.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 19:58:28 +0530
Message-Id: <1247063308.4382.12.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit faf80d62e44dc627efb741f48db50c1858d1667c:
  Linus Torvalds (1):
        Merge branch 'x86-fixes-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/headers-check-2.6.git master

Jaswinder Singh Rajput (44):
      includecheck fix: arm, misc.c
      includecheck fix: arm, atomic.h
      includecheck fix: arm, board-dm355-evm.c
      includecheck fix: arm, board-dm355-leopard.c
      includecheck fix: arm, board-dm644x-evm.c
      includecheck fix: arm, board-dm646x-evm.c
      includecheck fix: arm, board-sffsdr.c
      includecheck fix: arm, mach-mx3/devices.c
      includecheck fix: arm, mach-omap1/mcbsp.c
      includecheck fix: arm, mach-omap2/mcbsp.c
      includecheck fix: arm, plat-s3c64xx/pm.c
      includecheck fix: arm, plat-stmp3xxx/pinmux.c
      includecheck fix: mn10300, sys_mn10300.c
      includecheck fix: powerpc, mpc7450-pmu.c
      includecheck fix: powerpc, ppc970-pmu.c
      includecheck fix: s390, sys_s390.c
      includecheck fix: um, helper.c
      includecheck fix: x86, dumpstack.c
      includecheck fix: x86, traps.c
      includecheck fix: x86, shadow.c
      includecheck fix: Documentation, cfag12864b-example.c
      includecheck fix: drivers/char, vt.c
      includecheck fix: drivers/net, sja1000.c
      includecheck fix: drivers/net, axnet_cs.c
      includecheck fix: drivers/net, smc911x.h
      includecheck fix: drivers/parisc, ccio-dma.c
      includecheck fix: drivers/scsi, libfcoe.c
      includecheck fix: drivers/scsi, ibmvscsi.c
      includecheck fix: drivers/spi, amba-pl022.c
      includecheck fix: drivers/staging, usbdrv.c
      includecheck fix: drivers/staging, rt_linux.h
      includecheck fix: drivers/video, vgacon.c
      includecheck fix: drivers/xen, evtchn.c
      includecheck fix: fs/xfs, xfs_iops.c
      includecheck fix: include/acpi, acpi_bus.h
      includecheck fix: include/drm, drm_memory.h
      includecheck fix: include/linux, aio.h
      includecheck fix: include/linux, ftrace.h
      includecheck fix: include/linux, icmpv6.h
      includecheck fix: include/linux, net_dropmon.h
      includecheck fix: include/linux, rfkill.h
      includecheck fix: kernel/trace, ring_buffer.c
      includecheck fix: mm, nommu.c
      includecheck fix: mm, shmem.c

 Documentation/auxdisplay/cfag12864b-example.c |    1 -
 arch/arm/boot/compressed/misc.c               |    1 -
 arch/arm/include/asm/atomic.h                 |    2 --
 arch/arm/mach-davinci/board-dm355-evm.c       |    1 -
 arch/arm/mach-davinci/board-dm355-leopard.c   |    1 -
 arch/arm/mach-davinci/board-dm644x-evm.c      |    1 -
 arch/arm/mach-davinci/board-dm646x-evm.c      |    1 -
 arch/arm/mach-davinci/board-sffsdr.c          |    1 -
 arch/arm/mach-mx3/devices.c                   |    1 -
 arch/arm/mach-omap1/mcbsp.c                   |    1 -
 arch/arm/mach-omap2/mcbsp.c                   |    1 -
 arch/arm/plat-s3c64xx/pm.c                    |    2 --
 arch/arm/plat-stmp3xxx/pinmux.c               |    1 -
 arch/mn10300/kernel/sys_mn10300.c             |    1 -
 arch/powerpc/kernel/mpc7450-pmu.c             |    1 -
 arch/powerpc/kernel/ppc970-pmu.c              |    1 -
 arch/s390/kernel/sys_s390.c                   |    1 -
 arch/um/os-Linux/helper.c                     |    1 -
 arch/x86/kernel/dumpstack.c                   |    1 -
 arch/x86/kernel/traps.c                       |    1 -
 arch/x86/mm/kmemcheck/shadow.c                |    1 -
 drivers/char/vt.c                             |    1 -
 drivers/net/can/sja1000/sja1000.c             |    1 -
 drivers/net/pcmcia/axnet_cs.c                 |    2 --
 drivers/net/smc911x.h                         |    1 -
 drivers/parisc/ccio-dma.c                     |    1 -
 drivers/scsi/fcoe/libfcoe.c                   |    1 -
 drivers/scsi/ibmvscsi/ibmvscsi.c              |    1 -
 drivers/spi/amba-pl022.c                      |    2 --
 drivers/staging/otus/usbdrv.c                 |    3 ---
 drivers/staging/rt2860/rt_linux.h             |    4 ----
 drivers/video/console/vgacon.c                |    1 -
 drivers/xen/evtchn.c                          |    1 -
 fs/xfs/linux-2.6/xfs_iops.c                   |    1 -
 include/acpi/acpi_bus.h                       |    1 -
 include/drm/drm_memory.h                      |    2 --
 include/linux/aio.h                           |    2 --
 include/linux/ftrace.h                        |    1 -
 include/linux/icmpv6.h                        |    2 --
 include/linux/net_dropmon.h                   |    1 -
 include/linux/rfkill.h                        |    1 -
 kernel/trace/ring_buffer.c                    |    2 --
 mm/nommu.c                                    |    2 --
 mm/shmem.c                                    |    1 -
 44 files changed, 0 insertions(+), 58 deletions(-)


