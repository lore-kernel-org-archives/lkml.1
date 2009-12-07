Return-Path: <linux-kernel-owner+w=401wt.eu-S1758279AbZLGRxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758279AbZLGRxM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 12:53:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758250AbZLGRxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 12:53:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53386 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758226AbZLGRxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 12:53:03 -0500
Date: Mon, 7 Dec 2009 18:53:08 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] trivial
Message-ID: <alpine.LNX.2.00.0912071844520.3755@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

could you please pull from 'for-linus' branch of

        git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git for-linus

to receive accumulated trivial fixes all over the tree.

The diffstat looks quite huge, mostly because this time we have several patches
that fix up some common typos all over the tree (but usually it makes sense to
fix these, as they make grepping for things much more convenient).

In addition to that, we have some Documentation updates, __init/__exit cleanups
and removal of some code that has been dead for years.

Thanks.

 Documentation/ABI/testing/procfs-diskstats         |    2 +-
 Documentation/ABI/testing/sysfs-block              |    2 +-
 Documentation/DocBook/genericirq.tmpl              |    4 +-
 Documentation/DocBook/mtdnand.tmpl                 |    2 +-
 Documentation/DocBook/v4l/videodev2.h.xml          |    2 +-
 Documentation/DocBook/writing-an-alsa-driver.tmpl  |    2 +-
 Documentation/dvb/README.dvb-usb                   |    2 +-
 Documentation/edac.txt                             |    7 +-
 Documentation/lguest/lguest.c                      |    2 +-
 Documentation/oops-tracing.txt                     |    2 +
 Documentation/power/regulator/consumer.txt         |    2 +-
 Documentation/scsi/ChangeLog.megaraid_sas          |    2 +-
 Documentation/spi/spi-summary                      |    2 +-
 Documentation/sysctl/kernel.txt                    |    6 +-
 Documentation/sysctl/vm.txt                        |    2 +-
 Documentation/timers/hpet.txt                      |    2 +-
 Documentation/video4linux/gspca.txt                |    2 +-
 Documentation/vm/page-types.c                      |    2 +-
 Documentation/vm/slub.txt                          |    2 +-
 arch/alpha/mm/numa.c                               |    2 +-
 arch/arm/common/scoop.c                            |    2 +-
 arch/arm/mach-bcmring/include/csp/reg.h            |    2 +-
 .../mach-bcmring/include/mach/csp/dmacHw_priv.h    |    2 +-
 arch/arm/mach-bcmring/include/mach/csp/mm_addr.h   |    2 +-
 arch/arm/mach-bcmring/include/mach/dma.h           |    2 +-
 arch/arm/mach-lh7a40x/include/mach/hardware.h      |    2 +-
 arch/arm/mach-orion5x/pci.c                        |    2 +-
 arch/arm/mach-pxa/include/mach/palmld.h            |    2 +-
 arch/arm/mach-pxa/include/mach/palmt5.h            |    2 +-
 arch/arm/mach-pxa/include/mach/palmtc.h            |    2 +-
 arch/arm/mach-pxa/include/mach/palmte2.h           |    2 +-
 arch/arm/mach-pxa/include/mach/palmtx.h            |    2 +-
 arch/arm/mach-pxa/include/mach/palmz72.h           |    2 +-
 arch/arm/mach-s3c2400/Kconfig                      |    6 --
 arch/arm/mach-s3c2410/Kconfig                      |    2 -
 arch/arm/mach-s3c2412/Kconfig                      |    4 -
 arch/arm/mach-s3c2440/Kconfig                      |    3 -
 arch/arm/mach-s3c2442/Kconfig                      |    4 -
 arch/arm/mach-s3c2443/Kconfig                      |    2 -
 arch/arm/mach-s3c6400/Kconfig                      |    2 -
 arch/arm/mach-s3c6400/setup-sdhci.c                |    2 +-
 arch/arm/mach-s3c6410/Kconfig                      |    2 -
 arch/arm/mach-s3c6410/setup-sdhci.c                |    2 +-
 arch/arm/mach-s5pc100/Kconfig                      |    2 -
 arch/arm/mach-sa1100/dma.c                         |    2 +-
 arch/arm/mach-u300/include/mach/u300-regs.h        |    2 +-
 arch/arm/plat-mxc/include/mach/iomux-mx3.h         |    2 +-
 arch/arm/plat-mxc/include/mach/iomux-mxc91231.h    |    2 +-
 arch/arm/plat-mxc/pwm.c                            |    2 +-
 arch/arm/plat-omap/dma.c                           |    2 +-
 arch/arm/plat-omap/include/mach/omap16xx.h         |    2 +-
 arch/arm/plat-s3c/Kconfig                          |    2 -
 arch/arm/plat-s3c24xx/Kconfig                      |    2 -
 arch/arm/plat-s3c24xx/include/plat/map.h           |    2 +-
 arch/arm/plat-s3c64xx/Kconfig                      |    2 -
 arch/arm/plat-s5pc1xx/Kconfig                      |    2 -
 arch/avr32/boards/hammerhead/Kconfig               |    2 +-
 arch/blackfin/kernel/traps.c                       |    2 +-
 .../mach-bf518/include/mach/defBF51x_base.h        |    4 +-
 .../mach-bf527/include/mach/defBF52x_base.h        |    4 +-
 arch/blackfin/mach-bf537/include/mach/defBF534.h   |    4 +-
 arch/blackfin/mach-bf548/include/mach/defBF544.h   |    4 +-
 arch/blackfin/mach-bf548/include/mach/defBF547.h   |    4 +-
 arch/blackfin/mach-bf548/include/mach/defBF548.h   |    4 +-
 arch/blackfin/mach-bf548/include/mach/defBF549.h   |    4 +-
 arch/cris/arch-v10/mm/fault.c                      |    3 +-
 arch/cris/arch-v10/mm/tlb.c                        |   22 -------
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
 arch/parisc/kernel/perf.c                          |    2 +-
 arch/powerpc/include/asm/reg_fsl_emb.h             |    2 +-
 arch/powerpc/kernel/kgdb.c                         |    2 +-
 arch/powerpc/kernel/tau_6xx.c                      |    2 +-
 arch/powerpc/kernel/vdso.c                         |    2 +-
 arch/powerpc/oprofile/op_model_cell.c              |    6 +-
 arch/powerpc/platforms/52xx/mpc52xx_pci.c          |    2 +-
 arch/powerpc/platforms/powermac/pci.c              |    2 +-
 arch/powerpc/sysdev/dart_iommu.c                   |    2 +-
 arch/s390/math-emu/math.c                          |    4 +-
 arch/sh/include/mach-common/mach/titan.h           |    2 +-
 arch/x86/include/asm/desc_defs.h                   |    4 +-
 arch/x86/include/asm/mmzone_32.h                   |    2 +-
 arch/x86/include/asm/sigcontext.h                  |    4 +-
 arch/x86/include/asm/uv/uv_bau.h                   |    2 +-
 arch/x86/kernel/acpi/boot.c                        |    2 +-
 arch/x86/kernel/amd_iommu.c                        |    4 +-
 arch/x86/kernel/cpu/perf_event.c                   |    2 +-
 arch/x86/kernel/kprobes.c                          |    4 +-
 arch/x86/mm/kmmio.c                                |    4 +-
 block/blk-iopoll.c                                 |    2 +-
 drivers/Kconfig                                    |    2 -
 drivers/acpi/video_detect.c                        |   10 ++--
 drivers/ata/ata_piix.c                             |    2 +-
 drivers/ata/libata-sff.c                           |    6 +-
 drivers/ata/pata_cs5535.c                          |    2 +-
 drivers/ata/sata_fsl.c                             |    6 +-
 drivers/atm/iphase.c                               |    2 +-
 drivers/base/dd.c                                  |    2 +-
 drivers/block/ataflop.c                            |    3 -
 drivers/block/cciss_cmd.h                          |    2 +-
 drivers/bluetooth/btmrvl_sdio.c                    |    2 +-
 drivers/bluetooth/hci_ldisc.c                      |    2 +-
 drivers/char/mem.c                                 |    2 +-
 drivers/char/mspec.c                               |    2 +-
 drivers/char/n_r3964.c                             |    2 +-
 drivers/char/rio/route.h                           |    2 +-
 drivers/char/tty_ioctl.c                           |    2 +-
 drivers/cpuidle/governor.c                         |    4 +-
 drivers/crypto/hifn_795x.c                         |    2 +-
 drivers/dma/at_hdmac.c                             |    2 +-
 drivers/firewire/core-topology.c                   |    2 +-
 drivers/gpu/drm/drm_crtc.c                         |    4 +-
 drivers/gpu/drm/i915/i915_gem.c                    |    2 +-
 drivers/gpu/drm/i915/intel_fb.c                    |    2 +-
 drivers/gpu/drm/i915/intel_sdvo.c                  |    2 +-
 drivers/gpu/drm/radeon/atombios.h                  |   16 +++---
 drivers/gpu/drm/radeon/r600.c                      |    4 +-
 drivers/gpu/drm/radeon/radeon_fb.c                 |    2 +-
 drivers/gpu/drm/radeon/radeon_state.c              |    2 +-
 drivers/gpu/drm/radeon/radeon_ttm.c                |    2 +-
 drivers/gpu/drm/radeon/rv770.c                     |    4 +-
 drivers/gpu/drm/ttm/ttm_bo_util.c                  |    2 +-
 drivers/hwmon/adm1029.c                            |    2 +-
 drivers/hwmon/lm93.c                               |    2 +-
 drivers/ieee1394/dv1394.c                          |    2 +-
 drivers/infiniband/hw/cxgb3/cxio_hal.c             |    2 +-
 drivers/infiniband/hw/ipath/ipath_iba6110.c        |    2 +-
 drivers/infiniband/hw/ipath/ipath_sd7220.c         |    4 +-
 drivers/infiniband/hw/mlx4/qp.c                    |    2 +-
 drivers/infiniband/ulp/iser/iser_verbs.c           |    2 +-
 drivers/input/serio/hp_sdc.c                       |    2 +-
 drivers/input/serio/hp_sdc_mlc.c                   |    2 +-
 drivers/input/touchscreen/atmel-wm97xx.c           |    2 +-
 drivers/input/touchscreen/mainstone-wm97xx.c       |    4 +-
 drivers/input/touchscreen/zylonite-wm97xx.c        |    2 +-
 drivers/isdn/act2000/Kconfig                       |    4 -
 drivers/isdn/capi/Kconfig                          |    4 -
 drivers/isdn/capi/capidrv.c                        |    2 +-
 drivers/isdn/hardware/eicon/di.c                   |    2 +-
 drivers/isdn/hardware/eicon/maintidi.c             |    4 +-
 drivers/isdn/hardware/mISDN/hfcsusb.c              |    2 +-
 drivers/isdn/hardware/mISDN/hfcsusb.h              |    2 +-
 drivers/isdn/hardware/mISDN/mISDNisar.c            |    2 +-
 drivers/isdn/hisax/hfc_usb.c                       |    2 +-
 drivers/isdn/hysdn/Kconfig                         |    4 -
 drivers/isdn/i4l/isdn_net.c                        |    2 +-
 drivers/isdn/i4l/isdn_ppp.c                        |    6 +-
 drivers/isdn/i4l/isdn_ttyfax.c                     |    2 +-
 drivers/isdn/icn/Kconfig                           |    4 -
 drivers/isdn/mISDN/dsp_core.c                      |    2 +-
 drivers/isdn/mISDN/tei.c                           |    2 +-
 drivers/isdn/pcbit/Kconfig                         |    4 -
 drivers/isdn/sc/Kconfig                            |    4 -
 drivers/macintosh/therm_windtunnel.c               |    2 +-
 drivers/md/dm-crypt.c                              |    2 +-
 drivers/media/common/saa7146_i2c.c                 |    2 +-
 drivers/media/dvb/dvb-core/dvb_frontend.h          |    2 +-
 drivers/media/dvb/dvb-core/dvb_net.c               |    2 +-
 drivers/media/dvb/dvb-usb/anysee.c                 |    2 +-
 drivers/media/dvb/dvb-usb/dibusb-mb.c              |    2 +-
 drivers/media/dvb/dvb-usb/dvb-usb-remote.c         |    2 +-
 drivers/media/dvb/dvb-usb/usb-urb.c                |    4 +-
 drivers/media/dvb/frontends/au8522_decoder.c       |    2 +-
 drivers/media/dvb/frontends/cx24110.c              |    4 +-
 drivers/media/dvb/frontends/cx24113.c              |    2 +-
 drivers/media/dvb/frontends/dib3000mb.c            |    2 +-
 drivers/media/dvb/frontends/drx397xD.c             |    2 +-
 drivers/media/dvb/frontends/lgdt330x.c             |    4 +-
 drivers/media/dvb/frontends/stb0899_drv.c          |    2 +-
 drivers/media/dvb/ttpci/av7110.c                   |    4 +-
 drivers/media/dvb/ttpci/budget-patch.c             |    2 +-
 drivers/media/radio/radio-mr800.c                  |    2 +-
 drivers/media/video/cx18/cx18-av-core.h            |    2 +-
 drivers/media/video/cx18/cx18-driver.c             |    4 +-
 drivers/media/video/cx18/cx18-mailbox.h            |    2 +-
 drivers/media/video/cx231xx/cx231xx-avcore.c       |    8 ++-
 drivers/media/video/cx23885/cx23885-core.c         |    4 +-
 drivers/media/video/cx23885/cx23885-dvb.c          |    2 +-
 drivers/media/video/cx88/cx88-core.c               |    2 +-
 drivers/media/video/davinci/dm355_ccdc.c           |    6 +-
 drivers/media/video/davinci/dm644x_ccdc.c          |    4 +-
 drivers/media/video/davinci/vpss.c                 |    2 +-
 drivers/media/video/gspca/sonixb.c                 |    2 +-
 drivers/media/video/gspca/spca500.c                |    2 +-
 drivers/media/video/gspca/spca501.c                |    6 +-
 drivers/media/video/gspca/sunplus.c                |    2 +-
 drivers/media/video/gspca/zc3xx.c                  |    2 +-
 drivers/media/video/ivtv/ivtv-driver.c             |    4 +-
 drivers/media/video/ov772x.c                       |    2 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h |    2 +-
 drivers/media/video/s2255drv.c                     |    2 +-
 drivers/media/video/saa7134/saa7134-core.c         |    4 +-
 drivers/media/video/saa7164/saa7164-core.c         |    4 +-
 drivers/media/video/zoran/zoran.h                  |    2 +-
 drivers/message/i2o/i2o_block.c                    |    2 +-
 drivers/message/i2o/iop.c                          |    4 +-
 drivers/misc/sgi-gru/grufile.c                     |    2 +-
 drivers/mmc/card/sdio_uart.c                       |   40 +++++++------
 drivers/mmc/host/s3cmci.c                          |    2 +-
 drivers/mtd/chips/Kconfig                          |    3 -
 drivers/mtd/devices/Kconfig                        |    3 -
 drivers/mtd/devices/slram.c                        |    2 +-
 drivers/mtd/lpddr/Kconfig                          |    3 -
 drivers/mtd/maps/Kconfig                           |    8 +--
 drivers/mtd/nand/Kconfig                           |    2 -
 drivers/mtd/nand/diskonchip.c                      |    2 +-
 drivers/mtd/nand/nand_ecc.c                        |    2 +-
 drivers/mtd/nand/s3c2410.c                         |    2 +-
 drivers/mtd/onenand/Kconfig                        |    4 -
 drivers/mtd/ubi/Kconfig                            |    2 -
 drivers/net/82596.c                                |    2 +-
 drivers/net/amd8111e.c                             |    7 ++-
 drivers/net/appletalk/cops.c                       |    2 +-
 drivers/net/ariadne.h                              |    2 +-
 drivers/net/atl1c/atl1c_main.c                     |    2 +-
 drivers/net/benet/be_cmds.h                        |    2 +-
 drivers/net/benet/be_main.c                        |    2 +-
 drivers/net/bnx2x_reg.h                            |    2 +-
 drivers/net/bonding/bond_alb.c                     |    2 +-
 drivers/net/cxgb3/sge.c                            |    2 +-
 drivers/net/ehea/ehea_ethtool.c                    |    4 +-
 drivers/net/hamradio/baycom_ser_fdx.c              |    2 +-
 drivers/net/irda/smsc-ircc2.c                      |    2 +-
 drivers/net/iseries_veth.c                         |    2 +-
 drivers/net/lasi_82596.c                           |    2 +-
 drivers/net/lib82596.c                             |    2 +-
 drivers/net/mlx4/en_rx.c                           |    2 +-
 drivers/net/mlx4/en_tx.c                           |    2 +-
 drivers/net/mlx4/mlx4_en.h                         |    2 +-
 drivers/net/ps3_gelic_net.c                        |    2 +-
 drivers/net/ps3_gelic_wireless.h                   |    2 +-
 drivers/net/qla3xxx.c                              |    2 +-
 drivers/net/s2io.c                                 |    2 +-
 drivers/net/sis900.c                               |    4 +-
 drivers/net/skfp/h/smc.h                           |    8 +-
 drivers/net/skfp/skfddi.c                          |    2 +-
 drivers/net/sky2.c                                 |    2 +-
 drivers/net/smsc911x.c                             |    2 +-
 drivers/net/smsc911x.h                             |    2 +-
 drivers/net/spider_net.c                           |    2 +-
 drivers/net/stmmac/gmac.c                          |    2 +-
 drivers/net/stmmac/gmac.h                          |    4 +-
 drivers/net/tokenring/ibmtr.c                      |    2 +-
 drivers/net/tokenring/smctr.c                      |    2 +-
 drivers/net/ucc_geth.c                             |    2 +-
 drivers/net/ucc_geth.h                             |   20 +++---
 drivers/net/usb/smsc95xx.c                         |    2 +-
 drivers/net/wan/hdlc_fr.c                          |    2 +-
 drivers/net/wan/lmc/lmc_main.c                     |    2 +-
 drivers/net/wimax/i2400m/rx.c                      |    2 +-
 drivers/net/wireless/ath/ath5k/base.h              |    4 +-
 drivers/net/wireless/ath/ath5k/eeprom.c            |    2 +-
 drivers/net/wireless/ath/ath5k/phy.c               |    6 +-
 drivers/net/wireless/ath/ath9k/rc.c                |    2 +-
 drivers/net/wireless/b43/main.c                    |    2 +-
 drivers/net/wireless/b43legacy/main.c              |    2 +-
 drivers/net/wireless/ipw2x00/ipw2100.c             |    6 +-
 drivers/net/wireless/ipw2x00/ipw2200.c             |    8 +-
 drivers/net/wireless/ipw2x00/libipw_module.c       |    2 +-
 drivers/net/wireless/iwmc3200wifi/hal.c            |    2 +-
 drivers/net/wireless/iwmc3200wifi/rx.c             |    2 +-
 drivers/net/wireless/libertas/if_sdio.c            |    2 +-
 drivers/net/wireless/orinoco/hermes_dld.c          |    4 +-
 drivers/net/wireless/prism54/isl_ioctl.c           |    4 +-
 drivers/net/wireless/rt2x00/rt2400pci.h            |    2 +-
 drivers/net/wireless/rt2x00/rt2500pci.h            |    2 +-
 drivers/net/wireless/rt2x00/rt2500usb.h            |    2 +-
 drivers/net/wireless/rt2x00/rt61pci.h              |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.h              |    2 +-
 drivers/net/wireless/wavelan_cs.c                  |    2 +-
 drivers/net/wireless/zd1211rw/zd_mac.c             |    2 +-
 drivers/parisc/ccio-dma.c                          |    2 +-
 drivers/platform/Kconfig                           |    2 -
 drivers/platform/x86/thinkpad_acpi.c               |    2 +-
 drivers/pnp/pnpbios/rsparser.c                     |    8 +-
 drivers/ps3/ps3-sys-manager.c                      |    2 +-
 drivers/rtc/rtc-ds1511.c                           |    4 +-
 drivers/rtc/rtc-stk17ta8.c                         |    2 +-
 drivers/rtc/rtc-v3020.c                            |    2 +-
 drivers/s390/block/dasd_proc.c                     |    2 +-
 drivers/s390/char/fs3270.c                         |    2 +-
 drivers/s390/cio/chp.c                             |    2 +-
 drivers/s390/cio/cmf.c                             |    2 +-
 drivers/s390/net/qeth_core_mpc.h                   |    2 +-
 drivers/sbus/char/envctrl.c                        |    4 +-
 drivers/scsi/3w-9xxx.c                             |    2 +-
 drivers/scsi/3w-xxxx.c                             |    2 +-
 drivers/scsi/53c700.c                              |    2 +-
 drivers/scsi/aacraid/aacraid.h                     |    6 +-
 drivers/scsi/aacraid/comminit.c                    |    2 +-
 drivers/scsi/advansys.c                            |    2 +-
 drivers/scsi/aic7xxx/aic79xx.seq                   |    4 +-
 drivers/scsi/aic7xxx/aic79xx_core.c                |    2 +-
 drivers/scsi/aic7xxx/aic79xx_osm.c                 |    2 +-
 drivers/scsi/aic7xxx/aic7xxx.seq                   |    2 +-
 drivers/scsi/aic7xxx/aic7xxx_core.c                |    2 +-
 drivers/scsi/aic7xxx/aic7xxx_osm.c                 |    2 +-
 drivers/scsi/aic94xx/aic94xx_reg_def.h             |    2 +-
 drivers/scsi/bfa/include/defs/bfa_defs_pport.h     |    2 +-
 drivers/scsi/bfa/include/defs/bfa_defs_tsensor.h   |    2 +-
 drivers/scsi/bfa/include/protocol/ct.h             |    4 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c                   |    2 +-
 drivers/scsi/dc395x.c                              |    2 +-
 drivers/scsi/dmx3191d.c                            |    2 +-
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
 drivers/scsi/nsp32.c                               |    2 +-
 drivers/scsi/pmcraid.c                             |    6 +-
 drivers/scsi/pmcraid.h                             |    6 +-
 drivers/scsi/scsi_netlink.c                        |    2 +-
 drivers/scsi/scsi_transport_sas.c                  |    6 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c                |    2 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.c                |    2 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.h                |    2 +-
 drivers/scsi/wd7000.c                              |    2 +-
 drivers/serial/8250_pnp.c                          |    4 +-
 drivers/serial/pmac_zilog.h                        |    2 +-
 drivers/serial/ucc_uart.c                          |    2 +-
 drivers/spi/spidev.c                               |    2 +-
 drivers/staging/otus/80211core/pub_zfi.h           |    2 +-
 drivers/staging/otus/zdcompat.h                    |    2 +-
 drivers/staging/rtl8187se/r8180.h                  |    2 +-
 drivers/staging/rtl8192su/r8192S_phyreg.h          |    2 +-
 drivers/telephony/ixj.c                            |    4 +-
 drivers/usb/atm/ueagle-atm.c                       |    2 +-
 drivers/usb/class/usbtmc.c                         |    2 +-
 drivers/usb/core/message.c                         |    2 +-
 drivers/usb/gadget/f_acm.c                         |    2 +-
 drivers/usb/gadget/pxa27x_udc.c                    |    2 +-
 drivers/usb/host/ehci-hcd.c                        |    2 +-
 drivers/usb/host/fhci-sched.c                      |    2 +-
 drivers/usb/wusbcore/crypto.c                      |    2 +-
 drivers/usb/wusbcore/wa-xfer.c                     |    4 +-
 drivers/uwb/i1480/dfu/usb.c                        |    2 +-
 drivers/uwb/neh.c                                  |    2 +-
 drivers/uwb/wlp/txrx.c                             |    2 +-
 drivers/video/atmel_lcdfb.c                        |    2 +-
 drivers/video/aty/atyfb_base.c                     |    4 +-
 drivers/video/backlight/atmel-pwm-bl.c             |    2 +-
 drivers/video/backlight/tosa_lcd.c                 |    2 +-
 drivers/video/console/sticore.c                    |    2 +-
 drivers/video/fb_defio.c                           |    2 +-
 drivers/video/gbefb.c                              |    2 +-
 drivers/video/omap/lcd_ams_delta.c                 |    4 +-
 drivers/video/omap/lcd_mipid.c                     |    4 +-
 drivers/video/sgivwfb.c                            |    4 +-
 drivers/video/stifb.c                              |    4 +-
 drivers/video/tdfxfb.c                             |    2 +-
 drivers/video/via/dvi.c                            |    4 +-
 drivers/video/vt8623fb.c                           |    2 +-
 drivers/watchdog/coh901327_wdt.c                   |    2 +-
 drivers/watchdog/machzwd.c                         |    2 +-
 drivers/watchdog/sb_wdog.c                         |    4 +-
 drivers/watchdog/wdrtas.c                          |    6 +-
 fs/binfmt_elf.c                                    |    2 +-
 fs/bio.c                                           |    2 +-
 fs/btrfs/extent_map.c                              |    2 +-
 fs/cifs/README                                     |    2 +-
 fs/cifs/cifsglob.h                                 |    2 +-
 fs/cifs/cifspdu.h                                  |    2 +-
 fs/cifs/inode.c                                    |    4 +-
 fs/cifs/smbdes.c                                   |    2 +-
 fs/compat_ioctl.c                                  |    2 +-
 fs/debugfs/inode.c                                 |    6 +-
 fs/dlm/plock.c                                     |    2 +-
 fs/ext3/inode.c                                    |    2 +-
 fs/ext4/inode.c                                    |    8 +-
 fs/ext4/mballoc.c                                  |    2 +-
 fs/jffs2/compr.c                                   |    2 +-
 fs/jffs2/readinode.c                               |    2 +-
 fs/jffs2/xattr.c                                   |    2 +-
 fs/jfs/jfs_dmap.c                                  |    4 +-
 fs/ncpfs/ioctl.c                                   |    2 +-
 fs/notify/inotify/inotify_user.c                   |    4 -
 fs/ntfs/compress.c                                 |    2 +-
 fs/ntfs/file.c                                     |    4 +-
 fs/ntfs/logfile.c                                  |    2 +-
 fs/ocfs2/alloc.c                                   |    2 +-
 fs/ocfs2/blockcheck.c                              |    2 +-
 fs/ocfs2/dlm/dlmmaster.c                           |    2 +-
 fs/ocfs2/dlmglue.c                                 |    2 +-
 fs/ocfs2/journal.c                                 |    2 +-
 fs/ocfs2/refcounttree.c                            |    2 +-
 fs/omfs/bitmap.c                                   |    2 +-
 fs/qnx4/bitmap.c                                   |    2 +-
 fs/qnx4/dir.c                                      |    6 +-
 fs/qnx4/inode.c                                    |   26 ++++----
 fs/qnx4/namei.c                                    |    6 +-
 fs/reiserfs/fix_node.c                             |    2 +-
 fs/ubifs/recovery.c                                |    2 +-
 fs/xfs/quota/xfs_dquot.h                           |    2 +-
 include/asm-generic/memory_model.h                 |    2 +-
 include/asm-generic/unistd.h                       |    2 +-
 include/linux/cciss_ioctl.h                        |    2 +-
 include/linux/chio.h                               |    2 +-
 include/linux/dm-log-userspace.h                   |    2 +-
 include/linux/in6.h                                |    2 +-
 include/linux/irq.h                                |    2 +-
 include/linux/mfd/ezx-pcap.h                       |    4 +-
 include/linux/pktcdvd.h                            |    2 +-
 include/linux/serial_reg.h                         |    8 +-
 include/linux/spi/spi_bitbang.h                    |    2 +-
 include/linux/sysctl.h                             |   10 ++--
 include/linux/usb/wusb.h                           |    2 +-
 include/linux/videodev2.h                          |    2 +-
 include/net/sctp/structs.h                         |    2 +-
 include/net/tcp.h                                  |    2 +-
 include/net/wimax.h                                |    2 +-
 include/sound/ac97_codec.h                         |    2 +-
 include/sound/wm8993.h                             |    2 +-
 include/video/sgivw.h                              |   11 ++--
 ipc/msg.c                                          |    2 +-
 kernel/irq/spurious.c                              |    2 +-
 kernel/perf_event.c                                |    4 +-
 kernel/time/clocksource.c                          |    2 +-
 lib/Kconfig.debug                                  |    2 +-
 lib/decompress_bunzip2.c                           |    2 +-
 lib/dma-debug.c                                    |    2 +-
 lib/idr.c                                          |    4 +-
 lib/swiotlb.c                                      |    2 +-
 mm/filemap.c                                       |    2 +-
 mm/kmemleak.c                                      |    4 +-
 mm/memcontrol.c                                    |    6 +-
 mm/memory-failure.c                                |    2 +-
 mm/truncate.c                                      |    2 +-
 net/bluetooth/bnep/core.c                          |    4 +-
 net/ipv4/netfilter/ipt_ECN.c                       |    2 +-
 net/irda/irlap.c                                   |   14 ++--
 net/irda/irlap_event.c                             |    2 +-
 net/irda/irlmp.c                                   |    4 +-
 net/mac80211/mesh_pathtbl.c                        |    4 +-
 net/netlabel/netlabel_domainhash.c                 |    2 +-
 net/sched/act_api.c                                |    2 +-
 net/sctp/sm_sideeffect.c                           |    2 +-
 net/sctp/sm_statefuns.c                            |    2 +-
 net/sunrpc/xprtrdma/svc_rdma_sendto.c              |    2 +-
 net/wimax/op-reset.c                               |    2 +-
 samples/Kconfig                                    |    3 -
 scripts/kconfig/mconf.c                            |    2 +-
 security/selinux/netlabel.c                        |    2 +-
 security/selinux/ss/services.c                     |    2 +-
 sound/Kconfig                                      |    6 +--
 sound/isa/cs423x/cs4236.c                          |    2 +-
 sound/isa/opti9xx/miro.c                           |    2 +-
 sound/isa/opti9xx/opti92x-ad1848.c                 |    2 +-
 sound/oss/Kconfig                                  |    2 -
 sound/oss/dmasound/dmasound_paula.c                |    2 +-
 sound/pci/ca0106/ca0106_proc.c                     |    2 +-
 sound/pci/cs46xx/imgs/cwcdma.asp                   |    9 ++-
 sound/pci/emu10k1/emu10k1x.c                       |    2 +-
 sound/pci/hda/patch_cirrus.c                       |    2 +-
 sound/pci/hda/patch_cmedia.c                       |    2 +-
 sound/pci/hda/patch_realtek.c                      |    2 +-
 sound/pci/ice1712/juli.c                           |    2 +-
 sound/pci/rme9652/hdspm.c                          |    4 +-
 sound/soc/codecs/uda134x.c                         |    4 +-
 sound/soc/codecs/wm8903.c                          |    6 +-
 sound/soc/codecs/wm8993.c                          |    4 +-
 sound/soc/s3c24xx/s3c24xx_simtec.c                 |    2 +-
 sound/soc/s6000/s6000-pcm.c                        |    2 +-
 sound/sound_core.c                                 |    2 +-
 sound/synth/emux/soundfont.c                       |    2 +-
 490 files changed, 721 insertions(+), 832 deletions(-)

Adam Buchbinder (2):
      reiserfs: fix misspelling of "journaled"
      tree-wide: fix misspelling of "definition" in comments

Alberto Bertogli (1):
      fs/debugfs/inode.c: fix comment typos

Amerigo Wang (1):
      fix URL in hpet.txt

Anders Larsen (1):
      qnx4fs: add missing KERN_xxx to printk() calls

Andrew Sharp (1):
      fix my email address.

André Goddard Rosa (1):
      tree-wide: fix assorted typos all over the place

Brandon Philips (1):
      sky2: fix sky2_link_down copy/paste comment error

Claudio Scordino (1):
      atmel_lcdfb.c: fix printk() type mismatch

Davidlohr Bueso (1):
      fix typos/grammos in Documentation/edac.txt

Dirk Hohndel (1):
      tree-wide: fix a very frequent spelling mistake

Dr. David Alan Gilbert (1):
      doc: fix regulator docs cut-and-pasteism

Felipe Contreras (1):
      ipc: fix unused variable warning

Giuseppe Scrivano (1):
      inotify: remove superfluous return code check

Jean Delvare (1):
      comment typo fix: sybsystem -> subsystem

Jiri Kosina (3):
      CIRS: turn local_save_flags() + local_irq_disable()into local_irq_save()
      CRIS: remove code that has been commented out for many years
      ataflop: remove buggy/commented-out IRQ disable from do_fd_request()

Justin P. Mattock (1):
      doc: Fix a typo in slub.txt.

Krzysztof Halasa (3):
      drivers/ata/libata-sff.c: comment spelling fixes
      doc: Fix IRQ chip docs
      mtd: Fix comment in Kconfig

Liuweni (1):
      fix kerneldoc for set_irq_msi()

Michael Roth (1):
      Kconfig: Remove useless and sometimes wrong comments

Nick Bowler (1):
      docs: Describe the 'C' taint flag in oops-tracing.txt

Otavio Salvador (1):
      pata_cs5535: fix comment header typo

Ozan Çağlayan (1):
      ehci-hcd: Fix typo in an error message

Peng Tao (1):
      mm: fix comments for invalidate_inode_pages2()

Peter Huewe (2):
      add __init/__exit macros to omap video drivers
      media/video: add __init/__exit macros to various drivers

Randy Dunlap (1):
      docs: fix core_pipe_limit info

Rudy Matela (1):
      hdlc: spelling fix in find_pvc() comment

Thadeu Lima de Souza Cascardo (4):
      tree-wide: fix some typos and punctuation in comments
      sdio_uart: coding style fixes
      spidev: fix double "of of" in comment
      sysctl: add missing comments

Thiago Farina (1):
      sgivwfb: Make use of ARRAY_SIZE.

Uwe Kleine-König (5):
      tree-wide: fix typos "selct" + "slect" -> "select"
      tree-wide: fix typos "aquire" -> "acquire", "cumsumed" -> "consumed"
      move stk17ta8's probe function to .devinit.text
      tree-wide: fix typos "offest" -> "offset"
      tree-wide: fix typos "couter" -> "counter"

