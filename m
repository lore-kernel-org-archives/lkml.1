Return-Path: <linux-kernel-owner+w=401wt.eu-S1755675AbZHMT7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675AbZHMT7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754873AbZHMT7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:59:08 -0400
Received: from kroah.org ([198.145.64.141]:41610 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754832AbZHMT7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:59:06 -0400
Date: Thu, 13 Aug 2009 12:57:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 00/74] 2.6.30.5-stable review
Message-ID: <20090813195705.GA22393@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.30.5 release.
There are 74 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Saturday, August 15, 2009 19:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.30.5-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h

----------------

 Makefile                                       |    2 +-
 arch/powerpc/boot/dts/asp834x-redboot.dts      |    2 +-
 arch/powerpc/boot/dts/mpc8349emitx.dts         |    2 +-
 arch/powerpc/boot/dts/mpc834x_mds.dts          |    2 +-
 arch/powerpc/boot/dts/sbc8349.dts              |    2 +-
 arch/powerpc/platforms/83xx/mpc83xx.h          |    4 +-
 arch/powerpc/platforms/83xx/usb.c              |   10 ++--
 arch/x86/include/asm/irqflags.h                |    8 +++-
 arch/x86/kernel/vmi_32.c                       |    2 +-
 arch/x86/mm/pageattr.c                         |   39 ++++++++++----
 block/Kconfig                                  |   11 +++--
 drivers/acpi/sleep.c                           |    8 +++
 drivers/edac/x38_edac.c                        |    2 +-
 drivers/firewire/fw-sbp2.c                     |   10 +++-
 drivers/gpu/drm/i915/i915_dma.c                |    5 ++-
 drivers/gpu/drm/i915/i915_drv.h                |    8 +++
 drivers/gpu/drm/i915/i915_gem.c                |   13 +++++
 drivers/gpu/drm/i915/i915_irq.c                |    2 -
 drivers/gpu/drm/i915/i915_suspend.c            |   20 +++++++
 drivers/gpu/drm/i915/intel_bios.c              |   10 ++--
 drivers/gpu/drm/i915/intel_display.c           |    2 +
 drivers/gpu/drm/i915/intel_fb.c                |    8 +++-
 drivers/gpu/drm/i915/intel_lvds.c              |   17 +++++-
 drivers/hwmon/asus_atk0110.c                   |    6 ++-
 drivers/hwmon/smsc47m1.c                       |   11 ++++
 drivers/i2c/chips/tsl2550.c                    |   17 ++++---
 drivers/ide/ide-disk.c                         |    1 +
 drivers/ide/ide-dma.c                          |   21 -------
 drivers/ide/ide-iops.c                         |    3 -
 drivers/ide/ide-probe.c                        |   23 +++++++-
 drivers/ieee1394/sbp2.c                        |    1 +
 drivers/ieee1394/sbp2.h                        |    8 +++-
 drivers/md/md.c                                |   15 +++++-
 drivers/md/raid5.c                             |   26 ++++-----
 drivers/net/atl1c/atl1c.h                      |    8 ++--
 drivers/net/atl1c/atl1c_ethtool.c              |    2 +-
 drivers/net/atl1c/atl1c_main.c                 |    2 +-
 drivers/net/benet/be.h                         |    2 +-
 drivers/net/benet/be_ethtool.c                 |    4 +-
 drivers/net/benet/be_main.c                    |   45 +++++++++++-----
 drivers/net/e100.c                             |    3 +
 drivers/net/sky2.c                             |    2 +-
 drivers/net/usb/cdc_subset.c                   |    7 ++-
 drivers/net/wireless/iwlwifi/iwl-agn.c         |   19 +------
 drivers/net/wireless/iwlwifi/iwl3945-base.c    |   19 +------
 drivers/parisc/eisa_eeprom.c                   |    2 +-
 drivers/platform/x86/Kconfig                   |    4 +-
 drivers/platform/x86/thinkpad_acpi.c           |   61 +++++++++++++++++-----
 drivers/scsi/libsas/sas_port.c                 |   19 +++++--
 drivers/staging/rt2870/2870_main_dev.c         |   67 ++++++++++++++++--------
 drivers/staging/rt2870/common/2870_rtmp_init.c |   35 ++++++-------
 drivers/staging/rt2870/common/cmm_data.c       |    3 +
 drivers/staging/rt2870/common/rtmp_init.c      |    2 +-
 drivers/staging/rt2870/common/rtusb_io.c       |    3 +-
 drivers/staging/rt2870/rt2870.h                |    6 +--
 drivers/staging/rt2870/rt_linux.h              |   11 ++--
 drivers/usb/core/devio.c                       |   10 ++--
 drivers/usb/serial/ftdi_sio.c                  |    3 +
 drivers/usb/serial/ftdi_sio.h                  |   14 +++++
 drivers/usb/storage/transport.c                |    2 +-
 drivers/usb/storage/unusual_devs.h             |    7 +++
 fs/binfmt_flat.c                               |   17 ++++--
 fs/cifs/cifs_dfs_ref.c                         |   12 +++-
 fs/cifs/connect.c                              |   13 ++++-
 fs/compat_ioctl.c                              |    1 +
 fs/nfs/direct.c                                |   20 ++++----
 fs/nfs/read.c                                  |    6 +--
 fs/nfs/write.c                                 |    6 +--
 fs/nilfs2/segment.c                            |   16 +++++-
 fs/proc/base.c                                 |   27 ++++-----
 fs/proc/task_mmu.c                             |    1 +
 fs/proc/task_nommu.c                           |    1 +
 fs/sysfs/dir.c                                 |    2 +
 include/linux/ide.h                            |    2 -
 include/linux/netdevice.h                      |    5 +-
 include/linux/nfs_fs.h                         |    5 +-
 include/net/sctp/sctp.h                        |    1 +
 include/net/sock.h                             |   34 +++++++-----
 kernel/fork.c                                  |   22 ++++----
 kernel/posix-timers.c                          |    7 +++
 kernel/smp.c                                   |    2 +-
 kernel/trace/ring_buffer.c                     |   11 ++--
 kernel/trace/trace.c                           |   10 +++-
 kernel/trace/trace_functions_graph.c           |   11 +++-
 mm/hugetlb.c                                   |    2 +-
 mm/page_alloc.c                                |   13 +++--
 net/ax25/ax25_in.c                             |    3 +-
 net/core/dev.c                                 |   10 ++--
 net/core/sock.c                                |   39 ++++++++++++--
 net/ipv4/ip_input.c                            |    3 +
 net/ipv6/ip6_input.c                           |    3 +
 net/irda/af_irda.c                             |    3 -
 net/irda/ircomm/ircomm_lmp.c                   |    1 +
 net/socket.c                                   |    2 +-
 net/wireless/scan.c                            |    4 +-
 net/xfrm/xfrm_algo.c                           |    4 +-
 sound/pci/hda/patch_realtek.c                  |    2 +
 97 files changed, 659 insertions(+), 345 deletions(-)
