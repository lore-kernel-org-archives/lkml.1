Return-Path: <linux-kernel-owner+w=401wt.eu-S932187AbZFOUIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187AbZFOUIH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 16:08:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765731AbZFOUHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 16:07:55 -0400
Received: from kroah.org ([198.145.64.141]:44358 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753800AbZFOUHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 16:07:53 -0400
Date: Mon, 15 Jun 2009 13:03:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.29.5
Message-ID: <20090615200304.GA2003@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.29.5 kernel.  All users of the
2.6.29 kernel series are very strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.29.4 and 2.6.29.5

The updated 2.6.29.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.29.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.29.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/filesystems/ext4.txt     |    5 +
 Makefile                               |    2 
 arch/powerpc/mm/tlb_nohash_low.S       |    2 
 arch/sparc/kernel/of_device_32.c       |   21 +++++-
 arch/sparc/kernel/of_device_64.c       |   21 +++++-
 arch/sparc/kernel/smp_64.c             |    4 -
 arch/x86/kernel/hpet.c                 |   41 +++++++++---
 arch/x86/kvm/mmu.c                     |    3 
 arch/x86/kvm/x86.c                     |    6 +
 arch/x86/mm/hugetlbpage.c              |    6 +
 arch/x86/pci/mmconfig-shared.c         |    6 -
 crypto/api.c                           |    3 
 drivers/acpi/processor_idle.c          |    8 ++
 drivers/block/xen-blkfront.c           |    6 +
 drivers/char/random.c                  |   19 +++--
 drivers/char/tpm/tpm_bios.c            |    3 
 drivers/crypto/padlock-aes.c           |    2 
 drivers/gpu/drm/r128/r128_cce.c        |    6 -
 drivers/hid/usbhid/hid-core.c          |    2 
 drivers/hwmon/lm78.c                   |    2 
 drivers/ide/ide-io.c                   |    4 -
 drivers/ide/ide-iops.c                 |   21 +++++-
 drivers/ide/ide-pci-generic.c          |   11 +++
 drivers/ide/ide-tape.c                 |    6 -
 drivers/mtd/devices/mtd_dataflash.c    |    2 
 drivers/net/Makefile                   |    2 
 drivers/net/bnx2.c                     |    2 
 drivers/net/bonding/bond_alb.c         |   10 ---
 drivers/net/e1000/e1000_main.c         |    5 -
 drivers/net/igb/igb_ethtool.c          |    4 +
 drivers/net/mac8390.c                  |   10 +--
 drivers/net/macvlan.c                  |    9 +-
 drivers/net/myri10ge/myri10ge.c        |    1 
 drivers/net/r8169.c                    |  102 +++++++++++++++++--------------
 drivers/net/wireless/iwlwifi/iwl-sta.c |   21 +++---
 drivers/scsi/3w-xxxx.c                 |    5 -
 drivers/scsi/3w-xxxx.h                 |    2 
 drivers/serial/icom.c                  |    2 
 drivers/serial/mpc52xx_uart.c          |    2 
 drivers/usb/class/cdc-acm.c            |    4 -
 drivers/usb/host/isp1760-hcd.c         |   24 ++++++-
 drivers/usb/serial/ftdi_sio.c          |    9 --
 drivers/usb/serial/usb-serial.c        |    1 
 fs/ext4/ext4.h                         |   30 +++++++++
 fs/ext4/extents.c                      |   19 ++++-
 fs/ext4/file.c                         |    7 +-
 fs/ext4/ialloc.c                       |   17 ++---
 fs/ext4/inode.c                        |  106 +++++++++++++++++++++++++++++++--
 fs/ext4/ioctl.c                        |   17 ++++-
 fs/ext4/namei.c                        |   18 ++++-
 fs/ext4/super.c                        |   25 ++++---
 fs/jbd2/revoke.c                       |   24 +++++--
 fs/nfs/dir.c                           |    3 
 include/linux/ptrace.h                 |    1 
 kernel/exit.c                          |   83 ++++++++++++-------------
 kernel/futex.c                         |   24 ++++---
 kernel/ptrace.c                        |   25 ++++---
 mm/hugetlb.c                           |   26 ++++----
 mm/slub.c                              |    3 
 net/8021q/vlan_dev.c                   |    3 
 net/core/pktgen.c                      |    2 
 net/core/skbuff.c                      |    2 
 net/ipv4/route.c                       |   60 ++++++------------
 net/ipv4/tcp.c                         |    5 +
 net/ipv4/tcp_input.c                   |    3 
 net/mac80211/rc80211_minstrel.c        |    4 -
 net/mac80211/rc80211_pid_algo.c        |   73 ++++++++++++----------
 net/rose/af_rose.c                     |   10 ---
 net/sched/sch_teql.c                   |    5 -
 net/wimax/op-msg.c                     |   11 +--
 net/wireless/reg.c                     |    7 ++
 net/xfrm/xfrm_state.c                  |    6 -
 security/keys/request_key.c            |    9 +-
 security/selinux/hooks.c               |    2 
 sound/pci/hda/patch_realtek.c          |    1 
 sound/usb/usbaudio.c                   |    2 
 sound/usb/usbaudio.h                   |    2 
 sound/usb/usbmidi.c                    |   12 +++
 sound/usb/usbquirks.h                  |    2 
 virt/kvm/kvm_main.c                    |    1 
 80 files changed, 692 insertions(+), 385 deletions(-)

Adam Radford (1):
      3w-xxxx: scsi_dma_unmap fix

Adam Williamson (1):
      ALSA: hda - fix audio on HP TX25xx series notebooks

Alan Cox (1):
      cdc-acm: Fix long standing abuse of tty->low_latency

Alan Stern (1):
      usb-serial: fix crash when sub-driver updates firmware

Andreas Herrmann (3):
      x86: hpet: provide separate functions to stop and start the counter
      x86: hpet: stop HPET_COUNTER when programming periodic mode
      x86: hpet: fix periodic mode programming on AMD 81xx

Aneesh Kumar K.V (4):
      ext4: Fix discard of inode prealloc space with delayed allocation.
      ext4: Fix sub-block zeroing for writes into preallocated extents
      ext4: Use a fake block number for delayed new buffer_head
      ext4: Clear the unwritten buffer_head flag after the extent is initialized

Avi Kivity (3):
      KVM: Make paravirt tlb flush also reload the PAE PDPTRs
      KVM: Fix PDPTR reloading on CR4 writes
      KVM: Explicity initialize cpus_hardware_enabled

Bartlomiej Zolnierkiewicz (3):
      ide: fix 40-wire cable detection for TSST SH-S202* ATAPI devices (v2)
      ide_pci_generic: add quirk for Netcell ATA RAID
      ide: fix OOPS during ide-cd error recovery

Breno Leitao (1):
      icom: fix rmmod crash

Bryan Donlan (1):
      ext4: return -EIO not -ESTALE on directory traversal through deleted inode

Chuck Ebbert (1):
      ext4: really print the find_group_flex fallback warning only once

Clemens Ladisch (1):
      sound: usb-audio: make the MotU Fastlane work again

Dave Airlie (1):
      drm/r128: fix r128 ioremaps to use ioremap_wc.

David Howells (1):
      keys: Handle there being no fallback destination keyring for request_key()

David S. Miller (3):
      Revert "rose: zero length frame filtering in af_rose.c"
      sparc: Fix bus type probing for ESP and LE devices.
      sparc64: Fix smp_callin() locking.

David Woodhouse (1):
      Fix oops on close of hot-unplugged FTDI serial converter

Duane Griffin (2):
      ext4: don't inherit inappropriate inode flags from parent
      ext4: tighten restrictions on inode flags

Eric Dumazet (3):
      sch_teql: should not dereference skb after ndo_start_xmit()
      net: fix length computation in rt_check_expire()
      net: fix rtable leak in net/ipv4/route.c

Eric Paris (2):
      TPM: get_event_name stack corruption
      SELinux: BUG in SELinux compat_net code

Finn Thain (1):
      mac8390: fix regression caused during net_device_ops conversion

Florian Westphal (1):
      pktgen: do not access flows[] beyond its length

Frank Filz (1):
      nfs: Fix NFS v4 client handling of MAY_EXEC in nfs_permission.

Greg Kroah-Hartman (1):
      Linux 2.6.29.5

Herbert Xu (2):
      crypto: padlock - Revert aes-all alias to aes
      crypto: api - Fix algorithm module auto-loading

Ian Campbell (1):
      xen/blkfront: allow xenbus state transition to Closing->Closed when not Connected

Ilpo Jarvinen (2):
      tcp: fix MSG_PEEK race check
      tcp: fix >2 iw selection

Inaky Perez-Gonzalez (1):
      wimax: fix oops if netlink fails to add attribute

Jan Kara (1):
      jbd2: Update locking coments

Jay Vosburgh (2):
      bonding: fix alb mode locking regression
      bonding: Remove debug printk

Jeff Kirsher (1):
      igb: fix LRO warning

Jiri Slaby (2):
      mac80211: minstrel, fix memory corruption
      mac80211: pid, fix memory corruption

John W. Linville (1):
      mac80211: avoid NULL ptr deref when finding max_rates in PID and minstrel

Linus Torvalds (2):
      random: make get_random_int() more random
      Avoid ICE in get_random_int() with gcc-3.4.5

Luis R. Rodriguez (1):
      cfg80211: fix race between core hint and driver's custom apply

Mel Gorman (2):
      x86: ignore VM_LOCKED when determining if hugetlb-backed page tables can be shared or not
      mm: account for MAP_SHARED mappings using VM_MAYSHARE and not VM_SHARED in hugetlbfs

Michael Buesch (1):
      r8169: avoid losing MSI interrupts

Michael Chan (1):
      bnx2: Fix panic in bnx2_poll_work().

Mike Frysinger (1):
      hwmon: (lm78) Add missing __devexit_p()

Neil Horman (1):
      e1000: add missing length check to e1000 receive routine

Nick Piggin (1):
      mm: SLUB fix reclaim_state

Nicolas Dichtel (1):
      xfrm: wrong hash value for temporary SA

Oleg Nesterov (4):
      ptrace: kill __ptrace_detach(), fix ->exit_state check
      ptrace: simplify ptrace_exit()->ignoring_children() path
      ptrace: reintroduce __ptrace_detach() as a callee of ptrace_exit()
      ptrace: fix possible zombie leak on PTRACE_DETACH

Patrick McHardy (1):
      vlan/macvlan: fix NULL pointer dereferences in ethtool handlers

Peter Korsgaard (1):
      mtd_dataflash: unbreak erase support

Reinette Chatre (1):
      iwlwifi: update key flags at time key is set

Roel Kluin (1):
      drivers/serial/mpc52xx_uart.c: fix array overindexing check

Shaohua Li (2):
      cpuidle: make AMC C1E work in processor_idle
      cpuidle: fix AMD C1E suspend hang

Stanislaw Gruszka (1):
      myr10ge: again fix lro_gen_skb() alignment

Stephen Rothwell (1):
      powerpc: fix for long standing bug noticed by gcc 4.4.0

Tejun Heo (1):
      ide-tape: remove back-to-back REQUEST_SENSE detection

Theodore Ts'o (9):
      ext4: Add fine print for the 32000 subdirectory limit
      ext4: add EXT4_IOC_ALLOC_DA_BLKS ioctl
      ext4: Automatically allocate delay allocated blocks on close
      ext4: Automatically allocate delay allocated blocks on rename
      ext4: Add auto_da_alloc mount option
      ext4: Check for an valid i_mode when reading the inode from disk
      ext4: Fix softlockup caused by illegal i_file_acl value in on-disk inode
      ext4: Ignore i_file_acl_high unless EXT4_FEATURE_INCOMPAT_64BIT is present
      ext4: Fix race in ext4_inode_info.i_cached_extent

Thomas Chenault (1):
      net: fix skb_seq_read returning wrong offset/length for page frag data

Thomas Gleixner (1):
      futex: setup writeable mapping for futex ops which modify user space data

Warren Free (1):
      USB: isp1760: urb_dequeue doesn't always find the urbs

Yinghai Lu (1):
      x86/pci: fix mmconfig detection with 32bit near 4g

Zoltan Karcagi (1):
      HID: fix dropped device-specific quirks

