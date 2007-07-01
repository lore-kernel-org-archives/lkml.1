Return-Path: <linux-kernel-owner+w=401wt.eu-S1755447AbXGAVce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447AbXGAVce (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 17:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750889AbXGAVc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 17:32:27 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42491 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750738AbXGAVc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 17:32:26 -0400
Date: Sun, 1 Jul 2007 14:32:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.22-rc7
Message-ID: <alpine.LFD.0.98.0707011427380.1172@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Ok, Linux-2.6.22-rc7 is out there.

It's hopefully (almost certainly) the last -rc before the final 2.6.22 
release, and we should be in pretty good shape. The flow of patches has 
really slowed down and the regression list has shrunk a lot.

The shortlog/diffstat reflects that, with the biggest part of the -rc7 
patch being literally just a power defconfig update.

The patches are mostly trivial fixes, a few new device ID's, and the 
appended shortlog really does pretty much explain it.

Final testing always appreciated, of course,

		Linus

---
Alan Cox (1):
      HPT374 is UDMA100 not UDMA133

Alexander Gattin (1):
      USB: add new device id to option driver

Alexey Dobriyan (3):
      mips-jazz: correct flags for timer io resource
      [SPARC64]: Add linux/pagemap.h to asm/tlb.h
      frv: fix fallout from "remove sched.h from mm.h" patch

Andrew Morton (2):
      ext2: fix return of uninitialised variable
      i386: mtrr crash fix

Atsushi Nemoto (1):
      [MIPS] Remove a duplicated local variable in test_and_clear_bit()

Bjorn Helgaas (3):
      smsc-ircc2: skip preconfiguration for PNP devices
      PNP SMCf010 quirk: auto-config device if BIOS left it broken
      smsc-ircc2: bypass PNP detection until we get the quirks worked out

Björn Steinbrink (1):
      fix nmi_watchdog=2 bootup hang

Catalin Marinas (1):
      [ARM] 4452/1: Force the literal pool dump before reloc_end

Chris Dearman (1):
      [MIPS] Count timer interrupts correctly.

Christoph Lameter (1):
      SLAB: remove WARN_ON_ONCE for zero sized objects for 2.6.22 release

David S. Miller (3):
      [SPARC64]: Add irqs to mdesc_node.
      [SPARC64]: Fix VIRQ enabling.
      [SPARC64]: Need to set state to IDLE during sun4v IRQ enable.

David Wilder (1):
      relay file read: start-pos fix

David Woodhouse (1):
      Introduce fixed sys_sync_file_range2() syscall, implement on PowerPC and ARM

Davide Libenzi (1):
      avoid spurious POLLIN returns in signalfd

Dean Nelson (1):
      [IA64] change sh_change_coherence oemcall to use nolock

Divy Le Ray (1):
      cxgb3 - fix register to stop bc/mc traffic

Evgeniy Polyakov (1):
      w1_therm_read_bin: don't call flush_signals()

Hugh Dickins (1):
      mm: kill validate_anon_vma to avoid mapcount BUG

Ian Romanick (1):
      Add support SiS based XGI chips to SiS DRM.

Jarek Poplawski (1):
      [NETPOLL] netconsole: fix soft lockup when removing module

Jay Lubomirski (1):
      serial: clear proper MPSC interrupt cause bits

Jeff Mahoney (1):
      saa7134: fix thread shutdown handling

Jes Sorensen (1):
      [IA64] Make SN2 PCI code use ioremap rather than manually mangle the address

Keith Owens (1):
      [IA64] Correct unwind validation code

Kumar Gala (1):
      phy: Fix phy_id for Vitesse 824x PHY

Linus Torvalds (2):
      i386: remove bogus mtrr range check
      Linux 2.6.22-rc7

Luiz Fernando N. Capitulino (1):
      USB: ftdio_sio: New IPlus device ID

MUNEDA Takahiro (1):
      [IA64] remove duplicate header include line

Masami Hiramatsu (1):
      relayfs: fix overwrites

Maxime Austruy (1):
      asus_acpi: fix oops on non-asus machines

Michael Halcrow (3):
      eCryptfs: fix write zeros behavior
      eCryptfs: initialize crypt_stat in setattr
      zero out last page for llseek/write

Neil Horman (2):
      SCTP: update sctp_getsockopt helpers to allow oversized buffers
      SCTP: Fix sctp_getsockopt_get_peer_addrs

Nicolas Pitre (1):
      [ARM] 4449/1: more entries in arch/arm/boot/.gitignore

Olaf Hering (2):
      2.6.22: ERROR: "__ucmpdi2" [drivers/net/s2io.ko] undefined!
      fix section mismatch in chipsfb

Oleg Nesterov (1):
      USB: g_file_storage: call allow_signal()

Oliver Neukum (4):
      USB: ti serial driver sleeps with spinlock held
      USB: memory leak in iowarrior.c
      USB: usblcd doesn't limit memory consumption during write
      USB: fix race leading to use after free in io_edgeport

Paul Mackerras (2):
      [POWERPC] Update defconfigs
      [POWERPC] Fix subtle FP state corruption bug in signal return on SMP

Pavel Kiryukhin (1):
      [MIPS] use compat_siginfo in rt_sigframe_n32

Rafael J. Wysocki (1):
      PM: introduce set_target method in pm_ops

Ralf Baechle (6):
      [MIPS] __ucmpdi2 arguments are unsigned long long.
      [MIPS] AP/SP requires shadow registers, auto enable support.
      [MIPS] 20K: Handle WAIT related bugs according to errata information
      [MIPS] EMMA2RH: Disable GEN_RTC, it can't possibly work.
      [MIPS] SMTC and non-SMTC kernel and modules are incompatible
      au1000_eth: Fix warnings.

Randy Dunlap (9):
      pata_it821x: fix section mismatch warning
      eventfd: clean compile when CONFIG_EVENTFD=n
      mtrr/cyrix: fix sections
      IOATDMA: fix section mismatches
      ALSA: fix ice1712 section mismatch
      ALSA: use __devexit_p
      [IRDA]: fix printk format
      ALSA: more section mismatches
      pci.h stubs (for EDD build error)

Russ Anderson (1):
      [IA64] Force error to surface in nofault code

Russell King (2):
      [ARM] Add support for pause_on_oops and display preempt/smp options
      [ARM] Update show_regs/oops register format

Siddha, Suresh B (1):
      x86_64 irq: use mask/unmask and proper locking in fixup_irqs()

Stefan Richter (1):
      Documentation/HOWTO: update URLs of git trees

Stephen Hemminger (3):
      [NETPOLL]: tx lock deadlock fix
      remove leftover documentation of acpi_generic_hotkey
      blink driver power saving

Suresh Siddha (1):
      x86_64: set the irq_chip name for lapic

Tejun Heo (9):
      libata: kill the infamous abnormal status message
      libata: kill non-sense warning message
      libata: be less verbose about hpa
      libata: remove unused variable from ata_eh_reset()
      libata: fix ata_dev_disable()
      libata: fix infinite EH waiting bug
      libata: call ata_check_atapi_dma() with qc better prepared
      libata: use PIO for non-16 byte aligned ATAPI commands
      libata: kill ATA_HORKAGE_DMA_RW_ONLY

Tony Breeds (1):
      [POWERPC] Fix VDSO gettimeofday() when called with NULL struct timeval

Trent Piepho (1):
      Fix Kconfig dependency problems wrt boolean menuconfigs

Ville Syrjala (1):
      atyfb: Fix XCLK frequency on Apple iBook1

Will Schmidt (1):
      Fix VDSO gettimeofday() when called with NULL struct timeval.

Yoichi Yuasa (4):
      [MIPS] add io_map_base to pci_controller on Cobalt
      [MIPS] remove "support for" from system type entry
      [MIPS] Alchemy: Fix wrong cast
      [MIPS] Fix pb1500 reg B access

Zach Brown (1):
      SCTP: lock_sock_nested in sctp_sock_migrate

vignesh babu (1):
      [IA64] is_power_of_2-ia64/mm/hugetlbpage.c

will schmidt (1):
      [POWERPC] Update g5_defconfig

---
 Documentation/HOWTO                           |   28 +-
 Documentation/kernel-parameters.txt           |    5 -
 Makefile                                      |    2 +-
 arch/arm/boot/.gitignore                      |    3 +
 arch/arm/boot/compressed/head.S               |    1 +
 arch/arm/kernel/calls.S                       |    2 +-
 arch/arm/kernel/process.c                     |   63 ++--
 arch/arm/kernel/sys_arm.c                     |   13 -
 arch/arm/kernel/traps.c                       |   20 +-
 arch/arm/mach-at91/pm.c                       |    4 +-
 arch/i386/kernel/cpu/mtrr/cyrix.c             |    4 +-
 arch/i386/kernel/cpu/mtrr/generic.c           |    8 +-
 arch/ia64/kernel/time.c                       |    1 -
 arch/ia64/kernel/unwind.c                     |   16 +-
 arch/ia64/mm/hugetlbpage.c                    |    3 +-
 arch/ia64/sn/kernel/xp_nofault.S              |    3 +-
 arch/ia64/sn/pci/pcibr/pcibr_provider.c       |    7 +-
 arch/ia64/sn/pci/tioca_provider.c             |    4 +-
 arch/ia64/sn/pci/tioce_provider.c             |    4 +-
 arch/mips/Kconfig                             |    5 +-
 arch/mips/au1000/pb1100/init.c                |    2 +-
 arch/mips/au1000/pb1500/board_setup.c         |    2 +-
 arch/mips/cobalt/pci.c                        |    1 +
 arch/mips/configs/emma2rh_defconfig           |    3 +-
 arch/mips/jazz/setup.c                        |    2 +-
 arch/mips/kernel/cpu-probe.c                  |   12 +-
 arch/mips/kernel/signal32.c                   |   62 ----
 arch/mips/kernel/signal_n32.c                 |    6 +-
 arch/mips/kernel/smtc.c                       |    2 +-
 arch/mips/lib/ucmpdi2.c                       |    2 +-
 arch/powerpc/configs/cell_defconfig           |  243 ++++++--------
 arch/powerpc/configs/celleb_defconfig         |  169 +++------
 arch/powerpc/configs/chrp32_defconfig         |  353 +++++++++++--------
 arch/powerpc/configs/ebony_defconfig          |  138 +++-----
 arch/powerpc/configs/g5_defconfig             |  342 ++++++++++---------
 arch/powerpc/configs/holly_defconfig          |  125 +++-----
 arch/powerpc/configs/iseries_defconfig        |   36 +--
 arch/powerpc/configs/linkstation_defconfig    |  384 +++++++++------------
 arch/powerpc/configs/lite5200_defconfig       |  182 +++++------
 arch/powerpc/configs/maple_defconfig          |  248 ++++++--------
 arch/powerpc/configs/pasemi_defconfig         |   58 +---
 arch/powerpc/configs/pmac32_defconfig         |  375 ++++++++++-----------
 arch/powerpc/configs/ppc64_defconfig          |  460 +++++++++++++++---------
 arch/powerpc/configs/prpmc2800_defconfig      |   98 ++----
 arch/powerpc/configs/ps3_defconfig            |   79 +----
 arch/powerpc/configs/pseries_defconfig        |  387 +++++++++++++---------
 arch/powerpc/kernel/signal_64.c               |   10 +-
 arch/powerpc/kernel/sys_ppc32.c               |    9 +
 arch/powerpc/kernel/vdso32/gettimeofday.S     |    4 +-
 arch/powerpc/kernel/vdso64/gettimeofday.S     |    7 +-
 arch/sparc64/kernel/irq.c                     |   12 +-
 arch/x86_64/kernel/io_apic.c                  |    1 +
 arch/x86_64/kernel/irq.c                      |   32 ++-
 drivers/acpi/asus_acpi.c                      |    3 +-
 drivers/ata/libata-core.c                     |   56 +--
 drivers/ata/libata-eh.c                       |    7 +-
 drivers/ata/libata-scsi.c                     |   20 +-
 drivers/ata/pata_hpt37x.c                     |    4 +-
 drivers/ata/pata_it821x.c                     |    2 +-
 drivers/atm/Kconfig                           |    2 +-
 drivers/char/drm/drm_pciids.h                 |    2 +
 drivers/char/drm/sis_drv.h                    |    8 +-
 drivers/dma/ioatdma.c                         |    8 +-
 drivers/media/dvb/Kconfig                     |    2 +-
 drivers/media/radio/Kconfig                   |    2 +-
 drivers/media/video/Kconfig                   |    6 +-
 drivers/media/video/saa7134/saa7134-tvaudio.c |    2 +-
 drivers/misc/blink.c                          |   22 +-
 drivers/net/au1000_eth.c                      |    2 +-
 drivers/net/cxgb3/xgmac.c                     |    8 +-
 drivers/net/irda/irport.c                     |    2 +-
 drivers/net/irda/smsc-ircc2.c                 |   16 +-
 drivers/net/pcmcia/Kconfig                    |    2 +-
 drivers/net/phy/mdio_bus.c                    |    3 +-
 drivers/net/phy/vitesse.c                     |    2 +-
 drivers/net/s2io.c                            |   16 +-
 drivers/pnp/quirks.c                          |   66 +++-
 drivers/serial/mpsc.c                         |    3 +-
 drivers/usb/gadget/file_storage.c             |   12 +-
 drivers/usb/misc/iowarrior.c                  |    7 +-
 drivers/usb/misc/usblcd.c                     |   22 +-
 drivers/usb/serial/ftdi_sio.c                 |    1 +
 drivers/usb/serial/ftdi_sio.h                 |    1 +
 drivers/usb/serial/io_edgeport.c              |    4 +-
 drivers/usb/serial/option.c                   |    6 +-
 drivers/usb/serial/ti_usb_3410_5052.c         |    8 +-
 drivers/video/aty/atyfb_base.c                |   17 +-
 drivers/video/chipsfb.c                       |    6 +-
 drivers/w1/slaves/w1_therm.c                  |    6 +-
 fs/ecryptfs/ecryptfs_kernel.h                 |    2 +
 fs/ecryptfs/inode.c                           |   66 ++++-
 fs/ecryptfs/mmap.c                            |   55 ++--
 fs/ext2/super.c                               |    1 +
 fs/signalfd.c                                 |    3 +-
 fs/sync.c                                     |    8 +
 include/asm-arm/ptrace.h                      |    3 -
 include/asm-arm/unistd.h                      |    1 +
 include/asm-frv/pgtable.h                     |    2 +-
 include/asm-i386/paravirt.h                   |    2 +-
 include/asm-ia64/sn/sn_sal.h                  |    4 +-
 include/asm-mips/bitops.h                     |    2 +-
 include/asm-mips/compat-signal.h              |   62 ++++
 include/asm-mips/module.h                     |    9 +-
 include/asm-powerpc/systbl.h                  |    1 +
 include/asm-powerpc/unistd.h                  |    3 +-
 include/asm-sparc64/mdesc.h                   |    1 +
 include/asm-sparc64/tlb.h                     |    1 +
 include/linux/eventfd.h                       |    3 +-
 include/linux/libata.h                        |    9 +-
 include/linux/pci.h                           |   11 +
 include/linux/pm.h                            |   62 +++-
 include/linux/syscalls.h                      |    2 +
 kernel/power/main.c                           |    6 +-
 kernel/relay.c                                |   11 +-
 mm/rmap.c                                     |   24 +--
 mm/slab.c                                     |    1 -
 net/core/netpoll.c                            |   30 +-
 net/sctp/socket.c                             |  120 +++++--
 scripts/checksyscalls.sh                      |    5 +
 sound/drivers/mts64.c                         |    2 +-
 sound/isa/opl3sa2.c                           |    2 +-
 sound/oss/sb_card.c                           |    2 +-
 sound/pci/ice1712/prodigy192.c                |    2 +-
 123 files changed, 2506 insertions(+), 2410 deletions(-)
