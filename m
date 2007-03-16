Return-Path: <linux-kernel-owner+w=401wt.eu-S965484AbXCPQeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965484AbXCPQeZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 12:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965508AbXCPQeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 12:34:11 -0400
Received: from smtp.osdl.org ([65.172.181.24]:50412 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965484AbXCPQeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 12:34:00 -0400
Date: Fri, 16 Mar 2007 09:33:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.21-rc4
Message-ID: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463790079-949060105-1174062834=:26106"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463790079-949060105-1174062834=:26106
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT


I pushed out the -git trees yesterday, but then got distracted, so the 
patches and tar-balls and the announcement got delayed until this morning. 
Oops. I'm a scatter-brain.

Anyway, the good news about -rc4 is that there's just lots of random 
fixes. I'm hoping that we've seriously cut down on the regression list, 
and I'd ask everybody who is on Adrian's list to please re-verify their 
regression, and in case it's one of the "patches available" ones but I 
haven't merged (maybe because it hasn't been sent to me!), make sure I do.

Shortlog appended. Nothing really stands out. 

		Linus
---
Adrian Bunk (2):
      [DLM] fs/dlm/user.c should #include "user.h"
      asus-laptop: make code static

Adrian Hunter (2):
      [MTD] Correct partition failed erase address
      [MTD] [OneNAND] add Nokia Copyright and a credit

Aji Srinivas (1):
      [BRIDGE]: adding new device to bridge should enable if up

Akiyama, Nobuyuki (1):
      [IA64] add missing syscall trace clear

Al Viro (31):
      fix deadlock in audit_log_task_context()
      sanitize security_getprocattr() API
      ibmtr probe is __devinit, not __init
      const file_operations fallout
      appldata build fix
      (uml) sparse flags for userland glue are missing $(CF)
      zatm __init abuse
      stacktrace doesn't work on uml
      fix ipath_dma_free_coherent() prototype
      m32r dma-mapping.h should simply include generic/dma-mapping-broken.h
      include of asm/pgtable.h in nfsfh is bogus
      BLK_DEV_IDE_CELLEB dependency fix
      sparc: have dma-mapping.h include generic/dma-mapping-broken in non-PCI case
      rtc-cmos needs RTC_ALWAYS_BCD known
      misc NULL noise
      fastcall still doesn't make sense in paravirt
      dmfe trivial endianness annotations
      constant should be long
      pasemi trivial iomem annotations
      sparc: nr_free_pages() is unsigned long
      trivial ATA iomem annotations
      cciss endian annotations
      qeth gfp_t annotations
      C99 initializers, proper use of const in drivers/ps3
      cifs endianness annotations
      hid-core endianness annotations
      ANSIfy powerpc floppy.h
      atl1 trivial endianness misannotations
      kill bogus casts in amd64 uaccess.h
      paride endianness annotations
      m68k dma-mapping: gfp_t annotations

Alan Cox (4):
      [MTD] [MAPS] dilnetpc: Fix printk warning
      libata-acpi: Try and stop all the non PCI devices crashing
      ata_piix: Remove ugly layering violation
      z85230: Fix FIFO handling

Alan Stern (4):
      USB: set the correct interval for interrupt URBs
      UHCI: fix port resume problem
      sysfs and driver core: add callback helper, used by SCSI and S390
      sysfs: reinstate exclusion between method calls and attribute unregistration

Alexey Starikovskiy (2):
      ACPICA: Fix ACPI Global Lock re-entrancy
      ACPI: ec: fix race in status register access

Andre Spahlinger (1):
      USB: ipaq.c: Additional devices

Andrew Morton (1):
      sony-laptop: fix uninitialised variable

Andrew Nayenko (1):
      USB storage: Nokia 6288 unusual_devs entry

Anthony Godshall, Ampro Computers, Inc (1):
      ACPI: make blacklist more verbose

Arnd Bergmann (2):
      [POWERPC] spufs: fix possible memory corruption is spufs_mem_write
      [POWERPC] update cell_defconfig

Artem Bityutskiy (1):
      [JFFS2] print a message when marking bad block

Benjamin Herrenschmidt (4):
      [POWERPC] Fix warning in prom_parse.c of_irq_map_oldworld()
      [POWERPC] Fix warning in powermac feature.c
      [POWERPC] Fix warning in powermac pci.c
      [POWERPC] Fix spu SLB invalidations

Bernhard Walle (1):
      ACPI: Add kernel-parameters hint that acpi=off doesn't work on IA64.

Brice Goglin (4):
      myri10ge: fix error checking and return value in myri10ge_allocate_rings
      myri10ge: use pci_map_page to prepare the dmatest buffer
      myri10ge: prevent 4k rdma on SGI TIOCE chipset
      myri10ge: add a wc_enabled flag to myri10ge_priv

Chris Dearman (1):
      [MIPS] Oprofile: Reset all performance registers for MIPS_MT_SMP configs

Chris Wright (1):
      [IPV6] fix ipv6_getsockopt_sticky copy_to_user leak

Christoph Hellwig (1):
      [POWERPC] avoid SPU_ACTIVATE_NOWAKE optimization

Cyrill Gorcunov (2):
      [MTD] ESB2 check for closed ROM window
      USB Elan FTDI: check for workqueue creation

Dale Farnsworth (1):
      mv643xx: Clear pending interrupts before calling request_irq

Dan Williams (1):
      [ARM] 4248/1: lh7a40x: fix missing definitions for get_irqnr_preamble

Dave Jones (2):
      update 'getting sparse' info.
      build fix for i386 earlyquirk.c

David Brownell (1):
      USB: at91_udc, fix more modpost bogosity (rename driver struct)

David Miller (1):
      RDMA/cxgb3: Fix build on sparc64

David S. Miller (5):
      [IPV6]: Handle np->opt being NULL in ipv6_getsockopt_sticky().
      [SPARC64]: Fix PARPORT build (again).
      [SPARC]: We do not need OLD_GETRLIMIT.
      [SPARC]: Hook up missing syscalls.
      [SPARC64]: Add missing HPAGE_MASK masks on address parameters.

David Woodhouse (2):
      [JFFS2] Use yield() between GC passes in background thread.
      [JFFS2] Check for all-zero node headers

Davide Libenzi (1):
      Add epoll compat_ code to fs/compat.c

Dirk Behme (1):
      ARM: OMAP: Fix missing workqueue include in board-h2.c

Dmitriy Monakhov (1):
      kobject: new_device->kref wasn't putted after error in kobject_move()

Dmitry Torokhov (1):
      Input: i8042 - another attempt to fix AUX delivery checks

Eric Paris (3):
      [IPSEC]: xfrm_policy delete security check misplaced
      [IPSEC]: Add xfrm policy change auditing to pfkey_spdget
      [IPSEC]: xfrm audit hook misplaced in pfkey_delete and xfrm_del_sa

Eric W. Biederman (2):
      msi: Safer state caching.
      pci: Repair pci_save/restore_state so we can restore one save many times.

Evgeniy Polyakov (1):
      [IPV4]: Fix rtm_to_ifaddr() error handling.

Fenghua Yu (1):
      [IA64] fsys_getcpu for IA64

Francois Romieu (2):
      r8169: revert bogus BMCR reset
      r8169: fix a race between PCI probe and dev_open

Gard Spreemann (1):
      USB: Product ID for FT232RL in ftdi_sio

Gary Zambrano (1):
      avr32: dma-mapping.h

Geert Uytterhoeven (2):
      [POWERPC] ps3: always make sure were running on a PS3
      [IPV4]: Fix warning in ip_mc_rejoin_group.

Gerrit Renker (2):
      [DCCP]: Revert patch which disables bidirectional mode
      [DCCP]: Initialise write_xmit_timer also on passive sockets

Greg Kroah-Hartman (2):
      Revert "driver core: refcounting fix"
      Driver core: add device symlink back to sysfs

Haavard Skinnemoen (5):
      [AVR32] at32_spi_setup_slaves should be __init
      [AVR32] show_trace: Only walk valid stack addresses
      [AVR32] Fix typo in include/asm-avr32/Kbuild
      [AVR32] Fix bogus ti->flags manipulation in debug handler
      [AVR32] Don't use kmap() in flush_icache_page()

Henrique de Moraes Holschuh (3):
      ACPI: ibm-acpi: fix initial status of backlight device
      ACPI: ibm-acpi: make ibm-acpi bay support optional
      ACPI: ibm-acpi: improve backlight power handling

Herbert Xu (2):
      [UDP]: Reread uh pointer after pskb_trim
      [IPV6]: Do not set IF_READY if device is down

Hideo Saito (1):
      sh: Fix kernel thread stack corruption with preempt.

Hoang-Nam Nguyen (1):
      IB/ehca: Fix sync between completion handler and destroy cq

Horms (3):
      [IA64] remove duplicate declaration of efi_initialize_iomem_resources
      [IA64] whitespace fixes for include/asm-ia64/sal.h
      [IA64] put kdump_find_rsvd_region in __init

Ingo Molnar (1):
      CPU hotplug: call check_tsc_sync_source() with irqs off

Ishizaki Kou (1):
      [POWERPC] Celleb: bug fix caused by not casting pointer types

Jarek Poplawski (1):
      [SCTP] ipv6: inconsistent lock state ipv6_add_addr/sctp_v6_copy_addrlist

Jeff Dike (1):
      uml: arch_prctl should set thread fs

Jim Radford (2):
      usb-serial: fix shutdown / device_unregister order
      USB: ftdi_sio: use port_probe / port_remove thereby fixing access to the latency_timer

Jiri Kosina (3):
      bluetooth: fix socket locking in hci_sock_dev_event()
      HID: allocate hid_parser in a proper way
      HID: zeroing of bytes in output fields is bogus

Joel Becker (4):
      ocfs2: Proper cleanup in case of error in ocfs2_register_hb_callbacks()
      ocfs2: Concurrent access of o2hb_region->hr_task was not locked
      ocfs2: add some missing address space callbacks
      configfs: add missing mutex_unlock()

Joerg Sommer (1):
      bcm43xx: Fix bug in frequency to channel conversion

Johannes Berg (1):
      driver core: export device_rename

John Keller (2):
      ACPI: Altix: cannot register acpi bus driver before bus scan
      ACPI: Altix: reinitialize acpi tables

Jon K Hellan (1):
      USB: New device IDs for cp2101 driver

Josef Whiter (2):
      [GFS2] fix locking mistake
      [GFS2] fix hangup when multiple processes are trying to write to the same file

Joy Latten (1):
      [XFRM]: Fix missing protocol comparison of larval SAs.

Julius Volz (1):
      ACPI: video: Fix spelling and grammar mistakes

Jörn Engel (1):
      Remove devfs from MAINTAINERS

KAMEZAWA Hiroyuki (1):
      [IA64] fix NULL pointer in ia64/irq_chip-mask/unmask function

Keith Owens (1):
      [IA64] Remove sparse warning from unwind code

Konstantin Karasyov (2):
      ACPI: fix S3 fan resume issue
      ACPI: ThinkPad Z60m: usb mouse stops working after suspend to RAM

Kristen Accardi (1):
      libata-acpi: allow _GTF on SATA, but disable on PATA for now

Kumar Gala (1):
      [POWERPC] 85xx: Enable CONFIG_SERIAL_8250_SHARE_IRQ

Kyungmin Park (4):
      [MTD] [OneNAND] Use oob buffer instead of main one in oob functions
      [MTD] [OneNAND] Fix typo & wrong comments
      [MTD] [OneNAND] Exit the loop when transferring/filling of the oob is finished
      [MTD] [OneNAND] Classify the page data and oob buffer

Larry Finger (1):
      bcm43xx: Fix errors in specs to code translation in B6PHY init

Len Brown (3):
      ACPI: fix Thinkpad 600/600E/600X interrupts
      ACPI: repair nvidia early quirk breakage on x86_64
      ACPI: repair nvidia early quirk breakage on x86_64

Li Yang (1):
      [POWERPC] 83xx: Minor fixes for 834x_mds USB setup code

Linsys Contractor Mithlesh Thukral (2):
      NetXen: Bug fix for Jumbo frames on XG card
      NetXen: Fix softlockup seen during hardware access

Linus Torvalds (3):
      Revert "USB: pxa2xx_udc: fix hardcoded irq number"
      Disable NMI watchdog by default properly
      Linux 2.6.21-rc4

Martin Schiller (1):
      USB: RTS/DTR signal patch for airprime driver

Mathieu Desnoyers (1):
      [SPARC64]: Fix atomicity of TIF update in flush_thread()

Max Dmitrichenko (1):
      USB: fix Unaligned access in EHCI driver

Michael Ellerman (1):
      [POWERPC] Add missing newline in xmon help output

Michael Karcher (1):
      ACPI: fix parallel port IRQ after resume from S3

Michael Olberg (1):
      USB: add QL355P power supply ids to fdti_sio

Milan Svoboda (2):
      USB: pxa2xx_udc: fix hardcoded irq number
      [ARM] 4263/1: fix IXP4XX_NPE[ABC]_BASE_VIRT address

Olaf Kirch (1):
      [IPV6]: Fix for ipv6_setsockopt NULL dereference

Oliver Neukum (5):
      USB: ratelimit debounce error messages
      USB: kill dead code from hub.c
      USB: fix usb-serial device naming bug
      USB: further fix for usb-serial
      USB: fix spinlock recursion in cdc-acm.c

Olof Johansson (1):
      [POWERPC] No DEEPNAP on 970MP 1.0

Paolo 'Blaisorblade' Giarrusso (9):
      uml: hostfs: fix double free
      uml: hostfs: make hostfs= option work as a jail, as intended.
      um: fix a memory leak in the multicast driver
      um: remove dead code about os_usr1_signal() and os_usr1_process()
      um: mark both consoles as CON_ANYTIME
      um: fix confusion irq early reenabling
      uml: activate_fd: return ENOMEM only when appropriate
      um: fix errno usage
      x86_64: fix 2.6.18 regression - PTRACE_OLDSETOPTIONS should be accepted

Pat Gefre (1):
      2.6 Altix: console fix for CONFIG_DEBUG_SHIRQ usage

Patrick McHardy (3):
      [NETFILTER]: nf_conntrack_ipv6: fix incorrect classification of IPv6 fragments as ESTABLISHED
      [NETFILTER]: nfnetlink_log: zero-terminate prefix
      [NETFILTER]: nfnetlink_log: fix crash on bridged packet

Paul Moore (1):
      [NetLabel]: parse the CIPSO ranged tag on incoming packets

Paul Mundt (6):
      doc: Add SH to vdso and earlyprintk in kernel-parameters.txt
      sysctl: Support vdso_enabled sysctl on SH.
      sh: Use L1_CACHE_BYTES for .data.cacheline_aligned.
      sh: Enable SM501 support for RTS7751R2D.
      sh: Revert lazy dcache writeback changes.
      sh: Kill off I/O cruft for R7780RP.

Pavel Pisa (3):
      [ARM] 4254/1: i.MX/MX1 CPU Frequency scaling honor boot loader set BCLK_DIV.
      [ARM] 4255/1: i.MX/MX1 Correct MPU PLL reference clock value.
      [ARM] 4256/1: i.MX/MX1 SDHC fix/workaround of SD card recognition problems

Pavel Roskin (1):
      bcm43xx: Fix assertion failures in interrupt handler

Peter Zijlstra (1):
      ecryptfs: nested locking annotation

Petr Vandrovec (1):
      Fix simplex adapters with libata

Phil Dibowitz (1):
      USB storage: Removed duplicate supertop unusual_dev entry

Philipp Reisner (1):
      [CONNECTOR]: Bugfix for cn_call_callback()

Ralf Baechle (14):
      [CHAR] ds1286: Fix handling of seconds in RTC_ALM_SET ioctl.
      [MIPS] ISA: Fix typo
      [MIPS] ARC: Fix several compiler warnings.
      [MIPS] DEC: Remove call to register_prom_console.
      netxen: fix warnings
      3c59x: Fix several modpost warnings
      ibmtr: Drain rich supply of modpost warnings.
      [MIPS] Sibyte: Do not allow enabling LDT support if PCI is disabled.
      [MIPS] Sibyte: Fix ZBbus profiler
      USB: goku_udc: Remove crude cache coherency code
      [ROSE]: Remove ourselves from waitqueue when receiving a signal
      [ROSE]: Socket locking is a great invention.
      [MIPS] Viper2: Remove defective support.
      [MIPS] kspd: ioctl needs a translation entry.

Richard Fearn (1):
      [GFS2] add newline to printk message

Richard Purdie (3):
      [ARM] 4249/1: Fix tosa compile failure
      [ARM] 4250/1: Fix locomo backlight conversion error/compile failure
      [ARM] 4251/1: Fix sharpsl_pm dependency

Richard Woodruff (1):
      ARM: OMAP: Fix OMAP2 dss2 so clk_set_parent works

Robert Hancock (1):
      sata_nv: revert use of notifiers for now

Robert P. J. Day (3):
      [MTD] [NAND] Correct misspelled preprocessor variable.
      ACPI: Kconfig: hide ACPI menu when CONFIG_PM=n
      [WANROUTER]: Delete superfluous source file "net/wanrouter/af_wanpipe.c".

Robert Reif (2):
      [CG14]: Fix section mismatch warnings.
      [BW2]: Fix section mismatch warnings.

Roger Luethi (1):
      via-rhine: set avoid_D3 for broken BIOSes

Roland Dreier (2):
      IPoIB: Only handle async events for one port
      IB/mthca: Fix error path in mthca_alloc_memfree()

Russ Anderson (2):
      [IA64] Proper handling of TLB errors from duplicate itr.d dropins
      [IA64] Cache error recovery

Ryusuke Sakato (1):
      sh: Fix sigmask trampling in signal delivery.

Sam Ravnborg (3):
      pcie: fix section mismatch warning
      PCI: aer: fix section mismatch warning
      pci: fix section mismatch warning

Sean Hefty (2):
      RDMA/cma: Initialize rdma_bind_list in cma_alloc_any_port()
      RDMA/ucma: Avoid sending reject if backlog is full

Segher Boessenkool (1):
      [POWERPC] Select u-image as default image for Linkstation

Shaohua Li (1):
      ACPI: fix boot hang w/o "noapic" on MSI MS-6390-L

Shirley Ma (1):
      IPoIB: Turn on interface's carrier after broadcast group is joined

Simon Horman (2):
      [IA64] kexec: declare ia64_mca_pal_base in mca.h rather than kexec.h
      [IA64] Cleanup in crash.c

Stephen Hemminger (2):
      sky2: turn off Rx checksum on bad hardware
      skge: set mac address bonding fix

Stephen Rothwell (3):
      [POWERPC] Allocate syscall number for sys_getcpu
      [POWERPC] Wire up sys_epoll_pwait
      [POWERPC] sys_move_pages should be callable from an SPU

Steve Wise (8):
      RDMA/cxgb3: Start ep timer on a MPA reject
      RDMA/cxgb3: Don't use mm after it's freed in iwch_mmap()
      RDMA/cxgb3: Fixes for "normal close" failures
      RDMA/cxgb3: Move QP to error on destroy if the state is IDLE
      RDMA/cxgb3: Stop EP timer when MPA exchange is aborted by peer
      RDMA/cxgb3: Squelch logging AE errors
      RDMA/cxgb3: Don't reuse skbs that are non-linear or cloned
      RDMA/cxgb3: Fix MR permission problems

Steven Whitehouse (5):
      [GFS2] Fix bz 230143, incorrect flushing of rgrps
      [GFS2] Fix bz 229831, lookup returns wrong inode
      [GFS2] Remove unused variable
      [GFS2] go_drop_bh is never used, so remove it
      [GFS2] Fix bz 229873, alternate test: assertion "!ip->i_inode.i_mapping->nrpages" failed

Stuart Menefy (1):
      sh: Clear UBC when not in use.

Sunil Mushran (2):
      ocfs2_dlm: Missing get/put lockres in dlm_run_purge_lockres
      ocfs2_dlm: Add missing locks in dlm_empty_lockres

Tejun Heo (3):
      libata: fix ata_host_release() free order
      devres: release resources on device_del()
      PCI: allow multiple calls to pcim_pin_device()

Thomas Schleusener (1):
      USB: add Additional PIDs in ftdi_sio

Tony Lindgren (1):
      ARM: OMAP: Include missing header

Tony Luck (2):
      [IA64] Pick highest possible saved_max_pfn for crash_dump
      [IA64] refresh config files

Uwe Kleine-KÃ¶nig (1):
      [ARM] 4247/1: Fix long name for cc9p9360dev

Vijay Sampath (1):
      [MTD] [NOR] Fix oops in cfi_amdstd_sync

Vitaly Wool (2):
      [MTD] [NAND] make oobavail public
      [JFFS2] Fix writebuffer recovery in the first page of a block

Wendy Cheng (2):
      [GFS2] NFS filehandle check
      [GFS2] pass formal ino in do_filldir_main

William Lee Irwin III (1):
      [SPARC]: Fix TIF_USEDFPU flag atomicity

Wim Van Sebroeck (1):
      [WATCHDOG] i8xx TCO driver - mark for removal

YOSHIFUJI Hideaki (1):
      USBNET: DM9501: Add Corega FEther USB-TXC support.

Zachary Amsden (2):
      Fix VMI and COMPAT_VDSO for 2.6.21
      Fix vmi time header bug

Zhang, Yanmin (1):
      [IA64] pci_get_legacy_ide_irq should return irq (not GSI)

akpm@linux-foundation.org (1):
      [GFS2] build fix

broonie@sirena.org.uk (3):
      natsemi: Consistently use interrupt enable/disable functions
      natsemi: Fix NAPI for interrupt sharing
      natsemi: Avoid IntrStatus lossage if RX state machine resets.

suzuki (1):
      check_partition(): fix error check

---1463790079-949060105-1174062834=:26106--
