Return-Path: <linux-kernel-owner+w=401wt.eu-S1753139AbZKOPLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbZKOPLZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 10:11:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbZKOPLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 10:11:24 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:34714 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082AbZKOPLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 10:11:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=m4Q6TRsSxeosQLID5mxjlJe22ByJh7VpZV+EaeEj1VKtJn8NzqvKElF6usjmMHaS3t
         KZY5vZ8TBeaYnRKWQwzD4mtmgIuZpqsyWdCrPzE4aU+YwvfernkO1oqznIeKPpZqiroo
         o602T+Y/76KbOxW2bwKI1QSqC9zVefxr2fmX4=
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
To: jkosina@suse.cz, "linux list" <linux-kernel@vger.kernel.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Subject: [PATCH v3 1/2] trivial: tree-wide: fix assorted typos all over the place
Date: Sat, 14 Nov 2009 13:09:05 -0200
Message-Id: <73057d290d1358776ac0c9fbf69601a44663b81a.1258210892.git.andre.goddard@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e.dirty
In-Reply-To: <cover.1258210891.git.andre.goddard@gmail.com>
References: <cover.1258210891.git.andre.goddard@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That is "success", "unknown", "through", "performance", "[re|un]mapping"
, "access", "default", "reasonable", "[con]currently", "temperature"
, "channel", "[un]used", "application", "example","hierarchy", "therefore"
, "[over|under]flow", "contiguous", "threshold", "enough" and others.

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
---
 Documentation/ABI/testing/procfs-diskstats         |    2 +-
 Documentation/ABI/testing/sysfs-block              |    2 +-
 Documentation/DocBook/mtdnand.tmpl                 |    2 +-
 Documentation/DocBook/v4l/videodev2.h.xml          |    2 +-
 Documentation/DocBook/writing-an-alsa-driver.tmpl  |    2 +-
 Documentation/dvb/README.dvb-usb                   |    2 +-
 Documentation/lguest/lguest.c                      |    2 +-
 Documentation/scsi/ChangeLog.megaraid_sas          |    2 +-
 Documentation/spi/spi-summary                      |    2 +-
 Documentation/sysctl/vm.txt                        |    2 +-
 Documentation/video4linux/gspca.txt                |    2 +-
 Documentation/vm/page-types.c                      |    2 +-
 arch/alpha/mm/numa.c                               |    2 +-
 arch/arm/common/scoop.c                            |    2 +-
 .../mach-bcmring/include/mach/csp/dmacHw_priv.h    |    2 +-
 arch/arm/mach-bcmring/include/mach/dma.h           |    2 +-
 arch/arm/mach-lh7a40x/include/mach/hardware.h      |    2 +-
 arch/arm/mach-orion5x/pci.c                        |    2 +-
 arch/arm/mach-pxa/include/mach/palmld.h            |    2 +-
 arch/arm/mach-pxa/include/mach/palmt5.h            |    2 +-
 arch/arm/mach-pxa/include/mach/palmtc.h            |    2 +-
 arch/arm/mach-pxa/include/mach/palmte2.h           |    2 +-
 arch/arm/mach-pxa/include/mach/palmtx.h            |    2 +-
 arch/arm/mach-pxa/include/mach/palmz72.h           |    2 +-
 arch/arm/mach-s3c6400/setup-sdhci.c                |    2 +-
 arch/arm/mach-s3c6410/setup-sdhci.c                |    2 +-
 arch/arm/mach-sa1100/dma.c                         |    2 +-
 arch/arm/plat-mxc/include/mach/iomux-mx3.h         |    2 +-
 arch/arm/plat-mxc/include/mach/iomux-mxc91231.h    |    2 +-
 arch/arm/plat-mxc/pwm.c                            |    2 +-
 arch/arm/plat-omap/dma.c                           |    2 +-
 arch/arm/plat-omap/include/mach/omap16xx.h         |    2 +-
 arch/arm/plat-s3c24xx/include/plat/map.h           |    2 +-
 arch/avr32/boards/hammerhead/Kconfig               |    2 +-
 arch/blackfin/kernel/traps.c                       |    2 +-
 .../mach-bf518/include/mach/defBF51x_base.h        |    4 +-
 .../mach-bf527/include/mach/defBF52x_base.h        |    4 +-
 arch/blackfin/mach-bf537/include/mach/defBF534.h   |    4 +-
 arch/blackfin/mach-bf548/include/mach/defBF544.h   |    4 +-
 arch/blackfin/mach-bf548/include/mach/defBF547.h   |    4 +-
 arch/blackfin/mach-bf548/include/mach/defBF548.h   |    4 +-
 arch/blackfin/mach-bf548/include/mach/defBF549.h   |    4 +-
 arch/cris/mm/fault.c                               |    2 +-
 arch/ia64/hp/common/sba_iommu.c                    |    2 +-
 arch/ia64/ia32/ia32_entry.S                        |    2 +-
 arch/ia64/include/asm/perfmon_default_smpl.h       |    2 +-
 arch/ia64/include/asm/sn/shubio.h                  |    2 +-
 arch/ia64/kernel/esi.c                             |    2 +-
 arch/ia64/kernel/perfmon.c                         |    2 +-
 arch/m68k/ifpsp060/src/fpsp.S                      |   28 +++++-----
 arch/m68k/ifpsp060/src/pfpsp.S                     |   26 ++++----
 arch/m68k/include/asm/bootinfo.h                   |    2 +-
 arch/microblaze/lib/memcpy.c                       |    2 +-
 arch/microblaze/lib/memmove.c                      |    2 +-
 arch/microblaze/lib/memset.c                       |    2 +-
 arch/mips/include/asm/mach-pnx833x/gpio.h          |    2 +-
 arch/mips/include/asm/sgi/ioc.h                    |    2 +-
 arch/mips/include/asm/sibyte/sb1250_mac.h          |    2 +-
 arch/mips/include/asm/sn/sn0/hubio.h               |    2 +-
 arch/mips/kernel/smtc.c                            |    2 +-
 arch/mips/math-emu/dp_sub.c                        |    2 +-
 arch/mips/txx9/generic/smsc_fdc37m81x.c            |    2 +-
 arch/powerpc/include/asm/reg_fsl_emb.h             |    2 +-
 arch/powerpc/kernel/kgdb.c                         |    2 +-
 arch/powerpc/kernel/tau_6xx.c                      |    2 +-
 arch/powerpc/oprofile/op_model_cell.c              |    4 +-
 arch/powerpc/platforms/52xx/mpc52xx_pci.c          |    2 +-
 arch/powerpc/platforms/powermac/pci.c              |    2 +-
 arch/powerpc/sysdev/dart_iommu.c                   |    2 +-
 arch/s390/math-emu/math.c                          |    4 +-
 arch/x86/include/asm/desc_defs.h                   |    4 +-
 arch/x86/include/asm/mmzone_32.h                   |    2 +-
 arch/x86/include/asm/uv/uv_bau.h                   |    2 +-
 arch/x86/kernel/acpi/boot.c                        |    2 +-
 arch/x86/kernel/amd_iommu.c                        |    4 +-
 arch/x86/kernel/cpu/perf_event.c                   |    2 +-
 arch/x86/kernel/kprobes.c                          |    4 +-
 arch/x86/mm/kmmio.c                                |    4 +-
 arch/x86/pci/amd_bus.c                             |    2 +-
 block/blk-iopoll.c                                 |    2 +-
 drivers/ata/ata_piix.c                             |    2 +-
 drivers/ata/sata_fsl.c                             |    6 +-
 drivers/atm/iphase.c                               |    2 +-
 drivers/base/dd.c                                  |    2 +-
 drivers/bluetooth/btmrvl_sdio.c                    |    2 +-
 drivers/bluetooth/hci_ldisc.c                      |    2 +-
 drivers/char/mem.c                                 |    2 +-
 drivers/char/mspec.c                               |    2 +-
 drivers/char/n_r3964.c                             |    2 +-
 drivers/char/rio/route.h                           |    2 +-
 drivers/crypto/hifn_795x.c                         |    2 +-
 drivers/dma/at_hdmac.c                             |    2 +-
 drivers/firewire/core-topology.c                   |    2 +-
 drivers/gpu/drm/drm_crtc.c                         |    4 +-
 drivers/gpu/drm/i915/i915_gem.c                    |    2 +-
 drivers/gpu/drm/i915/intel_fb.c                    |    2 +-
 drivers/gpu/drm/i915/intel_sdvo.c                  |    2 +-
 drivers/gpu/drm/radeon/r600.c                      |    4 +-
 drivers/gpu/drm/radeon/radeon_fb.c                 |    2 +-
 drivers/gpu/drm/radeon/radeon_state.c              |    2 +-
 drivers/gpu/drm/radeon/radeon_ttm.c                |    2 +-
 drivers/gpu/drm/radeon/rv770.c                     |    4 +-
 drivers/gpu/drm/ttm/ttm_bo_util.c                  |    2 +-
 drivers/hwmon/adm1029.c                            |    2 +-
 drivers/hwmon/lm93.c                               |    2 +-
 drivers/ieee1394/dv1394.c                          |    2 +-
 drivers/infiniband/hw/ipath/ipath_iba6110.c        |    2 +-
 drivers/infiniband/hw/ipath/ipath_sd7220.c         |    4 +-
 drivers/infiniband/hw/mlx4/qp.c                    |    2 +-
 drivers/input/serio/hp_sdc.c                       |    2 +-
 drivers/input/serio/hp_sdc_mlc.c                   |    2 +-
 drivers/input/touchscreen/atmel-wm97xx.c           |    2 +-
 drivers/input/touchscreen/mainstone-wm97xx.c       |    4 +-
 drivers/input/touchscreen/zylonite-wm97xx.c        |    2 +-
 drivers/isdn/capi/capidrv.c                        |    2 +-
 drivers/isdn/hardware/eicon/di.c                   |    2 +-
 drivers/isdn/hardware/eicon/maintidi.c             |    4 +-
 drivers/isdn/hardware/mISDN/hfcsusb.c              |    2 +-
 drivers/isdn/hardware/mISDN/hfcsusb.h              |    2 +-
 drivers/isdn/hardware/mISDN/mISDNisar.c            |    2 +-
 drivers/isdn/hisax/hfc_usb.c                       |    2 +-
 drivers/isdn/i4l/isdn_ppp.c                        |    6 +-
 drivers/isdn/i4l/isdn_ttyfax.c                     |    2 +-
 drivers/isdn/mISDN/dsp_core.c                      |    2 +-
 drivers/isdn/mISDN/tei.c                           |    2 +-
 drivers/macintosh/therm_windtunnel.c               |    2 +-
 drivers/media/common/saa7146_i2c.c                 |    2 +-
 drivers/media/dvb/dvb-core/dvb_frontend.h          |    2 +-
 drivers/media/dvb/dvb-usb/anysee.c                 |    2 +-
 drivers/media/dvb/dvb-usb/dibusb-mb.c              |    2 +-
 drivers/media/dvb/dvb-usb/dvb-usb-remote.c         |    2 +-
 drivers/media/dvb/dvb-usb/usb-urb.c                |    4 +-
 drivers/media/dvb/frontends/au8522_decoder.c       |    2 +-
 drivers/media/dvb/frontends/cx24110.c              |    4 +-
 drivers/media/dvb/frontends/cx24113.c              |    2 +-
 drivers/media/dvb/frontends/dib3000mb.c            |    2 +-
 drivers/media/dvb/frontends/lgdt330x.c             |    4 +-
 drivers/media/dvb/frontends/stb0899_drv.c          |    2 +-
 drivers/media/dvb/ttpci/av7110.c                   |    4 +-
 drivers/media/dvb/ttpci/budget-patch.c             |    2 +-
 drivers/media/radio/radio-mr800.c                  |    2 +-
 drivers/media/video/cx231xx/cx231xx-avcore.c       |    8 ++-
 drivers/media/video/cx23885/cx23885-dvb.c          |    2 +-
 drivers/media/video/cx88/cx88-core.c               |    2 +-
 drivers/media/video/davinci/dm355_ccdc.c           |    2 +-
 drivers/media/video/davinci/vpss.c                 |    2 +-
 drivers/media/video/gspca/sonixb.c                 |    2 +-
 drivers/media/video/gspca/spca500.c                |    2 +-
 drivers/media/video/gspca/spca501.c                |    6 +-
 drivers/media/video/gspca/sunplus.c                |    2 +-
 drivers/media/video/gspca/zc3xx.c                  |    2 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h |    2 +-
 drivers/media/video/s2255drv.c                     |    2 +-
 drivers/media/video/zoran/zoran.h                  |    2 +-
 drivers/message/i2o/i2o_block.c                    |    2 +-
 drivers/message/i2o/iop.c                          |    4 +-
 drivers/misc/sgi-gru/grufile.c                     |    2 +-
 drivers/mmc/host/s3cmci.c                          |    2 +-
 drivers/mtd/devices/slram.c                        |    2 +-
 drivers/mtd/nand/diskonchip.c                      |    2 +-
 drivers/mtd/nand/nand_ecc.c                        |    2 +-
 drivers/mtd/nand/s3c2410.c                         |    2 +-
 drivers/net/82596.c                                |    2 +-
 drivers/net/amd8111e.c                             |    7 ++-
 drivers/net/appletalk/cops.c                       |    2 +-
 drivers/net/ariadne.h                              |    2 +-
 drivers/net/atl1c/atl1c_main.c                     |    2 +-
 drivers/net/benet/be_cmds.h                        |    2 +-
 drivers/net/benet/be_main.c                        |    2 +-
 drivers/net/bnx2x_reg.h                            |    2 +-
 drivers/net/cxgb3/sge.c                            |    2 +-
 drivers/net/e1000e/82571.c                         |    4 +-
 drivers/net/e1000e/lib.c                           |    2 +-
 drivers/net/ehea/ehea_ethtool.c                    |    4 +-
 drivers/net/hamradio/baycom_ser_fdx.c              |    2 +-
 drivers/net/iseries_veth.c                         |    2 +-
 drivers/net/lasi_82596.c                           |    2 +-
 drivers/net/lib82596.c                             |    2 +-
 drivers/net/mlx4/en_rx.c                           |    2 +-
 drivers/net/mlx4/en_tx.c                           |    2 +-
 drivers/net/mlx4/mlx4_en.h                         |    2 +-
 drivers/net/ps3_gelic_net.c                        |    2 +-
 drivers/net/sfc/falcon.c                           |    2 +-
 drivers/net/sis900.c                               |    4 +-
 drivers/net/skfp/h/smc.h                           |    8 +-
 drivers/net/skfp/skfddi.c                          |    2 +-
 drivers/net/smsc911x.c                             |    2 +-
 drivers/net/smsc911x.h                             |    2 +-
 drivers/net/spider_net.c                           |    2 +-
 drivers/net/stmmac/gmac.c                          |    2 +-
 drivers/net/stmmac/gmac.h                          |    4 +-
 drivers/net/tokenring/smctr.c                      |    2 +-
 drivers/net/ucc_geth.c                             |    2 +-
 drivers/net/ucc_geth.h                             |   20 +++---
 drivers/net/usb/smsc95xx.c                         |    2 +-
 drivers/net/wan/lmc/lmc_main.c                     |    2 +-
 drivers/net/wimax/i2400m/rx.c                      |    2 +-
 drivers/net/wireless/ath/ath5k/phy.c               |    6 +-
 drivers/net/wireless/ath/ath9k/rc.c                |    2 +-
 drivers/net/wireless/ipw2x00/ipw2100.c             |    6 +-
 drivers/net/wireless/ipw2x00/ipw2200.c             |    8 +-
 drivers/net/wireless/ipw2x00/libipw_module.c       |    2 +-
 drivers/net/wireless/iwmc3200wifi/hal.c            |    2 +-
 drivers/net/wireless/iwmc3200wifi/rx.c             |    2 +-
 drivers/net/wireless/libertas/if_sdio.c            |    2 +-
 drivers/net/wireless/prism54/isl_ioctl.c           |    4 +-
 drivers/net/wireless/rt2x00/rt2400pci.h            |    2 +-
 drivers/net/wireless/rt2x00/rt2500pci.h            |    2 +-
 drivers/net/wireless/rt2x00/rt2500usb.h            |    2 +-
 drivers/net/wireless/rt2x00/rt2800usb.h            |    2 +-
 drivers/net/wireless/rt2x00/rt2x00usb.c            |    2 +-
 drivers/net/wireless/rt2x00/rt61pci.h              |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.h              |    2 +-
 drivers/net/wireless/wavelan_cs.c                  |    2 +-
 drivers/net/wireless/zd1211rw/zd_mac.c             |    2 +-
 drivers/parisc/ccio-dma.c                          |    2 +-
 drivers/platform/x86/thinkpad_acpi.c               |    2 +-
 drivers/pnp/pnpbios/rsparser.c                     |    8 +-
 drivers/ps3/ps3-sys-manager.c                      |    2 +-
 drivers/rtc/rtc-v3020.c                            |    2 +-
 drivers/s390/char/fs3270.c                         |    2 +-
 drivers/s390/cio/chp.c                             |    2 +-
 drivers/s390/cio/cmf.c                             |    2 +-
 drivers/sbus/char/envctrl.c                        |    4 +-
 drivers/scsi/53c700.c                              |    2 +-
 drivers/scsi/aacraid/aacraid.h                     |    6 +-
 drivers/scsi/aacraid/comminit.c                    |    2 +-
 drivers/scsi/aic7xxx/aic79xx.seq                   |    2 +-
 drivers/scsi/aic7xxx/aic79xx_core.c                |    2 +-
 drivers/scsi/aic7xxx/aic7xxx_core.c                |    2 +-
 drivers/scsi/bfa/include/defs/bfa_defs_pport.h     |    2 +-
 drivers/scsi/bfa/include/defs/bfa_defs_tsensor.h   |    2 +-
 drivers/scsi/hptiop.c                              |    2 +-
 drivers/scsi/libfc/fc_lport.c                      |    2 +-
 drivers/scsi/libiscsi_tcp.c                        |    2 +-
 drivers/scsi/lpfc/lpfc_attr.c                      |    4 +-
 drivers/scsi/lpfc/lpfc_els.c                       |    4 +-
 drivers/scsi/lpfc/lpfc_init.c                      |   62 ++++++++++----------
 drivers/scsi/lpfc/lpfc_sli.c                       |   10 ++--
 drivers/scsi/megaraid.h                            |    2 +-
 drivers/scsi/megaraid/mbox_defs.h                  |    2 +-
 drivers/scsi/megaraid/megaraid_mbox.c              |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c               |    2 +-
 drivers/scsi/ncr53c8xx.c                           |    2 +-
 drivers/scsi/pmcraid.c                             |    6 +-
 drivers/scsi/pmcraid.h                             |    6 +-
 drivers/scsi/scsi_netlink.c                        |    2 +-
 drivers/scsi/scsi_transport_sas.c                  |    6 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c                |    2 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.c                |    2 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.h                |    2 +-
 drivers/serial/8250_pnp.c                          |    4 +-
 drivers/serial/pmac_zilog.h                        |    2 +-
 drivers/serial/ucc_uart.c                          |    2 +-
 drivers/telephony/ixj.c                            |    4 +-
 drivers/usb/atm/ueagle-atm.c                       |    2 +-
 drivers/usb/class/usbtmc.c                         |    2 +-
 drivers/usb/core/message.c                         |    2 +-
 drivers/usb/gadget/f_acm.c                         |    2 +-
 drivers/usb/gadget/pxa27x_udc.c                    |    2 +-
 drivers/usb/host/fhci-sched.c                      |    2 +-
 drivers/usb/wusbcore/crypto.c                      |    2 +-
 drivers/usb/wusbcore/wa-xfer.c                     |    4 +-
 drivers/uwb/i1480/dfu/usb.c                        |    2 +-
 drivers/uwb/wlp/txrx.c                             |    2 +-
 drivers/video/aty/atyfb_base.c                     |    4 +-
 drivers/video/backlight/atmel-pwm-bl.c             |    2 +-
 drivers/video/backlight/tosa_lcd.c                 |    2 +-
 drivers/video/console/sticore.c                    |    2 +-
 drivers/video/gbefb.c                              |    2 +-
 drivers/video/stifb.c                              |    4 +-
 drivers/video/tdfxfb.c                             |    2 +-
 drivers/video/via/dvi.c                            |    4 +-
 drivers/video/vt8623fb.c                           |    2 +-
 drivers/watchdog/coh901327_wdt.c                   |    2 +-
 drivers/watchdog/machzwd.c                         |    2 +-
 drivers/watchdog/wdrtas.c                          |    6 +-
 fs/binfmt_elf.c                                    |    2 +-
 fs/bio.c                                           |    2 +-
 fs/btrfs/extent_map.c                              |    2 +-
 fs/cifs/README                                     |    2 +-
 fs/cifs/cifsglob.h                                 |    2 +-
 fs/cifs/inode.c                                    |    4 +-
 fs/cifs/smbdes.c                                   |    2 +-
 fs/dlm/plock.c                                     |    2 +-
 fs/ext4/inode.c                                    |    6 +-
 fs/ext4/mballoc.c                                  |    2 +-
 fs/jffs2/compr.c                                   |    2 +-
 fs/jffs2/readinode.c                               |    2 +-
 fs/jffs2/xattr.c                                   |    2 +-
 fs/jfs/jfs_dmap.c                                  |    4 +-
 fs/ncpfs/ioctl.c                                   |    2 +-
 fs/ntfs/compress.c                                 |    2 +-
 fs/ntfs/file.c                                     |    4 +-
 fs/ntfs/logfile.c                                  |    2 +-
 fs/ocfs2/alloc.c                                   |    2 +-
 fs/ocfs2/dlm/dlmmaster.c                           |    2 +-
 fs/ocfs2/dlmglue.c                                 |    2 +-
 fs/ocfs2/journal.c                                 |    2 +-
 fs/ocfs2/refcounttree.c                            |    2 +-
 fs/omfs/bitmap.c                                   |    2 +-
 fs/ubifs/recovery.c                                |    2 +-
 fs/xfs/quota/xfs_dquot.h                           |    2 +-
 include/asm-generic/memory_model.h                 |    2 +-
 include/asm-generic/unistd.h                       |    2 +-
 include/linux/chio.h                               |    2 +-
 include/linux/mfd/ezx-pcap.h                       |    4 +-
 include/linux/pktcdvd.h                            |    2 +-
 include/linux/serial_reg.h                         |    8 +-
 include/linux/videodev2.h                          |    2 +-
 include/net/sctp/structs.h                         |    2 +-
 include/net/tcp.h                                  |    2 +-
 include/net/wimax.h                                |    2 +-
 include/sound/wm8993.h                             |    2 +-
 kernel/perf_event.c                                |    4 +-
 lib/Kconfig.debug                                  |    2 +-
 lib/decompress_bunzip2.c                           |    2 +-
 lib/dma-debug.c                                    |    2 +-
 lib/swiotlb.c                                      |    2 +-
 mm/filemap.c                                       |    2 +-
 mm/memcontrol.c                                    |    4 +-
 mm/memory-failure.c                                |    2 +-
 net/ipv4/netfilter/ipt_ECN.c                       |    2 +-
 net/irda/irlap.c                                   |   14 ++--
 net/irda/irlap_event.c                             |    2 +-
 net/irda/irlmp.c                                   |    4 +-
 net/mac80211/mesh_pathtbl.c                        |    4 +-
 net/netlabel/netlabel_domainhash.c                 |    2 +-
 net/sctp/sm_sideeffect.c                           |    2 +-
 net/sunrpc/xprtrdma/svc_rdma_sendto.c              |    2 +-
 net/wimax/op-reset.c                               |    2 +-
 scripts/kconfig/mconf.c                            |    2 +-
 security/selinux/netlabel.c                        |    2 +-
 security/selinux/ss/services.c                     |    2 +-
 sound/Kconfig                                      |    2 +-
 sound/isa/cs423x/cs4236.c                          |    2 +-
 sound/isa/opti9xx/miro.c                           |    2 +-
 sound/isa/opti9xx/opti92x-ad1848.c                 |    2 +-
 sound/oss/dmasound/dmasound_paula.c                |    2 +-
 sound/pci/ca0106/ca0106_proc.c                     |    2 +-
 sound/pci/cs46xx/imgs/cwcdma.asp                   |    9 ++-
 sound/pci/emu10k1/emu10k1x.c                       |    2 +-
 sound/pci/hda/patch_cmedia.c                       |    2 +-
 sound/pci/hda/patch_realtek.c                      |    2 +-
 sound/pci/rme9652/hdspm.c                          |    4 +-
 sound/soc/codecs/uda134x.c                         |    4 +-
 sound/soc/codecs/wm8903.c                          |    6 +-
 sound/soc/codecs/wm8993.c                          |    4 +-
 sound/soc/s3c24xx/s3c24xx_simtec.c                 |    2 +-
 sound/soc/s6000/s6000-pcm.c                        |    2 +-
 sound/sound_core.c                                 |    2 +-
 351 files changed, 523 insertions(+), 515 deletions(-)

diff --git a/Documentation/ABI/testing/procfs-diskstats b/Documentation/ABI/testing/procfs-diskstats
index 9923390..f91a973 100644
--- a/Documentation/ABI/testing/procfs-diskstats
+++ b/Documentation/ABI/testing/procfs-diskstats
@@ -8,7 +8,7 @@ Description:
 		 1 - major number
 		 2 - minor mumber
 		 3 - device name
-		 4 - reads completed succesfully
+		 4 - reads completed successfully
 		 5 - reads merged
 		 6 - sectors read
 		 7 - time spent reading (ms)
diff --git a/Documentation/ABI/testing/sysfs-block b/Documentation/ABI/testing/sysfs-block
index 5f3beda..d2f9033 100644
--- a/Documentation/ABI/testing/sysfs-block
+++ b/Documentation/ABI/testing/sysfs-block
@@ -4,7 +4,7 @@ Contact:	Jerome Marchand <jmarchan@redhat.com>
 Description:
 		The /sys/block/<disk>/stat files displays the I/O
 		statistics of disk <disk>. They contain 11 fields:
-		 1 - reads completed succesfully
+		 1 - reads completed successfully
 		 2 - reads merged
 		 3 - sectors read
 		 4 - time spent reading (ms)
diff --git a/Documentation/DocBook/mtdnand.tmpl b/Documentation/DocBook/mtdnand.tmpl
index df0d089..f508a8a 100644
--- a/Documentation/DocBook/mtdnand.tmpl
+++ b/Documentation/DocBook/mtdnand.tmpl
@@ -362,7 +362,7 @@ module_exit(board_cleanup);
 	<sect1 id="Multiple_chip_control">
 		<title>Multiple chip control</title>
 		<para>
-			The nand driver can control chip arrays. Therefor the
+			The nand driver can control chip arrays. Therefore the
 			board driver must provide an own select_chip function. This
 			function must (de)select the requested chip.
 			The function pointer in the nand_chip structure must
diff --git a/Documentation/DocBook/v4l/videodev2.h.xml b/Documentation/DocBook/v4l/videodev2.h.xml
index 9700206..26303e5 100644
--- a/Documentation/DocBook/v4l/videodev2.h.xml
+++ b/Documentation/DocBook/v4l/videodev2.h.xml
@@ -492,7 +492,7 @@ struct <link linkend="v4l2-jpegcompression">v4l2_jpegcompression</link> {
                                  * you do, leave them untouched.
                                  * Inluding less markers will make the
                                  * resulting code smaller, but there will
-                                 * be fewer aplications which can read it.
+                                 * be fewer applications which can read it.
                                  * The presence of the APP and COM marker
                                  * is influenced by APP_len and COM_len
                                  * ONLY, not by this property! */
diff --git a/Documentation/DocBook/writing-an-alsa-driver.tmpl b/Documentation/DocBook/writing-an-alsa-driver.tmpl
index 7a2e0e9..0d0f7b4 100644
--- a/Documentation/DocBook/writing-an-alsa-driver.tmpl
+++ b/Documentation/DocBook/writing-an-alsa-driver.tmpl
@@ -5318,7 +5318,7 @@ struct _snd_pcm_runtime {
       pages of the given size and map them onto the virtually contiguous
       memory.  The virtual pointer is addressed in runtime-&gt;dma_area.
       The physical address (runtime-&gt;dma_addr) is set to zero,
-      because the buffer is physically non-contigous.
+      because the buffer is physically non-contiguous.
       The physical address table is set up in sgbuf-&gt;table.
       You can get the physical address at a certain offset via
       <function>snd_pcm_sgbuf_get_addr()</function>. 
diff --git a/Documentation/dvb/README.dvb-usb b/Documentation/dvb/README.dvb-usb
index bf2a9cd..c8238e4 100644
--- a/Documentation/dvb/README.dvb-usb
+++ b/Documentation/dvb/README.dvb-usb
@@ -85,7 +85,7 @@ http://www.linuxtv.org/wiki/index.php/DVB_USB
 	     - moved transfer control (pid filter, fifo control) from usb driver to frontend, it seems
 	       better settled there (added xfer_ops-struct)
 	     - created a common files for frontends (mc/p/mb)
-  2004-09-28 - added support for a new device (Unkown, vendor ID is Hyper-Paltek)
+  2004-09-28 - added support for a new device (Unknown, vendor ID is Hyper-Paltek)
   2004-09-20 - added support for a new device (Compro DVB-U2000), thanks
 	       to Amaury Demol for reporting
 	     - changed usb TS transfer method (several urbs, stopping transfer
diff --git a/Documentation/lguest/lguest.c b/Documentation/lguest/lguest.c
index 098de5b..4220851 100644
--- a/Documentation/lguest/lguest.c
+++ b/Documentation/lguest/lguest.c
@@ -304,7 +304,7 @@ static void *map_zeroed_pages(unsigned int num)
 	addr = mmap(NULL, getpagesize() * num,
 		    PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE, fd, 0);
 	if (addr == MAP_FAILED)
-		err(1, "Mmaping %u pages of /dev/zero", num);
+		err(1, "Mmapping %u pages of /dev/zero", num);
 
 	/*
 	 * One neat mmap feature is that you can close the fd, and it
diff --git a/Documentation/scsi/ChangeLog.megaraid_sas b/Documentation/scsi/ChangeLog.megaraid_sas
index c851ef4..84524e0 100644
--- a/Documentation/scsi/ChangeLog.megaraid_sas
+++ b/Documentation/scsi/ChangeLog.megaraid_sas
@@ -185,7 +185,7 @@ ii.	FW enables WCE bit in Mode Sense cmd for drives that are configured
 	Disks are exposed with WCE=1. User is advised to enable Write Back
 	mode only when the controller has battery backup. At this time
 	Synhronize cache is not supported by the FW. Driver will short-cycle
-	the cmd and return sucess without sending down to FW.
+	the cmd and return success without sending down to FW.
 
 1 Release Date    : Sun Jan. 14 11:21:32 PDT 2007 -
 		 Sumant Patro <Sumant.Patro@lsil.com>/Bo Yang
diff --git a/Documentation/spi/spi-summary b/Documentation/spi/spi-summary
index deab51d..4884cb3 100644
--- a/Documentation/spi/spi-summary
+++ b/Documentation/spi/spi-summary
@@ -538,7 +538,7 @@ SPI MESSAGE QUEUE
 The bulk of the driver will be managing the I/O queue fed by transfer().
 
 That queue could be purely conceptual.  For example, a driver used only
-for low-frequency sensor acess might be fine using synchronous PIO.
+for low-frequency sensor access might be fine using synchronous PIO.
 
 But the queue will probably be very real, using message->queue, PIO,
 often DMA (especially if the root filesystem is in SPI flash), and
diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
index a6e360d..fc5790d 100644
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -370,7 +370,7 @@ The default is 1 percent.
 mmap_min_addr
 
 This file indicates the amount of address space  which a user process will
-be restricted from mmaping.  Since kernel null dereference bugs could
+be restricted from mmapping.  Since kernel null dereference bugs could
 accidentally operate based on the information in the first couple of pages
 of memory userspace processes should not be allowed to write to them.  By
 default this value is set to 0 and no protections will be enforced by the
diff --git a/Documentation/video4linux/gspca.txt b/Documentation/video4linux/gspca.txt
index 3f61825..6b29555 100644
--- a/Documentation/video4linux/gspca.txt
+++ b/Documentation/video4linux/gspca.txt
@@ -6,7 +6,7 @@ The modules are:
 
 xxxx		vend:prod
 ----
-spca501		0000:0000	MystFromOri Unknow Camera
+spca501		0000:0000	MystFromOri Unknown Camera
 m5602		0402:5602	ALi Video Camera Controller
 spca501		040a:0002	Kodak DVC-325
 spca500		040a:0300	Kodak EZ200
diff --git a/Documentation/vm/page-types.c b/Documentation/vm/page-types.c
index 3ec4f2a..aa7f4d0 100644
--- a/Documentation/vm/page-types.c
+++ b/Documentation/vm/page-types.c
@@ -301,7 +301,7 @@ static char *page_flag_name(uint64_t flags)
 		present = (flags >> i) & 1;
 		if (!page_flag_names[i]) {
 			if (present)
-				fatal("unkown flag bit %d\n", i);
+				fatal("unknown flag bit %d\n", i);
 			continue;
 		}
 		buf[j++] = present ? page_flag_names[i][0] : '_';
diff --git a/arch/alpha/mm/numa.c b/arch/alpha/mm/numa.c
index 10b4035..7b2c56d 100644
--- a/arch/alpha/mm/numa.c
+++ b/arch/alpha/mm/numa.c
@@ -197,7 +197,7 @@ setup_memory_node(int nid, void *kernel_end)
 	}
 
 	if (bootmap_start == -1)
-		panic("couldn't find a contigous place for the bootmap");
+		panic("couldn't find a contiguous place for the bootmap");
 
 	/* Allocate the bootmap and mark the whole MM as reserved.  */
 	bootmap_size = init_bootmem_node(NODE_DATA(nid), bootmap_start,
diff --git a/arch/arm/common/scoop.c b/arch/arm/common/scoop.c
index 7713a08..37bda5f 100644
--- a/arch/arm/common/scoop.c
+++ b/arch/arm/common/scoop.c
@@ -82,7 +82,7 @@ static int scoop_gpio_get(struct gpio_chip *chip, unsigned offset)
 {
 	struct scoop_dev *sdev = container_of(chip, struct scoop_dev, gpio);
 
-	/* XXX: I'm usure,  but it seems so */
+	/* XXX: I'm unsure, but it seems so */
 	return ioread16(sdev->base + SCOOP_GPRR) & (1 << (offset + 1));
 }
 
diff --git a/arch/arm/mach-bcmring/include/mach/csp/dmacHw_priv.h b/arch/arm/mach-bcmring/include/mach/csp/dmacHw_priv.h
index 375066a..cbf334d 100644
--- a/arch/arm/mach-bcmring/include/mach/csp/dmacHw_priv.h
+++ b/arch/arm/mach-bcmring/include/mach/csp/dmacHw_priv.h
@@ -83,7 +83,7 @@ typedef struct {
 *  @brief   Get next available transaction width
 *
 *
-*  @return  On sucess  : Next avail able transaction width
+*  @return  On success  : Next available transaction width
 *           On failure : dmacHw_TRANSACTION_WIDTH_8
 *
 *  @note
diff --git a/arch/arm/mach-bcmring/include/mach/dma.h b/arch/arm/mach-bcmring/include/mach/dma.h
index 847980c..1f2c531 100644
--- a/arch/arm/mach-bcmring/include/mach/dma.h
+++ b/arch/arm/mach-bcmring/include/mach/dma.h
@@ -651,7 +651,7 @@ int dma_map_add_region(DMA_MemMap_t *memMap,	/* Stores state information about t
 /**
 *   Creates a descriptor ring from a memory mapping.
 *
-*   @return 0 on sucess, error code otherwise.
+*   @return 0 on success, error code otherwise.
 */
 /****************************************************************************/
 
diff --git a/arch/arm/mach-lh7a40x/include/mach/hardware.h b/arch/arm/mach-lh7a40x/include/mach/hardware.h
index 48e827d..59d2ace 100644
--- a/arch/arm/mach-lh7a40x/include/mach/hardware.h
+++ b/arch/arm/mach-lh7a40x/include/mach/hardware.h
@@ -31,7 +31,7 @@
 /*
  * This __REG() version gives the same results as the one above,  except
  * that we are fooling gcc somehow so it generates far better and smaller
- * assembly code for access to contigous registers.  It's a shame that gcc
+ * assembly code for access to contiguous registers.  It's a shame that gcc
  * doesn't guess this by itself.
  */
 #include <asm/types.h>
diff --git a/arch/arm/mach-orion5x/pci.c b/arch/arm/mach-orion5x/pci.c
index 36dc541..bdf96eb 100644
--- a/arch/arm/mach-orion5x/pci.c
+++ b/arch/arm/mach-orion5x/pci.c
@@ -463,7 +463,7 @@ static void __init orion5x_setup_pci_wins(struct mbus_dram_target_info *dram)
 	writel(win_enable, PCI_BAR_ENABLE);
 
 	/*
-	 * Disable automatic update of address remaping when writing to BARs.
+	 * Disable automatic update of address remapping when writing to BARs.
 	 */
 	orion5x_setbits(PCI_ADDR_DECODE_CTRL, 1);
 }
diff --git a/arch/arm/mach-pxa/include/mach/palmld.h b/arch/arm/mach-pxa/include/mach/palmld.h
index 8721b80..ae536e8 100644
--- a/arch/arm/mach-pxa/include/mach/palmld.h
+++ b/arch/arm/mach-pxa/include/mach/palmld.h
@@ -91,7 +91,7 @@
 /* BATTERY */
 #define PALMLD_BAT_MAX_VOLTAGE		4000	/* 4.00V maximum voltage */
 #define PALMLD_BAT_MIN_VOLTAGE		3550	/* 3.55V critical voltage */
-#define PALMLD_BAT_MAX_CURRENT		0	/* unknokn */
+#define PALMLD_BAT_MAX_CURRENT		0	/* unknown */
 #define PALMLD_BAT_MIN_CURRENT		0	/* unknown */
 #define PALMLD_BAT_MAX_CHARGE		1	/* unknown */
 #define PALMLD_BAT_MIN_CHARGE		1	/* unknown */
diff --git a/arch/arm/mach-pxa/include/mach/palmt5.h b/arch/arm/mach-pxa/include/mach/palmt5.h
index d15662a..6baf746 100644
--- a/arch/arm/mach-pxa/include/mach/palmt5.h
+++ b/arch/arm/mach-pxa/include/mach/palmt5.h
@@ -66,7 +66,7 @@
 /* BATTERY */
 #define PALMT5_BAT_MAX_VOLTAGE		4000	/* 4.00v current voltage */
 #define PALMT5_BAT_MIN_VOLTAGE		3550	/* 3.55v critical voltage */
-#define PALMT5_BAT_MAX_CURRENT		0	/* unknokn */
+#define PALMT5_BAT_MAX_CURRENT		0	/* unknown */
 #define PALMT5_BAT_MIN_CURRENT		0	/* unknown */
 #define PALMT5_BAT_MAX_CHARGE		1	/* unknown */
 #define PALMT5_BAT_MIN_CHARGE		1	/* unknown */
diff --git a/arch/arm/mach-pxa/include/mach/palmtc.h b/arch/arm/mach-pxa/include/mach/palmtc.h
index 3dc9b07..3f9dd3f 100644
--- a/arch/arm/mach-pxa/include/mach/palmtc.h
+++ b/arch/arm/mach-pxa/include/mach/palmtc.h
@@ -68,7 +68,7 @@
 /* BATTERY */
 #define PALMTC_BAT_MAX_VOLTAGE		4000	/* 4.00V maximum voltage */
 #define PALMTC_BAT_MIN_VOLTAGE		3550	/* 3.55V critical voltage */
-#define PALMTC_BAT_MAX_CURRENT		0	/* unknokn */
+#define PALMTC_BAT_MAX_CURRENT		0	/* unknown */
 #define PALMTC_BAT_MIN_CURRENT		0	/* unknown */
 #define PALMTC_BAT_MAX_CHARGE		1	/* unknown */
 #define PALMTC_BAT_MIN_CHARGE		1	/* unknown */
diff --git a/arch/arm/mach-pxa/include/mach/palmte2.h b/arch/arm/mach-pxa/include/mach/palmte2.h
index 1236134..f89e989 100644
--- a/arch/arm/mach-pxa/include/mach/palmte2.h
+++ b/arch/arm/mach-pxa/include/mach/palmte2.h
@@ -59,7 +59,7 @@
 /* BATTERY */
 #define PALMTE2_BAT_MAX_VOLTAGE		4000	/* 4.00v current voltage */
 #define PALMTE2_BAT_MIN_VOLTAGE		3550	/* 3.55v critical voltage */
-#define PALMTE2_BAT_MAX_CURRENT		0	/* unknokn */
+#define PALMTE2_BAT_MAX_CURRENT		0	/* unknown */
 #define PALMTE2_BAT_MIN_CURRENT		0	/* unknown */
 #define PALMTE2_BAT_MAX_CHARGE		1	/* unknown */
 #define PALMTE2_BAT_MIN_CHARGE		1	/* unknown */
diff --git a/arch/arm/mach-pxa/include/mach/palmtx.h b/arch/arm/mach-pxa/include/mach/palmtx.h
index 1be0db6..10abc4f 100644
--- a/arch/arm/mach-pxa/include/mach/palmtx.h
+++ b/arch/arm/mach-pxa/include/mach/palmtx.h
@@ -94,7 +94,7 @@
 /* BATTERY */
 #define PALMTX_BAT_MAX_VOLTAGE		4000	/* 4.00v current voltage */
 #define PALMTX_BAT_MIN_VOLTAGE		3550	/* 3.55v critical voltage */
-#define PALMTX_BAT_MAX_CURRENT		0	/* unknokn */
+#define PALMTX_BAT_MAX_CURRENT		0	/* unknown */
 #define PALMTX_BAT_MIN_CURRENT		0	/* unknown */
 #define PALMTX_BAT_MAX_CHARGE		1	/* unknown */
 #define PALMTX_BAT_MIN_CHARGE		1	/* unknown */
diff --git a/arch/arm/mach-pxa/include/mach/palmz72.h b/arch/arm/mach-pxa/include/mach/palmz72.h
index 2806ef6..2bbcf70 100644
--- a/arch/arm/mach-pxa/include/mach/palmz72.h
+++ b/arch/arm/mach-pxa/include/mach/palmz72.h
@@ -49,7 +49,7 @@
 /* Battery */
 #define PALMZ72_BAT_MAX_VOLTAGE		4000	/* 4.00v current voltage */
 #define PALMZ72_BAT_MIN_VOLTAGE		3550	/* 3.55v critical voltage */
-#define PALMZ72_BAT_MAX_CURRENT		0	/* unknokn */
+#define PALMZ72_BAT_MAX_CURRENT		0	/* unknown */
 #define PALMZ72_BAT_MIN_CURRENT		0	/* unknown */
 #define PALMZ72_BAT_MAX_CHARGE		1	/* unknown */
 #define PALMZ72_BAT_MIN_CHARGE		1	/* unknown */
diff --git a/arch/arm/mach-s3c6400/setup-sdhci.c b/arch/arm/mach-s3c6400/setup-sdhci.c
index b93dafb..1039937 100644
--- a/arch/arm/mach-s3c6400/setup-sdhci.c
+++ b/arch/arm/mach-s3c6400/setup-sdhci.c
@@ -30,7 +30,7 @@ char *s3c6400_hsmmc_clksrcs[4] = {
 	[0] = "hsmmc",
 	[1] = "hsmmc",
 	[2] = "mmc_bus",
-	/* [3] = "48m", - note not succesfully used yet */
+	/* [3] = "48m", - note not successfully used yet */
 };
 
 void s3c6400_setup_sdhci_cfg_card(struct platform_device *dev,
diff --git a/arch/arm/mach-s3c6410/setup-sdhci.c b/arch/arm/mach-s3c6410/setup-sdhci.c
index 20666f3..816d2d9 100644
--- a/arch/arm/mach-s3c6410/setup-sdhci.c
+++ b/arch/arm/mach-s3c6410/setup-sdhci.c
@@ -30,7 +30,7 @@ char *s3c6410_hsmmc_clksrcs[4] = {
 	[0] = "hsmmc",
 	[1] = "hsmmc",
 	[2] = "mmc_bus",
-	/* [3] = "48m", - note not succesfully used yet */
+	/* [3] = "48m", - note not successfully used yet */
 };
 
 
diff --git a/arch/arm/mach-sa1100/dma.c b/arch/arm/mach-sa1100/dma.c
index cb4521a..ad66035 100644
--- a/arch/arm/mach-sa1100/dma.c
+++ b/arch/arm/mach-sa1100/dma.c
@@ -65,7 +65,7 @@ static irqreturn_t dma_irq_handler(int irq, void *dev_id)
 
 
 /**
- *	sa1100_request_dma - allocate one of the SA11x0's DMA chanels
+ *	sa1100_request_dma - allocate one of the SA11x0's DMA channels
  *	@device: The SA11x0 peripheral targeted by this request
  *	@device_id: An ascii name for the claiming device
  *	@callback: Function to be called when the DMA completes
diff --git a/arch/arm/plat-mxc/include/mach/iomux-mx3.h b/arch/arm/plat-mxc/include/mach/iomux-mx3.h
index 446f867..0c7802b 100644
--- a/arch/arm/plat-mxc/include/mach/iomux-mx3.h
+++ b/arch/arm/plat-mxc/include/mach/iomux-mx3.h
@@ -112,7 +112,7 @@ enum iomux_gp_func {
  * setups a single pin:
  * 	- reserves the pin so that it is not claimed by another driver
  * 	- setups the iomux according to the configuration
- * 	- if the pin is configured as a GPIO, we claim it throug kernel gpiolib
+ * 	- if the pin is configured as a GPIO, we claim it through kernel gpiolib
  */
 int mxc_iomux_alloc_pin(const unsigned int pin, const char *label);
 /*
diff --git a/arch/arm/plat-mxc/include/mach/iomux-mxc91231.h b/arch/arm/plat-mxc/include/mach/iomux-mxc91231.h
index 9f13061..3887f3f 100644
--- a/arch/arm/plat-mxc/include/mach/iomux-mxc91231.h
+++ b/arch/arm/plat-mxc/include/mach/iomux-mxc91231.h
@@ -48,7 +48,7 @@
  * setups a single pin:
  * 	- reserves the pin so that it is not claimed by another driver
  * 	- setups the iomux according to the configuration
- * 	- if the pin is configured as a GPIO, we claim it throug kernel gpiolib
+ * 	- if the pin is configured as a GPIO, we claim it through kernel gpiolib
  */
 int mxc_iomux_alloc_pin(const unsigned int pin_mode, const char *label);
 /*
diff --git a/arch/arm/plat-mxc/pwm.c b/arch/arm/plat-mxc/pwm.c
index 5cdbd60..4ff6dfe 100644
--- a/arch/arm/plat-mxc/pwm.c
+++ b/arch/arm/plat-mxc/pwm.c
@@ -94,7 +94,7 @@ int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
 		 * register to follow the ratio of duty_ns vs. period_ns
 		 * accordingly.
 		 *
-		 * This is good enought for programming the brightness of
+		 * This is good enough for programming the brightness of
 		 * the LCD backlight.
 		 *
 		 * The real implementation would divide PERCLK[0] first by
diff --git a/arch/arm/plat-omap/dma.c b/arch/arm/plat-omap/dma.c
index 68eaae3..b5d786d 100644
--- a/arch/arm/plat-omap/dma.c
+++ b/arch/arm/plat-omap/dma.c
@@ -1246,7 +1246,7 @@ static void create_dma_lch_chain(int lch_head, int lch_queue)
  * 					      OMAP_DMA_DYNAMIC_CHAIN
  * @params - Channel parameters
  *
- * @return - Succes : 0
+ * @return - Success : 0
  * 	     Failure: -EINVAL/-ENOMEM
  */
 int omap_request_dma_chain(int dev_id, const char *dev_name,
diff --git a/arch/arm/plat-omap/include/mach/omap16xx.h b/arch/arm/plat-omap/include/mach/omap16xx.h
index 0e69b50..7560b4d 100644
--- a/arch/arm/plat-omap/include/mach/omap16xx.h
+++ b/arch/arm/plat-omap/include/mach/omap16xx.h
@@ -124,7 +124,7 @@
 #define TIPB_SWITCH_BASE		 (0xfffbc800)
 #define OMAP16XX_MMCSD2_SSW_MPU_CONF	(TIPB_SWITCH_BASE + 0x160)
 
-/* UART3 Registers Maping through MPU bus */
+/* UART3 Registers Mapping through MPU bus */
 #define UART3_RHR               (OMAP_UART3_BASE + 0)
 #define UART3_THR               (OMAP_UART3_BASE + 0)
 #define UART3_DLL               (OMAP_UART3_BASE + 0)
diff --git a/arch/arm/plat-s3c24xx/include/plat/map.h b/arch/arm/plat-s3c24xx/include/plat/map.h
index c4d1334..bd534d3 100644
--- a/arch/arm/plat-s3c24xx/include/plat/map.h
+++ b/arch/arm/plat-s3c24xx/include/plat/map.h
@@ -64,7 +64,7 @@
 /* the calculation for the VA of this must ensure that
  * it is the same distance apart from the UART in the
  * phsyical address space, as the initial mapping for the IO
- * is done as a 1:1 maping. This puts it (currently) at
+ * is done as a 1:1 mapping. This puts it (currently) at
  * 0xFA800000, which is not in the way of any current mapping
  * by the base system.
 */
diff --git a/arch/avr32/boards/hammerhead/Kconfig b/arch/avr32/boards/hammerhead/Kconfig
index fda2331..5c13d78 100644
--- a/arch/avr32/boards/hammerhead/Kconfig
+++ b/arch/avr32/boards/hammerhead/Kconfig
@@ -24,7 +24,7 @@ config BOARD_HAMMERHEAD_SND
 	bool "Atmel AC97 Sound support"
 	help
 	  This enables Sound support for the Hammerhead board. You may
-	  also go trough the ALSA settings to get it working.
+	  also go through the ALSA settings to get it working.
 
 	  Choose 'Y' here if you have ordered a Corona daugther board and
 	  want to make your board funky.
diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index 6b7325d..78cb3d3 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -619,7 +619,7 @@ asmlinkage notrace void trap_c(struct pt_regs *fp)
 
 /*
  * Similar to get_user, do some address checking, then dereference
- * Return true on sucess, false on bad address
+ * Return true on success, false on bad address
  */
 static bool get_instruction(unsigned short *val, unsigned short *address)
 {
diff --git a/arch/blackfin/mach-bf518/include/mach/defBF51x_base.h b/arch/blackfin/mach-bf518/include/mach/defBF51x_base.h
index e06f411..f9fd2b2 100644
--- a/arch/blackfin/mach-bf518/include/mach/defBF51x_base.h
+++ b/arch/blackfin/mach-bf518/include/mach/defBF51x_base.h
@@ -542,7 +542,7 @@
 #define HMDMA0_CONTROL		0xFFC03300	/* Handshake MDMA0 Control Register					*/
 #define HMDMA0_ECINIT		0xFFC03304	/* HMDMA0 Initial Edge Count Register				*/
 #define HMDMA0_BCINIT		0xFFC03308	/* HMDMA0 Initial Block Count Register				*/
-#define HMDMA0_ECURGENT		0xFFC0330C	/* HMDMA0 Urgent Edge Count Threshhold Register		*/
+#define HMDMA0_ECURGENT		0xFFC0330C	/* HMDMA0 Urgent Edge Count Threshold Register		*/
 #define HMDMA0_ECOVERFLOW	0xFFC03310	/* HMDMA0 Edge Count Overflow Interrupt Register	*/
 #define HMDMA0_ECOUNT		0xFFC03314	/* HMDMA0 Current Edge Count Register				*/
 #define HMDMA0_BCOUNT		0xFFC03318	/* HMDMA0 Current Block Count Register				*/
@@ -550,7 +550,7 @@
 #define HMDMA1_CONTROL		0xFFC03340	/* Handshake MDMA1 Control Register					*/
 #define HMDMA1_ECINIT		0xFFC03344	/* HMDMA1 Initial Edge Count Register				*/
 #define HMDMA1_BCINIT		0xFFC03348	/* HMDMA1 Initial Block Count Register				*/
-#define HMDMA1_ECURGENT		0xFFC0334C	/* HMDMA1 Urgent Edge Count Threshhold Register		*/
+#define HMDMA1_ECURGENT		0xFFC0334C	/* HMDMA1 Urgent Edge Count Threshold Register		*/
 #define HMDMA1_ECOVERFLOW	0xFFC03350	/* HMDMA1 Edge Count Overflow Interrupt Register	*/
 #define HMDMA1_ECOUNT		0xFFC03354	/* HMDMA1 Current Edge Count Register				*/
 #define HMDMA1_BCOUNT		0xFFC03358	/* HMDMA1 Current Block Count Register				*/
diff --git a/arch/blackfin/mach-bf527/include/mach/defBF52x_base.h b/arch/blackfin/mach-bf527/include/mach/defBF52x_base.h
index f821700..b9dbb73 100644
--- a/arch/blackfin/mach-bf527/include/mach/defBF52x_base.h
+++ b/arch/blackfin/mach-bf527/include/mach/defBF52x_base.h
@@ -544,7 +544,7 @@
 #define HMDMA0_CONTROL		0xFFC03300	/* Handshake MDMA0 Control Register					*/
 #define HMDMA0_ECINIT		0xFFC03304	/* HMDMA0 Initial Edge Count Register				*/
 #define HMDMA0_BCINIT		0xFFC03308	/* HMDMA0 Initial Block Count Register				*/
-#define HMDMA0_ECURGENT		0xFFC0330C	/* HMDMA0 Urgent Edge Count Threshhold Register		*/
+#define HMDMA0_ECURGENT		0xFFC0330C	/* HMDMA0 Urgent Edge Count Threshold Register		*/
 #define HMDMA0_ECOVERFLOW	0xFFC03310	/* HMDMA0 Edge Count Overflow Interrupt Register	*/
 #define HMDMA0_ECOUNT		0xFFC03314	/* HMDMA0 Current Edge Count Register				*/
 #define HMDMA0_BCOUNT		0xFFC03318	/* HMDMA0 Current Block Count Register				*/
@@ -552,7 +552,7 @@
 #define HMDMA1_CONTROL		0xFFC03340	/* Handshake MDMA1 Control Register					*/
 #define HMDMA1_ECINIT		0xFFC03344	/* HMDMA1 Initial Edge Count Register				*/
 #define HMDMA1_BCINIT		0xFFC03348	/* HMDMA1 Initial Block Count Register				*/
-#define HMDMA1_ECURGENT		0xFFC0334C	/* HMDMA1 Urgent Edge Count Threshhold Register		*/
+#define HMDMA1_ECURGENT		0xFFC0334C	/* HMDMA1 Urgent Edge Count Threshold Register		*/
 #define HMDMA1_ECOVERFLOW	0xFFC03350	/* HMDMA1 Edge Count Overflow Interrupt Register	*/
 #define HMDMA1_ECOUNT		0xFFC03354	/* HMDMA1 Current Edge Count Register				*/
 #define HMDMA1_BCOUNT		0xFFC03358	/* HMDMA1 Current Block Count Register				*/
diff --git a/arch/blackfin/mach-bf537/include/mach/defBF534.h b/arch/blackfin/mach-bf537/include/mach/defBF534.h
index cebb14f..a6d20ca 100644
--- a/arch/blackfin/mach-bf537/include/mach/defBF534.h
+++ b/arch/blackfin/mach-bf537/include/mach/defBF534.h
@@ -934,7 +934,7 @@
 #define HMDMA0_CONTROL		0xFFC03300	/* Handshake MDMA0 Control Register                                     */
 #define HMDMA0_ECINIT		0xFFC03304	/* HMDMA0 Initial Edge Count Register                           */
 #define HMDMA0_BCINIT		0xFFC03308	/* HMDMA0 Initial Block Count Register                          */
-#define HMDMA0_ECURGENT		0xFFC0330C	/* HMDMA0 Urgent Edge Count Threshhold Register         */
+#define HMDMA0_ECURGENT		0xFFC0330C	/* HMDMA0 Urgent Edge Count Threshold Register         */
 #define HMDMA0_ECOVERFLOW	0xFFC03310	/* HMDMA0 Edge Count Overflow Interrupt Register        */
 #define HMDMA0_ECOUNT		0xFFC03314	/* HMDMA0 Current Edge Count Register                           */
 #define HMDMA0_BCOUNT		0xFFC03318	/* HMDMA0 Current Block Count Register                          */
@@ -942,7 +942,7 @@
 #define HMDMA1_CONTROL		0xFFC03340	/* Handshake MDMA1 Control Register                                     */
 #define HMDMA1_ECINIT		0xFFC03344	/* HMDMA1 Initial Edge Count Register                           */
 #define HMDMA1_BCINIT		0xFFC03348	/* HMDMA1 Initial Block Count Register                          */
-#define HMDMA1_ECURGENT		0xFFC0334C	/* HMDMA1 Urgent Edge Count Threshhold Register         */
+#define HMDMA1_ECURGENT		0xFFC0334C	/* HMDMA1 Urgent Edge Count Threshold Register         */
 #define HMDMA1_ECOVERFLOW	0xFFC03350	/* HMDMA1 Edge Count Overflow Interrupt Register        */
 #define HMDMA1_ECOUNT		0xFFC03354	/* HMDMA1 Current Edge Count Register                           */
 #define HMDMA1_BCOUNT		0xFFC03358	/* HMDMA1 Current Block Count Register                          */
diff --git a/arch/blackfin/mach-bf548/include/mach/defBF544.h b/arch/blackfin/mach-bf548/include/mach/defBF544.h
index dd414ae..39f588d 100644
--- a/arch/blackfin/mach-bf548/include/mach/defBF544.h
+++ b/arch/blackfin/mach-bf548/include/mach/defBF544.h
@@ -491,7 +491,7 @@
 #define                   HMDMA0_CONTROL  0xffc04500   /* Handshake MDMA0 Control Register */
 #define                    HMDMA0_ECINIT  0xffc04504   /* Handshake MDMA0 Initial Edge Count Register */
 #define                    HMDMA0_BCINIT  0xffc04508   /* Handshake MDMA0 Initial Block Count Register */
-#define                  HMDMA0_ECURGENT  0xffc0450c   /* Handshake MDMA0 Urgent Edge Count Threshhold Register */
+#define                  HMDMA0_ECURGENT  0xffc0450c   /* Handshake MDMA0 Urgent Edge Count Threshold Register */
 #define                HMDMA0_ECOVERFLOW  0xffc04510   /* Handshake MDMA0 Edge Count Overflow Interrupt Register */
 #define                    HMDMA0_ECOUNT  0xffc04514   /* Handshake MDMA0 Current Edge Count Register */
 #define                    HMDMA0_BCOUNT  0xffc04518   /* Handshake MDMA0 Current Block Count Register */
@@ -501,7 +501,7 @@
 #define                   HMDMA1_CONTROL  0xffc04540   /* Handshake MDMA1 Control Register */
 #define                    HMDMA1_ECINIT  0xffc04544   /* Handshake MDMA1 Initial Edge Count Register */
 #define                    HMDMA1_BCINIT  0xffc04548   /* Handshake MDMA1 Initial Block Count Register */
-#define                  HMDMA1_ECURGENT  0xffc0454c   /* Handshake MDMA1 Urgent Edge Count Threshhold Register */
+#define                  HMDMA1_ECURGENT  0xffc0454c   /* Handshake MDMA1 Urgent Edge Count Threshold Register */
 #define                HMDMA1_ECOVERFLOW  0xffc04550   /* Handshake MDMA1 Edge Count Overflow Interrupt Register */
 #define                    HMDMA1_ECOUNT  0xffc04554   /* Handshake MDMA1 Current Edge Count Register */
 #define                    HMDMA1_BCOUNT  0xffc04558   /* Handshake MDMA1 Current Block Count Register */
diff --git a/arch/blackfin/mach-bf548/include/mach/defBF547.h b/arch/blackfin/mach-bf548/include/mach/defBF547.h
index 5a9dbab..c4dcf30 100644
--- a/arch/blackfin/mach-bf548/include/mach/defBF547.h
+++ b/arch/blackfin/mach-bf548/include/mach/defBF547.h
@@ -470,7 +470,7 @@
 #define                   HMDMA0_CONTROL  0xffc04500   /* Handshake MDMA0 Control Register */
 #define                    HMDMA0_ECINIT  0xffc04504   /* Handshake MDMA0 Initial Edge Count Register */
 #define                    HMDMA0_BCINIT  0xffc04508   /* Handshake MDMA0 Initial Block Count Register */
-#define                  HMDMA0_ECURGENT  0xffc0450c   /* Handshake MDMA0 Urgent Edge Count Threshhold Register */
+#define                  HMDMA0_ECURGENT  0xffc0450c   /* Handshake MDMA0 Urgent Edge Count Threshold Register */
 #define                HMDMA0_ECOVERFLOW  0xffc04510   /* Handshake MDMA0 Edge Count Overflow Interrupt Register */
 #define                    HMDMA0_ECOUNT  0xffc04514   /* Handshake MDMA0 Current Edge Count Register */
 #define                    HMDMA0_BCOUNT  0xffc04518   /* Handshake MDMA0 Current Block Count Register */
@@ -480,7 +480,7 @@
 #define                   HMDMA1_CONTROL  0xffc04540   /* Handshake MDMA1 Control Register */
 #define                    HMDMA1_ECINIT  0xffc04544   /* Handshake MDMA1 Initial Edge Count Register */
 #define                    HMDMA1_BCINIT  0xffc04548   /* Handshake MDMA1 Initial Block Count Register */
-#define                  HMDMA1_ECURGENT  0xffc0454c   /* Handshake MDMA1 Urgent Edge Count Threshhold Register */
+#define                  HMDMA1_ECURGENT  0xffc0454c   /* Handshake MDMA1 Urgent Edge Count Threshold Register */
 #define                HMDMA1_ECOVERFLOW  0xffc04550   /* Handshake MDMA1 Edge Count Overflow Interrupt Register */
 #define                    HMDMA1_ECOUNT  0xffc04554   /* Handshake MDMA1 Current Edge Count Register */
 #define                    HMDMA1_BCOUNT  0xffc04558   /* Handshake MDMA1 Current Block Count Register */
diff --git a/arch/blackfin/mach-bf548/include/mach/defBF548.h b/arch/blackfin/mach-bf548/include/mach/defBF548.h
index 82cd593..a507998 100644
--- a/arch/blackfin/mach-bf548/include/mach/defBF548.h
+++ b/arch/blackfin/mach-bf548/include/mach/defBF548.h
@@ -853,7 +853,7 @@
 #define                   HMDMA0_CONTROL  0xffc04500   /* Handshake MDMA0 Control Register */
 #define                    HMDMA0_ECINIT  0xffc04504   /* Handshake MDMA0 Initial Edge Count Register */
 #define                    HMDMA0_BCINIT  0xffc04508   /* Handshake MDMA0 Initial Block Count Register */
-#define                  HMDMA0_ECURGENT  0xffc0450c   /* Handshake MDMA0 Urgent Edge Count Threshhold Register */
+#define                  HMDMA0_ECURGENT  0xffc0450c   /* Handshake MDMA0 Urgent Edge Count Threshold Register */
 #define                HMDMA0_ECOVERFLOW  0xffc04510   /* Handshake MDMA0 Edge Count Overflow Interrupt Register */
 #define                    HMDMA0_ECOUNT  0xffc04514   /* Handshake MDMA0 Current Edge Count Register */
 #define                    HMDMA0_BCOUNT  0xffc04518   /* Handshake MDMA0 Current Block Count Register */
@@ -863,7 +863,7 @@
 #define                   HMDMA1_CONTROL  0xffc04540   /* Handshake MDMA1 Control Register */
 #define                    HMDMA1_ECINIT  0xffc04544   /* Handshake MDMA1 Initial Edge Count Register */
 #define                    HMDMA1_BCINIT  0xffc04548   /* Handshake MDMA1 Initial Block Count Register */
-#define                  HMDMA1_ECURGENT  0xffc0454c   /* Handshake MDMA1 Urgent Edge Count Threshhold Register */
+#define                  HMDMA1_ECURGENT  0xffc0454c   /* Handshake MDMA1 Urgent Edge Count Threshold Register */
 #define                HMDMA1_ECOVERFLOW  0xffc04550   /* Handshake MDMA1 Edge Count Overflow Interrupt Register */
 #define                    HMDMA1_ECOUNT  0xffc04554   /* Handshake MDMA1 Current Edge Count Register */
 #define                    HMDMA1_BCOUNT  0xffc04558   /* Handshake MDMA1 Current Block Count Register */
diff --git a/arch/blackfin/mach-bf548/include/mach/defBF549.h b/arch/blackfin/mach-bf548/include/mach/defBF549.h
index 6fc6e39..f7f0435 100644
--- a/arch/blackfin/mach-bf548/include/mach/defBF549.h
+++ b/arch/blackfin/mach-bf548/include/mach/defBF549.h
@@ -1024,7 +1024,7 @@
 #define                   HMDMA0_CONTROL  0xffc04500   /* Handshake MDMA0 Control Register */
 #define                    HMDMA0_ECINIT  0xffc04504   /* Handshake MDMA0 Initial Edge Count Register */
 #define                    HMDMA0_BCINIT  0xffc04508   /* Handshake MDMA0 Initial Block Count Register */
-#define                  HMDMA0_ECURGENT  0xffc0450c   /* Handshake MDMA0 Urgent Edge Count Threshhold Register */
+#define                  HMDMA0_ECURGENT  0xffc0450c   /* Handshake MDMA0 Urgent Edge Count Threshold Register */
 #define                HMDMA0_ECOVERFLOW  0xffc04510   /* Handshake MDMA0 Edge Count Overflow Interrupt Register */
 #define                    HMDMA0_ECOUNT  0xffc04514   /* Handshake MDMA0 Current Edge Count Register */
 #define                    HMDMA0_BCOUNT  0xffc04518   /* Handshake MDMA0 Current Block Count Register */
@@ -1034,7 +1034,7 @@
 #define                   HMDMA1_CONTROL  0xffc04540   /* Handshake MDMA1 Control Register */
 #define                    HMDMA1_ECINIT  0xffc04544   /* Handshake MDMA1 Initial Edge Count Register */
 #define                    HMDMA1_BCINIT  0xffc04548   /* Handshake MDMA1 Initial Block Count Register */
-#define                  HMDMA1_ECURGENT  0xffc0454c   /* Handshake MDMA1 Urgent Edge Count Threshhold Register */
+#define                  HMDMA1_ECURGENT  0xffc0454c   /* Handshake MDMA1 Urgent Edge Count Threshold Register */
 #define                HMDMA1_ECOVERFLOW  0xffc04550   /* Handshake MDMA1 Edge Count Overflow Interrupt Register */
 #define                    HMDMA1_ECOUNT  0xffc04554   /* Handshake MDMA1 Current Edge Count Register */
 #define                    HMDMA1_BCOUNT  0xffc04558   /* Handshake MDMA1 Current Block Count Register */
diff --git a/arch/cris/mm/fault.c b/arch/cris/mm/fault.c
index 4a7cdd9..380df1a 100644
--- a/arch/cris/mm/fault.c
+++ b/arch/cris/mm/fault.c
@@ -209,7 +209,7 @@ do_page_fault(unsigned long address, struct pt_regs *regs,
 	/* Are we prepared to handle this kernel fault?
 	 *
 	 * (The kernel has valid exception-points in the source
-	 *  when it acesses user-memory. When it fails in one
+	 *  when it accesses user-memory. When it fails in one
 	 *  of those points, we find it in a table and do a jump
 	 *  to some fixup code that loads an appropriate error
 	 *  code)
diff --git a/arch/ia64/hp/common/sba_iommu.c b/arch/ia64/hp/common/sba_iommu.c
index 674a837..f332e3f 100644
--- a/arch/ia64/hp/common/sba_iommu.c
+++ b/arch/ia64/hp/common/sba_iommu.c
@@ -1381,7 +1381,7 @@ sba_coalesce_chunks(struct ioc *ioc, struct device *dev,
 #endif
 
 			/*
-			** Not virtually contigous.
+			** Not virtually contiguous.
 			** Terminate prev chunk.
 			** Start a new chunk.
 			**
diff --git a/arch/ia64/ia32/ia32_entry.S b/arch/ia64/ia32/ia32_entry.S
index af9405c..02d1fb7 100644
--- a/arch/ia64/ia32/ia32_entry.S
+++ b/arch/ia64/ia32/ia32_entry.S
@@ -79,7 +79,7 @@ GLOBAL_ENTRY(ia32_ret_from_clone)
 (p6)	br.cond.spnt .ia32_strace_check_retval
 	;;					// prevent RAW on r8
 END(ia32_ret_from_clone)
-	// fall thrugh
+	// fall through
 GLOBAL_ENTRY(ia32_ret_from_syscall)
 	PT_REGS_UNWIND_INFO(0)
 
diff --git a/arch/ia64/include/asm/perfmon_default_smpl.h b/arch/ia64/include/asm/perfmon_default_smpl.h
index 48822c0..74724b2 100644
--- a/arch/ia64/include/asm/perfmon_default_smpl.h
+++ b/arch/ia64/include/asm/perfmon_default_smpl.h
@@ -67,7 +67,7 @@ typedef struct {
         unsigned long   ip;                     /* where did the overflow interrupt happened  */
         unsigned long   tstamp;                 /* ar.itc when entering perfmon intr. handler */
 
-        unsigned short  cpu;                    /* cpu on which the overfow occured */
+        unsigned short  cpu;                    /* cpu on which the overflow occured */
         unsigned short  set;                    /* event set active when overflow ocurred   */
         int    		tgid;              	/* thread group id (for NPTL, this is getpid()) */
 } pfm_default_smpl_entry_t;
diff --git a/arch/ia64/include/asm/sn/shubio.h b/arch/ia64/include/asm/sn/shubio.h
index 22a6f18..6052422 100644
--- a/arch/ia64/include/asm/sn/shubio.h
+++ b/arch/ia64/include/asm/sn/shubio.h
@@ -3289,7 +3289,7 @@ typedef ii_icrb0_e_u_t icrbe_t;
 #define IIO_IIDSR_LVL_SHIFT     0
 #define IIO_IIDSR_LVL_MASK      0x000000ff
 
-/* Xtalk timeout threshhold register (IIO_IXTT) */
+/* Xtalk timeout threshold register (IIO_IXTT) */
 #define IXTT_RRSP_TO_SHFT	55	/* read response timeout */
 #define IXTT_RRSP_TO_MASK	(0x1FULL << IXTT_RRSP_TO_SHFT)
 #define IXTT_RRSP_PS_SHFT	32	/* read responsed TO prescalar */
diff --git a/arch/ia64/kernel/esi.c b/arch/ia64/kernel/esi.c
index d5764a3..b091111 100644
--- a/arch/ia64/kernel/esi.c
+++ b/arch/ia64/kernel/esi.c
@@ -84,7 +84,7 @@ static int __init esi_init (void)
 		      case ESI_DESC_ENTRY_POINT:
 			break;
 		      default:
-			printk(KERN_WARNING "Unkown table type %d found in "
+			printk(KERN_WARNING "Unknown table type %d found in "
 			       "ESI table, ignoring rest of table\n", *p);
 			return -ENODEV;
 		}
diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
index f178270..b3a1cb3 100644
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -3523,7 +3523,7 @@ pfm_use_debug_registers(struct task_struct *task)
  * IA64_THREAD_DBG_VALID set. This indicates a task which was
  * able to use the debug registers for debugging purposes via
  * ptrace(). Therefore we know it was not using them for
- * perfmormance monitoring, so we only decrement the number
+ * performance monitoring, so we only decrement the number
  * of "ptraced" debug register users to keep the count up to date
  */
 int
diff --git a/arch/m68k/ifpsp060/src/fpsp.S b/arch/m68k/ifpsp060/src/fpsp.S
index 6c1a9a2..73613b5 100644
--- a/arch/m68k/ifpsp060/src/fpsp.S
+++ b/arch/m68k/ifpsp060/src/fpsp.S
@@ -753,7 +753,7 @@ fovfl_ovfl_on:
 
 	bra.l		_real_ovfl
 
-# overflow occurred but is disabled. meanwhile, inexact is enabled. therefore,
+# overflow occurred but is disabled. meanwhile, inexact is enabled. Therefore,
 # we must jump to real_inex().
 fovfl_inex_on:
 
@@ -1015,7 +1015,7 @@ funfl_unfl_on2:
 
 	bra.l		_real_unfl
 
-# undeflow occurred but is disabled. meanwhile, inexact is enabled. therefore,
+# underflow occurred but is disabled. meanwhile, inexact is enabled. Therefore,
 # we must jump to real_inex().
 funfl_inex_on:
 
@@ -2963,7 +2963,7 @@ iea_disabled:
 
 	tst.w		%d0			# is instr fmovm?
 	bmi.b		iea_dis_fmovm		# yes
-# instruction is using an extended precision immediate operand. therefore,
+# instruction is using an extended precision immediate operand. Therefore,
 # the total instruction length is 16 bytes.
 iea_dis_immed:
 	mov.l		&0x10,%d0		# 16 bytes of instruction
@@ -9624,7 +9624,7 @@ sok_dnrm:
 	bge.b		sok_norm2		# thank goodness no
 
 # the multiply factor that we're trying to create should be a denorm
-# for the multiply to work. therefore, we're going to actually do a
+# for the multiply to work. Therefore, we're going to actually do a
 # multiply with a denorm which will cause an unimplemented data type
 # exception to be put into the machine which will be caught and corrected
 # later. we don't do this with the DENORMs above because this method
@@ -12216,7 +12216,7 @@ fin_sd_unfl_dis:
 
 #
 # operand will underflow AND underflow or inexact is enabled.
-# therefore, we must return the result rounded to extended precision.
+# Therefore, we must return the result rounded to extended precision.
 #
 fin_sd_unfl_ena:
 	mov.l		FP_SCR0_HI(%a6),FP_SCR1_HI(%a6)
@@ -12746,7 +12746,7 @@ fdiv_zero_load_p:
 
 #
 # The destination was In Range and the source was a ZERO. The result,
-# therefore, is an INF w/ the proper sign.
+# Therefore, is an INF w/ the proper sign.
 # So, determine the sign and return a new INF (w/ the j-bit cleared).
 #
 	global		fdiv_inf_load		# global for fsgldiv
@@ -12996,7 +12996,7 @@ fneg_sd_unfl_dis:
 
 #
 # operand will underflow AND underflow is enabled.
-# therefore, we must return the result rounded to extended precision.
+# Therefore, we must return the result rounded to extended precision.
 #
 fneg_sd_unfl_ena:
 	mov.l		FP_SCR0_HI(%a6),FP_SCR1_HI(%a6)
@@ -13611,7 +13611,7 @@ fabs_sd_unfl_dis:
 
 #
 # operand will underflow AND underflow is enabled.
-# therefore, we must return the result rounded to extended precision.
+# Therefore, we must return the result rounded to extended precision.
 #
 fabs_sd_unfl_ena:
 	mov.l		FP_SCR0_HI(%a6),FP_SCR1_HI(%a6)
@@ -14973,7 +14973,7 @@ fadd_zero_2:
 
 #
 # the ZEROes have opposite signs:
-# - therefore, we return +ZERO if the rounding modes are RN,RZ, or RP.
+# - Therefore, we return +ZERO if the rounding modes are RN,RZ, or RP.
 # - -ZERO is returned in the case of RM.
 #
 fadd_zero_2_chk_rm:
@@ -15425,7 +15425,7 @@ fsub_zero_2:
 
 #
 # the ZEROes have the same signs:
-# - therefore, we return +ZERO if the rounding mode is RN,RZ, or RP
+# - Therefore, we return +ZERO if the rounding mode is RN,RZ, or RP
 # - -ZERO is returned in the case of RM.
 #
 fsub_zero_2_chk_rm:
@@ -15693,7 +15693,7 @@ fsqrt_sd_unfl_dis:
 
 #
 # operand will underflow AND underflow is enabled.
-# therefore, we must return the result rounded to extended precision.
+# Therefore, we must return the result rounded to extended precision.
 #
 fsqrt_sd_unfl_ena:
 	mov.l		FP_SCR0_HI(%a6),FP_SCR1_HI(%a6)
@@ -21000,7 +21000,7 @@ fout_pack_type:
 	tst.l		%d0
 	bne.b		fout_pack_set
 # "mantissa" is all zero which means that the answer is zero. but, the '040
-# algorithm allows the exponent to be non-zero. the 881/2 do not. therefore,
+# algorithm allows the exponent to be non-zero. the 881/2 do not. Therefore,
 # if the mantissa is zero, I will zero the exponent, too.
 # the question now is whether the exponents sign bit is allowed to be non-zero
 # for a zero, also...
@@ -21743,7 +21743,7 @@ denorm_set_stky:
 	rts
 
 #									#
-# dnrm_lp(): normalize exponent/mantissa to specified threshhold	#
+# dnrm_lp(): normalize exponent/mantissa to specified threshold		#
 #									#
 # INPUT:								#
 #	%a0	   : points to the operand to be denormalized		#
@@ -22402,7 +22402,7 @@ unnorm_shift:
 	bgt.b		unnorm_nrm_zero		# yes; denorm only until exp = 0
 
 #
-# exponent would not go < 0. therefore, number stays normalized
+# exponent would not go < 0. Therefore, number stays normalized
 #
 	sub.w		%d0, %d1		# shift exponent value
 	mov.w		FTEMP_EX(%a0), %d0	# load old exponent
diff --git a/arch/m68k/ifpsp060/src/pfpsp.S b/arch/m68k/ifpsp060/src/pfpsp.S
index 51b9f7d..e71ba0a 100644
--- a/arch/m68k/ifpsp060/src/pfpsp.S
+++ b/arch/m68k/ifpsp060/src/pfpsp.S
@@ -752,7 +752,7 @@ fovfl_ovfl_on:
 
 	bra.l		_real_ovfl
 
-# overflow occurred but is disabled. meanwhile, inexact is enabled. therefore,
+# overflow occurred but is disabled. meanwhile, inexact is enabled. Therefore,
 # we must jump to real_inex().
 fovfl_inex_on:
 
@@ -1014,7 +1014,7 @@ funfl_unfl_on2:
 
 	bra.l		_real_unfl
 
-# undeflow occurred but is disabled. meanwhile, inexact is enabled. therefore,
+# underflow occurred but is disabled. meanwhile, inexact is enabled. Therefore,
 # we must jump to real_inex().
 funfl_inex_on:
 
@@ -2962,7 +2962,7 @@ iea_disabled:
 
 	tst.w		%d0			# is instr fmovm?
 	bmi.b		iea_dis_fmovm		# yes
-# instruction is using an extended precision immediate operand. therefore,
+# instruction is using an extended precision immediate operand. Therefore,
 # the total instruction length is 16 bytes.
 iea_dis_immed:
 	mov.l		&0x10,%d0		# 16 bytes of instruction
@@ -5865,7 +5865,7 @@ denorm_set_stky:
 	rts
 
 #									#
-# dnrm_lp(): normalize exponent/mantissa to specified threshhold	#
+# dnrm_lp(): normalize exponent/mantissa to specified threshold		#
 #									#
 # INPUT:								#
 #	%a0	   : points to the operand to be denormalized		#
@@ -6524,7 +6524,7 @@ unnorm_shift:
 	bgt.b		unnorm_nrm_zero		# yes; denorm only until exp = 0
 
 #
-# exponent would not go < 0. therefore, number stays normalized
+# exponent would not go < 0. Therefore, number stays normalized
 #
 	sub.w		%d0, %d1		# shift exponent value
 	mov.w		FTEMP_EX(%a0), %d0	# load old exponent
@@ -7901,7 +7901,7 @@ fout_pack_type:
 	tst.l		%d0
 	bne.b		fout_pack_set
 # "mantissa" is all zero which means that the answer is zero. but, the '040
-# algorithm allows the exponent to be non-zero. the 881/2 do not. therefore,
+# algorithm allows the exponent to be non-zero. the 881/2 do not. Therefore,
 # if the mantissa is zero, I will zero the exponent, too.
 # the question now is whether the exponents sign bit is allowed to be non-zero
 # for a zero, also...
@@ -8647,7 +8647,7 @@ fin_sd_unfl_dis:
 
 #
 # operand will underflow AND underflow or inexact is enabled.
-# therefore, we must return the result rounded to extended precision.
+# Therefore, we must return the result rounded to extended precision.
 #
 fin_sd_unfl_ena:
 	mov.l		FP_SCR0_HI(%a6),FP_SCR1_HI(%a6)
@@ -9177,7 +9177,7 @@ fdiv_zero_load_p:
 
 #
 # The destination was In Range and the source was a ZERO. The result,
-# therefore, is an INF w/ the proper sign.
+# Therefore, is an INF w/ the proper sign.
 # So, determine the sign and return a new INF (w/ the j-bit cleared).
 #
 	global		fdiv_inf_load		# global for fsgldiv
@@ -9427,7 +9427,7 @@ fneg_sd_unfl_dis:
 
 #
 # operand will underflow AND underflow is enabled.
-# therefore, we must return the result rounded to extended precision.
+# Therefore, we must return the result rounded to extended precision.
 #
 fneg_sd_unfl_ena:
 	mov.l		FP_SCR0_HI(%a6),FP_SCR1_HI(%a6)
@@ -10042,7 +10042,7 @@ fabs_sd_unfl_dis:
 
 #
 # operand will underflow AND underflow is enabled.
-# therefore, we must return the result rounded to extended precision.
+# Therefore, we must return the result rounded to extended precision.
 #
 fabs_sd_unfl_ena:
 	mov.l		FP_SCR0_HI(%a6),FP_SCR1_HI(%a6)
@@ -11404,7 +11404,7 @@ fadd_zero_2:
 
 #
 # the ZEROes have opposite signs:
-# - therefore, we return +ZERO if the rounding modes are RN,RZ, or RP.
+# - Therefore, we return +ZERO if the rounding modes are RN,RZ, or RP.
 # - -ZERO is returned in the case of RM.
 #
 fadd_zero_2_chk_rm:
@@ -11856,7 +11856,7 @@ fsub_zero_2:
 
 #
 # the ZEROes have the same signs:
-# - therefore, we return +ZERO if the rounding mode is RN,RZ, or RP
+# - Therefore, we return +ZERO if the rounding mode is RN,RZ, or RP
 # - -ZERO is returned in the case of RM.
 #
 fsub_zero_2_chk_rm:
@@ -12124,7 +12124,7 @@ fsqrt_sd_unfl_dis:
 
 #
 # operand will underflow AND underflow is enabled.
-# therefore, we must return the result rounded to extended precision.
+# Therefore, we must return the result rounded to extended precision.
 #
 fsqrt_sd_unfl_ena:
 	mov.l		FP_SCR0_HI(%a6),FP_SCR1_HI(%a6)
diff --git a/arch/m68k/include/asm/bootinfo.h b/arch/m68k/include/asm/bootinfo.h
index fb8a06b..67e7a78 100644
--- a/arch/m68k/include/asm/bootinfo.h
+++ b/arch/m68k/include/asm/bootinfo.h
@@ -145,7 +145,7 @@ struct bi_record {
 
     /*
      *  Macintosh hardware profile data - unused, see macintosh.h for
-     *  resonable type values
+     *  reasonable type values
      */
 
 #define BI_MAC_VIA1BASE		0x8010	/* Mac VIA1 base address (always present) */
diff --git a/arch/microblaze/lib/memcpy.c b/arch/microblaze/lib/memcpy.c
index 6a907c5..cc2108b 100644
--- a/arch/microblaze/lib/memcpy.c
+++ b/arch/microblaze/lib/memcpy.c
@@ -9,7 +9,7 @@
  * It is based on demo code originally Copyright 2001 by Intel Corp, taken from
  * http://www.embedded.com/showArticle.jhtml?articleID=19205567
  *
- * Attempts were made, unsuccesfully, to contact the original
+ * Attempts were made, unsuccessfully, to contact the original
  * author of this code (Michael Morrow, Intel).  Below is the original
  * copyright notice.
  *
diff --git a/arch/microblaze/lib/memmove.c b/arch/microblaze/lib/memmove.c
index d4e9f49..0929198 100644
--- a/arch/microblaze/lib/memmove.c
+++ b/arch/microblaze/lib/memmove.c
@@ -9,7 +9,7 @@
  * It is based on demo code originally Copyright 2001 by Intel Corp, taken from
  * http://www.embedded.com/showArticle.jhtml?articleID=19205567
  *
- * Attempts were made, unsuccesfully, to contact the original
+ * Attempts were made, unsuccessfully, to contact the original
  * author of this code (Michael Morrow, Intel).  Below is the original
  * copyright notice.
  *
diff --git a/arch/microblaze/lib/memset.c b/arch/microblaze/lib/memset.c
index 941dc8f..4df851d 100644
--- a/arch/microblaze/lib/memset.c
+++ b/arch/microblaze/lib/memset.c
@@ -9,7 +9,7 @@
  * It is based on demo code originally Copyright 2001 by Intel Corp, taken from
  * http://www.embedded.com/showArticle.jhtml?articleID=19205567
  *
- * Attempts were made, unsuccesfully, to contact the original
+ * Attempts were made, unsuccessfully, to contact the original
  * author of this code (Michael Morrow, Intel).  Below is the original
  * copyright notice.
  *
diff --git a/arch/mips/include/asm/mach-pnx833x/gpio.h b/arch/mips/include/asm/mach-pnx833x/gpio.h
index 8de0eb9..ed3a88d 100644
--- a/arch/mips/include/asm/mach-pnx833x/gpio.h
+++ b/arch/mips/include/asm/mach-pnx833x/gpio.h
@@ -24,7 +24,7 @@
 
 /* BIG FAT WARNING: races danger!
    No protections exist here. Current users are only early init code,
-   when locking is not needed because no cuncurency yet exists there,
+   when locking is not needed because no concurrency yet exists there,
    and GPIO IRQ dispatcher, which does locking.
    However, if many uses will ever happen, proper locking will be needed
    - including locking between different uses
diff --git a/arch/mips/include/asm/sgi/ioc.h b/arch/mips/include/asm/sgi/ioc.h
index 343ed15..57a9719 100644
--- a/arch/mips/include/asm/sgi/ioc.h
+++ b/arch/mips/include/asm/sgi/ioc.h
@@ -164,7 +164,7 @@ struct sgioc_regs {
 	u32 _unused5;
 	u8 _write[3];
 	volatile u8 write;
-#define SGIOC_WRITE_NTHRESH	0x01	/* use 4.5db threshhold */
+#define SGIOC_WRITE_NTHRESH	0x01	/* use 4.5db threshold */
 #define SGIOC_WRITE_TPSPEED	0x02	/* use 100ohm TP speed */
 #define SGIOC_WRITE_EPSEL	0x04	/* force cable mode: 1=AUI 0=TP */
 #define SGIOC_WRITE_EASEL	0x08	/* 1=autoselect 0=manual cable selection */
diff --git a/arch/mips/include/asm/sibyte/sb1250_mac.h b/arch/mips/include/asm/sibyte/sb1250_mac.h
index b6faf08..591b906 100644
--- a/arch/mips/include/asm/sibyte/sb1250_mac.h
+++ b/arch/mips/include/asm/sibyte/sb1250_mac.h
@@ -212,7 +212,7 @@
 #define G_MAC_TXD_WEIGHT1(x)        _SB_GETVALUE(x, S_MAC_TXD_WEIGHT1, M_MAC_TXD_WEIGHT1)
 
 /*
- * MAC Fifo Threshhold registers (Table 9-14)
+ * MAC Fifo Threshold registers (Table 9-14)
  * Register: MAC_THRSH_CFG_0
  * Register: MAC_THRSH_CFG_1
  * Register: MAC_THRSH_CFG_2
diff --git a/arch/mips/include/asm/sn/sn0/hubio.h b/arch/mips/include/asm/sn/sn0/hubio.h
index d0c29d4..31c76c0 100644
--- a/arch/mips/include/asm/sn/sn0/hubio.h
+++ b/arch/mips/include/asm/sn/sn0/hubio.h
@@ -825,7 +825,7 @@ typedef union iprb_u {
 	struct {
 	    u64	rsvd1:	15,
 		error:	1,	/* Widget rcvd wr resp pkt w/ error */
-		ovflow:	5,	/* Over flow count. perf measurement */
+		ovflow:	5,	/* Overflow count. perf measurement */
 		fire_and_forget: 1, /* Launch Write without response */
 		mode:	2,	/* Widget operation Mode	*/
 		rsvd2:	2,
diff --git a/arch/mips/kernel/smtc.c b/arch/mips/kernel/smtc.c
index 24630fd..a38e3ee 100644
--- a/arch/mips/kernel/smtc.c
+++ b/arch/mips/kernel/smtc.c
@@ -1331,7 +1331,7 @@ void smtc_get_new_mmu_context(struct mm_struct *mm, unsigned long cpu)
 		if (!((asid += ASID_INC) & ASID_MASK) ) {
 			if (cpu_has_vtag_icache)
 				flush_icache_all();
-			/* Traverse all online CPUs (hack requires contigous range) */
+			/* Traverse all online CPUs (hack requires contiguous range) */
 			for_each_online_cpu(i) {
 				/*
 				 * We don't need to worry about our own CPU, nor those of
diff --git a/arch/mips/math-emu/dp_sub.c b/arch/mips/math-emu/dp_sub.c
index b30c5b1..a2127d6 100644
--- a/arch/mips/math-emu/dp_sub.c
+++ b/arch/mips/math-emu/dp_sub.c
@@ -110,7 +110,7 @@ ieee754dp ieee754dp_sub(ieee754dp x, ieee754dp y)
 
 	case CLPAIR(IEEE754_CLASS_DNORM, IEEE754_CLASS_DNORM):
 		DPDNORMX;
-		/* FAAL THOROUGH */
+		/* FALL THROUGH */
 
 	case CLPAIR(IEEE754_CLASS_NORM, IEEE754_CLASS_DNORM):
 		/* normalize ym,ye */
diff --git a/arch/mips/txx9/generic/smsc_fdc37m81x.c b/arch/mips/txx9/generic/smsc_fdc37m81x.c
index a2b2d62..8ebc384 100644
--- a/arch/mips/txx9/generic/smsc_fdc37m81x.c
+++ b/arch/mips/txx9/generic/smsc_fdc37m81x.c
@@ -117,7 +117,7 @@ unsigned long __init smsc_fdc37m81x_init(unsigned long port)
 	if (chip_id == SMSC_FDC37M81X_CHIP_ID)
 		smsc_fdc37m81x_config_end();
 	else {
-		printk(KERN_WARNING "%s: unknow chip id 0x%02x\n", __func__,
+		printk(KERN_WARNING "%s: unknown chip id 0x%02x\n", __func__,
 		       chip_id);
 		g_smsc_fdc37m81x_base = 0;
 	}
diff --git a/arch/powerpc/include/asm/reg_fsl_emb.h b/arch/powerpc/include/asm/reg_fsl_emb.h
index 1e180a5..0de404d 100644
--- a/arch/powerpc/include/asm/reg_fsl_emb.h
+++ b/arch/powerpc/include/asm/reg_fsl_emb.h
@@ -39,7 +39,7 @@
 #define PMRN_PMLCB2	0x112	/* PM Local Control B2 */
 #define PMRN_PMLCB3	0x113	/* PM Local Control B3 */
 
-#define PMLCB_THRESHMUL_MASK	0x0700	/* Threshhold Multiple Field */
+#define PMLCB_THRESHMUL_MASK	0x0700	/* Threshold Multiple Field */
 #define PMLCB_THRESHMUL_SHIFT	8
 
 #define PMLCB_THRESHOLD_MASK	0x003f	/* Threshold Field */
diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
index 641c74b..b6bd1ea 100644
--- a/arch/powerpc/kernel/kgdb.c
+++ b/arch/powerpc/kernel/kgdb.c
@@ -52,7 +52,7 @@ static struct hard_trap_info
 	{ 0x2030, 0x08 /* SIGFPE */  },		/* spe fp data */
 	{ 0x2040, 0x08 /* SIGFPE */  },		/* spe fp data */
 	{ 0x2050, 0x08 /* SIGFPE */  },		/* spe fp round */
-	{ 0x2060, 0x0e /* SIGILL */  },		/* performace monitor */
+	{ 0x2060, 0x0e /* SIGILL */  },		/* performance monitor */
 	{ 0x2900, 0x08 /* SIGFPE */  },		/* apu unavailable */
 	{ 0x3100, 0x0e /* SIGALRM */ },		/* fixed interval timer */
 	{ 0x3200, 0x02 /* SIGINT */  }, 	/* watchdog */
diff --git a/arch/powerpc/kernel/tau_6xx.c b/arch/powerpc/kernel/tau_6xx.c
index c3a56d6..a753b72 100644
--- a/arch/powerpc/kernel/tau_6xx.c
+++ b/arch/powerpc/kernel/tau_6xx.c
@@ -59,7 +59,7 @@ void set_thresholds(unsigned long cpu)
 	mtspr(SPRN_THRM1, THRM1_THRES(tau[cpu].low) | THRM1_V | THRM1_TIE | THRM1_TID);
 
 	/* setup THRM2,
-	 * threshold, valid bit, enable interrupts, interrupt when above threshhold
+	 * threshold, valid bit, enable interrupts, interrupt when above threshold
 	 */
 	mtspr (SPRN_THRM2, THRM1_THRES(tau[cpu].high) | THRM1_V | THRM1_TIE);
 #else
diff --git a/arch/powerpc/oprofile/op_model_cell.c b/arch/powerpc/oprofile/op_model_cell.c
index ae06c62..3b581b0 100644
--- a/arch/powerpc/oprofile/op_model_cell.c
+++ b/arch/powerpc/oprofile/op_model_cell.c
@@ -1594,7 +1594,7 @@ static void cell_handle_interrupt_spu(struct pt_regs *regs,
 		 * to a latch.  The new values (interrupt setting bits, reset
 		 * counter value etc.) are not copied to the actual registers
 		 * until the performance monitor is enabled.  In order to get
-		 * this to work as desired, the permormance monitor needs to
+		 * this to work as desired, the performance monitor needs to
 		 * be disabled while writing to the latches.  This is a
 		 * HW design issue.
 		 */
@@ -1668,7 +1668,7 @@ static void cell_handle_interrupt_ppu(struct pt_regs *regs,
 		 * to a latch.	The new values (interrupt setting bits, reset
 		 * counter value etc.) are not copied to the actual registers
 		 * until the performance monitor is enabled.  In order to get
-		 * this to work as desired, the permormance monitor needs to
+		 * this to work as desired, the performance monitor needs to
 		 * be disabled while writing to the latches.  This is a
 		 * HW design issue.
 		 */
diff --git a/arch/powerpc/platforms/52xx/mpc52xx_pci.c b/arch/powerpc/platforms/52xx/mpc52xx_pci.c
index dd43114..da110bd 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_pci.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_pci.c
@@ -100,7 +100,7 @@ const struct of_device_id mpc52xx_pci_ids[] __initdata = {
 };
 
 /* ======================================================================== */
-/* PCI configuration acess                                                  */
+/* PCI configuration access                                                 */
 /* ======================================================================== */
 
 static int
diff --git a/arch/powerpc/platforms/powermac/pci.c b/arch/powerpc/platforms/powermac/pci.c
index e81403b..ab2027c 100644
--- a/arch/powerpc/platforms/powermac/pci.c
+++ b/arch/powerpc/platforms/powermac/pci.c
@@ -302,7 +302,7 @@ static void __init setup_chaos(struct pci_controller *hose,
  *  1 -> Skip the device but act as if the access was successfull
  *       (return 0xff's on reads, eventually, cache config space
  *       accesses in a later version)
- * -1 -> Hide the device (unsuccessful acess)
+ * -1 -> Hide the device (unsuccessful access)
  */
 static int u3_ht_skip_device(struct pci_controller *hose,
 			     struct pci_bus *bus, unsigned int devfn)
diff --git a/arch/powerpc/sysdev/dart_iommu.c b/arch/powerpc/sysdev/dart_iommu.c
index ae3c4db..bafc3f8 100644
--- a/arch/powerpc/sysdev/dart_iommu.c
+++ b/arch/powerpc/sysdev/dart_iommu.c
@@ -160,7 +160,7 @@ static int dart_build(struct iommu_table *tbl, long index,
 
 	dp = ((unsigned int*)tbl->it_base) + index;
 
-	/* On U3, all memory is contigous, so we can move this
+	/* On U3, all memory is contiguous, so we can move this
 	 * out of the loop.
 	 */
 	l = npages;
diff --git a/arch/s390/math-emu/math.c b/arch/s390/math-emu/math.c
index 3ee78cc..cd4e9c1 100644
--- a/arch/s390/math-emu/math.c
+++ b/arch/s390/math-emu/math.c
@@ -2088,7 +2088,7 @@ int math_emu_ldr(__u8 *opcode) {
         __u16 opc = *((__u16 *) opcode);
 
         if ((opc & 0x90) == 0) {           /* test if rx in {0,2,4,6} */
-                /* we got an exception therfore ry can't be in {0,2,4,6} */
+                /* we got an exception therefore ry can't be in {0,2,4,6} */
 		asm volatile(		/* load rx from fp_regs.fprs[ry] */
 			"	bras	1,0f\n"
 			"	ld	0,0(%1)\n"
@@ -2118,7 +2118,7 @@ int math_emu_ler(__u8 *opcode) {
         __u16 opc = *((__u16 *) opcode);
 
         if ((opc & 0x90) == 0) {           /* test if rx in {0,2,4,6} */
-                /* we got an exception therfore ry can't be in {0,2,4,6} */
+                /* we got an exception therefore ry can't be in {0,2,4,6} */
 		asm volatile(		/* load rx from fp_regs.fprs[ry] */
 			"	bras	1,0f\n"
 			"	le	0,0(%1)\n"
diff --git a/arch/x86/include/asm/desc_defs.h b/arch/x86/include/asm/desc_defs.h
index 9d66848..278441f 100644
--- a/arch/x86/include/asm/desc_defs.h
+++ b/arch/x86/include/asm/desc_defs.h
@@ -12,9 +12,9 @@
 #include <linux/types.h>
 
 /*
- * FIXME: Acessing the desc_struct through its fields is more elegant,
+ * FIXME: Accessing the desc_struct through its fields is more elegant,
  * and should be the one valid thing to do. However, a lot of open code
- * still touches the a and b acessors, and doing this allow us to do it
+ * still touches the a and b accessors, and doing this allow us to do it
  * incrementally. We keep the signature as a struct, rather than an union,
  * so we can get rid of it transparently in the future -- glommer
  */
diff --git a/arch/x86/include/asm/mmzone_32.h b/arch/x86/include/asm/mmzone_32.h
index ede6998..91df7c5 100644
--- a/arch/x86/include/asm/mmzone_32.h
+++ b/arch/x86/include/asm/mmzone_32.h
@@ -47,7 +47,7 @@ static inline void resume_map_numa_kva(pgd_t *pgd) {}
 /*
  * generic node memory support, the following assumptions apply:
  *
- * 1) memory comes in 64Mb contigious chunks which are either present or not
+ * 1) memory comes in 64Mb contiguous chunks which are either present or not
  * 2) we will not have more than 64Gb in total
  *
  * for now assume that 64Gb is max amount of RAM for whole system
diff --git a/arch/x86/include/asm/uv/uv_bau.h b/arch/x86/include/asm/uv/uv_bau.h
index 80e2984..b414d2b 100644
--- a/arch/x86/include/asm/uv/uv_bau.h
+++ b/arch/x86/include/asm/uv/uv_bau.h
@@ -55,7 +55,7 @@
 #define DESC_STATUS_SOURCE_TIMEOUT	3
 
 /*
- * source side threshholds at which message retries print a warning
+ * source side thresholds at which message retries print a warning
  */
 #define SOURCE_TIMEOUT_LIMIT		20
 #define DESTINATION_TIMEOUT_LIMIT	20
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 67e929b..1c2c483 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1122,7 +1122,7 @@ static int __init acpi_parse_madt_ioapic_entries(void)
 	if (!acpi_sci_override_gsi)
 		acpi_sci_ioapic_setup(acpi_gbl_FADT.sci_interrupt, 0, 0);
 
-	/* Fill in identity legacy mapings where no override */
+	/* Fill in identity legacy mappings where no override */
 	mp_config_acpi_legacy_irqs();
 
 	count =
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 0285521..42ac5e0 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1637,7 +1637,7 @@ retry:
 			goto out;
 
 		/*
-		 * aperture was sucessfully enlarged by 128 MB, try
+		 * aperture was successfully enlarged by 128 MB, try
 		 * allocation again
 		 */
 		goto retry;
@@ -2396,7 +2396,7 @@ int __init amd_iommu_init_passthrough(void)
 	struct pci_dev *dev = NULL;
 	u16 devid, devid2;
 
-	/* allocate passthroug domain */
+	/* allocate passthrough domain */
 	pt_domain = protection_domain_alloc();
 	if (!pt_domain)
 		return -ENOMEM;
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index b5801c3..35be580 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1229,7 +1229,7 @@ x86_perf_event_set_period(struct perf_event *event,
 		return 0;
 
 	/*
-	 * If we are way outside a reasoable range then just skip forward:
+	 * If we are way outside a reasonable range then just skip forward:
 	 */
 	if (unlikely(left <= -period)) {
 		left = period;
diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 7b5169d..7d37737 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -514,7 +514,7 @@ static int __kprobes reenter_kprobe(struct kprobe *p, struct pt_regs *regs,
 
 /*
  * Interrupts are disabled on entry as trap3 is an interrupt gate and they
- * remain disabled thorough out this function.
+ * remain disabled throughout this function.
  */
 static int __kprobes kprobe_handler(struct pt_regs *regs)
 {
@@ -851,7 +851,7 @@ no_change:
 
 /*
  * Interrupts are disabled on entry as trap1 is an interrupt gate and they
- * remain disabled thoroughout this function.
+ * remain disabled throughout this function.
  */
 static int __kprobes post_kprobe_handler(struct pt_regs *regs)
 {
diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
index 16ccbd7..d16d576 100644
--- a/arch/x86/mm/kmmio.c
+++ b/arch/x86/mm/kmmio.c
@@ -203,7 +203,7 @@ static void disarm_kmmio_fault_page(struct kmmio_fault_page *f)
  */
 /*
  * Interrupts are disabled on entry as trap3 is an interrupt gate
- * and they remain disabled thorough out this function.
+ * and they remain disabled throughout this function.
  */
 int kmmio_handler(struct pt_regs *regs, unsigned long addr)
 {
@@ -302,7 +302,7 @@ no_kmmio:
 
 /*
  * Interrupts are disabled on entry as trap1 is an interrupt gate
- * and they remain disabled thorough out this function.
+ * and they remain disabled throughout this function.
  * This must always get called as the pair to kmmio_handler().
  */
 static int post_kmmio_handler(unsigned long condition, struct pt_regs *regs)
diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index 572ee97..575f6fe 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -19,7 +19,7 @@
 
 /*
  * sub bus (transparent) will use entres from 3 to store extra from root,
- * so need to make sure have enought slot there, increase PCI_BUS_NUM_RESOURCES?
+ * so need to make sure have enough slot there, increase PCI_BUS_NUM_RESOURCES?
  */
 #define RES_NUM 16
 struct pci_root_info {
diff --git a/block/blk-iopoll.c b/block/blk-iopoll.c
index ca56420..58916af 100644
--- a/block/blk-iopoll.c
+++ b/block/blk-iopoll.c
@@ -28,7 +28,7 @@ static DEFINE_PER_CPU(struct list_head, blk_cpu_iopoll);
  * Description:
  *     Add this blk_iopoll structure to the pending poll list and trigger the
  *     raise of the blk iopoll softirq. The driver must already have gotten a
- *     succesful return from blk_iopoll_sched_prep() before calling this.
+ *     successful return from blk_iopoll_sched_prep() before calling this.
  **/
 void blk_iopoll_sched(struct blk_iopoll *iop)
 {
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 9ac4e37..3aadded 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -599,7 +599,7 @@ static const struct ich_laptop ich_laptop[] = {
 	{ 0x27DF, 0x1028, 0x02b0 },	/* ICH7 on unknown Dell */
 	{ 0x27DF, 0x1043, 0x1267 },	/* ICH7 on Asus W5F */
 	{ 0x27DF, 0x103C, 0x30A1 },	/* ICH7 on HP Compaq nc2400 */
-	{ 0x27DF, 0x103C, 0x361a },	/* ICH7 on unkown HP  */
+	{ 0x27DF, 0x103C, 0x361a },	/* ICH7 on unknown HP  */
 	{ 0x27DF, 0x1071, 0xD221 },	/* ICH7 on Hercules EC-900 */
 	{ 0x27DF, 0x152D, 0x0778 },	/* ICH7 on unknown Intel */
 	{ 0x24CA, 0x1025, 0x0061 },	/* ICH4 on ACER Aspire 2023WLMi */
diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index d344db4..0d9d2f2 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -43,9 +43,9 @@ enum {
 	/*
 	 * SATA-FSL host controller supports a max. of (15+1) direct PRDEs, and
 	 * chained indirect PRDEs upto a max count of 63.
-	 * We are allocating an array of 63 PRDEs contigiously, but PRDE#15 will
+	 * We are allocating an array of 63 PRDEs contiguously, but PRDE#15 will
 	 * be setup as an indirect descriptor, pointing to it's next
-	 * (contigious) PRDE. Though chained indirect PRDE arrays are
+	 * (contiguous) PRDE. Though chained indirect PRDE arrays are
 	 * supported,it will be more efficient to use a direct PRDT and
 	 * a single chain/link to indirect PRDE array/PRDT.
 	 */
@@ -314,7 +314,7 @@ static unsigned int sata_fsl_fill_sg(struct ata_queued_cmd *qc, void *cmd_desc,
 	u32 ttl_dwords = 0;
 
 	/*
-	 * NOTE : direct & indirect prdt's are contigiously allocated
+	 * NOTE : direct & indirect prdt's are contiguously allocated
 	 */
 	struct prde *prd = (struct prde *)&((struct command_desc *)
 					    cmd_desc)->prdt;
diff --git a/drivers/atm/iphase.c b/drivers/atm/iphase.c
index b2c1b37..f734b34 100644
--- a/drivers/atm/iphase.c
+++ b/drivers/atm/iphase.c
@@ -1132,7 +1132,7 @@ static int rx_pkt(struct atm_dev *dev)
                     IF_ERR(printk(" cause: packet time out\n");)
                 }
                 else {
-                    IF_ERR(printk(" cause: buffer over flow\n");)
+                    IF_ERR(printk(" cause: buffer overflow\n");)
                 }
 		goto out_free_desc;
 	}  
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 979d159..ee95c76 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -188,7 +188,7 @@ EXPORT_SYMBOL_GPL(wait_for_device_probe);
  * @dev: device to try to bind to the driver
  *
  * This function returns -ENODEV if the device is not registered,
- * 1 if the device is bound sucessfully and 0 otherwise.
+ * 1 if the device is bound successfully and 0 otherwise.
  *
  * This function must be called with @dev->sem held.  When called for a
  * USB interface, @dev->parent->sem must be held as well.
diff --git a/drivers/bluetooth/btmrvl_sdio.c b/drivers/bluetooth/btmrvl_sdio.c
index 5b33b85..63bfc54 100644
--- a/drivers/bluetooth/btmrvl_sdio.c
+++ b/drivers/bluetooth/btmrvl_sdio.c
@@ -535,7 +535,7 @@ static int btmrvl_sdio_card_to_host(struct btmrvl_private *priv)
 		break;
 
 	default:
-		BT_ERR("Unknow packet type:%d", type);
+		BT_ERR("Unknown packet type:%d", type);
 		print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, payload,
 						blksz * buf_block_len);
 
diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
index 4895f0e..aa09193 100644
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -214,7 +214,7 @@ static int hci_uart_send_frame(struct sk_buff *skb)
 	struct hci_uart *hu;
 
 	if (!hdev) {
-		BT_ERR("Frame for uknown device (hdev=NULL)");
+		BT_ERR("Frame for unknown device (hdev=NULL)");
 		return -ENODEV;
 	}
 
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index a074fce..42e65cf 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -5,7 +5,7 @@
  *
  *  Added devfs support. 
  *    Jan-11-1998, C. Scott Ananian <cananian@alumni.princeton.edu>
- *  Shared /dev/zero mmaping support, Feb 2000, Kanoj Sarcar <kanoj@sgi.com>
+ *  Shared /dev/zero mmapping support, Feb 2000, Kanoj Sarcar <kanoj@sgi.com>
  */
 
 #include <linux/mm.h>
diff --git a/drivers/char/mspec.c b/drivers/char/mspec.c
index 1997270..ecb89d7 100644
--- a/drivers/char/mspec.c
+++ b/drivers/char/mspec.c
@@ -248,7 +248,7 @@ static const struct vm_operations_struct mspec_vm_ops = {
 /*
  * mspec_mmap
  *
- * Called when mmaping the device.  Initializes the vma with a fault handler
+ * Called when mmapping the device.  Initializes the vma with a fault handler
  * and private data structure necessary to allocate, track, and free the
  * underlying pages.
  */
diff --git a/drivers/char/n_r3964.c b/drivers/char/n_r3964.c
index 6934025..c1d8b54 100644
--- a/drivers/char/n_r3964.c
+++ b/drivers/char/n_r3964.c
@@ -602,7 +602,7 @@ static void receive_char(struct r3964_info *pInfo, const unsigned char c)
 		}
 		break;
 	case R3964_WAIT_FOR_RX_REPEAT:
-		/* FALLTROUGH */
+		/* FALLTHROUGH */
 	case R3964_IDLE:
 		if (c == STX) {
 			/* Prevent rx_queue from overflow: */
diff --git a/drivers/char/rio/route.h b/drivers/char/rio/route.h
index 20ed73f..46e9637 100644
--- a/drivers/char/rio/route.h
+++ b/drivers/char/rio/route.h
@@ -67,7 +67,7 @@
 typedef struct COST_ROUTE COST_ROUTE;
 struct COST_ROUTE {
 	unsigned char cost;	/* Cost down this link */
-	unsigned char route[NODE_BYTES];	/* Nodes thorough this route */
+	unsigned char route[NODE_BYTES];	/* Nodes through this route */
 };
 
 typedef struct ROUTE_STR ROUTE_STR;
diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 5f753fc..09ad915 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -863,7 +863,7 @@ static int hifn_init_pubrng(struct hifn_device *dev)
 		dev->dmareg |= HIFN_DMAIER_PUBDONE;
 		hifn_write_1(dev, HIFN_1_DMA_IER, dev->dmareg);
 
-		dprintk("Chip %s: Public key engine has been sucessfully "
+		dprintk("Chip %s: Public key engine has been successfully "
 				"initialised.\n", dev->name);
 	}
 
diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 7585c41..c52ac9e 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -99,7 +99,7 @@ static struct at_desc *atc_alloc_descriptor(struct dma_chan *chan,
 }
 
 /**
- * atc_desc_get - get a unsused descriptor from free_list
+ * atc_desc_get - get an unused descriptor from free_list
  * @atchan: channel we want a new descriptor for
  */
 static struct at_desc *atc_desc_get(struct at_dma_chan *atchan)
diff --git a/drivers/firewire/core-topology.c b/drivers/firewire/core-topology.c
index fddf2b3..d373d17 100644
--- a/drivers/firewire/core-topology.c
+++ b/drivers/firewire/core-topology.c
@@ -183,7 +183,7 @@ static inline struct fw_node *fw_node(struct list_head *l)
  * This function builds the tree representation of the topology given
  * by the self IDs from the latest bus reset.  During the construction
  * of the tree, the function checks that the self IDs are valid and
- * internally consistent.  On succcess this function returns the
+ * internally consistent.  On success this function returns the
  * fw_node corresponding to the local card otherwise NULL.
  */
 static struct fw_node *build_tree(struct fw_card *card,
diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index 5cae0b3..3f7c500 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -272,7 +272,7 @@ EXPORT_SYMBOL(drm_mode_object_find);
  * functions & device file and adds it to the master fd list.
  *
  * RETURNS:
- * Zero on success, error code on falure.
+ * Zero on success, error code on failure.
  */
 int drm_framebuffer_init(struct drm_device *dev, struct drm_framebuffer *fb,
 			 const struct drm_framebuffer_funcs *funcs)
@@ -2328,7 +2328,7 @@ int drm_mode_connector_property_set_ioctl(struct drm_device *dev,
 	} else if (connector->funcs->set_property)
 		ret = connector->funcs->set_property(connector, property, out_resp->value);
 
-	/* store the property value if succesful */
+	/* store the property value if successful */
 	if (!ret)
 		drm_connector_property_set_value(connector, property, out_resp->value);
 out:
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index abfc27b..a2a3fa5 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1309,7 +1309,7 @@ out_free_list:
  * i915_gem_release_mmap - remove physical page mappings
  * @obj: obj in question
  *
- * Preserve the reservation of the mmaping with the DRM core code, but
+ * Preserve the reservation of the mmapping with the DRM core code, but
  * relinquish ownership of the pages back to the system.
  *
  * It is vital that we remove the page mapping if we have mapped a tiled
diff --git a/drivers/gpu/drm/i915/intel_fb.c b/drivers/gpu/drm/i915/intel_fb.c
index 2b0fe54..40fcf6f 100644
--- a/drivers/gpu/drm/i915/intel_fb.c
+++ b/drivers/gpu/drm/i915/intel_fb.c
@@ -70,7 +70,7 @@ static struct drm_fb_helper_funcs intel_fb_helper_funcs = {
 
 
 /**
- * Curretly it is assumed that the old framebuffer is reused.
+ * Currently it is assumed that the old framebuffer is reused.
  *
  * LOCKING
  * caller should hold the mode config lock.
diff --git a/drivers/gpu/drm/i915/intel_sdvo.c b/drivers/gpu/drm/i915/intel_sdvo.c
index 083bec2..e7fa327 100644
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -2726,7 +2726,7 @@ bool intel_sdvo_init(struct drm_device *dev, int output_device)
 	/* Wrap with our custom algo which switches to DDC mode */
 	intel_output->ddc_bus->algo = &intel_sdvo_i2c_bit_algo;
 
-	/* In defaut case sdvo lvds is false */
+	/* In default case sdvo lvds is false */
 	intel_sdvo_get_capabilities(intel_output, &sdvo_priv->caps);
 
 	if (intel_sdvo_output_setup(intel_output,
diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index 278f646..6740ed2 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -394,11 +394,11 @@ int r600_mc_init(struct radeon_device *rdev)
 		 * AGP so that GPU can catch out of VRAM/AGP access
 		 */
 		if (rdev->mc.gtt_location > rdev->mc.mc_vram_size) {
-			/* Enought place before */
+			/* Enough place before */
 			rdev->mc.vram_location = rdev->mc.gtt_location -
 							rdev->mc.mc_vram_size;
 		} else if (tmp > rdev->mc.mc_vram_size) {
-			/* Enought place after */
+			/* Enough place after */
 			rdev->mc.vram_location = rdev->mc.gtt_location +
 							rdev->mc.gtt_size;
 		} else {
diff --git a/drivers/gpu/drm/radeon/radeon_fb.c b/drivers/gpu/drm/radeon/radeon_fb.c
index b38c4c8..d10eb43 100644
--- a/drivers/gpu/drm/radeon/radeon_fb.c
+++ b/drivers/gpu/drm/radeon/radeon_fb.c
@@ -59,7 +59,7 @@ static struct fb_ops radeonfb_ops = {
 };
 
 /**
- * Curretly it is assumed that the old framebuffer is reused.
+ * Currently it is assumed that the old framebuffer is reused.
  *
  * LOCKING
  * caller should hold the mode config lock.
diff --git a/drivers/gpu/drm/radeon/radeon_state.c b/drivers/gpu/drm/radeon/radeon_state.c
index 38537d9..067167c 100644
--- a/drivers/gpu/drm/radeon/radeon_state.c
+++ b/drivers/gpu/drm/radeon/radeon_state.c
@@ -1950,7 +1950,7 @@ static void radeon_apply_surface_regs(int surf_index,
  * Note that refcount can be at most 2, since during a free refcount=3
  * might mean we have to allocate a new surface which might not always
  * be available.
- * For example : we allocate three contigous surfaces ABC. If B is
+ * For example : we allocate three contiguous surfaces ABC. If B is
  * freed, we suddenly need two surfaces to store A and C, which might
  * not always be available.
  */
diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
index 1381e06..eda4ade 100644
--- a/drivers/gpu/drm/radeon/radeon_ttm.c
+++ b/drivers/gpu/drm/radeon/radeon_ttm.c
@@ -378,7 +378,7 @@ static int radeon_bo_move(struct ttm_buffer_object *bo,
 	     new_mem->mem_type == TTM_PL_SYSTEM) ||
 	    (old_mem->mem_type == TTM_PL_SYSTEM &&
 	     new_mem->mem_type == TTM_PL_TT)) {
-		/* bind is enought */
+		/* bind is enough */
 		radeon_move_null(bo, new_mem);
 		return 0;
 	}
diff --git a/drivers/gpu/drm/radeon/rv770.c b/drivers/gpu/drm/radeon/rv770.c
index b0efd0d..5e06ee7 100644
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -829,11 +829,11 @@ int rv770_mc_init(struct radeon_device *rdev)
 		 * AGP so that GPU can catch out of VRAM/AGP access
 		 */
 		if (rdev->mc.gtt_location > rdev->mc.mc_vram_size) {
-			/* Enought place before */
+			/* Enough place before */
 			rdev->mc.vram_location = rdev->mc.gtt_location -
 							rdev->mc.mc_vram_size;
 		} else if (tmp > rdev->mc.mc_vram_size) {
-			/* Enought place after */
+			/* Enough place after */
 			rdev->mc.vram_location = rdev->mc.gtt_location +
 							rdev->mc.gtt_size;
 		} else {
diff --git a/drivers/gpu/drm/ttm/ttm_bo_util.c b/drivers/gpu/drm/ttm/ttm_bo_util.c
index c70927e..61c5572 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_util.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -427,7 +427,7 @@ static int ttm_bo_kmap_ttm(struct ttm_buffer_object *bo,
 
 		/*
 		 * We need to use vmap to get the desired page protection
-		 * or to make the buffer object look contigous.
+		 * or to make the buffer object look contiguous.
 		 */
 		prot = (mem->placement & TTM_PL_FLAG_CACHED) ?
 			PAGE_KERNEL :
diff --git a/drivers/hwmon/adm1029.c b/drivers/hwmon/adm1029.c
index 3671815..e845b75 100644
--- a/drivers/hwmon/adm1029.c
+++ b/drivers/hwmon/adm1029.c
@@ -432,7 +432,7 @@ static int adm1029_remove(struct i2c_client *client)
 }
 
 /*
-function that update the status of the chips (temperature for exemple)
+function that update the status of the chips (temperature for example)
 */
 static struct adm1029_data *adm1029_update_device(struct device *dev)
 {
diff --git a/drivers/hwmon/lm93.c b/drivers/hwmon/lm93.c
index fc36cad..c48a284 100644
--- a/drivers/hwmon/lm93.c
+++ b/drivers/hwmon/lm93.c
@@ -928,7 +928,7 @@ static void lm93_update_client_common(struct lm93_data *data,
 	data->prochot_interval = lm93_read_byte(client,
 			LM93_REG_PROCHOT_INTERVAL);
 
-	/* Fan Boost Termperature registers */
+	/* Fan Boost Temperature registers */
 	for (i = 0; i < 4; i++)
 		data->boost[i] = lm93_read_byte(client, LM93_REG_BOOST(i));
 
diff --git a/drivers/ieee1394/dv1394.c b/drivers/ieee1394/dv1394.c
index 2cd00b5..9fd4a0d 100644
--- a/drivers/ieee1394/dv1394.c
+++ b/drivers/ieee1394/dv1394.c
@@ -125,7 +125,7 @@
    0 - no debugging messages
    1 - some debugging messages, but none during DMA frame transmission
    2 - lots of messages, including during DMA frame transmission
-       (will cause undeflows if your machine is too slow!)
+       (will cause underflows if your machine is too slow!)
 */
 
 #define DV1394_DEBUG_LEVEL 0
diff --git a/drivers/infiniband/hw/ipath/ipath_iba6110.c b/drivers/infiniband/hw/ipath/ipath_iba6110.c
index 4bd39c8..37d12e5 100644
--- a/drivers/infiniband/hw/ipath/ipath_iba6110.c
+++ b/drivers/infiniband/hw/ipath/ipath_iba6110.c
@@ -381,7 +381,7 @@ static const ipath_err_t infinipath_hwe_htclnkbbyte1crcerr =
 #define IPATH_GPIO_SCL \
 	(1ULL << (_IPATH_GPIO_SCL_NUM+INFINIPATH_EXTC_GPIOOE_SHIFT))
 
-/* keep the code below somewhat more readonable; not used elsewhere */
+/* keep the code below somewhat more readable; not used elsewhere */
 #define _IPATH_HTLINK0_CRCBITS (infinipath_hwe_htclnkabyte0crcerr |	\
 				infinipath_hwe_htclnkabyte1crcerr)
 #define _IPATH_HTLINK1_CRCBITS (infinipath_hwe_htclnkbbyte0crcerr |	\
diff --git a/drivers/infiniband/hw/ipath/ipath_sd7220.c b/drivers/infiniband/hw/ipath/ipath_sd7220.c
index aa47eb5..2a68d9f 100644
--- a/drivers/infiniband/hw/ipath/ipath_sd7220.c
+++ b/drivers/infiniband/hw/ipath/ipath_sd7220.c
@@ -614,7 +614,7 @@ static int epb_trans(struct ipath_devdata *dd, u16 reg, u64 i_val, u64 *o_vp)
  * @wd: Write Data - value to set in register
  * @mask: ones where data should be spliced into reg.
  *
- * Basic register read/modify/write, with un-needed acesses elided. That is,
+ * Basic register read/modify/write, with un-needed accesses elided. That is,
  * a mask of zero will prevent write, while a mask of 0xFF will prevent read.
  * returns current (presumed, if a write was done) contents of selected
  * register, or <0 if errors.
@@ -989,7 +989,7 @@ static struct rxeq_init {
 	/* Set DFELTHFDR/HDR thresholds */
 	RXEQ_VAL(7, 8,    0, 0, 0, 0), /* FDR */
 	RXEQ_VAL(7, 0x21, 0, 0, 0, 0), /* HDR */
-	/* Set TLTHFDR/HDR theshold */
+	/* Set TLTHFDR/HDR threshold */
 	RXEQ_VAL(7, 9,    2, 2, 2, 2), /* FDR */
 	RXEQ_VAL(7, 0x23, 2, 2, 2, 2), /* HDR */
 	/* Set Preamp setting 2 (ZFR/ZCNT) */
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 219b103..256a00c 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -352,7 +352,7 @@ static int set_kernel_sq_size(struct mlx4_ib_dev *dev, struct ib_qp_cap *cap,
 	 * anymore, so we do this only if selective signaling is off.
 	 *
 	 * Further, on 32-bit platforms, we can't use vmap() to make
-	 * the QP buffer virtually contigious.  Thus we have to use
+	 * the QP buffer virtually contiguous.  Thus we have to use
 	 * constant-sized WRs to make sure a WR is always fully within
 	 * a single page-sized chunk.
 	 *
diff --git a/drivers/input/serio/hp_sdc.c b/drivers/input/serio/hp_sdc.c
index 1c9410d..bcc2d30 100644
--- a/drivers/input/serio/hp_sdc.c
+++ b/drivers/input/serio/hp_sdc.c
@@ -955,7 +955,7 @@ static int __init hp_sdc_init_hppa(struct parisc_device *d)
 	INIT_DELAYED_WORK(&moduleloader_work, request_module_delayed);
 
 	ret = hp_sdc_init();
-	/* after sucessfull initialization give SDC some time to settle
+	/* after successfull initialization give SDC some time to settle
 	 * and then load the hp_sdc_mlc upper layer driver */
 	if (!ret)
 		schedule_delayed_work(&moduleloader_work,
diff --git a/drivers/input/serio/hp_sdc_mlc.c b/drivers/input/serio/hp_sdc_mlc.c
index 820e516..7d2b820 100644
--- a/drivers/input/serio/hp_sdc_mlc.c
+++ b/drivers/input/serio/hp_sdc_mlc.c
@@ -125,7 +125,7 @@ static void hp_sdc_mlc_isr (int irq, void *dev_id,
 		break;
 
 	default:
-		printk(KERN_WARNING PREFIX "Unkown HIL Error status (%x)!\n", data);
+		printk(KERN_WARNING PREFIX "Unknown HIL Error status (%x)!\n", data);
 		break;
 	}
 
diff --git a/drivers/input/touchscreen/atmel-wm97xx.c b/drivers/input/touchscreen/atmel-wm97xx.c
index 35377f5..a12242f 100644
--- a/drivers/input/touchscreen/atmel-wm97xx.c
+++ b/drivers/input/touchscreen/atmel-wm97xx.c
@@ -59,7 +59,7 @@
 #define ATMEL_WM97XX_AC97C_IRQ		(29)
 #define ATMEL_WM97XX_GPIO_DEFAULT	(32+16) /* Pin 16 on port B. */
 #else
-#error Unkown CPU, this driver only supports AT32AP700X CPUs.
+#error Unknown CPU, this driver only supports AT32AP700X CPUs.
 #endif
 
 struct continuous {
diff --git a/drivers/input/touchscreen/mainstone-wm97xx.c b/drivers/input/touchscreen/mainstone-wm97xx.c
index 8fc3b08..6cdcf2a 100644
--- a/drivers/input/touchscreen/mainstone-wm97xx.c
+++ b/drivers/input/touchscreen/mainstone-wm97xx.c
@@ -14,7 +14,7 @@
  *
  * Notes:
  *     This is a wm97xx extended touch driver to capture touch
- *     data in a continuous manner on the Intel XScale archictecture
+ *     data in a continuous manner on the Intel XScale architecture
  *
  *  Features:
  *       - codecs supported:- WM9705, WM9712, WM9713
@@ -131,7 +131,7 @@ static int wm97xx_acc_pen_down(struct wm97xx *wm)
 	/* When the AC97 queue has been drained we need to allow time
 	 * to buffer up samples otherwise we end up spinning polling
 	 * for samples.  The controller can't have a suitably low
-	 * threashold set to use the notifications it gives.
+	 * threshold set to use the notifications it gives.
 	 */
 	schedule_timeout_uninterruptible(1);
 
diff --git a/drivers/input/touchscreen/zylonite-wm97xx.c b/drivers/input/touchscreen/zylonite-wm97xx.c
index 41e4359..eca54db 100644
--- a/drivers/input/touchscreen/zylonite-wm97xx.c
+++ b/drivers/input/touchscreen/zylonite-wm97xx.c
@@ -96,7 +96,7 @@ static int wm97xx_acc_pen_down(struct wm97xx *wm)
 	/* When the AC97 queue has been drained we need to allow time
 	 * to buffer up samples otherwise we end up spinning polling
 	 * for samples.  The controller can't have a suitably low
-	 * threashold set to use the notifications it gives.
+	 * threshold set to use the notifications it gives.
 	 */
 	msleep(1);
 
diff --git a/drivers/isdn/capi/capidrv.c b/drivers/isdn/capi/capidrv.c
index 3e6d17f..66b7d7a 100644
--- a/drivers/isdn/capi/capidrv.c
+++ b/drivers/isdn/capi/capidrv.c
@@ -830,7 +830,7 @@ static void handle_controller(_cmsg * cmsg)
 		      case 0: break;
 		      case 1: s = "unknown class"; break;
 		      case 2: s = "unknown function"; break;
-		      default: s = "unkown error"; break;
+		      default: s = "unknown error"; break;
 		   }
 		   if (s)
 	           printk(KERN_INFO "capidrv-%d: %s from controller 0x%x function %d: %s\n",
diff --git a/drivers/isdn/hardware/eicon/di.c b/drivers/isdn/hardware/eicon/di.c
index b029d13..cb14ae3 100644
--- a/drivers/isdn/hardware/eicon/di.c
+++ b/drivers/isdn/hardware/eicon/di.c
@@ -806,7 +806,7 @@ static void xdi_xlog_request (byte Adapter, byte Id,
           DELIVERY - indication entered isdn_rc function
           RNR=...  - application had returned RNR=... after the
                      look ahead callback
-          RNum=0   - aplication had not returned any buffer to copy
+          RNum=0   - application had not returned any buffer to copy
                      this indication and will copy it self
           COMPLETE - XDI had copied the data to the buffers provided
                      bu the application and is about to issue the
diff --git a/drivers/isdn/hardware/eicon/maintidi.c b/drivers/isdn/hardware/eicon/maintidi.c
index 41c26e7..534978b 100644
--- a/drivers/isdn/hardware/eicon/maintidi.c
+++ b/drivers/isdn/hardware/eicon/maintidi.c
@@ -385,7 +385,7 @@ static int SuperTraceMessageInput (void* hLib) {
                   }
                   break;
                 default:
-                  diva_mnt_internal_dprintf (0, DLI_ERR, "Unknon IDI Ind (DMA mode): %02x", Ind);
+                  diva_mnt_internal_dprintf (0, DLI_ERR, "Unknown IDI Ind (DMA mode): %02x", Ind);
               }
               p += (this_ind_length+1);
               total_length -= (4 + this_ind_length);
@@ -420,7 +420,7 @@ static int SuperTraceMessageInput (void* hLib) {
             }
             break;
           default:
-            diva_mnt_internal_dprintf (0, DLI_ERR, "Unknon IDI Ind: %02x", Ind);
+            diva_mnt_internal_dprintf (0, DLI_ERR, "Unknown IDI Ind: %02x", Ind);
         }
       }
     }
diff --git a/drivers/isdn/hardware/mISDN/hfcsusb.c b/drivers/isdn/hardware/mISDN/hfcsusb.c
index fc46a26..a64bb6c 100644
--- a/drivers/isdn/hardware/mISDN/hfcsusb.c
+++ b/drivers/isdn/hardware/mISDN/hfcsusb.c
@@ -721,7 +721,7 @@ hfcsusb_setup_bch(struct bchannel *bch, int protocol)
 	switch (protocol) {
 	case (-1):	/* used for init */
 		bch->state = -1;
-		/* fall trough */
+		/* fall through */
 	case (ISDN_P_NONE):
 		if (bch->state == ISDN_P_NONE)
 			return 0; /* already in idle state */
diff --git a/drivers/isdn/hardware/mISDN/hfcsusb.h b/drivers/isdn/hardware/mISDN/hfcsusb.h
index 43efe73..369196a 100644
--- a/drivers/isdn/hardware/mISDN/hfcsusb.h
+++ b/drivers/isdn/hardware/mISDN/hfcsusb.h
@@ -150,7 +150,7 @@ symbolic(struct hfcusb_symbolic_list list[], const int num)
 	for (i = 0; list[i].name != NULL; i++)
 		if (list[i].num == num)
 			return list[i].name;
-	return "<unkown USB Error>";
+	return "<unknown USB Error>";
 }
 
 /* USB descriptor need to contain one of the following EndPoint combination: */
diff --git a/drivers/isdn/hardware/mISDN/mISDNisar.c b/drivers/isdn/hardware/mISDN/mISDNisar.c
index de352a1..09095c7 100644
--- a/drivers/isdn/hardware/mISDN/mISDNisar.c
+++ b/drivers/isdn/hardware/mISDN/mISDNisar.c
@@ -860,7 +860,7 @@ isar_pump_statev_modem(struct isar_ch *ch, u8 devt) {
 		pr_debug("%s: pump stev GSTN CLEAR\n", ch->is->name);
 		break;
 	default:
-		pr_info("u%s: nknown pump stev %x\n", ch->is->name, devt);
+		pr_info("u%s: unknown pump stev %x\n", ch->is->name, devt);
 		break;
 	}
 }
diff --git a/drivers/isdn/hisax/hfc_usb.c b/drivers/isdn/hisax/hfc_usb.c
index a420b64..aaaeaaf 100644
--- a/drivers/isdn/hisax/hfc_usb.c
+++ b/drivers/isdn/hisax/hfc_usb.c
@@ -1086,7 +1086,7 @@ hfc_usb_l2l1(struct hisax_if *my_hisax_if, int pr, void *arg)
 			break;
 		default:
 			DBG(HFCUSB_DBG_STATES,
-			       "HFC_USB: hfc_usb_d_l2l1: unkown state : %#x", pr);
+			       "HFC_USB: hfc_usb_d_l2l1: unknown state : %#x", pr);
 			break;
 	}
 }
diff --git a/drivers/isdn/i4l/isdn_ppp.c b/drivers/isdn/i4l/isdn_ppp.c
index 2d14b64..0f4ea7d 100644
--- a/drivers/isdn/i4l/isdn_ppp.c
+++ b/drivers/isdn/i4l/isdn_ppp.c
@@ -836,7 +836,7 @@ isdn_ppp_write(int min, struct file *file, const char __user *buf, int count)
 			unsigned short hl;
 			struct sk_buff *skb;
 			/*
-			 * we need to reserve enought space in front of
+			 * we need to reserve enough space in front of
 			 * sk_buff. old call to dev_alloc_skb only reserved
 			 * 16 bytes, now we are looking what the driver want
 			 */
@@ -1326,7 +1326,7 @@ isdn_ppp_xmit(struct sk_buff *skb, struct net_device *netdev)
 		struct sk_buff *new_skb;
 	        unsigned short hl;
 		/*
-		 * we need to reserve enought space in front of
+		 * we need to reserve enough space in front of
 		 * sk_buff. old call to dev_alloc_skb only reserved
 		 * 16 bytes, now we are looking what the driver want.
 		 */
@@ -1685,7 +1685,7 @@ static void isdn_ppp_mp_receive(isdn_net_dev * net_dev, isdn_net_local * lp,
 	 *
 	 * try to accomplish several tasks:
 	 * - reassemble any complete fragment sequence (non-null 'start'
-	 *   indicates there is a continguous sequence present)
+	 *   indicates there is a contiguous sequence present)
 	 * - discard any incomplete sequences that are below minseq -- due
 	 *   to the fact that sender always increment sequence number, if there
 	 *   is an incomplete sequence below minseq, no new fragments would
diff --git a/drivers/isdn/i4l/isdn_ttyfax.c b/drivers/isdn/i4l/isdn_ttyfax.c
index 78f7660..4c41f19 100644
--- a/drivers/isdn/i4l/isdn_ttyfax.c
+++ b/drivers/isdn/i4l/isdn_ttyfax.c
@@ -470,7 +470,7 @@ isdn_tty_cmd_FCLASS2(char **p, modem_info * info)
 		}
 		return 0;
 	}
-	/* BADMUL=value - dummy 0=disable errorchk disabled (treshold multiplier) */
+	/* BADMUL=value - dummy 0=disable errorchk disabled (threshold multiplier) */
 	if (!strncmp(p[0], "BADMUL", 6)) {
 		p[0] += 6;
 		switch (*p[0]) {
diff --git a/drivers/isdn/mISDN/dsp_core.c b/drivers/isdn/mISDN/dsp_core.c
index 77ee286..43ff4d3 100644
--- a/drivers/isdn/mISDN/dsp_core.c
+++ b/drivers/isdn/mISDN/dsp_core.c
@@ -110,7 +110,7 @@
  * crossconnections and conferences via software if not possible through
  * hardware. If hardware capability is available, hardware is used.
  *
- * Echo: Is generated by CMX and is used to check performane of hard and
+ * Echo: Is generated by CMX and is used to check performance of hard and
  * software CMX.
  *
  * The CMX has special functions for conferences with one, two and more
diff --git a/drivers/isdn/mISDN/tei.c b/drivers/isdn/mISDN/tei.c
index e04bad6..6d4da60 100644
--- a/drivers/isdn/mISDN/tei.c
+++ b/drivers/isdn/mISDN/tei.c
@@ -725,7 +725,7 @@ tei_id_ver_tout_net(struct FsmInst *fi, int event, void *arg)
 	if (tm->rcnt == 1) {
 		if (*debug & DEBUG_L2_TEI)
 			tm->tei_m.printdebug(fi,
-			    "check req for tei %d sucessful\n", tm->l2->tei);
+			    "check req for tei %d successful\n", tm->l2->tei);
 		mISDN_FsmChangeState(fi, ST_TEI_NOP);
 	} else if (tm->rcnt > 1) {
 		/* duplicate assignment; remove */
diff --git a/drivers/macintosh/therm_windtunnel.c b/drivers/macintosh/therm_windtunnel.c
index 8b93644..3fbe41b 100644
--- a/drivers/macintosh/therm_windtunnel.c
+++ b/drivers/macintosh/therm_windtunnel.c
@@ -15,7 +15,7 @@
  *
  *	WARNING: This driver has only been testen on Apple's
  *	1.25 MHz Dual G4 (March 03). It is tuned for a CPU
- *	temperatur around 57 C.
+ *	temperature around 57 C.
  *
  *   Copyright (C) 2003, 2004 Samuel Rydh (samuel@ibrium.se)
  *
diff --git a/drivers/media/common/saa7146_i2c.c b/drivers/media/common/saa7146_i2c.c
index 7e8f568..48cb154 100644
--- a/drivers/media/common/saa7146_i2c.c
+++ b/drivers/media/common/saa7146_i2c.c
@@ -98,7 +98,7 @@ static int saa7146_i2c_msg_cleanup(const struct i2c_msg *m, int num, __le32 *op)
 
 		op_count++;
 
-		/* loop throgh all bytes of message i */
+		/* loop through all bytes of message i */
 		for(j = 0; j < m[i].len; j++) {
 			/* write back all bytes that could have been read */
 			m[i].buf[j] = (le32_to_cpu(op[op_count/3]) >> ((3-(op_count%3))*8));
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.h b/drivers/media/dvb/dvb-core/dvb_frontend.h
index 810f07d..52e4ce4 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.h
@@ -160,7 +160,7 @@ struct tuner_state {
  * search callback possible return status
  *
  * DVBFE_ALGO_SEARCH_SUCCESS
- * The frontend search algorithm completed and returned succesfully
+ * The frontend search algorithm completed and returned successfully
  *
  * DVBFE_ALGO_SEARCH_ASLEEP
  * The frontend search algorithm is sleeping
diff --git a/drivers/media/dvb/dvb-usb/anysee.c b/drivers/media/dvb/dvb-usb/anysee.c
index 2ae7f64..bb69f37 100644
--- a/drivers/media/dvb/dvb-usb/anysee.c
+++ b/drivers/media/dvb/dvb-usb/anysee.c
@@ -344,7 +344,7 @@ static int anysee_frontend_attach(struct dvb_usb_adapter *adap)
 	if (ret)
 		return ret;
 
-	err("Unkown Anysee version: %02x %02x %02x. "\
+	err("Unknown Anysee version: %02x %02x %02x. "\
 	    "Please report the <linux-dvb@linuxtv.org>.",
 	    hw_info[0], hw_info[1], hw_info[2]);
 
diff --git a/drivers/media/dvb/dvb-usb/dibusb-mb.c b/drivers/media/dvb/dvb-usb/dibusb-mb.c
index eeef50b..5c0126d 100644
--- a/drivers/media/dvb/dvb-usb/dibusb-mb.c
+++ b/drivers/media/dvb/dvb-usb/dibusb-mb.c
@@ -242,7 +242,7 @@ static struct dvb_usb_device_properties dibusb1_1_properties = {
 			{ &dibusb_dib3000mb_table[9],  &dibusb_dib3000mb_table[11], NULL },
 			{ &dibusb_dib3000mb_table[10], &dibusb_dib3000mb_table[12], NULL },
 		},
-		{	"Unkown USB1.1 DVB-T device ???? please report the name to the author",
+		{	"Unknown USB1.1 DVB-T device ???? please report the name to the author",
 			{ &dibusb_dib3000mb_table[13], NULL },
 			{ &dibusb_dib3000mb_table[14], NULL },
 		},
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-remote.c b/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
index edde87c..6b5ded9 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
@@ -259,7 +259,7 @@ int dvb_usb_nec_rc_key_to_event(struct dvb_usb_device *d,
 			*state = REMOTE_KEY_REPEAT;
 			break;
 		default:
-			deb_err("unkown type of remote status: %d\n",keybuf[0]);
+			deb_err("unknown type of remote status: %d\n",keybuf[0]);
 			break;
 	}
 	return 0;
diff --git a/drivers/media/dvb/dvb-usb/usb-urb.c b/drivers/media/dvb/dvb-usb/usb-urb.c
index 9da2cc9..f9702e3 100644
--- a/drivers/media/dvb/dvb-usb/usb-urb.c
+++ b/drivers/media/dvb/dvb-usb/usb-urb.c
@@ -56,7 +56,7 @@ static void usb_urb_complete(struct urb *urb)
 				stream->complete(stream, b, urb->actual_length);
 			break;
 		default:
-			err("unkown endpoint type in completition handler.");
+			err("unknown endpoint type in completition handler.");
 			return;
 	}
 	usb_submit_urb(urb,GFP_ATOMIC);
@@ -228,7 +228,7 @@ int usb_urb_init(struct usb_data_stream *stream, struct usb_data_stream_properti
 		case USB_ISOC:
 			return usb_isoc_urb_init(stream);
 		default:
-			err("unkown URB-type for data transfer.");
+			err("unknown URB-type for data transfer.");
 			return -EINVAL;
 	}
 }
diff --git a/drivers/media/dvb/frontends/au8522_decoder.c b/drivers/media/dvb/frontends/au8522_decoder.c
index 74981ee..7c6431f 100644
--- a/drivers/media/dvb/frontends/au8522_decoder.c
+++ b/drivers/media/dvb/frontends/au8522_decoder.c
@@ -315,7 +315,7 @@ static void setup_decoder_defaults(struct au8522_state *state, u8 input_mode)
 	if (input_mode == AU8522_INPUT_CONTROL_REG081H_SVIDEO_CH13 ||
 	    input_mode == AU8522_INPUT_CONTROL_REG081H_SVIDEO_CH24) {
 		/* Despite what the table says, for the HVR-950q we still need
-		   to be in CVBS mode for the S-Video input (reason uknown). */
+		   to be in CVBS mode for the S-Video input (reason unknown). */
 		/* filter_coef_type = 3; */
 		filter_coef_type = 5;
 	} else {
diff --git a/drivers/media/dvb/frontends/cx24110.c b/drivers/media/dvb/frontends/cx24110.c
index ffbcfab..00a4e8f 100644
--- a/drivers/media/dvb/frontends/cx24110.c
+++ b/drivers/media/dvb/frontends/cx24110.c
@@ -1,4 +1,4 @@
-	/*
+/*
     cx24110 - Single Chip Satellite Channel Receiver driver module
 
     Copyright (C) 2002 Peter Hettkamp <peter.hettkamp@htp-tel.de> based on
@@ -96,7 +96,7 @@ static struct {u8 reg; u8 data;} cx24110_regdata[]=
 	 {0x42,0x00}, /* @ middle bytes " */
 	 {0x43,0x00}, /* @ LSB          " */
 		      /* leave the carrier tracking loop parameters on default */
-		      /* leave the bit timing loop parameters at gefault */
+		      /* leave the bit timing loop parameters at default */
 	 {0x56,0x4d}, /* set the filtune voltage to 2.7V, as recommended by */
 		      /* the cx24108 data sheet for symbol rates above 15MS/s */
 	 {0x57,0x00}, /* @ Filter sigma delta enabled, positive */
diff --git a/drivers/media/dvb/frontends/cx24113.c b/drivers/media/dvb/frontends/cx24113.c
index 075b2b5..e9ee555 100644
--- a/drivers/media/dvb/frontends/cx24113.c
+++ b/drivers/media/dvb/frontends/cx24113.c
@@ -589,7 +589,7 @@ struct dvb_frontend *cx24113_attach(struct dvb_frontend *fe,
 		info("detected CX24113 variant\n");
 		break;
 	case REV_CX24113:
-		info("sucessfully detected\n");
+		info("successfully detected\n");
 		break;
 	default:
 		err("unsupported device id: %x\n", state->rev);
diff --git a/drivers/media/dvb/frontends/dib3000mb.c b/drivers/media/dvb/frontends/dib3000mb.c
index 136b9d2..ad4c8cf 100644
--- a/drivers/media/dvb/frontends/dib3000mb.c
+++ b/drivers/media/dvb/frontends/dib3000mb.c
@@ -154,7 +154,7 @@ static int dib3000mb_set_frontend(struct dvb_frontend* fe,
 			case BANDWIDTH_AUTO:
 				return -EOPNOTSUPP;
 			default:
-				err("unkown bandwidth value.");
+				err("unknown bandwidth value.");
 				return -EINVAL;
 		}
 	}
diff --git a/drivers/media/dvb/frontends/lgdt330x.c b/drivers/media/dvb/frontends/lgdt330x.c
index 056387b..43971e6 100644
--- a/drivers/media/dvb/frontends/lgdt330x.c
+++ b/drivers/media/dvb/frontends/lgdt330x.c
@@ -479,7 +479,7 @@ static int lgdt3302_read_status(struct dvb_frontend* fe, fe_status_t* status)
 	switch (state->current_modulation) {
 	case QAM_256:
 	case QAM_64:
-		/* Need to undestand why there are 3 lock levels here */
+		/* Need to understand why there are 3 lock levels here */
 		if ((buf[0] & 0x07) == 0x07)
 			*status |= FE_HAS_CARRIER;
 		break;
@@ -520,7 +520,7 @@ static int lgdt3303_read_status(struct dvb_frontend* fe, fe_status_t* status)
 	switch (state->current_modulation) {
 	case QAM_256:
 	case QAM_64:
-		/* Need to undestand why there are 3 lock levels here */
+		/* Need to understand why there are 3 lock levels here */
 		if ((buf[0] & 0x07) == 0x07)
 			*status |= FE_HAS_CARRIER;
 		else
diff --git a/drivers/media/dvb/frontends/stb0899_drv.c b/drivers/media/dvb/frontends/stb0899_drv.c
index a04c782..1570669 100644
--- a/drivers/media/dvb/frontends/stb0899_drv.c
+++ b/drivers/media/dvb/frontends/stb0899_drv.c
@@ -1571,7 +1571,7 @@ static enum dvbfe_search stb0899_search(struct dvb_frontend *fe, struct dvb_fron
  * stb0899_track
  * periodically check the signal level against a specified
  * threshold level and perform derotator centering.
- * called once we have a lock from a succesful search
+ * called once we have a lock from a successful search
  * event.
  *
  * Will be called periodically called to maintain the
diff --git a/drivers/media/dvb/ttpci/av7110.c b/drivers/media/dvb/ttpci/av7110.c
index 8d65c65..baf3159 100644
--- a/drivers/media/dvb/ttpci/av7110.c
+++ b/drivers/media/dvb/ttpci/av7110.c
@@ -2425,7 +2425,7 @@ static int __devinit av7110_attach(struct saa7146_dev* dev,
 		 * use 0x15 to track VPE  interrupts - increase by 1 every vpeirq() is called
 		 */
 		saa7146_write(dev, EC1SSR, (0x03<<2) | 3 );
-		/* set event counter 1 treshold to maximum allowed value        (rEC p55) */
+		/* set event counter 1 threshold to maximum allowed value        (rEC p55) */
 		saa7146_write(dev, ECT1R,  0x3fff );
 #endif
 		/* Set RPS1 Address register to point to RPS code               (r108 p42) */
@@ -2559,7 +2559,7 @@ static int __devinit av7110_attach(struct saa7146_dev* dev,
 		 * use 0x15 to track VPE  interrupts - increase by 1 every vpeirq() is called
 		 */
 		saa7146_write(dev, EC1SSR, (0x03<<2) | 3 );
-		/* set event counter 1 treshold to maximum allowed value        (rEC p55) */
+		/* set event counter 1 threshold to maximum allowed value        (rEC p55) */
 		saa7146_write(dev, ECT1R,  0x3fff );
 #endif
 		/* Setup BUDGETPATCH MAIN RPS1 "program" (p35) */
diff --git a/drivers/media/dvb/ttpci/budget-patch.c b/drivers/media/dvb/ttpci/budget-patch.c
index 6013668..9c92f9d 100644
--- a/drivers/media/dvb/ttpci/budget-patch.c
+++ b/drivers/media/dvb/ttpci/budget-patch.c
@@ -456,7 +456,7 @@ static int budget_patch_attach (struct saa7146_dev* dev, struct saa7146_pci_exte
 	// use 0x03 to track RPS1 interrupts - increase by 1 every gpio3 is toggled
 	// use 0x15 to track VPE  interrupts - increase by 1 every vpeirq() is called
 	saa7146_write(dev, EC1SSR, (0x03<<2) | 3 );
-	// set event counter 1 treshold to maximum allowed value        (rEC p55)
+	// set event counter 1 threshold to maximum allowed value        (rEC p55)
 	saa7146_write(dev, ECT1R,  0x3fff );
 #endif
 	// Fix VSYNC level
diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
index a123908..5f79acb 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -28,7 +28,7 @@
  * http://av-usbradio.sourceforge.net/index.php
  * http://sourceforge.net/projects/av-usbradio/
  * Latest release of theirs project was in 2005.
- * Probably, this driver could be improved trough using their
+ * Probably, this driver could be improved through using their
  * achievements (specifications given).
  * Also, Faidon Liambotis <paravoid@debian.org> wrote nice driver for this radio
  * in 2007. He allowed to use his driver to improve current mr800 radio driver.
diff --git a/drivers/media/video/cx231xx/cx231xx-avcore.c b/drivers/media/video/cx231xx/cx231xx-avcore.c
index 28f48f4..c217441 100644
--- a/drivers/media/video/cx231xx/cx231xx-avcore.c
+++ b/drivers/media/video/cx231xx/cx231xx-avcore.c
@@ -2414,9 +2414,11 @@ int cx231xx_gpio_i2c_read_ack(struct cx231xx *dev)
 		cx231xx_info("No ACK after %d msec -GPIO I2C failed!",
 			     nInit * 10);
 
-	/* readAck
-	   throuth clock stretch ,slave has given a SCL signal,
-	   so the SDA data can be directly read.  */
+	/*
+	 * readAck
+	 * through clock stretch, slave has given a SCL signal,
+	 * so the SDA data can be directly read.
+	 */
 	status = cx231xx_get_gpio_bit(dev, dev->gpio_dir, (u8 *)&dev->gpio_val);
 
 	if ((dev->gpio_val & 1 << dev->board.tuner_sda_gpio) == 0) {
diff --git a/drivers/media/video/cx23885/cx23885-dvb.c b/drivers/media/video/cx23885/cx23885-dvb.c
index 45e13ee..16c6a92 100644
--- a/drivers/media/video/cx23885/cx23885-dvb.c
+++ b/drivers/media/video/cx23885/cx23885-dvb.c
@@ -940,7 +940,7 @@ int cx23885_dvb_register(struct cx23885_tsport *port)
 	int err, i;
 
 	/* Here we need to allocate the correct number of frontends,
-	 * as reflected in the cards struct. The reality is that currrently
+	 * as reflected in the cards struct. The reality is that currently
 	 * no cx23885 boards support this - yet. But, if we don't modify this
 	 * code then the second frontend would never be allocated (later)
 	 * and fail with error before the attach in dvb_register().
diff --git a/drivers/media/video/cx88/cx88-core.c b/drivers/media/video/cx88/cx88-core.c
index cf63460..b354111 100644
--- a/drivers/media/video/cx88/cx88-core.c
+++ b/drivers/media/video/cx88/cx88-core.c
@@ -624,7 +624,7 @@ int cx88_reset(struct cx88_core *core)
 	/* setup image format */
 	cx_andor(MO_COLOR_CTRL, 0x4000, 0x4000);
 
-	/* setup FIFO Threshholds */
+	/* setup FIFO Thresholds */
 	cx_write(MO_PDMA_STHRSH,   0x0807);
 	cx_write(MO_PDMA_DTHRSH,   0x0807);
 
diff --git a/drivers/media/video/davinci/dm355_ccdc.c b/drivers/media/video/davinci/dm355_ccdc.c
index 4629cab..d506347 100644
--- a/drivers/media/video/davinci/dm355_ccdc.c
+++ b/drivers/media/video/davinci/dm355_ccdc.c
@@ -285,7 +285,7 @@ static int validate_ccdc_param(struct ccdc_config_params_raw *ccdcparam)
 
 	if ((ccdcparam->med_filt_thres < 0) ||
 	   (ccdcparam->med_filt_thres > CCDC_MED_FILT_THRESH)) {
-		dev_dbg(dev, "Invalid value of median filter thresold\n");
+		dev_dbg(dev, "Invalid value of median filter threshold\n");
 		return -EINVAL;
 	}
 
diff --git a/drivers/media/video/davinci/vpss.c b/drivers/media/video/davinci/vpss.c
index 6d709ca..453236b 100644
--- a/drivers/media/video/davinci/vpss.c
+++ b/drivers/media/video/davinci/vpss.c
@@ -53,7 +53,7 @@ struct vpss_hw_ops {
 	int (*enable_clock)(enum vpss_clock_sel clock_sel, int en);
 	/* select input to ccdc */
 	void (*select_ccdc_source)(enum vpss_ccdc_source_sel src_sel);
-	/* clear wbl overlflow bit */
+	/* clear wbl overflow bit */
 	int (*clear_wbl_overflow)(enum vpss_wbl_sel wbl_sel);
 };
 
diff --git a/drivers/media/video/gspca/sonixb.c b/drivers/media/video/gspca/sonixb.c
index cf3af8d..e39efb4 100644
--- a/drivers/media/video/gspca/sonixb.c
+++ b/drivers/media/video/gspca/sonixb.c
@@ -304,7 +304,7 @@ static const __u8 initOv6650[] = {
 };
 static const __u8 ov6650_sensor_init[][8] =
 {
-	/* Bright, contrast, etc are set througth SCBB interface.
+	/* Bright, contrast, etc are set through SCBB interface.
 	 * AVCAP on win2 do not send any data on this 	controls. */
 	/* Anyway, some registers appears to alter bright and constrat */
 
diff --git a/drivers/media/video/gspca/spca500.c b/drivers/media/video/gspca/spca500.c
index fab7ef8..7dbd5ee 100644
--- a/drivers/media/video/gspca/spca500.c
+++ b/drivers/media/video/gspca/spca500.c
@@ -589,7 +589,7 @@ static void spca500_reinit(struct gspca_dev *gspca_dev)
 	int err;
 	__u8 Data;
 
-	/* some unknow command from Aiptek pocket dv and family300 */
+	/* some unknown command from Aiptek pocket dv and family300 */
 
 	reg_w(gspca_dev, 0x00, 0x0d01, 0x01);
 	reg_w(gspca_dev, 0x00, 0x0d03, 0x00);
diff --git a/drivers/media/video/gspca/spca501.c b/drivers/media/video/gspca/spca501.c
index b74a342..66f9f00 100644
--- a/drivers/media/video/gspca/spca501.c
+++ b/drivers/media/video/gspca/spca501.c
@@ -1636,7 +1636,7 @@ static const __u16 spca501c_arowana_init_data[][3] = {
 	{}
 };
 
-/* Unknow camera from Ori Usbid 0x0000:0x0000 */
+/* Unknown camera from Ori Usbid 0x0000:0x0000 */
 /* Based on snoops from Ori Cohen */
 static const __u16 spca501c_mysterious_open_data[][3] = {
 	{0x02, 0x000f, 0x0005},
@@ -1945,7 +1945,7 @@ static int sd_init(struct gspca_dev *gspca_dev)
 			goto error;
 		break;
 	case MystFromOriUnknownCamera:
-		/* UnKnow Ori CMOS Camera data */
+		/* Unknown Ori CMOS Camera data */
 		if (write_vector(gspca_dev, spca501c_mysterious_open_data))
 			goto error;
 		break;
@@ -1978,7 +1978,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 		write_vector(gspca_dev, spca501c_arowana_open_data);
 		break;
 	case MystFromOriUnknownCamera:
-		/* UnKnow  CMOS Camera data */
+		/* Unknown CMOS Camera data */
 		write_vector(gspca_dev, spca501c_mysterious_init_data);
 		break;
 	default:
diff --git a/drivers/media/video/gspca/sunplus.c b/drivers/media/video/gspca/sunplus.c
index aa8f995..1a9af2e 100644
--- a/drivers/media/video/gspca/sunplus.c
+++ b/drivers/media/video/gspca/sunplus.c
@@ -631,7 +631,7 @@ static void spca504A_acknowledged_command(struct gspca_dev *gspca_dev,
 	count = 200;
 	while (--count > 0) {
 		msleep(10);
-		/* gsmart mini2 write a each wait setting 1 ms is enought */
+		/* gsmart mini2 write a each wait setting 1 ms is enough */
 /*		reg_w_riv(dev, req, idx, val); */
 		status = reg_r_12(gspca_dev, 0x01, 0x0001, 1);
 		if (status == endcode) {
diff --git a/drivers/media/video/gspca/zc3xx.c b/drivers/media/video/gspca/zc3xx.c
index cdf3357..49c3c12 100644
--- a/drivers/media/video/gspca/zc3xx.c
+++ b/drivers/media/video/gspca/zc3xx.c
@@ -7065,7 +7065,7 @@ static int sd_config(struct gspca_dev *gspca_dev,
 				break;
 			default:
 				PDEBUG(D_PROBE,
-					"Sensor UNKNOW_0 force Tas5130");
+					"Sensor UNKNOWN_0 force Tas5130");
 				sd->sensor = SENSOR_TAS5130CXX;
 			}
 			break;
diff --git a/drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h b/drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h
index 5b152ff..5fcad28 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h
+++ b/drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h
@@ -332,7 +332,7 @@ struct pvr2_hdw {
 
 	/* Bit mask of PVR2_CVAL_INPUT choices which are valid for the hardware */
 	unsigned int input_avail_mask;
-	/* Bit mask of PVR2_CVAL_INPUT choices which are currenly allowed */
+	/* Bit mask of PVR2_CVAL_INPUT choices which are currently allowed */
 	unsigned int input_allowed_mask;
 
 	/* Location of eeprom or a negative number if none */
diff --git a/drivers/media/video/s2255drv.c b/drivers/media/video/s2255drv.c
index 2c0bb06..03d3926 100644
--- a/drivers/media/video/s2255drv.c
+++ b/drivers/media/video/s2255drv.c
@@ -1980,7 +1980,7 @@ static int save_frame(struct s2255_dev *dev, struct s2255_pipeinfo *pipe_info)
 					wake_up(&dev->fw_data->wait_fw);
 					break;
 				default:
-					printk(KERN_INFO "s2255 unknwn resp\n");
+					printk(KERN_INFO "s2255 unknown resp\n");
 				}
 			default:
 				pdata++;
diff --git a/drivers/media/video/zoran/zoran.h b/drivers/media/video/zoran/zoran.h
index d439c76..cb1de7e 100644
--- a/drivers/media/video/zoran/zoran.h
+++ b/drivers/media/video/zoran/zoran.h
@@ -106,7 +106,7 @@ struct zoran_params {
 	unsigned long jpeg_markers;	/* Which markers should go into the JPEG output.
 					 * Unless you exactly know what you do, leave them untouched.
 					 * Inluding less markers will make the resulting code
-					 * smaller, but there will be fewer aplications
+					 * smaller, but there will be fewer applications
 					 * which can read it.
 					 * The presence of the APP and COM marker is
 					 * influenced by APP0_len and COM_len ONLY! */
diff --git a/drivers/message/i2o/i2o_block.c b/drivers/message/i2o/i2o_block.c
index d505b68..e39986a 100644
--- a/drivers/message/i2o/i2o_block.c
+++ b/drivers/message/i2o/i2o_block.c
@@ -940,7 +940,7 @@ static const struct block_device_operations i2o_block_fops = {
  *	Allocate memory for the i2o_block_device struct, gendisk and request
  *	queue and initialize them as far as no additional information is needed.
  *
- *	Returns a pointer to the allocated I2O Block device on succes or a
+ *	Returns a pointer to the allocated I2O Block device on success or a
  *	negative error code on failure.
  */
 static struct i2o_block_device *i2o_block_device_alloc(void)
diff --git a/drivers/message/i2o/iop.c b/drivers/message/i2o/iop.c
index 27cf4af..e5ab621 100644
--- a/drivers/message/i2o/iop.c
+++ b/drivers/message/i2o/iop.c
@@ -132,7 +132,7 @@ u32 i2o_cntxt_list_add(struct i2o_controller * c, void *ptr)
  *	Removes a previously added pointer from the context list and returns
  *	the matching context id.
  *
- *	Returns context id on succes or 0 on failure.
+ *	Returns context id on success or 0 on failure.
  */
 u32 i2o_cntxt_list_remove(struct i2o_controller * c, void *ptr)
 {
@@ -198,7 +198,7 @@ void *i2o_cntxt_list_get(struct i2o_controller *c, u32 context)
  *	@c: controller to which the context list belong
  *	@ptr: pointer to which the context id should be fetched
  *
- *	Returns context id which matches to the pointer on succes or 0 on
+ *	Returns context id which matches to the pointer on success or 0 on
  *	failure.
  */
 u32 i2o_cntxt_list_get_ptr(struct i2o_controller * c, void *ptr)
diff --git a/drivers/misc/sgi-gru/grufile.c b/drivers/misc/sgi-gru/grufile.c
index 41c8fe2..ce5eda9 100644
--- a/drivers/misc/sgi-gru/grufile.c
+++ b/drivers/misc/sgi-gru/grufile.c
@@ -92,7 +92,7 @@ static void gru_vma_close(struct vm_area_struct *vma)
 /*
  * gru_file_mmap
  *
- * Called when mmaping the device.  Initializes the vma with a fault handler
+ * Called when mmapping the device.  Initializes the vma with a fault handler
  * and private data structure necessary to allocate, track, and free the
  * underlying pages.
  */
diff --git a/drivers/mmc/host/s3cmci.c b/drivers/mmc/host/s3cmci.c
index 99b74a3..941a4d3 100644
--- a/drivers/mmc/host/s3cmci.c
+++ b/drivers/mmc/host/s3cmci.c
@@ -1360,7 +1360,7 @@ static struct mmc_host_ops s3cmci_ops = {
 
 static struct s3c24xx_mci_pdata s3cmci_def_pdata = {
 	/* This is currently here to avoid a number of if (host->pdata)
-	 * checks. Any zero fields to ensure reaonable defaults are picked. */
+	 * checks. Any zero fields to ensure reasonable defaults are picked. */
 };
 
 #ifdef CONFIG_CPU_FREQ
diff --git a/drivers/mtd/devices/slram.c b/drivers/mtd/devices/slram.c
index 3aa05cd..592016a 100644
--- a/drivers/mtd/devices/slram.c
+++ b/drivers/mtd/devices/slram.c
@@ -18,7 +18,7 @@
                 to specify the offset instead of the absolute address
 
   NOTE:
-  With slram it's only possible to map a contigous memory region. Therfore
+  With slram it's only possible to map a contiguous memory region. Therefore
   if there's a device mapped somewhere in the region specified slram will
   fail to load (see kernel log if modprobe fails).
 
diff --git a/drivers/mtd/nand/diskonchip.c b/drivers/mtd/nand/diskonchip.c
index e51c1ed..b126cf8 100644
--- a/drivers/mtd/nand/diskonchip.c
+++ b/drivers/mtd/nand/diskonchip.c
@@ -1056,7 +1056,7 @@ static struct nand_ecclayout doc200x_oobinfo = {
 };
 
 /* Find the (I)NFTL Media Header, and optionally also the mirror media header.
-   On sucessful return, buf will contain a copy of the media header for
+   On successful return, buf will contain a copy of the media header for
    further processing.  id is the string to scan for, and will presumably be
    either "ANAND" or "BNAND".  If findmirror=1, also look for the mirror media
    header.  The page #s of the found media headers are placed in mh0_page and
diff --git a/drivers/mtd/nand/nand_ecc.c b/drivers/mtd/nand/nand_ecc.c
index db7ae9d..92320a6 100644
--- a/drivers/mtd/nand/nand_ecc.c
+++ b/drivers/mtd/nand/nand_ecc.c
@@ -475,7 +475,7 @@ int __nand_correct_data(unsigned char *buf,
 		 *
 		 * The b2 shift is there to get rid of the lowest two bits.
 		 * We could also do addressbits[b2] >> 1 but for the
-		 * performace it does not make any difference
+		 * performance it does not make any difference
 		 */
 		if (eccsize_mult == 1)
 			byte_addr = (addressbits[b1] << 4) + addressbits[b0];
diff --git a/drivers/mtd/nand/s3c2410.c b/drivers/mtd/nand/s3c2410.c
index 11dc7e6..68b5b3a 100644
--- a/drivers/mtd/nand/s3c2410.c
+++ b/drivers/mtd/nand/s3c2410.c
@@ -875,7 +875,7 @@ static void s3c2410_nand_init_chip(struct s3c2410_nand_info *info,
  * @info: The controller instance.
  * @nmtd: The driver version of the MTD instance.
  *
- * This routine is called after the chip probe has succesfully completed
+ * This routine is called after the chip probe has successfully completed
  * and the relevant per-chip information updated. This call ensure that
  * we update the internal state accordingly.
  *
diff --git a/drivers/net/82596.c b/drivers/net/82596.c
index ea6b139..1663bc9 100644
--- a/drivers/net/82596.c
+++ b/drivers/net/82596.c
@@ -19,7 +19,7 @@
    TBD:
    * look at deferring rx frames rather than discarding (as per tulip)
    * handle tx ring full as per tulip
-   * performace test to tune rx_copybreak
+   * performance test to tune rx_copybreak
 
    Most of my modifications relate to the braindead big-endian
    implementation by Intel.  When the i596 is operating in
diff --git a/drivers/net/amd8111e.c b/drivers/net/amd8111e.c
index 4e6359f..766aabf 100644
--- a/drivers/net/amd8111e.c
+++ b/drivers/net/amd8111e.c
@@ -1633,8 +1633,13 @@ static int amd8111e_enable_link_change(struct amd8111e_priv* lp)
 	readl(lp->mmio + CMD7);
 	return 0;
 }
-/* This function is called when a packet transmission fails to complete within a  resonable period, on the assumption that an interrupts have been failed or the  interface is locked up. This function will reinitialize the hardware */
 
+/*
+ * This function is called when a packet transmission fails to complete
+ * within a reasonable period, on the assumption that an interrupt have
+ * failed or the interface is locked up. This function will reinitialize
+ * the hardware.
+ */
 static void amd8111e_tx_timeout(struct net_device *dev)
 {
 	struct amd8111e_priv* lp = netdev_priv(dev);
diff --git a/drivers/net/appletalk/cops.c b/drivers/net/appletalk/cops.c
index b5dc7f5..9d828ae 100644
--- a/drivers/net/appletalk/cops.c
+++ b/drivers/net/appletalk/cops.c
@@ -120,7 +120,7 @@ static int irq = 5;		/* Default IRQ */
  *      DAYNA driver mode:
  *              Dayna DL2000/DaynaTalk PC (Half Length), COPS LT-95, 
  *		Farallon PhoneNET PC III, Farallon PhoneNET PC II
- *	Other cards possibly supported mode unkown though:
+ *	Other cards possibly supported mode unknown though:
  *		Dayna DL2000 (Full length), COPS LT/M (Micro-Channel)
  *
  *	Cards NOT supported by this driver but supported by the ltpc.c
diff --git a/drivers/net/ariadne.h b/drivers/net/ariadne.h
index bb613f2..727be5c 100644
--- a/drivers/net/ariadne.h
+++ b/drivers/net/ariadne.h
@@ -244,7 +244,7 @@ struct Am79C960 {
 #define DLNKTST		0x0010	/* Disable Link Status */
 #define DAPC		0x0008	/* Disable Automatic Polarity Correction */
 #define MENDECL		0x0004	/* MENDEC Loopback Mode */
-#define LRTTSEL		0x0002	/* Low Receive Treshold/Transmit Mode Select */
+#define LRTTSEL		0x0002	/* Low Receive Threshold/Transmit Mode Select */
 #define PORTSEL1	0x0001	/* Port Select Bits */
 #define PORTSEL2	0x8000	/* Port Select Bits */
 #define INTL		0x4000	/* Internal Loopback */
diff --git a/drivers/net/atl1c/atl1c_main.c b/drivers/net/atl1c/atl1c_main.c
index 1372e9a..96506ea 100644
--- a/drivers/net/atl1c/atl1c_main.c
+++ b/drivers/net/atl1c/atl1c_main.c
@@ -1543,7 +1543,7 @@ static irqreturn_t atl1c_intr(int irq, void *data)
 		if (status & ISR_OVER)
 			if (netif_msg_intr(adapter))
 				dev_warn(&pdev->dev,
-					"TX/RX over flow (status = 0x%x)\n",
+					"TX/RX overflow (status = 0x%x)\n",
 					status & ISR_OVER);
 
 		/* link event */
diff --git a/drivers/net/benet/be_cmds.h b/drivers/net/benet/be_cmds.h
index e5f9676..21f4077 100644
--- a/drivers/net/benet/be_cmds.h
+++ b/drivers/net/benet/be_cmds.h
@@ -435,7 +435,7 @@ enum be_if_flags {
  * filtering capabilities. */
 struct be_cmd_req_if_create {
 	struct be_cmd_req_hdr hdr;
-	u32 version;		/* ignore currntly */
+	u32 version;		/* ignore currently */
 	u32 capability_flags;
 	u32 enable_flags;
 	u8 mac_addr[ETH_ALEN];
diff --git a/drivers/net/benet/be_main.c b/drivers/net/benet/be_main.c
index 876b357..c3a7db3 100644
--- a/drivers/net/benet/be_main.c
+++ b/drivers/net/benet/be_main.c
@@ -1877,7 +1877,7 @@ int be_load_fw(struct be_adapter *adapter, u8 *func)
 		goto fw_exit;
 	}
 
-	dev_info(&adapter->pdev->dev, "Firmware flashed succesfully\n");
+	dev_info(&adapter->pdev->dev, "Firmware flashed successfully\n");
 
 fw_exit:
 	release_firmware(fw);
diff --git a/drivers/net/bnx2x_reg.h b/drivers/net/bnx2x_reg.h
index aa76cba..732eafd 100644
--- a/drivers/net/bnx2x_reg.h
+++ b/drivers/net/bnx2x_reg.h
@@ -2536,7 +2536,7 @@
 /* [RC 1] A flag to indicate that overflow error occurred in one of the
    queues. */
 #define QM_REG_OVFERROR 					 0x16805c
-/* [RC 7] the Q were the qverflow occurs */
+/* [RC 7] the Q where the overflow occurs */
 #define QM_REG_OVFQNUM						 0x168058
 /* [R 16] Pause state for physical queues 15-0 */
 #define QM_REG_PAUSESTATE0					 0x168410
diff --git a/drivers/net/cxgb3/sge.c b/drivers/net/cxgb3/sge.c
index f866128..56ba872 100644
--- a/drivers/net/cxgb3/sge.c
+++ b/drivers/net/cxgb3/sge.c
@@ -1285,7 +1285,7 @@ netdev_tx_t t3_eth_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	/*
 	 * We do not use Tx completion interrupts to free DMAd Tx packets.
-	 * This is good for performamce but means that we rely on new Tx
+	 * This is good for performance but means that we rely on new Tx
 	 * packets arriving to run the destructors of completed packets,
 	 * which open up space in their sockets' send queues.  Sometimes
 	 * we do not get such new packets causing Tx to stall.  A single
diff --git a/drivers/net/e1000e/82571.c b/drivers/net/e1000e/82571.c
index d1e0563..b7ce406 100644
--- a/drivers/net/e1000e/82571.c
+++ b/drivers/net/e1000e/82571.c
@@ -282,7 +282,7 @@ static s32 e1000_init_mac_params_82571(struct e1000_adapter *adapter)
 
 	/*
 	 * Ensure that the inter-port SWSM.SMBI lock bit is clear before
-	 * first NVM or PHY acess. This should be done for single-port
+	 * first NVM or PHY access. This should be done for single-port
 	 * devices, and for one port only on dual-port devices so that
 	 * for those devices we can still use the SMBI lock to synchronize
 	 * inter-port accesses to the PHY & NVM.
@@ -1412,7 +1412,7 @@ static s32 e1000_check_for_serdes_link_82571(struct e1000_hw *hw)
 		case e1000_serdes_link_autoneg_progress:
 			/*
 			 * If the LU bit is set in the STATUS register,
-			 * autoneg has completed sucessfully. If not,
+			 * autoneg has completed successfully. If not,
 			 * try foring the link because the far end may be
 			 * available but not capable of autonegotiation.
 			 */
diff --git a/drivers/net/e1000e/lib.c b/drivers/net/e1000e/lib.c
index 99ba2b8..b065ba4 100644
--- a/drivers/net/e1000e/lib.c
+++ b/drivers/net/e1000e/lib.c
@@ -571,7 +571,7 @@ s32 e1000e_check_for_serdes_link(struct e1000_hw *hw)
 				if (!(rxcw & E1000_RXCW_IV)) {
 					mac->serdes_has_link = true;
 					hw_dbg(hw, "SERDES: Link up - autoneg "
-					   "completed sucessfully.\n");
+					   "completed successfully.\n");
 				} else {
 					mac->serdes_has_link = false;
 					hw_dbg(hw, "SERDES: Link down - invalid"
diff --git a/drivers/net/ehea/ehea_ethtool.c b/drivers/net/ehea/ehea_ethtool.c
index d768852..75b099c 100644
--- a/drivers/net/ehea/ehea_ethtool.c
+++ b/drivers/net/ehea/ehea_ethtool.c
@@ -118,7 +118,7 @@ doit:
 	ret = ehea_set_portspeed(port, sp);
 
 	if (!ret)
-		ehea_info("%s: Port speed succesfully set: %dMbps "
+		ehea_info("%s: Port speed successfully set: %dMbps "
 			  "%s Duplex",
 			  port->netdev->name, port->port_speed,
 			  port->full_duplex == 1 ? "Full" : "Half");
@@ -134,7 +134,7 @@ static int ehea_nway_reset(struct net_device *dev)
 	ret = ehea_set_portspeed(port, EHEA_SPEED_AUTONEG);
 
 	if (!ret)
-		ehea_info("%s: Port speed succesfully set: %dMbps "
+		ehea_info("%s: Port speed successfully set: %dMbps "
 			  "%s Duplex",
 			  port->netdev->name, port->port_speed,
 			  port->full_duplex == 1 ? "Full" : "Half");
diff --git a/drivers/net/hamradio/baycom_ser_fdx.c b/drivers/net/hamradio/baycom_ser_fdx.c
index ed60fd6..0cab992 100644
--- a/drivers/net/hamradio/baycom_ser_fdx.c
+++ b/drivers/net/hamradio/baycom_ser_fdx.c
@@ -35,7 +35,7 @@
  *          driver only supports standard serial hardware (8250, 16450, 16550A)
  *
  *          This modem usually draws its supply current out of the otherwise unused
- *          TXD pin of the serial port. Thus a contignuous stream of 0x00-bytes
+ *          TXD pin of the serial port. Thus a contiguous stream of 0x00-bytes
  *          is transmitted to achieve a positive supply voltage.
  *
  *  hsk:    This is a 4800 baud FSK modem, designed for TNC use. It works fine
diff --git a/drivers/net/iseries_veth.c b/drivers/net/iseries_veth.c
index aa7286b..8739ba8 100644
--- a/drivers/net/iseries_veth.c
+++ b/drivers/net/iseries_veth.c
@@ -1384,7 +1384,7 @@ static inline void veth_build_dma_list(struct dma_chunk *list,
 	unsigned long done;
 	int i = 1;
 
-	/* FIXME: skbs are continguous in real addresses.  Do we
+	/* FIXME: skbs are contiguous in real addresses.  Do we
 	 * really need to break it into PAGE_SIZE chunks, or can we do
 	 * it just at the granularity of iSeries real->absolute
 	 * mapping?  Indeed, given the way the allocator works, can we
diff --git a/drivers/net/lasi_82596.c b/drivers/net/lasi_82596.c
index a0c5785..b77238d 100644
--- a/drivers/net/lasi_82596.c
+++ b/drivers/net/lasi_82596.c
@@ -47,7 +47,7 @@
    TBD:
    * look at deferring rx frames rather than discarding (as per tulip)
    * handle tx ring full as per tulip
-   * performace test to tune rx_copybreak
+   * performance test to tune rx_copybreak
 
    Most of my modifications relate to the braindead big-endian
    implementation by Intel.  When the i596 is operating in
diff --git a/drivers/net/lib82596.c b/drivers/net/lib82596.c
index 51e11c3..c0dbfc1 100644
--- a/drivers/net/lib82596.c
+++ b/drivers/net/lib82596.c
@@ -47,7 +47,7 @@
    TBD:
    * look at deferring rx frames rather than discarding (as per tulip)
    * handle tx ring full as per tulip
-   * performace test to tune rx_copybreak
+   * performance test to tune rx_copybreak
 
    Most of my modifications relate to the braindead big-endian
    implementation by Intel.  When the i596 is operating in
diff --git a/drivers/net/mlx4/en_rx.c b/drivers/net/mlx4/en_rx.c
index 03b781a..829b9ec 100644
--- a/drivers/net/mlx4/en_rx.c
+++ b/drivers/net/mlx4/en_rx.c
@@ -204,7 +204,7 @@ static void mlx4_en_free_rx_desc(struct mlx4_en_priv *priv,
 		en_dbg(DRV, priv, "Freeing fragment:%d\n", nr);
 		dma = be64_to_cpu(rx_desc->data[nr].addr);
 
-		en_dbg(DRV, priv, "Unmaping buffer at dma:0x%llx\n", (u64) dma);
+		en_dbg(DRV, priv, "Unmapping buffer at dma:0x%llx\n", (u64) dma);
 		pci_unmap_single(mdev->pdev, dma, skb_frags[nr].size,
 				 PCI_DMA_FROMDEVICE);
 		put_page(skb_frags[nr].page);
diff --git a/drivers/net/mlx4/en_tx.c b/drivers/net/mlx4/en_tx.c
index 8c72799..3d1396a 100644
--- a/drivers/net/mlx4/en_tx.c
+++ b/drivers/net/mlx4/en_tx.c
@@ -47,7 +47,7 @@ enum {
 static int inline_thold __read_mostly = MAX_INLINE;
 
 module_param_named(inline_thold, inline_thold, int, 0444);
-MODULE_PARM_DESC(inline_thold, "treshold for using inline data");
+MODULE_PARM_DESC(inline_thold, "threshold for using inline data");
 
 int mlx4_en_create_tx_ring(struct mlx4_en_priv *priv,
 			   struct mlx4_en_tx_ring *ring, u32 size,
diff --git a/drivers/net/mlx4/mlx4_en.h b/drivers/net/mlx4/mlx4_en.h
index 4376147..82c3ebc 100644
--- a/drivers/net/mlx4/mlx4_en.h
+++ b/drivers/net/mlx4/mlx4_en.h
@@ -162,7 +162,7 @@ enum {
 #define MLX4_EN_DEF_RX_PAUSE	1
 #define MLX4_EN_DEF_TX_PAUSE	1
 
-/* Interval between sucessive polls in the Tx routine when polling is used
+/* Interval between successive polls in the Tx routine when polling is used
    instead of interrupts (in per-core Tx rings) - should be power of 2 */
 #define MLX4_EN_TX_POLL_MODER	16
 #define MLX4_EN_TX_POLL_TIMEOUT	(HZ / 4)
diff --git a/drivers/net/ps3_gelic_net.c b/drivers/net/ps3_gelic_net.c
index b211613..86fde1a 100644
--- a/drivers/net/ps3_gelic_net.c
+++ b/drivers/net/ps3_gelic_net.c
@@ -296,7 +296,7 @@ static void gelic_card_reset_chain(struct gelic_card *card,
  * @card: card structure
  * @descr: descriptor to re-init
  *
- * return 0 on succes, <0 on failure
+ * return 0 on success, <0 on failure
  *
  * allocates a new rx skb, iommu-maps it and attaches it to the descriptor.
  * Activate the descriptor state-wise
diff --git a/drivers/net/sfc/falcon.c b/drivers/net/sfc/falcon.c
index c049364..70c1232 100644
--- a/drivers/net/sfc/falcon.c
+++ b/drivers/net/sfc/falcon.c
@@ -1264,7 +1264,7 @@ int falcon_flush_queues(struct efx_nic *efx)
 		msleep(FALCON_FLUSH_INTERVAL);
 		falcon_poll_flush_events(efx);
 
-		/* Check if every queue has been succesfully flushed */
+		/* Check if every queue has been successfully flushed */
 		outstanding = false;
 		efx_for_each_tx_queue(tx_queue, efx)
 			outstanding |= !tx_queue->flushed;
diff --git a/drivers/net/sis900.c b/drivers/net/sis900.c
index c072f7f..9d94a14 100644
--- a/drivers/net/sis900.c
+++ b/drivers/net/sis900.c
@@ -1760,7 +1760,7 @@ static int sis900_rx(struct net_device *net_dev)
 				sis_priv->rx_ring[entry].bufptr, RX_BUF_SIZE,
 				PCI_DMA_FROMDEVICE);
 
-			/* refill the Rx buffer, what if there is not enought
+			/* refill the Rx buffer, what if there is not enough
 			 * memory for new socket buffer ?? */
 			if ((skb = dev_alloc_skb(RX_BUF_SIZE)) == NULL) {
 				/*
@@ -1775,7 +1775,7 @@ static int sis900_rx(struct net_device *net_dev)
 			}
 
 			/* This situation should never happen, but due to
-			   some unknow bugs, it is possible that
+			   some unknown bugs, it is possible that
 			   we are working on NULL sk_buff :-( */
 			if (sis_priv->rx_skbuff[entry] == NULL) {
 				if (netif_msg_rx_err(sis_priv))
diff --git a/drivers/net/skfp/h/smc.h b/drivers/net/skfp/h/smc.h
index 1758d95..026a83b 100644
--- a/drivers/net/skfp/h/smc.h
+++ b/drivers/net/skfp/h/smc.h
@@ -393,10 +393,10 @@ struct smt_config {
 					 */
 	u_long	mac_d_max ;		/* MAC : D_Max timer value */
 
-	u_long lct_short ;		/* LCT : error threshhold */
-	u_long lct_medium ;		/* LCT : error threshhold */
-	u_long lct_long ;		/* LCT : error threshhold */
-	u_long lct_extended ;		/* LCT : error threshhold */
+	u_long lct_short ;		/* LCT : error threshold */
+	u_long lct_medium ;		/* LCT : error threshold */
+	u_long lct_long ;		/* LCT : error threshold */
+	u_long lct_extended ;		/* LCT : error threshold */
 } ;
 
 #ifdef	DEBUG
diff --git a/drivers/net/skfp/skfddi.c b/drivers/net/skfp/skfddi.c
index b27156e..db216a7 100644
--- a/drivers/net/skfp/skfddi.c
+++ b/drivers/net/skfp/skfddi.c
@@ -1002,7 +1002,7 @@ static int skfp_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 		}
 		break;
 	default:
-		printk("ioctl for %s: unknow cmd: %04x\n", dev->name, ioc.cmd);
+		printk("ioctl for %s: unknown cmd: %04x\n", dev->name, ioc.cmd);
 		status = -EOPNOTSUPP;
 
 	}			// switch
diff --git a/drivers/net/smsc911x.c b/drivers/net/smsc911x.c
index ccdd196..4a00940 100644
--- a/drivers/net/smsc911x.c
+++ b/drivers/net/smsc911x.c
@@ -816,7 +816,7 @@ static int smsc911x_mii_probe(struct net_device *dev)
 	SMSC_TRACE(HW, "Passed Loop Back Test");
 #endif				/* USE_PHY_WORK_AROUND */
 
-	SMSC_TRACE(HW, "phy initialised succesfully");
+	SMSC_TRACE(HW, "phy initialised successfully");
 	return 0;
 }
 
diff --git a/drivers/net/smsc911x.h b/drivers/net/smsc911x.h
index b5716bd..016360c 100644
--- a/drivers/net/smsc911x.h
+++ b/drivers/net/smsc911x.h
@@ -30,7 +30,7 @@
 #define SMSC_NAPI_WEIGHT	16
 
 /* implements a PHY loopback test at initialisation time, to ensure a packet
- * can be succesfully looped back */
+ * can be successfully looped back */
 #define USE_PHY_WORK_AROUND
 
 #define DPRINTK(nlevel, klevel, fmt, args...) \
diff --git a/drivers/net/spider_net.c b/drivers/net/spider_net.c
index 90e663f..40b51e6 100644
--- a/drivers/net/spider_net.c
+++ b/drivers/net/spider_net.c
@@ -409,7 +409,7 @@ spider_net_free_rx_chain_contents(struct spider_net_card *card)
  * @card: card structure
  * @descr: descriptor to re-init
  *
- * Return 0 on succes, <0 on failure.
+ * Return 0 on success, <0 on failure.
  *
  * Allocates a new rx skb, iommu-maps it and attaches it to the
  * descriptor. Mark the descriptor as activated, ready-to-use.
diff --git a/drivers/net/stmmac/gmac.c b/drivers/net/stmmac/gmac.c
index b624bb5..52586ee 100644
--- a/drivers/net/stmmac/gmac.c
+++ b/drivers/net/stmmac/gmac.c
@@ -112,7 +112,7 @@ static void gmac_dma_operation_mode(unsigned long ioaddr, int txmode,
 			      " (threshold = %d)\n", txmode);
 		csr6 &= ~DMA_CONTROL_TSF;
 		csr6 &= DMA_CONTROL_TC_TX_MASK;
-		/* Set the transmit threashold */
+		/* Set the transmit threshold */
 		if (txmode <= 32)
 			csr6 |= DMA_CONTROL_TTC_32;
 		else if (txmode <= 64)
diff --git a/drivers/net/stmmac/gmac.h b/drivers/net/stmmac/gmac.h
index 684a363..2e82d6c 100644
--- a/drivers/net/stmmac/gmac.h
+++ b/drivers/net/stmmac/gmac.h
@@ -154,14 +154,14 @@ enum rx_tx_priority_ratio {
 #define DMA_CONTROL_DT		0x04000000 /* Disable Drop TCP/IP csum error */
 #define DMA_CONTROL_RSF		0x02000000 /* Receive Store and Forward */
 #define DMA_CONTROL_DFF		0x01000000 /* Disaable flushing */
-/* Theshold for Activating the FC */
+/* Threshold for Activating the FC */
 enum rfa {
 	act_full_minus_1 = 0x00800000,
 	act_full_minus_2 = 0x00800200,
 	act_full_minus_3 = 0x00800400,
 	act_full_minus_4 = 0x00800600,
 };
-/* Theshold for Deactivating the FC */
+/* Threshold for Deactivating the FC */
 enum rfd {
 	deac_full_minus_1 = 0x00400000,
 	deac_full_minus_2 = 0x00400800,
diff --git a/drivers/net/tokenring/smctr.c b/drivers/net/tokenring/smctr.c
index ebda61b..78e12b5 100644
--- a/drivers/net/tokenring/smctr.c
+++ b/drivers/net/tokenring/smctr.c
@@ -426,7 +426,7 @@ static int smctr_alloc_shared_memory(struct net_device *dev)
         smctr_malloc(dev, 1L);
 
         /* Allocate Non-MAC receive data buffers.
-         * To guarantee a minimum of 256 contigous memory to
+         * To guarantee a minimum of 256 contiguous memory to
          * UM_Receive_Packet's lookahead pointer, before a page
          * change or ring end is encountered, place each rx buffer on
          * a 256 byte boundary.
diff --git a/drivers/net/ucc_geth.c b/drivers/net/ucc_geth.c
index 4469f24..5e9adba 100644
--- a/drivers/net/ucc_geth.c
+++ b/drivers/net/ucc_geth.c
@@ -3798,7 +3798,7 @@ static int ucc_geth_probe(struct of_device* ofdev, const struct of_device_id *ma
 		prop = of_get_property(np, "tx-clock", NULL);
 		if (!prop) {
 			printk(KERN_ERR
-				"ucc_geth: mising tx-clock-name property\n");
+				"ucc_geth: missing tx-clock-name property\n");
 			return -EINVAL;
 		}
 		if ((*prop < QE_CLK_NONE) || (*prop > QE_CLK24)) {
diff --git a/drivers/net/ucc_geth.h b/drivers/net/ucc_geth.h
index 03a6ca0..a007e2a 100644
--- a/drivers/net/ucc_geth.h
+++ b/drivers/net/ucc_geth.h
@@ -80,16 +80,16 @@ struct ucc_geth {
 				   frames) received that were between 128
 				   (Including FCS length==4) and 255 octets */
 	u32 txok;		/* Total number of octets residing in frames
-				   that where involved in succesfull
+				   that where involved in successfull
 				   transmission */
 	u16 txcf;		/* Total number of PAUSE control frames
 				   transmitted by this MAC */
 	u8 res4[0x2];
 	u32 tmca;		/* Total number of frames that were transmitted
-				   succesfully with the group address bit set
+				   successfully with the group address bit set
 				   that are not broadcast frames */
 	u32 tbca;		/* Total number of frames transmitted
-				   succesfully that had destination address
+				   successfully that had destination address
 				   field equal to the broadcast address */
 	u32 rxfok;		/* Total number of frames received OK */
 	u32 rxbok;		/* Total number of octets received OK */
@@ -98,9 +98,9 @@ struct ucc_geth {
 				   HW because it includes octets in frames that
 				   never even reach the UCC */
 	u32 rmca;		/* Total number of frames that were received
-				   succesfully with the group address bit set
+				   successfully with the group address bit set
 				   that are not broadcast frames */
-	u32 rbca;		/* Total number of frames received succesfully
+	u32 rbca;		/* Total number of frames received successfully
 				   that had destination address equal to the
 				   broadcast address */
 	u32 scar;		/* Statistics carry register */
@@ -759,15 +759,15 @@ struct ucc_geth_hardware_statistics {
 				   frames) received that were between 128
 				   (Including FCS length==4) and 255 octets */
 	u32 txok;		/* Total number of octets residing in frames
-				   that where involved in succesfull
+				   that where involved in successfull
 				   transmission */
 	u16 txcf;		/* Total number of PAUSE control frames
 				   transmitted by this MAC */
 	u32 tmca;		/* Total number of frames that were transmitted
-				   succesfully with the group address bit set
+				   successfully with the group address bit set
 				   that are not broadcast frames */
 	u32 tbca;		/* Total number of frames transmitted
-				   succesfully that had destination address
+				   successfully that had destination address
 				   field equal to the broadcast address */
 	u32 rxfok;		/* Total number of frames received OK */
 	u32 rxbok;		/* Total number of octets received OK */
@@ -776,9 +776,9 @@ struct ucc_geth_hardware_statistics {
 				   HW because it includes octets in frames that
 				   never even reach the UCC */
 	u32 rmca;		/* Total number of frames that were received
-				   succesfully with the group address bit set
+				   successfully with the group address bit set
 				   that are not broadcast frames */
-	u32 rbca;		/* Total number of frames received succesfully
+	u32 rbca;		/* Total number of frames received successfully
 				   that had destination address equal to the
 				   broadcast address */
 } __attribute__ ((packed));
diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index c6c9222..0c3c738 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -748,7 +748,7 @@ static int smsc95xx_phy_initialize(struct usbnet *dev)
 	mii_nway_restart(&dev->mii);
 
 	if (netif_msg_ifup(dev))
-		devdbg(dev, "phy initialised succesfully");
+		devdbg(dev, "phy initialised successfully");
 	return 0;
 }
 
diff --git a/drivers/net/wan/lmc/lmc_main.c b/drivers/net/wan/lmc/lmc_main.c
index 7ea71b3..ee784e0 100644
--- a/drivers/net/wan/lmc/lmc_main.c
+++ b/drivers/net/wan/lmc/lmc_main.c
@@ -927,7 +927,7 @@ static int __devinit lmc_init_one(struct pci_dev *pdev,
         sc->lmc_media = &lmc_t1_media;
         break;
     default:
-	printk(KERN_WARNING "%s: LMC UNKOWN CARD!\n", dev->name);
+	printk(KERN_WARNING "%s: LMC UNKNOWN CARD!\n", dev->name);
         break;
     }
 
diff --git a/drivers/net/wimax/i2400m/rx.c b/drivers/net/wimax/i2400m/rx.c
index 07c32e6..99d2747 100644
--- a/drivers/net/wimax/i2400m/rx.c
+++ b/drivers/net/wimax/i2400m/rx.c
@@ -1114,7 +1114,7 @@ error:
  * device. See the file header for the format. Run all checks on the
  * buffer header, then run over each payload's descriptors, verify
  * their consistency and act on each payload's contents.  If
- * everything is succesful, update the device's statistics.
+ * everything is successful, update the device's statistics.
  *
  * Note: You need to set the skb to contain only the length of the
  * received buffer; for that, use skb_trim(skb, RECEIVED_SIZE).
diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 1a039f2..6f04cc7 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -117,7 +117,7 @@ static unsigned int ath5k_hw_rfb_op(struct ath5k_hw *ah,
 
 /*
  * This code is used to optimize rf gain on different environments
- * (temprature mostly) based on feedback from a power detector.
+ * (temperature mostly) based on feedback from a power detector.
  *
  * It's only used on RF5111 and RF5112, later RF chips seem to have
  * auto adjustment on hw -notice they have a much smaller BANK 7 and
@@ -2675,7 +2675,7 @@ ath5k_setup_channel_powertable(struct ath5k_hw *ah,
 		/* Fill curves in reverse order
 		 * from lower power (max gain)
 		 * to higher power. Use curve -> idx
-		 * backmaping we did on eeprom init */
+		 * backmapping we did on eeprom init */
 		u8 idx = pdg_curve_to_idx[pdg];
 
 		/* Grab the needed curves by index */
@@ -2777,7 +2777,7 @@ ath5k_setup_channel_powertable(struct ath5k_hw *ah,
 	/* Now we have a set of curves for this
 	 * channel on tmpL (x range is table_max - table_min
 	 * and y values are tmpL[pdg][]) sorted in the same
-	 * order as EEPROM (because we've used the backmaping).
+	 * order as EEPROM (because we've used the backmapping).
 	 * So for RF5112 it's from higher power to lower power
 	 * and for RF2413 it's from lower power to higher power.
 	 * For RF5111 we only have one curve. */
diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 1895d63..0a35ee6 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -969,7 +969,7 @@ static bool ath_rc_update_per(struct ath_softc *sc,
 				 * Since this probe succeeded, we allow the next
 				 * probe twice as soon.  This allows the maxRate
 				 * to move up faster if the probes are
-				 * succesful.
+				 * successful.
 				 */
 				ath_rc_priv->probe_time =
 					now_msec - rate_table->probe_interval / 2;
diff --git a/drivers/net/wireless/ipw2x00/ipw2100.c b/drivers/net/wireless/ipw2x00/ipw2100.c
index 240cff1..46e0528 100644
--- a/drivers/net/wireless/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/ipw2x00/ipw2100.c
@@ -551,7 +551,7 @@ static int ipw2100_get_ordinal(struct ipw2100_priv *priv, u32 ord,
 		/* get number of entries */
 		field_count = *(((u16 *) & field_info) + 1);
 
-		/* abort if no enought memory */
+		/* abort if no enough memory */
 		total_length = field_len * field_count;
 		if (total_length > *len) {
 			*len = total_length;
@@ -3044,7 +3044,7 @@ static void ipw2100_tx_send_data(struct ipw2100_priv *priv)
 			     IPW_MAX_BDS)) {
 			/* TODO: Support merging buffers if more than
 			 * IPW_MAX_BDS are used */
-			IPW_DEBUG_INFO("%s: Maximum BD theshold exceeded.  "
+			IPW_DEBUG_INFO("%s: Maximum BD threshold exceeded.  "
 				       "Increase fragmentation level.\n",
 				       priv->net_dev->name);
 		}
@@ -6820,7 +6820,7 @@ static int ipw2100_wx_get_range(struct net_device *dev,
 	range->max_qual.updated = 7;	/* Updated all three */
 
 	range->avg_qual.qual = 70;	/* > 8% missed beacons is 'bad' */
-	/* TODO: Find real 'good' to 'bad' threshol value for RSSI */
+	/* TODO: Find real 'good' to 'bad' threshold value for RSSI */
 	range->avg_qual.level = 20 + IPW2100_RSSI_TO_DBM;
 	range->avg_qual.noise = 0;
 	range->avg_qual.updated = 7;	/* Updated all three */
diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index 827824d..d2b5630 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -787,7 +787,7 @@ static int ipw_get_ordinal(struct ipw_priv *priv, u32 ord, void *val, u32 * len)
 		/* get number of entries */
 		field_count = *(((u16 *) & field_info) + 1);
 
-		/* abort if not enought memory */
+		/* abort if not enough memory */
 		total_len = field_len * field_count;
 		if (total_len > *len) {
 			*len = total_len;
@@ -7751,7 +7751,7 @@ static void ipw_rebuild_decrypted_skb(struct ipw_priv *priv,
 	case SEC_LEVEL_0:
 		break;
 	default:
-		printk(KERN_ERR "Unknow security level %d\n",
+		printk(KERN_ERR "Unknown security level %d\n",
 		       priv->ieee->sec.level);
 		break;
 	}
@@ -8917,7 +8917,7 @@ static int ipw_wx_get_range(struct net_device *dev,
 	range->max_qual.updated = 7;	/* Updated all three */
 
 	range->avg_qual.qual = 70;
-	/* TODO: Find real 'good' to 'bad' threshol value for RSSI */
+	/* TODO: Find real 'good' to 'bad' threshold value for RSSI */
 	range->avg_qual.level = 0;	/* FIXME to real average level */
 	range->avg_qual.noise = 0;
 	range->avg_qual.updated = 7;	/* Updated all three */
@@ -10290,7 +10290,7 @@ static int ipw_tx_skb(struct ipw_priv *priv, struct libipw_txb *txb,
 		case SEC_LEVEL_0:
 			break;
 		default:
-			printk(KERN_ERR "Unknow security level %d\n",
+			printk(KERN_ERR "Unknown security level %d\n",
 			       priv->ieee->sec.level);
 			break;
 		}
diff --git a/drivers/net/wireless/ipw2x00/libipw_module.c b/drivers/net/wireless/ipw2x00/libipw_module.c
index a0e9f6a..7a072e1 100644
--- a/drivers/net/wireless/ipw2x00/libipw_module.c
+++ b/drivers/net/wireless/ipw2x00/libipw_module.c
@@ -199,7 +199,7 @@ struct net_device *alloc_ieee80211(int sizeof_priv, int monitor)
 	ieee->host_decrypt = 1;
 	ieee->host_mc_decrypt = 1;
 
-	/* Host fragementation in Open mode. Default is enabled.
+	/* Host fragmentation in Open mode. Default is enabled.
 	 * Note: host fragmentation is always enabled if host encryption
 	 * is enabled. For cards can do hardware encryption, they must do
 	 * hardware fragmentation as well. So we don't need a variable
diff --git a/drivers/net/wireless/iwmc3200wifi/hal.c b/drivers/net/wireless/iwmc3200wifi/hal.c
index c430418..d13c885 100644
--- a/drivers/net/wireless/iwmc3200wifi/hal.c
+++ b/drivers/net/wireless/iwmc3200wifi/hal.c
@@ -411,7 +411,7 @@ static void iwm_build_lmac_hdr(struct iwm_priv *iwm, struct iwm_lmac_hdr *hdr,
 /*
  * iwm_hal_send_host_cmd(): sends commands to the UMAC or the LMAC.
  * Sending command to the LMAC is equivalent to sending a
- * regular UMAC command with the LMAC passtrough or the LMAC
+ * regular UMAC command with the LMAC passthrough or the LMAC
  * wrapper UMAC command IDs.
  */
 int iwm_hal_send_host_cmd(struct iwm_priv *iwm,
diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
index 771a301..8ddb51a 100644
--- a/drivers/net/wireless/iwmc3200wifi/rx.c
+++ b/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -1448,7 +1448,7 @@ static void iwm_rx_process_packet(struct iwm_priv *iwm,
 		kfree_skb(packet->skb);
 		break;
 	default:
-		IWM_ERR(iwm, "Unknow ticket action: %d\n",
+		IWM_ERR(iwm, "Unknown ticket action: %d\n",
 			le16_to_cpu(ticket_node->ticket->action));
 		kfree_skb(packet->skb);
 	}
diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index 485a8d4..afe6abe 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -934,7 +934,7 @@ static int if_sdio_probe(struct sdio_func *func,
 	}
 
 	if (i == ARRAY_SIZE(if_sdio_models)) {
-		lbs_pr_err("unkown card model 0x%x\n", card->model);
+		lbs_pr_err("unknown card model 0x%x\n", card->model);
 		ret = -ENODEV;
 		goto free;
 	}
diff --git a/drivers/net/wireless/prism54/isl_ioctl.c b/drivers/net/wireless/prism54/isl_ioctl.c
index bc08464..f7f5c79 100644
--- a/drivers/net/wireless/prism54/isl_ioctl.c
+++ b/drivers/net/wireless/prism54/isl_ioctl.c
@@ -1897,7 +1897,7 @@ prism54_get_mac(struct net_device *ndev, struct iw_request_info *info,
 	return 0;
 }
 
-/* Setting policy also clears the MAC acl, even if we don't change the defaut
+/* Setting policy also clears the MAC acl, even if we don't change the default
  * policy
  */
 
@@ -2323,7 +2323,7 @@ prism54_process_trap_helper(islpci_private *priv, enum oid_num_t oid,
 
 	case DOT11_OID_BEACON:
 		send_formatted_event(priv,
-				     "Received a beacon from an unkown AP",
+				     "Received a beacon from an unknown AP",
 				     mlme, 0);
 		break;
 
diff --git a/drivers/net/wireless/rt2x00/rt2400pci.h b/drivers/net/wireless/rt2x00/rt2400pci.h
index ccd6441..aced057 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.h
+++ b/drivers/net/wireless/rt2x00/rt2400pci.h
@@ -35,7 +35,7 @@
 
 /*
  * Signal information.
- * Defaul offset is required for RSSI <-> dBm conversion.
+ * Default offset is required for RSSI <-> dBm conversion.
  */
 #define DEFAULT_RSSI_OFFSET		100
 
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.h b/drivers/net/wireless/rt2x00/rt2500pci.h
index 54d3795..3db9041 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.h
+++ b/drivers/net/wireless/rt2x00/rt2500pci.h
@@ -46,7 +46,7 @@
 
 /*
  * Signal information.
- * Defaul offset is required for RSSI <-> dBm conversion.
+ * Default offset is required for RSSI <-> dBm conversion.
  */
 #define DEFAULT_RSSI_OFFSET		121
 
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.h b/drivers/net/wireless/rt2x00/rt2500usb.h
index b01edca..d300082 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.h
+++ b/drivers/net/wireless/rt2x00/rt2500usb.h
@@ -46,7 +46,7 @@
 
 /*
  * Signal information.
- * Defaul offset is required for RSSI <-> dBm conversion.
+ * Default offset is required for RSSI <-> dBm conversion.
  */
 #define DEFAULT_RSSI_OFFSET		120
 
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.h b/drivers/net/wireless/rt2x00/rt2800usb.h
index 4d9991c..7c61d5b 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.h
+++ b/drivers/net/wireless/rt2x00/rt2800usb.h
@@ -61,7 +61,7 @@
 
 /*
  * Signal information.
- * Defaul offset is required for RSSI <-> dBm conversion.
+ * Default offset is required for RSSI <-> dBm conversion.
  */
 #define DEFAULT_RSSI_OFFSET		120 /* FIXME */
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index f02b48a..f8075f8 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -200,7 +200,7 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
 	 * Obtain the status about this packet.
 	 * Note that when the status is 0 it does not mean the
 	 * frame was send out correctly. It only means the frame
-	 * was succesfully pushed to the hardware, we have no
+	 * was successfully pushed to the hardware, we have no
 	 * way to determine the transmission status right now.
 	 * (Only indirectly by looking at the failed TX counters
 	 * in the register).
diff --git a/drivers/net/wireless/rt2x00/rt61pci.h b/drivers/net/wireless/rt2x00/rt61pci.h
index 93eb699..77b5116 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.h
+++ b/drivers/net/wireless/rt2x00/rt61pci.h
@@ -37,7 +37,7 @@
 
 /*
  * Signal information.
- * Defaul offset is required for RSSI <-> dBm conversion.
+ * Default offset is required for RSSI <-> dBm conversion.
  */
 #define DEFAULT_RSSI_OFFSET		120
 
diff --git a/drivers/net/wireless/rt2x00/rt73usb.h b/drivers/net/wireless/rt2x00/rt73usb.h
index 81fe0be..e194332 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.h
+++ b/drivers/net/wireless/rt2x00/rt73usb.h
@@ -37,7 +37,7 @@
 
 /*
  * Signal information.
- * Defaul offset is required for RSSI <-> dBm conversion.
+ * Default offset is required for RSSI <-> dBm conversion.
  */
 #define DEFAULT_RSSI_OFFSET		120
 
diff --git a/drivers/net/wireless/wavelan_cs.c b/drivers/net/wireless/wavelan_cs.c
index 431a20e..b3b0b5b 100644
--- a/drivers/net/wireless/wavelan_cs.c
+++ b/drivers/net/wireless/wavelan_cs.c
@@ -4011,7 +4011,7 @@ wavelan_interrupt(int		irq,
 #endif
 
   /* Prevent reentrancy. We need to do that because we may have
-   * multiple interrupt handler running concurently.
+   * multiple interrupt handler running concurrently.
    * It is safe because interrupts are disabled before aquiring
    * the spinlock. */
   spin_lock(&lp->spinlock);
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index 6d66635..2b7f965 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -312,7 +312,7 @@ static void tx_status(struct ieee80211_hw *hw, struct sk_buff *skb,
  * zd_mac_tx_failed - callback for failed frames
  * @dev: the mac80211 wireless device
  *
- * This function is called if a frame couldn't be succesfully be
+ * This function is called if a frame couldn't be successfully be
  * transferred. The first frame from the tx queue, will be selected and
  * reported as error to the upper layers.
  */
diff --git a/drivers/parisc/ccio-dma.c b/drivers/parisc/ccio-dma.c
index a6b4a5a..f511e70 100644
--- a/drivers/parisc/ccio-dma.c
+++ b/drivers/parisc/ccio-dma.c
@@ -650,7 +650,7 @@ ccio_clear_io_tlb(struct ioc *ioc, dma_addr_t iovp, size_t byte_cnt)
  * Mark the I/O Pdir entries invalid and blow away the corresponding I/O
  * TLB entries.
  *
- * FIXME: at some threshhold it might be "cheaper" to just blow
+ * FIXME: at some threshold it might be "cheaper" to just blow
  *        away the entire I/O TLB instead of individual entries.
  *
  * FIXME: Uturn has 256 TLB entries. We don't need to purge every
diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index d93108d..36db20a 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -6533,7 +6533,7 @@ static struct ibm_struct volume_driver_data = {
  * 	The speeds are stored on handles
  * 	(FANA:FAN9), (FANC:FANB), (FANE:FAND).
  *
- * 	There are three default speed sets, acessible as handles:
+ * 	There are three default speed sets, accessible as handles:
  * 	FS1L,FS1M,FS1H; FS2L,FS2M,FS2H; FS3L,FS3M,FS3H
  *
  * 	ACPI DSDT switches which set is in use depending on various
diff --git a/drivers/pnp/pnpbios/rsparser.c b/drivers/pnp/pnpbios/rsparser.c
index 87b4f49..a5135eb 100644
--- a/drivers/pnp/pnpbios/rsparser.c
+++ b/drivers/pnp/pnpbios/rsparser.c
@@ -191,7 +191,7 @@ static unsigned char *pnpbios_parse_allocated_resource_data(struct pnp_dev *dev,
 			return (unsigned char *)p;
 			break;
 
-		default:	/* an unkown tag */
+		default:	/* an unknown tag */
 len_err:
 			dev_err(&dev->dev, "unknown tag %#x length %d\n",
 				tag, len);
@@ -405,7 +405,7 @@ pnpbios_parse_resource_option_data(unsigned char *p, unsigned char *end,
 		case SMALL_TAG_END:
 			return p + 2;
 
-		default:	/* an unkown tag */
+		default:	/* an unknown tag */
 len_err:
 			dev_err(&dev->dev, "unknown tag %#x length %d\n",
 				tag, len);
@@ -475,7 +475,7 @@ static unsigned char *pnpbios_parse_compatible_ids(unsigned char *p,
 			return (unsigned char *)p;
 			break;
 
-		default:	/* an unkown tag */
+		default:	/* an unknown tag */
 len_err:
 			dev_err(&dev->dev, "unknown tag %#x length %d\n",
 				tag, len);
@@ -744,7 +744,7 @@ static unsigned char *pnpbios_encode_allocated_resource_data(struct pnp_dev
 			return (unsigned char *)p;
 			break;
 
-		default:	/* an unkown tag */
+		default:	/* an unknown tag */
 len_err:
 			dev_err(&dev->dev, "unknown tag %#x length %d\n",
 				tag, len);
diff --git a/drivers/ps3/ps3-sys-manager.c b/drivers/ps3/ps3-sys-manager.c
index 88cb740..3cbaf18 100644
--- a/drivers/ps3/ps3-sys-manager.c
+++ b/drivers/ps3/ps3-sys-manager.c
@@ -46,7 +46,7 @@
 /**
  * struct ps3_sys_manager_header - System manager message header.
  * @version: Header version, currently 1.
- * @size: Header size in bytes, curently 16.
+ * @size: Header size in bytes, currently 16.
  * @payload_size: Message payload size in bytes.
  * @service_id: Message type, one of enum ps3_sys_manager_service_id.
  * @request_tag: Unique number to identify reply.
diff --git a/drivers/rtc/rtc-v3020.c b/drivers/rtc/rtc-v3020.c
index 423cd5a..ad741af 100644
--- a/drivers/rtc/rtc-v3020.c
+++ b/drivers/rtc/rtc-v3020.c
@@ -335,7 +335,7 @@ static int rtc_probe(struct platform_device *pdev)
 		goto err_io;
 	}
 
-	/* Make sure frequency measurment mode, test modes, and lock
+	/* Make sure frequency measurement mode, test modes, and lock
 	 * are all disabled */
 	v3020_set_reg(chip, V3020_STATUS_0, 0x0);
 
diff --git a/drivers/s390/char/fs3270.c b/drivers/s390/char/fs3270.c
index 097d384..f54b1ee 100644
--- a/drivers/s390/char/fs3270.c
+++ b/drivers/s390/char/fs3270.c
@@ -74,7 +74,7 @@ fs3270_do_io(struct raw3270_view *view, struct raw3270_request *rq)
 		}
 		rc = raw3270_start(view, rq);
 		if (rc == 0) {
-			/* Started sucessfully. Now wait for completion. */
+			/* Started successfully. Now wait for completion. */
 			wait_event(fp->wait, raw3270_request_final(rq));
 		}
 	} while (rc == -EACCES);
diff --git a/drivers/s390/cio/chp.c b/drivers/s390/cio/chp.c
index 8ab5160..c268a2e 100644
--- a/drivers/s390/cio/chp.c
+++ b/drivers/s390/cio/chp.c
@@ -65,7 +65,7 @@ static void set_chp_logically_online(struct chp_id chpid, int onoff)
 	chpid_to_chp(chpid)->state = onoff;
 }
 
-/* On succes return 0 if channel-path is varied offline, 1 if it is varied
+/* On success return 0 if channel-path is varied offline, 1 if it is varied
  * online. Return -ENODEV if channel-path is not registered. */
 int chp_get_status(struct chp_id chpid)
 {
diff --git a/drivers/s390/cio/cmf.c b/drivers/s390/cio/cmf.c
index 30f5161..2985eb4 100644
--- a/drivers/s390/cio/cmf.c
+++ b/drivers/s390/cio/cmf.c
@@ -462,7 +462,7 @@ static struct cmb_area cmb_area = {
  * block of memory, which can not be moved as long as any channel
  * is active. Therefore, a maximum number of subchannels needs to
  * be defined somewhere. This is a module parameter, defaulting to
- * a resonable value of 1024, or 32 kb of memory.
+ * a reasonable value of 1024, or 32 kb of memory.
  * Current kernels don't allow kmalloc with more than 128kb, so the
  * maximum is 4096.
  */
diff --git a/drivers/sbus/char/envctrl.c b/drivers/sbus/char/envctrl.c
index 58e583b..aa2b60a 100644
--- a/drivers/sbus/char/envctrl.c
+++ b/drivers/sbus/char/envctrl.c
@@ -92,11 +92,11 @@
 #define ENVCTRL_CPUTEMP_MON			1    /* cpu temperature monitor */
 #define ENVCTRL_CPUVOLTAGE_MON	  	2    /* voltage monitor         */
 #define ENVCTRL_FANSTAT_MON  		3    /* fan status monitor      */
-#define ENVCTRL_ETHERTEMP_MON		4    /* ethernet temperarture */
+#define ENVCTRL_ETHERTEMP_MON		4    /* ethernet temperature */
 					     /* monitor                     */
 #define ENVCTRL_VOLTAGESTAT_MON	  	5    /* voltage status monitor  */
 #define ENVCTRL_MTHRBDTEMP_MON		6    /* motherboard temperature */
-#define ENVCTRL_SCSITEMP_MON		7    /* scsi temperarture */
+#define ENVCTRL_SCSITEMP_MON		7    /* scsi temperature */
 #define ENVCTRL_GLOBALADDR_MON		8    /* global address */
 
 /* Child device type.
diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index f5a9add..07ce9bf 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -1491,7 +1491,7 @@ NCR_700_intr(int irq, void *dev_id)
 	unsigned long flags;
 	int handled = 0;
 
-	/* Use the host lock to serialise acess to the 53c700
+	/* Use the host lock to serialise access to the 53c700
 	 * hardware.  Note: In future, we may need to take the queue
 	 * lock to enter the done routines.  When that happens, we
 	 * need to ensure that for this driver, the host lock and the
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index cdbdec9..83986ed 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -526,10 +526,10 @@ struct aac_driver_ident
 
 /*
  *	The adapter interface specs all queues to be located in the same
- *	physically contigous block. The host structure that defines the
+ *	physically contiguous block. The host structure that defines the
  *	commuication queues will assume they are each a separate physically
- *	contigous memory region that will support them all being one big
- *	contigous block.
+ *	contiguous memory region that will support them all being one big
+ *	contiguous block.
  *	There is a command and response queue for each level and direction of
  *	commuication. These regions are accessed by both the host and adapter.
  */
diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index d598eba..666d515 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -226,7 +226,7 @@ static int aac_comm_init(struct aac_dev * dev)
 	spin_lock_init(&dev->fib_lock);
 
 	/*
-	 *	Allocate the physically contigous space for the commuication
+	 *	Allocate the physically contiguous space for the commuication
 	 *	queue headers. 
 	 */
 
diff --git a/drivers/scsi/aic7xxx/aic79xx.seq b/drivers/scsi/aic7xxx/aic79xx.seq
index 58bc175..da2bcec 100644
--- a/drivers/scsi/aic7xxx/aic79xx.seq
+++ b/drivers/scsi/aic7xxx/aic79xx.seq
@@ -217,7 +217,7 @@ BEGIN_CRITICAL;
 scbdma_tohost_done:
 	test	CCSCBCTL, CCARREN jz fill_qoutfifo_dmadone;
 	/*
-	 * An SCB has been succesfully uploaded to the host.
+	 * An SCB has been successfully uploaded to the host.
 	 * If the SCB was uploaded for some reason other than
 	 * bad SCSI status (currently only for underruns), we
 	 * queue the SCB for normal completion.  Otherwise, we
diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 63b521d..4d419c1 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -2487,7 +2487,7 @@ ahd_handle_scsiint(struct ahd_softc *ahd, u_int intstat)
 		/*
 		 * Although the driver does not care about the
 		 * 'Selection in Progress' status bit, the busy
-		 * LED does.  SELINGO is only cleared by a sucessfull
+		 * LED does.  SELINGO is only cleared by a successfull
 		 * selection, so we must manually clear it to insure
 		 * the LED turns off just incase no future successful
 		 * selections occur (e.g. no devices on the bus).
diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index 8dfb59d..45aa728 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -1733,7 +1733,7 @@ ahc_handle_scsiint(struct ahc_softc *ahc, u_int intstat)
 		/*
 		 * Although the driver does not care about the
 		 * 'Selection in Progress' status bit, the busy
-		 * LED does.  SELINGO is only cleared by a sucessfull
+		 * LED does.  SELINGO is only cleared by a successfull
 		 * selection, so we must manually clear it to insure
 		 * the LED turns off just incase no future successful
 		 * selections occur (e.g. no devices on the bus).
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_pport.h b/drivers/scsi/bfa/include/defs/bfa_defs_pport.h
index a000bc4..bf32041 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_pport.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_pport.h
@@ -61,7 +61,7 @@ enum bfa_pport_speed {
  * 		Port operational type (in sync with SNIA port type).
  */
 enum bfa_pport_type {
-	BFA_PPORT_TYPE_UNKNOWN = 1,	/*  port type is unkown */
+	BFA_PPORT_TYPE_UNKNOWN = 1,	/*  port type is unknown */
 	BFA_PPORT_TYPE_TRUNKED = 2,	/*  Trunked mode */
 	BFA_PPORT_TYPE_NPORT   = 5,	/*  P2P with switched fabric */
 	BFA_PPORT_TYPE_NLPORT  = 6,	/*  public loop */
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_tsensor.h b/drivers/scsi/bfa/include/defs/bfa_defs_tsensor.h
index 31881d2..ade763d 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_tsensor.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_tsensor.h
@@ -25,7 +25,7 @@
  * Temperature sensor status values
  */
 enum bfa_tsensor_status {
-	BFA_TSENSOR_STATUS_UNKNOWN   = 1,   /*  unkown status */
+	BFA_TSENSOR_STATUS_UNKNOWN   = 1,   /*  unknown status */
 	BFA_TSENSOR_STATUS_FAULTY    = 2,   /*  sensor is faulty */
 	BFA_TSENSOR_STATUS_BELOW_MIN = 3,   /*  temperature below mininum */
 	BFA_TSENSOR_STATUS_NOMINAL   = 4,   /*  normal temperature */
diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index a0e7e71..5be67a6 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -834,7 +834,7 @@ static int hptiop_reset_hba(struct hptiop_hba *hba)
 			atomic_read(&hba->resetting) == 0, 60 * HZ);
 
 	if (atomic_read(&hba->resetting)) {
-		/* IOP is in unkown state, abort reset */
+		/* IOP is in unknown state, abort reset */
 		printk(KERN_ERR "scsi%d: reset failed\n", hba->host->host_no);
 		return -1;
 	}
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index bd2f771..6486ae4 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -56,7 +56,7 @@
  * at the same time.
  *
  * When discovery succeeds or fails a callback is made to the lport as
- * notification. Currently, succesful discovery causes the lport to take no
+ * notification. Currently, successful discovery causes the lport to take no
  * action. A failure will cause the lport to reset. There is likely a circular
  * locking problem with this implementation.
  */
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 2e0746d..ca25ee5 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -1004,7 +1004,7 @@ static struct iscsi_r2t_info *iscsi_tcp_get_curr_r2t(struct iscsi_task *task)
  * iscsi_tcp_task_xmit - xmit normal PDU task
  * @task: iscsi command task
  *
- * We're expected to return 0 when everything was transmitted succesfully,
+ * We're expected to return 0 when everything was transmitted successfully,
  * -EAGAIN if there's still data in the queue, or != 0 for any other kind
  * of error.
  */
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index e1a30a1..9bd19aa 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -654,7 +654,7 @@ lpfc_selective_reset(struct lpfc_hba *phba)
  * Notes:
  * Assumes any error from lpfc_selective_reset() will be negative.
  * If lpfc_selective_reset() returns zero then the length of the buffer
- * is returned which indicates succcess
+ * is returned which indicates success
  *
  * Returns:
  * -EINVAL if the buffer does not contain the string "selective"
@@ -3147,7 +3147,7 @@ sysfs_ctlreg_write(struct kobject *kobj, struct bin_attribute *bin_attr,
  * sysfs_ctlreg_read - Read method for reading from ctlreg
  * @kobj: kernel kobject that contains the kernel class device.
  * @bin_attr: kernel attributes passed to us.
- * @buf: if succesful contains the data from the adapter IOREG space.
+ * @buf: if successful contains the data from the adapter IOREG space.
  * @off: offset into buffer to beginning of data.
  * @count: bytes to transfer.
  *
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 45337cd..a14ab45 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -802,7 +802,7 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 	/* FLOGI completes successfully */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
-			 "0101 FLOGI completes sucessfully "
+			 "0101 FLOGI completes successfully "
 			 "Data: x%x x%x x%x x%x\n",
 			 irsp->un.ulpWord[4], sp->cmn.e_d_tov,
 			 sp->cmn.w2.r_a_tov, sp->cmn.edtovResolution);
@@ -4133,7 +4133,7 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 	/* Indicate we are walking fc_rscn_id_list on this vport */
 	vport->fc_rscn_flush = 1;
 	spin_unlock_irq(shost->host_lock);
-	/* Get the array count after sucessfully have the token */
+	/* Get the array count after successfully have the token */
 	rscn_cnt = vport->fc_rscn_id_cnt;
 	/* If we are already processing an RSCN, save the received
 	 * RSCN payload buffer, cmdiocb->context2 to process later.
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 562d8ce..82f8ab5 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -645,7 +645,7 @@ lpfc_hba_down_prep(struct lpfc_hba *phba)
  * down the SLI Layer.
  *
  * Return codes
- *   0 - sucess.
+ *   0 - success.
  *   Any other value - error.
  **/
 static int
@@ -700,7 +700,7 @@ lpfc_hba_down_post_s3(struct lpfc_hba *phba)
  * down the SLI Layer.
  *
  * Return codes
- *   0 - sucess.
+ *   0 - success.
  *   Any other value - error.
  **/
 static int
@@ -755,7 +755,7 @@ lpfc_hba_down_post_s4(struct lpfc_hba *phba)
  * uninitialization after the HBA is reset when bring down the SLI Layer.
  *
  * Return codes
- *   0 - sucess.
+ *   0 - success.
  *   Any other value - error.
  **/
 int
@@ -1254,7 +1254,7 @@ lpfc_handle_eratt_s4(struct lpfc_hba *phba)
  * routine from the API jump table function pointer from the lpfc_hba struct.
  *
  * Return codes
- *   0 - sucess.
+ *   0 - success.
  *   Any other value - error.
  **/
 void
@@ -3124,7 +3124,7 @@ static void lpfc_log_intr_mode(struct lpfc_hba *phba, uint32_t intr_mode)
  * PCI devices.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  * 	other values - error
  **/
 static int
@@ -3220,7 +3220,7 @@ lpfc_reset_hba(struct lpfc_hba *phba)
  * support the SLI-3 HBA device it attached to.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  * 	other values - error
  **/
 static int
@@ -3321,7 +3321,7 @@ lpfc_sli_driver_resource_unset(struct lpfc_hba *phba)
  * support the SLI-4 HBA device it attached to.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  * 	other values - error
  **/
 static int
@@ -3642,7 +3642,7 @@ lpfc_init_api_table_setup(struct lpfc_hba *phba, uint8_t dev_grp)
  * device specific resource setup to support the HBA device it attached to.
  *
  * Return codes
- *	0 - sucessful
+ *	0 - successful
  *	other values - error
  **/
 static int
@@ -3688,7 +3688,7 @@ lpfc_setup_driver_resource_phase1(struct lpfc_hba *phba)
  * device specific resource setup to support the HBA device it attached to.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  * 	other values - error
  **/
 static int
@@ -3753,7 +3753,7 @@ lpfc_free_iocb_list(struct lpfc_hba *phba)
  * list and set up the IOCB tag array accordingly.
  *
  * Return codes
- *	0 - sucessful
+ *	0 - successful
  *	other values - error
  **/
 static int
@@ -3872,7 +3872,7 @@ lpfc_free_active_sgl(struct lpfc_hba *phba)
  * list and set up the sgl xritag tag array accordingly.
  *
  * Return codes
- *	0 - sucessful
+ *	0 - successful
  *	other values - error
  **/
 static int
@@ -3986,7 +3986,7 @@ out_free_mem:
  * enabled and the driver is reinitializing the device.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  * 	ENOMEM - No availble memory
  *      EIO - The mailbox failed to complete successfully.
  **/
@@ -4146,7 +4146,7 @@ lpfc_sli4_remove_rpi_hdrs(struct lpfc_hba *phba)
  * PCI device data structure is set.
  *
  * Return codes
- *      pointer to @phba - sucessful
+ *      pointer to @phba - successful
  *      NULL - error
  **/
 static struct lpfc_hba *
@@ -4202,7 +4202,7 @@ lpfc_hba_free(struct lpfc_hba *phba)
  * host with it.
  *
  * Return codes
- *      0 - sucessful
+ *      0 - successful
  *      other values - error
  **/
 static int
@@ -4365,7 +4365,7 @@ lpfc_post_init_setup(struct lpfc_hba *phba)
  * with SLI-3 interface spec.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  * 	other values - error
  **/
 static int
@@ -4662,7 +4662,7 @@ lpfc_sli4_bar2_register_memmap(struct lpfc_hba *phba, uint32_t vf)
  * this routine.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  * 	ENOMEM - could not allocated memory.
  **/
 static int
@@ -4761,7 +4761,7 @@ lpfc_destroy_bootstrap_mbox(struct lpfc_hba *phba)
  * allocation for the port.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  * 	ENOMEM - No availble memory
  *      EIO - The mailbox failed to complete successfully.
  **/
@@ -4861,7 +4861,7 @@ lpfc_sli4_read_config(struct lpfc_hba *phba)
  * HBA consistent with the SLI-4 interface spec.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  * 	ENOMEM - No availble memory
  *      EIO - The mailbox failed to complete successfully.
  **/
@@ -4910,7 +4910,7 @@ lpfc_setup_endian_order(struct lpfc_hba *phba)
  * we just use some constant number as place holder.
  *
  * Return codes
- *      0 - sucessful
+ *      0 - successful
  *      ENOMEM - No availble memory
  *      EIO - The mailbox failed to complete successfully.
  **/
@@ -5218,7 +5218,7 @@ out_error:
  * operation.
  *
  * Return codes
- *      0 - sucessful
+ *      0 - successful
  *      ENOMEM - No availble memory
  *      EIO - The mailbox failed to complete successfully.
  **/
@@ -5286,7 +5286,7 @@ lpfc_sli4_queue_destroy(struct lpfc_hba *phba)
  * operation.
  *
  * Return codes
- *      0 - sucessful
+ *      0 - successful
  *      ENOMEM - No availble memory
  *      EIO - The mailbox failed to complete successfully.
  **/
@@ -5552,7 +5552,7 @@ out_error:
  * operation.
  *
  * Return codes
- *      0 - sucessful
+ *      0 - successful
  *      ENOMEM - No availble memory
  *      EIO - The mailbox failed to complete successfully.
  **/
@@ -5599,7 +5599,7 @@ lpfc_sli4_queue_unset(struct lpfc_hba *phba)
  * Later, this can be used for all the slow-path events.
  *
  * Return codes
- *      0 - sucessful
+ *      0 - successful
  *      -ENOMEM - No availble memory
  **/
 static int
@@ -5760,7 +5760,7 @@ lpfc_sli4_cq_event_release_all(struct lpfc_hba *phba)
  * all resources assigned to the PCI function which originates this request.
  *
  * Return codes
- *      0 - sucessful
+ *      0 - successful
  *      ENOMEM - No availble memory
  *      EIO - The mailbox failed to complete successfully.
  **/
@@ -5923,7 +5923,7 @@ lpfc_sli4_fcfi_unreg(struct lpfc_hba *phba, uint16_t fcfi)
  * with SLI-4 interface spec.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  * 	other values - error
  **/
 static int
@@ -6052,7 +6052,7 @@ lpfc_sli4_pci_mem_unset(struct lpfc_hba *phba)
  * will be left with MSI-X enabled and leaks its vectors.
  *
  * Return codes
- *   0 - sucessful
+ *   0 - successful
  *   other values - error
  **/
 static int
@@ -6184,7 +6184,7 @@ lpfc_sli_disable_msix(struct lpfc_hba *phba)
  * is done in this function.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  * 	other values - error
  */
 static int
@@ -6243,7 +6243,7 @@ lpfc_sli_disable_msi(struct lpfc_hba *phba)
  * MSI-X -> MSI -> IRQ.
  *
  * Return codes
- *   0 - sucessful
+ *   0 - successful
  *   other values - error
  **/
 static uint32_t
@@ -6333,7 +6333,7 @@ lpfc_sli_disable_intr(struct lpfc_hba *phba)
  * enabled and leaks its vectors.
  *
  * Return codes
- * 0 - sucessful
+ * 0 - successful
  * other values - error
  **/
 static int
@@ -6443,7 +6443,7 @@ lpfc_sli4_disable_msix(struct lpfc_hba *phba)
  * which is done in this function.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  * 	other values - error
  **/
 static int
@@ -6508,7 +6508,7 @@ lpfc_sli4_disable_msi(struct lpfc_hba *phba)
  * MSI-X -> MSI -> IRQ.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  * 	other values - error
  **/
 static uint32_t
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 43cbe33..42d4f3d 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1794,7 +1794,7 @@ lpfc_sli_handle_mb_event(struct lpfc_hba *phba)
 		 */
 		if (lpfc_sli_chk_mbx_command(pmbox->mbxCommand) ==
 		    MBX_SHUTDOWN) {
-			/* Unknow mailbox command compl */
+			/* Unknown mailbox command compl */
 			lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
 					"(%d):0323 Unknown Mailbox command "
 					"x%x (x%x) Cmpl\n",
@@ -4163,7 +4163,7 @@ lpfc_sli4_read_fcoe_params(struct lpfc_hba *phba,
  * addition, this routine gets the port vpd data.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  * 	ENOMEM - could not allocated memory.
  **/
 static int
@@ -11091,7 +11091,7 @@ lpfc_sli4_handle_received_buffer(struct lpfc_hba *phba)
  * sequential.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  *      EIO - The mailbox failed to complete successfully.
  * 	When this error occurs, the driver is not guaranteed
  *	to have any rpi regions posted to the device and
@@ -11129,7 +11129,7 @@ lpfc_sli4_post_all_rpi_hdrs(struct lpfc_hba *phba)
  * maps up to 64 rpi context regions.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  * 	ENOMEM - No available memory
  *      EIO - The mailbox failed to complete successfully.
  **/
@@ -11191,7 +11191,7 @@ lpfc_sli4_post_rpi_hdr(struct lpfc_hba *phba, struct lpfc_rpi_hdr *rpi_page)
  * PAGE_SIZE modulo 64 rpi context headers.
  *
  * Returns
- * 	A nonzero rpi defined as rpi_base <= rpi < max_rpi if sucessful
+ * 	A nonzero rpi defined as rpi_base <= rpi < max_rpi if successful
  * 	LPFC_RPI_ALLOC_ERROR if no rpis are available.
  **/
 int
diff --git a/drivers/scsi/megaraid.h b/drivers/scsi/megaraid.h
index 512c2cc..d310f49 100644
--- a/drivers/scsi/megaraid.h
+++ b/drivers/scsi/megaraid.h
@@ -381,7 +381,7 @@ typedef struct {
 	u8	battery_status;	/*
 				 * BIT 0: battery module missing
 				 * BIT 1: VBAD
-				 * BIT 2: temprature high
+				 * BIT 2: temperature high
 				 * BIT 3: battery pack missing
 				 * BIT 4,5:
 				 *   00 - charge complete
diff --git a/drivers/scsi/megaraid/mbox_defs.h b/drivers/scsi/megaraid/mbox_defs.h
index b25b747..ce2487a 100644
--- a/drivers/scsi/megaraid/mbox_defs.h
+++ b/drivers/scsi/megaraid/mbox_defs.h
@@ -497,7 +497,7 @@ typedef struct {
  * @inserted_drive		: channel:Id of inserted drive
  * @battery_status		: bit 0: battery module missing
  *				bit 1: VBAD
- *				bit 2: temprature high
+ *				bit 2: temperature high
  *				bit 3: battery pack missing
  *				bit 4,5:
  *					00 - charge complete
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index 234f0b7..f9ae803 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -2704,7 +2704,7 @@ megaraid_reset_handler(struct scsi_cmnd *scp)
 	}
 	else {
 		con_log(CL_ANN, (KERN_NOTICE
-		"megaraid mbox: reset sequence completed sucessfully\n"));
+		"megaraid mbox: reset sequence completed successfully\n"));
 	}
 
 
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 86ab32d..756e509 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -2894,7 +2894,7 @@ _scsih_normalize_sense(char *sense_buffer, struct sense_info *data)
 
 #ifdef CONFIG_SCSI_MPT2SAS_LOGGING
 /**
- * _scsih_scsi_ioc_info - translated non-succesfull SCSI_IO request
+ * _scsih_scsi_ioc_info - translated non-successfull SCSI_IO request
  * @ioc: per adapter object
  * @scmd: pointer to scsi command object
  * @mpi_reply: reply mf payload returned from firmware
diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index e3c482a..a2d5698 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -6495,7 +6495,7 @@ static void ncr_int_ma (struct ncb *np)
 	**	we force a SIR_NEGO_PROTO interrupt (it is a hack that avoids 
 	**	bloat for such a should_not_happen situation).
 	**	In all other situation, we reset the BUS.
-	**	Are these assumptions reasonnable ? (Wait and see ...)
+	**	Are these assumptions reasonable ? (Wait and see ...)
 	*/
 unexpected_phase:
 	dsp -= 8;
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index f7c70e2..d3d39f8 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3342,7 +3342,7 @@ static int pmcraid_chr_fasync(int fd, struct file *filep, int mode)
  * @direction : data transfer direction
  *
  * Return value
- *  0 on sucess, non-zero error code on failure
+ *  0 on success, non-zero error code on failure
  */
 static int pmcraid_build_passthrough_ioadls(
 	struct pmcraid_cmd *cmd,
@@ -3401,7 +3401,7 @@ static int pmcraid_build_passthrough_ioadls(
  * @direction: data transfer direction
  *
  * Return value
- *  0 on sucess, non-zero error code on failure
+ *  0 on success, non-zero error code on failure
  */
 static void pmcraid_release_passthrough_ioadls(
 	struct pmcraid_cmd *cmd,
@@ -3429,7 +3429,7 @@ static void pmcraid_release_passthrough_ioadls(
  * @arg: pointer to pmcraid_passthrough_buffer user buffer
  *
  * Return value
- *  0 on sucess, non-zero error code on failure
+ *  0 on success, non-zero error code on failure
  */
 static long pmcraid_ioctl_passthrough(
 	struct pmcraid_instance *pinstance,
diff --git a/drivers/scsi/pmcraid.h b/drivers/scsi/pmcraid.h
index 3441b3f..2752b56 100644
--- a/drivers/scsi/pmcraid.h
+++ b/drivers/scsi/pmcraid.h
@@ -771,11 +771,11 @@ static struct pmcraid_ioasc_error pmcraid_ioasc_error_table[] = {
 	{0x01180600, IOASC_LOG_LEVEL_MUST,
 	 "Recovered Error, soft media error, sector reassignment suggested"},
 	{0x015D0000, IOASC_LOG_LEVEL_MUST,
-	 "Recovered Error, failure prediction thresold exceeded"},
+	 "Recovered Error, failure prediction threshold exceeded"},
 	{0x015D9200, IOASC_LOG_LEVEL_MUST,
-	 "Recovered Error, soft Cache Card Battery error thresold"},
+	 "Recovered Error, soft Cache Card Battery error threshold"},
 	{0x015D9200, IOASC_LOG_LEVEL_MUST,
-	 "Recovered Error, soft Cache Card Battery error thresold"},
+	 "Recovered Error, soft Cache Card Battery error threshold"},
 	{0x02048000, IOASC_LOG_LEVEL_MUST,
 	 "Not Ready, IOA Reset Required"},
 	{0x02408500, IOASC_LOG_LEVEL_MUST,
diff --git a/drivers/scsi/scsi_netlink.c b/drivers/scsi/scsi_netlink.c
index 723fdec..0fd6ae6 100644
--- a/drivers/scsi/scsi_netlink.c
+++ b/drivers/scsi/scsi_netlink.c
@@ -613,7 +613,7 @@ EXPORT_SYMBOL_GPL(scsi_nl_send_transport_msg);
  * @data_buf:		pointer to vendor unique data buffer
  *
  * Returns:
- *   0 on succesful return
+ *   0 on successful return
  *   otherwise, failing error code
  *
  * Notes:
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index fd47cb1..f27e52d 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -666,7 +666,7 @@ EXPORT_SYMBOL(sas_phy_add);
  *
  * Note:
  *   This function must only be called on a PHY that has not
- *   sucessfully been added using sas_phy_add().
+ *   successfully been added using sas_phy_add().
  */
 void sas_phy_free(struct sas_phy *phy)
 {
@@ -896,7 +896,7 @@ EXPORT_SYMBOL(sas_port_add);
  *
  * Note:
  *   This function must only be called on a PORT that has not
- *   sucessfully been added using sas_port_add().
+ *   successfully been added using sas_port_add().
  */
 void sas_port_free(struct sas_port *port)
 {
@@ -1476,7 +1476,7 @@ EXPORT_SYMBOL(sas_rphy_add);
  *
  * Note:
  *   This function must only be called on a remote
- *   PHY that has not sucessfully been added using
+ *   PHY that has not successfully been added using
  *   sas_rphy_add() (or has been sas_rphy_remove()'d)
  */
 void sas_rphy_free(struct sas_rphy *rphy)
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 45374d6..2b38f6a 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -1864,7 +1864,7 @@ static pci_ers_result_t sym2_io_slot_dump(struct pci_dev *pdev)
  *
  * This routine is similar to sym_set_workarounds(), except
  * that, at this point, we already know that the device was
- * succesfully intialized at least once before, and so most
+ * successfully intialized at least once before, and so most
  * of the steps taken there are un-needed here.
  */
 static void sym2_reset_workarounds(struct pci_dev *pdev)
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index 297deb8..a7bc8b7 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -2692,7 +2692,7 @@ static void sym_int_ma (struct sym_hcb *np)
 	 *  we force a SIR_NEGO_PROTO interrupt (it is a hack that avoids 
 	 *  bloat for such a should_not_happen situation).
 	 *  In all other situation, we reset the BUS.
-	 *  Are these assumptions reasonnable ? (Wait and see ...)
+	 *  Are these assumptions reasonable ? (Wait and see ...)
 	 */
 unexpected_phase:
 	dsp -= 8;
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.h b/drivers/scsi/sym53c8xx_2/sym_hipd.h
index 053e63c..5a80cba 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.h
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.h
@@ -54,7 +54,7 @@
  *
  *    SYM_OPT_LIMIT_COMMAND_REORDERING
  *        When this option is set, the driver tries to limit tagged 
- *        command reordering to some reasonnable value.
+ *        command reordering to some reasonable value.
  *        (set for Linux)
  */
 #if 0
diff --git a/drivers/serial/8250_pnp.c b/drivers/serial/8250_pnp.c
index d71dfe3..36ede02 100644
--- a/drivers/serial/8250_pnp.c
+++ b/drivers/serial/8250_pnp.c
@@ -361,9 +361,9 @@ static const struct pnp_device_id pnp_dev_table[] = {
 	{	"LTS0001",		0       },
 	/* Rockwell's (PORALiNK) 33600 INT PNP */
 	{	"WCI0003",		0	},
-	/* Unkown PnP modems */
+	/* Unknown PnP modems */
 	{	"PNPCXXX",		UNKNOWN_DEV	},
-	/* More unkown PnP modems */
+	/* More unknown PnP modems */
 	{	"PNPDXXX",		UNKNOWN_DEV	},
 	{	"",			0	}
 };
diff --git a/drivers/serial/pmac_zilog.h b/drivers/serial/pmac_zilog.h
index 570b0d9..f6e77f1 100644
--- a/drivers/serial/pmac_zilog.h
+++ b/drivers/serial/pmac_zilog.h
@@ -73,7 +73,7 @@ static inline struct uart_pmac_port *pmz_get_port_A(struct uart_pmac_port *uap)
 }
 
 /*
- * Register acessors. Note that we don't need to enforce a recovery
+ * Register accessors. Note that we don't need to enforce a recovery
  * delay on PCI PowerMac hardware, it's dealt in HW by the MacIO chip,
  * though if we try to use this driver on older machines, we might have
  * to add it back
diff --git a/drivers/serial/ucc_uart.c b/drivers/serial/ucc_uart.c
index 0c08f28..46de564 100644
--- a/drivers/serial/ucc_uart.c
+++ b/drivers/serial/ucc_uart.c
@@ -313,7 +313,7 @@ static void qe_uart_stop_tx(struct uart_port *port)
  * This function will attempt to stuff of all the characters from the
  * kernel's transmit buffer into TX BDs.
  *
- * A return value of non-zero indicates that it sucessfully stuffed all
+ * A return value of non-zero indicates that it successfully stuffed all
  * characters from the kernel buffer.
  *
  * A return value of zero indicates that there are still characters in the
diff --git a/drivers/telephony/ixj.c b/drivers/telephony/ixj.c
index 40de151..e89304c 100644
--- a/drivers/telephony/ixj.c
+++ b/drivers/telephony/ixj.c
@@ -4190,7 +4190,7 @@ static void ixj_aec_start(IXJ *j, int level)
 				ixj_WriteDSPCommand(0x1224, j);
 
 			ixj_WriteDSPCommand(0xE014, j);
-			ixj_WriteDSPCommand(0x0003, j);	/* Lock threashold at 3dB */
+			ixj_WriteDSPCommand(0x0003, j);	/* Lock threshold at 3dB */
 
 			ixj_WriteDSPCommand(0xE338, j);	/* Set Echo Suppresser Attenuation to 0dB */
 
@@ -4235,7 +4235,7 @@ static void ixj_aec_start(IXJ *j, int level)
 				ixj_WriteDSPCommand(0x1224, j);
 
 			ixj_WriteDSPCommand(0xE014, j);
-			ixj_WriteDSPCommand(0x0003, j);	/* Lock threashold at 3dB */
+			ixj_WriteDSPCommand(0x0003, j);	/* Lock threshold at 3dB */
 
 			ixj_WriteDSPCommand(0xE338, j);	/* Set Echo Suppresser Attenuation to 0dB */
 
diff --git a/drivers/usb/atm/ueagle-atm.c b/drivers/usb/atm/ueagle-atm.c
index d171b56..bba4d3e 100644
--- a/drivers/usb/atm/ueagle-atm.c
+++ b/drivers/usb/atm/ueagle-atm.c
@@ -1958,7 +1958,7 @@ static void uea_dispatch_cmv_e1(struct uea_softc *sc, struct intr_pkt *intr)
 		goto bad1;
 
 	/* FIXME : ADI930 reply wrong preambule (func = 2, sub = 2) to
-	 * the first MEMACESS cmv. Ignore it...
+	 * the first MEMACCESS cmv. Ignore it...
 	 */
 	if (cmv->bFunction != dsc->function) {
 		if (UEA_CHIP_VERSION(sc) == ADI930
diff --git a/drivers/usb/class/usbtmc.c b/drivers/usb/class/usbtmc.c
index 2473cf0..b4bd241 100644
--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -1,5 +1,5 @@
 /**
- * drivers/usb/class/usbtmc.c - USB Test & Measurment class driver
+ * drivers/usb/class/usbtmc.c - USB Test & Measurement class driver
  *
  * Copyright (C) 2007 Stefan Kopp, Gechingen, Germany
  * Copyright (C) 2008 Novell, Inc.
diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index da718e8..e80f1af 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1890,7 +1890,7 @@ static void cancel_async_set_config(struct usb_device *udev)
  * routine gets around the normal restrictions by using a work thread to
  * submit the change-config request.
  *
- * Returns 0 if the request was succesfully queued, error code otherwise.
+ * Returns 0 if the request was successfully queued, error code otherwise.
  * The caller has no way to know whether the queued request will eventually
  * succeed.
  */
diff --git a/drivers/usb/gadget/f_acm.c b/drivers/usb/gadget/f_acm.c
index 7953948..4e36578 100644
--- a/drivers/usb/gadget/f_acm.c
+++ b/drivers/usb/gadget/f_acm.c
@@ -432,7 +432,7 @@ static void acm_disable(struct usb_function *f)
  * @length: size of data
  * Context: irqs blocked, acm->lock held, acm_notify_req non-null
  *
- * Returns zero on sucess or a negative errno.
+ * Returns zero on success or a negative errno.
  *
  * See section 6.3.5 of the CDC 1.1 specification for information
  * about the only notification we issue:  SerialState change.
diff --git a/drivers/usb/gadget/pxa27x_udc.c b/drivers/usb/gadget/pxa27x_udc.c
index 1937d8c..adda120 100644
--- a/drivers/usb/gadget/pxa27x_udc.c
+++ b/drivers/usb/gadget/pxa27x_udc.c
@@ -1524,7 +1524,7 @@ static int pxa_udc_get_frame(struct usb_gadget *_gadget)
  * pxa_udc_wakeup - Force udc device out of suspend
  * @_gadget: usb gadget
  *
- * Returns 0 if succesfull, error code otherwise
+ * Returns 0 if successfull, error code otherwise
  */
 static int pxa_udc_wakeup(struct usb_gadget *_gadget)
 {
diff --git a/drivers/usb/host/fhci-sched.c b/drivers/usb/host/fhci-sched.c
index 62a226b..00a2985 100644
--- a/drivers/usb/host/fhci-sched.c
+++ b/drivers/usb/host/fhci-sched.c
@@ -627,7 +627,7 @@ irqreturn_t fhci_irq(struct usb_hcd *hcd)
 
 
 /*
- * Process normal completions(error or sucess) and clean the schedule.
+ * Process normal completions(error or success) and clean the schedule.
  *
  * This is the main path for handing urbs back to drivers. The only other patth
  * is process_del_list(),which unlinks URBs by scanning EDs,instead of scanning
diff --git a/drivers/usb/wusbcore/crypto.c b/drivers/usb/wusbcore/crypto.c
index 9ec7fd5..9579cf4 100644
--- a/drivers/usb/wusbcore/crypto.c
+++ b/drivers/usb/wusbcore/crypto.c
@@ -111,7 +111,7 @@ struct aes_ccm_b1 {
  *
  * CCM uses Ax blocks to generate a keystream with which the MIC and
  * the message's payload are encoded. A0 always encrypts/decrypts the
- * MIC. Ax (x>0) are used for the sucesive payload blocks.
+ * MIC. Ax (x>0) are used for the successive payload blocks.
  *
  * The x is the counter, and is increased for each block.
  */
diff --git a/drivers/usb/wusbcore/wa-xfer.c b/drivers/usb/wusbcore/wa-xfer.c
index 613a5fc..489b478 100644
--- a/drivers/usb/wusbcore/wa-xfer.c
+++ b/drivers/usb/wusbcore/wa-xfer.c
@@ -558,7 +558,7 @@ static void wa_seg_dto_cb(struct urb *urb)
 /*
  * Callback for the segment request
  *
- * If succesful transition state (unless already transitioned or
+ * If successful transition state (unless already transitioned or
  * outbound transfer); otherwise, take a note of the error, mark this
  * segment done and try completion.
  *
@@ -1364,7 +1364,7 @@ segment_aborted:
 /*
  * Callback for the IN data phase
  *
- * If succesful transition state; otherwise, take a note of the
+ * If successful transition state; otherwise, take a note of the
  * error, mark this segment done and try completion.
  *
  * Note we don't access until we are sure that the transfer hasn't
diff --git a/drivers/uwb/i1480/dfu/usb.c b/drivers/uwb/i1480/dfu/usb.c
index c7080d4..0bb665a 100644
--- a/drivers/uwb/i1480/dfu/usb.c
+++ b/drivers/uwb/i1480/dfu/usb.c
@@ -229,7 +229,7 @@ void i1480_usb_neep_cb(struct urb *urb)
  * will verify it.
  *
  * Set i1480->evt_result with the result of getting the event or its
- * size (if succesful).
+ * size (if successful).
  *
  * Delivers the data directly to i1480->evt_buf
  */
diff --git a/drivers/uwb/wlp/txrx.c b/drivers/uwb/wlp/txrx.c
index 86a853b..7350ed6 100644
--- a/drivers/uwb/wlp/txrx.c
+++ b/drivers/uwb/wlp/txrx.c
@@ -282,7 +282,7 @@ EXPORT_SYMBOL_GPL(wlp_receive_frame);
  *         and transmission will be done by the calling function.
  * @dst:   On return this will contain the device address to which the
  *         frame is destined.
- * @returns: 0 on success no tx : WLP header sucessfully applied to skb buffer,
+ * @returns: 0 on success no tx : WLP header successfully applied to skb buffer,
  *                                calling function can proceed with tx
  *           1 on success with tx : WLP will take over transmission of this
  *                                  frame
diff --git a/drivers/video/aty/atyfb_base.c b/drivers/video/aty/atyfb_base.c
index 913b4a4..1ddeb4c 100644
--- a/drivers/video/aty/atyfb_base.c
+++ b/drivers/video/aty/atyfb_base.c
@@ -3276,7 +3276,7 @@ static void __devinit aty_init_lcd(struct atyfb_par *par, u32 bios_base)
 				txtformat = "24 bit interface";
 				break;
 			default:
-				txtformat = "unkown format";
+				txtformat = "unknown format";
 			}
 		} else {
 			switch (format & 7) {
@@ -3299,7 +3299,7 @@ static void __devinit aty_init_lcd(struct atyfb_par *par, u32 bios_base)
 				txtformat = "262144 colours (FDPI-2 mode)";
 				break;
 			default:
-				txtformat = "unkown format";
+				txtformat = "unknown format";
 			}
 		}
 		PRINTKI("%s%s %s monitor detected: %s\n",
diff --git a/drivers/video/backlight/atmel-pwm-bl.c b/drivers/video/backlight/atmel-pwm-bl.c
index 505c082..2cf7ba5 100644
--- a/drivers/video/backlight/atmel-pwm-bl.c
+++ b/drivers/video/backlight/atmel-pwm-bl.c
@@ -158,7 +158,7 @@ static int atmel_pwm_bl_probe(struct platform_device *pdev)
 			goto err_free_pwm;
 		}
 
-		/* Turn display off by defatult. */
+		/* Turn display off by default. */
 		retval = gpio_direction_output(pwmbl->gpio_on,
 				0 ^ pdata->on_active_low);
 		if (retval)
diff --git a/drivers/video/backlight/tosa_lcd.c b/drivers/video/backlight/tosa_lcd.c
index 50ec17d..fa32b94 100644
--- a/drivers/video/backlight/tosa_lcd.c
+++ b/drivers/video/backlight/tosa_lcd.c
@@ -177,7 +177,7 @@ static int __devinit tosa_lcd_probe(struct spi_device *spi)
 	if (!data)
 		return -ENOMEM;
 
-	data->is_vga = true; /* defaut to VGA mode */
+	data->is_vga = true; /* default to VGA mode */
 
 	/*
 	 * bits_per_word cannot be configured in platform data
diff --git a/drivers/video/console/sticore.c b/drivers/video/console/sticore.c
index 857b366..6468a29 100644
--- a/drivers/video/console/sticore.c
+++ b/drivers/video/console/sticore.c
@@ -436,7 +436,7 @@ sti_init_glob_cfg(struct sti_struct *sti,
 			    (offs < PCI_BASE_ADDRESS_0 ||
 			     offs > PCI_BASE_ADDRESS_5)) {
 				printk (KERN_WARNING
-					"STI pci region maping for region %d (%02x) can't be mapped\n",
+					"STI pci region mapping for region %d (%02x) can't be mapped\n",
 					i,sti->rm_entry[i]);
 				continue;
 			}
diff --git a/drivers/video/gbefb.c b/drivers/video/gbefb.c
index 1a83709..492e6e6 100644
--- a/drivers/video/gbefb.c
+++ b/drivers/video/gbefb.c
@@ -701,7 +701,7 @@ static int gbefb_set_par(struct fb_info *info)
 	   blocks of 512x128, 256x128 or 128x128 pixels, respectively for 8bit,
 	   16bit and 32 bit modes (64 kB). They cover the screen with partial
 	   tiles on the right and/or bottom of the screen if needed.
-	   For exemple in 640x480 8 bit mode the mapping is:
+	   For example in 640x480 8 bit mode the mapping is:
 
 	   <-------- 640 ----->
 	   <---- 512 ----><128|384 offscreen>
diff --git a/drivers/video/stifb.c b/drivers/video/stifb.c
index 6120f0c..876648e 100644
--- a/drivers/video/stifb.c
+++ b/drivers/video/stifb.c
@@ -756,9 +756,9 @@ hyperResetPlanes(struct stifb_info *fb, int enable)
 		if (fb->info.var.bits_per_pixel == 32)
 			controlPlaneReg = 0x04000F00;
 		else
-			controlPlaneReg = 0x00000F00;   /* 0x00000800 should be enought, but lets clear all 4 bits */
+			controlPlaneReg = 0x00000F00;   /* 0x00000800 should be enough, but lets clear all 4 bits */
 	else
-		controlPlaneReg = 0x00000F00; /* 0x00000100 should be enought, but lets clear all 4 bits */
+		controlPlaneReg = 0x00000F00; /* 0x00000100 should be enough, but lets clear all 4 bits */
 
 	switch (enable) {
 	case ENABLE:
diff --git a/drivers/video/tdfxfb.c b/drivers/video/tdfxfb.c
index ff43c88..9805483 100644
--- a/drivers/video/tdfxfb.c
+++ b/drivers/video/tdfxfb.c
@@ -52,7 +52,7 @@
  *
  * 0.1.3 (released 1999-11-02)	added Attila's panning support, code
  *				reorg, hwcursor address page size alignment
- *				(for mmaping both frame buffer and regs),
+ *				(for mmapping both frame buffer and regs),
  *				and my changes to get rid of hardcoded
  *				VGA i/o register locations (uses PCI
  *				configuration info now)
diff --git a/drivers/video/via/dvi.c b/drivers/video/via/dvi.c
index c5c32b6..67b3693 100644
--- a/drivers/video/via/dvi.c
+++ b/drivers/video/via/dvi.c
@@ -467,7 +467,7 @@ static int dvi_get_panel_size_from_DDCv1(void)
 	default:
 		viaparinfo->tmds_setting_info->dvi_panel_size =
 			VIA_RES_1024X768;
-		DEBUG_MSG(KERN_INFO "Unknow panel size max resolution = %d !\
+		DEBUG_MSG(KERN_INFO "Unknown panel size max resolution = %d !\
 					 set default panel size.\n", max_h);
 		break;
 	}
@@ -534,7 +534,7 @@ static int dvi_get_panel_size_from_DDCv2(void)
 	default:
 		viaparinfo->tmds_setting_info->dvi_panel_size =
 			VIA_RES_1024X768;
-		DEBUG_MSG(KERN_INFO "Unknow panel size max resolution = %d!\
+		DEBUG_MSG(KERN_INFO "Unknown panel size max resolution = %d!\
 					set default panel size.\n", HSize);
 		break;
 	}
diff --git a/drivers/video/vt8623fb.c b/drivers/video/vt8623fb.c
index 3df17dc..65ccd21 100644
--- a/drivers/video/vt8623fb.c
+++ b/drivers/video/vt8623fb.c
@@ -446,7 +446,7 @@ static int vt8623fb_set_par(struct fb_info *info)
 
 	svga_wseq_mask(0x1E, 0xF0, 0xF0); // DI/DVP bus
 	svga_wseq_mask(0x2A, 0x0F, 0x0F); // DI/DVP bus
-	svga_wseq_mask(0x16, 0x08, 0xBF); // FIFO read treshold
+	svga_wseq_mask(0x16, 0x08, 0xBF); // FIFO read threshold
 	vga_wseq(NULL, 0x17, 0x1F);       // FIFO depth
 	vga_wseq(NULL, 0x18, 0x4E);
 	svga_wseq_mask(0x1A, 0x08, 0x08); // enable MMIO ?
diff --git a/drivers/watchdog/coh901327_wdt.c b/drivers/watchdog/coh901327_wdt.c
index 381026c..923cc68 100644
--- a/drivers/watchdog/coh901327_wdt.c
+++ b/drivers/watchdog/coh901327_wdt.c
@@ -508,7 +508,7 @@ void coh901327_watchdog_reset(void)
 	 * deactivating the watchdog before it is shut down by it.
 	 *
 	 * NOTE: on future versions of the watchdog, this restriction is
-	 * gone: the watchdog will be reloaded with a defaul value (1 min)
+	 * gone: the watchdog will be reloaded with a default value (1 min)
 	 * instead of last value, and you can conveniently set the watchdog
 	 * timeout to 10ms (value = 1) without any problems.
 	 */
diff --git a/drivers/watchdog/machzwd.c b/drivers/watchdog/machzwd.c
index b6b3f59..47d7197 100644
--- a/drivers/watchdog/machzwd.c
+++ b/drivers/watchdog/machzwd.c
@@ -21,7 +21,7 @@
  *      wd#1 - 2 seconds;
  *      wd#2 - 7.2 ms;
  *  After the expiration of wd#1, it can generate a NMI, SCI, SMI, or
- *  a system RESET and it starts wd#2 that unconditionaly will RESET
+ *  a system RESET and it starts wd#2 that unconditionally will RESET
  *  the system when the counter reaches zero.
  *
  *  14-Dec-2001 Matt Domsch <Matt_Domsch@dell.com>
diff --git a/drivers/watchdog/wdrtas.c b/drivers/watchdog/wdrtas.c
index 3bde56b..5bfb1f2 100644
--- a/drivers/watchdog/wdrtas.c
+++ b/drivers/watchdog/wdrtas.c
@@ -542,7 +542,7 @@ static struct notifier_block wdrtas_notifier = {
 /**
  * wdrtas_get_tokens - reads in RTAS tokens
  *
- * returns 0 on succes, <0 on failure
+ * returns 0 on success, <0 on failure
  *
  * wdrtas_get_tokens reads in the tokens for the RTAS calls used in
  * this watchdog driver. It tolerates, if "get-sensor-state" and
@@ -598,7 +598,7 @@ static void wdrtas_unregister_devs(void)
 /**
  * wdrtas_register_devs - registers the misc dev handlers
  *
- * returns 0 on succes, <0 on failure
+ * returns 0 on success, <0 on failure
  *
  * wdrtas_register_devs registers the watchdog and temperature watchdog
  * misc devs
@@ -630,7 +630,7 @@ static int wdrtas_register_devs(void)
 /**
  * wdrtas_init - init function of the watchdog driver
  *
- * returns 0 on succes, <0 on failure
+ * returns 0 on success, <0 on failure
  *
  * registers the file handlers and the reboot notifier
  */
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index b9b3bb5..d15ea17 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -767,7 +767,7 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	
 	current->mm->start_stack = bprm->p;
 
-	/* Now we do a little grungy work by mmaping the ELF image into
+	/* Now we do a little grungy work by mmapping the ELF image into
 	   the correct location in memory. */
 	for(i = 0, elf_ppnt = elf_phdata;
 	    i < loc->elf_ex.e_phnum; i++, elf_ppnt++) {
diff --git a/fs/bio.c b/fs/bio.c
index 12da5db..2bd671a 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -272,7 +272,7 @@ EXPORT_SYMBOL(bio_init);
  *   for a &struct bio to become free. If a %NULL @bs is passed in, we will
  *   fall back to just using @kmalloc to allocate the required memory.
  *
- *   Note that the caller must set ->bi_destructor on succesful return
+ *   Note that the caller must set ->bi_destructor on successful return
  *   of a bio, to do the appropriate freeing of the bio once the reference
  *   count drops to zero.
  **/
diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index ccbdcb5..46bea0f 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -256,7 +256,7 @@ out:
  * Insert @em into @tree or perform a simple forward/backward merge with
  * existing mappings.  The extent_map struct passed in will be inserted
  * into the tree directly, with an additional reference taken, or a
- * reference dropped if the merge attempt was sucessfull.
+ * reference dropped if the merge attempt was successfull.
  */
 int add_extent_mapping(struct extent_map_tree *tree,
 		       struct extent_map *em)
diff --git a/fs/cifs/README b/fs/cifs/README
index 79c1a93..a727b7c 100644
--- a/fs/cifs/README
+++ b/fs/cifs/README
@@ -423,7 +423,7 @@ A partial list of the supported mount options follows:
 		source name to use to represent the client netbios machine 
 		name when doing the RFC1001 netbios session initialize.
   direct        Do not do inode data caching on files opened on this mount.
-		This precludes mmaping files on this mount. In some cases
+		This precludes mmapping files on this mount. In some cases
 		with fast networks and little or no caching benefits on the
 		client (e.g. when the application is doing large sequential
 		reads bigger than page size without rereading the same data) 
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 5d0fde1..4b35f7e 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -39,7 +39,7 @@
 
 /*
  * MAX_REQ is the maximum number of requests that WE will send
- * on one socket concurently. It also matches the most common
+ * on one socket concurrently. It also matches the most common
  * value of max multiplex returned by servers.  We may
  * eventually want to use the negotiated value (in case
  * future servers can handle more) when we are more confident that
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index cababd8..cf18ee7 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -914,8 +914,8 @@ undo_setattr:
 /*
  * If dentry->d_inode is null (usually meaning the cached dentry
  * is a negative dentry) then we would attempt a standard SMB delete, but
- * if that fails we can not attempt the fall back mechanisms on EACESS
- * but will return the EACESS to the caller.  Note that the VFS does not call
+ * if that fails we can not attempt the fall back mechanisms on EACCESS
+ * but will return the EACCESS to the caller. Note that the VFS does not call
  * unlink on negative dentries currently.
  */
 int cifs_unlink(struct inode *dir, struct dentry *dentry)
diff --git a/fs/cifs/smbdes.c b/fs/cifs/smbdes.c
index 224a1f4..b6b6dcb 100644
--- a/fs/cifs/smbdes.c
+++ b/fs/cifs/smbdes.c
@@ -371,7 +371,7 @@ E_P24(unsigned char *p21, const unsigned char *c8, unsigned char *p24)
 	smbhash(p24 + 16, c8, p21 + 14, 1);
 }
 
-#if 0 /* currently unsued */
+#if 0 /* currently unused */
 static void
 D_P16(unsigned char *p14, unsigned char *in, unsigned char *out)
 {
diff --git a/fs/dlm/plock.c b/fs/dlm/plock.c
index 16f682e..b540aa5 100644
--- a/fs/dlm/plock.c
+++ b/fs/dlm/plock.c
@@ -143,7 +143,7 @@ out:
 }
 EXPORT_SYMBOL_GPL(dlm_posix_lock);
 
-/* Returns failure iff a succesful lock operation should be canceled */
+/* Returns failure iff a successful lock operation should be canceled */
 static int dlm_plock_callback(struct plock_op *op)
 {
 	struct file *file;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 2c8caa5..c2da491 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2933,7 +2933,7 @@ retry:
 		ret = write_cache_pages(mapping, wbc, __mpage_da_writepage,
 					&mpd);
 		/*
-		 * If we have a contigous extent of pages and we
+		 * If we have a contiguous extent of pages and we
 		 * haven't done the I/O yet, map the blocks and submit
 		 * them for I/O.
 		 */
@@ -5376,7 +5376,7 @@ static int ext4_index_trans_blocks(struct inode *inode, int nrblocks, int chunk)
  * worse case, the indexs blocks spread over different block groups
  *
  * If datablocks are discontiguous, they are possible to spread over
- * different block groups too. If they are contiugous, with flexbg,
+ * different block groups too. If they are contiuguous, with flexbg,
  * they could still across block group boundary.
  *
  * Also account for superblock, inode, quota and xattr blocks
@@ -5452,7 +5452,7 @@ int ext4_writepage_trans_blocks(struct inode *inode)
  * Calculate the journal credits for a chunk of data modification.
  *
  * This is called from DIO, fallocate or whoever calling
- * ext4_get_blocks() to map/allocate a chunk of contigous disk blocks.
+ * ext4_get_blocks() to map/allocate a chunk of contiguous disk blocks.
  *
  * journal buffers for data blocks are not included here, as DIO
  * and fallocate do no need to journal data buffers.
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index bba1282..74e495d 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -142,7 +142,7 @@
  * 2 blocks and the order of allocation is >= sbi->s_mb_order2_reqs. The
  * value of s_mb_order2_reqs can be tuned via
  * /sys/fs/ext4/<partition>/mb_order2_req.  If the request len is equal to
- * stripe size (sbi->s_stripe), we try to search for contigous block in
+ * stripe size (sbi->s_stripe), we try to search for contiguous block in
  * stripe size. This should result in better allocation on RAID setups. If
  * not, we search in the specific group using bitmap for best extents. The
  * tunable min_to_scan and max_to_scan control the behaviour here.
diff --git a/fs/jffs2/compr.c b/fs/jffs2/compr.c
index f25e70c..f029441 100644
--- a/fs/jffs2/compr.c
+++ b/fs/jffs2/compr.c
@@ -177,7 +177,7 @@ uint16_t jffs2_compress(struct jffs2_sb_info *c, struct jffs2_inode_info *f,
 		spin_unlock(&jffs2_compressor_list_lock);
 		break;
 	default:
-		printk(KERN_ERR "JFFS2: unknow compression mode.\n");
+		printk(KERN_ERR "JFFS2: unknown compression mode.\n");
 	}
  out:
 	if (ret == JFFS2_COMPR_NONE) {
diff --git a/fs/jffs2/readinode.c b/fs/jffs2/readinode.c
index 1a80301..378991c 100644
--- a/fs/jffs2/readinode.c
+++ b/fs/jffs2/readinode.c
@@ -931,7 +931,7 @@ static inline int read_unknown(struct jffs2_sb_info *c, struct jffs2_raw_node_re
  * Helper function for jffs2_get_inode_nodes().
  * The function detects whether more data should be read and reads it if yes.
  *
- * Returns: 0 on succes;
+ * Returns: 0 on success;
  * 	    negative error code on failure.
  */
 static int read_more(struct jffs2_sb_info *c, struct jffs2_raw_node_ref *ref,
diff --git a/fs/jffs2/xattr.c b/fs/jffs2/xattr.c
index 082e844..4b10788 100644
--- a/fs/jffs2/xattr.c
+++ b/fs/jffs2/xattr.c
@@ -31,7 +31,7 @@
  *   is used to release xattr name/value pair and detach from c->xattrindex.
  * reclaim_xattr_datum(c)
  *   is used to reclaim xattr name/value pairs on the xattr name/value pair cache when
- *   memory usage by cache is over c->xdatum_mem_threshold. Currentry, this threshold 
+ *   memory usage by cache is over c->xdatum_mem_threshold. Currently, this threshold 
  *   is hard coded as 32KiB.
  * do_verify_xattr_datum(c, xd)
  *   is used to load the xdatum informations without name/value pair from the medium.
diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index 2bc7d8a..d9b031c 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -755,7 +755,7 @@ int dbAlloc(struct inode *ip, s64 hint, s64 nblocks, s64 * results)
 	 * allocation group.
 	 */
 	if ((blkno & (bmp->db_agsize - 1)) == 0)
-		/* check if the AG is currenly being written to.
+		/* check if the AG is currently being written to.
 		 * if so, call dbNextAG() to find a non-busy
 		 * AG with sufficient free space.
 		 */
@@ -3337,7 +3337,7 @@ int dbExtendFS(struct inode *ipbmap, s64 blkno,	s64 nblocks)
 	for (i = 0, n = 0; i < agno; n++) {
 		bmp->db_agfree[n] = 0;	/* init collection point */
 
-		/* coalesce cotiguous k AGs; */
+		/* coalesce contiguous k AGs; */
 		for (j = 0; j < k && i < agno; j++, i++) {
 			/* merge AGi to AGn */
 			bmp->db_agfree[n] += bmp->db_agfree[i];
diff --git a/fs/ncpfs/ioctl.c b/fs/ncpfs/ioctl.c
index 0d58caf..ec8f45f 100644
--- a/fs/ncpfs/ioctl.c
+++ b/fs/ncpfs/ioctl.c
@@ -835,7 +835,7 @@ static int ncp_ioctl_need_write(unsigned int cmd)
 	case NCP_IOC_SETROOT:
 		return 0;
 	default:
-		/* unkown IOCTL command, assume write */
+		/* unknown IOCTL command, assume write */
 		return 1;
 	}
 }
diff --git a/fs/ntfs/compress.c b/fs/ntfs/compress.c
index 9669541..08f7530 100644
--- a/fs/ntfs/compress.c
+++ b/fs/ntfs/compress.c
@@ -927,7 +927,7 @@ lock_retry_remap:
 		return 0;
 
 	ntfs_debug("Failed. Returning error code %s.", err == -EOVERFLOW ?
-			"EOVERFLOW" : (!err ? "EIO" : "unkown error"));
+			"EOVERFLOW" : (!err ? "EIO" : "unknown error"));
 	return err < 0 ? err : -EIO;
 
 read_err:
diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index 663c0e3..43179dd 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -399,7 +399,7 @@ static inline void ntfs_fault_in_pages_readable_iovec(const struct iovec *iov,
  * @cached_page: allocated but as yet unused page
  * @lru_pvec:	lru-buffering pagevec of caller
  *
- * Obtain @nr_pages locked page cache pages from the mapping @maping and
+ * Obtain @nr_pages locked page cache pages from the mapping @mapping and
  * starting at index @index.
  *
  * If a page is newly created, increment its refcount and add it to the
@@ -1281,7 +1281,7 @@ rl_not_mapped_enoent:
 
 /*
  * Copy as much as we can into the pages and return the number of bytes which
- * were sucessfully copied.  If a fault is encountered then clear the pages
+ * were successfully copied.  If a fault is encountered then clear the pages
  * out to (ofs + bytes) and return the number of bytes which were copied.
  */
 static inline size_t ntfs_copy_from_user(struct page **pages,
diff --git a/fs/ntfs/logfile.c b/fs/ntfs/logfile.c
index 89b0298..4dadcdf 100644
--- a/fs/ntfs/logfile.c
+++ b/fs/ntfs/logfile.c
@@ -338,7 +338,7 @@ err_out:
  * copy of the complete multi sector transfer deprotected page.  On failure,
  * *@wrp is undefined.
  *
- * Simillarly, if @lsn is not NULL, on succes *@lsn will be set to the current
+ * Simillarly, if @lsn is not NULL, on success *@lsn will be set to the current
  * logfile lsn according to this restart page.  On failure, *@lsn is undefined.
  *
  * The following error codes are defined:
diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 38a42f5..7c7198a 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -2398,7 +2398,7 @@ static int ocfs2_leftmost_rec_contains(struct ocfs2_extent_list *el, u32 cpos)
  *
  * The array is assumed to be large enough to hold an entire path (tree depth).
  *
- * Upon succesful return from this function:
+ * Upon successful return from this function:
  *
  * - The 'right_path' array will contain a path to the leaf block
  *   whose range contains e_cpos.
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 83bcaf2..03ccf9a 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -2586,7 +2586,7 @@ fail:
 	 * is complete everywhere.  if the target dies while this is
 	 * going on, some nodes could potentially see the target as the
 	 * master, so it is important that my recovery finds the migration
-	 * mle and sets the master to UNKNONWN. */
+	 * mle and sets the master to UNKNOWN. */
 
 
 	/* wait for new node to assert master */
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 0d38d67..c5e4a49 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -1855,7 +1855,7 @@ int ocfs2_file_lock(struct file *file, int ex, int trylock)
 		 * outstanding lock request, so a cancel convert is
 		 * required. We intentionally overwrite 'ret' - if the
 		 * cancel fails and the lock was granted, it's easier
-		 * to just bubble sucess back up to the user.
+		 * to just bubble success back up to the user.
 		 */
 		ret = ocfs2_flock_handle_signal(lockres, level);
 	} else if (!ret && (level > lockres->l_level)) {
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 54c16b6..bf34c49 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -659,7 +659,7 @@ static int __ocfs2_journal_access(handle_t *handle,
 
 	default:
 		status = -EINVAL;
-		mlog(ML_ERROR, "Uknown access type!\n");
+		mlog(ML_ERROR, "Unknown access type!\n");
 	}
 	if (!status && ocfs2_meta_ecc(osb) && triggers)
 		jbd2_journal_set_triggers(bh, &triggers->ot_triggers);
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 60287fc..d00c658 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -2431,7 +2431,7 @@ out:
  * we gonna touch and whether we need to create new blocks.
  *
  * Normally the refcount blocks store these refcount should be
- * continguous also, so that we can get the number easily.
+ * contiguous also, so that we can get the number easily.
  * As for meta_ac, we will at most add split 2 refcount record and
  * 2 more refcount block, so just check it in a rough way.
  *
diff --git a/fs/omfs/bitmap.c b/fs/omfs/bitmap.c
index e1c0ec0..0822345 100644
--- a/fs/omfs/bitmap.c
+++ b/fs/omfs/bitmap.c
@@ -85,7 +85,7 @@ out:
 }
 
 /*
- * Tries to allocate exactly one block.  Returns true if sucessful.
+ * Tries to allocate exactly one block.  Returns true if successful.
  */
 int omfs_allocate_block(struct super_block *sb, u64 block)
 {
diff --git a/fs/ubifs/recovery.c b/fs/ubifs/recovery.c
index f94ddf7..868a55e 100644
--- a/fs/ubifs/recovery.c
+++ b/fs/ubifs/recovery.c
@@ -23,7 +23,7 @@
 /*
  * This file implements functions needed to recover from unclean un-mounts.
  * When UBIFS is mounted, it checks a flag on the master node to determine if
- * an un-mount was completed sucessfully. If not, the process of mounting
+ * an un-mount was completed successfully. If not, the process of mounting
  * incorparates additional checking and fixing of on-flash data structures.
  * UBIFS always cleans away all remnants of an unclean un-mount, so that
  * errors do not accumulate. However UBIFS defers recovery if it is mounted
diff --git a/fs/xfs/quota/xfs_dquot.h b/fs/xfs/quota/xfs_dquot.h
index 6533ead..a2c16bc 100644
--- a/fs/xfs/quota/xfs_dquot.h
+++ b/fs/xfs/quota/xfs_dquot.h
@@ -98,7 +98,7 @@ typedef struct xfs_dquot {
 #define dq_flags	q_lists.dqm_flags
 
 /*
- * Lock hierachy for q_qlock:
+ * Lock hierarchy for q_qlock:
  *	XFS_QLOCK_NORMAL is the implicit default,
  * 	XFS_QLOCK_NESTED is the dquot with the higher id in xfs_dqlock2
  */
diff --git a/include/asm-generic/memory_model.h b/include/asm-generic/memory_model.h
index 4c8d0af..fb2d63f 100644
--- a/include/asm-generic/memory_model.h
+++ b/include/asm-generic/memory_model.h
@@ -47,7 +47,7 @@
 
 #elif defined(CONFIG_SPARSEMEM_VMEMMAP)
 
-/* memmap is virtually contigious.  */
+/* memmap is virtually contiguous.  */
 #define __pfn_to_page(pfn)	(vmemmap + (pfn))
 #define __page_to_pfn(page)	(unsigned long)((page) - vmemmap)
 
diff --git a/include/asm-generic/unistd.h b/include/asm-generic/unistd.h
index d76b66a..7c38c14 100644
--- a/include/asm-generic/unistd.h
+++ b/include/asm-generic/unistd.h
@@ -631,7 +631,7 @@ __SYSCALL(__NR_perf_event_open, sys_perf_event_open)
  * these are provided for both review and as a porting
  * help for the C library version.
 *
- * Last chance: are any of these important enought to
+ * Last chance: are any of these important enough to
  * enable by default?
  */
 #ifdef __ARCH_WANT_SYSCALL_NO_AT
diff --git a/include/linux/chio.h b/include/linux/chio.h
index 519248d..d9bac7f 100644
--- a/include/linux/chio.h
+++ b/include/linux/chio.h
@@ -21,7 +21,7 @@
  *    query vendor-specific element types
  *
  *    accessing elements works by specifing type and unit of the element.
- *    for eample, storage elements are addressed with type = CHET_ST and
+ *    for example, storage elements are addressed with type = CHET_ST and
  *    unit = 0 .. cp_nslots-1
  *
  */
diff --git a/include/linux/mfd/ezx-pcap.h b/include/linux/mfd/ezx-pcap.h
index e5124ce..3402042 100644
--- a/include/linux/mfd/ezx-pcap.h
+++ b/include/linux/mfd/ezx-pcap.h
@@ -45,7 +45,7 @@ void pcap_set_ts_bits(struct pcap_chip *, u32);
 #define PCAP_CLEAR_INTERRUPT_REGISTER	0x01ffffff
 #define PCAP_MASK_ALL_INTERRUPT		0x01ffffff
 
-/* registers acessible by both pcap ports */
+/* registers accessible by both pcap ports */
 #define PCAP_REG_ISR		0x0	/* Interrupt Status */
 #define PCAP_REG_MSR		0x1	/* Interrupt Mask */
 #define PCAP_REG_PSTAT		0x2	/* Processor Status */
@@ -67,7 +67,7 @@ void pcap_set_ts_bits(struct pcap_chip *, u32);
 #define PCAP_REG_VENDOR_TEST1	0x1e
 #define PCAP_REG_VENDOR_TEST2	0x1f
 
-/* registers acessible by pcap port 1 only (a1200, e2 & e6) */
+/* registers accessible by pcap port 1 only (a1200, e2 & e6) */
 #define PCAP_REG_INT_SEL	0x3	/* Interrupt Select */
 #define PCAP_REG_SWCTRL		0x4	/* Switching Regulator Control */
 #define PCAP_REG_VREG1		0x5	/* Regulator Bank 1 Control */
diff --git a/include/linux/pktcdvd.h b/include/linux/pktcdvd.h
index d745f5b..76e5053 100644
--- a/include/linux/pktcdvd.h
+++ b/include/linux/pktcdvd.h
@@ -30,7 +30,7 @@
 
 /*
  * use drive write caching -- we need deferred error handling to be
- * able to sucessfully recover with this option (drive will return good
+ * able to successfully recover with this option (drive will return good
  * status as soon as the cdb is validated).
  */
 #if defined(CONFIG_CDROM_PKTCDVD_WCACHE)
diff --git a/include/linux/serial_reg.h b/include/linux/serial_reg.h
index 850db2e..cf9327c 100644
--- a/include/linux/serial_reg.h
+++ b/include/linux/serial_reg.h
@@ -216,10 +216,10 @@
 
 #define UART_IIR_TOD	0x08	/* Character Timeout Indication Detected */
 
-#define UART_FCR_PXAR1	0x00	/* receive FIFO treshold = 1 */
-#define UART_FCR_PXAR8	0x40	/* receive FIFO treshold = 8 */
-#define UART_FCR_PXAR16	0x80	/* receive FIFO treshold = 16 */
-#define UART_FCR_PXAR32	0xc0	/* receive FIFO treshold = 32 */
+#define UART_FCR_PXAR1	0x00	/* receive FIFO threshold = 1 */
+#define UART_FCR_PXAR8	0x40	/* receive FIFO threshold = 8 */
+#define UART_FCR_PXAR16	0x80	/* receive FIFO threshold = 16 */
+#define UART_FCR_PXAR32	0xc0	/* receive FIFO threshold = 32 */
 
 
 
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index b59e78c..dfd4745 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -490,7 +490,7 @@ struct v4l2_jpegcompression {
 				 * you do, leave them untouched.
 				 * Inluding less markers will make the
 				 * resulting code smaller, but there will
-				 * be fewer aplications which can read it.
+				 * be fewer applications which can read it.
 				 * The presence of the APP and COM marker
 				 * is influenced by APP_len and COM_len
 				 * ONLY, not by this property! */
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 6e5f0e0..ca4789e 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -988,7 +988,7 @@ struct sctp_transport {
 	int init_sent_count;
 
 	/* state       : The current state of this destination,
-	 *             : i.e. SCTP_ACTIVE, SCTP_INACTIVE, SCTP_UNKOWN.
+	 *             : i.e. SCTP_ACTIVE, SCTP_INACTIVE, SCTP_UNKNOWN.
 	 */
 	int state;
 
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 03a49c7..1827e7f 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1260,7 +1260,7 @@ static inline struct sk_buff *tcp_write_queue_prev(struct sock *sk, struct sk_bu
 	skb_queue_walk_from_safe(&(sk)->sk_write_queue, skb, tmp)
 
 /* This function calculates a "timeout" which is equivalent to the timeout of a
- * TCP connection after "boundary" unsucessful, exponentially backed-off
+ * TCP connection after "boundary" unsuccessful, exponentially backed-off
  * retransmissions with an initial RTO of TCP_RTO_MIN.
  */
 static inline bool retransmits_timed_out(const struct sock *sk,
diff --git a/include/net/wimax.h b/include/net/wimax.h
index 2af7bf8..3b07f6a 100644
--- a/include/net/wimax.h
+++ b/include/net/wimax.h
@@ -79,7 +79,7 @@
  * drivers have to only report state changes due to external
  * conditions.
  *
- * All API operations are 'atomic', serialized thorough a mutex in the
+ * All API operations are 'atomic', serialized through a mutex in the
  * `struct wimax_dev`.
  *
  * EXPORTING TO USER SPACE THROUGH GENERIC NETLINK
diff --git a/include/sound/wm8993.h b/include/sound/wm8993.h
index 9c661f2..eee19f6 100644
--- a/include/sound/wm8993.h
+++ b/include/sound/wm8993.h
@@ -36,7 +36,7 @@ struct wm8993_platform_data {
 	unsigned int micbias1_lvl:1;
 	unsigned int micbias2_lvl:1;
 
-	/* Jack detect threashold levels, see datasheet for values */
+	/* Jack detect threshold levels, see datasheet for values */
 	unsigned int jd_scthr:2;
 	unsigned int jd_thr:2;
 };
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 7f29643..759a629 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -419,7 +419,7 @@ static void perf_event_remove_from_context(struct perf_event *event)
 	if (!task) {
 		/*
 		 * Per cpu events are removed via an smp call and
-		 * the removal is always sucessful.
+		 * the removal is always successful.
 		 */
 		smp_call_function_single(event->cpu,
 					 __perf_event_remove_from_context,
@@ -827,7 +827,7 @@ perf_install_in_context(struct perf_event_context *ctx,
 	if (!task) {
 		/*
 		 * Per cpu events are installed via an smp call and
-		 * the install is always sucessful.
+		 * the install is always successful.
 		 */
 		smp_call_function_single(cpu, __perf_install_in_context,
 					 event, 1);
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 234ceb1..456b2bc 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -105,7 +105,7 @@ config DEBUG_SECTION_MISMATCH
 	bool "Enable full Section mismatch analysis"
 	depends on UNDEFINED
 	# This option is on purpose disabled for now.
-	# It will be enabled when we are down to a resonable number
+	# It will be enabled when we are down to a reasonable number
 	# of section mismatch warnings (< 10 for an allyesconfig build)
 	help
 	  The section mismatch analysis checks if there are illegal
diff --git a/lib/decompress_bunzip2.c b/lib/decompress_bunzip2.c
index 600f473..7607420 100644
--- a/lib/decompress_bunzip2.c
+++ b/lib/decompress_bunzip2.c
@@ -299,7 +299,7 @@ static int INIT get_next_block(struct bunzip_data *bd)
 		   again when using them (during symbol decoding).*/
 		base = hufGroup->base-1;
 		limit = hufGroup->limit-1;
-		/* Calculate permute[].  Concurently, initialize
+		/* Calculate permute[].  Concurrently, initialize
 		 * temp[] and limit[]. */
 		pp = 0;
 		for (i = minLen; i <= maxLen; i++) {
diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index ce6b7ea..d9b08e0 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -259,7 +259,7 @@ static struct dma_debug_entry *hash_bucket_find(struct hash_bucket *bucket,
 		 * times. Without a hardware IOMMU this results in the
 		 * same device addresses being put into the dma-debug
 		 * hash multiple times too. This can result in false
-		 * positives being reported. Therfore we implement a
+		 * positives being reported. Therefore we implement a
 		 * best-fit algorithm here which returns the entry from
 		 * the hash which fits best to the reference value
 		 * instead of the first-fit.
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index ac25cd2..853907e 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -453,7 +453,7 @@ do_unmap_single(struct device *hwdev, char *dma_addr, size_t size, int dir)
 
 	/*
 	 * Return the buffer to the free list by setting the corresponding
-	 * entries to indicate the number of contigous entries available.
+	 * entries to indicate the number of contiguous entries available.
 	 * While returning the entries to the free list, we merge the entries
 	 * with slots below and above the pool being returned.
 	 */
diff --git a/mm/filemap.c b/mm/filemap.c
index ef169f3..c3d3506 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1844,7 +1844,7 @@ static size_t __iovec_copy_from_user_inatomic(char *vaddr,
 
 /*
  * Copy as much as we can into the page and return the number of bytes which
- * were sucessfully copied.  If a fault is encountered then return the number of
+ * were successfully copied.  If a fault is encountered then return the number of
  * bytes which were copied.
  */
 size_t iov_iter_copy_from_user_atomic(struct page *page,
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f99f599..5202299 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -209,7 +209,7 @@ struct mem_cgroup {
 	int	prev_priority;	/* for recording reclaim priority */
 
 	/*
-	 * While reclaiming in a hiearchy, we cache the last child we
+	 * While reclaiming in a hierarchy, we cache the last child we
 	 * reclaimed from.
 	 */
 	int last_scanned_child;
@@ -2466,7 +2466,7 @@ static int mem_cgroup_hierarchy_write(struct cgroup *cont, struct cftype *cft,
 
 	cgroup_lock();
 	/*
-	 * If parent's use_hiearchy is set, we can't make any modifications
+	 * If parent's use_hierarchy is set, we can't make any modifications
 	 * in the child subtrees. If it is unset, then the change can
 	 * occur, provided the current cgroup has no children.
 	 *
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index dacc641..1ac49fe 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -174,7 +174,7 @@ static void kill_procs_ao(struct list_head *to_kill, int doit, int trapno,
 	list_for_each_entry_safe (tk, next, to_kill, nd) {
 		if (doit) {
 			/*
-			 * In case something went wrong with munmaping
+			 * In case something went wrong with munmapping
 			 * make sure the process doesn't catch the
 			 * signal and then access the memory. Just kill it.
 			 * the signal handlers
diff --git a/net/ipv4/netfilter/ipt_ECN.c b/net/ipv4/netfilter/ipt_ECN.c
index f7e2fa0..16ad251 100644
--- a/net/ipv4/netfilter/ipt_ECN.c
+++ b/net/ipv4/netfilter/ipt_ECN.c
@@ -50,7 +50,7 @@ set_ect_tcp(struct sk_buff *skb, const struct ipt_ECN_info *einfo)
 	struct tcphdr _tcph, *tcph;
 	__be16 oldval;
 
-	/* Not enought header? */
+	/* Not enough header? */
 	tcph = skb_header_pointer(skb, ip_hdrlen(skb), sizeof(_tcph), &_tcph);
 	if (!tcph)
 		return false;
diff --git a/net/irda/irlap.c b/net/irda/irlap.c
index 356e65b..783c5f3 100644
--- a/net/irda/irlap.c
+++ b/net/irda/irlap.c
@@ -450,10 +450,10 @@ void irlap_disconnect_request(struct irlap_cb *self)
 
 	/* Check if we are in the right state for disconnecting */
 	switch (self->state) {
-	case LAP_XMIT_P:        /* FALLTROUGH */
-	case LAP_XMIT_S:        /* FALLTROUGH */
-	case LAP_CONN:          /* FALLTROUGH */
-	case LAP_RESET_WAIT:    /* FALLTROUGH */
+	case LAP_XMIT_P:        /* FALLTHROUGH */
+	case LAP_XMIT_S:        /* FALLTHROUGH */
+	case LAP_CONN:          /* FALLTHROUGH */
+	case LAP_RESET_WAIT:    /* FALLTHROUGH */
 	case LAP_RESET_CHECK:
 		irlap_do_event(self, DISCONNECT_REQUEST, NULL, NULL);
 		break;
@@ -485,9 +485,9 @@ void irlap_disconnect_indication(struct irlap_cb *self, LAP_REASON reason)
 		IRDA_DEBUG(1, "%s(), Sending reset request!\n", __func__);
 		irlap_do_event(self, RESET_REQUEST, NULL, NULL);
 		break;
-	case LAP_NO_RESPONSE:	   /* FALLTROUGH */
-	case LAP_DISC_INDICATION:  /* FALLTROUGH */
-	case LAP_FOUND_NONE:       /* FALLTROUGH */
+	case LAP_NO_RESPONSE:	   /* FALLTHROUGH */
+	case LAP_DISC_INDICATION:  /* FALLTHROUGH */
+	case LAP_FOUND_NONE:       /* FALLTHROUGH */
 	case LAP_MEDIA_BUSY:
 		irlmp_link_disconnect_indication(self->notify.instance, self,
 						 reason, NULL);
diff --git a/net/irda/irlap_event.c b/net/irda/irlap_event.c
index c5c5195..94a9884 100644
--- a/net/irda/irlap_event.c
+++ b/net/irda/irlap_event.c
@@ -1741,7 +1741,7 @@ static int irlap_state_reset(struct irlap_cb *self, IRLAP_EVENT event,
  * Function irlap_state_xmit_s (event, skb, info)
  *
  *   XMIT_S, The secondary station has been given the right to transmit,
- *   and we therefor do not expect to receive any transmissions from other
+ *   and we therefore do not expect to receive any transmissions from other
  *   stations.
  */
 static int irlap_state_xmit_s(struct irlap_cb *self, IRLAP_EVENT event,
diff --git a/net/irda/irlmp.c b/net/irda/irlmp.c
index 7bf5b91..0e7d8bd 100644
--- a/net/irda/irlmp.c
+++ b/net/irda/irlmp.c
@@ -105,7 +105,7 @@ int __init irlmp_init(void)
 
 	init_timer(&irlmp->discovery_timer);
 
-	/* Do discovery every 3 seconds, conditionaly */
+	/* Do discovery every 3 seconds, conditionally */
 	if (sysctl_discovery)
 		irlmp_start_discovery_timer(irlmp,
 					    sysctl_discovery_timeout*HZ);
@@ -1842,7 +1842,7 @@ LM_REASON irlmp_convert_lap_reason( LAP_REASON lap_reason)
 		reason = LM_CONNECT_FAILURE;
 		break;
 	default:
-		IRDA_DEBUG(1, "%s(), Unknow IrLAP disconnect reason %d!\n",
+		IRDA_DEBUG(1, "%s(), Unknown IrLAP disconnect reason %d!\n",
 			   __func__, lap_reason);
 		reason = LM_LAP_DISCONNECT;
 		break;
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 751c4d0..719ddbc 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -244,7 +244,7 @@ struct mesh_path *mesh_path_lookup_by_idx(int idx, struct ieee80211_sub_if_data
  * @addr: destination address of the path (ETH_ALEN length)
  * @sdata: local subif
  *
- * Returns: 0 on sucess
+ * Returns: 0 on success
  *
  * State: the initial state of the new path is set to 0
  */
@@ -530,7 +530,7 @@ static void mesh_path_node_reclaim(struct rcu_head *rp)
  * @addr: dst address (ETH_ALEN length)
  * @sdata: local subif
  *
- * Returns: 0 if succesful
+ * Returns: 0 if successful
  */
 int mesh_path_del(u8 *addr, struct ieee80211_sub_if_data *sdata)
 {
diff --git a/net/netlabel/netlabel_domainhash.c b/net/netlabel/netlabel_domainhash.c
index 7a10bbe..c5d9f97 100644
--- a/net/netlabel/netlabel_domainhash.c
+++ b/net/netlabel/netlabel_domainhash.c
@@ -682,7 +682,7 @@ struct netlbl_domaddr6_map *netlbl_domhsh_getentry_af6(const char *domain,
  * buckets and @skip_chain entries.  For each entry in the table call
  * @callback, if @callback returns a negative value stop 'walking' through the
  * table and return.  Updates the values in @skip_bkt and @skip_chain on
- * return.  Returns zero on succcess, negative values on failure.
+ * return.  Returns zero on success, negative values on failure.
  *
  */
 int netlbl_domhsh_walk(u32 *skip_bkt,
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 8674d49..29d8501 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -719,7 +719,7 @@ static void sctp_cmd_new_state(sctp_cmd_seq_t *cmds,
 
 	if (sctp_style(sk, TCP)) {
 		/* Change the sk->sk_state of a TCP-style socket that has
-		 * sucessfully completed a connect() call.
+		 * successfully completed a connect() call.
 		 */
 		if (sctp_state(asoc, ESTABLISHED) && sctp_sstate(sk, CLOSED))
 			sk->sk_state = SCTP_SS_ESTABLISHED;
diff --git a/net/sunrpc/xprtrdma/svc_rdma_sendto.c b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
index f11be72..b15e1eb 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_sendto.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
@@ -54,7 +54,7 @@
  * Assumptions:
  * - head[0] is physically contiguous.
  * - tail[0] is physically contiguous.
- * - pages[] is not physically or virtually contigous and consists of
+ * - pages[] is not physically or virtually contiguous and consists of
  *   PAGE_SIZE elements.
  *
  * Output:
diff --git a/net/wimax/op-reset.c b/net/wimax/op-reset.c
index ca26917..35f3700 100644
--- a/net/wimax/op-reset.c
+++ b/net/wimax/op-reset.c
@@ -62,7 +62,7 @@
  * Called when wanting to reset the device for any reason. Device is
  * taken back to power on status.
  *
- * This call blocks; on succesful return, the device has completed the
+ * This call blocks; on successful return, the device has completed the
  * reset process and is ready to operate.
  */
 int wimax_reset(struct wimax_dev *wimax_dev)
diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index d829535..8413cf3 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -213,7 +213,7 @@ load_config_help[] = N_(
 	"to modify that configuration.\n"
 	"\n"
 	"If you are uncertain, then you have probably never used alternate\n"
-	"configuration files.  You should therefor leave this blank to abort.\n"),
+	"configuration files. You should therefore leave this blank to abort.\n"),
 save_config_text[] = N_(
 	"Enter a filename to which this configuration should be saved "
 	"as an alternate.  Leave blank to abort."),
diff --git a/security/selinux/netlabel.c b/security/selinux/netlabel.c
index e688237..2534400 100644
--- a/security/selinux/netlabel.c
+++ b/security/selinux/netlabel.c
@@ -204,7 +204,7 @@ int selinux_netlbl_skbuff_getsid(struct sk_buff *skb,
  *
  * Description
  * Call the NetLabel mechanism to set the label of a packet using @sid.
- * Returns zero on auccess, negative values on failure.
+ * Returns zero on success, negative values on failure.
  *
  */
 int selinux_netlbl_skbuff_setsid(struct sk_buff *skb,
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index ff17820..5914eeb 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -741,7 +741,7 @@ int security_bounded_transition(u32 old_sid, u32 new_sid)
 		goto out;
 	}
 
-	/* type/domain unchaned */
+	/* type/domain unchanged */
 	if (old_context->type == new_context->type) {
 		rc = 0;
 		goto out;
diff --git a/sound/Kconfig b/sound/Kconfig
index 439e15c..b3e53e6 100644
--- a/sound/Kconfig
+++ b/sound/Kconfig
@@ -58,7 +58,7 @@ config SOUND_OSS_CORE_PRECLAIM
 	  Please read Documentation/feature-removal-schedule.txt for
 	  details.
 
-	  If unusre, say Y.
+	  If unsure, say Y.
 
 source "sound/oss/dmasound/Kconfig"
 
diff --git a/sound/isa/cs423x/cs4236.c b/sound/isa/cs423x/cs4236.c
index a076a6c..a828baa 100644
--- a/sound/isa/cs423x/cs4236.c
+++ b/sound/isa/cs423x/cs4236.c
@@ -177,7 +177,7 @@ static struct pnp_card_device_id snd_cs423x_pnpids[] = {
 	{ .id = "CSC0437", .devs = { { "CSC0000" }, { "CSC0010" }, { "CSC0003" } } },
 	/* Digital PC 5000 Onboard - CS4236B */
 	{ .id = "CSC0735", .devs = { { "CSC0000" }, { "CSC0010" } } },
-	/* some uknown CS4236B */
+	/* some unknown CS4236B */
 	{ .id = "CSC0b35", .devs = { { "CSC0000" }, { "CSC0010" }, { "CSC0003" } } },
 	/* Intel PR440FX Onboard sound */
 	{ .id = "CSC0b36", .devs = { { "CSC0000" }, { "CSC0010" }, { "CSC0003" } } },
diff --git a/sound/isa/opti9xx/miro.c b/sound/isa/opti9xx/miro.c
index 02e30d7..ddad60e 100644
--- a/sound/isa/opti9xx/miro.c
+++ b/sound/isa/opti9xx/miro.c
@@ -137,7 +137,7 @@ struct snd_miro {
 static void snd_miro_proc_init(struct snd_miro * miro);
 
 static char * snd_opti9xx_names[] = {
-	"unkown",
+	"unknown",
 	"82C928", "82C929",
 	"82C924", "82C925",
 	"82C930", "82C931", "82C933"
diff --git a/sound/isa/opti9xx/opti92x-ad1848.c b/sound/isa/opti9xx/opti92x-ad1848.c
index 5cd5553..8480075 100644
--- a/sound/isa/opti9xx/opti92x-ad1848.c
+++ b/sound/isa/opti9xx/opti92x-ad1848.c
@@ -185,7 +185,7 @@ MODULE_DEVICE_TABLE(pnp_card, snd_opti9xx_pnpids);
 #endif
 
 static char * snd_opti9xx_names[] = {
-	"unkown",
+	"unknown",
 	"82C928",	"82C929",
 	"82C924",	"82C925",
 	"82C930",	"82C931",	"82C933"
diff --git a/sound/oss/dmasound/dmasound_paula.c b/sound/oss/dmasound/dmasound_paula.c
index 06e9e88..bb14e4c 100644
--- a/sound/oss/dmasound/dmasound_paula.c
+++ b/sound/oss/dmasound/dmasound_paula.c
@@ -657,7 +657,7 @@ static int AmiStateInfo(char *buffer, size_t space)
 	len += sprintf(buffer+len, "\tsound.volume_right = %d [0...64]\n",
 		       dmasound.volume_right);
 	if (len >= space) {
-		printk(KERN_ERR "dmasound_paula: overlowed state buffer alloc.\n") ;
+		printk(KERN_ERR "dmasound_paula: overflowed state buffer alloc.\n") ;
 		len = space ;
 	}
 	return len;
diff --git a/sound/pci/ca0106/ca0106_proc.c b/sound/pci/ca0106/ca0106_proc.c
index c62b7d1..8d13092 100644
--- a/sound/pci/ca0106/ca0106_proc.c
+++ b/sound/pci/ca0106/ca0106_proc.c
@@ -233,7 +233,7 @@ static void snd_ca0106_proc_dump_iec958( struct snd_info_buffer *buffer, u32 val
 			snd_iprintf(buffer, "user-defined\n");
 			break;
 		default:
-			snd_iprintf(buffer, "unkown\n");
+			snd_iprintf(buffer, "unknown\n");
 			break;
 		}
 		snd_iprintf(buffer, "Sample Bits: ");
diff --git a/sound/pci/cs46xx/imgs/cwcdma.asp b/sound/pci/cs46xx/imgs/cwcdma.asp
index 09d24c7..a65e119 100644
--- a/sound/pci/cs46xx/imgs/cwcdma.asp
+++ b/sound/pci/cs46xx/imgs/cwcdma.asp
@@ -26,10 +26,11 @@
 //
 //
 // The purpose of this code is very simple: make it possible to tranfser
-// the samples 'as they are' with no alteration from a PCMreader SCB (DMA from host)
-// to any other SCB. This is useful for AC3 throug SPDIF. SRC (source rate converters) 
-// task always alters the samples in some how, however it's from 48khz -> 48khz. The
-// alterations are not audible, but AC3 wont work. 
+// the samples 'as they are' with no alteration from a PCMreader
+// SCB (DMA from host) to any other SCB. This is useful for AC3 through SPDIF.
+// SRC (source rate converters) task always alters the samples in somehow,
+// however it's from 48khz -> 48khz.
+// The alterations are not audible, but AC3 wont work. 
 //
 //        ...
 //         |
diff --git a/sound/pci/emu10k1/emu10k1x.c b/sound/pci/emu10k1/emu10k1x.c
index 36e08bd..360e380 100644
--- a/sound/pci/emu10k1/emu10k1x.c
+++ b/sound/pci/emu10k1/emu10k1x.c
@@ -184,7 +184,7 @@ MODULE_PARM_DESC(enable, "Enable the EMU10K1X soundcard.");
  * The hardware has 3 channels for playback and 1 for capture.
  *  - channel 0 is the front channel
  *  - channel 1 is the rear channel
- *  - channel 2 is the center/lfe chanel
+ *  - channel 2 is the center/lfe channel
  * Volume is controlled by the AC97 for the front and rear channels by
  * the PCM Playback Volume, Sigmatel Surround Playback Volume and 
  * Surround Playback Volume. The Sigmatel 4-Speaker Stereo switch affects
diff --git a/sound/pci/hda/patch_cmedia.c b/sound/pci/hda/patch_cmedia.c
index 780e1a7..8917071 100644
--- a/sound/pci/hda/patch_cmedia.c
+++ b/sound/pci/hda/patch_cmedia.c
@@ -66,7 +66,7 @@ struct cmi_spec {
 
 	struct hda_pcm pcm_rec[2];	/* PCM information */
 
-	/* pin deafault configuration */
+	/* pin default configuration */
 	hda_nid_t pin_nid[NUM_PINS];
 	unsigned int def_conf[NUM_PINS];
 	unsigned int pin_def_confs;
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index daf6975..3166086 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6619,7 +6619,7 @@ static struct hda_input_mux alc889A_mb31_capture_source = {
 		/* Front Mic (0x01) unused */
 		{ "Line", 0x2 },
 		/* Line 2 (0x03) unused */
-		/* CD (0x04) unsused? */
+		/* CD (0x04) unused? */
 	},
 };
 
diff --git a/sound/pci/rme9652/hdspm.c b/sound/pci/rme9652/hdspm.c
index 0dce331..a1b10d1 100644
--- a/sound/pci/rme9652/hdspm.c
+++ b/sound/pci/rme9652/hdspm.c
@@ -3017,7 +3017,7 @@ snd_hdspm_proc_read_madi(struct snd_info_entry * entry,
 		insel = "Coaxial";
 		break;
 	default:
-		insel = "Unkown";
+		insel = "Unknown";
 	}
 
 	switch (hdspm->control_register & HDSPM_SyncRefMask) {
@@ -3028,7 +3028,7 @@ snd_hdspm_proc_read_madi(struct snd_info_entry * entry,
 		syncref = "MADI";
 		break;
 	default:
-		syncref = "Unkown";
+		syncref = "Unknown";
 	}
 	snd_iprintf(buffer, "Inputsel = %s, SyncRef = %s\n", insel,
 		    syncref);
diff --git a/sound/soc/codecs/uda134x.c b/sound/soc/codecs/uda134x.c
index c33b92e..8ce1c9b 100644
--- a/sound/soc/codecs/uda134x.c
+++ b/sound/soc/codecs/uda134x.c
@@ -101,7 +101,7 @@ static int uda134x_write(struct snd_soc_codec *codec, unsigned int reg,
 	pr_debug("%s reg: %02X, value:%02X\n", __func__, reg, value);
 
 	if (reg >= UDA134X_REGS_NUM) {
-		printk(KERN_ERR "%s unkown register: reg: %u",
+		printk(KERN_ERR "%s unknown register: reg: %u",
 		       __func__, reg);
 		return -EINVAL;
 	}
@@ -552,7 +552,7 @@ static int uda134x_soc_probe(struct platform_device *pdev)
 					ARRAY_SIZE(uda1341_snd_controls));
 	break;
 	default:
-		printk(KERN_ERR "%s unkown codec type: %d",
+		printk(KERN_ERR "%s unknown codec type: %d",
 			__func__, pd->model);
 	return -EINVAL;
 	}
diff --git a/sound/soc/codecs/wm8903.c b/sound/soc/codecs/wm8903.c
index fe1307b..d72347d 100644
--- a/sound/soc/codecs/wm8903.c
+++ b/sound/soc/codecs/wm8903.c
@@ -607,7 +607,7 @@ SOC_SINGLE("Right Input PGA Common Mode Switch", WM8903_ANALOGUE_RIGHT_INPUT_1,
 SOC_SINGLE("DRC Switch", WM8903_DRC_0, 15, 1, 0),
 SOC_ENUM("DRC Compressor Slope R0", drc_slope_r0),
 SOC_ENUM("DRC Compressor Slope R1", drc_slope_r1),
-SOC_SINGLE_TLV("DRC Compressor Threashold Volume", WM8903_DRC_3, 5, 124, 1,
+SOC_SINGLE_TLV("DRC Compressor Threshold Volume", WM8903_DRC_3, 5, 124, 1,
 	       drc_tlv_thresh),
 SOC_SINGLE_TLV("DRC Volume", WM8903_DRC_3, 0, 30, 1, drc_tlv_amp),
 SOC_SINGLE_TLV("DRC Minimum Gain Volume", WM8903_DRC_1, 2, 3, 1, drc_tlv_min),
@@ -617,11 +617,11 @@ SOC_ENUM("DRC Decay Rate", drc_decay),
 SOC_ENUM("DRC FF Delay", drc_ff_delay),
 SOC_SINGLE("DRC Anticlip Switch", WM8903_DRC_0, 1, 1, 0),
 SOC_SINGLE("DRC QR Switch", WM8903_DRC_0, 2, 1, 0),
-SOC_SINGLE_TLV("DRC QR Threashold Volume", WM8903_DRC_0, 6, 3, 0, drc_tlv_max),
+SOC_SINGLE_TLV("DRC QR Threshold Volume", WM8903_DRC_0, 6, 3, 0, drc_tlv_max),
 SOC_ENUM("DRC QR Decay Rate", drc_qr_decay),
 SOC_SINGLE("DRC Smoothing Switch", WM8903_DRC_0, 3, 1, 0),
 SOC_SINGLE("DRC Smoothing Hysteresis Switch", WM8903_DRC_0, 0, 1, 0),
-SOC_ENUM("DRC Smoothing Threashold", drc_smoothing),
+SOC_ENUM("DRC Smoothing Threshold", drc_smoothing),
 SOC_SINGLE_TLV("DRC Startup Volume", WM8903_DRC_0, 6, 18, 0, drc_tlv_startup),
 
 SOC_DOUBLE_R_TLV("Digital Capture Volume", WM8903_ADC_DIGITAL_VOLUME_LEFT,
diff --git a/sound/soc/codecs/wm8993.c b/sound/soc/codecs/wm8993.c
index d998799..bc03368 100644
--- a/sound/soc/codecs/wm8993.c
+++ b/sound/soc/codecs/wm8993.c
@@ -689,7 +689,7 @@ SOC_DOUBLE_TLV("Digital Sidetone Volume", WM8993_DIGITAL_SIDE_TONE,
 
 SOC_SINGLE("DRC Switch", WM8993_DRC_CONTROL_1, 15, 1, 0),
 SOC_ENUM("DRC Path", drc_path),
-SOC_SINGLE_TLV("DRC Compressor Threashold Volume", WM8993_DRC_CONTROL_2,
+SOC_SINGLE_TLV("DRC Compressor Threshold Volume", WM8993_DRC_CONTROL_2,
 	       2, 60, 1, drc_comp_threash),
 SOC_SINGLE_TLV("DRC Compressor Amplitude Volume", WM8993_DRC_CONTROL_3,
 	       11, 30, 1, drc_comp_amp),
@@ -709,7 +709,7 @@ SOC_SINGLE_TLV("DRC Quick Release Volume", WM8993_DRC_CONTROL_3, 2, 3, 0,
 SOC_ENUM("DRC Quick Release Rate", drc_qr_rate),
 SOC_SINGLE("DRC Smoothing Switch", WM8993_DRC_CONTROL_1, 11, 1, 0),
 SOC_SINGLE("DRC Smoothing Hysteresis Switch", WM8993_DRC_CONTROL_1, 8, 1, 0),
-SOC_ENUM("DRC Smoothing Hysteresis Threashold", drc_smooth),
+SOC_ENUM("DRC Smoothing Hysteresis Threshold", drc_smooth),
 SOC_SINGLE_TLV("DRC Startup Volume", WM8993_DRC_CONTROL_4, 8, 18, 0,
 	       drc_startup_tlv),
 
diff --git a/sound/soc/s3c24xx/s3c24xx_simtec.c b/sound/soc/s3c24xx/s3c24xx_simtec.c
index 1966e0d..3c7ccb7 100644
--- a/sound/soc/s3c24xx/s3c24xx_simtec.c
+++ b/sound/soc/s3c24xx/s3c24xx_simtec.c
@@ -270,7 +270,7 @@ static int attach_gpio_amp(struct device *dev,
 		gpio_direction_output(pd->amp_gain[1], 0);
 	}
 
-	/* note, curently we assume GPA0 isn't valid amp */
+	/* note, currently we assume GPA0 isn't valid amp */
 	if (pdata->amp_gpio > 0) {
 		ret = gpio_request(pd->amp_gpio, "gpio-amp");
 		if (ret) {
diff --git a/sound/soc/s6000/s6000-pcm.c b/sound/soc/s6000/s6000-pcm.c
index 83b8028..81d6f98 100644
--- a/sound/soc/s6000/s6000-pcm.c
+++ b/sound/soc/s6000/s6000-pcm.c
@@ -196,7 +196,7 @@ static int s6000_pcm_start(struct snd_pcm_substream *substream)
 			   0 /* destination skip after chunk (impossible) */,
 			   4 /* 16 byte burst size */,
 			   -1 /* don't conserve bandwidth */,
-			   0 /* low watermark irq descriptor theshold */,
+			   0 /* low watermark irq descriptor threshold */,
 			   0 /* disable hardware timestamps */,
 			   1 /* enable channel */);
 
diff --git a/sound/sound_core.c b/sound/sound_core.c
index 49c9981..dbca7c9 100644
--- a/sound/sound_core.c
+++ b/sound/sound_core.c
@@ -353,7 +353,7 @@ static struct sound_unit *chains[SOUND_STEP];
  *      @dev: device pointer
  *
  *	Allocate a special sound device by minor number from the sound
- *	subsystem. The allocated number is returned on succes. On failure
+ *	subsystem. The allocated number is returned on success. On failure
  *	a negative error code is returned.
  */
  
-- 
1.6.5.2.180.gc5b3e.dirty

