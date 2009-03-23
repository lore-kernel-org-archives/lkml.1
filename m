Return-Path: <linux-kernel-owner+w=401wt.eu-S1754339AbZCWXbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbZCWXbB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 19:31:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbZCWXav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 19:30:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56274 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750906AbZCWXat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 19:30:49 -0400
Date: Mon, 23 Mar 2009 16:29:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.29
Message-ID: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It's out there now, or at least in the process of getting mirrored out.

The most obvious change is the (temporary) change of logo to Tuz, the 
Tasmanian Devil. But there's a number of driver updates and some m68k 
header updates (fixing headers_install after the merge of non-MMU/MMU) 
that end up being pretty noticeable in the diffs.

The shortlog (from -rc8, obviously - the full logs from 2.6.28 are too big 
to even contemplate attaching here) is appended, and most of the non-logo 
changes really shouldn't be all that noticeable to most people. Nothing 
really exciting, although I admit to fleetingly considering another -rc 
series just because the changes are bigger than I would have wished for 
this late in the game. But there was little point in holding off the real 
release any longer, I feel.

This obviously starts the merge window for 2.6.30, although as usual, I'll 
probably wait a day or two before I start actively merging. I do that in 
order to hopefully result in people testing the final plain 2.6.29 a bit 
more before all the crazy changes start up again.

		Linus

---
Aaro Koskinen (2):
      ARM: OMAP: sched_clock() corrected
      ARM: OMAP: Allow I2C bus driver to be compiled as a module

Abhijeet Joglekar (2):
      [SCSI] libfc: Pass lport in exch_mgr_reset
      [SCSI] libfc: when rport goes away (re-plogi), clean up exchanges to/from rport

Achilleas Kotsis (1):
      USB: Add device id for Option GTM380 to option driver

Al Viro (1):
      net: fix sctp breakage

Alan Stern (2):
      USB: usbfs: keep async URBs until the device file is closed
      USB: EHCI: expedite unlinks when the root hub is suspended

Albert Pauw (1):
      USB: option.c: add ZTE 622 modem device

Alexander Duyck (1):
      igb: remove ASPM L0s workaround

Andrew Vasquez (4):
      [SCSI] qla2xxx: Correct address range checking for option-rom updates.
      [SCSI] qla2xxx: Correct truncation in return-code status checking.
      [SCSI] qla2xxx: Correct overwrite of pre-assigned init-control-block structure size.
      [SCSI] qla2xxx: Update version number to 8.03.00-k4.

Andy Whitcroft (1):
      suspend: switch the Asus Pundit P1-AH2 to old ACPI sleep ordering

Anirban Chakraborty (1):
      [SCSI] qla2xxx: Correct vport delete bug.

Anton Vorontsov (1):
      ucc_geth: Fix oops when using fixed-link support

Antti Palosaari (1):
      V4L/DVB (10972): zl10353: i2c_gate_ctrl bug fix

Axel Wachtler (1):
      USB: serial: add FTDI USB/Serial converter devices

Ben Dooks (6):
      [ARM] S3C64XX: Set GPIO pin when select IRQ_EINT type
      [ARM] S3C64XX: Rename IRQ_UHOST to IRQ_USBH
      [ARM] S3C64XX: Fix name of USB host clock.
      [ARM] S3C64XX: Fix USB host clock mux list
      [ARM] S3C64XX: sparse warnings in arch/arm/plat-s3c64xx/s3c6400-clock.c
      [ARM] S3C64XX: sparse warnings in arch/arm/plat-s3c64xx/irq.c

Benjamin Herrenschmidt (2):
      emac: Fix clock control for 405EX and 405EXr chips
      radeonfb: Whack the PCI PM register until it sticks

Benny Halevy (1):
      NFSD: provide encode routine for OP_OPENATTR

Bjørn Mork (1):
      ipv6: fix display of local and remote sit endpoints

Borislav Petkov (1):
      ide-floppy: do not map dataless cmds to an sg

Carlos Corbacho (2):
      acpi-wmi: Unmark as 'experimental'
      acer-wmi: Unmark as 'experimental'

Chris Leech (3):
      [SCSI] libfc: rport retry on LS_RJT from certain ELS
      [SCSI] fcoe: fix handling of pending queue, prevent out of order frames (v3)
      ixgbe: fix multiple unicast address support

Chris Mason (2):
      Btrfs: Fix locking around adding new space_info
      Btrfs: Clear space_info full when adding new devices

Christoph Paasch (2):
      netfilter: conntrack: fix dropping packet after l4proto->packet()
      netfilter: conntrack: check for NEXTHDR_NONE before header sanity checking

Chuck Lever (2):
      NLM: Shrink the IPv4-only version of nlm_cmp_addr()
      NLM: Fix GRANT callback address comparison when IPv6 is enabled

Corentin Chary (4):
      asus-laptop: restore acpi_generate_proc_event()
      eeepc-laptop: restore acpi_generate_proc_event()
      asus-laptop: use select instead of depends on
      platform/x86: depends instead of select for laptop platform drivers

Cyrill Gorcunov (1):
      acpi: check for pxm_to_node_map overflow

Daisuke Nishimura (1):
      vmscan: pgmoved should be cleared after updating recent_rotated

Dan Carpenter (1):
      acer-wmi: double free in acer_rfkill_exit()

Dan Williams (1):
      USB: Option: let cdc-acm handle Sony Ericsson F3507g / Dell 5530

Darius Augulis (1):
      MX1 fix include

Dave Jones (1):
      via-velocity: Fix DMA mapping length errors on transmit.

David Brownell (2):
      ARM: OMAP: Fix compile error if pm.h is included
      dm9000: locking bugfix

David S. Miller (3):
      dnet: Fix warnings on 64-bit.
      xfrm: Fix xfrm_state_find() wrt. wildcard source address.
      sparc64: Reschedule KGDB capture to a software interrupt.

Davide Libenzi (1):
      eventfd: remove fput() call from possible IRQ context

Dhananjay Phadke (1):
      netxen: remove old flash check.

Dirk Hohndel (1):
      USB: Add Vendor/Product ID for new CDMA U727 to option driver

Eilon Greenstein (3):
      bnx2x: Adding restriction on sge_buf_size
      bnx2x: Casting page alignment
      bnx2x: Using DMAE to initialize the chip

Enrik Berkhan (1):
      nommu: ramfs: pages allocated to an inode's pagecache may get wrongly discarded

Eric Sandeen (3):
      ext4: fix header check in ext4_ext_search_right() for deep extent trees.
      ext4: fix bogus BUG_ONs in in mballoc code
      ext4: fix bb_prealloc_list corruption due to wrong group locking

FUJITA Tomonori (1):
      ide: save the returned value of dma_map_sg

Geert Uytterhoeven (1):
      ps3/block: Replace mtd/ps3vram by block/ps3vram

Geoff Levand (1):
      powerpc/ps3: ps3_defconfig updates

Gerald Schaefer (1):
      [S390] Dont check for pfn_valid() in uaccess_pt.c

Gertjan van Wingerde (1):
      Update my email address

Grant Grundler (2):
      parisc: fix wrong assumption about bus->self
      parisc: update MAINTAINERS

Grant Likely (1):
      Fix Xilinx SystemACE driver to handle empty CF slot

Greg Kroah-Hartman (3):
      USB: usbtmc: fix stupid bug in open()
      USB: usbtmc: add protocol 1 support
      Staging: benet: remove driver now that it is merged in drivers/net/

Greg Ungerer (8):
      m68k: merge the non-MMU and MMU versions of param.h
      m68k: merge the non-MMU and MMU versions of swab.h
      m68k: merge the non-MMU and MMU versions of sigcontext.h
      m68k: use MMU version of setup.h for both MMU and non-MMU
      m68k: merge the non-MMU and MMU versions of ptrace.h
      m68k: merge the non-MMU and MMU versions of signal.h
      m68k: use the MMU version of unistd.h for all m68k platforms
      m68k: merge the non-MMU and MMU versions of siginfo.h

Gregory Lardiere (1):
      V4L/DVB (10789): m5602-s5k4aa: Split up the initial sensor probe in chunks.

Hans Werner (1):
      V4L/DVB (10977): STB6100 init fix, the call to stb6100_set_bandwidth needs an argument

Hartley Sweeten (1):
      [ARM] 5419/1: ep93xx: fix build warnings about struct i2c_board_info

Heiko Carstens (2):
      [S390] topology: define SD_MC_INIT to fix performance regression
      [S390] ftrace/mcount: fix kernel stack backchain

Helge Deller (7):
      parisc: BUG_ON() cleanup
      parisc: fix section mismatch warnings
      parisc: fix `struct pt_regs' declared inside parameter list warning
      parisc: remove unused local out_putf label
      parisc: fix dev_printk() compile warnings for accessing a device struct
      parisc: add braces around arguments in assembler macros
      parisc: fix 64bit build

Herbert Xu (1):
      gro: Fix legacy path napi_complete crash

Huang Ying (1):
      dm crypt: fix kcryptd_async_done parameter

Ian Dall (1):
      Bug 11061, NFS mounts dropped

Igor M. Liplianin (1):
      V4L/DVB (10976): Bug fix: For legacy applications stv0899 performs search only first time after insmod.

Ilya Yanok (3):
      dnet: Dave DNET ethernet controller driver (updated)
      dnet: replace obsolete *netif_rx_* functions with *napi_*
      dnet: DNET should depend on HAS_IOMEM

Ingo Molnar (1):
      kconfig: improve seed in randconfig

J. Bruce Fields (1):
      nfsd: nfsd should drop CAP_MKNOD for non-root

James Bottomley (1):
      parisc: remove klist iterators

Jan Dumon (1):
      USB: unusual_devs: Add support for GI 0431 SD-Card interface

Jay Vosburgh (1):
      bonding: Fix updating of speed/duplex changes

Jeff Moyer (1):
      aio: lookup_ioctx can return the wrong value when looking up a bogus context

Jiri Slaby (8):
      ACPI: remove doubled status checking
      USB: atm/cxacru, fix lock imbalance
      USB: image/mdc800, fix lock imbalance
      USB: misc/adutux, fix lock imbalance
      USB: misc/vstusb, fix lock imbalance
      USB: wusbcore/wa-xfer, fix lock imbalance
      ALSA: pcm_oss, fix locking typo
      ALSA: mixart, fix lock imbalance

Jody McIntyre (1):
      trivial: fix orphan dates in ext2 documentation

Johannes Weiner (3):
      HID: fix incorrect free in hiddev
      HID: fix waitqueue usage in hiddev
      nommu: ramfs: don't leak pages when adding to page cache fails

John Dykstra (1):
      ipv6:  Fix BUG when disabled ipv6 module is unloaded

John W. Linville (1):
      lib80211: silence excessive crypto debugging messages

Jorge Boncompte [DTI2] (1):
      netns: oops in ip[6]_frag_reasm incrementing stats

Jouni Malinen (3):
      mac80211: Fix panic on fragmentation with power saving
      zd1211rw: Do not panic on device eject when associated
      nl80211: Check that function pointer != NULL before using it

Karsten Wiese (1):
      USB: EHCI: Fix isochronous URB leak

Kay Sievers (1):
      parisc: dino: struct device - replace bus_id with dev_name(), dev_set_name()

Koen Kooi (1):
      ARM: OMAP: board-omap3beagle: set i2c-3 to 100kHz

Krzysztof Helt (1):
      ALSA: opl3sa2 - Fix NULL dereference when suspending snd_opl3sa2

Kumar Gala (2):
      powerpc/mm: Respect _PAGE_COHERENT on classic ppc32 SW
      powerpc/mm: Fix Respect _PAGE_COHERENT on classic ppc32 SW TLB load machines

Kyle McMartin (8):
      parisc: fix use of new cpumask api in irq.c
      parisc: convert (read|write)bwlq to inlines
      parisc: convert cpu_check_affinity to new cpumask api
      parisc: define x->x mmio accessors
      parisc: update defconfigs
      parisc: sba_iommu: fix build bug when CONFIG_PARISC_AGP=y
      tulip: fix crash on iface up with shirq debug
      Build with -fno-dwarf2-cfi-asm

Lalit Chandivade (1):
      [SCSI] qla2xxx: Use correct value for max vport in LOOP topology.

Len Brown (1):
      Revert "ACPI: make some IO ports off-limits to AML"

Lennert Buytenhek (1):
      mv643xx_eth: fix unicast address filter corruption on mtu change

Li Zefan (1):
      block: fix memory leak in bio_clone()

Linus Torvalds (7):
      Fix potential fast PIT TSC calibration startup glitch
      Fast TSC calibration: calculate proper frequency error bounds
      Avoid 64-bit "switch()" statements on 32-bit architectures
      Add '-fwrapv' to gcc CFLAGS
      Fix race in create_empty_buffers() vs __set_page_dirty_buffers()
      Move cc-option to below arch-specific setup
      Linux 2.6.29

Luis R. Rodriguez (2):
      ath9k: implement IO serialization
      ath9k: AR9280 PCI devices must serialize IO as well

Maciej Sosnowski (1):
      dca: add missing copyright/license headers

Manu Abraham (1):
      V4L/DVB (10975): Bug: Use signed types, Offsets and range can be negative

Mark Brown (5):
      [ARM] S3C64XX: Fix section mismatch for s3c64xx_register_clocks()
      [ARM] SMDK6410: Correct I2C device name for WM8580
      [ARM] SMDK6410: Declare iodesc table static
      [ARM] S3C64XX: Staticise s3c64xx_init_irq_eint()
      [ARM] S3C64XX: Do gpiolib configuration earlier

Mark Lord (1):
      sata_mv: fix MSI irq race condition

Martin Schwidefsky (3):
      [S390] __div64_31 broken for CONFIG_MARCH_G5
      [S390] make page table walking more robust
      [S390] make page table upgrade work again

Masami Hiramatsu (2):
      prevent boosting kprobes on exception address
      module: fix refptr allocation and release order

Mathieu Chouquet-Stringer (1):
      thinkpad-acpi: fix module autoloading for older models

Matthew Wilcox (1):
      [SCSI] sd: Don't try to spin up drives that are connected to an inactive port

Matthias Schwarzzot (1):
      V4L/DVB (10978): Report tuning algorith correctly

Mauro Carvalho Chehab (1):
      V4L/DVB (10834): zoran: auto-select bt866 for AverMedia 6 Eyes

Michael Chan (1):
      bnx2: Fix problem of using wrong IRQ handler.

Michael Hennerich (1):
      USB: serial: ftdi: enable UART detection on gnICE JTAG adaptors blacklist interface0

Mike Travis (1):
      parisc: update parisc for new irq_desc

Miklos Szeredi (1):
      fix ptrace slowness

Mikulas Patocka (3):
      dm table: rework reference counting fix
      dm io: respect BIO_MAX_PAGES limit
      sparc64: Fix crash with /proc/iomem

Milan Broz (2):
      dm ioctl: validate name length when renaming
      dm crypt: wait for endio to complete before destruction

Moritz Muehlenhoff (1):
      USB: Updated unusual-devs entry for USB mass storage on Nokia 6233

Nobuhiro Iwamatsu (2):
      sh_eth: Change handling of IRQ
      sh_eth: Fix mistake of the address of SH7763

Pablo Neira Ayuso (2):
      netfilter: conntrack: don't deliver events for racy packets
      netfilter: ctnetlink: fix crash during expectation creation

Pantelis Koukousoulas (1):
      virtio_net: Make virtio_net support carrier detection

Piotr Ziecik (1):
      powerpc/5200: Enable CPU_FTR_NEED_COHERENT for MPC52xx

Ralf Baechle (1):
      MIPS: Mark Eins: Fix configuration.

Robert Love (11):
      [SCSI] libfc: Don't violate transport template for rogue port creation
      [SCSI] libfc: correct RPORT_TO_PRIV usage
      [SCSI] libfc: rename rp to rdata in fc_disc_new_target()
      [SCSI] libfc: check for err when recv and state is incorrect
      [SCSI] libfc: Cleanup libfc_function_template comments
      [SCSI] libfc, fcoe: Fix kerneldoc comments
      [SCSI] libfc, fcoe: Cleanup function formatting and minor typos
      [SCSI] libfc, fcoe: Remove unnecessary cast by removing inline wrapper
      [SCSI] fcoe: Use setup_timer() and mod_timer()
      [SCSI] fcoe: Correct fcoe_transports initialization vs. registration
      [SCSI] fcoe: Change fcoe receive thread nice value from 19 (lowest priority) to -20

Robert M. Kenney (1):
      USB: serial: new cp2101 device id

Roel Kluin (3):
      [SCSI] fcoe: fix kfree(skb)
      acpi-wmi: unsigned cannot be less than 0
      net: kfree(napi->skb) => kfree_skb

Ron Mercer (4):
      qlge: bugfix: Increase filter on inbound csum.
      qlge: bugfix: Tell hw to strip vlan header.
      qlge: bugfix: Move netif_napi_del() to common call point.
      qlge: bugfix: Pad outbound frames smaller than 60 bytes.

Russell King (2):
      [ARM] update mach-types
      [ARM] Fix virtual to physical translation macro corner cases

Rusty Russell (1):
      linux.conf.au 2009: Tuz

Saeed Bishara (1):
      [ARM] orion5x: pass dram mbus data to xor driver

Sam Ravnborg (1):
      kconfig: fix randconfig for choice blocks

Sathya Perla (3):
      net: Add be2net driver.
      be2net: replenish when posting to rx-queue is starved in out of mem conditions
      be2net: fix to restore vlan ids into BE2 during a IF DOWN->UP cycle

Scott James Remnant (1):
      sbus: Auto-load openprom module when device opened.

Sigmund Augdal (1):
      V4L/DVB (10974): Use Diseqc 3/3 mode to send data

Stanislaw Gruszka (1):
      net: Document /proc/sys/net/core/netdev_budget

Stephen Hemminger (1):
      sungem: missing net_device_ops

Stephen Rothwell (1):
      net: update dnet.c for bus_id removal

Steve Glendinning (1):
      smsc911x: reset last known duplex and carrier on open

Steve Ma (1):
      [SCSI] libfc: exch mgr is freed while lport still retrying sequences

Stuart MENEFY (1):
      libata: Keep shadow last_ctl up to date during resets

Suresh Jayaraman (1):
      NFS: Handle -ESTALE error in access()

Takashi Iwai (3):
      ALSA: hda - Fix DMA mask for ATI controllers
      ALSA: hda - Workaround for buggy DMA position on ATI controllers
      ALSA: Fix vunmap and free order in snd_free_sgbuf_pages()

Tao Ma (2):
      ocfs2: Fix a bug found by sparse check.
      ocfs2: Use xs->bucket to set xattr value outside

Tejun Heo (1):
      ata_piix: add workaround for Samsung DB-P70

Theodore Ts'o (1):
      ext4: Print the find_group_flex() warning only once

Thomas Bartosik (1):
      USB: storage: Unusual USB device Prolific 2507 variation added

Tiger Yang (2):
      ocfs2: reserve xattr block for new directory with inline data
      ocfs2: tweak to get the maximum inline data size with xattr

Tilman Schmidt (1):
      bas_gigaset: correctly allocate USB interrupt transfer buffer

Trond Myklebust (6):
      SUNRPC: Tighten up the task locking rules in __rpc_execute()
      NFS: Fix misparsing of nfsv4 fs_locations attribute (take 2)
      NFSv3: Fix posix ACL code
      SUNRPC: Fix an Oops due to socket not set up yet...
      SUNRPC: xprt_connect() don't abort the task if the transport isn't bound
      NFS: Fix the fix to Bugzilla #11061, when IPv6 isn't defined...

Tyler Hicks (3):
      eCryptfs: don't encrypt file key with filename key
      eCryptfs: Allocate a variable number of pages for file headers
      eCryptfs: NULL crypt_stat dereference during lookup

Uwe Kleine-König (2):
      [ARM] 5418/1: restore lr before leaving mcount
      [ARM] 5421/1: ftrace: fix crash due to tracing of __naked functions

Vasu Dev (5):
      [SCSI] libfc: handle RRQ exch timeout
      [SCSI] libfc: fixed a soft lockup issue in fc_exch_recv_abts
      [SCSI] libfc, fcoe: fixed locking issues with lport->lp_mutex around lport->link_status
      [SCSI] libfc: fixed a read IO data integrity issue when a IO data frame lost
      [SCSI] fcoe: Out of order tx frames was causing several check condition SCSI status

Viral Mehta (1):
      ALSA: oss-mixer - Fixes recording gain control

Vitaly Wool (1):
      V4L/DVB (10832): tvaudio: Avoid breakage with tda9874a

Werner Almesberger (1):
      [ARM] S3C64XX: Fix s3c64xx_setrate_clksrc

Yi Zou (2):
      [SCSI] libfc: do not change the fh_rx_id of a recevied frame
      [SCSI] fcoe: ETH_P_8021Q is already in if_ether and fcoe is not using it anyway

Zhang Le (2):
      MIPS: Fix TIF_32BIT undefined problem when seccomp is disabled
      filp->f_pos not correctly updated in proc_task_readdir

Zhang Rui (1):
      ACPI suspend: Blacklist Toshiba Satellite L300 that requires to set SCI_EN directly on resume

françois romieu (2):
      r8169: use hardware auto-padding.
      r8169: revert "r8169: read MAC address from EEPROM on init (2nd attempt)"

un'ichi Nomura (1):
      block: Add gfp_mask parameter to bio_integrity_clone()
