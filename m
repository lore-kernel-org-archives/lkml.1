Return-Path: <linux-kernel-owner+w=401wt.eu-S1755846AbYGMWob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbYGMWob (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 18:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753028AbYGMWoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 18:44:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48845 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751531AbYGMWoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 18:44:22 -0400
Date: Sun, 13 Jul 2008 15:44:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.26
Message-ID: <alpine.LFD.1.10.0807131531050.3305@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So it's been almost three months since 2.6.25 (87 days to be exact, I 
think), making this a longer-than-usual release cycle. Or maybe it just 
feels that way, and we're always getting close to three months these days.

But it's out there now. Or rather, the git tree is out there, and the 
patch/tar-ball is still uploading as I write this.

The diffs from -rc9 are pretty small, with with the bulk actually being 
Documentation updates (almost 80% is just added docs). The rest tensd to 
be one-liners for some regressions or otherwise pretty small patches. 

Several regressions did get fixed in the last few days, thanks to 
everybody involved.

dirstat since -rc9:

   3.3% Documentation/networking/
  78.5% Documentation/
   2.5% arch/
   2.4% drivers/net/wireless/
   4.0% drivers/net/
   2.0% drivers/usb/host/
   2.1% drivers/usb/
   9.4% drivers/
   2.0% fs/
   3.6% net/

and dirstat for the whole release since 2.6.25 (yeah, Documentation 
doesn't even show up in the latter :^):

   4.9% arch/arm/
   9.0% arch/powerpc/configs/
  11.8% arch/powerpc/
  28.7% arch/
   5.0% drivers/media/video/
   9.2% drivers/media/
   5.5% drivers/net/sk98lin/
   6.6% drivers/net/wireless/
  17.8% drivers/net/
   4.8% drivers/s390/net/
   5.3% drivers/s390/
  49.7% drivers/
   6.4% include/
   5.1% net/

Have fun,

		Linus

---
Alan Stern (1):
      [SCSI] erase invalid data returned by device

Alessandro Zummo (1):
      rtc-fm3130: fix chip naming

Andres Salomon (1):
      ov7670: clean up ov7670_read semantics

Andrew Morton (1):
      tcp: net/ipv4/tcp.c needs linux/scatterlist.h

Andrey Vagin (1):
      ipv6: fix race between ipv6_del_addr and DAD timer

Anthony Liguori (1):
      x86: KVM guest: Add memory clobber to hypercalls

Bartlomiej Zolnierkiewicz (2):
      ide: add __ide_default_irq() inline helper
      it8213: fix return value in it8213_init_one()

Ben Hutchings (1):
      ipv4: fib_trie: Fix lookup error return

Benjamin Herrenschmidt (1):
      powerpc: Fix unterminated of_device_id array in legacy_serial.c

Brian King (1):
      [SCSI] ipr: Fix HDIO_GET_IDENTITY oops for SATA devices

Dan Williams (1):
      md: ensure all blocks are uptodate or locked when syncing

Daniel Guilak (3):
      kernel/printk.c: Made printk_recursion_bug_msg static.
      kernel/kprobes.c: Made kprobe_blacklist static.
      arch/x86/kernel/.gitignore: Added vmlinux.lds to .gitignore file because it shouldn't be tracked.

Darren Jenkins (4):
      drivers/net/wireless/iwlwifi/iwl-3945.c Fix type issue on 64bit
      crypto: tcrypt - Fix memory leak in test_cipher
      drivers/char/pcmcia/ipwireless/hardware.c fix resource leak
      drivers/isdn/i4l/isdn_common.c fix small resource leak

Dave Chinner (1):
      Fix reference counting race on log buffers

David Gibson (1):
      Correct hash flushing from huge_ptep_set_wrprotect()

David Howells (2):
      netfilter: nf_nat_snmp_basic: fix a range check in NAT for SNMP
      frv: fix irqs_disabled() to return an int, not an unsigned long

Denis V. Lunev (2):
      netlabel: netlink_unicast calls kfree_skb on error path by itself
      ipv6: missed namespace context in ipv6_rthdr_rcv

Dmitry Adamushko (3):
      sched: fix cpu hotplug
      slub: Fix use-after-preempt of per-CPU data structure
      cpusets, hotplug, scheduler: fix scheduler domain breakage

Eric W. Biederman (1):
      serial8250: sanity check nr_uarts on all paths.

Eugene Surovegin (1):
      rapidio: fix device reference counting

Firat Birlik (1):
      zd1211rw: add ID for AirTies WUS-201

Guy Cohen (1):
      mac80211: move netif_carrier_on to after ieee80211_bss_info_change_notify

Herbert Xu (1):
      crypto: chainiv - Invoke completion function

Hugh Dickins (1):
      exec: fix stack excutability without PT_GNU_STACK

Ihar Hrachyshka (1):
      libertas: fix memory alignment problems on the blackfin

Ivo van Doorn (2):
      mac80211: Only flush workqueue when last interface was removed
      rt2x00: Disable synchronization during initialization

J. Bruce Fields (1):
      Documentation: clarify tcp_{r,w}mem sysctl docs

James Bottomley (3):
      [SCSI] mptspi: fix oops in mptspi_dv_renegotiate_work()
      [SCSI] fusion: default MSI to disabled for SPI and FC controllers
      [SCSI] bsg: fix oops on remove

Jan-Bernd Themann (3):
      ehea: fix might sleep problem
      ehea: add MODULE_DEVICE_TABLE
      ehea: fix race condition

Jaya Kumar (1):
      fbdev: bugfix for multiprocess defio

Jeff Dike (1):
      [UML] fix gcc ICEs and unresolved externs

Jeff Layton (2):
      cifs: fix inode leak in cifs_get_inode_info_unix
      cifs: fix wksidarr declaration to be big-endian friendly

Jeff Mahoney (1):
      reiserfs: discard prealloc in reiserfs_delete_inode

Jesse Barnes (1):
      Revert "PCI: Correct last two HP entries in the bfsort whitelist"

Jiri Pirko (1):
      Documentation/HOWTO: correct wrong kernel bugzilla FAQ URL

John W. Linville (1):
      hostap_cs: correct poor NULL checks in suspend/resume routines

Jon Smirl (1):
      rtc-pcf8563: add chip id

Julius Volz (1):
      irda: Fix netlink error path return value

Kai Krakow (1):
      Added Targa Visionary 1000 IDE adapter to pata_sis.c

Krzysztof Halasa (1):
      Add missing skb->dev assignment in Frame Relay RX code

Laurent Pinchart (1):
      fs_enet: restore promiscuous and multicast settings in restart()

Li Zefan (2):
      devcgroup: always show positive major/minor num
      devcgroup: fix permission check when adding entry to child cgroup

Linus Torvalds (7):
      Revert "USB: don't explicitly reenable root-hub status interrupts"
      vsprintf: split out '%s' handling logic
      vsprintf: split out '%p' handling logic
      vsprintf: add infrastructure support for extended '%p' specifiers
      vsprintf: add support for '%pS' and '%pF' pointer formats
      sched: fix cpu hotplug, cleanup
      Linux 2.6.26

Luis Carlos Cobo (1):
      zd1211rw: stop beacons on remove_interface

Marcin Obara (1):
      tpm: add Intel TPM TIS device HID

Mark Fasheh (1):
      ocfs2: Fix flags in ocfs2_file_lock

Mark McLoughlin (1):
      KVM: IOAPIC: Fix level-triggered irq injection hang

Mark Rustad (1):
      IPMI: return correct value from ipmi_write

Mattias Nissler (1):
      rc80211_pid: Fix fast_start parameter handling

Max Krasnyansky (1):
      tun: Persistent devices can get stuck in xoff state

Michael Buesch (1):
      ssb-pcicore: Fix IRQ-vector init on embedded devices

Michael Karcher (1):
      x86: fix ldt limit for 64 bit

Milton Miller (1):
      tcp: correct kcalloc usage

Nick Piggin (2):
      [S390] protect _PAGE_SPECIAL bit against mprotect
      Fix PREEMPT_RCU without HOTPLUG_CPU

Octavian Purdila (1):
      tcp: fix a size_t < 0 comparison in tcp_read_sock

Oliver Hartkopp (1):
      can: add sanity checks

Patrick McHardy (2):
      bridge: fix use-after-free in br_cleanup_bridges()
      netfilter: nf_conntrack_tcp: fix endless loop

Paul Gortmaker (1):
      rtc: fix reported IRQ rate for when HPET is enabled

Philipp Zabel (1):
      pxamci: fix byte aligned DMA transfers

Rick Farrington (1):
      iwlwifi: fix incorrect 5GHz rates reported in monitor mode

Robert Richter (1):
      OProfile kernel maintainership changes

Roland Dreier (2):
      ehea: Access iph->tot_len with correct endianness
      pasemi_mac: Access iph->tot_len with correct endianness

Sathya Narayanan (2):
      ibm_newemac: Fixes kernel crashes when speed of cable connected changes
      ibm_newemac: Fixes entry of short packets

Sergei Shtylyov (1):
      palm_bk3710: fix IDECLK period calculation

Shane McDonald (1):
      [MIPS] Atlas, decstation: Fix section mismatches triggered by defconfigs

Steffen Klassert (1):
      xfrm: Add a XFRM_STATE_AF_UNSPEC flag to xfrm_usersa_info

Stephen Hemminger (1):
      ip: sysctl documentation cleanup

Steve Wise (1):
      RDMA/cxgb3: Fix regression caused by class_device -> device conversion

Steven Rostedt (1):
      ftrace: Documentation

Sunil Mushran (1):
      ocfs2/dlm: Fixes oops in dlm_new_lockres()

Takashi Iwai (1):
      Fix broken fix for fsl-diu-db

Tejun Heo (1):
      libata-acpi: filter out DIPM enable

Thomas Bogendoerfer (1):
      [MIPS] Fix 32bit kernels on R4k with 128 byte cache line size

Tobias Diedrich (1):
      forcedeth: fix lockdep warning on ethtool -s

Trond Myklebust (3):
      NFS: Fix readdir cache invalidation
      SUNRPC: Fix a double-free in rpcbind
      SUNRPC: Fix an rpcbind breakage for the case of IPv6 lookups

Uwe Kleine-König (1):
      Fix name of Russell King in various comments

Venkatesh Pallipadi (1):
      x86: fix /dev/mem compatibility under PAT

Ville Syrjala (1):
      irda: New device ID for nsc-ircc

Vitaly Bordug (1):
      powerpc: Add missing reference to coherent_dma_mask

Vlad Yasevich (2):
      sctp: Mark the tsn as received after all allocations finish
      sctp: Add documentation for sctp sysctl variable

Vladimir Koutny (1):
      mac80211: don't report selected IBSS when not found

Wang Chen (1):
      irda: via-ircc proper dma freeing

Zhang Rui (1):
      libata-acpi: don't call sleeping function from invalid context

Zhu Yi (1):
      iwlwifi: drop skb silently for Tx request in monitor mode

andrey@cozybit.com (1):
      libertas: support USB persistence on suspend/resume (resend)
