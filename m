Return-Path: <linux-kernel-owner+w=401wt.eu-S1757571AbZGCAMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571AbZGCAMr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 20:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756869AbZGCALr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 20:11:47 -0400
Received: from kroah.org ([198.145.64.141]:49696 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757395AbZGCALk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 20:11:40 -0400
Date: Thu, 2 Jul 2009 17:10:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.30.1
Message-ID: <20090703001035.GC27031@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.30.1 kernel.  All users of the
2.6.30 kernel series are very strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.30 and 2.6.30.1

The updated 2.6.30.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.30.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.30.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/sysctl/vm.txt               |   12 ++-
 Makefile                                  |    2 
 arch/arm/include/asm/cacheflush.h         |    8 ++
 arch/x86/crypto/aesni-intel_asm.S         |    5 -
 arch/x86/include/asm/apic.h               |    2 
 arch/x86/include/asm/cpufeature.h         |    1 
 arch/x86/include/asm/kvm_host.h           |    2 
 arch/x86/include/asm/mce.h                |    2 
 arch/x86/include/asm/uv/uv_bau.h          |    2 
 arch/x86/include/asm/uv/uv_hub.h          |    6 +
 arch/x86/include/asm/vmx.h                |    1 
 arch/x86/kernel/apic/x2apic_uv_x.c        |   15 ++-
 arch/x86/kernel/cpu/amd.c                 |   14 +++
 arch/x86/kernel/cpu/mcheck/mce_32.c       |    1 
 arch/x86/kernel/cpu/mcheck/mce_64.c       |    1 
 arch/x86/kernel/hpet.c                    |    3 
 arch/x86/kernel/pci-gart_64.c             |   10 ++
 arch/x86/kernel/reboot.c                  |    9 ++
 arch/x86/kernel/setup.c                   |   15 ---
 arch/x86/kernel/tlb_uv.c                  |   24 +++---
 arch/x86/kernel/tsc.c                     |   11 ++
 arch/x86/kernel/vm86_32.c                 |    9 +-
 arch/x86/kernel/vsyscall_64.c             |    8 --
 arch/x86/kvm/vmx.c                        |   64 +++++++++++++++-
 arch/x86/kvm/x86.c                        |   10 ++
 arch/x86/mm/memtest.c                     |   14 +--
 drivers/char/epca.c                       |    9 +-
 drivers/char/moxa.c                       |    7 +
 drivers/char/n_r3964.c                    |   26 +++---
 drivers/char/pcmcia/cm4000_cs.c           |    3 
 drivers/char/rocket.c                     |    6 -
 drivers/char/vt_ioctl.c                   |    3 
 drivers/firmware/memmap.c                 |   16 ++--
 drivers/gpu/drm/i915/i915_drv.c           |    4 -
 drivers/ide/ide-cd.c                      |    2 
 drivers/infiniband/hw/mlx4/qp.c           |    4 +
 drivers/isdn/hisax/hfc_pci.c              |   41 +++++++---
 drivers/isdn/hisax/hisax.h                |    2 
 drivers/md/dm-exception-store.c           |    9 +-
 drivers/md/dm-exception-store.h           |    2 
 drivers/md/dm-log.c                       |    2 
 drivers/md/dm-mpath.c                     |   12 +++
 drivers/md/dm-table.c                     |    3 
 drivers/md/dm.c                           |    4 +
 drivers/md/raid5.c                        |    1 
 drivers/media/dvb/frontends/lgdt3305.c    |   17 ----
 drivers/media/video/Makefile              |   77 ++++++++++---------
 drivers/media/video/cx18/cx18-controls.c  |    2 
 drivers/media/video/cx2341x.c             |    2 
 drivers/media/video/ivtv/ivtv-controls.c  |    2 
 drivers/media/video/pvrusb2/pvrusb2-hdw.c |   56 ++++++++------
 drivers/media/video/saa7134/Makefile      |    3 
 drivers/net/bonding/bond_sysfs.c          |    1 
 drivers/net/e1000e/netdev.c               |    2 
 drivers/net/mv643xx_eth.c                 |    7 -
 drivers/net/sky2.c                        |   31 ++++----
 drivers/net/tun.c                         |    7 +
 drivers/net/usb/pegasus.c                 |   29 ++++---
 drivers/net/via-velocity.c                |    2 
 drivers/net/wireless/ath5k/base.c         |    7 +
 drivers/net/wireless/ath9k/calib.c        |   67 ++++++-----------
 drivers/net/wireless/ath9k/main.c         |   28 ++++---
 drivers/net/wireless/ath9k/pci.c          |   18 ++++
 drivers/net/wireless/ath9k/regd.c         |    2 
 drivers/net/wireless/ath9k/xmit.c         |    5 -
 drivers/parport/parport_pc.c              |   34 +++++++-
 drivers/pci/pci.c                         |    7 +
 drivers/pci/pcie/aspm.c                   |    4 +
 drivers/scsi/qla2xxx/qla_dbg.c            |    2 
 drivers/scsi/sym53c8xx_2/sym_hipd.c       |    5 -
 drivers/serial/bfin_5xx.c                 |    5 +
 drivers/spi/spi_mpc83xx.c                 |    6 -
 drivers/staging/uc2322/aten2011.c         |    4 -
 drivers/usb/class/usbtmc.c                |    6 +
 drivers/usb/serial/aircable.c             |    5 -
 drivers/usb/serial/belkin_sa.c            |    7 -
 drivers/usb/serial/cp210x.c               |    6 -
 drivers/usb/serial/cyberjack.c            |   20 +++--
 drivers/usb/serial/cypress_m8.c           |   11 +-
 drivers/usb/serial/digi_acceleport.c      |   20 +++--
 drivers/usb/serial/empeg.c                |    8 --
 drivers/usb/serial/ftdi_sio.c             |   14 ---
 drivers/usb/serial/garmin_gps.c           |   16 +++-
 drivers/usb/serial/generic.c              |    9 +-
 drivers/usb/serial/io_edgeport.c          |   29 +++++--
 drivers/usb/serial/io_tables.h            |   12 ++-
 drivers/usb/serial/io_ti.c                |   22 ++++-
 drivers/usb/serial/ipaq.c                 |    7 -
 drivers/usb/serial/iuu_phoenix.c          |    6 -
 drivers/usb/serial/keyspan.c              |   13 +++
 drivers/usb/serial/keyspan.h              |   12 ++-
 drivers/usb/serial/keyspan_pda.c          |    4 -
 drivers/usb/serial/kl5kusb105.c           |   39 +++++-----
 drivers/usb/serial/kobil_sct.c            |   12 +--
 drivers/usb/serial/mct_u232.c             |   13 +--
 drivers/usb/serial/mos7720.c              |    9 --
 drivers/usb/serial/mos7840.c              |   42 +++++++++-
 drivers/usb/serial/omninet.c              |   19 +++-
 drivers/usb/serial/opticon.c              |   14 ++-
 drivers/usb/serial/option.c               |   17 +++-
 drivers/usb/serial/oti6858.c              |    7 -
 drivers/usb/serial/pl2303.c               |    5 -
 drivers/usb/serial/sierra.c               |   28 ++++++-
 drivers/usb/serial/spcp8x5.c              |    5 -
 drivers/usb/serial/symbolserial.c         |   14 ++-
 drivers/usb/serial/ti_usb_3410_5052.c     |   10 +-
 drivers/usb/serial/usb-serial.c           |   29 +++----
 drivers/usb/serial/visor.c                |   13 +--
 drivers/usb/serial/whiteheat.c            |    6 -
 fs/Kconfig                                |   14 +--
 fs/cifs/file.c                            |   10 +-
 fs/eventpoll.c                            |   21 +++--
 fs/fs-writeback.c                         |    2 
 fs/jfs/jfs_extent.c                       |    1 
 fs/ocfs2/super.c                          |   32 ++++----
 fs/ramfs/inode.c                          |    9 +-
 fs/xfs/xfs_bmap.c                         |    1 
 include/linux/firmware-map.h              |   12 +--
 include/linux/kvm_host.h                  |    1 
 include/linux/mlx4/qp.h                   |    1 
 include/linux/serial.h                    |  116 +++++++++++++++++-------------
 include/linux/usb/serial.h                |   12 ++-
 include/linux/vmstat.h                    |    3 
 include/net/x25.h                         |    2 
 kernel/acct.c                             |    6 +
 kernel/trace/trace_functions.c            |    8 +-
 lib/Kconfig.debug                         |    2 
 lib/dma-debug.c                           |   43 ++++++++++-
 lib/genalloc.c                            |    1 
 mm/page_alloc.c                           |    6 -
 mm/vmscan.c                               |   55 ++++++++++++--
 mm/vmstat.c                               |    3 
 net/ipv4/route.c                          |   36 ++++++++-
 net/mac80211/rc80211_minstrel.c           |    2 
 net/wireless/nl80211.c                    |   26 ++++--
 net/wireless/reg.c                        |   10 ++
 net/x25/af_x25.c                          |   23 ++++-
 net/x25/x25_timer.c                       |    2 
 security/integrity/ima/ima_audit.c        |    2 
 security/integrity/ima/ima_main.c         |   13 ++-
 sound/core/seq/seq_midi_event.c           |    8 +-
 sound/isa/cmi8330.c                       |    2 
 sound/pci/ca0106/ca0106_mixer.c           |    6 +
 sound/pci/hda/patch_realtek.c             |    2 
 sound/pci/intel8x0.c                      |   24 +++---
 sound/soc/codecs/wm8903.c                 |    4 -
 virt/kvm/kvm_main.c                       |   18 +++-
 147 files changed, 1223 insertions(+), 664 deletions(-)

Alan Stern (1):
      usb-serial: replace shutdown with disconnect, release

Andi Kleen (1):
      KVM: Add VT-x machine check support v4

Andreas Herrmann (3):
      x86: Detect use of extended APIC ID for AMD CPUs
      x86: memtest: remove 64-bit division
      x86: Set cpu_llc_id on AMD CPUs

Andrew Vasquez (1):
      qla2xxx: Correct (again) overflow during dump-processing on large-memory ISP23xx parts.

Andy Gospodarek (1):
      e1000e: stop unnecessary polling when using msi-x

Avi Kivity (3):
      KVM: Disable large pages on misaligned memory slots
      KVM: Prevent overflow in largepages calculation
      KVM: VMX: Handle vmx instruction vmexits

Bob Copeland (1):
      mac80211: fix minstrel single-rate memory corruption

Clemens Ladisch (1):
      sound: seq_midi_event: fix decoding of (N)RPN events

Cliff Wickman (2):
      x86: Fix UV BAU activation descriptor init
      x86: Fix uv bau sending buffer initialization

Dan Williams (1):
      md/raid5: add missing call to schedule() after prepare_to_wait()

Dave Jones (1):
      via-velocity: Fix velocity driver unmapping incorrect size.

Dave Kleikamp (1):
      jfs: fix regression preventing coalescing of extents

David S. Miller (1):
      x25: Fix sleep from timer on socket destroy.

Davide Libenzi (1):
      epoll: fix nested calls support

Dimitri Sivanich (1):
      mm: fix handling of pagesets for downed cpus

Dirk Eibach (1):
      char: moxa, prevent opening unavailable ports

Eric Paris (3):
      IMA: use current_cred() instead of current->cred
      IMA: Handle dentry_open failures
      IMA: open all files O_LARGEFILE

Eric W. Biederman (1):
      tun: Fix unregister race

FUJITA Tomonori (1):
      parport_pc: set properly the dma_mask for parport_pc device

Felix Blyakher (1):
      xfs: fix freeing memory in xfs_getbmap()

Frederic Weisbecker (1):
      tracing/urgent: fix unbalanced ftrace_start_up

Greg Kroah-Hartman (2):
      USB: usbtmc: fix switch statment
      Linux 2.6.30.1

Hans Verkuil (2):
      V4L: ivtv/cx18: fix regression: class controls are no longer seen
      V4L: i2c modules must be linked before the v4l2 drivers

Huang Ying (1):
      crypto: aes-ni - Fix cbc mode IV saving

Izik Eidus (1):
      KVM: Fix dirty bit tracking for slots with large pages

Jack Morgenstein (1):
      IB/mlx4: Add strong ordering to local inval and fast reg work requests

Jack Steiner (1):
      x86, UV: Fix macros for multiple coherency domains

Jean Delvare (1):
      x86: Add quirk for reboot stalls on a Dell Optiplex 360

Jeff Layton (1):
      cifs: fix fh_mutex locking in cifs_reopen_file

Jens Rottmann (1):
      parport_pc: after superio probing restore original register values

Jesse Barnes (1):
      drm/i915: correct suspend/resume ordering

Jiri Slaby (6):
      serial: refactor ASYNC_ flags
      rocket: fix test_bit parameters
      epca: fix test_bit parameters
      vt_ioctl: fix lock imbalance
      pcmcia/cm4000: fix lock imbalance
      n_r3964: fix lock imbalance

Joerg Roedel (1):
      dma-debug: change hash_bucket_find from first-fit to best-fit

John Stoffel (1):
      sym53c8xx: ratelimit parity errors

Jonathan Brassow (1):
      dm exception store: fix exstore lookup to be case insensitive

Jouni Malinen (2):
      ath9k: Fix PCI FATAL interrupts by restoring RETRY_TIMEOUT disabling
      ath5k: avoid PCI FATAL interrupts by restoring RETRY_TIMEOUT disabling

Karsten Keil (1):
      ISDN: Fix DMA alloc for hfcpci

Lubomir Rintel (1):
      x86: Fix non-lazy GS handling in sys_vm86()

Luis R. Rodriguez (5):
      cfg80211: fix for duplicate userspace replies
      cfg80211: cleanup return calls on nl80211_set_reg()
      cfg80211: return immediately if num reg rules > NL80211_MAX_SUPP_REG_RULES
      cfg80211: fix in nl80211_set_reg()
      ath9k: Fix bug when using a card with a busted EEPROM

Marcelo Tosatti (2):
      KVM: x86: check for cr3 validity in ioctl_set_sregs
      KVM: protect concurrent make_all_cpus_request

Mark Brown (1):
      ASoC: Remove odd bit clock ratios for WM8903

Mark Langsdorf (1):
      x86: enable GART-IOMMU only after setting up protection methods

Matt T. Yourst (1):
      KVM: x86: silence preempt warning on kvm_write_guest_time

Mel Gorman (2):
      vmscan: properly account for the number of page cache pages zone_reclaim() can reclaim
      vmscan: count the number of times zone_reclaim() scans and fails

Michael Buesch (1):
      pegasus usb-net: Fix endianness bugs

Michael Krufky (1):
      DVB: lgdt3305: fix 64bit division in function lgdt3305_set_if

Mike Frysinger (3):
      serial: bfin_5xx: add missing spin_lock init
      ramfs: ignore unknown mount options
      serial: bfin_5xx: fix building as module when early printk is enabled

Mike Isely (2):
      V4L: pvrusb2: Fix hardware scaling when used with cx25840
      V4L: pvrusb2: Re-fix hardware scaling on video standard change

Mikulas Patocka (4):
      dm mpath: validate hw_handler argument count
      dm mpath: validate table argument count
      dm mpath: flush keventd queue in destructor
      dm: use i_size_read

Milan Broz (2):
      dm: sysfs skip output when device is being destroyed
      dm exception store: really fix type lookup

Neil Horman (2):
      ipv4: fix NULL pointer + success return in route lookup path
      ipv4 routing: Ensure that route cache entries are usable and reclaimable with caching is off

Nick Piggin (1):
      fs: remove incorrect I_NEW warnings

Nicolas Pitre (1):
      ARM: 5545/2: add flush_kernel_dcache_page() for ARM

Ondrej Zary (1):
      ALSA: cmi8330: fix MPU-401 PnP init copy&paste bug

Peter Zijlstra (1):
      lockdep: Select frame pointers on x86

Petr Tesarik (1):
      x86: move rdtsc_barrier() into the TSC vread method

Prabhanjan Sarnaik (1):
      mv643xx_eth: fix unicast filter programming in promiscuous mode

Rafael J. Wysocki (2):
      PCI PM: Fix handling of devices without PM support by pci_target_state()
      PCI PM: Follow PCI_PM_CTRL_NO_SOFT_RESET during transitions from D3

Rainer Weikusat (1):
      ide-cd: prevent null pointer deref via cdrom_newpc_intr

Renaud Lottiaux (1):
      bsdacct: fix access to invalid filp in acct_on()

Roel Kluin (1):
      spi: takes size of a pointer to determine the size of the pointed-to type

Shaohua Li (1):
      PCI: disable ASPM on VIA root-port-under-bridge configurations

Stephen Hemminger (2):
      sky2: don't look for VPD size
      bonding: fix multiple module load problem

Sujith (6):
      ath9k: Fix bug in calibration initialization
      ath9k: Fix bug in determining calibration support
      ath9k: Fix bug in checking HT flag
      ath9k: Fix bug in scan termination
      ath9k: Fix memleak on TX DMA failure
      ath9k: Initialize ANI timers

Sunil Mushran (1):
      ocfs2: Fix ocfs2_osb_dump()

Takashi Iwai (4):
      ALSA: ca0106 - Add missing registrations of vmaster controls
      ALSA: intel8x0 - Fix PCM position craziness
      ALSA: hda - Get back Input Source for ALC262 toshiba-s06 model
      ALSA: hda - Add quirk for Sony VAIO Z21MN

Thomas Gleixner (1):
      x86: hpet: Mark per cpu interrupts IRQF_TIMER to prevent resume failure

Tomas Szepe (1):
      CONFIG_FILE_LOCKING should not depend on CONFIG_BLOCK

Yinghai Lu (2):
      firmware_map: fix hang with x86/32bit
      x86: handle initrd that extends into unusable memory

Zygo Blaxell (1):
      lib/genalloc.c: remove unmatched write_lock() in gen_pool_destroy

