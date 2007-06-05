Return-Path: <linux-kernel-owner+w=401wt.eu-S1762573AbXFEDu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762573AbXFEDu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 23:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759902AbXFEDuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 23:50:21 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:43787 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760367AbXFEDuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 23:50:17 -0400
Date: Mon, 4 Jun 2007 20:50:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.22-rc4
Message-ID: <alpine.LFD.0.98.0706042040350.23741@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463790079-527691117-1181015415=:23741"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463790079-527691117-1181015415=:23741
Content-Type: TEXT/PLAIN; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT


So -rc4 is out there now, hopefully shrinking the regression list further. 

The diffstat (for those that look at those kinds of things) tells the 
story: lots of small stuff to random files. I think the single biggest 
file change was the patch-checking script, along with some sparc64 fixes. 
But the bulk of it all is just a lot of small random things.

Shortlog appended to give kind of an overview, nothing really stands out 
there. Mostly driver fixes, with some architecture updates.

I'd ask that people involved with the known regressions please test 
whether they got fixed, and if you wrote a patch and it's still pending, 
please make sure to push it upstream..

		Linus

---

Akinobu Mita (3):
      ieee80211: fix incomplete error message
      softmac: alloc_ieee80211() NULL check
      [POWERPC] Fix return from pte_alloc_one() in out-of-memory case

Alan Cox (2):
      [WATCHDOG] clean-up watchdog documentation
      [ARM] enable arbitary speed tty ioctls and split input/output speed

Alan Stern (2):
      [SCSI] sd: fix refcounting regression in suspend/resume routines
      USB: replace flush_workqueue with cancel_sync_work

Alex Tomas (1):
      When ext4_ext_insert_extent() fails to insert new blocks

Alexey Dobriyan (1):
      Fix vmi.c compilation

Amit Arora (1):
      ext4: Extent overlap bugfix

Andrea Paterniani (1):
      SPI: Freescale iMX SPI controller driver fixes

Andrew Morton (6):
      sh: support older gcc's
      [SPARC32]: Build fix.
      ntfs_init_locked_inode(): fix array indexing
      afs: needs sched.h
      mtrr atomicity fix
      vanishing ioctl handler debugging

Andrew Victor (2):
      [WATCHDOG] ks8695_wdt.c - new KS8695 watchdog driver
      [ARM] 4411/1: KS8695: Another serial driver fix

Andy Gospodarek (1):
      PCI: disable MSI by default on systems with Serverworks HT1000 chips

Andy Whitcroft (1):
      add a trivial patch style checker

Antonino A. Daplas (1):
      neofb: Fix pseudo_palette array overrun in neofb_setcolreg

Arnaldo Carvalho de Melo (1):
      [SOCK]: Shrink struct sock by 8 bytes on 64-bit.

Artem Bityutskiy (1):
      [JFFS2] Fix buffer length calculations in jffs2_get_inode_nodes()

Auke Kok (1):
      e1000: disable polling before registering netdevice

Avuton Olrich (1):
      cfag12864bfb: Use sys_ instead of cfb_ framebuffer accessors

Baruch Even (2):
      [ALSA] hda-codec - Add quirk for MSI S420
      [BRIDGE]: Reduce frequency of forwarding cleanup timer in bridge.

Ben Dooks (6):
      [ARM] 4401/1: S3C2443: Add definitions for port GPIOJ
      [ARM] 4402/1: S3C2443: Add physical address of HSMMC controller
      [ARM] 4412/1: S3C2412: reset errata fix
      [ARM] 4414/1: S3C2443: sparse fix for clock.c
      [ARM] 4415/1: AML5900: fix sparse warnings from map_io
      [ARM] 4416/1: NWFPE: fix undeclared symbols

Ben Gardner (1):
      PCI: Fix pci_find_present

Benjamin Herrenschmidt (2):
      [POWERPC] Fix ppc32 single-stepping out of syscalls
      [POWERPC] Fix possible access to free pages

Bill Nottingham (2):
      [SCSI] qla2xxx: fix timeout in qla2x00_down_timeout
      [NET]: Fix comparisons of unsigned < 0.

Björn Steinbrink (2):
      prism54: fix monitor mode oops
      timer statistics: fix race

Bob Moore (1):
      ACPICA: Support for external package objects as method arguments

Brandon Craig Rhodes (1):
      hostap: Allocate enough tailroom for TKIP

Brian King (1):
      [SCSI] ipr: Proper return codes for eh_dev_reset for SATA devices

Brice Goglin (1):
      myri10ge: report link up/down in standard ethtool way

Bryan Wu (1):
      a bug in ramfs_nommu_resize function, passing old size to vmtruncate

Catalin Marinas (1):
      [ARM] 4394/1: ARMv7: Add the TLB range operations

Chris Wright (1):
      x86: fix oprofile double free

Christian Rothlaender (1):
      [ALSA] hda-codec - Add support for ASUS A8J modem

Christoph Hellwig (6):
      [SCSI] NCR53C9x: correct spelling mistake in deprecation notice
      [SCSI] pluto: Use wait_for_completion_timeout.
      [SPARC64]: Kill unused DIE_PAGE_FAULT enum value.
      [S390] dasd_eer: use mutex instead of semaphore
      [S390] arch/s390/kernel/debug.c: use mutex instead of semaphore
      [S390] raw3270: use mutex instead of semaphore

Christoph Lameter (3):
      SLUB: More documentation
      SLUB: Fix NUMA / SYSFS bootstrap issue
      SLUB: fix locking for hotplug callbacks

Cornelia Huck (1):
      [S390] cio: Use device_schedule_callback() for removing disconnected devices.

Dan Williams (1):
      msi: fix ARM compile

Daniel Drake (1):
      [ALSA] hda-intel: fix ASUS M2V detection

Daniel T Chen (1):
      [ALSA] hda-codec - Add quirk for Supermicro PDSBA to alc883_cfg_tbl[]

Darrick J. Wong (1):
      [SCSI] aic94xx: asd_clear_nexus should fail if the cleared task does not complete

Dave Airlie (1):
      drm/radeon: add more IGP chipset pci ids

Dave Jones (1):
      [SCSI] fusion: Fix |/|| confusion

Dave Kleikamp (1):
      EXT4: Fix whitespace

David Brownell (1):
      SPI dynamic busid generation bugfix

David Chinner (1):
      [XFS] Write at EOF may not update filesize correctly.

David Gibson (2):
      [POWERPC] Fix compiler/assembler flags for Ebony platform boot files
      [POWERPC] Don't use HOSTCFLAGS in BOOTCFLAGS

David Howells (1):
      [MTD] generalise the handling of MTD-specific superblocks

David Rientjes (1):
      [ARM] use __used attribute

David S. Miller (25):
      [SPARC64]: Don't be picky about virtual-dma values on sun4v.
      [SPARC64]: PCI device scan is way too verbose by default.
      [SCSI] ESP: Kill SCSI_ESP_CORE and link directly just like jazz_esp
      [SPARC64]: Fix typo in sun4v_hvapi_register error handling.
      [SPARC64]: Report proper system soft state to the hypervisor.
      [SPARC64]: Negotiate hypervisor API for PCI services.
      [SPARC64]: Use machine description and OBP properly for cpu probing.
      [SPARC64]: Eliminate NR_CPUS limitations.
      [SPARC64]: Fix _PAGE_EXEC_4U check in sun4u I-TLB miss handler.
      [SPARC64]: Fix two bugs wrt. kernel 4MB TSB.
      [SPARC64]: Fill holes in hypervisor APIs and fix KTSB registry.
      [CASSINI]: Fix printk message typo.
      [XFRM]: Allow XFRM_ACQ_EXPIRES to be tunable via sysctl.
      [XFRM]: xfrm_larval_drop sysctl should be __read_mostly.
      [IPV4]: Kill references to bogus non-existent CONFIG_IP_NOSIOCRT
      [AF_PACKET]: Kill bogus CONFIG_PACKET_MULTICAST
      [IPV6]: Fix build warning.
      [AF_PACKET]: Kill CONFIG_PACKET_SOCKET.
      [IPSEC]: Add xfrm_sysctl.txt.
      [SPARC64]: Add missing NCS and SVC hypervisor interfaces.
      [AF_UNIX]: Make socket locking much less confusing.
      [AF_UNIX]: Fix datagram connect race causing an OOPS.
      [VIDEO]: XVR500 and XVR2500 require FB=y
      [ATA]: Don't allow to enable this for SPARC64 without PCI.
      [SCSI] JAZZ ESP and SUN ESP need SPI_ATTRS

David Woodhouse (4):
      [JFFS2] Fix BUG() caused by failing to discard xattrs on deleted files.
      [JFFS2] Fix potential memory leak of dead xattrs on unmount.
      [MTD] Fix error checking after get_mtd_device() in get_sb_mtd functions
      [JFFS2] Fix obsoletion of metadata nodes in jffs2_add_tn_to_tree()

Dmitry Torokhov (3):
      Input: db9 - do not ignore dev2 module parameter
      Input: ucb1x00 - do not access input_dev->private directly
      Input: reduce raciness when input handlers disconnect

Domen Puncer (1):
      [POWERPC] 52xx: unbreak lite5200 dts (_pic vs. -pic)

Ed Lin (4):
      [SCSI] stex: fix id mapping issue
      [SCSI] stex: extend hard reset wait time
      [SCSI] stex: fix reset recovery for console device
      [SCSI] stex: minor cleanup and version update

Enrico Scholz (1):
      [ARM] 4403/1: Make the PXA-I2C driver work with lockdep validator

Eric W. Biederman (2):
      msi: fix the ordering of msix irqs
      msi: mask the msix vector before we unmap it

Evgeniy Polyakov (1):
      sh: trivial build cleanups.

FUJITA Tomonori (1):
      [SCSI] tgt: fix a rdma indirect transfer error bug

Geert Uytterhoeven (1):
      fbdev: Move declaration of fb_class to <linux/fb.h>

Haavard Skinnemoen (1):
      atmel_spi dma address bugfix

Heiko Carstens (1):
      [S390] Fix section annotations.

Henrique de Moraes Holschuh (1):
      ACPI: thinkpad-acpi: do not use named sysfs groups

Herbert Xu (3):
      e1000: restore netif_poll_enable call but make sure IRQs are off
      [NET] napi: Call __netif_rx_complete in netif_rx_complete
      [NET] gso: Fix GSO feature mask in sk_setup_caps

Hong Liu (1):
      mac80211: fix memory leak when defrag fragments

Horst H. von Brand (2):
      [SPARC64]: arch/sparc64/time.c doesn't compile on Ultra 1 (no PCI)
      [SPARC]: Missing #include <linux/mm.h> in drivers/sbus/char/flash.c

Hugh Dickins (1):
      [SCSI] fix CONFIG_SCSI_WAIT_SCAN=m

Ilpo Järvinen (1):
      [TCP]: Fix GSO ignorance of pkts_acked arg (cong.cntrl modules)

Ingo Molnar (1):
      timer stats: speedups

Ivan Kokshaysky (1):
      PCI: i386: fixup for Siemens Nixdorf AG FSC Multiprocessor Interrupt Controllers

James Bottomley (2):
      [SCSI] aacraid: fix panic on short Inquiry
      [SCSI] aic7xxx: fix aicasm build failure with gcc-3.4.6

Jan Altenberg (1):
      Add select PHYLIB to the UCC_GETH Kconfig option

Jan Engelhardt (1):
      [SPARC]: Linux always started with 9600 8N1

Jan Kara (1):
      Fix possible UDF data corruption

Jaroslav Kysela (1):
      [ALSA] version 1.0.14

Jason Gaston (1):
      pci_ids: update patch for Intel ICH9M

Jay Cliburn (1):
      PCI: quirk disable MSI on via vt3351

Jay Estabrook (3):
      ALPHA: support graphics on non-zero PCI domains
      ALPHA: correct low-level I/O routines for sable-lynx
      ALPHA: misc fixes

Jean Delvare (4):
      hwmon/ds1621: Fix swapped temperature limits
      hwmon/w83627hf: Be quiet when no chip is found
      hwmon-vid: Don't spam the logs when VRM version is missing
      hwmon/applesmc: Simplify dependencies

Jeff Garzik (4):
      firewire: fix return code
      [libata] Add drive to NCQ blacklist
      misc/tifm_7xx1: replace deprecated irq flag
      [ATM]: Fix warning.

Jerome Borsboom (1):
      [NET]: parse ip:port strings correctly in in4_pton

Johannes Berg (1):
      [POWERPC] Don't allow PMAC_APM_EMU for 64-bit

John W. Linville (1):
      mac80211: avoid null ptr deref in ieee80211_ibss_add_sta

Karsten Keil (1):
      Fix broken CLIR in isdn driver

Kazunori MIYAZAWA (2):
      [IPSEC]: Fix IPv6 AH calculation in outbound
      [IPSEC]: Fix panic when using inter address familiy IPsec on loopback.

Kristian Høgsberg (4):
      firewire: Add missing byteswapping for receive DMA programs.
      firewire: Implement suspend/resume PCI driver hooks.
      firewire: Change struct fw_cdev_iso_packet to not use bitfields.
      firewire: Install firewire-constants.h and firewire-cdev.h for userspace.

Krzysztof Helt (4):
      [SPARC32]: Removes mismatch section warnigs in sparc time.c file
      [SERIAL] sunzilog: section mismatch fix
      skeletonfb: fix of xxxfb_setup ifdef
      pm3fb: switching between X and fb fix

Kumar Gala (5):
      [PPC] Fix COMMON symbol warnings
      [PPC] Remove duplicate export of __div64_32.
      [POWERPC] Fix modpost warning
      [PPC] Fix modpost warning
      [POWERPC] Fix Kconfig warning

Kyle McMartin (2):
      [SPARC]: Emulate cmpxchg like parisc
      fix possible null ptr deref in kallsyms_lookup

Len Brown (4):
      ACPICA: allow Load(OEMx) tables
      ACPI: extend "acpi_osi=" boot option
      ACPI: Make _OSI(Linux) a special case
      ACPI: add __init to acpi_initialize_subsystem()

Li Yang (2):
      [POWERPC] Fix Section mismatch warnings
      NET: add MAINTAINERS entry for ucc_geth driver

Linus Torvalds (2):
      smpboot: fix cachesize comparison in smp_tune_scheduling()
      Linux 2.6.22-rc4

Luis R. Rodriguez (1):
      prism54: MAINTAINERS update

Maciej W. Rozycki (2):
      defxx: Fix the handling of ioremap() failures
      serial_core.h: include <linux/sysrq.h>

Manuel Lauss (2):
      sh: Trivial fix for dma-api compile failure.
      sh: Fix vsyscall build failure.

Marc Pignat (1):
      at91: fix enable/disable_irq_wake symmetry in pcmcia driver

Mariusz Kozlowski (1):
      m68k: parenthesis balance

Mark Glines (1):
      [TCP]: Use default 32768-61000 outgoing port range in all cases.

Martin Habets (1):
      [SPARC]: Mark as emulating cmpxchg, add appropriate depends for DRM.

Martin Peschke (1):
      [SCSI] zfcp: avoid clutter in erp_dbf

Matt Mackall (2):
      random: fix error in entropy extraction
      random: fix seeding with zero entropy

Matthew Garrett (1):
      RTC: use fallback IRQ if PNP tables don't provide one

Michael Chan (1):
      [TG3]: Fix link problem on Dell's onboard 5906.

Michael Ellerman (2):
      [POWERPC] Update documentation for of_find_node_by_type()
      [POWERPC] Compare irq numbers with NO_IRQ not IRQ_NONE

Michael Holzheu (1):
      [S390] Add exception handler for diagnose 224

Michael Loehr (1):
      [SCSI] zfcp: IO stall after deleting and path checker changes after reenabling zfcp devices

Michael Neuling (1):
      [POWERPC] Fix compile warning in pseries xics code

Michael S. Tsirkin (2):
      IB/mthca: Fix handling of send CQE with error for QPs connected to SRQ
      IPoIB/cm: Fix performance regression on Mellanox

Michael Schmitz (1):
      [SCSI] atari_NCR5380: update_timeout removal

Michael Wu (1):
      mac80211: always set carrier status on open

Michael-Luke Jones (4):
      [ARM] 4404/1: Trivial IXP42x Kconfig cleanup
      [ARM] 4405/1: NSLU2, DSM-G600 frequency fixup code
      [ARM] 4406/1: Trivial NSLU2 / NAS-100D header & setup code cleanup
      [ARM] 4410/1: Remove extern declarations in coyote/ixdpg425-pci.c

Michel Dänzer (1):
      drm: make sure the drawable code doesn't call malloc(0).

Mike Frysinger (1):
      [MTD] [MAPS] don't force uclinux mtd map to be root dev

Milton Miller (1):
      [POWERPC] Fix zImage.coff generation for 32-bit pmac

Mingming Cao (1):
      Remove unnecessary exported symbols.

Mithlesh Thukral (1):
      NetXen: Removal of extra free_irq call

Nicolas Boichat (1):
      hwmon/applesmc: Handle name file creation error and deletion

Oleg Nesterov (1):
      tty: fix leakage of -ERESTARTSYS to userland

Ondrej Zajicek (1):
      vt8623fb: arkfb: null pointer dereference fix

Patrick McHardy (1):
      [ICMP]: Fix icmp_errors_use_inbound_ifaddr sysctl

Paul Mundt (2):
      sh: section mismatch fixes for system timer.
      smc91x: sh solution engine fixes.

Pavel Emelianov (1):
      [TCP]: Consolidate checking for tcp orphan count being too big.

Pekka Enberg (1):
      Documentation: How to use GDB to decode OOPSes

Peter Oberparleiter (1):
      [S390] cio: deregister ccw device when pgid disband failed

Petr Vandrovec (1):
      ieee1394: raw1394: Fix async send

Rafael J. Wysocki (1):
      [CRYPTO] cryptd: Fix problem with cryptd and the freezer

Richard Henderson (2):
      alpha: cleanup in bitops.h
      alpha: support new syscalls

Robert P. J. Day (1):
      [ARM] remove unused header file: arch/arm/mach-s3c2410/bast.h

Roland Dreier (1):
      IB/mlx4: Fix last allocated object tracking in bitmap allocator

Roman Zippel (2):
      m68k: runtime patching infrastructure
      m68k: discontinuous memory support

Rudolf Marek (1):
      hwmon/coretemp: Add more safety checks

Russell King (3):
      [ARM] Fix stacktrace FP range checking
      [ARM] oprofile: avoid lockdep warnings on mpcore oprofile init
      [ARM] Fix some section mismatch warnings

Salyzyn, Mark (3):
      [SCSI] aacraid: Correct sa platform support. (Was: [Bug 8469] Bad EIP value on pentium3 SMP kernel-2.6.21.1)
      [SCSI] aacraid: apply commit config for reset_devices flag
      [SCSI] aacraid: fix shutdown handler to also disable interrupts.

Sam Ravnborg (6):
      sparc64: fix alignment bug in linker definition script
      microcode: fix section mismatch warning
      isdn: fix section mismatch warnings
      acpi: fix section mismatch warning in asus + toshiba
      kvm: fix section mismatch warning in kvm-intel.o
      net/hp100: fix section mismatch warning

Sangtae Ha (1):
      [TCP] tcp_probe: a trivial fix for mismatched number of printl arguments.

Satoru Takeuchi (1):
      Better documentation for ERESTARTSYS

Sean Hefty (1):
      IB/cm: Fix stale connection detection

Stefan Richter (9):
      ieee1394: sbp2: include workqueue.h
      ieee1394: eth1394: remove bogus netif_wake_queue
      ieee1394: eth1394: handle tlabel exhaustion
      ieee1394: eth1394: bring back a parent device
      firewire: prefix modules with firewire- instead of fw-
      ieee1394: fix calculation of sysfs attribute "address"
      ieee1394: sbp2: offer SAM-conforming target port ID in sysfs
      firewire: fw-sbp2: implement sysfs ieee1394_id
      firewire: add to MAINTAINERS

Stefan Roese (1):
      [POWERPC] Fix compile breakage for IBM/AMCC 4xx arch/ppc platforms

Stephen Hemminger (12):
      sky2: dont set bogus bit in PHY register
      sky2: checksum offload plus vlan bug
      sky2: program proper register for fiber PHY
      sky2: enable IRQ on duplex renegotiation
      [TCP] tcp_probe: use GCC printf attribute
      [BRIDGE]: Round off STP perodic timers.
      qla3xxx: device doesnt do hardware checksumming.
      VLAN: kill_vid is only useful for VLAN filtering devices
      sky2: Fix VLAN unregistration
      8139cp: fix VLAN unregistration
      atl1: eliminate unneeded kill_vid code
      network drivers: eliminate unneeded kill_vid code

Stephen Rothwell (3):
      [POWERPC] ps3/interrupt.c uses get_hard_smp_processor_id
      [POWERPC] pasemi idle uses hard_smp_processor_id
      [POWERPC] Create a zImage for legacy iSeries

Steve Longerbeam (1):
      [ALSA] hda-codec - Fix pin configs for Gateway MX6453

Sumant Patro (2):
      [SCSI] MegaRAID: Update MAINTAINERS email-id
      [SCSI] megaraid_sas: intercept cmd timeout and throttle io

Takashi Iwai (3):
      [ALSA] ali5451 - Fix possible NULL dereference
      [ALSA] hda-codec - Fix input with STAC92xx
      [ALSA] hda-codec - Fix STAC922x capture boost level

Takashi YOSHII (1):
      sh: Fix pcrel too far for in_nmi label.

Tejun Heo (2):
      pci-quirks: fix MSI disabling on RS400-200 and RS480
      libata: always use polling SETXFER

Theodore Ts'o (1):
      Define/reserve new ext4 superblock fields

Thomas Bogendoerfer (1):
      [SCSI] jazz_esp: Converted to use esp_core.

Thomas Gleixner (3):
      drm: Spinlock initializer cleanup
      NOHZ: prevent multiplication overflow - stop timer for huge timeouts
      [ARM] 4417/1: Serial: Fix AMBA drivers locking

Thomas Klein (1):
      ehea: Fixed multi queue RX bug

Thomas Renninger (1):
      ACPI: thermal: Replace pointer with name in trip_points

Tilman Schmidt (1):
      ISDN4Linux: fix maturity label

Tim Gardner (1):
      Work around Dell E520 BIOS reboot bug

Timur Tabi (1):
      [POWERPC] QE: fix Kconfig 'select' warning with UCC_FAST

Tobin Davis (4):
      [ALSA] HDA: Add support for Gateway NX860
      [ALSA] HDA: Add more systems to Sigmatel codec
      [ALSA] HDA: Fix headphone mute issue on non-eapd Conexant systems
      [ALSA] hda-codec - Add support for MSI K9N Ultra

Tony Luck (1):
      ACPI: Section mismatch ... acpi_map_pxm_to_node

Trond Myklebust (1):
      NFS: Fix a refcount leakage in O_DIRECT

Ulrich Drepper (1):
      fix compat futex code for private futexes

Uwe Bugla (1):
      Input: logips2pp - fix typo in Kconfig

Valerie Henson (1):
      Update tulip maintainer email address

Venkatesh Pallipadi (1):
      [NET]: Make net watchdog timers 1 sec jiffy aligned.

Wei Dong (1):
      [IPV4]: Fix "ipOutNoRoutes" counter error for TCP and UDP

YOSHIFUJI Hideaki (2):
      [IPV6] ROUTE: No longer handle ::/0 specially.
      [IPV6] ADDRCONF: Fix conflicts in DEVCONF_xxx constant.

Yasunori Goto (1):
      memory hotplug: fix unnecessary calling of init_currenty_empty_zone()

Yoann Padioleau (2):
      potential parse error in ifdef
      parse errors in ifdefs

Yoshinori Sato (1):
      h8300 trival patches

Zhu Yi (1):
      mac80211: fail back to use associate from reassociate

Zoltan Devai (1):
      [ALSA] Fix ASoC s3c24xx-pcm spinlock bug

Zou Nan hai (1):
      x86_64: allocate sparsemem memmap above 4G

---1463790079-527691117-1181015415=:23741--
