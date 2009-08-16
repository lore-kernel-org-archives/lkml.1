Return-Path: <linux-kernel-owner+w=401wt.eu-S1756210AbZHPVj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210AbZHPVj1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 17:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756180AbZHPVjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 17:39:25 -0400
Received: from kroah.org ([198.145.64.141]:36148 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756162AbZHPVjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 17:39:24 -0400
Date: Sun, 16 Aug 2009 14:34:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.30.5
Message-ID: <20090816213436.GA7015@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.30.5 kernel.  All users of the
2.6.30 kernel series are very strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.30.4 and 2.6.30.5

The updated 2.6.30.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.30.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.30.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                       |    2 
 arch/powerpc/boot/dts/asp834x-redboot.dts      |    2 
 arch/powerpc/boot/dts/mpc8349emitx.dts         |    2 
 arch/powerpc/boot/dts/mpc834x_mds.dts          |    2 
 arch/powerpc/boot/dts/sbc8349.dts              |    2 
 arch/powerpc/platforms/83xx/mpc83xx.h          |    4 -
 arch/powerpc/platforms/83xx/usb.c              |   10 +--
 arch/x86/include/asm/irqflags.h                |    8 ++
 arch/x86/kernel/vmi_32.c                       |    2 
 arch/x86/mm/pageattr.c                         |   39 ++++++++++----
 block/Kconfig                                  |   11 ++--
 drivers/acpi/sleep.c                           |    8 ++
 drivers/edac/x38_edac.c                        |    2 
 drivers/firewire/fw-sbp2.c                     |   10 +++
 drivers/gpu/drm/i915/i915_dma.c                |    5 +
 drivers/gpu/drm/i915/i915_drv.h                |    8 ++
 drivers/gpu/drm/i915/i915_gem.c                |   13 ++++
 drivers/gpu/drm/i915/i915_irq.c                |    2 
 drivers/gpu/drm/i915/i915_suspend.c            |   20 +++++++
 drivers/gpu/drm/i915/intel_bios.c              |   10 ++-
 drivers/gpu/drm/i915/intel_display.c           |    2 
 drivers/gpu/drm/i915/intel_fb.c                |    8 ++
 drivers/gpu/drm/i915/intel_lvds.c              |   17 +++++-
 drivers/hwmon/asus_atk0110.c                   |    6 +-
 drivers/hwmon/smsc47m1.c                       |   11 ++++
 drivers/i2c/chips/tsl2550.c                    |   17 +++---
 drivers/ide/ide-disk.c                         |    1 
 drivers/ide/ide-dma.c                          |   21 -------
 drivers/ide/ide-iops.c                         |    3 -
 drivers/ide/ide-probe.c                        |   23 +++++++-
 drivers/ieee1394/sbp2.c                        |    1 
 drivers/ieee1394/sbp2.h                        |    8 ++
 drivers/md/md.c                                |   15 +++++
 drivers/md/raid5.c                             |   26 ++++-----
 drivers/net/atl1c/atl1c.h                      |    8 +-
 drivers/net/atl1c/atl1c_ethtool.c              |    2 
 drivers/net/atl1c/atl1c_main.c                 |    2 
 drivers/net/benet/be.h                         |    2 
 drivers/net/benet/be_ethtool.c                 |    4 -
 drivers/net/benet/be_main.c                    |   45 +++++++++++-----
 drivers/net/e100.c                             |    3 +
 drivers/net/sky2.c                             |    2 
 drivers/net/usb/cdc_subset.c                   |    7 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c         |   19 -------
 drivers/net/wireless/iwlwifi/iwl3945-base.c    |   19 -------
 drivers/parisc/eisa_eeprom.c                   |    2 
 drivers/platform/x86/Kconfig                   |    4 +
 drivers/scsi/libsas/sas_port.c                 |   19 +++++--
 drivers/staging/rt2870/2870_main_dev.c         |   67 ++++++++++++++++---------
 drivers/staging/rt2870/common/2870_rtmp_init.c |   35 +++++--------
 drivers/staging/rt2870/common/cmm_data.c       |    3 +
 drivers/staging/rt2870/common/rtmp_init.c      |    2 
 drivers/staging/rt2870/common/rtusb_io.c       |    3 -
 drivers/staging/rt2870/rt2870.h                |    6 --
 drivers/staging/rt2870/rt_linux.h              |   11 ++--
 drivers/usb/core/devio.c                       |   10 ++-
 drivers/usb/serial/ftdi_sio.c                  |    3 +
 drivers/usb/serial/ftdi_sio.h                  |   14 +++++
 drivers/usb/storage/transport.c                |    2 
 drivers/usb/storage/unusual_devs.h             |    7 ++
 fs/binfmt_flat.c                               |   17 ++++--
 fs/cifs/cifs_dfs_ref.c                         |   12 +++-
 fs/cifs/connect.c                              |   13 +++-
 fs/compat_ioctl.c                              |    1 
 fs/nfs/direct.c                                |   20 +++----
 fs/nfs/read.c                                  |    6 --
 fs/nfs/write.c                                 |    6 --
 fs/nilfs2/segment.c                            |   16 +++++
 fs/proc/base.c                                 |   27 ++++------
 fs/proc/task_mmu.c                             |    1 
 fs/proc/task_nommu.c                           |    1 
 fs/sysfs/dir.c                                 |    2 
 include/linux/ide.h                            |    2 
 include/linux/netdevice.h                      |    5 -
 include/linux/nfs_fs.h                         |    5 -
 include/net/sctp/sctp.h                        |    1 
 include/net/sock.h                             |   34 +++++++-----
 kernel/fork.c                                  |   22 ++++----
 kernel/posix-timers.c                          |    7 ++
 kernel/smp.c                                   |    2 
 kernel/trace/ring_buffer.c                     |   11 +---
 kernel/trace/trace.c                           |   10 ++-
 kernel/trace/trace_functions_graph.c           |   11 +++-
 mm/hugetlb.c                                   |    2 
 mm/page_alloc.c                                |   13 +++-
 net/ax25/ax25_in.c                             |    3 -
 net/core/dev.c                                 |   10 +--
 net/core/sock.c                                |   39 +++++++++++++-
 net/ipv4/ip_input.c                            |    3 +
 net/ipv6/ip6_input.c                           |    3 +
 net/irda/af_irda.c                             |    3 -
 net/irda/ircomm/ircomm_lmp.c                   |    1 
 net/socket.c                                   |    2 
 net/wireless/scan.c                            |    4 +
 net/xfrm/xfrm_algo.c                           |    4 -
 sound/pci/hda/patch_realtek.c                  |    2 
 96 files changed, 612 insertions(+), 331 deletions(-)


Ajit Khaparde (1):
      be2net: Fix to avoid a crash seen on PPC with LRO and Jumbo frames.

Alan Stern (1):
      USB: usbfs: fix -ENOENT error code to be -ENODEV

Alok Kataria (1):
      x86: Fix VMI && stack protector

Anton Vorontsov (1):
      sky2: Fix checksum endianness

Bartlomiej Zolnierkiewicz (3):
      PM / ACPI: HP G7000 Notebook needs a SCI_EN resume quirk
      ide: fix handling of unexpected IRQs vs request_irq()
      ide: relax DMA info validity checking

Dan Williams (1):
      md/raid6: release spare page at ->stop()

David Brownell (1):
      usbnet cdc_subset: fix issues talking to PXA gadgets

Dhaval Vasa (1):
      USB: ftdi_sio: add product_id for Marvell OpenRD Base, Client

Eric Anholt (1):
      drm/i915: Save/restore cursor state on suspend/resume.

Eric Dumazet (4):
      net: sk_prot_alloc() should not blindly overwrite memory
      net: sock_copy() fixes
      execve: must clear current->clear_child_tid
      ring-buffer: Fix memleak in ring_buffer_free()

Eric Sandeen (2):
      hugetlbfs: fix i_blocks accounting
      compat_ioctl: hook up compat handler for FIEMAP ioctl

Giacomo Lozito (1):
      USB: storage: raise timeout in usb_stor_Bulk_max_lun

Greg Kroah-Hartman (2):
      Staging: rt2870: Revert d44ca7 Removal of kernel_thread() API
      Linux 2.6.30.5

Grégoire Henry (1):
      drm/i915: initialize fence registers to zero when loading GEM

H. Peter Anvin (1):
      x86: fix assembly constraints in native_save_fl()

Henrique de Moraes Holschuh (1):
      thinkpad-acpi: disable broken bay and dock subdrivers

Herbert Xu (5):
      ipsec: Fix name of CAST algorithm
      gro: Flush GRO packets in napi_disable_pending path
      gso: Stop fraglists from escaping
      net: Move rx skb_orphan call to where needed
      inet: Call skb_orphan before tproxy activates

Hiroshi Shimamoto (1):
      posix-timers: Fix oops in clock_nanosleep() with CLOCK_MONOTONIC_RAW

Jarod Wilson (1):
      drm/i915: add ignore lvds quirk info for AOpen Mini PC

Jean Delvare (1):
      hwmon: (smsc47m1) Differentiate between LPC47M233 and LPC47M292

Jeff Layton (1):
      cifs: fix error handling in mount-time DFS referral chasing code

Jesse Barnes (2):
      drm/i915: apply G45 vblank count code to all G4x chips and fix max_frame_count
      drm/i915: avoid non-atomic sysrq execution

Johannes Berg (1):
      cfg80211: add two missing NULL pointer checks

John Stoffel (1):
      Make SCSI SG v4 driver enabled by default and remove EXPERIMENTAL dependency, since udev depends on BSG

Keith Packard (1):
      drm/i915: Hook connector to encoder during load detection (fixes tv/vga detect)

Krzysztof Halasa (1):
      E100: work around the driver using streaming DMA mapping for RX descriptors.

Lai Jiangshan (2):
      tracing: Fix invalid function_graph entry
      tracing: Fix missing function_graph events when we splice_read from trace_pipe

Linus Torvalds (2):
      flat: fix uninitialized ptr with shared libs
      Make sock_sendpage() use kernel_sendpage()

Lu Zhihe (1):
      edac: x38 fix mchbar high register addr

Luca Tettamanti (1):
      hwmon: (asus_atk0110) Fix upper limit readings

Ma Ling (1):
      drm/i915: Set SSC frequency for 8xx chips correctly

Marko Hänninen (1):
      USB: ftdi_sio: add vendor and product id for Bayer glucose meter serial converter cable

Maxime Bizon (1):
      ide: fix memory leak when flush command is issued

Mel Gorman (1):
      page-allocator: preserve PFN ordering when __GFP_COLD is set

Michael Buesch (2):
      parisc: isa-eeprom - Fix loff_t usage
      USB: devio: Properly do access_ok() checks

Michael Cousin (1):
      drm/i915: Skip lvds with Aopen i945GTt-VFA

Michele Jr De Candia (1):
      i2c/tsl2550: Fix lux value in dark environment

Neil Brown (1):
      md: Handle growth of v1.x metadata correctly.

NeilBrown (1):
      md: when a level change reduces the number of devices, remove the excess.

Oleg Nesterov (3):
      mm_for_maps: simplify, use ptrace_may_access()
      mm_for_maps: shift down_read(mmap_sem) to the caller
      mm_for_maps: take ->cred_guard_mutex to fix the race with exec

Pallipadi, Venkatesh (1):
      x86, pat: Fix set_memory_wc related corruption

Peter Korsgaard (1):
      powerpc/mpc83xx: Fix usb mux setup for mpc834x

Peter Oberparleiter (1):
      sysfs: fix hardlink count on device_move

Reinette Chatre (1):
      iwlwifi: only show active power level via sysfs

Robert Richter (1):
      ring-buffer: Fix advance of reader in rb_buffer_peek()

Roel Kluin (1):
      atl1c: WAKE_MCAST tested twice, not WAKE_UCAST

Rogerio Brito (1):
      USB: storage: include Prolific Technology USB drive in unusual_devs list

Ryusuke Konishi (1):
      nilfs2: fix oops due to inconsistent state in page with discrete b-tree nodes

Stefan Richter (2):
      firewire: sbp2: add support for disks >2 TB (and 16 bytes long CDBs)
      ieee1394: sbp2: add support for disks >2 TB (and 16 bytes long CDBs)

Takashi Iwai (1):
      ALSA: hda - Add missing vmaster initialization for ALC269

Thomas Hellstrom (1):
      x86: Fix CPA memtype reserving in the set_pages_array*() cases

Tom Peng (1):
      SCSI: libsas: reuse the original port when hotplugging phys in wide ports

Trond Myklebust (1):
      NFS: Fix an O_DIRECT Oops...

Xiao Guangrong (1):
      generic-ipi: fix hotplug_cfd()

roel kluin (2):
      atl1c: add missing parentheses
      atl1c: misplaced parenthesis

