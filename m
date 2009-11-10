Return-Path: <linux-kernel-owner+w=401wt.eu-S1755756AbZKJBLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756AbZKJBLr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 20:11:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754458AbZKJBLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 20:11:46 -0500
Received: from kroah.org ([198.145.64.141]:45794 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578AbZKJBLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 20:11:45 -0500
Date: Mon, 9 Nov 2009 17:07:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.31.6
Message-ID: <20091110010715.GA8144@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.31.6 kernel.  All users of the
2.6.31 kernel series are very strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.31.5 and 2.6.31.6

The updated 2.6.31.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.31.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.31.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/dontdiff                       |    1 
 Makefile                                     |    2 
 arch/alpha/kernel/vmlinux.lds.S              |    1 
 arch/m68k/Kconfig                            |    6 
 arch/mips/kernel/Makefile                    |    2 
 arch/mips/kernel/vmlinux.lds.S               |   12 
 arch/powerpc/platforms/powermac/cpufreq_32.c |    8 
 arch/powerpc/platforms/powermac/low_i2c.c    |    7 
 arch/powerpc/platforms/powermac/pci.c        |   61 ++
 arch/powerpc/platforms/powermac/smp.c        |    2 
 arch/powerpc/platforms/pseries/msi.c         |    2 
 arch/powerpc/platforms/pseries/xics.c        |    9 
 arch/sparc/kernel/ldc.c                      |    4 
 arch/sparc/kernel/setup_32.c                 |    2 
 arch/sparc/kernel/setup_64.c                 |    2 
 arch/x86/ia32/ia32entry.S                    |    5 
 arch/x86/include/asm/amd_iommu.h             |    1 
 arch/x86/include/asm/uv/uv_hub.h             |    7 
 arch/x86/kernel/amd_iommu.c                  |    2 
 arch/x86/kernel/amd_iommu_init.c             |   24 +
 arch/x86/kernel/apic/x2apic_uv_x.c           |    8 
 arch/x86/kernel/cpu/mcheck/therm_throt.c     |   67 +--
 arch/x86/kernel/e820.c                       |    4 
 arch/x86/kernel/tlb_uv.c                     |    4 
 arch/x86/kvm/i8254.c                         |    2 
 arch/x86/kvm/lapic.c                         |    2 
 arch/x86/kvm/x86.c                           |    3 
 arch/x86/xen/enlighten.c                     |   11 
 drivers/acpi/pci_root.c                      |   11 
 drivers/acpi/scan.c                          |   12 
 drivers/ata/ahci.c                           |   52 --
 drivers/ata/libata-core.c                    |   12 
 drivers/ata/libata-eh.c                      |    6 
 drivers/ata/pata_sc1200.c                    |    3 
 drivers/ata/pata_via.c                       |    2 
 drivers/ata/sata_nv.c                        |   18 
 drivers/ata/sata_via.c                       |    1 
 drivers/base/driver.c                        |    2 
 drivers/char/Kconfig                         |    6 
 drivers/char/agp/intel-agp.c                 |    7 
 drivers/char/hvc_xen.c                       |   25 +
 drivers/char/vt.c                            |    3 
 drivers/cpuidle/cpuidle.c                    |    5 
 drivers/gpu/drm/i915/i915_drv.h              |    2 
 drivers/gpu/drm/i915/i915_reg.h              |   14 
 drivers/gpu/drm/i915/intel_display.c         |   73 +++
 drivers/hwmon/it87.c                         |    5 
 drivers/input/mouse/synaptics.c              |   10 
 drivers/macintosh/via-pmu.c                  |   40 +
 drivers/md/dm-exception-store.c              |   22 
 drivers/md/dm-exception-store.h              |    8 
 drivers/md/dm-log-userspace-base.c           |    2 
 drivers/md/dm-snap-persistent.c              |   16 
 drivers/md/dm-snap.c                         |   25 -
 drivers/md/dm.c                              |   11 
 drivers/misc/sgi-gru/gruprocfs.c             |   13 
 drivers/net/bonding/bond_main.c              |    2 
 drivers/net/wireless/b43/rfkill.c            |    3 
 drivers/net/wireless/iwlwifi/iwl-rx.c        |   34 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c  |   33 +
 drivers/net/wireless/libertas/if_usb.c       |    2 
 drivers/net/wireless/ray_cs.c                |    2 
 drivers/pcmcia/cs.c                          |   69 +--
 drivers/pcmcia/yenta_socket.c                |   12 
 drivers/scsi/dpt_i2o.c                       |    4 
 drivers/serial/8250_pci.c                    |   11 
 drivers/usb/serial/option.c                  |   10 
 drivers/usb/serial/sierra.c                  |   23 -
 drivers/video/console/.gitignore             |    2 
 drivers/video/console/Kconfig                |    9 
 drivers/video/console/Makefile               |   12 
 drivers/video/console/prom.uni               |   11 
 drivers/video/console/promcon.c              |  598 ---------------------------
 drivers/virtio/virtio_ring.c                 |    3 
 drivers/watchdog/riowd.c                     |    2 
 fs/cifs/connect.c                            |    3 
 fs/fuse/file.c                               |    5 
 fs/hfsplus/wrapper.c                         |    4 
 fs/nfs/client.c                              |    2 
 fs/nfs/dir.c                                 |    2 
 fs/nfs/direct.c                              |    1 
 fs/nfs/nfs4proc.c                            |   15 
 fs/nfs/nfs4renewd.c                          |    6 
 fs/nfs/nfs4xdr.c                             |    1 
 fs/nfs/super.c                               |    2 
 fs/nilfs2/btnode.c                           |    3 
 fs/notify/inode_mark.c                       |    6 
 fs/pipe.c                                    |   41 +
 include/drm/drm_pciids.h                     |    1 
 include/linux/moduleparam.h                  |    1 
 include/linux/pci_ids.h                      |    4 
 include/pcmcia/ss.h                          |    4 
 kernel/futex.c                               |   20 
 kernel/params.c                              |   17 
 mm/mempolicy.c                               |   13 
 mm/nommu.c                                   |    6 
 mm/swapfile.c                                |    3 
 mm/vmscan.c                                  |    2 
 net/mac80211/cfg.c                           |    6 
 net/mac80211/tx.c                            |    2 
 net/sched/cls_api.c                          |    2 
 net/unix/af_unix.c                           |    2 
 scripts/Makefile                             |    1 
 security/keys/keyctl.c                       |    2 
 sound/pci/ice1712/ice1724.c                  |    2 
 virt/kvm/kvm_main.c                          |    7 
 106 files changed, 715 insertions(+), 980 deletions(-)

Alan Cox (4):
      ray_cs: Fix copy_from_user handling
      dpt_i2o: Fix up copy*user
      tty: Mark generic_serial users as BROKEN
      pata_sc1200: Fix crash on boot

Anand V. Avati (1):
      fuse: prevent fuse_put_request on invalid pointer

Andre Detsch (1):
      powerpc/pci: Fix regression in powerpc MSI-X

Andre Przywara (1):
      KVM: ignore reads from AMDs C1E enabled MSR

Andrew Morton (1):
      dm log: userspace fix incorrect luid cast in userspace_ctr

Bastian Blank (1):
      powerpc: Remove SMP warning from PowerMac cpufreq

Ben Hutchings (2):
      hfsplus: refuse to mount volumes larger than 2TB
      nfs: Avoid overrun when copying client IP address string

Benjamin Herrenschmidt (4):
      8250_pci: add IBM Saturn serial card
      powerpc/pmac: Fix PowerSurge SMP IPI allocation
      powerpc/pmac: Fix issues with sleep on some powerbooks
      powerpc: Fix some late PowerMac G5 with PCIe ATI graphics

Björn Smedman (1):
      mac80211: fix for incorrect sequence number on hostapd injected frames

Bo Liu (1):
      mm: remove incorrect swap_count() from try_to_unuse()

Bryan Wu (1):
      USB: option: TLAYTECH TUE800 support

Chuck Ebbert (1):
      ahci: revert "Restore SB600 sata controller 64 bit DMA"

Darren Hart (2):
      futex: Check for NULL keys in match_futex
      futex: Move drop_futex_key_refs out of spinlock'ed region

Darrick J. Wong (1):
      KVM: Prevent kvm_init from corrupting debugfs structures

David Henningsson (1):
      ALSA: ice1724 - Make call to set hw params succeed on ESI Juli@

David Howells (2):
      NOMMU: Don't pass NULL pointers to fput() in do_mmap_pgoff()
      KEYS: get_instantiation_keyring() should inc the keyring refcount in all cases

David S. Miller (2):
      sparc64: Set IRQF_DISABLED on LDC channel IRQs.
      sparc: Kill PROM console driver.

David Woodhouse (1):
      libertas if_usb: Fix crash on 64-bit machines

Dmitry Torokhov (1):
      Input: synaptics - add another Protege M300 to rate blacklist

Earl Chew (1):
      fs: pipe.c null pointer dereference

Elina Pasheva (1):
      USB: serial: sierra driver send_setup() autopm fix

Eric Paris (1):
      fsnotify: do not set group for a mark before it is on the i_list

Fabian Henze (2):
      agp/intel: Add B43 chipset support
      drm/i915: add B43 chipset support

Gleb Natapov (1):
      KVM: get_tss_base_addr() should return a gpa_t

Greg Kroah-Hartman (1):
      Linux 2.6.31.6

Huzaifa Sidhpurwala (1):
      USB: option: Support for AIRPLUS MCD650 Datacard

Ingo Molnar (2):
      x86: mce: Clean up thermal throttling state tracking code
      x86: mce: Fix thermal throttling message storm

Jan Beulich (1):
      x86-64: Fix register leak in 32-bit syscall audting

Jean Delvare (1):
      hwmon: (it87) Fix VID reading on IT8718F/IT8720F

Jens Axboe (1):
      fuse: fix kunmap in fuse_ioctl_copy_user

Jeremy Fitzhardinge (2):
      xen/hvc: make sure console output is always emitted, with explicit polling
      xen: mask extended topology info in cpuid

Jiri Bohac (1):
      bonding: fix a race condition in calls to slave MII ioctls

Jiri Pirko (1):
      netlink: fix typo in initialization (CVE-2009-3612)

Joerg Roedel (2):
      x86/amd-iommu: Workaround for erratum 63
      x86/amd-iommu: Un__init function required on shutdown

Johannes Berg (1):
      mac80211: check interface is down before type change

Jonathan Brassow (1):
      dm snapshot: free exception store on init failure

JosephChan@via.com.tw (2):
      sata_via: Remove redundant device ID for VIA VT8261
      pata_via: extend the rev_max for VT6330

KOSAKI Motohiro (2):
      mbind(): fix leak of never putback pages
      do_mbind(): fix memory leak

Kevin Hilman (1):
      cpuidle: always return with interrupts enabled

Kiyoshi Ueda (1):
      dm: dec_pending needs locking to save error value

Larry Finger (1):
      b43: Fix Bugzilla #14181 and the bug from the previous 'fix'

Len Brown (1):
      Revert "ACPI: Attach the ACPI device to the ACPI handle as early as possible"

Linus Torvalds (1):
      sgi-gru: decrapfiy options_write() function

Manuel Lauss (1):
      mips: fix build of vmlinux.lds

Marcelo Tosatti (1):
      KVM: use proper hrtimer function to retrieve expiration time

Michael S. Tsirkin (1):
      virtio: order used ring after used index read

Mikulas Patocka (5):
      dm snapshot: sort by chunk size to fix race
      dm exception store: fix failed set_chunk_size error path
      dm snapshot: lock snapshot while supplying status
      dm snapshot: require non zero chunk size by end of ctr
      dm snapshot: use unsigned integer chunk size

OGAWA Hirofumi (1):
      dpt_i2o: Fix typo of EINVAL

Rafael J. Wysocki (2):
      ACPI / PCI: Fix NULL pointer dereference in acpi_get_pci_dev() (rev. 2)
      PM / yenta: Split resume into early and late parts (rev. 4)

Reinette Chatre (2):
      iwlwifi: fix potential rx buffer loss
      iwlwifi: reduce noise when skb allocation fails

Robin Holt (2):
      x86, UV: Fix information in __uv_hub_info structure
      x86, UV: Set DELIVERY_MODE=4 for vector=NMI_VECTOR in uv_hub_send_ipi()

Ronnie Furuskog (1):
      USB: option: Patch for Huawei Mobile Broadband E270+ Modem

Rusty Russell (3):
      param: fix lots of bugs with writing charp params from sysfs, by leaking mem.
      param: fix NULL comparison on oom
      param: fix setting arrays of bool

Ryusuke Konishi (1):
      nilfs2: fix dirty page accounting leak causing hang at write

Sam Ravnborg (1):
      alpha: fix build after vmlinux.lds.S cleanup

Stas Sergeev (1):
      Driver core: fix driver_register() return value

Steve French (1):
      CIFS: Fixing to avoid invalid kfree() in cifs_get_tcp_session()

Tejun Heo (3):
      libata: fix internal command failure handling
      libata: fix PMP initialization
      sata_nv: make sure link is brough up online when skipping hardreset

Terry Loftin (1):
      nfs: Panic when commit fails

Thomas Gleixner (3):
      futex: Handle spurious wake up
      futex: Fix spurious wakeup for requeue_pi really
      watchdog: Fix rio watchdog probe function

Tomoki Sekiyama (1):
      AF_UNIX: Fix deadlock on connecting to shutdown socket (CVE-2009-3621)

Trond Myklebust (4):
      NFSv4: Fix a bug when the server returns NFS4ERR_RESOURCE
      NFSv4: Fix two unbalanced put_rpccred() issues.
      NFSv4: Kill nfs4_renewd_prepare_shutdown()
      NFSv4: The link() operation should return any delegation on the file

Wu Fengguang (1):
      vmscan: limit VM_EXEC protection to file pages

Yinghai Lu (2):
      pci: increase alignment to make more space for hidden code
      nfs: Fix nfs_parse_mount_options() kfree() leak

Zdenek Kabelac (1):
      dm: add missing del_gendisk to alloc_dev error path

Zhenyu Wang (3):
      drm/i915: Fix FDI M/N setting according with correct color depth
      drm/i915: fix to setup display reference clock control on Ironlake
      drm/i915: fix panel fitting filter coefficient select for Ironlake

