Return-Path: <linux-kernel-owner+w=401wt.eu-S1754348AbZF1Q13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbZF1Q13 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbZF1Q1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:27:10 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1067 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbZF1Q1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:27:07 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 00/62] Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:26:05 -0700
Message-Id: <cover.1246173664.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found by script
#! /bin/bash

from=";\s*;\s*\n"
to=";\n"

for file in $(grep -rP --include=*.[ch] -li $from *) ; do

    perl -i -e \
	"local $/; while(<>) { s/$from/$to/g; print; }" $file

done

Some false positives removed manually

Joe Perches (62):
  arch/arm: Remove unnecessary semicolons
  arch/ia64: Remove unnecessary semicolons
  arch/m68knommu/kernel/time.c: Remove unnecessary semicolons
  arch/mips/kernel/vpe.c: Remove unnecessary semicolons
  arch/powerpc: Remove unnecessary semicolons
  arch/s390/hypfs/inode.c: Remove unnecessary semicolons
  arch/s390/kvm/interrupt.c: Remove unnecessary semicolons
  arch/sh/boards/mach-se/7206/io.c: Remove unnecessary semicolons
  arch/sparc/kernel/irq_64.c: Remove unnecessary semicolons
  arch/um/drivers/net_kern.c: Remove unnecessary semicolons
  arch/x86/kernel/ds.c: Remove unnecessary semicolons
  drivers/ata: Remove unnecessary semicolons
  drivers/block: Remove unnecessary semicolons
  drivers/char/epca.c: Remove unnecessary semicolons
  drivers/dma/fsldma.c: Remove unnecessary semicolons
  drivers/dma: Remove unnecessary semicolons
  drivers/gpu/drm: Remove unnecessary semicolons
  drivers/hwmon/sht15.c: Remove unnecessary semicolons
  drivers/ide: Remove unnecessary semicolons
  drivers/isdn/capi/capiutil.c: Remove unnecessary semicolons
  drivers/macintosh/rack-meter.c: Remove unnecessary semicolons
  drivers/media/video/cx18/cx18-fileops.c: Remove unnecessary semicolons
  drivers/media/video/ivtv/ivtv-driver.c: Remove unnecessary semicolons
  drivers/media: Remove unnecessary semicolons
  drivers/mfd/twl4030-irq.c: Remove unnecessary semicolons
  drivers/mmc/host/imxmmc.c: Remove unnecessary semicolons
  drivers/net/wireless/ath/ath9k: Remove unnecessary semicolons
  drivers/net/bnx2x_link.c: Remove unnecessary semicolons
  drivers/net/igb/igb_main.c: Remove unnecessary semicolons
  drivers/net/qlge/qlge_main.c: Remove unnecessary semicolons
  drivers/net/skfp: Remove unnecessary semicolons
  drivers/net/skge.c: Remove unnecessary semicolons
  drivers/net/sky2.c: Remove unnecessary semicolons
  drivers/net: Remove unnecessary semicolons
  drivers/pci/pcie/aer/ecrc.c: Remove unnecessary semicolons
  drivers/pcmcia/pcmcia_resource.c: Remove unnecessary semicolons
  drivers/regulator/pcf50633-regulator.c: Remove unnecessary semicolons
  drivers/rtc/rtc-omap.c: Remove unnecessary semicolons
  drivers/s390/block/dasd_eckd.c: Remove unnecessary semicolons
  drivers/s390/net/netiucv.c: Remove unnecessary semicolons
  drivers/s390/scsi/zfcp_scsi.c: Remove unnecessary semicolons
  drivers/scsi/bnx2i/bnx2i_hwi.c: Remove unnecessary semicolons
  include/scsi/fc/fc_fc2.h: Remove unnecessary semicolons
  drivers/scsi/lpfc/lpfc_ct.c: Remove unnecessary semicolons
  drivers/spi: Remove unnecessary semicolons
  drivers/staging: Remove unnecessary semicolons
  drivers/usb: Remove unnecessary semicolons
  drivers/uwb/i1480/i1480u-wlp/netdev.c: Remove unnecessary semicolons
  drivers/video/cfbcopyarea.c: Remove unnecessary semicolons
  drivers/video/imxfb.c: Remove unnecessary semicolons
  drivers/video/s3c2410fb.c: Remove unnecessary semicolons
  drivers/watchdog/bcm47xx_wdt.c: Remove unnecessary semicolons
  drivers/xen/balloon.c: Remove unnecessary semicolons
  fs/autofs/dirhash.c: Remove unnecessary semicolons
  fs/btrfs/tree-log.c: Remove unnecessary semicolons
  fs/cifs/cifs_dfs_ref.c: Remove unnecessary semicolons
  fs/ext4/mballoc.c: Remove unnecessary semicolons
  fs/nfs/callback_xdr.c: Remove unnecessary semicolons
  fs/ocfs2/quota_global.c: Remove unnecessary semicolons
  kernel/trace/trace_hw_branches.c: Remove unnecessary semicolons
  net/wireless/wext-compat.c: Remove unnecessary semicolons
  sound: Remove unnecessary semicolons

 arch/arm/mach-at91/at91cap9_devices.c              |    2 +-
 arch/arm/mach-at91/at91sam9rl_devices.c            |    2 +-
 arch/arm/mach-w90x900/w90p910.c                    |    2 +-
 arch/arm/plat-mxc/irq.c                            |    2 +-
 arch/ia64/kernel/esi.c                             |    2 +-
 arch/ia64/kvm/process.c                            |    6 +++---
 arch/ia64/kvm/vcpu.c                               |    2 +-
 arch/ia64/kvm/vtlb.c                               |    4 ++--
 arch/m68knommu/kernel/time.c                       |    2 +-
 arch/mips/kernel/vpe.c                             |    2 +-
 arch/powerpc/mm/tlb_hash64.c                       |    2 +-
 arch/powerpc/oprofile/cell/vma_map.c               |    2 +-
 arch/powerpc/platforms/powermac/cpufreq_64.c       |    2 +-
 arch/powerpc/platforms/powermac/pic.c              |    2 +-
 arch/powerpc/platforms/ps3/system-bus.c            |    1 -
 arch/powerpc/sysdev/fsl_rio.c                      |    2 +-
 arch/powerpc/sysdev/ppc4xx_pci.c                   |    4 ++--
 arch/s390/hypfs/inode.c                            |    2 +-
 arch/s390/kvm/interrupt.c                          |    2 +-
 arch/sh/boards/mach-se/7206/io.c                   |    2 +-
 arch/sparc/kernel/irq_64.c                         |    2 +-
 arch/um/drivers/net_kern.c                         |    2 +-
 arch/x86/kernel/ds.c                               |    2 +-
 drivers/ata/pata_octeon_cf.c                       |    2 +-
 drivers/ata/sata_inic162x.c                        |    2 +-
 drivers/block/DAC960.c                             |    4 ++--
 drivers/block/swim3.c                              |    2 +-
 drivers/char/epca.c                                |    2 +-
 drivers/dma/dmatest.c                              |    2 +-
 drivers/dma/fsldma.c                               |    2 +-
 drivers/dma/mv_xor.c                               |    2 +-
 drivers/gpu/drm/i915/intel_dp.c                    |    2 +-
 drivers/gpu/drm/radeon/r300.c                      |    4 ++--
 drivers/hwmon/sht15.c                              |    2 +-
 drivers/ide/ide-probe.c                            |    2 +-
 drivers/ide/umc8672.c                              |    4 ++--
 drivers/isdn/capi/capiutil.c                       |    2 +-
 drivers/macintosh/rack-meter.c                     |    2 +-
 drivers/media/dvb/b2c2/flexcop-fe-tuner.c          |    2 +-
 drivers/media/dvb/dvb-usb/dib0700_devices.c        |    2 +-
 drivers/media/dvb/frontends/cx24123.c              |    2 +-
 drivers/media/dvb/frontends/dib0070.c              |    2 +-
 drivers/media/dvb/frontends/stv0900_sw.c           |    2 +-
 drivers/media/video/cx18/cx18-fileops.c            |    2 +-
 drivers/media/video/cx231xx/cx231xx-video.c        |    4 ++--
 drivers/media/video/cx23885/cx23885.h              |    2 +-
 drivers/media/video/ivtv/ivtv-driver.c             |    2 +-
 drivers/mfd/twl4030-irq.c                          |    2 +-
 drivers/mmc/host/imxmmc.c                          |    2 +-
 drivers/net/arcnet/arc-rawmode.c                   |    1 -
 drivers/net/arcnet/capmode.c                       |    1 -
 drivers/net/bnx2x_link.c                           |    2 +-
 drivers/net/gianfar_ethtool.c                      |    2 +-
 drivers/net/ibm_newemac/core.c                     |    8 ++++----
 drivers/net/igb/igb_main.c                         |    4 ++--
 drivers/net/ll_temac_main.c                        |    2 +-
 drivers/net/ni52.c                                 |    4 ++--
 drivers/net/qlge/qlge_main.c                       |    4 ++--
 drivers/net/skfp/pcmplc.c                          |    2 +-
 drivers/net/skfp/pmf.c                             |    8 ++++----
 drivers/net/skge.c                                 |    2 +-
 drivers/net/sky2.c                                 |    2 +-
 drivers/net/vxge/vxge-config.h                     |    2 +-
 drivers/net/vxge/vxge-main.c                       |    2 +-
 drivers/net/wireless/ath/ath9k/eeprom.c            |    2 --
 drivers/net/wireless/ath/ath9k/hw.c                |    2 +-
 drivers/net/wireless/iwmc3200wifi/rx.c             |    8 ++++----
 drivers/pci/pcie/aer/ecrc.c                        |    2 +-
 drivers/pcmcia/pcmcia_resource.c                   |    2 +-
 drivers/regulator/pcf50633-regulator.c             |    2 +-
 drivers/rtc/rtc-omap.c                             |    2 +-
 drivers/s390/block/dasd_eckd.c                     |    2 +-
 drivers/s390/net/netiucv.c                         |    2 +-
 drivers/s390/scsi/zfcp_scsi.c                      |    2 +-
 drivers/scsi/bnx2i/bnx2i_hwi.c                     |    2 +-
 drivers/scsi/lpfc/lpfc_ct.c                        |    2 +-
 drivers/spi/omap_uwire.c                           |    2 +-
 drivers/spi/spi_s3c24xx.c                          |    2 +-
 .../comedi/drivers/addi-data/APCI1710_Tor.c        |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci1500.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci1516.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3501.c      |    2 +-
 drivers/staging/comedi/drivers/amplc_pci230.c      |    2 +-
 drivers/staging/comedi/drivers/comedi_bond.c       |    2 +-
 drivers/staging/go7007/go7007-driver.c             |    2 +-
 drivers/staging/otus/80211core/cmmsta.c            |    2 +-
 drivers/staging/otus/hal/hpmain.c                  |    2 +-
 drivers/staging/rt2860/common/cmm_data_2860.c      |    8 ++++----
 drivers/staging/rt2860/rt_linux.c                  |    2 +-
 drivers/staging/rt2860/rtmp.h                      |    3 +--
 drivers/staging/rt2860/sta/aironet.c               |    2 +-
 drivers/staging/rtl8187se/r8185b_init.c            |    2 +-
 drivers/staging/rtl8192su/ieee80211/ieee80211_tx.c |    2 +-
 drivers/staging/rtl8192su/r8192U_core.c            |    6 +++---
 drivers/staging/rtl8192su/r819xU_phy.c             |    2 +-
 drivers/staging/vt6655/card.c                      |    2 +-
 drivers/staging/vt6655/iwctl.c                     |    2 +-
 drivers/staging/vt6655/wpa2.c                      |    4 ++--
 drivers/usb/class/cdc-wdm.c                        |    2 --
 drivers/usb/serial/spcp8x5.c                       |    2 +-
 drivers/uwb/i1480/i1480u-wlp/netdev.c              |    2 +-
 drivers/video/cfbcopyarea.c                        |    2 +-
 drivers/video/imxfb.c                              |    2 +-
 drivers/video/s3c2410fb.c                          |    2 +-
 drivers/watchdog/bcm47xx_wdt.c                     |    2 +-
 drivers/xen/balloon.c                              |    2 +-
 fs/autofs/dirhash.c                                |    2 +-
 fs/btrfs/tree-log.c                                |    2 +-
 fs/cifs/cifs_dfs_ref.c                             |    2 +-
 fs/ext4/mballoc.c                                  |    2 +-
 fs/nfs/callback_xdr.c                              |    2 +-
 fs/ocfs2/quota_global.c                            |    2 +-
 include/scsi/fc/fc_fc2.h                           |    3 +--
 kernel/trace/trace_hw_branches.c                   |    2 +-
 net/wireless/wext-compat.c                         |    2 +-
 sound/oss/sys_timer.c                              |    3 ---
 sound/soc/codecs/wm9081.c                          |    2 +-
 sound/soc/pxa/pxa-ssp.c                            |    2 +-
 sound/soc/s3c24xx/s3c24xx_uda134x.c                |    2 +-
 119 files changed, 139 insertions(+), 151 deletions(-)

