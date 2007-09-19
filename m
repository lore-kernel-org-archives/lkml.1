Return-Path: <linux-kernel-owner+w=401wt.eu-S1758544AbXISXRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544AbXISXRi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 19:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755755AbXISXRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 19:17:30 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60448 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755724AbXISXR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 19:17:28 -0400
Date: Wed, 19 Sep 2007 16:17:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Arr! Linux 2.6.23-rc7
Message-ID: <alpine.LFD.0.999.0709191605530.16478@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Ahoy me laddies (and beauties),
 time for the traditional "Talk Like a Pirate Day" kernel release!

Now, last year we had a full release (2.6.18 was immortalized on 
TLAP-2006), but this year I'm chickening out, and we're just doing what is 
hopefully going to be the last -rc release for the 2.6.23 series.

I'm not including the diffstat, because it got blown up by the 
resurrection of the sk98lin driver - because skge that is supposed to 
supplant it doesn't handle some of the hardware. Oh well.

Apart from that, we had some mips, powerpc and xtense updates, and various 
driver tweaks. Things like the USB autosuspend revert should make people 
happier, and some more clockevents fixes should help suspend/restore on 
i386.

But the shortlog probably tells it best.

		Linus

---
Adit Ranadive (1):
      [PKTGEN]: srcmac fix

Adrian Bunk (1):
      fix SERIAL_CORE_CONSOLE driver dependencies

Al Viro (2):
      [VLAN]: Fix net_device leak.
      [SUNSAB]: Fix several bugs.

Alan Cox (3):
      [patch 1/2] Xtensa: enable arbitary tty speed setting ioctls
      USB: oti6858: Remove broken ioctl code in -mm tree and also the broken fixes
      [MIPS] tty: add the new ioctls and definitions.

Alan Stern (3):
      USB: prevent Thomson card reader from autosuspending
      USB: prevent Genesys USB-IDE from autosuspending
      USB: disable autosuspend by default for non-hubs

Alexey Dobriyan (3):
      Fix select on /proc files without ->poll
      Fix UTS corruption during clone(CLONE_NEWUTS)
      nfs: fix oops re sysctls and V4 support

Andi Kleen (3):
      x86_64: Add missing mask operation to vdso
      x86_64: Prevent doing anything from cache_remove_dev() when info setup failed.
      i386: Fix leak of ../kernel from top level

Andre Haupt (1):
      fix typo in Documentation/SubmittingPatches

Andreas Gruenbacher (1):
      afs: mntput called before dput

Andrew Morton (3):
      revert "highmem: catch illegal nesting"
      Fix "Fix DAC960 driver on machines which don't support 64-bit DMA"
      disable sys_timerfd() for 2.6.23

Andrew Vasquez (6):
      [SCSI] qla2xxx: Allocate enough space for the full PCI descriptor.
      [SCSI] qla2xxx: Don't modify parity bits during ISP25XX restart.
      [SCSI] qla2xxx: Correct management-server login-state synchronization issue.
      [SCSI] qla2xxx: Correct 8GB iIDMA support.
      [SCSI] qla2xxx: Correct mailbox register dump for FWI2 capable ISPs.
      [SCSI] qla2xxx: Update version number to 8.02.00-k3.

Anti Sullin (1):
      bug in AT91 MCI suspend routines

Anton Vorontsov (1):
      ucc_geth: fix compilation

Antonino A. Daplas (1):
      intelfb: Fix bug in DPLL disable

Aristeu Rozanski (1):
      drivers/edac: fix e752x correct return code

Arnd Bergmann (1):
      futex_compat: fix list traversal bugs

Atsushi Nemoto (2):
      [MIPS] No ide_default_io_base() if PCI IDE was not found
      rtc: rtc-ds1553.c should use resource_size_t for base address

Avi Kivity (1):
      KVM: MMU: Fix rare oops on guest context switch

Bartlomiej Zolnierkiewicz (1):
      via82cxxx: add Arima W730-K8 and other rebadgings to short cables list

Benjamin Herrenschmidt (2):
      [POWERPC] Don't expose clock vDSO functions when CPU has no timebase
      [POWERPC] Fix timekeeping on PowerPC 601

Bjorn Helgaas (1):
      PNP: remove SMCf010 quirk

Chris Zankel (15):
      [XTENSA] fix wrong usage of __init and __initdata in traps.c
      [XTENSA] add missing system calls
      [XTENSA] Add getpgrp system-call to unistd.h
      [XTENSA] Add freestanding option to CFLAGS
      [XTENSA] Move pre-initialized structures to init_task.c
      [XTENSA] Move string-io functions to io.c from pci.c
      [XTENSA] Remove extraneous include statement
      [XTENSA] Fix fadvise64_64
      [XTENSA] Fix timer instabilities.
      [XTENSA] Add typecast macro for constants
      [XTENSA] Initialize semaphore_wake_lock
      [XTENSA] Use the generic version of get_order
      [XTENSA] Add support for executable/non-executable feature in the mmu
      [XTENSA] Add kernel module support
      [XTENSA] Add support for cache-aliasing

Christian Borntraeger (1):
      ACPI: (more) delete CONFIG_ACPI_PROCFS_SLEEP (again)

Christoph Hellwig (1):
      [POWERPC] spusched: Fix null pointer dereference in find_victim

Christoph Lameter (1):
      SLUB: accurately compare debug flags during slab cache merge

Cliff Wickman (1):
      mspec: handle shrinking virtual memory areas

Dale Farnsworth (1):
      mv643xx_eth: Fix tx_bytes stats calculation

Daniel Exner (1):
      pata_ali/alim15x3: override 80-wire cable detection for Toshiba S1800-814

Dave Airlie (1):
      intel-agp: Fix i830 mask variable that changed with G33 support

David Brownell (1):
      USB: fix serial gadget ACM breakage

David Chinner (1):
      [XFS] On-demand reaping of the MRU cache

David Gibson (1):
      rtc-ds1742.c should use resource_size_t for base address

David Miller (1):
      tty: termios locking functions break with new termios type

David S. Miller (6):
      [SPARC64]: Fix booting on V100 systems.
      [BLUETOOTH]: Fix non-COMPAT build of hci_sock.c
      [NET]: Fix two issues wrt. SO_BINDTODEVICE.
      [SPARC64]: Update defconfig.
      [SPARC64]: Fix lockdep, particularly on SMP.
      [SPARC64]: Warn user if cpu is ignored.

Denis V. Lunev (1):
      [IPV6]: Freeing alive inet6 address

Dmitry Torokhov (1):
      Driver core: fix deprectated sysfs structure for nested class devices

Doug Thompson (1):
      drivers/edac: fix printk level down to debug from emerg

Elvis Pranskevichus (1):
      Input: i8042 - add HP Pavilion DV4270ca to the MUX blacklist

Eric Paris (1):
      SELinux: fix array out of bounds when mounting with selinux options

Eric Sandeen (2):
      dir_index: error out instead of BUG on corrupt dx dirs
      ext34: ensure do_split leaves enough free space in both blocks

Frederik Deweerdt (1):
      [patch 2/2] xtensa console.c: remove duplicate #include

Geert Uytterhoeven (1):
      m68k(nommu): add missing syscalls

Greg Kroah-Hartman (2):
      USB: option: Add Dell HSDPA 5520 to driver
      Revert "usb-storage: implement autosuspend"

Hans Verkuil (1):
      V4L/DVB (6095): ivtv: fix VIDIOC_G_ENC_INDEX flag handling

Hans-Jürgen Koch (1):
      Fix a lock problem in generic phy code

Heiko Carstens (3):
      [SCSI] zfcp: fix memory leak
      [SCSI] zfcp: allocate gid_pn_data objects from gid_pn_cache
      [SCSI] zfcp: fix the data buffer accessor patch

Henrique de Moraes Holschuh (3):
      ACPI: fix CONFIG_NET=n acpi_bus_generate_netlink_event build failure
      ACPI: thinkpad-acpi: revert new 2.6.23 CONFIG_THINKPAD_ACPI_INPUT_ENABLED option
      ACPI: thinkpad-acpi: bump up version to 0.16

Herbert Xu (8):
      [NET]: Do not dereference iov if length is zero
      [PPP] pppoe: Fix skb_unshare_check call position
      [PPP] pppoe: Fix data clobbering in __pppoe_xmit and return value
      [PPP] pppoe: Fill in header directly in __pppoe_xmit
      [BRIDGE]: Kill clone argument to br_flood_*
      [NET] skbuff: Add skb_cow_head
      [PPP] generic: Call skb_cow_head before scribbling over skb
      [PPP] generic: Fix receive path data clobbering & non-linear handling

Hiroshi Shimamoto (1):
      sched: fix invalid sched_class use

Ingo Molnar (1):
      sched: add /proc/sys/kernel/sched_compat_yield

Ishizaki Kou (1):
      spidernet: fix interrupt reason recognition

Jaime Velasco Juan (1):
      USB: option: Add a new device ID for the HUAWEI E220 HSDPA modem.

Jamal Hadi Salim (1):
      [NET_SCHED] protect action config/dump from irqs

Jan Andersson (1):
      spi_mpc83xx: hang fix

Jan Kara (1):
      quota: fix infinite loop

Jan-Bernd Themann (2):
      ehea: propagate physical port state
      ehea: fix last_rx update

Jason Gaston (1):
      PCI: irq and pci_ids patch for Intel Tolapai

Jean Delvare (2):
      Fix this Paul Simon song's name
      V4L/DVB (6147): Pwc: Fix a broken debug message

Jeff Dike (1):
      uml: fix irqstack crash

Jeff Garzik (1):
      drivers/net/pcmcia/3c589_cs: fix port configuration switcheroo

Jens Axboe (1):
      Fix race with shared tag queue maps

Jeremy Fitzhardinge (1):
      xen: don't bother trying to set cr4

Jiri Kosina (1):
      [IPV6]: Fix source address selection.

Jochen Friedrich (1):
      [PPC] 8xx: Fix r3 trashing due to 8MB TLB page instantiation

Johannes Dickgreber (1):
      [MIPS] N32 needs to use compat_sys_futimesat

Jonathan Woithe (1):
      msi-laptop: replace ',' with ';'

Jorge Juan Chico (1):
      ide: ST320413A has the same problem as ST340823A

Kees Cook (1):
      pci: fix unterminated pci_device_id lists

Krzysztof Halasa (1):
      Subject: [PATCH] Intel FB pixel clock calculation fix

Kumar Gala (3):
      [POWERPC] 8{5,6}xx: Fix build issue with !CONFIG_PCI
      mpc8xx: Only build mpc8xx on arch/ppc
      [POWERPC] Enable GENERIC_ISA_DMA if FSL_ULI1575 to fix compile issue

Kyungmin Park (1):
      [MIPS] i8259: Add disable method.

Lachlan McIlroy (2):
      [XFS] Ensure file size updates have been completed before writing inode to disk.
      [XFS] Avoid replaying inode buffer initialisation log items if on-disk version is newer.

Lamarque Vieira Souza (1):
      USB: More USB_QUIRK_RESET_RESUME devices

Larry Finger (1):
      bcm43xx: Fix cancellation of work queue crashes

Lee Schermerhorn (1):
      Fix NUMA Memory Policy Reference Counting

Linus Torvalds (3):
      V4L/DVB (6220a): fix build error for et61x251 driver
      x86-64: page faults from user mode are always user faults
      Linux 2.6.23-rc7

Luca Tettamanti (1):
      atl1: disable broken 64-bit DMA

Maciej W. Rozycki (3):
      [MIPS] Workaround for 4Kc machine check exception
      [MIPS] DEC: Initialise ioasic_ssr_lock
      [MIPS] cpu-bugs64.c: GCC 3.3 constraint workaround

Marcel Holtmann (4):
      [Bluetooth] Add missing stat.byte_rx counter modification
      [Bluetooth] Add compat handling for timestamp structure
      [Bluetooth] Update security filter for Bluetooth 2.1
      [Bluetooth] Fix parameter list for event filter command

Mark Fasheh (2):
      ocfs2: update docs for new features
      ocfs2: Fix calculation of i_blocks during truncate

Masakazu Mokuno (1):
      As struct iw_point is bi-directional payload, we should copy back the content

Massimiliano Ghilardi (1):
      USB Mass Storage: limit "Rockchip ROCK MP3" device (071b:3203) max I/O to 64 sectors per command

Matt Colyer (1):
      USB: Add iPhone device id to the quirk list.

Matthew Wilcox (3):
      Fix DAC960 driver on machines which don't support 64-bit DMA
      PTR_ALIGN
      Fix non-ISA link error in drivers/scsi/advansys.c

Matthias Kaehlcke (1):
      kernel/user.c: Use list_for_each_entry instead of list_for_each

Mauro Carvalho Chehab (2):
      V4L/DVB (6148): Fix a warning at saa7191_probe
      Revert "V4L/DVB (6173a): Documentation: Remove reference to dead "cpia_pp=" boot-time option"

Maxime Bizon (1):
      [MIPS] R10000: Fix wrong test in dma-default.c

Michael Chan (1):
      [TG3]: Workaround MSI bug on 5714/5780.

Michael Ellerman (1):
      Restore call_usermodehelper_pipe() behaviour

Michael Hennerich (1):
      Blackfin arch: Update/Fix PM support add new pm_ops valid

Mikael Pettersson (1):
      pdc202xx_new: PLL detection fix

Mike Christie (2):
      [SCSI] libiscsi: fix null ptr regression when aborting a command with data to transfer
      [SCSI] libiscsi: sync up iscsi and scsi eh's access to the connection

Mike Frysinger (1):
      Blackfin arch: fix some bugs in lib/string.h functions found by our string testing modules

Mike Rapoport (1):
      RTC v3020 fixes

Nathael Pajani (1):
      USB: fix linked list insertion bugfix for usb core

Neil Brown (1):
      Correctly close old nfsd/lockd sockets.

Neil Horman (1):
      [NETFILTER]: Fix/improve deadlock condition on module removal netfilter

NeilBrown (1):
      md: fix some bugs with growing raid5/raid6 arrays.

Nick Piggin (1):
      shared tag queue barrier comment

Nicolas George (1):
      uml: use correct type in BLKGETSIZE ioctl

Nigel Cunningham (1):
      Fix failure to resume from initrds

Oliver Neukum (2):
      USB: quirky flash drive
      USB: another quirky device (LCD display)

Olof Johansson (1):
      [POWERPC] Move serial_dev_init to device_initcall()

Ortwin Glück (1):
      USB: Nikon D40 Quirks

Patrick McHardy (3):
      [DECNET]: Fix interface address listing regression.
      [NETFILTER]: nf_conntrack_ipv4: fix "Frag of proto ..." messages
      [INET_DIAG]: Fix oops in netlink_rcv_skb

Paul Mackerras (1):
      Define termios_1 functions for powerpc, s390, avr32 and frv

Pavel Emelyanov (3):
      Leases can be hidden by flocks
      Convert uid hash to hlist
      Fix user namespace exiting OOPs

Peter P Waskiewicz Jr (1):
      [NET] DOC: Update networking/multiqueue.txt with correct information.

Pierre Castella (1):
      USB: ftdi_sio: add of a new product/manufacturer, TML

Ralf Baechle (13):
      Input: i8042 - fix modpost warning
      PCI: remove devinit from pci_read_bridge_bases
      PCI: Remove __devinit from pcibios_get_irq_routing_table
      [MIPS] BCM1480: Fix computation of interrupt mask address register.
      [MIPS] PCI: Set need_domain_info if controller domain index is non-zero.
      [MIPS] Kconfig: whitespace cleanup.
      [MIPS] Sibyte: Remove broken dependency on EXPERIMENTAL from SIBYTE_SB1xxx_SOC.
      [MIPS] Provide empty irq_enable_hazard definition for legacy and R1 cores.
      [MIPS] Fix aliasing bug in copy_user_highpage.
      [MIPS] rtlx: fix int vs. long bug.
      [MIPS] rtlx: Fix build error.
      [MIPS] Malta: Fix off by one bug in interrupt handler.
      [MIPS] 20Kc: Disable use of WAIT instruction.

Randy Dunlap (1):
      PCI AER: fix warnings when PCIEAER=n

Ricardo Barberis (1):
      USB: Add Sony Ericsson P1i to unusual_devs.h

Rob Landley (1):
      Documentation/00-INDEX: notice ecryptfs.txt moved

Robert P. J. Day (3):
      H8/300: Fix misnamed "CONFIG_BLKDEV_RESERVE_ADDRESS" Kconfig variable
      V4L/DVB (6173a): Documentation: Remove reference to dead "cpia_pp=" boot-time option
      V4L/DVB (6173a): Documentation: Remove reference to dead "cpia_pp=" boot-time option

Robin Getz (1):
      Blackfin arch: fix the aliased write macros

Russell King (1):
      [ARM] realview: disable second GIC on RevB MPCore platforms

Rusty Russell (1):
      lguest: Fix guest crash when CONFIG_X86_USE_3DNOW=y

Samuel Thibault (1):
      Input: add more Braille keycodes

Satyam Sharma (2):
      USB: drivers/usb/serial/bus.c: Fix incompatible pointer type warning
      [PKT_SCHED]: sch_cbq.c: Shut up uninitialized variable warning

Scott Wood (1):
      [POWERPC] cpm2: Fix off-by-one error in setbrg().

Sergei Shtylyov (5):
      ide: fix PCI refcounting
      pdc202xx_new: fix PCI refcounting
      hpt366: fix PCI clock detection for HPT374 (take 4)
      ide: add ide_dev_is_sata() helper (take 2)
      hpt366: UltraDMA filter for SATA cards (take 2)

Stas Sergeev (1):
      V4L/DVB (6144): Fix mux setup for composite sound on AverTV 307

Stephen Hemminger (3):
      [IPV4] devinet: show all addresses assigned to interface
      sky2: restore multicast list on resume and other ops
      sk98lin: resurrect driver

Stephen Rothwell (1):
      ide: remove unused variables from drivers/ide/ppc/pmac.c

Steven Toth (1):
      V4L/DVB (6188): Avoid a NULL pointer dereference during mpeg_open()

Thiemo Seufer (2):
      [MIPS] TLB: Fix instruction bitmasks
      BCM1480 serial build fix

Thomas Bogendoerfer (2):
      [MIPS] IP22: Fix wrong check for second HPC
      [MIPS] IP22: fix wrong argument order

Thomas Gleixner (5):
      timekeeping: access rtc outside of xtime lock
      timekeeping: Prevent time going backwards on resume
      clockevents: Enforce oneshot broadcast when broadcast mask is set on resume
      clockevents: do not shutdown the oneshot broadcast device
      clockevents: prevent stale tick update on offline cpu

Tiger Yang (1):
      ocfs2: fix mount option parsing

Tony Breeds (3):
      pmac: build fix
      Fix "no_sync_cmos_clock" logic inversion in kernel/time/ntp.c
      sparc64 (and others): fix tty_ioctl.c build

Tzachi Perelstein (1):
      [ARM] 4567/1: Fix 'Oops - undefined instruction' when CONFIG_VFP=y on non VFP device

Venkatesh Pallipadi (1):
      ACPI: Reevaluate C/P/T states when a cpu becomes online

Vlad Yasevich (2):
      [SCTP]: Add RCU synchronization around sctp_localaddr_list
      [SCTP]: Convert bind_addr_list locking to RCU

Vladimir Shebordaev (1):
      Input: usbtouchscreen - correctly set 'phys'

YOSHIFUJI Hideaki (4):
      [IPv6]: Fix NULL pointer dereference in ip6_flush_pending_frames
      [IPV6]: Fix unbalanced socket reference with MSG_CONFIRM.
      [IPV6]: Just increment OutDatagrams once per a datagram.
      [IPV4]: Just increment OutDatagrams once per a datagram.

Yoichi Yuasa (3):
      [MIPS] Ocelot: remove remaining bits
      leds: Add missing include for leds.h
      [MIPS] Add #include <linux/profile.h> to arch/mips/kernel/time.c

Zhenyu Wang (2):
      intel_agp: fix stolen mem range on G33
      intel_agp: fix GTT map size on G33

aherrman@arcor.de (3):
      radeonfb: fix setting of PPLL_REF_DIV for RV370 5B60.
      radeonfb: fix chip definition for Radeon Xpress 200M 0x5975
      Fix kernel buuild with (CONFIG_COMPAT && ! CONFIG_BLOCK)

gw.kernel@tnode.com (1):
      PCI: unhide SMBus on Compaq Deskpro EP 401963-001 motherboard

samson yeung (1):
      usb/misc/sisusbvga: add product ID of TARGUS/MCT device

tao.ma@oracle.com (1):
      ocfs2: Fix a wrong cluster calculation.
