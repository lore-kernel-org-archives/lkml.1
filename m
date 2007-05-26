Return-Path: <linux-kernel-owner+w=401wt.eu-S1754862AbXEZDVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbXEZDVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 23:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751811AbXEZDVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 23:21:13 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:54419 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751665AbXEZDVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 23:21:11 -0400
Date: Fri, 25 May 2007 20:21:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux v2.6.22-rc3
Message-ID: <alpine.LFD.0.98.0705252008210.26602@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463790079-1531236494-1180149664=:26602"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463790079-1531236494-1180149664=:26602
Content-Type: TEXT/PLAIN; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT


It's Friday evening, and the US is preparing for a long three-day weekend, 
often considered the official start of summer here. 

So what's a pasty white nerd to do? You can't go out on the beach, because 
the goodlooking people will laugh at you, and kick sand in your face.

I'm not bitter.

But now you _can_ do something: you can download the latest -rc kernel, 
and smile smugly to yourself, knowing that you are running the latest and 
greatest on your machine. And suddenly it doesn't even matter that summer 
is coming, because you can just sit in the basement, and close the blinds, 
and bask in the warm light from your LCD, rather than the harsh glare of 
the daystar..

The geeks with embedded hardware can consider themselves doubly special 
(and not just because your mothers told you you are), because we've got 
updates to ARM, SH and Blackfin.

What more could you possibly want? Some ATA updates? USB suspend problem 
solving? Infiniband? DVB and MMC updates? Network drivers and some fixes 
for silly network problems? Yeah we got them!

So stop worrying about those dangerous ultraviolet rays, and instead get 
your Vitamin D in the form God (and the pharmaceutical industry) intended: 
small easily swallowed pills. Beaches are overrated anyway, the sand gets 
into the laptop fan and soon it won't work.

May you have a great summer,

		Linus

---
Akinobu Mita (3):
      i2o: destroy event queue only when drv->event is set
      i2o: fix notifiers when max_drivers is configured
      i2o: eliminate a peculiar constraint on i2o_max_drivers

Alan Cox (9):
      pata_hpt366: Enable bits are unreliable so don't use them
      ata_piix: clean up
      libata: Kiss post_set_mode goodbye
      ide/pci/serverworks.c: Fix corruption/timeouts with MegaIDE
      hpt3x2n: Correct revision boundary
      pata_sis: Fix and clean up some timing setups
      pata_via: Handle laptops via DMI
      pata: Trivia
      pata_hpt37x: Further improvements based on the IDE updates and vendor drivers

Alan Stern (10):
      EHCI: fix problem with BIOS handoff
      USB: more autosuspend timer stuff
      USB: remove unneeded WARN_ON
      USB: set the correct Interrupt interval in usb_bulk_msg
      USB: remove short initial timeout for device descriptor fetch
      USB: don't try to kzalloc 0 bytes
      USB: make the autosuspend workqueue thread freezable
      USB: handle errors in power/level attribute
      USB: fix ratelimit call semantics
      HiSax: fix error checking for hisax_register()]

Alexey Dobriyan (1):
      Detach sched.h from mm.h

Ali Ayoub (1):
      IB/mthca: Fix use-after-free on device restart

Andi Kleen (7):
      x86_64: Update defconfig
      i386: Update defconfig
      x86_64: Support x86_64 in make buildtar
      i386: Fix K8/core2 oprofile on multiple CPUs
      x86_64: Support gcc 5 properly
      i386: Clear MCE flag on AMD K6
      i386: Enable CX8/PGE CPUID bits early on VIA C3

Andrew Morton (5):
      USB: auerswald: fix file release handler
      ide serverworks warning fixes
      capability.h warning fix
      capifunc warning fixes
      drivers/isdn/hardware/eicon/message.c warning fixes

Andrew Victor (1):
      [ARM] 4378/1: KS8695: Serial driver fix

Andrey Borzenkov (1):
      USB: Fix USB OHCI Subvendor for Toshiba Portege 4000

Anton Altaparmakov (1):
      LDM: Fix for Windows Vista dynamic disks

Anton Blanchard (2):
      [POWERPC] Add missing pmc_type fields in cpu_table
      [POWERPC] Fix typo: MMCR0_PMA0 != MMCR0_PMAO

Arnaud Patard (1):
      i2c-s3c2410: Fix build warning

Atsushi Nemoto (1):
      kbuild: make better section mismatch reports on i386, arm and mips

Aubrey Li (3):
      Blackfin arch: ISP1761 doesn't work for USB flash disk
      Blackfin arch: dma_memcpy borken for > 64K
      Blackfin serial driver: fix overhead issue

Auke Kok (2):
      e1000: Don't enable polling in open() (was: e1000: assertion hit in e1000_clean(), kernel 2.6.21.1)
      Add constant for FCS/CRC length (frame check sequence)

Ayaz Abdulla (1):
      forcedeth: fix cpu irq mask

Badari Pulavarty (1):
      optimize compat_core_sys_select() by a using stack space for small fd sets

Ben Collins (2):
      USB: Remove duplicate IDs from option card driver
      Avoid zero size allocation in cache_k8_northbridges()

Ben Dooks (6):
      [ARM] 4395/1: S3C24XX: add include of <linux/sysdev.h> to relevant machines
      [ARM] 4396/1: S3C2443: Add missing HCLK clocks
      [ARM] 4397/1: S3C2443: remove SDI0/1 IRQ ambiguity
      [ARM] 4398/1: S3C2443: Fix watchdog IRQ number
      [ARM] 4399/2: S3C2443: Fix SMDK2443 nand timings
      [ARM] 4400/1: S3C24XX: Add high-speed MMC device definition

Benjamin Herrenschmidt (2):
      [POWERPC] Fix powerpc vmlinux.lds.S
      [POWERPC] Fix warning in 32-bit builds with CONFIG_HIGHMEM

Bernd Schmidt (1):
      Blackfin arch: fix signal handling bug

Brian Gerst (1):
      i386: fix PGE mask

Bryan Wu (5):
      Blackfin arch: add SPI MMC driver support on bf533-stamp, tested on STAMP-BF533
      Blackfin arch: update blackfin header files to latest one in VDSP.
      Blackfin arch: update defconfig files
      Blackfin arch: update pm.c according to power management API change.
      Blackfin SPI: cleanup according to David Brownell's review

Christian Volkmann (1):
      i386: Fix wrong CPU error message in early boot path

Christoph Hellwig (3):
      sh: revert addition of page fault notifiers
      uselib: add missing MNT_NOEXEC check
      ocfs2: use generic_segment_checks

Christoph Lameter (2):
      SLUB Debug: Fix object size calculation
      SLUB Debug: fix check for super sized slabs (>512k 64bit, >256k 32bit)

Chuck Lever (1):
      NFS: Fix handful of compiler warnings in direct.c

Cornelia Huck (1):
      [S390] cio: Update documentation.

Dan Williams (2):
      [ARM] 4382/1: iop13xx: fix msi support
      [ARM] 4383/1: iop: fix usage of '__init' and 'inline' in iop files

Danny Budik (1):
      USB: Add support for Sierra Wireless Aircard 595U

Dave Jones (1):
      libata: Add Seagate STT20000A to DMA blacklist.

Davi Arnaut (1):
      signalfd: retrieve multiple signals with one read() call

David Brownell (6):
      i2c: Legacy i2c drivers shouldn't issue uevents
      Input: ads7846 - document that it handles tsc2046 too
      USB: fix more ftdi-elan/u132-hcd #include lossage
      USB: handle more rndis_host oddities
      USB: remove usb DocBook warnings
      spi doc update: describe clock mode bits

David Hollis (1):
      asix.c - Add Belkin F5D5055 ids

David Howells (2):
      [AF_RXRPC]: AF_RXRPC depends on IPv4
      [AF_RXRPC]: Make call state names available if CONFIG_PROC_FS=n

David S. Miller (3):
      [DCCP]: Fix build warning when debugging is disabled.
      [CASSINI]: Check pci_set_mwi() return value.
      [XFRM]: Allow packet drops during larval state resolution.

David Woodhouse (2):
      Make 'headerscheck' stop immediately on an error
      Missing 'const' from reiserfs MIN_KEY declaration.

Deepak Saxena (1):
      [IPV6]: Add ip6_tunnel.h to headers_install

Denver Gingerich (1):
      fix compiler warning in fixed.c

Dmitry Torokhov (4):
      Input: adbhid - do not access input_dev->private directly
      Input: ALPS - force stream mode
      Input: ucb1x00-ts - remove commented out code
      USB: Onetouch - switch to using input_dev->dev.parent

Domen Puncer (2):
      mpc52xx_psc_spi: fix it for CONFIG_PPC_MERGE
      spi/spidev: check message size before copying

Domenico Andreoli (1):
      documentation: Documentation/initrd.txt

Eli Cohen (4):
      IB/core: Free umem when mm is already gone
      IB/mlx4: Fix check of max_qp_dest_rdma in modify QP
      IB/mlx4: Pass send queue sizes from userspace to kernel
      IB/mlx4: Initialize send queue entry ownership bits

Eric Piel (1):
      Input: input-polldev - add module info

Eric Sesterhenn / Snakebyte (1):
      Off by one in floppy.c

Eugene Teo (2):
      drivers/net/wireless/libertas/fw.c: fix use-before-check
      drivers/net/wireless/libertas/rx.c: fix use-after-free

Florin Malita (3):
      libertas: skb dereferenced after netif_rx
      spi: potential memleak in spidev_ioctl
      spidernet: skb used after netif_receive_skb

Gautham R Shenoy (2):
      freezer: fix PF_NOFREEZE vs freezeable race
      freezer: move frozen_process() to kernel/power/process.c

Geert Uytterhoeven (1):
      ps3fb: use FB_SYS_* instead of FB_CFB_*

Greg Ungerer (2):
      [ARM] 4387/1: fix /proc/cpuinfo formatting for pre-ARM7 parts
      [ARM] 4388/1: no need for arm/mm mmap range checks for non-mmu

Guido Scholz (1):
      USB: ftdi_sio: Add USB Product Id for OpenDCC

H. Peter Anvin (1):
      boot documentation: clarifications

Hans Verkuil (1):
      V4L/DVB (5670): Adding new fields to v4l2_pix_format broke the ABI, reverted that change

Heiko Carstens (4):
      [S390] Wire up sys_utimensat.
      [S390] Wire up signald, timerfd and eventfd syscalls.
      [S390] Make use of kretprobe_assert.
      [S390] More verbose show_mem() like other architectures.

Henry Su (1):
      add the IDE device ID for ATI SB700

Herbert Xu (4):
      [CRYPTO] api: Read module pointer before freeing algorithm
      [IPSEC] pfkey: Load specific algorithm in pfkey_add rather than all
      [IPSEC]: Fix warnings with casting int to pointer
      [NET_SCHED]: Fix qdisc_restart return value when dequeue is empty

Hoang-Nam Nguyen (1):
      IB/ehca: Return proper error code if register_mr fails

Hugh Dickins (2):
      [POWERPC] Fix smp_call_function to be preempt-safe
      fix compat console unimap regression

Ilpo Järvinen (2):
      [TCP] FRTO: Add missing ECN CWR sending to one of the responses
      [TCP] FRTO: Prevent state inconsistency in corner cases

Imre Deak (1):
      omap_uwire: SPI_CPHA mode bugfix

Ivo van Doorn (1):
      [RFKILL]: Fix check for correct rfkill allocation

Jan Engelhardt (7):
      USB: Fix debug output of ark3116
      [DCCP]: Use menuconfig objects.
      [IPVS]: Use menuconfig objects.
      [SCTP]: Use menuconfig objects.
      [TIPC]: Use menuconfig objects.
      [ARCNET]: Use menuconfig objects.
      [TR]: Use menuconfig objects.

Jarek Poplawski (1):
      Documentation/memory-barriers.txt: various fixes

Jean Delvare (1):
      i2c-tiny-usb: Fix truncated adapter name

Jeff Dike (1):
      uml: improve PTRACE_SYSEMU checking

Jeff Garzik (7):
      libata: Trim trailing whitespace
      libata: bump versions
      partitions/LDM: build fix
      [libata] sata_promise: fix flags typo
      [libata] sata_mv: add TODO list
      [libata] Fix decoding of 6-byte commands
      [libata] sata_via, pata_via: Add PCI IDs.

Jing Min Zhao (5):
      [NETFILTER]: nf_conntrack_h323: fix ASN.1 types
      [NETFILTER]: nf_conntrack_h323: fix get_h225_addr() for IPv6 address access
      [NETFILTER]: nf_conntrack_h323: remove unnecessary process of Information signal
      [NETFILTER]: nf_conntrack_h323: add missing T.120 address in OLCA
      [NETFILTER]: nf_nat_h323: call set_h225_addr instead of set_h225_addr_hook

Jiri Slaby (3):
      Char: cyclades, fix deadlock
      phantom: move to unlocked_ioctl
      Misc: phantom, take care of pci posting

Johann Deneux (2):
      Input: iforce - fix force feedback not working
      Input: iforce - minor clean-ups

John Stultz (1):
      x86_64: vsyscall time() fix

Jon Paul Maloy (1):
      [TIPC]: Fixed erroneous introduction of for_each_netdev

Jonathan Corbet (2):
      V4L/DVB (5690): Cafe_ccic: Properly power down the sensor
      V4L/DVB (5691): Ov7670: reset clkrc in rgb565 mode

Jordan Crouse (1):
      [CRYPTO] geode: Fix in-place operations and set key

Josef 'Jeff' Sipek (1):
      Documentation: Fix up docs still talking about i_sem

Junio C Hamano (1):
      Match DMA blacklist entries between ide-dma.c and libata-core.c

Kenji Kaneshige (1):
      [IA64] fix kmalloc(0) in arch/ia64/pci/pci.c

Kristen Carlson Accardi (2):
      genhd: expose AN to user space
      genhd: send async notification on media change

Kristoffer Ericson (1):
      input: hp680_ts compile fixes.

Krzysztof Helt (3):
      fbdev: cleanup of sparc FB options
      pm2fb: RDAC_WR barriers clean up
      pm3fb: various fixes

Li Yang (5):
      kbuild: add "Section mismatch" warning whitelist for powerpc
      USB: fsl_usb2_udc: Fix UMTI_WIDE support and a compile warning
      ehci-fsl: fix cache coherency problem on system with large memory
      ucc_geth: Fix MODULE_DEVICE_TABLE() duplication
      ucc_geth:trivial fix

Linus Torvalds (5):
      Revert "kbuild: make better section mismatch reports on i386, arm and mips"
      Fix crash with irqpoll due to the IRQF_IRQPOLL flag testing
      Revert "HOWTO: bug report addition" (or "HOWTO: mention bughunting")
      Don't call a warnign a bug. It's a warning.
      Linux 2.6.22-rc3

Maciej W. Rozycki (1):
      declance: Remove a dangling spin_unlock_irq() thingy

Manu Abraham (1):
      V4L/DVB (5639a): Fix dst usage count

Marcel Holtmann (2):
      [Bluetooth] Always send HCI_Reset for Broadcom devices
      [Bluetooth] Fix L2CAP configuration parameter handling

Mariusz Kozlowski (2):
      [ARM] at91_adc parenthesis balance
      chelsio parenthesis fix

Mark Fasheh (3):
      ocfs2: trylock in ocfs2_readpage()
      ocfs2: unmap_mapping_range() in ocfs2_truncate()
      ocfs2: fix inode leak

Matthew Davidson (1):
      usb-storage: ignore Sitecom WL-117 USB-WLAN

Matthias Kaehlcke (1):
      [ATM]: Use mutex instead of binary semaphore in idt77252 driver.

Matthieu CASTET (1):
      V4L/DVB (5680): Tuner-simple.c fix suport for SECAM with FI1216MF

Mauro Carvalho Chehab (2):
      V4L/DVB (5639): Fix Kconfig dependencies for ivtv
      V4L/DVB (5640): Fix: em28xx shouldn't be selecting VIDEO_BUF

Michael Halcrow (1):
      eCryptfs: delay writing 0's after llseek until write

Michael Hennerich (7):
      Blackfin arch: Add Workaround for ANOMALY 05000257
      Blackfin arch: Add configuration data for ISP176x on BF561
      Blackfin arch: Fix reserved map after we changed PORT_H definition
      Blackfin arch: Move write to VR_CTL closer to IDLE
      Blackfin arch: DMA operation cleanup
      Blackfin arch: GPIO fix some defines
      Blackfin arch: Fix bug using usb keyboard crashes kernel

Michael S. Tsirkin (7):
      IB/mthca: Fix RESET to ERROR transition
      IB/mlx4: Fix RESET to RESET and RESET to ERROR transitions
      IB/ipoib: Fix typos in error messages
      IPoIB/cm: Fix SRQ WR leak
      IB/cm: Improve local id allocation
      IPoIB/cm: Fix timeout check in ipoib_cm_dev_stop()
      IPoIB/cm: Drain cq in ipoib_cm_dev_stop()

Mika Kukkonen (1):
      Add two missing chipsets to drivers/ide/ide-proc.c

Mikael Pettersson (1):
      [NET]: Fix net/core/skbuff.c gcc-3.2.3 compilation error

Mike Frysinger (17):
      kbuild: include limits.h in sumversion.c for PATH_MAX
      kconfig: search harder for curses library in check-lxdialog.sh
      Blackfin arch: fix a few random warnings
      Blackfin arch: mark a bunch of local functions as static
      Blackfin arch: fix trace output for FLAT binaries
      Blackfin arch: initial tepla-bf561 board support
      Blackfin arch: make sure we declare the revid functions as pure (since they are)
      Blackfin arch: dont clear status register bits in SWRST so we can actually use it
      Blackfin arch: finish removing p* volatile defines for MMRs
      Blackfin arch: move board specific setup out of common init code and into the board specific init code
      Blackfin arch: issue reset via SWRST so we dont clobber the watchdog state
      Blackfin arch: document why we have to touch the UART peripheral in our boot up code
      Blackfin arch: dont clear the bit that tells coreb to start booting
      Blackfin arch: make sure we use local labels
      Blackfin arch: cache SWRST value at bootup so other things like watchdog can non-destructively query it
      Blackfin arch: add board default configs to blackfin arch
      Blackfin serial driver: implement support for ignoring parity/break errors

Miklos Szeredi (4):
      fuse: fix mknod of regular file
      fuse: generic_write_checks() for direct_io
      fuse: delete inode on drop
      fix unused setup_nr_node_ids

Milan Kocian (1):
      [RTNETLINK]: Fix sending netlink message when replace route.

Milan Svoboda (1):
      [ARM] 4376/1: Selects GENERIC_GPIO for ARCH_IXP4XX in Kconfig

Nate Diller (1):
      ocfs2: use zero_user_page

Neil \"Superna\" ARMSTRONG (1):
      USB: New device PID for ftdi_sio driver

NeilBrown (3):
      md: avoid overflow in raid0 calculation with large components
      md: don't write more than is required of the last page of a bitmap
      md: fix bug with linear hot-add and elsewhere

Nicolas Boichat (1):
      applesmc - sensors patch missing from 2.6.22-rc2

OGAWA Hirofumi (2):
      Fix "fs: convert core functions to zero_user_page"
      power: Fix sizeof(PAGE_SIZE) typo

Oleg Nesterov (2):
      freezer: fix kthread_create vs freezer theoretical race
      simplify cleanup_workqueue_thread()

Oliver Hartkopp (1):
      [IPV6]: Ignore ipv6 events on non-IPV6 capable devices.

Oliver Neukum (4):
      USB: fix omninet memory leak found by coverity
      USB: remove useless check in mos7840 found by coverity
      USB: address FIXME in usbnet w.r.t drivers claiming multiple interfaces
      USB: ldusb bugfix

Patrick McHardy (8):
      [NETFILTER]: nf_conntrack: fix use-after-free in helper destroy callback invocation
      [NETFILTER]: nf_conntrack_ipv4: fix incorrect #ifdef config name
      [IPV4]: icmp: fix crash with sysctl_icmp_errors_use_inbound_ifaddr
      [RTNETLINK]: Allow changing of subsets of netdevice flags in rtnl_setlink
      [RTNETLINK]: Remove remains of wireless extensions over rtnetlink
      [NET_SCHED]: sch_htb: fix event cache time calculation
      [NETFILTER]: nf_conntrack_ftp: fix newline sequence number update
      [NETFILTER]: nf_conntrack_ftp: fix newline sequence number calculation

Paul E. McKenney (1):
      prohibit rcutorture from being compiled into the kernel

Paul Mundt (12):
      sh: Shut up compiler warnings in __do_page_fault().
      sh: Fix up psw build rules for r7780rp.
      sh: Kill off pmb slab cache destructor.
      sh: Wire up signalfd/timerfd/eventfd syscalls.
      sh: Fix up various compile warnings for SE boards.
      sh: Fix page size alignment in __copy_user_page().
      sh: Disable psw support for R7785RP.
      fs: Kill sh dependency for binfmt_flat.
      sh: disable genrtc support.
      sh: sr.bl toggling around idle sleep.
      sh: Wire up kdump crash kernel exec in die().
      sh: Fix dreamcast build for IRQ changes.

Pavel Pisa (1):
      mmc: add maintainer for iMX MMC interface

Pete Zaitcev (2):
      USB: Deref URB after usbmon is done with it
      USB: usblp: Use correct DMA address in case of probe error

Peter Samuelson (1):
      Input: logips2pp - add type 72 (PS/2 TrackMan Marble)

Pierre Ossman (2):
      mmc: clean up unused parts of block driver
      mmc: mark unmaintained drivers

Rafael J. Wysocki (3):
      freezer: close potential race between refrigerator and thaw_tasks
      freezer: fix vfork problem
      freezer: take kernel_execve into consideration

Ralf Baechle (1):
      meth driver renovation

Randy Dunlap (2):
      update dontdiff file
      document clocksources

Richard Purdie (2):
      [ARM] 4375/1: sharpsl_pm: Fix compile warnings
      w100fb: fix compile warnings

Robert P. J. Day (1):
      Documentation: fix the explanation of Kconfig files

Robin Holt (2):
      [IA64] Improve unwind checking.
      [IA64] Only unwind non-running tasks.

Roland Dreier (7):
      IB/ipath: Fix potential deadlock with multicast spinlocks
      IB/core: Use start_port() and end_port()
      IB/mlx4: Set GRH:HopLimit when sending globally routed MADs
      mlx4_core: Fix array overrun in dump_dev_cap_flags()
      IB/mlx4: Fix check of opcode in mlx4_ib_post_send()
      IB/mlx4: Check if SRQ is full when posting receive
      IB/mlx4: Don't allocate RQ doorbell if using SRQ

Roland McGrath (1):
      recalc_sigpending_tsk fixes

Rolf Manderscheid (1):
      IB/mthca: Set GRH:HopLimit when building MLX headers

Russell King (8):
      [ARM] Remove Integrator/CP SMP platform support
      [ARM] Update ARM syscalls
      [ARM] Silence OMAP kernel configuration warning
      [ARM] gic: Fix gic cascade irq handling
      [ARM] integrator: fix pci_v3 compile error with DEBUG_LL
      [ARM] ARMv6: add CPU_HAS_ASID configuration
      kbuild: make modpost section warnings clearer
      mmc: add maintainer for ARM Primecell controller

Sam Ravnborg (6):
      all-archs: consolidate .text section definition in asm-generic
      all-archs: consolidate .data section definition in asm-generic
      kbuild: introduce __init_refok/__initdata_refok to supress section mismatch warnings
      init/main: use __init_refok to fix section mismatch
      mm: fix section mismatch warnings
      mm/slab: fix section mismatch warning

Sandeep Sanjay Patil (1):
      [ARM] 4384/1: S3C2412/13 SPI registers offset correction

Sascha Hauer (2):
      imxfb: remove ifdefs
      imxfb: fix memory hole

Satoru Takeuchi (1):
      Input: ucb1400_ts - use sched_setscheduler()

Semih Hazar (1):
      Input: ads7846 - SPI_CPHA mode bugfix

Simon Arlott (3):
      [ARM] spelling fixes
      spelling fixes: arch/sh/
      V4L/DVB (5630): Dvb-core: Handle failures to create devices

Sonic Zhang (1):
      Blackfin arch: Change NO_ACCESS_CHECK to ACCESS_CHECK

Stefan Richter (1):
      i386, x86-64: show that CONFIG_HOTPLUG_CPU is required for suspend on SMP

Stefan Roscher (1):
      IB/ehca: Fix number of send WRs reported for new QP

Stephen Hemminger (1):
      [NET]: Fix race condition about network device name allocation.

Stephen Rothwell (1):
      Fix headers check fallout

Syed Khasim (1):
      mmc: Add maintainers for TI OMAP MMC interface

Sylvain Munaut (1):
      powerpc: Fix the MODALIAS generation in modpost for of devices

Tejun Heo (4):
      ahci: disable 64bit dma on sb600
      ata_piix: add short 40c quirk for Acer Aspire 2030, take #2
      libata: don't consider 0xff as port empty if SStatus is available
      libata: -ENODEV during prereset isn't an error

Thomas Gleixner (4):
      Ignore bogus ACPI info for offline CPUs
      NOHZ: Rate limit the local softirq pending warning output
      Prevent going idle with softirq pending
      i386: fix early usage of atomic_add_return and local_add_return on real i386

Tony Breeds (1):
      Fix build failure for drivers/ata/pata_scc.c

Tony Lindgren (1):
      USB: Add support for Olimex arm-usb-ocd JTAG interface serial port

Tony Luck (4):
      [IA64] Fix bogus messages about system calls not implemented.
      [IA64] Yet another section mismatch warning
      [IA64] start_secondary() and smp_callin() should be __cpuinit
      [IA64] acpi_get_sysname() should be __init

Trond Myklebust (2):
      NFS: Avoid a deadlock situation on write
      NFS: Fix nfs_direct_dirty_pages()

Uwe Koziolek (1):
      libata: sata_sis fixes

Vasily Averin (1):
      [NET]: "wrong timeout value" in sk_wait_data() v2

Venki Pallipadi (2):
      [IA64] Fix using uninitialized data in _PDC setup
      [IA64] Cleanup acpi header to reuse the generic _PDC defines

William Lee Irwin III (1):
      i386 bigsmp: section mismatch fixes

Yinghai Lu (1):
      x86_64: early_print kernel console should send CRLF not LFCR

Yoichi Yuasa (1):
      remove unnecessary dependency on VIA velocity config

Yosef Etigin (2):
      IB/core: Add helpers for uncached GID and P_Key searches
      IPoIB: Handle P_Key table reordering

dmitry pervushin (1):
      sh: Fix clock multiplier on SH7722.

kogiidena (2):
      sh: landisk: rtc-rs5c313 support.
      sh: landisk: Header cleanups.

---1463790079-1531236494-1180149664=:26602--
