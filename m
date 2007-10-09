Return-Path: <linux-kernel-owner+w=401wt.eu-S1756525AbXJIUyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525AbXJIUyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 16:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754711AbXJIUyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 16:54:36 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43577 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754642AbXJIUye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 16:54:34 -0400
Date: Tue, 9 Oct 2007 13:54:30 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.23
Message-ID: <alpine.LFD.0.999.0710091346490.5039@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Finally.

Yeah, it got delayed, not because of any huge issues, but because of 
various bugfixes trickling in and causing me to reset my "release clock" 
all the time. But it's out there now, and hopefully better for the wait.

Not a whole lot of changes since -rc9, although there's a few updates to 
mips, sparc64 and blackfin in there.  Ignoring those arch updates, there's 
basically a number of mostly one-liners (mostly in drivers, but there's 
some networking fixes and soem VFS/VM fixes there too).

Shortlog and diffstat appended (both relative to -rc9, of course - the 
full log from 2.6.22 is on kernel.org as usual).

I want this to be what people look at for a few days, but expect the x86 
merge to go ahead after that. So far, all indications are still that it's 
going to be all smooth sailing, but hey, those indicators seem to always 
say that, and only after the fact do people notice any problems ;)

		Linus

---
Akinobu Mita (1):
      [SPARC64]: check fork_idle() error

Al Viro (1):
      fix bogus reporting of signals by audit

Alexey Dobriyan (2):
      Move kasprintf.o to obj-y
      [ROSE]: Fix rose.ko oops on unload

Alexey Kuznetsov (1):
      [SFQ]: Remove artificial limitation for queue limit.

Andrew Morton (1):
      binfmt_flat: checkpatch fixing minimum support for the blackfin relocations

Anton Blanchard (2):
      [POWERPC] Fix xics set_affinity code
      Fix timer_stats printout of events/sec

Attila Kinali (1):
      Add manufacturer and card id of teltonica pcmcia modems

Ben Dooks (2):
      [ARM] 4597/2: OSIRIS: ensure CPLD0 is preserved after suspend
      [ARM] 4598/2: OSIRIS: Ensure we do not get nRSTOUT during suspend

Benjamin Herrenschmidt (1):
      Fix non-terminated PCI match table in PowerMac IDE

Bernd Schmidt (1):
      Binfmt_flat: Add minimum support for the Blackfin relocations

Brian Haley (1):
      [IPv6]: Fix ICMPv6 redirect handling with target multicast address

Bryan Wu (1):
      Blackfin arch: add some missing syscall

Dale Farnsworth (1):
      mv643xx_eth: Do not modify struct netdev tx_queue_len

David S. Miller (8):
      [SPARC]: Fix EBUS use of uninitialized variable.
      [SPARC64]: Fix put_user() calls in binfmt_aout32.c
      [SPARC64]: Fix missing load-twin usage in Niagara-1 memcpy.
      [SPARC64]: Don't use in/local regs for ldx/stx data in N1 memcpy.
      [SPARC64]: Fix domain-services port probing.
      [SPARC64]: VIO device addition log message level is too high.
      [SPARC64]: Temporary workaround for PCI-E slot on T1000.
      [SPARC64]: Fix 'niu' complex IRQ probing.

Dmitry Torokhov (1):
      Driver core: fix SYSF_DEPRECATED breakage for nested classdevs

Eric Dumazet (1):
      [TCP]: secure_tcp_sequence_number() should not use a too fast clock

FUJITA Tomonori (1):
      [SCSI] megaraid_old: fix READ_CAPACITY

Florian Fainelli (2):
      [MIPS] Alchemy: Fix USB initialization.
      [MIPS] Au1000: set the PCI controller IO base

Francois Romieu (1):
      r8169: revert part of 6dccd16b7c2703e8bbf8bca62b5cf248332afbe2

Giuseppe Sacco (2):
      [MIPS] IP32: Enable PCI bridges
      [MIPS] IP32: Fix fatal typo in address computation.

Hugh Dickins (1):
      Fix sys_remap_file_pages BUG at highmem.c:15!

Ilpo Järvinen (1):
      [TCP]: Fix fastpath_cnt_hint when GSO skb is partially ACKed

Ingo Molnar (1):
      sched: fix profile=sleep

Jeff Garzik (2):
      aic94xx: fix DMA data direction for SMP requests
      sata_mv: correct S/G table limits

Jeremy Fitzhardinge (1):
      xen: disable split pte locks for now

Jiri Slaby (1):
      Ata: pata_marvell, use ioread* for iomap-ped memory

Joe Perches (1):
      bcm43xx: Correct printk with PFX before KERN_

John W. Linville (1):
      [IEEE80211]: avoid integer underflow for runt rx frames

Karsten Keil (1):
      ISDN: Fix data access out of array bounds

Kyle McMartin (1):
      Revert "intel_agp: fix stolen mem range on G33"

Linus Torvalds (3):
      VT_WAITACTIVE: Avoid returning EINTR when not necessary
      Don't do load-average calculations at even 5-second intervals
      Linux 2.6.23

Maarten Bressers (1):
      Correct Makefile rule for generating custom keymap

Maciej W. Rozycki (1):
      [MIPS] pg-r4k.c: Fix a typo in an R4600 v2 erratum workaround

Michael Hennerich (2):
      Blackfin arch: gpio pinmux and resource allocation API required by BF537 on chip ethernet mac driver
      Blackfin arch: fix PORT_J BUG for BF537/6 EMAC driver reported by Kalle Pokki <kalle.pokki@iki.fi>

Olof Johansson (1):
      libata: fix for sata_mv >64KB DMA segments

Pavel Machek (1):
      sysrq docs: document sequence that actually works

Peter Korsgaard (1):
      dm9601: Fix receive MTU

Peter Zijlstra (2):
      lockstat: documentation
      mm: set_page_dirty_balance() vs ->page_mkwrite()

Rafal Bilski (1):
      Longhaul: add auto enabled "revid_errata" option

Ralf Baechle (2):
      [MIPS] Type proof reimplementation of cmpxchg.
      [MIPS] Terminally fix local_{dec,sub}_if_positive

Richard Knutsson (1):
      softmac: Fix compiler-warning

Ron Mercer (2):
      qla3xxx: bugfix: Add memory barrier before accessing rx completion.
      qla3xxx: bugfix: Fix VLAN rx completion handling.

Scott Thompson (1):
      drivers/ata/pata_ixp4xx_cf.c: ioremap return code check

Serge Belyshev (1):
      Remove unnecessary cast in prefetch()

Stefan Richter (1):
      firewire: point to migration document

Stephen Hemminger (2):
      sky2: jumbo frame regression fix
      [PKT_SCHED] cls_u32: error code isn't been propogated properly

Sunil Mushran (1):
      ocfs2: Unlock mutex in local alloc failure case

Tejun Heo (1):
      ata_piix: add another TECRA M3 entry to broken suspend list

Trond Myklebust (1):
      NLM: Fix a memory leak in nlmsvc_testlock

Yan Zheng (3):
      fix VM_CAN_NONLINEAR check in sys_remap_file_pages
      fix page release issue in filemap_fault
      AIO: fix cleanup in io_submit_one(...)

---
 Documentation/lockstat.txt                        |  120 +++++++
 Documentation/sysrq.txt                           |    2 +-
 Makefile                                          |    2 +-
 arch/arm/mach-s3c2440/mach-osiris.c               |   18 +
 arch/blackfin/kernel/bfin_gpio.c                  |  285 ++++++++++++++--
 arch/blackfin/mach-common/entry.S                 |   23 +-
 arch/i386/kernel/cpu/cpufreq/longhaul.c           |   60 ++++-
 arch/mips/au1000/common/pci.c                     |    1 +
 arch/mips/au1000/mtx-1/board_setup.c              |    4 +-
 arch/mips/au1000/pb1000/board_setup.c             |    6 +-
 arch/mips/au1000/pb1100/board_setup.c             |    4 +-
 arch/mips/au1000/pb1500/board_setup.c             |    6 +-
 arch/mips/mm/pg-r4k.c                             |    2 +-
 arch/mips/pci/ops-mace.c                          |   21 +-
 arch/powerpc/platforms/pseries/xics.c             |    2 +-
 arch/sparc/kernel/ebus.c                          |    2 +
 arch/sparc64/kernel/binfmt_aout32.c               |    4 +-
 arch/sparc64/kernel/ebus.c                        |    5 +-
 arch/sparc64/kernel/pci_common.c                  |    4 +-
 arch/sparc64/kernel/prom.c                        |    3 +-
 arch/sparc64/kernel/smp.c                         |    2 +
 arch/sparc64/kernel/vio.c                         |   29 ++-
 arch/sparc64/lib/NGcopy_from_user.S               |    8 +-
 arch/sparc64/lib/NGcopy_to_user.S                 |    8 +-
 arch/sparc64/lib/NGmemcpy.S                       |  371 ++++++++++++---------
 drivers/ata/ata_piix.c                            |    7 +
 drivers/ata/pata_ixp4xx_cf.c                      |    3 +
 drivers/ata/pata_marvell.c                        |    4 +-
 drivers/ata/sata_mv.c                             |   35 ++-
 drivers/base/core.c                               |   10 +-
 drivers/char/Makefile                             |    2 +-
 drivers/char/agp/intel-agp.c                      |    5 -
 drivers/char/random.c                             |   10 +-
 drivers/char/vt_ioctl.c                           |    4 +-
 drivers/firewire/Kconfig                          |    3 +-
 drivers/ide/ppc/pmac.c                            |    1 +
 drivers/isdn/i4l/isdn_common.c                    |    5 +-
 drivers/net/mv643xx_eth.c                         |    1 -
 drivers/net/qla3xxx.c                             |    7 +
 drivers/net/r8169.c                               |   16 +-
 drivers/net/sky2.c                                |    3 -
 drivers/net/usb/dm9601.c                          |    2 +-
 drivers/net/wireless/bcm43xx/bcm43xx_wx.c         |    2 +-
 drivers/scsi/aic94xx/aic94xx_task.c               |    4 +-
 drivers/scsi/megaraid.c                           |    8 +
 drivers/serial/serial_cs.c                        |    1 +
 fs/aio.c                                          |    2 +-
 fs/binfmt_flat.c                                  |    6 +-
 fs/lockd/svclock.c                                |    4 +-
 fs/ocfs2/localalloc.c                             |    4 +-
 include/asm-blackfin/mach-bf533/bfin_serial_5xx.h |   11 +-
 include/asm-blackfin/mach-bf537/bfin_serial_5xx.h |   23 +-
 include/asm-blackfin/mach-bf537/portmux.h         |   35 ++-
 include/asm-blackfin/mach-bf561/bfin_serial_5xx.h |   11 +-
 include/asm-blackfin/portmux.h                    |   55 +++
 include/asm-blackfin/unistd.h                     |   56 +++-
 include/asm-h8300/flat.h                          |    3 +-
 include/asm-m32r/flat.h                           |    3 +-
 include/asm-m68knommu/flat.h                      |    3 +-
 include/asm-mips/cmpxchg.h                        |  107 ++++++
 include/asm-mips/local.h                          |   69 +----
 include/asm-mips/system.h                         |  261 +---------------
 include/asm-sh/flat.h                             |    3 +-
 include/asm-v850/flat.h                           |    4 +-
 include/asm-x86_64/processor.h                    |    2 +-
 include/linux/sched.h                             |    2 +-
 include/linux/writeback.h                         |    2 +-
 include/net/rose.h                                |    2 +-
 kernel/sched_fair.c                               |   10 +
 kernel/signal.c                                   |   22 +-
 kernel/time/timer_stats.c                         |    5 +-
 lib/Kconfig.debug                                 |    2 +
 lib/Makefile                                      |    4 +-
 mm/Kconfig                                        |    1 +
 mm/filemap.c                                      |    1 +
 mm/fremap.c                                       |    2 +-
 mm/memory.c                                       |   23 +-
 mm/page-writeback.c                               |    4 +-
 net/ieee80211/ieee80211_rx.c                      |    6 +
 net/ieee80211/softmac/ieee80211softmac_wx.c       |    2 +-
 net/ipv4/tcp_input.c                              |    3 +
 net/ipv6/ndisc.c                                  |    9 +-
 net/rose/rose_loopback.c                          |    4 +-
 net/rose/rose_route.c                             |   15 +-
 net/sched/cls_u32.c                               |    2 +-
 net/sched/sch_sfq.c                               |   47 ++-
 86 files changed, 1254 insertions(+), 701 deletions(-)
 create mode 100644 Documentation/lockstat.txt
 create mode 100644 include/asm-mips/cmpxchg.h
