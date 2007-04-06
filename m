Return-Path: <linux-kernel-owner+w=401wt.eu-S1767420AbXDFCu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767420AbXDFCu0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 22:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767416AbXDFCu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 22:50:26 -0400
Received: from smtp.osdl.org ([65.172.181.24]:35096 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767273AbXDFCuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 22:50:20 -0400
Date: Thu, 5 Apr 2007 19:50:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.21-rc6
Message-ID: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Ok,
 I don't think there really is anything very interesting here, but we're 
hopefully whittling down the list of regressions, and fixing various 
random other small issues while at it.

Some smallish MIPS updates, networking (and network driver) fixes, removal 
of a long obsolete framebuffer driver, etc etc. The shortlog really tells 
the story.

We should be getting close to a 2.6.21 release, so please update any 
regression reports you've done,

		Linus

---
Adrian Bunk (6):
      [DCCP]: make dccp_write_xmit_timer() static again
      9p: make struct v9fs_cached_file_operations static
      drivers/spi/: fix section mismatches
      drivers/eisa/pci_eisa.c:pci_eisa_init() should be init
      drivers/mfd/sm501.c: fix an off-by-one
      net/sunrpc/svcsock.c: fix a check

Alan Cox (2):
      tty: minor merge correction
      pata_pdc202xx_old: LBA48 bug

Alan Stern (1):
      UHCI: Fix problem caused by lack of terminating QH

Albert Lee (5):
      pdc202xx_new: Enable ATAPI DMA
      libata: reorder HSM_ST_FIRST for easier decoding (take 3)
      libata: Clear tf before doing request sense (take 3)
      libata: Limit max sector to 128 for TORiSAN DVD drives (take 3)
      libata: Limit ATAPI DMA to R/W commands only for TORiSAN DVD drives (take 3)

Alexey Dobriyan (1):
      [NET]: Correct accept(2) recovery after sock_attach_fd()

Alexey Kuznetsov (1):
      [NET]: Fix neighbour destructor handling.

Andi Kleen (3):
      x86-64: Disable local APIC timer use on AMD systems with C1E
      x86-64: Let oprofile reserve MSR on all CPUs
      x86-64: Increase NMI watchdog probing timeout

Andreas Oberritter (2):
      V4L/DVB (5495): Tda10086: fix DiSEqC message length
      V4L/DVB (5496): Pluto2: fix incorrect TSCR register setting

Andrew Morton (4):
      proc: fix linkage with CONFIG_SYSCTL=y, CONFIG_PROC_SYSCTL=n
      revert "retries in ext3_prepare_write() violate ordering requirements"
      revert "retries in ext4_prepare_write() violate ordering requirements"
      remove protection of LANANA-reserved majors

Andrew Victor (1):
      [ARM] 4289/1: AT91: SAM9260 NAND flash timing

Arnaldo Carvalho de Melo (1):
      [DCCP] getsockopt: Fix DCCP_SOCKOPT_[SEND,RECV]_CSCOV

Avi Kivity (1):
      KVM: Prevent system selectors leaking into guest on real->protected mode transition on vmx

Ayaz Abdulla (2):
      forcedeth: fix nic poll
      forcedeth: fix tx timeout

Bartlomiej Zolnierkiewicz (2):
      ide: revert "ide: fix drive side 80c cable check, take 2" for now
      ide: fix locking for manual DMA enable/disable ("hdparm -d")

Bill Helfinstine (1):
      b44: fix IFF_ALLMULTI handling of CAM slots

Brian Pomerantz (1):
      fix page leak during core dump

Brice Goglin (1):
      myri10ge: correctly detect when TSO should be used

Bruce Fields (2):
      knfsd: nfsd4: fix inheritance flags on v4 ace derived from posix default ace
      knfsd: nfsd4: demote "clientid in use" printk to a dprintk

Carsten Otte (1):
      mm: fix xip issue with /dev/zero

Chris Dearman (2):
      [MIPS] lockdep: Handle interrupts in R3000 style c0_status register.
      [MIPS] lockdep: Deal with interrupt disable hazard in TRACE_IRQFLAGS

Chris Snook (1):
      atl1: save mac address on remove

Chuck Meade (1):
      [POWERPC] qe: Fix QUICC Engine SDMA setup errors

Conke Hu (1):
      ahci.c: walkaround for SB600 SATA internal error issue

Cornelia Huck (2):
      [S390] cio: Device status validity.
      [S390] cio: Fix handling of interrupt for csch().

Cyrill V. Gorcunov (1):
      SUN3/3X Lance trivial fix improved

Daniel Drake (1):
      generic_serial: fix decoding of baud rate

David Brownell (4):
      USB: omap_udc: workaround dma_free_coherent() bogosity
      USB: fix usb-serial/generic build warning
      USB: fix usb-serial/ftdi build warning
      rtc-cmos lockdep fix, irq updates

David Howells (1):
      SLAB: Mention slab name when listing corrupt objects

David S. Miller (4):
      [IPV6]: Fix routing round-robin locking.
      [DRM]: Delete sparc64 FFB driver code that never gets built.
      [VIDEO] ffb: Fix two DAC handling bugs.
      [SCSI]: Fix scsi_send_eh_cmnd scatterlist handling

David Wilder (1):
      [S390] kprobes: Align probe address.

David Woodhouse (1):
      bcm43xx: Fix machine check on PPC for version 1 PHY

Divy Le Ray (4):
      cxgb3 - Safeguard TCAM size usage
      cxgb3 - detect NIC only adapters
      cxgb3 - Tighten xgmac workaround
      cxgb3 - Firwmare update

Dmitriy Monakhov (1):
      splice: partial write fix

Erez Zilber (1):
      IB/iser: Handle aborting a command after it is sent

Eric W. Biederman (4):
      MSI-X: fix resume crash
      pid: Properly detect orphaned process groups in exit_notify
      msi: synchronously mask and unmask msi-x irqs.
      net: Ignore sysfs network device rename bugs.

Francois Romieu (3):
      sis190: new PHY support
      r8169: issue request_irq after the private data are completely initialized
      r8169: fix suspend/resume for down interface

G. Liakhovetski (1):
      [PPP]: Don't leak an sk_buff on interface destruction.

Gabriel Paubert (1):
      mv643xx_eth: Fix use of uninitialized port_num field

Guennadi Liakhovetski (1):
      [ARM] 4295/2: Fix error-handling in pxaficp_ir.c (version 2)

Hans Verkuil (1):
      V4L/DVB (5415): Msp_attach must return 0 if no msp3400 was found.

Heiko Carstens (1):
      [S390] Fix TCP/UDP pseudo header checksum computation.

Herbert Xu (5):
      [IPV6]: Set IF_READY if the device is up and has carrier
      [CRYPTO] api: Use the right value when advancing scatterwalk_copychunks
      crypto api: Use the right value when advancing scatterwalk_copychunks
      [CRYPTO] api: Flush the current page right than the next
      [IPSEC]: Reject packets within replay window but outside the bit mask

Hugh Dickins (4):
      holepunch: fix shmem_truncate_range punching too far
      holepunch: fix shmem_truncate_range punch locking
      holepunch: fix disconnected pages after second truncate
      holepunch: fix mmap_sem i_mutex deadlock

Ingo Molnar (2):
      KVM: always reload segment selectors
      hrtimers: fix reprogramming SMP race

J. Bruce Fields (1):
      knfsd: nfsd4: remove superfluous cancel_delayed_work() call

Jack Steiner (1):
      [IA64] Speed up boot - skip unnecessary clock calibration

Jan Beulich (1):
      kbuild: fix dependency generation

Jason Lunz (1):
      uml: fix LVM crash

Jay Cliburn (1):
      atl1: remove unnecessary crc inversion

Jean Delvare (3):
      PCI: Stop unhiding the SMBus on Toshiba laptops
      V4L/DVB (5421): Fix suspend/resume in msp3400 and tuner
      [APPLETALK]: Fix a remotely triggerable crash

Jean Tourrilhes (2):
      wext: Add missing ioctls to 64<->32 conversion
      WE-22 : prevent information leak on 64 bit

Jean-Christophe Dubois (1):
      [POWERPC] Fix dcr_unmap()

Jeff Dike (7):
      uml: fix epoll
      uml: fix static linking
      uml: use correct register file size everywhere
      uml: fix I/O hang when multiple devices are in use
      uml: fix device unplug crash
      uml: irq locking fixes
      uml: fix compilation problems

Jeff Garzik (1):
      [libata] Disable ACPI by default; fix namespace problems

Jens Axboe (1):
      Maxtor 6B250S0/BANC1B70 hangs with NCQ

Jiri Kosina (3):
      ISDN: fix BChannel_bh() call from isar_bh()
      oprofile: fix potential deadlock on oprofilefs_lock
      bluetooth hid quirks: mightymouse quirk

Joerg Dorchain (1):
      [SCSI] gdth: fix oops in gdth_copy_cmd()

John Heffner (1):
      [TCP]: Do receiver-side SWS avoidance for rcvbuf < MSS.

John Stultz (3):
      correct slow acpi_pm rating
      ntp: avoid time_offset overflows
      fix jiffies clocksource inittime

Jon K Hellan (1):
      USB: remove duplicated device id in airprime driver

Jonathan Corbet (1):
      PCI: Fix up PCI power management doc

Judith Lebzelter (1):
      [SCSI] mptsas: Fix oops for insmod during kexec

KAMEZAWA Hiroyuki (1):
      [IA64] bugfix stack layout upside-down

Kay Sievers (1):
      driver core: fix built-in drivers sysfs links

Kenji Kaneshige (1):
      [IA64] Fix possible invalid memory access in ia64_setup_msi_irq()

Kristoffer Ericson (1):
      sh: Trivial fix for hp6xx build.

Larry Finger (1):
      bcm43xx: Fix code for confusion between PHY revision and PHY version

Len Brown (1):
      Revert "ACPI: parse 2nd MADT by default"

Lennert Buytenhek (1):
      [ARM] 4298/1: fix memory barriers for DMA coherent and SMP platforms

Linas Vepstas (1):
      [SCSI] lpfc: avoid double-free during PCI error failure

Linsys Contractor Adhiraj Joshi (1):
      NetXen: Fix hardware access for ppc architecture.

Linus Torvalds (2):
      driver core: do not wait unnecessarily in driver_unregister()
      Linux 2.6.21-rc6

Maciej Zenczykowski (1):
      ia64: desc_empty thinko/typo fix

Mark Fasheh (1):
      Export __splice_from_pipe()

Mark Lord (2):
      2.6.21 fix lba48 bug in libata fill_result_tf()
      libata bugfix: preserve LBA bit for HDIO_DRIVE_TASK

Mark Mason (1):
      [MIPS] BCM1480: Fix setting of irq affinity.

Markus Lidel (1):
      I2O: remove Markus from MAINTAINERS

Martin Schwidefsky (1):
      [S390] page_mkclean data corruption.

Matt Domsch (1):
      pci: set pci=bfsort for PowerEdge R900

Mauro Carvalho Chehab (1):
      V4L/DVB (5408): Fix SECAM handling on saa7115

Maxim Levitsky (1):
      Add suspend/resume for HPET

Michael Chan (5):
      [TG3]: Eliminate the unused TG3_FLAG_SPLIT_MODE flag.
      [TG3]: Exit irq handler during chip reset.
      [TG3]: Update version and reldate.
      [BNX2]: Fix link interrupt problem.
      [BNX2]: Fix nvram write logic.

Michael S. Tsirkin (1):
      IB/mthca: Fix thinko in init_mr_table()

Michal Januszewski (1):
      vt: fix potential race in VT_WAITACTIVE handler

Mika Kukkonen (1):
      Fix kernel build with EMBEDDED & PROC_FS & !PROC_SYSCTL

Mikael Pettersson (1):
      [SPARC]: sparc64 gcc-4.2.0 20070317 -Werror failure

Mike Miller (OS Dev) (1):
      cciss: add init of drv->cylinders back to cciss_geometry_inquiry

Miklos Szeredi (1):
      uml: fix pte bit collision

Mitsuru Chinen (1):
      [IPv6]: Exclude truncated packets from InHdrErrors statistics

NeilBrown (5):
      knfsd: allow nfsd READDIR to return 64bit cookies
      md: allow raid4 arrays to be reshaped
      md: clear the congested_fn when stopping a raid5
      md: convert compile time warnings into runtime warnings
      md: avoid a deadlock when removing a device from an md array via sysfs

Nick Piggin (2):
      1/2 splice: dont steal
      2/2 splice: dont readpage

Oliver Endriss (1):
      V4L/DVB (5441): Saa7146: Fix allocation of clipping memory

Oliver Neukum (1):
      USB: another entry for the quirk list

Paolo 'Blaisorblade' Giarrusso (3):
      uml: hostfs variable renaming
      uml: fix static linking for real
      uml: fix unreasonably long udelay

Patrick McHardy (5):
      [NET_SCHED]: cls_basic: fix NULL pointer dereference
      [NET_SCHED]: Fix ingress locking
      [NET_SCHED]: sch_htb/sch_hfsc: fix oops in qlen_notify
      [IFB]: Fix crash on input device removal
      [NET_SCHED]: cls_basic: fix memory leak in basic_destroy

Patrick Ringl (1):
      ide: cosmetic adaption of drivers/ide/Kconfig concerning SATA

Paul Mundt (2):
      sh: Kill bogus GCC4 symbol exports.
      sh: Fixup __cmpxchg() compile breakage with gcc4.

Paul Rolland (1):
      ata: NCQ is broken on Maxtor 6L250S0

Peter Oberparleiter (1):
      [S390] dasd: Work around gcc bug.

Petr Vandrovec (1):
      Correctly report PnP 64bit resources

Prarit Bhargava (1):
      PCI: Fix warning message in PCIE port driver

Rafael J. Wysocki (3):
      Revert "swsusp: disable nonboot CPUs before entering platform suspend"
      Fix microcode-related suspend problem
      swsusp: fix memory shrinker

Ralf Baechle (11):
      [NET] AX.25 Kconfig and docs updates and fixes
      Wire up DEC serial drivers in Kconfig
      [MIPS] Ocelot: Give PMON_v1_setup a proper prototype.
      [MIPS] Ocelot: Fix warning.
      [MIPS] EV64120: Include <asm/irq.h> to fix warning.
      [MIPS] MT: MIPS_MT_SMTC_INSTANT_REPLAY currently conflicts with PREEMPT.
      [MIPS] MV64340: Add missing prototype for mv64340_irq_init().
      [MIPS] SMTC: irq_{enter,leave} and kstats keeping for relayed timer ints.
      [MIPS] SMTC: Fix false trigger of debug code on single VPE.
      [MIPS] do_page_fault() needs to use raw_smp_processor_id().
      [MIPS] SMTC: Fix recursion in instant IPI replay code.

Ralph Wuerthner (2):
      [S390] zcrypt: Fix possible dead lock in AP bus module.
      [S390] zcrypt: Fix ap_poll_requests counter in lost requests error path.

Robert Hancock (1):
      libata: add NCQ blacklist entries from Silicon Image Windows driver (v2)

Robert Olsson (1):
      [IPV4] fib_trie: Document locking.

Robert P. J. Day (2):
      [NET]: remove unused header file: drivers/net/wan/lmc/lmc_media.h
      [NET]: Remove dead net/sched/Makefile entry for sch_hpfq.o.

Robert Reif (3):
      [SPARC32]: Fix SMP build regression
      [VIDEO]: Fix section mismatch in cg3.c
      [SPARC]: Add unsigned to unused bit field in a.out.h

Ron Mercer (4):
      qla3xxx: bugfix: Add tx control block memset.
      qla3xxx: bugfix: Multi segment sends were getting whacked.
      qla3xxx: bugfix: Dropping interrupt under heavy network load.
      qla3xxx: bugfix: Jumbo frame handling.

Ruben Vandeginste (1):
      [SUNGEM]: Fix MAC address setting when interface is up.

Russ Cox (1):
      Add const to pointer qualifiers for __chk_user_ptr and __chk_io_ptr.

Russell King (2):
      [ARM] Export dma_channel_active()
      [ARM] Fix __NR_kexec_load

Salyzyn, Mark (1):
      adaptec MAINTAINERS updates

Serge E. Hallyn (2):
      utsns: fix !CONFIG_UTS_NS behavior
      ipcns: fix !CONFIG_IPC_NS behavior

Simon Arlott (1):
      V4L/DVB (5400): Core: fix several locking related problems

Simon Horman (1):
      CPUSETS: add mems to basic usage documentation

Sridhar Samudrala (1):
      [SCTP]: Update SCTP Maintainers entry

Stefano Brivio (1):
      bcm43xx: fix radio_set_tx_iq

Steve Wise (1):
      RDMA/cxgb3: Fix resource leak in cxio_hal_init_ctrl_qp()

Steven Whitehouse (1):
      [NET]: Change "not found" return value for rule lookup

Suleiman Souhlal (1):
      ide: use correct IDE error recovery

Sunil Mushran (2):
      ocfs2_dlm: Fix lockres ref counting bug
      ocfs2_dlm: Check for migrateable lockres in dlm_empty_lockres()

Tejun Heo (1):
      libata: IDENTIFY backwards for drive side cable detection

Thibaut VARENE (1):
      make elv_register() output atomic

Thomas Bittermann (1):
      kernel/time.c: add missing symbol exports

Thomas Gleixner (3):
      clockevents: remove bad designed sysfs support for now
      i386: Fix bogus return value in hpet_next_event()
      i386: fix file_read_actor() and pipe_read() for original i386 systems

Thomas Graf (3):
      [NET]: Fix fib_rules compatibility breakage
      [IPv4] fib: Fix out of bound access of fib_props[]
      [DECNet] fib: Fix out of bound access of dn_fib_props[]

Thomas Viehweger (1):
      V4L/DVB (5472): Isl6421: don't reference freed memory

Tilman Schmidt (1):
      drivers/isdn/gigaset: mark some static data as const (v2)

Timur Tabi (1):
      [POWERPC] qe: ucc_slow.guemr is in the wrong place

Tony Luck (1):
      [IA64] Fix arch/ia64/pci/pci.c:571: warning: `return' with a value

Trent Piepho (1):
      V4L/DVB (5390): Radio: Fix error in Kbuild file

Vasily Averin (1):
      i2o: block IO errors on i2o disk

Vasily Tarasov (1):
      block: blk_max_pfn is somtimes wrong

Venki Pallipadi (1):
      Fix maxcpus=1 trigerring BUG() in cpufreq

Vincent Penne (1):
      V4L/DVB (5332): Ir_rc5_timer_end decoder lockup fix

Vladimir Barinov (1):
      [ARM] 4296/1: ixp4xx: compile fix

YOSHIFUJI Hideaki (1):
      [IPv6]: Fix incorrect length check in rawv6_sendmsg()

Yinghai Lu (1):
      x86_64 irq: Fix comments after changing IRQ0_VECTOR from 0x20 to 0x30

Yoichi Yuasa (2):
      Fix struct device member name in PCMCIA au1000_generic
      Fix build error on zs serial driver

Zach Brown (1):
      aio: remove bare user-triggerable error printk

Zwane Mwaikambo (1):
      x86: Don't probe for DDC on VBE1.2

