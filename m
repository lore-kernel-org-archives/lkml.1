Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291Ab0BWPu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 10:50:27 -0500
Received: from kroah.org ([198.145.64.141]:37484 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164Ab0BWPuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 10:50:24 -0500
Date: Tue, 23 Feb 2010 07:49:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.9
Message-ID: <20100223154956.GA25530@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.32.9 kernel.

All users of the 2.6.32 kernel series should upgrade.

The updated 2.6.32.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.32.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.32.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                |    2 
 arch/sh/include/asm/pgtable_32.h                        |    5 
 arch/x86/include/asm/amd_iommu.h                        |    1 
 arch/x86/kernel/amd_iommu.c                             |   12 +
 arch/x86/kernel/amd_iommu_init.c                        |    3 
 arch/x86/kernel/apic/io_apic.c                          |    1 
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c               |    3 
 arch/x86/kvm/i8254.c                                    |    3 
 arch/x86/kvm/x86.c                                      |    7 
 drivers/acpi/processor_idle.c                           |    8 +
 drivers/acpi/scan.c                                     |    3 
 drivers/ata/ahci.c                                      |   15 +
 drivers/ata/libata-sff.c                                |    3 
 drivers/base/class.c                                    |    2 
 drivers/block/cciss.c                                   |    3 
 drivers/char/mem.c                                      |   70 ++++-----
 drivers/char/tpm/tpm_infineon.c                         |   79 +++++++---
 drivers/char/tty_io.c                                   |    4 
 drivers/crypto/padlock-sha.c                            |   23 ++
 drivers/dma/ioat/dma_v2.c                               |    2 
 drivers/edac/amd64_edac.c                               |   15 +
 drivers/gpu/drm/i915/i915_debugfs.c                     |   30 ---
 drivers/gpu/drm/i915/i915_drv.h                         |   13 +
 drivers/gpu/drm/i915/i915_gem.c                         |  123 ++++++++++++++--
 drivers/gpu/drm/i915/i915_reg.h                         |   15 +
 drivers/gpu/drm/i915/i915_suspend.c                     |    5 
 drivers/gpu/drm/i915/intel_crt.c                        |    3 
 drivers/gpu/drm/i915/intel_display.c                    |   48 +++++-
 drivers/gpu/drm/i915/intel_drv.h                        |    2 
 drivers/gpu/drm/i915/intel_fb.c                         |    2 
 drivers/gpu/drm/i915/intel_i2c.c                        |   19 ++
 drivers/gpu/drm/i915/intel_lvds.c                       |   21 ++
 drivers/gpu/drm/radeon/atom.c                           |    2 
 drivers/hwmon/adt7462.c                                 |    2 
 drivers/hwmon/lm78.c                                    |   25 +--
 drivers/hwmon/w83781d.c                                 |   26 +--
 drivers/i2c/busses/i2c-tiny-usb.c                       |   12 -
 drivers/md/dm-log-userspace-transfer.c                  |   10 -
 drivers/md/dm-stripe.c                                  |    2 
 drivers/md/raid5.c                                      |   11 -
 drivers/media/dvb/dvb-core/dmxdev.c                     |    2 
 drivers/message/fusion/mptscsih.c                       |    2 
 drivers/net/wireless/ath/ath9k/xmit.c                   |    4 
 drivers/net/wireless/b43/b43.h                          |    1 
 drivers/net/wireless/b43/main.c                         |   13 +
 drivers/net/wireless/iwlwifi/iwl-core.c                 |    1 
 drivers/net/wireless/rtl818x/rtl8187_dev.c              |    1 
 drivers/platform/x86/dell-wmi.c                         |    8 -
 drivers/platform/x86/hp-wmi.c                           |    9 +
 drivers/platform/x86/wmi.c                              |    4 
 drivers/regulator/core.c                                |    2 
 drivers/rtc/rtc-fm3130.c                                |    6 
 drivers/s390/block/dasd.c                               |   22 +-
 drivers/s390/block/dasd_eckd.c                          |   44 ++---
 drivers/s390/block/dasd_fba.c                           |   10 -
 drivers/s390/block/dasd_int.h                           |   10 +
 drivers/serial/8250.c                                   |    7 
 drivers/staging/rtl8187se/ieee80211/ieee80211.h         |   10 -
 drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c      |    2 
 drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c |   14 -
 drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c      |    2 
 drivers/staging/rtl8187se/r8180_core.c                  |   10 -
 drivers/staging/rtl8187se/r8180_wx.c                    |    2 
 drivers/usb/core/devio.c                                |   48 +++---
 drivers/usb/host/r8a66597-hcd.c                         |   37 +++-
 fs/befs/linuxvfs.c                                      |    1 
 fs/block_dev.c                                          |    7 
 fs/cifs/readdir.c                                       |    1 
 fs/ecryptfs/inode.c                                     |   16 ++
 fs/exec.c                                               |   21 ++
 fs/fcntl.c                                              |    6 
 fs/nfs/direct.c                                         |    3 
 fs/nfs/file.c                                           |    2 
 fs/nfs/fscache.c                                        |    9 -
 fs/nfs/mount_clnt.c                                     |    2 
 fs/nfs/nfs2xdr.c                                        |    2 
 fs/nfs/nfs4_fs.h                                        |    1 
 fs/nfs/nfs4proc.c                                       |   26 +++
 fs/nfs/nfs4xdr.c                                        |    6 
 fs/nfs/pagelist.c                                       |   17 +-
 fs/nfs/super.c                                          |   15 +
 fs/nfs/write.c                                          |    1 
 fs/sysfs/inode.c                                        |   47 ++----
 include/drm/drm_os_linux.h                              |    2 
 include/linux/sched.h                                   |   22 ++
 include/net/netns/conntrack.h                           |    3 
 include/net/netns/ipv4.h                                |    1 
 kernel/futex.c                                          |   30 +++
 kernel/time/timekeeping.c                               |    2 
 mm/migrate.c                                            |    3 
 net/core/dst.c                                          |    2 
 net/core/pktgen.c                                       |    1 
 net/ipv4/netfilter/arp_tables.c                         |    4 
 net/ipv4/netfilter/ip_tables.c                          |    4 
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c          |    2 
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c   |    4 
 net/ipv4/netfilter/nf_nat_core.c                        |   22 +-
 net/ipv6/netfilter/ip6_tables.c                         |    4 
 net/mac80211/ibss.c                                     |    2 
 net/netfilter/nf_conntrack_core.c                       |  117 ++++++++-------
 net/netfilter/nf_conntrack_expect.c                     |    4 
 net/netfilter/nf_conntrack_helper.c                     |    2 
 net/netfilter/nf_conntrack_netlink.c                    |    2 
 net/netfilter/nf_conntrack_standalone.c                 |    7 
 sound/pci/ctxfi/ctatc.c                                 |   15 -
 sound/pci/ctxfi/ctvmem.c                                |   38 ++--
 sound/pci/ctxfi/ctvmem.h                                |    8 -
 sound/pci/hda/hda_intel.c                               |    3 
 sound/pci/hda/patch_realtek.c                           |   28 +++
 sound/usb/usbaudio.c                                    |    2 
 110 files changed, 965 insertions(+), 458 deletions(-)


Al Viro (1):
      befs: fix leak

Alex Murray (1):
      ALSA: hda - Improved MacBook (Pro) 5,1 / 5,2 support

Alexey Dobriyan (2):
      netfilter: nf_conntrack: restrict runtime expect hashsize modifications
      netfilter: xtables: compat out of scope fix

Anisse Astier (1):
      wmi: Free the allocated acpi objects through wmi_get_event_data

Arjan van de Ven (1):
      ACPI: fix High cpu temperature with 2.6.32

Benoit Papillault (1):
      mac80211: Fix probe request filtering in IBSS mode

Borislav Petkov (1):
      amd64_edac: Do not falsely trigger kerneloops

Catalin Marinas (1):
      Call flush_dcache_page after PIO data transfers in libata-sff.c

Chris Wilson (1):
      drm/i915: Increase fb alignment to 64k

Chuck Lever (1):
      NFS: Too many GETATTR and ACCESS calls after direct I/O

Dan Williams (1):
      ioat: fix infinite timeout checking in ioat2_quiesce

Daniel Vetter (2):
      drm/i915: Update write_domains on active list after flush.
      drm/i915: add i915_lp_ring_sync helper

Dave Airlie (1):
      drm/radeon/kms: use udelay for short delays

David John (1):
      drm/i915: Disable SR when more than one pipe is enabled

Dick Hollenbeck (1):
      serial: 8250: add serial transmitter fully empty test

Eric Anholt (1):
      drm/i915: Fix DDC on some systems by clearing BIOS GMBUS setup.

Eric Dumazet (2):
      netfilter: nf_conntrack: per netns nf_conntrack_cachep
      dst: call cond_resched() in dst_gc_task()

Eric W. Biederman (1):
      sysfs: sysfs_sd_setattr set iattrs unconditionally

Francesco Lavra (1):
      V4L/DVB: dvb-core: fix initialization of feeds list in demux filter

George Kadianakis (1):
      Staging: fix rtl8187se compilation errors with mac80211

Greg Kroah-Hartman (2):
      USB: usbfs: only copy the actual data received
      Linux 2.6.32.9

Herbert Xu (1):
      crypto: padlock-sha - Add import/export support

Jaroslav Kysela (1):
      ALSA: ctxfi - fix PTP address initialization

Jason Wang (2):
      Export the symbol of getboottime and mmonotonic_to_bootbased
      kvmclock: count total_sleep_time when updating guest clock

Jean Delvare (3):
      hwmon: (w83781d) Request I/O ports individually for probing
      hwmon: (lm78) Request I/O ports individually for probing
      i2c-tiny-usb: Fix on big-endian systems

Jeff Layton (1):
      cifs: fix length calculation for converted unicode readdir names

Jelle Martijn Kok (1):
      rtl8187: Add new device ID

Jesse Barnes (2):
      drm/i915: enable self-refresh on 965
      drm/i915: handle FBC and self-refresh better

Jiri Slaby (1):
      resource: add helpers for fetching rlimits

Jody Bruchon (1):
      ALSA: hda-intel: Avoid divide by zero crash

Joerg Roedel (2):
      x86/amd-iommu: Fix IOMMU-API initialization for iommu=pt
      x86/amd-iommu: Fix deassignment of a device from the pt_domain

Jonathan Brassow (1):
      dm log: userspace fix overhead_size calcuations

Jun'ichi Nomura (1):
      freeze_bdev: don't deactivate successfully frozen MS_RDONLY sb

KAMEZAWA Hiroyuki (1):
      devmem: check vmalloc address on kmem read/write

Kashyap, Desai (1):
      SCSI: mptfusion : mptscsih_abort return value should be SUCCESS instead of value 0.

Larry Finger (1):
      b43: Fix throughput regression

Laurent Pinchart (1):
      class: Free the class private data in class_release

Len Brown (1):
      dell-wmi, hp-wmi, msi-wmi: check wmi_get_event_data() return value

Linus Torvalds (3):
      Fix potential crash with sys_move_pages
      Fix race in tty_fasync() properly
      USB: usbfs: properly clean up the as structure on error paths

Marcel Selhorst (1):
      tpm_infineon: fix suspend/resume handler for pnp_driver

Marcelo Tosatti (1):
      KVM: PIT: control word is write-only

Mark Brown (1):
      regulator: Fix display of null constraints for regulators

Matt Fleming (1):
      sh: Couple kernel and user write page perm bits for CONFIG_X2TLB

Michael Neuling (1):
      fs/exec.c: restrict initial stack space expansion to rlimit

Mikael Pettersson (1):
      futex_lock_pi() key refcnt fix

NeilBrown (1):
      md: fix 'degraded' calculation when starting a reshape.

Nikanth Karthikesan (1):
      dm stripe: avoid divide by zero with invalid stripe count

Patrick McHardy (2):
      netfilter: nf_conntrack: fix memory corruption with multiple namespaces
      netfilter: nf_conntrack: fix hash resizing with namespaces

Paul Mundt (1):
      usb: r8a66597-hcd: Flush the D-cache for the pipe-in transfer buffers.

Rafael J. Wysocki (1):
      pktgen: Fix freezing problem

Ray Copeland (1):
      hwmon: (adt7462) Wrong ADT7462_VOLT_COUNT

Sergey Matyukevich (1):
      rtc-fm3130: add missing braces

Stefan Haberland (1):
      dasd: remove strings from s390dbf

Stephen M. Cameron (1):
      cciss: Make cciss_seq_show handle holes in the h->drv[] array

Sujith (1):
      ath9k: Fix sequence numbers for PAE frames

Takashi Iwai (2):
      ALSA: hda - use WARN_ON_ONCE() for zero-division detection
      ALSA: usb-audio - Avoid Oops after disconnect

Tejun Heo (1):
      ahci: add Acer G725 to broken suspend list

Thomas Gleixner (2):
      futex: Handle user space corruption gracefully
      futex: Handle futex value corruption gracefully

Thomas Renninger (2):
      CPUFREQ: Fix use after free of struct powernow_k8_data
      ACPI: Add NULL pointer check in acpi_bus_start

Trond Myklebust (8):
      NFS: Fix a reference leak in nfs_wb_cancel_page()
      NFS: Try to commit unstable writes in nfs_release_page()
      NFSv4: Don't allow posix locking against servers that don't support it
      NFSv4: Ensure that the NFSv4 locking can recover from stateid errors
      NFS: Fix an Oops when truncating a file
      NFS: Fix a umount race
      NFS: Fix a bug in nfs_fscache_release_page()
      NFS: Fix the mapping of the NFSERR_SERVERFAULT error

Tyler Hicks (1):
      eCryptfs: Add getattr function

Wey-Yi Guy (1):
      iwlwifi: Fix to set correct ht configuration

Wu Fengguang (2):
      /dev/mem: introduce size_inside_page()
      devmem: fix kmem write bug on memory holes

Yinghai Lu (1):
      x86: Re-get cfg_new in case reuse/move irq_desc

Zhao Yakui (3):
      drm/i915: Add HP nx9020/SamsungSX20S to ACPI LID quirk list
      drm/i915: Fix the incorrect DMI string for Samsung SX20S laptop
      drm/i915: Add MALATA PC-81005 to ACPI LID quirk list

Zhenyu Wang (3):
      drm/i915: disable hotplug detect before Ironlake CRT detect
      drm/i915: remove full registers dump debug
      drm/i915: Don't wait interruptible for possible plane buffer flush

