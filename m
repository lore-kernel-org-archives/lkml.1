Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbZCDDcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbZCDDcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 22:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbZCDDcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 22:32:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50097 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751149AbZCDDcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 22:32:02 -0500
Date: Tue, 3 Mar 2009 19:31:24 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.29-rc7
Message-ID: <alpine.LFD.2.00.0903031925250.3170@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The bulk of the patch is a couple of new drivers (ATL1c network driver and 
firewire FireDTV DVB receiver). That's due to the whole "new drivers can't 
regress" thing, although obviously if you compile them in, they may give 
you problems whether you have the hardware or not, as we found with the 
FireDTV driver ;)

But apart from the new drivers, it should all be just small fixes.  The 
shortlog (appended) tells the story.

I'm hoping we're getting closer to a final 2.6.29, but judging by the 
regression list, I suspect we'll have at least an -rc8 still coming up.

		Linus
---

Adam Richter (1):
      USB: Quirk for Hummingbird huc56s / Conexant ACM modem

Alan Cox (3):
      [MTD] map_rom has NULL erase pointer
      [libata] pata_amd: program FIFO
      [libata] pata_legacy: for VLB 32bit PIO don't try tricks with slop

Alan Stern (3):
      USB: usb-storage: add IGNORE_RESIDUE flag for Genesys Logic adapters
      USB: g_file_storage: automatically disable stalls under Atmel
      USB: usb_get_string should check the descriptor type

Alexey Korolev (1):
      [MTD] [LPDDR] qinfo_probe depends on lpddr

Anand Gadiyar (1):
      USB: musb: resume suspended root hub on disconnect

Andrei Birjukov (1):
      [ARM] at91: fix for Atmel AT91 powersaving

Andres Salomon (2):
      [JFFS2] force the jffs2 GC daemon to behave a bit better
      sdhci: Add NO_BUSY_IRQ quirk for Marvell CAFE host chip

Andrew Patterson (1):
      PCI: Enable PCIe AER only after checking firmware support

Andrey Borzenkov (1):
      orinoco: do not resgister NULL pm_notifier function

Andy Whitcroft (9):
      checkpatch: make in_atomic ok in the core
      checkpatch: do not warn about -p0 patches when checking files
      checkpatch: correctly handle type spacing in the face of modifiers
      checkpatch: pointer type star may have modifiers following
      checkpatch: a modifier is not an identifier at the end of a type
      checkpatch: extend attribute testing to all modifiers
      checkpatch: add __ref as a sparse modifier
      checkpatch: version 0.28
      Input: synaptics - ensure we reset the device on resume

Anssi Hannula (1):
      ALSA: aw2: do not grab every saa7146 based device

Arjan Opmeer (1):
      Input: elantech - touchpad driver miss-recognising logitech mice

Atsushi Nemoto (1):
      [MTD] [MAPS] physmap: fix wrong free and del_mtd_{partition,device}

Bartlomiej Zolnierkiewicz (3):
      it821x: remove dead URL
      ide-cd: document capacity hack
      ide: fix refcounting in device drivers

Bastien Nocera (1):
      Input: uvc - the button on the camera is KEY_CAMERA

Beat Michel Liechti (1):
      firedtv: dvb_frontend_info for FireDTV S2, fix "frequency limits undefined" error

Ben Backx (2):
      firesat: fix DVB-S2 device recognition
      firesat: add DVB-S support for DVB-S2 devices

Ben Dooks (1):
      sdhci: Add quirk for controllers with no end-of-busy IRQ

Ben Gardner (1):
      w1_ds2433: clear the validcrc flag after a write

Benjamin Herrenschmidt (1):
      powerpc/44x: Fix address decoding setup of PCI 2.x cells

Benny Halevy (1):
      EXPORT_SYMBOL(d_obtain_alias) rather than EXPORT_SYMBOL_GPL

Bjørn Mork (2):
      cdc_ether: add usb id for Ericsson F3507g
      usbnet: make usbnet_get_link() fall back to ethtool_op_get_link()

Catalin Marinas (1):
      [ARM] 5417/1: Set the correct cacheid for ARMv6 CPUs with ARMv7 style MMU

Chris Leech (2):
      net headers: cleanup dcbnl.h
      net headers: export dcbnl.h

Chris Wilson (1):
      drm: Correct unbalanced drm_vblank_put() during mode setting.

Chris Wright (1):
      PCI: add some sysfs ABI docs

Christoph Hellwig (1):
      Fix FREEZE/THAW compat_ioctl regression

Clemens Noss (1):
      netns: build fix for net_alloc_generic

Costantino Leandro (1):
      Staging: panel: fix oops on panel_cleanup_module

Dan Streetman (1):
      Input: usbtouchscreen - allow reporting calibrated data

Daniel Lezcano (2):
      veth : add the set_mac_address capability
      netns: fix double free at netns creation

Daniel Mierswa (1):
      Input: atkbd - make forced_release_keys[] static

Daniel Ritz (1):
      Input: usbtouchscreen - fix eGalax HID ignoring

Dave Airlie (2):
      drm/i915: make hw page ioremap use ioremap_wc
      drm/i915: convert DRM_ERROR to DRM_DEBUG in phys object pwrite path

David Altobelli (1):
      hpilo: new pci device

David Brownell (2):
      USB: gadget: fix build error in omap_apollon_2420_defconfig
      usb: musb: make Davinci *work* in mainline

David Daney (1):
      MIPS: Only allow Cavium OCTEON to be configured for boards that support it

David Fries (1):
      ide: ide.c 'clear' fix, update "ide=nodma" documentation

David Howells (1):
      Fix recursive lock in free_uid()/free_user_ns()

David S. Miller (2):
      sparc64: Fix crashes in jbusmc_print_dimm()
      net: Kill skb_truesize_check(), it only catches false-positives.

David Woodhouse (1):
      [MTD] [MAPS] Remove MODULE_DEVICE_TABLE() from ck804rom driver.

Dhananjay Phadke (2):
      netxen: fix physical port mapping
      netxen: handle pci bar 0 mapping failure

Dhaval Giani (1):
      sched: don't allow setuid to succeed if the user does not have rt bandwidth

Divy Le Ray (1):
      cxgb3: Add support for PCI ID 0x35.

Dmitriy Taychenachev (2):
      USB: cdc-acm: add usb id for motomagx phones
      zaurus: add usb id for motomagx phones

Dmitry Krivoschekov (1):
      USB: musb: fix musb_host_tx() for shared endpoint FIFO

Eric Anholt (1):
      drm/i915: Fix use-before-null-check in i915_irq_emit().

Eric Leblond (3):
      netfilter: nf_conntrack_ipv6: fix nf_log_packet message in icmpv6 conntrack
      netfilter: nfnetlink_log: fix per-rule qthreshold override
      netfilter: nfnetlink_log: fix timeout handling

Eric Sandeen (1):
      ext4: don't call jbd2_journal_force_commit_nested without journal

Eric W. Biederman (2):
      PCI: pciehp: Handle interrupts that happen during initialization.
      veth: Fix carrier detect

Eugene Teo (1):
      net: amend the fix for SO_BSDCOMPAT gsopt infoleak

Felipe Balbi (2):
      usb: gadget: obex: select correct ep descriptors
      USB: musb: be careful with 64K+ transfer lengths (gadget side)

Fenghua Yu (1):
      Fix iwlan DMA mapping direction

Greg Kroah-Hartman (2):
      DVB: add firesat driver
      asix: new device ids

Guennadi Liakhovetski (1):
      V4L/DVB (10663): soc-camera: fix S_CROP breakage on PXA and SuperH

Harvey Harrison (1):
      ALSA: pcxhr.h replace signed one-bit bitfields

Helge Bahmann (1):
      proc: fix PG_locked reporting in /proc/kpageflags

Henrik Kurelid (5):
      firesat: update isochronous interface, add CI support
      firesat: avc resend
      firedtv: fix returned struct for ca_info
      firedtv: use length_field() of PMT as length
      firedtv: fix registration - adapter number could only be zero

Herbert Xu (2):
      crypto: api - Fix module load deadlock with fallback algorithms
      netpoll: Add drop checks to all entry points

Herton Ronaldo Krzesinski (1):
      w1: add missing Kconfig/Makefile entries for DS2431 slave driver

HighPoint Linux Team (1):
      [SCSI] hptiop: Add new PCI device ID

Hiroshi Shimamoto (1):
      sched_rt: don't start timer when rt bandwidth disabled

Hugh Dickins (1):
      shmem: fix shared anonymous accounting

Ilpo Järvinen (2):
      tcp: remove obsoleted comment about different passes
      tcp: fix retrans_out leaks

Inaky Perez-Gonzalez (1):
      wimax/i2400m: driver loads firmware v1.4 instead of v1.3

Ingo Molnar (1):
      x86: i915 needs pgprot_writecombine() and is_io_mapping_possible()

Ivan Vecera (1):
      r8169: read MAC address from EEPROM on init (2nd attempt)

James Bottomley (2):
      [SCSI] fix ABORTED_COMMAND looping forever problem
      x86, Voyager: fix compile by lifting the degeneracy of phys_cpu_present_map

Jan Engelhardt (1):
      netfilter: make proc/net/ip* print names from foreign NFPROTO

Jan Kara (1):
      ext4: Fix deadlock in ext4_write_begin() and ext4_da_write_begin()

Jarek Poplawski (2):
      vlan: Update skb->mac_header in __vlan_put_tag().
      pkt_sched: sch_drr: Fix oops in drr_change_class.

Jean Delvare (3):
      Input: psmouse - make MOUSE_PS2_LIFEBOOK depend on X86
      i2c-dev: Clarify the unit of ioctl I2C_TIMEOUT
      i2c: Make sure i2c_algo_bit_data.timeout is HZ-independent

Jens Axboe (4):
      block: fix bogus gcc warning for uninitialized var usage
      cciss: shorten 30s timeout on controller reset
      block: reduce stack footprint of blk_recount_segments()
      xen/blkfront: use blk_rq_map_sg to generate ring entries

Jeremy Fitzhardinge (1):
      xen: disable interrupts early, as start_kernel expects

Jesse Barnes (5):
      i915: suspend/resume interrupt state
      drm/i915: remove PLL debugging messages
      drm/i915: handle bogus VBT panel timing
      drm: Fix ordering of bit fields in EDID structure leading huge vsync values.
      drm: disable encoders before re-routing them

Jesse Sung (1):
      USB: option: add BenQ 3g modem information

Jie Yang (1):
      atl1c: Atheros L1C Gigabit Ethernet driver

Joe Perches (1):
      tcp_scalable: Update malformed & dead url

Joerg Roedel (1):
      intel-iommu: fix build error with INTR_REMAP=y and DMAR=n

Josef Bacik (2):
      Btrfs: add better -ENOSPC handling
      Btrfs: try committing transaction before returning ENOSPC

Josef Drexler (1):
      netfilter: xt_recent: fix proc-file addition/removal of IPv4 addresses

Juan Jesus Garcia de Soria (1):
      ALSA: hda - Quirk for Acer Aspire 6530G

Julia Lawall (1):
      firedtv: Use DEFINE_SPINLOCK

Karen Xie (6):
      [SCSI] cxgb3i: transmit work-request fixes
      [SCSI] cxgb3i: added per-task data to track transmit progress
      [SCSI] cxgb3i: Outgoing pdus need to observe skb's MAX_SKB_FRAGS
      [SCSI] cxgb3i: added missing include in cxgb3i_ddp.h
      [SCSI] cxgb3i: Fix spelling errors in documentation
      [SCSI] cxgb3i: update the driver version to 1.0.1

Karsten Keil (1):
      Change email address

Karsten Wiese (2):
      Fix an oops in i915_gem_retire_requests()
      USB: EHCI: slow down ITD reuse

Kay Sievers (1):
      Input: struct device - replace bus_id with dev_name(), dev_set_name()

Kiran Divekar (1):
      libertas: fix misuse of netdev_priv() and dev->ml_priv

Krzysztof Hałasa (1):
      crypto: ixp4xx - Fix qmgr_request_queue build failure

Krzysztof Sachanowicz (1):
      proc: proc_get_inode should de_put when inode already initialized

Kuninori Morimoto (1):
      serial: sh-sci: fix overrun error handling for SH7785 SCIF.

Kyle McMartin (4):
      x86, doc: fix references to Documentation/x86/i386/boot.txt
      drm: edid revision 0 is valid
      [IA64] enable setting DMAR on by default
      x86: enable DMAR by default

Larry Finger (1):
      rtl8187: New USB ID's for RTL8187L

Lee Nipper (1):
      crypto: ahash - Fix digest size in /proc/crypto

Li Yang (1):
      USB: fsl_usb2_udc: fix potential queue head corruption

Linus Torvalds (4):
      drm: Fix shifts of EDID vsync offset/width fields.
      Make ieee1394_init a fs-initcall
      Revert "menu: fix embedded menu snafu"
      Linux 2.6.29-rc7

Luke Yelavich (1):
      ALSA: hda - add another MacBook Pro 3,1 SSID

Mark Brown (1):
      [ARM] 5411/1: S3C64XX: Fix EINT unmask

Mark Lord (1):
      sata_mv: fix SoC interrupt breakage

Mark Nelson (2):
      powerpc: Fix 64bit memcpy() regression
      powerpc: Fix 64bit __copy_tofrom_user() regression

Michael Buesch (2):
      b44: Unconditionally enable interrupt routing on reset
      b44: Disable device on shutdown

Michael Neuling (1):
      powerpc: Fix load/store float double alignment handler

Mike Frysinger (2):
      [MTD] [MAPS] blackfin: fix memory leak in error path
      [MTD] [MAPS] blackfin async requires complex mappings

Márton Németh (1):
      block: add documentation for register_blkdev()

NeilBrown (3):
      md/raid10:  Don't skip more than 1 bitmap-chunk at a time during recovery.
      md/raid10:  Don't call bitmap_cond_end_sync when we are doing recovery.
      md: avoid races when stopping resync.

Nick Piggin (1):
      mm: vmap fix overflow

Nicola Soranzo (1):
      V4L/DVB (10659): em28xx: register device to soundcard for sysfs

Ondrej Zary (1):
      pata_it821x: resume from hibernation fails with RAID volume

Pallipadi, Venkatesh (1):
      fix warning in io_mapping_map_wc()

Patrick Boettcher (1):
      V4L/DVB (10694): [PATCH] software IRQ watchdog for Flexcop B2C2 DVB PCI cards

Patrick McHardy (1):
      netfilter: nf_conntrack: don't try to deliver events for untracked connections

Patrik Kullman (1):
      USB: serial: add support for second revision of Ericsson F3507G WWAN card

Paul E. McKenney (1):
      rcu: Teach RCU that idle task is not quiscent state at boot

Paul Moore (1):
      selinux: Fix a panic in selinux_netlbl_inode_permission()

Paul Mundt (1):
      sh: ap325rxa: Revert ov772x support.

Pavel Emelyanov (1):
      ipv6: don't use tw net when accounting for recycled tw

Pavel Machek (1):
      Staging: w35und: fix registration with wlan stack

Pekka Enberg (1):
      Staging: w35und: fix usb_control_msg() error handling in wb35_probe()

Pekka Paalanen (5):
      x86: count errors in testmmiotrace.ko
      x86: add far read test to testmmiotrace
      x86 mmiotrace: fix save/restore page table state
      x86 mmiotrace: split set_page_presence()
      x86 mmiotrace: fix race with release_kmmio_fault_page()

Ralf Baechle (2):
      MIPS: CVE-2009-0029: Enable syscall wrappers.
      Revert "MIPS: Print irq handler description"

Rambaldi (1):
      firedtv: rename files, variables, functions from firesat to firedtv

Randy Dunlap (4):
      ISDN: fix sc/shmem printk format warning
      net: fix hp-plus build error
      Staging: rtl8187se: fix Kconfig dependencies
      menu: fix embedded menu snafu

Rini van Zetten (1):
      gianfar: Do right check on num_txbdfree

Roel Kluin (16):
      [MTD] slram: Handle negative devlength correctly
      Input: bf54x-keys - fix debounce time validation
      Input: pxa930_trkball - fix write timeout handling
      Input: ambakmi - fix timeout handling in amba_kmi_write()
      ATM: misplaced parentheses?
      TG3: &&/|| confusion
      sundance: missing parentheses?
      SMSC: timeout reaches -1
      sunlance: Beyond ARRAY_SIZE of ib->btx_ring
      i2c: Fix misplaced parentheses
      i2c: Timeouts reach -1
      amd74xx: device/vendor confusion
      atiixp: fix missing parentheses
      [IA64] Do not go beyond ARRAY_SIZE of unw.hash
      [IA64] Don't go beyond iosapic_intr_info's arraysize
      MIPS: Alchemy: In plat_time_init() t reaches -1, tested: 0

Roland McGrath (2):
      x86-64: syscall-audit: fix 32/64 syscall hole
      x86-64: seccomp: fix 32/64 syscall hole

Russell King (3):
      [ARM] RiscPC: Fix etherh oops
      Add i2c_board_info for RiscPC PCF8583
      [ARM] fix lots of ARM __devexit sillyness

Sebastian Siewior (2):
      net/mv643xx: use GFP_ATOMIC while atomic
      net/mv643xx: don't disable the mib timer too early and lock properly

Sergei Shtylyov (5):
      USB: musb: fix urb_dequeue() method
      USB: musb: host endpoint_disable() oops fixes
      USB: musb: fix data toggle saving with shared FIFO
      USB: musb: be careful with 64K+ transfer lengths, host side
      USB: musb: use right poll limit for low speed devices

Seth Forshee (1):
      [ARM] 5416/1: Use unused address in v6_early_abort

Stefan Assmann (1):
      PCI: AMD 813x B2 devices do not need boot interrupt quirk

Stefan Richter (7):
      firesat: copyrights, rename to firedtv, API conversions, fix remote control input
      ieee1394: use correct barrier types between accesses of nodeid and generation
      ieee1394: add hpsb_node_read() and hpsb_node_lock()
      ieee1394: inherit ud vendor_id from node vendor_id
      ieee1394: remove superfluous assertions
      firedtv: cleanups and minor fixes
      firedtv: massive refactoring

Steve Chen (1):
      ALSA: fix excessive background noise introduced by OSS emulation rate shrink

Steve Glendinning (2):
      smsc9420: fix another postfixed timeout
      smsc9420: handle magic field of ethtool_eeprom

Stuart Bennett (2):
      x86 mmiotrace: WARN_ONCE if dis/arming a page fails
      x86 mmiotrace: improve handling of secondary faults

Sunil Mushran (4):
      ocfs2/dlm: Retract fix for race between purge and migrate
      ocfs2: Cleanup the lockname print in dlmglue.c
      ocfs2/dlm: Use ast_lock to protect ast_list
      ocfs2/dlm: Make dlm_assert_master_handler() kill itself instead of the asserter

Takashi Iwai (5):
      ALSA: hda - Fix parse of init_verbs sysfs entry
      ALSA: emu10k1 - Fix digital/analog switch on audigy2 ZS
      ALSA: hda - Fix digital mic on dell-m4-1 and dell-m4-3
      ALSA: hda - Add quirk for new HP xw series
      ALSA: hda - Add probe_mask default for Toshiba laptop with ALC268

Tao Ma (3):
      ocfs2: Access and dirty the buffer_head in mark_written.
      ocfs2: Use the right access_* method in ctime update of xattr.
      ocfs2: lock the metaecc process for xattr bucket

Tejun Heo (1):
      [SCSI] sd: revive sd_index_lock

Theodore Ts'o (3):
      ext4: Add fallback for find_group_flex
      ext4: Remove duplicate call to ext4_commit_super() in ext4_freeze()
      ext4: Reorder fs/Makefile so that ext2 root fs's are mounted using ext2

Thomas Gleixner (1):
      [JFFS2] fix mount crash caused by removed nodes

Thomas Hellstrom (3):
      drm: Don't return ERESTARTSYS to user-space.
      drm: Wake up all lock waiters when the master disappears.
      drm: Avoid client deadlocks when the master disappears.

Tiger Yang (1):
      ocfs2: set gap to seperate entry and value when xattr in bucket

Tim Blechmann (1):
      x86: oprofile: don't set counter width from cpuid on Core2

Tobias Diedrich (1):
      net: forcedeth: Fix wake-on-lan regression

Tobias Klauser (1):
      sh: Storage class should be before const qualifier

Tony Battersby (1):
      intel-iommu: fix endless "Unknown DMAR structure type" loop

Uwe Bugla (2):
      V4L/DVB (10695): Update Technisat card documentation
      V4L/DVB (10696): Remove outdated README for the flexcop-driver

Uwe Kleine-König (4):
      Input: corgikbd - mark probe function as __devinit
      Input: corgi_ts - mark probe function as __devinit
      Input: omap-keypad - mark probe function as __devinit
      Input: spitzkbd - mark probe function as __devinit

Vasanthakumar Thiagarajan (1):
      ath9k: Fix panic upon attach failure

Vegard Nossum (1):
      mm: fix lazy vmap purging (use-after-free error)

Venkatesh Pallipadi (2):
      gpu/drm, x86, PAT: Handle io_mapping_create_wc() errors in a clean way
      gpu/drm, x86, PAT: io_mapping_create_wc and resource_size_t

Vikram Pandita (1):
      USB: musb: fix srp sysfs entry deletion

Yinghai Lu (4):
      PCI quirk: enable MSI on 8132
      [SCSI] mpt: fix disable lsi sas to use msi as default
      PCI: don't enable too many HT MSI mappings
      x86: fix init_memory_mapping() to handle small ranges

Yu Zhao (1):
      VT-d: handle Invalidation Queue Error to avoid system hang

leandro Costantino (1):
      Staging: rtl8187se: Fix oops and memory poison caused by builtin ieee80211.

roel kluin (1):
      sungem: another error printed one too early

wengang wang (1):
      ocfs2: add IO error check in ocfs2_get_sector()
