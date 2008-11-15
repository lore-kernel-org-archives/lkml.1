Return-Path: <linux-kernel-owner+w=401wt.eu-S1756217AbYKOW4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbYKOW4Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 17:56:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbYKOW4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 17:56:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59215 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752101AbYKOW4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 17:56:14 -0500
Date: Sat, 15 Nov 2008 14:55:28 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.28-rc5
Message-ID: <alpine.LFD.2.00.0811151444090.3468@nehalem.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hmm.. No clear pattern here, mostly random fixes, along with some file 
movement in the Documentation/ subdirectory. Bulk-wise, that's the biggest 
part if you see it as a traditional diff (because of the delete/create 
pairs), but with rename detection on the Doc patches are only about 10% of 
the changes.

The rest tends to be the ppc def_config updates (15%), and then random 
driver updates (65% - mostly due to some new hwmon and rtc drivers and the 
c2port driver).

But in number of commits, most of them are really just random small 
changes all over. ACPI, DM, USB, V4L, ocfs..  Nothing really strikes me as 
standing out, but if I had to pick something, then the ACPI update in 
particular hopefully fixes a few regressions. Along with disabling 
tick_nohz_kick_tick.

			Linus

---
Adam Litke (1):
      hugetlb: make unmap_ref_private multi-size-aware

Ajay Kumar Gupta (3):
      usb: musb: Fix for isochronous IN transfer
      usb: musb: Removes compilation warning in gadget mode
      usb: musb: fix BULK request on different available endpoints

Akinobu Mita (1):
      V4L/DVB (9494): anysee: initialize anysee_usb_mutex statically

Al Viro (2):
      el3_common_init() should be __devinit, not __init
      Fix inotify watch removal/umount races

Alan Cox (2):
      tty: trivial - fix up email addresses in tty related stuff
      telephony: trivial: fix up email address

Alan Jenkins (1):
      ACPI: EC: make kernel messages more useful when GPE storm is detected

Alan Stern (4):
      USB: don't register endpoints for interfaces that are going away
      USB: unusual_devs entry for Argosy USB mass-storage interface
      USB: EHCI: fix handling of dead controllers
      USB: EHCI: fix divide-by-zero bug

Albert Comerma (1):
      USB: SISUSB2VGA driver: add 0x0711, 0x0903

Alexey Dobriyan (1):
      af_key: mark policy as dead before destroying

Alexey Klimov (2):
      V4L/DVB (9337a): HID: Don't allow KWorld radio fm700 be handled by usb hid drivers
      V4L/DVB (9350): radio-si470x: add support for kworld usb radio

Alexey Starikovskiy (7):
      ACPI EC: Fix regression due to use of uninitialized variable
      ACPI: EC: revert msleep patch
      ACPI: EC: wait for last write gpe
      ACPI: EC: restart failed command
      ACPICA: Use spinlock for acpi_{en|dis}able_gpe
      ACPI: EC: lower interrupt storm treshold
      ACPI: EC: Don't do transaction from GPE handler in poll mode.

Andreas Schwab (1):
      powerpc: Fix msr check in compat_sys_swapcontext

Andrew Morton (3):
      alsa: fix snd_BUG_on() and friends
      remove ratelimt()
      kernel/kprobes.c: don't pad kretprobe_table_locks[] on uniprocessor builds

Andrew Vasquez (2):
      [SCSI] qla2xxx: Use pci_disable_rom() to manipulate PCI config space.
      [SCSI] qla2xxx: Update version number to 8.02.01-k9.

Andy Walls (5):
      V4L/DVB (9475): cx18: Disable write retries for registers that always change - part 1.
      V4L/DVB (9510): cx18: Fix write retries for registers that always change - part 2.
      V4L/DVB (9511): cx18: Mark CX18_CPU_DE_RELEASE_MDL as a slow API call
      V4L/DVB (9515): cx18: Use correct Mailbox IRQ Ack values and misc IRQ handling cleanup
      V4L/DVB (9516): cx18: Move DVB buffer transfer handling from irq handler to work_queue

Antoine Jacquet (1):
      V4L/DVB (9348): dtv5100: add dependency on zl10353

Antti Palosaari (1):
      V4L/DVB (9527): af9015: fix compile warnings

Avi Kivity (2):
      KVM: Require the PCI subsystem
      KVM: Fix pit memory leak if unable to allocate irq source id

Balbir Singh (1):
      sched: fix stale value in average load per task

Ben Hutchings (1):
      sfc: Correct address of gPXE boot configuration in EEPROM

Benjamin Thery (1):
      ipv6: fix ip6_mr_init error path

Bjorn Helgaas (11):
      ACPI: remove comments about debug layer/level to use
      ACPI: SBS: remove useless acpi_cm_sbs_init() initcall
      ACPI: remove CONFIG_ACPI_POWER
      ACPI: remove CONFIG_ACPI_EC
      PNP: add Bjorn Helgaas as PNP co-maintainer
      ACPI: consolidate ACPI_*_COMPONENT definitions in acpi_drivers.h
      ACPI: fix conflicting component definitions
      ACPI: add driver component definitions to sysfs debug_layers
      ACPI: turn off all debug output by default
      ACPI: update debug parameter documentation
      ACPI: pci_link: remove acpi_irq_balance_set() interface

Bob Jolliffe (1):
      rtl8187 : support for Sitecom WL-168 0001 v4

Brandon Philips (1):
      USB: cdc-acm.c: fix recursive lock in acm_start_wb error path

Brice Goglin (1):
      myri10ge: fix stop/go ordering even more

Chandra Seetharaman (3):
      dm mpath: avoid attempting to activate null path
      dm mpath: warn if args ignored
      dm: avoid destroying table in dm_any_congested

Chien Tung (2):
      RDMA/nes: Correct handling of PBL resources
      RDMA/nes: Mitigate compatibility issue regarding PCIe write credits

Christian Borntraeger (1):
      [S390] kvm_s390: Fix oops in virtio device detection with "mem="

Christof Schmitt (6):
      [SCSI] zfcp: Dont clear reference from SCSI device to unit
      [SCSI] zfcp: fix mempool usage for status_read requests
      [SCSI] zfcp: Fix request list handling in error path
      [SCSI] zfcp: Fix cast warning
      [SCSI] zfcp: Wait for port scan to complete when setting adapter online
      [SCSI] zfcp: Fix hexdump data in s390dbf traces

Cornelia Huck (1):
      [S390] cio: Fix refcount after moving devices.

Craig Shelley (1):
      USB: CP2101 Add device ID for AMB2560

Damir N Abdullin (1):
      + usb-serial-cp2101-add-enfora-gsm2228.patch added to -mm tree

Dan Williams (3):
      [4/4] dca: fixup initialization dependency
      iop-adma: add a dummy read to flush next descriptor update
      iop-adma: use iop_paranoia() for debug BUG_ONs

Daniel J Blueman (1):
      V4L/DVB (9492): unplug oops from dvb_frontend_init...

Darrick J. Wong (7):
      Fix platform drivers that crash on suspend/resume
      i5000-edac: hold reference to mci kobject
      adt7470: check input range when sysfs files are written
      adt7473: check inputs from sysfs writes
      lm85: support adt7468 chips
      adt7462: new hwmon driver
      ics932s401: new clock generator chip driver

Darron Broad (1):
      V4L/DVB (9499): cx88-mpeg: final fix for analogue only compilation + de-alloc fix

Dasgupta, Romit (1):
      [netdrvr] smc911x: fix for driver resume (and compilation warning)

Dave Airlie (2):
      drm/radeon: map registers at load time
      drm/i915: Filter pci devices based on PCI_CLASS_DISPLAY_VGA

Dave Chinner (1):
      [XFS] handle memory allocation failures during log initialisation

David Brownell (1):
      USB: gadget: cdc-acm deadlock fix

David Chinner (2):
      [XFS] Account for allocated blocks when expanding directories
      [XFS] XFS: Check for valid transaction headers in recovery

David Howells (13):
      KEYS: Make request key instantiate the per-user keyrings
      MN10300: Clean up the misalignment handler a little
      MN10300: Add built-in testing for misalignment handler
      MN10300: Add further misalignment fixups
      MN10300: Extract the displacement from an insn correctly in misalignment fixup
      MN10300: Fix register-postinc addressing misalignment handling
      MN10300: Allow misalignment fixup in interrupt handling
      MN10300: Perform misalignment fixups of MOV_Lcc
      MN10300: Handle misaligned postinc-with-imm addressing mode correctly
      MN10300: Fix misaligned index-register addressing handling
      MN10300: Handle misaligned SP-based operands
      MN10300: Don't handle misaligned loading and storing of SP
      MN10300: Don't do misalignment handling for userspace

David Rientjes (1):
      cpusets: update mems allowed in page allocator

David S. Miller (3):
      Revert "sparc: correct section of current_pc()"
      sparc64: Update defconfig.
      niu: Fix readq implementation when architecture does not provide one.

David Teigland (1):
      dlm: fix shutdown cleanup

David Woodhouse (1):
      Revert "x86: blacklist DMAR on Intel G31/G33 chipsets"

Denys Vlasenko (1):
      parisc: fix find_extend_vma() breakage

Divy Le Ray (2):
      cxgb3 - eeprom read fixes
      cxgb3 - Limit multiqueue setting to msi-x

Dmitri Monakhov (1):
      ocfs2: truncate outstanding block after direct io failure

Doug Leith (1):
      tcp_htcp: last_cong bug fix

Eric Anholt (4):
      ftrace: fix breakage in bin_fmt results
      i915: Don't whine when pci_enable_msi() fails.
      i915: Remove racy delayed vblank swap ioctl.
      drm: Remove infrastructure for supporting i915's vblank swapping.

Eric Dumazet (1):
      net: fix /proc/net/snmp as memory corruptor

Eric W. Biederman (1):
      vfs: fix shrink_submounts

FUJITA Tomonori (1):
      [SCSI] megaraid: fix mega_internal_command oops

Felipe Balbi (2):
      usb: musb: tusb6010: kill compile warning
      usb: musb: fix debug global variable name

Ferenc Wagner (1):
      vlan: Fix typos in proc output string

Francesco VIRLINZI (1):
      sh: Fixed the TMU0 reload value on resume

Frederic CAND (3):
      V4L/DVB (9495): cx88-blackbird: bugfix: cx88-blackbird-poll-fix
      V4L/DVB (9496): cx88-blackbird: bugfix: cx88-blackbird-mpeg-users
      V4L/DVB (9493): kconfig patch

Gautham R Shenoy (1):
      timers: handle HRTIMER_CB_IRQSAFE_UNLOCKED correctly from softirq context

Geert Uytterhoeven (2):
      m68k: Fix off-by-one in m68k_setup_user_interrupt()
      misc: C2port needs <linux/sched.h>

Geoff Levand (1):
      USB: Fix PS3 USB shutdown problems

Gerald Schaefer (1):
      [S390] Fix range for add_active_range() in setup_memory()

Greg Kroah-Hartman (1):
      USB: vstusb: fix compiler warning on x86-64

Gregor Jasny (1):
      V4L/DVB (9352): Add some missing compat32 ioctls

Hans Verkuil (3):
      V4L/DVB (9485): ivtv: remove incorrect V4L1 & tvaudio dependency
      V4L/DVB (9486): ivtv/ivtvfb: no longer experimental
      V4L/DVB (9506): ivtv/cx18: fix test whether modules should be loaded or not.

Harvey Harrison (1):
      netfilter: payload_len is be16, add size of struct rather than size of pointer

Heiko Carstens (6):
      [SCSI] zfcp: fix req_list_locking.
      [S390] sclp: emit error message if assign storage fails
      [S390] lockdep: fix compile bug
      [S390] ftrace: disable tracing on idle psw
      [S390] ftrace: fix kernel stack backchain walking
      [S390] cpu topology: fix locking

Heinz Mauelshagen (1):
      dm stripe: fix init failure

Helge Deller (1):
      fix cpumask build breakage on parisc

Henrik Rydberg (1):
      hwmon: applesmc: add support for Macbook 4

Huang Weiyi (1):
      LIS3LV02Dx: remove unused #include <version.h>

Ilpo Järvinen (1):
      RDMA/nes: Reindent mis-indented spinlocks

Ingo Molnar (1):
      sched: fix init_idle()'s use of sched_clock()

Ivan Kuten (1):
      rtl8187: Add Abocom USB ID

Jan Kara (3):
      ocfs2: Fix check of return value of ocfs2_start_trans()
      ocfs2: Fix checking of return value of new_inode()
      ocfs2: Let inode be really deleted when ocfs2_mknod_locked() fails

Jason Cooper (1):
      USB: net: asix: add support for Cables-to-Go USB Ethernet adapter

Jean Delvare (2):
      V4L/DVB (9337b): remove tuner-3036 and dpc7146 drivers from feature-removal-schedule.txt
      V4L/DVB (9372): Minor fixes to the saa7110 driver

Jean-Christophe Lallemand (1):
      atmel_spi: work-around required for new HW bug in AT91SAM9263 Rev.B SPI controller

Jean-Francois Moine (3):
      V4L/DVB (9367a): Add gspca driver and subdrivers to MAINTAINERS
      V4L/DVB (9556): gspca: Bad init sequence for sensor HV7131B in zc3xx.
      V4L/DVB (9557): gspca: Small changes for the sensor HV7131B in zc3xx.

Jianjun Kong (1):
      mac80211: fix a buffer overrun in station debug code

Joel Becker (5):
      ocfs2: Check xattr block signatures properly.
      ocfs2: Don't return -EFAULT from a corrupt xattr entry.
      ocfs2: Check errors from ocfs2_xattr_update_xattr_search()
      ocfs2: Specify appropriate journal access for new xattr buckets.
      ocfs2: Don't repeat ocfs2_xattr_block_find()

Johannes Berg (2):
      mac80211: fix notify_mac function
      hostap: pad the skb->cb usage in lieu of a proper fix

John Linn (1):
      GPIO: add new Xilinx driver for powerpc

Jonathan Corbet (1):
      V4L/DVB (9355): de-BKL cafe_ccic.c

Jonathan McDowell (1):
      [netdrvr] usb/hso: Cleanup rfkill error handling

KAMEZAWA Hiroyuki (1):
      memcg: bugfix for memory hotplug

KOSAKI Motohiro (2):
      mm: remove lru_add_drain_all() from the munlock path
      mm: remove unevictable's show_page_path

Kay Sievers (2):
      ACPI: struct device - replace bus_id with dev_name(), dev_set_name()
      dmaengine: struct device - replace bus_id with dev_name(), dev_set_name()

Keith Packard (3):
      i915: Save/restore MCHBAR_RENDER_STANDBY on GM965/GM45
      i915: Clean up sarea pointers on leavevt
      drm/i915: Move legacy breadcrumb out of the reserved status page area

Kenji Kaneshige (1):
      PCI: ignore bit0 of _OSC return code

Krzysztof Helt (1):
      V4L/DVB (9549): gspca: Fix a typo in one of gspca chips name.

Kumar Gala (2):
      powerpc/fsl-booke: Fix synchronization bug w/local tlb invalidates
      powerpc: Updated Freescale PPC related defconfigs

Lachlan McIlroy (2):
      [XFS] Fix use-after-free with log and quotas
      [XFS] Wait for all I/O on truncate to zero file size

Lalit Chandivade (1):
      [SCSI] qla2xxx: Correct Atmel flash-part handling.

Len Brown (1):
      Revert "ACPI: Ingore the RESET_REG_SUP bit when using ACPI reset mechanism"

Lennert Buytenhek (3):
      net: fix setting of skb->tail in skb_recycle_check()
      dsa: fix skb->pkt_type when mac address of slave interface differs
      dsa: fix master interface allmulti/promisc handling

Leslie Watter (1):
      USB: Add YISO u893 usb modem vendor and product IDs to option driver

Li Yang (1):
      powerpc: Update QE/CPM2 usb_ctlr structures for USB support

Li Zefan (2):
      freezer_cg: remove task_lock from freezer_fork()
      freezer_cg: disable writing freezer.state of root cgroup

Lin Ming (1):
      Delete an unwanted return statement at evgpe.c

Linus Torvalds (2):
      Move "exit_robust_list" into mm_release()
      Linux 2.6.28-rc5

Maciej Sosnowski (3):
      [1/4] I/OAT: fix channel resources free for not allocated channels
      [2/4] I/OAT: fix dma_pin_iovec_pages() error handling
      [3/4] I/OAT: fix async_tx.callback checking

Madhusudhan Chikkature (4):
      w1: export w1_read_8 function
      hdq driver for OMAP2430/3430
      hdq: bQ27000 HDQ Slave Interface Driver
      hdq: documentation for OMAP HDQ

Magnus Damm (2):
      i2c: fix i2c-sh_mobile rx underrun
      sh: early printk port type fix

Manu Abraham (1):
      V4L/DVB (9346): Optimization: Enable gate in a symmetric/disciplined way,

Marc Pignat (1):
      [libata] pata_pcmcia: another memory card support

Marcelo Tosatti (1):
      KVM: MMU: increase per-vcpu rmap cache alloc size

Marco Stornelli (1):
      DOC: update xip method info

Mark Brown (1):
      rtc: rtc-wm8350: add support for WM8350 RTC

Mark Fasheh (1):
      ocfs2: fix printk related build warnings in xattr.c

Mark Jackson (1):
      rtc: add Dallas DS1390/93/94 RTC chips

Mark Salter (1):
      [libata] pata_sch: notice attached slave devices

Martin Petermann (1):
      [SCSI] zfcp: fix erp timeout cleanup for port open requests

Martin Schwidefsky (2):
      [S390] fix s390x_newuname
      Add 'pr_fmt()' format modifier to pr_xyz macros.

Martyn Welch (2):
      powerpc/86xx: Correct SOC bus-frequency in GE Fanuc SBC610 DTS
      rtc: basic implementation of Epson RX-8581 I2C Real Time Clock

Masami Hiramatsu (1):
      kprobes: disable preempt for module_text_address() and kernel_text_address()

Matt Fleming (3):
      x86: HPET: convert WARN_ON to WARN_ON_ONCE
      x86: HPET: read from HPET_Tn_CMP() not HPET_T0_CMP
      x86: HPET: enter hpet_interrupt_handler with interrupts disabled

Matthew Garrett (1):
      sony-laptop: Ignore missing _DIS method on pic device

Matthias Fuchs (1):
      powerpc: Fix Book-E watchdog timer interval setting

Matthias Schwarzott (1):
      V4L/DVB (9357): cx88-dvb: Fix Oops in case i2c bus failed to register

Mauro Carvalho Chehab (12):
      V4L/DVB (9351): ibmcam: Fix a regression caused by a482f327ff56bc3cf53176a7eb736cea47291a1d
      V4L/DVB (9613): tvaudio: fix a memory leak
      V4L/DVB (9615): tvaudio: instead of using a magic number, use ARRAY_SIZE
      V4L/DVB (9616): tvaudio: cleanup - group all callbacks together
      V4L/DVB (9617): tvtime: remove generic_checkmode callback
      V4L/DVB (9618): tvaudio: add additional logic to avoid OOPS
      V4L/DVB (9619): tvaudio: update initial comments
      V4L/DVB (9620): tvaudio: use a direct reference for chip description
      V4L/DVB (9621): Avoid writing outside shadow.bytes[] array
      V4L/DVB (9622): tvaudio: Improve comments and remove a unneeded prototype
      V4L/DVB (9623): tvaudio: Improve debug msg by printing something more human
      V4L/DVB (9624): CVE-2008-5033: fix OOPS on tvaudio when controlling bass/treble

Michael Buesch (1):
      ssb: Fix DMA-API compilation for non-PCI systems

Michael Reed (1):
      [SCSI] qla2xxx: Return a FAILED status when abort mailbox-command fails.

Michel Marti (1):
      ALSA: hda - Add another HP model (6730s) for AD1884A

Mike Christie (1):
      [SCSI] scsi_error regression: Fix idempotent command handling

Mike Frysinger (1):
      SSB: hide empty sub menu

Mikulas Patocka (2):
      dm raid1: flush workqueue before destruction
      dm: move pending queue wake_up end_io_acct

Miquel van Smoorenburg (1):
      [SCSI] dpt_i2o: fix transferred data length for scsi_set_resid()

Myron Stowe (3):
      ACPI: Disambiguate processor declaration type
      ACPI: Behave uniquely based on processor declaration definition type
      ACPI: 80 column adherence and spelling fix (no functional change)

Neil Horman (1):
      bnx2: fix poll_controller to pass proper structures and check all rx queues

Nicolas Ferre (1):
      atmel_lcdfb: change irq_base definition to allow error reporting

Nicolas Pitre (1):
      [ARM] 5329/1: Feroceon: fix feroceon_l2_inv_range

Oleg Nesterov (1):
      fix for account_group_exec_runtime(), make sure ->signal can't be freed under rq->lock

Owen Taylor (1):
      i915: Don't attempt to short-circuit object_wait_rendering by checking domains.

Patrick Ohly (1):
      net: put_cmsg_compat + SO_TIMESTAMP[NS]: use same name for value as caller

Paul Bolle (1):
      USB: storage: adjust comment in Kconfig

Paul Mackerras (1):
      powerpc: Update desktop/server defconfigs

Paul Mundt (4):
      sh: Handle fixmap TLB eviction more coherently.
      sh: Provide a sane valid_phys_addr_range() to prevent TLB reset with PMB.
      sh: Don't factor in PAGE_OFFSET for valid_phys_addr_range() check.
      serial: sh-sci: Reorder the SCxTDR write after the TDxE clear.

Paul Ready (1):
      USB: add Nikon D300 camera to unusual_devs

Paulius Zaleckas (1):
      hso: rfkill type should be WWAN

Pavel Machek (1):
      LIS3LV02Dx Accelerometer driver

Pete Zaitcev (1):
      ub: stub pre_reset and post_reset to fix oops

Peter Gruber (1):
      ACPI: avoid empty file name in sysfs

Peter Zijlstra (4):
      sched: clean up debug info
      sched: release buddies on yield
      hrtimer: clean up unused callback modes
      slab: document SLAB_DESTROY_BY_RCU

Qinghuang Feng (1):
      [libata] pata_cs553*.c: cleanup kernel-doc

Rabin Vincent (1):
      USB: mention URB_FREE_BUFFER in usb_free_urb documentation

Rafael Diniz (2):
      V4L/DVB (9368): VBI fix for cx88 cards
      V4L/DVB (9369): Documentation update for cx88

Rafael J. Wysocki (1):
      x86: Make NUMA on 32-bit depend on BROKEN

Rakib Mullick (1):
      x86: KVM guest: fix section mismatch warning in kvmclock.c

Ralph Campbell (1):
      IB/ipath: Fix RDMA write with immediate copy of last packet

Randy Dunlap (4):
      fujitsu-laptop: fix section mismatch warning
      DOC: add printk-formats.txt
      Create/use more directory structure in the Documentation/ tree.
      9p: restrict RDMA usage

Ricky Wong (1):
      usb: unusual devs patch for Nokia 7610 Supernova

Rodolfo Giometti (2):
      Add c2 port support
      c2port: add c2port support for Eurotech Duramar 2150

Roland Dreier (3):
      RDMA/cxgb3: Fix too-big reserved field zeroing in iwch_post_zb_read()
      mlx4_core: Fix unused variable warning
      libata: Avoid overflow in ata_tf_read_block() when tf->hba_lbal > 127

Russell King (7):
      [ARM] realview: correct MMC clock rate
      [ARM] versatile: correct MMC clock rate
      [ARM] iop: iop3xx needs registers mapped uncached+unbuffered
      [ARM] dma-mapping: fix compiler warning
      [ARM] integrator,realview,versatile: remove FLASH_* and EPROM_* constants
      [ARM] cdb89712,clps7500,h720x: avoid namespace clash for FLASH_* constants
      [ARM] cdb89712: avoid namespace clashes with SRAM_ and BOOTROM_ constants

Sebastian Andrzej Siewior (1):
      USB: remove optional bus bindings in isp1760, fixing runtime warning

Sheng Yang (1):
      KVM: VMX: Set IGMT bit in EPT entry

Shyam Sundar (1):
      [SCSI] qla2xxx: Do not honour max_vports from firmware for 2G ISPs and below.

Simon Arlott (1):
      Kconfig: SLUB is the default slab allocator

Stefan Haberland (1):
      [S390] dasd: log sense for fatal errors

Stefan Roscher (1):
      IB/ehca: Remove reference to special QP in case of port activation failure

Steve Wise (2):
      RDMA/cxgb3: deadlock in iw_cxgb3 can cause hang when configuring interface.
      RDMA/cxgb3: Fix deadlock in iw_cxgb3 (hang when configuring interface)

Steven Rostedt (4):
      ftrace: update txt document
      ftrace: ftrace.txt version update
      ftrace: disable tracing on resize
      ring-buffer: prevent infinite looping on time stamping

Stuart MENEFY (1):
      sh: __copy_user function can corrupt the stack in case of exception

Sunil Mushran (1):
      ocfs2: Set journal descriptor to NULL after journal shutdown

Suresh Siddha (1):
      V4L/DVB (9356): [PATCH] saa7134: fix resource map sanity check conflict

Takashi Iwai (5):
      ALSA: hda - Limit the number of GPIOs show in proc
      ALSA: hda - Add a quirk for MEDION MD96630
      ALSA: hda - Add missing analog-mux mixer creation for STAC9200
      ALSA: hda - Fix input pin initialization for STAC/IDT codecs
      ALSA: hda - Fix IDT/STAC multiple HP detection

Tao Ma (5):
      ocfs2: Remove unused ocfs2_restore_xattr_block().
      ocfs2: Fix some typos in xattr annotations.
      ocfs2: Fix check of return value of ocfs2_start_trans() in xattr.c.
      ocfs2: return 0 in page_mkwrite to let VFS retry.
      ocfs2/xattr: Proper hash collision handle in bucket division

Tejun Heo (3):
      libata: revert convert-to-block-tagging patches
      libata: fix last_reset timestamp handling
      libata: improve phantom device detection

Theodore Tso (1):
      ext3: Clean up outdated and incorrect comment for ext3_write_super()

Thierry MERLE (1):
      V4L/DVB (9358): CinergyT2: fix Kconfig typo

Thomas Gleixner (2):
      irq: call __irq_enter() before calling the tick_idle_check
      nohz: disable tick_nohz_kick_tick() for now

Thomas Renninger (10):
      ACPI: video: Ignore devices that aren't present in hardware
      ACPI video: if no ACPI backlight support, use vendor drivers
      Acer-WMI: fingers off backlight if video.ko is serving this functionality
      asus-acpi: fingers off backlight if video.ko is serving this functionality
      compal: fingers off backlight if video.ko is serving this functionality
      eeepc-laptop: fingers off backlight if video.ko is serving this functionality
      fujitsu-laptop: fingers off backlight if video.ko is serving this functionality
      msi-laptop: fingers off backlight if video.ko is serving this functionality
      sony-laptop: fingers off backlight if video.ko is serving this functionality
      thinkpad_acpi: fingers off backlight if video.ko is serving this functionality

Thomas, Sujith (2):
      intel_menlow: Add comment documenting legal GTHS values
      intel_menlow: MAINTAINERS

Tiger Yang (5):
      ocfs2: fix license in xattr
      ocfs2: fix function declaration and definition in xattr
      ocfs2: remove duplicate definition in xattr
      ocfs2: add handler_map array bounds checking
      ocfs2: Check search result in ocfs2_xattr_block_get()

Tim Blechmann (2):
      ALSA: HDSP: check for io box before uploading firmware
      ALSA: hdsp: check for iobox and upload firmware during ioctl

Tobias Lorenz (1):
      V4L/DVB (9482): Documentation, especially regarding audio and informational links

Tony Vroon (1):
      fujitsu-laptop: Add DMI callback for Lifebook S6420

Travis Place (1):
      ALSA: hda - Make the HP EliteBook 8530p use AD1884A model laptop

Trent Piepho (1):
      powerpc: Repair device bindings documentation

Vadim Makhervaks (1):
      RDMA/nes: Fix CQ allocation scheme for multicast receive queue apps

Venki Pallipadi (1):
      i7300_idle: Kconfig, show menu only on x86_64

Ville Syrjala (1):
      ALSA: gusextreme: Fix build errors

Vladimir Sokolovsky (1):
      IB/mlx4: Set umem field to NULL in mlx4_ib_alloc_fast_reg_mr()

Xiantao Zhang (2):
      KVM: ia64: Use guest signal mask when blocking
      KVM: ia64: fix vmm_spin_{un}lock for !CONFIG_SMP

Yevgeny Petrilin (1):
      mlx4_en: Start port error flow bug fix

Yinghai Lu (1):
      ACPI: use macro to replace hard number

Yoshihiro Shimoda (4):
      serial: sh-sci: fix cannot work SH7723 SCIFA
      fix sci type for SH7723
      usb: r8a66597-hcd: fix wrong data access in SuperH on-chip USB
      usb: r8a66597-hcd: fix wrong data access in SuperH on-chip USB

Yossi Etigin (3):
      IPoIB: Don't enable NAPI when it's already enabled
      IPoIB: Fix hang in ipoib_flush_paths()
      IPoIB: Fix crash in path_rec_completion()

Zhang Rui (2):
      ACPI: bugfix reporting of event handler status
      intel_menlow: don't set max_state a negative value

Zhao Yakui (2):
      ACPI: fix de-reference bug in power resource driver
      ACPI: fan: Delete the strict check in power transition

roel kluin (1):
      V4L/DVB (9524): af9013: fix bug in status reading
