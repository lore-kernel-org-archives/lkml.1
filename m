Return-Path: <linux-kernel-owner+w=401wt.eu-S1757732AbYFLVp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757732AbYFLVp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 17:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbYFLVpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 17:45:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48807 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751797AbYFLVpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 17:45:12 -0400
Date: Thu, 12 Jun 2008 14:45:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.26-rc6
Message-ID: <alpine.LFD.1.10.0806121430430.2949@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'd like to say that the diffs are shrinking and things are calming down, 
but I'd be lying. Another week, another -rc, and I another 350 commits. 
Yes, the diff is smaller than the one from rc4 to rc5 (despite having more 
commits), so we're on the right trajectory, but I was hoping for less 
churn at this stage.

As usual, most of the changes are to drivers (with arch updates a strong 
second). The DVB updates are the biggest chunk of that, but on the whole 
it's quite spread out. As mentioned, the diffs are smaller and there are 
more commits, and yes, most of the commits are really rather small and 
trivial fixes. 

Give it a try, we should have a few less regressions once more,

			Linus

---
Adrian Bunk (15):
      V4L/DVB (7906): tuners/mxl5005s.c: don't define variables for enums
      V4L/DVB (7908): always enter drivers/media/video/
      [MIPS] remove CONFIG_CPU_R4000 line from Makefile
      frv: don't offer BINFMT_FLAT
      asm-m32r/uaccess.h must #include <asm/setup.h>
      fat_valid_media() isn't for userspace
      [POWERPC] boot/Makefile CONFIG_ variable fixes
      include/linux/ssb/ssb_driver_gige.h typo fix
      ide: remove the ide_etrax100 chipset type
      MAINTAINERS: remove SIS 5513 IDE entry
      ide: export ide_doubler
      fix BLK_DEV_HD_ONLY on ARM dependencies
      add missing lance_* exports
      MAINTAINERS: update ACPI homepage
      proper prototype for acpi_processor_tstate_has_changed()

Akinobu Mita (3):
      introduce memory_read_from_buffer()
      isdn: use simple_read_from_buffer()
      ACPI: use memory_read_from_buffer()

Akio Idehara (1):
      [ALSA] hda - Fix "alc262_sony_unsol[]" hda_verb array

Al Viro (18):
      V4L/DVB (7956): cinergyT2: endianness annotations, endianness and race fixes
      V4L/DVB (7957): fix the roothole in av7110_av.c
      V4L/DVB (7958): fix unaligned access in av7110.c
      V4L/DVB (7959): endianness fix in flexcop-usb.c
      V4L/DVB (7960): net: endianness annotations
      V4L/DVB (7961): fix endianness bug in dib0700_devices.c
      V4L/DVB (7962): ttusb endianness annotations and fixes
      V4L/DVB (7963): ivtv: trivial annotations
      V4L/DVB (7964): cx18 iomem annotations
      V4L/DVB (7965): annotate bcx_riscmem
      V4L/DVB (7966): cx18: direct dereferencing of iomem
      V4L/DVB (7967): bt8xx: unaligned access
      V4L/DVB (7968): zoran: endianness annotations
      V4L/DVB (7969): m920x: unaligned access
      V4L/DVB (7970): mix trivial endianness annotations
      V4L/DVB (7971): usb: unaligned
      V4L/DVB (7972): or51132.c: unaligned
      s2io iomem annotations

Alan Cox (1):
      MAINTAINERS: reiserfs entry is out of date

Alexey Dobriyan (2):
      edd: fix incorrect return of 1 from module_init
      isdn divas: fix proc creation

Alexey Starikovskiy (1):
      ACPI: EC: Use msleep instead of udelay while waiting for event.

Alistair John Strachan (1):
      ACPI 2.6.26-rc2: Add missing newline to DSDT/SSDT warning message

Andres Salomon (1):
      PCI/x86: fix up PCI stuff so that PCI_GOANY supports OLPC

Andrew G. Morgan (1):
      capabilities: remain source compatible with 32-bit raw legacy capability support.

Andrew Morton (1):
      V4L/DVB (7901): zoran: use correct type for CPU flags

Andy Walls (1):
      V4L/DVB (7922): tuner-simple: fix tuner_warn() induced kernel oops in simple_tuner_attach()

Andy Whitcroft (1):
      update checkpatch.pl to version 0.19

Aneesh Kumar K.V (1):
      ext4: Fix use of uninitialized data with debug enabled.

Anton Vorontsov (1):
      serial: fix driver_name conflicts

Arjan van de Ven (1):
      ACPI: Reject below-freezing temperatures as invalid critical temperatures

Arnaldo Carvalho de Melo (1):
      inet{6}_request_sock: Init ->opt and ->pktopts in the constructor

Assaf Krauss (2):
      mac80211: Fixing slow IBSS rejoin
      mac80211: Checking IBSS support while changing channel in ad-hoc mode

Avi Kivity (4):
      KVM: x86 emulator: fix hypercall return value on AMD
      KVM: MMU: reschedule during shadow teardown
      KVM: MMU: Fix printk() format string
      KVM: MMU: Fix is_empty_shadow_page() check

Ayaz Abdulla (1):
      forcedeth: msi interrupts

Bartlomiej Zolnierkiewicz (8):
      sis5513: add missing pci_enable_device() call
      ide-generic: add missing hwif->chipset setup
      ide: fix host drivers missing hwif->chipset initialization
      delkin_cb: set proper hwif->gendev.parent value
      delkin_cb: use struct ide_port_info
      delkin_cb: add warm-plug support
      delkin_cb: add missing __init/__exit tags
      palm_bk3710: add warm-plug support

Ben Collins (1):
      mmc: Fix crash in mmc_block on 64-bit

Ben Hutchings (1):
      sky2: Hold RTNL while calling dev_close()

Benjamin Herrenschmidt (1):
      [POWERPC] Fix incorrect enabling of VMX when building signal or user context

Bertram Felgenhauer (1):
      x86/PCI: add workaround for bug in ASUS A7V600 BIOS (rev 1005)

Bjorn Helgaas (4):
      PNP: skip UNSET MEM resources as well as DISABLED ones
      pnpacpi: fix IRQ flag decoding
      pnpacpi: fix shareable IRQ encode/decode
      PNPACPI: use _CRS IRQ descriptor length for _SRS

Bob Moore (5):
      ACPICA: Fix to allow zero-length ASL field declarations
      ACPICA: Ignore ACPI table signature for Load() operator
      ACPICA: Fix for Load operator, load table at the namespace root
      ACPICA: Fix to make _SST method optional
      ACPICA: Fix for access to deleted object <regression>

Bryan Wu (1):
      smc91x: fix build error from the SMC_GET_MAC_ADDR API change

CHIKAMA masaki (1):
      cpufreq: fix null object access on Transmeta CPU

Carl Henrik Lunde (1):
      block: disable IRQs until data is written to relay channel

Carsten Otte (4):
      KVM: s390: fix interrupt delivery
      KVM: s390: Send program check on access error
      KVM: s390: Fix race condition in kvm_s390_handle_wait
      [S390] vt220 console, initialize list head before use

Chen Gong (1):
      [MTD] m25p80.c mutex unlock fix

Chien Tung (1):
      MAINTAINERS: Update NetEffect (iw_nes) entry

Chris Wright (4):
      LSM: remove stale web site from MAINTAINERS
      asn1: additional sanity checking during BER decoding
      [CPUFREQ] Fix format string bug.
      MAINTAINERS: update PPPoE maintainer address

Christian Borntraeger (3):
      KVM: s390: use yield instead of schedule to implement diag 0x44
      KVM: s390: fix locking order problem in enable_sie
      KVM: s390: handle machine checks when guest is running

Cornelia Huck (3):
      [S390] cio: Fix sparse warnings in blacklist.c.
      [S390] cio: Fix inverted isc priorities.
      qeth: Use ccw_device_get_id().

Dan Williams (7):
      md: fix prexor vs sync_request race
      md: fix uninitialized use of mddev->recovery_wait
      md: do not compute parity unless it is on a failed drive
      fujitsu-laptop: autoload module on Lifebook P1510D
      ipw2200: queue direct scans
      mac80211: send association event on IBSS create
      mac80211: decrease IBSS creation latency

Daniel Gimpelevich (1):
      V4L/DVB (7990): Fix entry for PowerColor RA 330 and make it run with firmware version 2.7

Daniel Walker (1):
      keys: remove unused key_alloc_sem

David Brigada (1):
      kobject: Documentation Spelling Patch

David Brownell (1):
      spi: fix refcount-related spidev oops-on-rmmod

David Howells (2):
      FRV: ip_fast_csum() requires a memory clobber on its inline asm
      x86: fix an incompatible pointer type warning on 64-bit compilations

David Sterba (1):
      ipwireless: Fix blocked sending

David Woodhouse (3):
      V4L/DVB (7166): [v4l] Add new user class controls and deprecate others
      Fix various old email addresses for dwmw2
      rtc: class driver for ppc_md RTC functions

Dmitri Belimov (1):
      V4L/DVB (7975): saa7134_empress

Dmitry Baryshkov (1):
      power_supply: Fix race in power_supply_uevent

Eli Collins (1):
      KVM: VMX: Clear CR4.VMXE in hardware_disable

Eric Miao (1):
      [MTD] [NAND] pxa: fix incorrect calling of pxa3xx_nand_config() on resume path

Eric Sandeen (1):
      ext4: enable barriers by default

Fenghua Yu (1):
      ACPI: handle invalid ACPI SLIT table

Frank Blaschka (3):
      qeth: layer 3 Oops in ip event handler
      qeth: reduce number of kernel messages
      qeth: start dev queue after tx drop error

Geert Uytterhoeven (1):
      m68k: enable CONFIG_COMPAT_BRK by default

Geoff Levand (1):
      fbdev: export symbol fb_mode_option

Graf Yang (1):
      Blackfin serial driver: fix up tty core set_ldisc API change breakage bug

Greg Ungerer (1):
      [ARM] 5060/1: remove unnecessary include of asm/io.h

Guennadi Liakhovetski (1):
      V4L/DVB (7911): Remove v4l2_video_std_fps prototype declaration

Haavard Skinnemoen (1):
      atmel_serial: filter out FP during baud rate detection

Hans Verkuil (9):
      V4L/DVB (7885): ivtv/cx18: add compat_ioctl entries
      V4L/DVB (7925): cx18: ensure that the xceive pin is always asserted on init.
      V4L/DVB (7928): cx18: fix audio registers 808 and 80c
      V4L/DVB (7930): ivtv: bump version to 1.3.0.
      V4L/DVB (7931): cx18: allow for simultaneous digital and analog capture
      V4L/DVB (7932): cx18: mark Compro H900 as fully supported.
      V4L/DVB (7934): cx18: move gpio_dir/val statics to the cx18 struct.
      V4L/DVB (7977): cx18: fix init order and remove duplicate open_on_first_use.
      V4L/DVB (7978): cx18: explicitly test for XC2028 tuner

Harvey Harrison (1):
      lib: export bitrev16

Heiko Carstens (2):
      [S390] sparsemem: use SPARSEMEM_STATIC if !64BIT.
      [S390] vmemmap: fix off-by-one bug.

Henrique de Moraes Holschuh (3):
      thinkpad-acpi: SW_RADIO to SW_RFKILL_ALL rename
      thinkpad-acpi: fix initialization error paths
      thinkpad-acpi: fix LED handling on older ThinkPads

Henry Nestler (1):
      x86: fix endless page faults in mount_block_root for Linux 2.6

Herbert Xu (2):
      net pppoe: Check packet length on all receive paths
      pppoe: Unshare skb before anything else

Holger Macht (1):
      bay: exit if notify handler cannot be installed

Holger Schurig (1):
      libertas: fix sleep confirmation

Hollis Blanchard (5):
      KVM: ppc: Remove duplicate function
      KVM: ppc: add lwzx/stwz emulation
      KVM: ppc: Remove unmatched kunmap() call
      KVM: ppc: Use a read lock around MMU operations, and release it on error
      KVM: ppc: Report bad GFNs

Huang Weiyi (1):
      uml: remove a duplicate include

Hugh Dickins (1):
      libata: fix G5 SATA broken on -rc5

Ilpo Järvinen (1):
      [MIPS] Add missing braces to pte_mkyoung

Ingo Molnar (7):
      V4L/DVB (7910): usb: input layer dependency fixes
      V4L/DVB (7974): fix MEDIA_TUNER && FW_LOADER build error
      uml: PATH_MAX needs limits.h
      irda: net/irda build fix: mcs7780
      USB: fix build bug in USB_ISIGHTFW
      geode: fix modular build
      Revert "x86: fix ioapic bug again"

Jamal Hadi Salim (1):
      ipsec: pfkey should ignore events when no listeners

James Chapman (1):
      l2tp: Fix potential memory corruption in pppol2tp_recvmsg()

Jan Engelhardt (1):
      vt: fix background color on line feed, DEC invert

Jan-Bernd Themann (1):
      ehea: set mac address fix

Jaroslav Franek (1):
      sound: emu10k1 - fix system hang with Audigy2 ZS Notebook PCMCIA card

Jay Cliburn (1):
      atl1: fix suspend regression

Jean Delvare (1):
      rtc-ds1374: rename device to just "ds1374"

Jeff Dike (3):
      uml: deal with host time going backwards
      uml: memcpy export needs to follow host declaration
      uml: stub needs to tolerate SIGWINCH

Jeff Kirsher (1):
      ixgbe: fix typo

Jeff Layton (5):
      on non-posix shares, clear write bits in mode when ATTR_READONLY is set
      when creating new inodes, use file_mode/dir_mode exclusively on mount without unix extensions
      silently ignore ownership changes unless unix extensions are enabled or we're faking uid changes
      disable most mode changes on non-unix/non-cifsacl mounts
      vm: add kzalloc_node() inline

Jeff Mahoney (1):
      fsl-diu-db: compile fix

Jeremy Fitzhardinge (3):
      common implementation of iterative div/mod
      add an inlined version of iter_div_u64_rem
      always_inline timespec_add_ns

Jes Sorensen (1):
      KVM: ia64: fix zero extending for mmio ld1/2/4 emulation in KVM

Jiri Kosina (1):
      brk: make sys_brk() honor COMPAT_BRK when computing lower bound

Joachim Fenkes (1):
      IB/ehca: Reject send WRs only for RESET, INIT and RTR state

Joe Korty (1):
      x86: fix asm warning in head_32.S

Jonathan Cameron (1):
      [ARM] 5068/1: PXA2xx Additional gpio definitions

Jose R. Santos (1):
      ext4: Fix uninit block group initialization with FLEX_BG

Josef Bacik (2):
      ext4: fix online resize bug
      ext3: fix online resize bug

Julia Lawall (1):
      [S390] tape_3590.c: introduce missing kfree

Kevin Winchester (1):
      x86: fix pointer type warning in arch/x86/mm/init_64.c:early_memtest

Krzysztof Helt (2):
      modedb: fix incorrect sync and vmode flags for CVT modes
      fbcon: fix wrong vmode bits copied on console switch

Krzysztof Piotr Oledzki (1):
      net: Fix routing tables with id > 255 for legacy software

Kyungmin Park (1):
      [MTD] [MAPS] Fix cmdlineparse handling in mapping files

Lai Jiangshan (3):
      cpusets: fix bug when adding nonexistent cpu or mem
      sched: fair group: fix overflow(was: fix divide by zero)
      sched: 64-bit: fix arithmetics overflow

Len Brown (1):
      ACPICA: fix stray va_end() caused by mis-merge

Linus Torvalds (3):
      Fix invalid access errors in blk_lookup_devt
      USB: don't use reset-resume if drivers don't support it
      Linux 2.6.26-rc6

Manish Katiyar (1):
      x86: fix unused variable 'loops' warning in arch/x86/boot/a20.c

Manuel Lauss (2):
      [MIPS] Alchemy: export get_au1x00_speed for modules
      [MIPS] Alchemy: dbdma: add API to delete custom DDMA device ids.

Marcelo Tosatti (2):
      KVM: migrate PIT timer
      KVM: IOAPIC: only set remote_irr if interrupt was injected

Marcin Slusarz (5):
      V4L/DVB (7902): fix handling of tea5761_autodetection return value
      V4L/DVB (7903): gp8psk_power_ctrl should return negative errors
      V4L/DVB (7904): v4l/tuner-core: consistent handling of return values
      V4L/DVB (7905): check_v4l2 should return -EINVAL on error
      iwlwifi: fix oops in iwl3945_led_brightness_set

Mark McLoughlin (3):
      virtio_net: Fix skb->csum_start computation
      virtio: Fix typo in virtio_net_hdr comments
      virtio: virtio_net free transmit skbs in a timer

Martin Schwidefsky (1):
      [S390] Fix __ctl_load/__ctl_store inline assembly constraints

Matt Carlson (4):
      tg3: Fix 5714S / 5715S / 5780S link failures
      tg3: Fix a flags typo
      tg3: Fix 5761 WOL
      tg3: Update version to 3.92.1

Matthew Garrett (1):
      isight_firmware: Avoid crash on loading invalid firmware

Miao Xie (1):
      cpusets: fix and update Documentation

Michael Buesch (1):
      zd1211rw: Fix data padding for QoS

Michael Halcrow (1):
      eCryptfs: remove unnecessary page decrypt call

Michael Krufky (7):
      V4L/DVB (7916): dib7000p: fix dib7000p_attach when !CONFIG_DVB_DIB7000P
      V4L/DVB (7918): au0828: remove irrelevent analog tuner standby code
      V4L/DVB (7919): VIDEO_AU0828 does not depend on VIDEO_DEV
      V4L/DVB (7943): tuner: add macro, hybrid_tuner_report_instance_count
      V4L/DVB (7944): tuner-xc2028: use hybrid_tuner_request_state
      V4L/DVB (7983): tda18271_calc_rf_cal must return the return value of tda18271_lookup_map
      V4L/DVB (8001): dib0070: fix dib0070_attach when !CONFIG_DVB_TUNER_DIB0070

Mike Frysinger (2):
      Blackfin arch: fixup warnings with the new cplb saved values
      Blackfin arch: protect only the SPI bus controller with CONFIG_SPI_BFIN

Mike Rapoport (2):
      [ARM] 5065/2: CM-X270: Fix DM9000 IRQ flags initialisation
      [ARM] 5066/2: EM-X270: Fix DM9000 IRQ flags initialisation

Nadia Derbey (2):
      ipc: restore MSGPOOL original value
      ipc: only output msgmni value at boot time

Nate Case (1):
      USB: isp1760: Assign resource fields before adding hcd

Nathan Lynch (2):
      [POWERPC] Make walk_memory_resource available with MEMORY_HOTPLUG=n
      [POWERPC] ehea: Remove dependency on MEMORY_HOTPLUG

Neil Horman (1):
      shm: Remove silly double assignment

Nick Piggin (3):
      Add 'rd' alias to new brd ramdisk driver
      hugetlb: fix lockdep error
      vt: fix vc_resize locking

Nobuhiro Iwamatsu (1):
      sh: Fix compile error SH7763 setup code

Oleg Nesterov (2):
      uml: activate_mm: remove the dead PF_BORROWED_MM check
      sched: fix TASK_WAKEKILL vs SIGKILL race

Paul Jackson (2):
      doc: update to URL and status of kernel-docs.txt entry
      doc: document the kernel-doc conventions for kernel hackers

Paul Mundt (3):
      nommu: fix kobjsize() for SLOB and SLUB
      sh: Add -mno-fdpic to default flags.
      nommu: Correct kobjsize() page validity checks.

Pavel Emelyanov (5):
      devcgroup: make a helper to convert cgroup_subsys_state to devs_cgroup
      devscgroup: relax task to dev_cgroup conversion
      devscgroup: check for device permissions at mount time
      devscgroup: make white list more compact in some cases
      ipv6 netns: init net is used to set bindv6only for new sock

Pekka Enberg (1):
      nommu: fix ksize() abuse

Peter Tiedemann (1):
      qeth: Prepare-function to call s390dbf was wrong

Peter Zijlstra (1):
      x86: fix lockdep warning during suspend-to-ram

Philipp Zabel (1):
      [ARM] 5070/1: pxa: add GPIO104_PSKTSEL to pxa27x MFP configuration

Pradeep Singh Rautela (1):
      drivers/atm/eni.h: remove unused macro KERNEL_OFFSET

Ralf Baechle (2):
      [MIPS] Add accessors for random register.
      [MIPS] Fix build error - Delete debugging crap that crept in with CMP

Ralph Campbell (2):
      IB/ipath: Fix device capability flags
      IB/ipath: Fix SM trap forwarding

Rami Rosen (1):
      ipv4: Remove unused declaration from include/net/tcp.h.

Randy Dunlap (1):
      dev_set_name: fix missing kernel-doc

Roland Dreier (3):
      IB/ipath: Avoid test_bit() on u64 SDMA status value
      IB/umem: Avoid sign problems when demoting npages to integer
      IB/core: Remove IB_DEVICE_SEND_W_INV capability flag

Roland.Kletzing (1):
      drivers/char/ip2: fix Kconfig after ip2/ip2main merge

Russ Anderson (1):
      mm: Minor clean-up of page flags in mm/page_alloc.c

Russell King (2):
      [ARM] fix AT91 include loops
      [ARM] pxa: fix tosa.c build error

Rusty Russell (1):
      virtio: use callback on empty in virtio_net

Sam Ravnborg (1):
      kbuild: ignore powerpc specific symbols in modpost

Segher Boessenkool (1):
      [S390] Fix build failure in __cpu_up()

Sigmund Augdal (1):
      V4L/DVB (8000): tda827x: fix NULL pointer in tda827xa_lna_gain

Sonic Zhang (1):
      Blackfin Serial Driver: Clean up BF54x macro in blackfin UART driver.

Stefan Richter (1):
      x86: fix CONFIG_NONPROMISC_DEVMEM prompt and help text

Stephen Rothwell (1):
      [POWERPC] Use dev_set_name in pci_64.c

Steve French (6):
      [CIFS] remove unused variables
      [CIFS] remove trailing whitespace
      [CIFS] warn if both dynperm and cifsacl mount options specified
      [CIFS] Correct incorrect obscure open flag
      [CIFS] Fix hang in mount when negprot causes server to kill tcp session
      [CIFS] cifs: fix oops on mount when CONFIG_CIFS_DFS_UPCALL is enabled

Steve Hodgson (1):
      sfc: Recover from RX queue flush failure

Theodore Ts'o (4):
      jbd2: Fix memory leak when verifying checksums in the journal
      jbd2: If a journal checksum error is detected, propagate the error to ext4
      ext4: Display the journal_async_commit mount option in /proc/mounts
      jbd2: Fix barrier fallback code to re-lock the buffer head

Thomas Bogendoerfer (5):
      [MIPS] R4700: Fix build_tlb_probe_entry
      [MIPS] Fix check for valid stack pointer during backtrace
      [MIPS] IP27: Fix bootmem memory setup
      [MIPS] IP27: Fix clockevent setup
      [MIPS] IP27: misc fixes

Thomas Tuttle (4):
      pagemap: fix bug in add_to_pagemap, require aligned-length reads of /proc/pid/pagemap
      pagemap: return map count, not reference count, in /proc/kpagecount
      pagemap: return EINVAL, not EIO, for unaligned reads of kpagecount or kpageflags
      pagemap: add documentation for pagemap

Tim Gardner (1):
      hdaps: fix module loading on Thinkpad T61P

Tim Pepper (1):
      dock.c remove trailing printk whitespace

Tom Spink (1):
      uml: deal with inaccessible address space start

Vegard Nossum (5):
      [MIPS] Fix typo in header guard
      h8300: fix typo in header guard
      v850: fix typo in header guard
      proc: calculate the correct /proc/<pid> link count
      x86, lockdep: fix "WARNING: at kernel/lockdep.c:2658 check_flags+0x4c/0x128()"

Venkatesh Pallipadi (1):
      cpuidle acpi driver: fix oops on AC<->DC

Willy Tarreau (1):
      doc: add suggestions about good practises for maintainers

Yoichi Yuasa (1):
      Fix divide by zero error in build_clear_page() and build_copy_page()

Yoshihiro Shimoda (2):
      usb: r8a66597-hcd: Add support for SH7723 USB host
      sh: add resource of USB host for SH7723

Yusuke.Goda (1):
      sh: Add SH7723 SCIF support

Zhao Yakui (1):
      ACPI: Disable Fixed_RTC event when installing RTC handler

eric miao (1):
      [ARM] 5062/1: pxa: remove unused definition of CONFIG_ARCH_COTULLA_IDP

surinder (1):
      [ARM] 5067/1: _raw_write_can_lock macro bugfix

