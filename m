Return-Path: <linux-kernel-owner+w=401wt.eu-S1763531AbXGVVJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763531AbXGVVJh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 17:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755841AbXGVVJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 17:09:29 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:41290 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751041AbXGVVJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 17:09:27 -0400
Date: Sun, 22 Jul 2007 23:08:51 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: please pull from the trivial tree
Message-ID: <20070722210851.GB26212@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bunk/trivial.git


This tree contains the following:

Jan Engelhardt (1):
      Convert files to UTF-8 and some cleanups

Jean Delvare (1):
      Spelling fix: explicitly

John Anthony Kazos Jr (2):
      crypto: convert "crypto" subdirectory to UTF-8
      crypto: convert crypto.h to UTF-8

Marcin Garski (1):
      more UTF-8 conversions

Patrick Ringl (1):
      fix typos in drivers/block/Kconfig

Robert P. J. Day (7):
      KCONFIG: Replace remaining "depends" with "depends on".
      Fix misspellings of "system", "controller", "interrupt" and "necessary".
      Explain clearly why kmalloc() can't use __GFP_HIGHMEM.
      Remove long-dead commented-out MODULE_PARM reference.
      Drop the superfluous test for an old version of gcc.
      Documentation: Drop reference to dead "eicon" kernel paramter.
      Documentation: Delete dead OSS-related kernel parameter.


 CREDITS                                           |   12 ++--
 Documentation/cdrom/cdrom-standard.tex            |    2 
 Documentation/filesystems/Locking                 |    2 
 Documentation/i2c/i2c-protocol                    |    2 
 Documentation/isdn/CREDITS                        |    2 
 Documentation/kernel-parameters.txt               |    6 --
 Documentation/mips/AU1xxx_IDE.README              |    2 
 Documentation/spi/pxa2xx                          |    2 
 arch/arm/mach-at91/gpio.c                         |    2 
 arch/arm/mach-omap1/irq.c                         |    2 
 arch/arm/mach-omap2/io.c                          |    2 
 arch/arm/mach-omap2/timer-gp.c                    |    2 
 arch/arm/mach-s3c2410/clock.c                     |    2 
 arch/arm/mach-s3c2412/clock.c                     |    2 
 arch/arm/mach-s3c2443/clock.c                     |    2 
 arch/arm/nwfpe/fpopcode.h                         |   34 +++++++-------
 arch/arm/plat-omap/dma.c                          |    2 
 arch/arm/plat-omap/gpio.c                         |    2 
 arch/arm26/nwfpe/fpopcode.h                       |   34 +++++++-------
 arch/cris/arch-v10/drivers/pcf8563.c              |    2 
 arch/cris/arch-v10/kernel/entry.S                 |    2 
 arch/cris/arch-v10/kernel/kgdb.c                  |    2 
 arch/cris/arch-v10/lib/dram_init.S                |    4 -
 arch/cris/arch-v32/drivers/pcf8563.c              |    2 
 arch/cris/arch-v32/lib/dram_init.S                |    2 
 arch/h8300/kernel/irq.c                           |    2 
 arch/i386/kernel/cpu/cpufreq/powernow-k6.c        |    2 
 arch/i386/kernel/cpu/cyrix.c                      |    8 +--
 arch/m68k/ifpsp060/CHANGES                        |    2 
 arch/m68k/ifpsp060/MISC                           |    2 
 arch/m68k/ifpsp060/README                         |    2 
 arch/m68k/ifpsp060/TEST.DOC                       |    2 
 arch/m68k/ifpsp060/fplsp.doc                      |    2 
 arch/m68k/ifpsp060/fpsp.doc                       |    2 
 arch/m68k/ifpsp060/fskeleton.S                    |    2 
 arch/m68k/ifpsp060/ilsp.doc                       |    2 
 arch/m68k/ifpsp060/iskeleton.S                    |    2 
 arch/m68k/ifpsp060/isp.doc                        |    2 
 arch/m68k/ifpsp060/os.S                           |    2 
 arch/m68k/ifpsp060/src/fplsp.S                    |    2 
 arch/m68k/ifpsp060/src/fpsp.S                     |    2 
 arch/m68k/ifpsp060/src/ftest.S                    |    2 
 arch/m68k/ifpsp060/src/ilsp.S                     |    2 
 arch/m68k/ifpsp060/src/isp.S                      |    2 
 arch/m68k/ifpsp060/src/itest.S                    |    2 
 arch/m68k/ifpsp060/src/pfpsp.S                    |    2 
 arch/m68k/tools/amiga/dmesg.c                     |    2 
 arch/m68knommu/platform/5307/pit.c                |    2 
 arch/mips/ddb5xxx/ddb5477/setup.c                 |    2 
 arch/mips/kernel/module.c                         |    2 
 arch/mips/kernel/smtc.c                           |    2 
 arch/mips/kernel/vmlinux.lds.S                    |    2 
 arch/mips/pci/pci-excite.c                        |    2 
 arch/mips/sni/pcimt.c                             |    2 
 arch/powerpc/Kconfig.debug                        |    2 
 arch/powerpc/kernel/cpu_setup_6xx.S               |    2 
 arch/powerpc/kernel/irq.c                         |    2 
 arch/powerpc/kernel/l2cr_6xx.S                    |    2 
 arch/powerpc/platforms/cell/spufs/file.c          |    2 
 arch/powerpc/platforms/celleb/scc_uhc.c           |    2 
 arch/ppc/platforms/apus_pci.c                     |    2 
 arch/sh64/kernel/pci_sh5.c                        |    2 
 arch/x86_64/kernel/suspend.c                      |    2 
 crypto/api.c                                      |    2 
 crypto/fcrypt.c                                   |    2 
 drivers/ata/ahci.c                                |    2 
 drivers/ata/libata-sff.c                          |    2 
 drivers/ata/pata_cs5530.c                         |    2 
 drivers/ata/pata_cs5535.c                         |    2 
 drivers/ata/pata_it821x.c                         |    4 -
 drivers/ata/pata_mpiix.c                          |    2 
 drivers/ata/pata_ns87410.c                        |    2 
 drivers/ata/pata_oldpiix.c                        |    2 
 drivers/ata/pata_radisys.c                        |    2 
 drivers/ata/pata_sc1200.c                         |    2 
 drivers/ata/pata_sil680.c                         |    2 
 drivers/ata/pata_via.c                            |    2 
 drivers/atm/firestream.c                          |    2 
 drivers/block/Kconfig                             |    4 -
 drivers/block/loop.c                              |    2 
 drivers/block/rd.c                                |    2 
 drivers/char/cyclades.c                           |    2 
 drivers/char/drm/drm_hashtab.c                    |    2 
 drivers/char/drm/drm_hashtab.h                    |    2 
 drivers/char/drm/drm_mm.c                         |    2 
 drivers/char/drm/drm_pci.c                        |    4 -
 drivers/char/drm/drm_sarea.h                      |    2 
 drivers/char/drm/drm_sman.c                       |    2 
 drivers/char/drm/drm_sman.h                       |    2 
 drivers/char/drm/r128_drv.h                       |    2 
 drivers/char/drm/radeon_irq.c                     |    2 
 drivers/char/drm/radeon_state.c                   |    2 
 drivers/char/drm/sis_mm.c                         |    2 
 drivers/char/drm/via_mm.c                         |    2 
 drivers/char/drm/via_verifier.h                   |    2 
 drivers/char/esp.c                                |    2 
 drivers/char/hw_random/omap-rng.c                 |    2 
 drivers/char/i8k.c                                |   14 ++---
 drivers/char/n_tty.c                              |    4 -
 drivers/char/rocket.c                             |    2 
 drivers/char/sonypi.c                             |    2 
 drivers/char/tty_io.c                             |    8 +--
 drivers/char/tty_ioctl.c                          |    2 
 drivers/char/watchdog/i6300esb.c                  |    6 +-
 drivers/char/watchdog/iTCO_vendor_support.c       |    2 
 drivers/char/watchdog/w83627hf_wdt.c              |    2 
 drivers/char/watchdog/w83697hf_wdt.c              |    2 
 drivers/hwmon/gl520sm.c                           |    4 -
 drivers/hwmon/sis5595.c                           |    2 
 drivers/hwmon/via686a.c                           |    4 -
 drivers/i2c/algos/i2c-algo-bit.c                  |    2 
 drivers/i2c/algos/i2c-algo-pca.c                  |    2 
 drivers/i2c/algos/i2c-algo-pcf.c                  |    2 
 drivers/i2c/busses/i2c-elektor.c                  |    2 
 drivers/i2c/busses/i2c-hydra.c                    |    2 
 drivers/i2c/busses/i2c-ibm_iic.c                  |    2 
 drivers/i2c/busses/i2c-omap.c                     |    2 
 drivers/i2c/busses/i2c-parport-light.c            |    2 
 drivers/i2c/busses/i2c-parport.c                  |    2 
 drivers/i2c/busses/i2c-via.c                      |    4 -
 drivers/i2c/busses/i2c-viapro.c                   |    2 
 drivers/i2c/i2c-core.c                            |    2 
 drivers/ide/ide-cd.c                              |    6 +-
 drivers/ide/ide-tape.c                            |    2 
 drivers/ide/legacy/q40ide.c                       |    2 
 drivers/ide/pci/it821x.c                          |    4 -
 drivers/ide/pci/siimage.c                         |    2 
 drivers/input/joystick/db9.c                      |    2 
 drivers/input/keyboard/omap-keypad.c              |    4 -
 drivers/input/mouse/psmouse-base.c                |    2 
 drivers/input/mouse/vsxxxaa.c                     |    2 
 drivers/isdn/act2000/act2000_isa.c                |    2 
 drivers/isdn/hardware/eicon/capifunc.c            |    4 -
 drivers/isdn/hisax/amd7930_fn.c                   |    2 
 drivers/isdn/hisax/enternow_pci.c                 |   18 +++----
 drivers/isdn/hisax/hfc_pci.c                      |    2 
 drivers/isdn/hisax/isdnhdlc.c                     |    4 -
 drivers/isdn/hisax/isdnhdlc.h                     |    2 
 drivers/isdn/hisax/jade.c                         |    2 
 drivers/isdn/pcbit/capi.c                         |    4 -
 drivers/leds/Kconfig                              |    2 
 drivers/macintosh/via-pmu.c                       |    2 
 drivers/md/dm-crypt.c                             |    2 
 drivers/md/raid1.c                                |    2 
 drivers/media/common/saa7146_hlp.c                |    2 
 drivers/media/dvb/bt8xx/bt878.c                   |    2 
 drivers/media/dvb/cinergyT2/cinergyT2.c           |    2 
 drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c |    2 
 drivers/media/video/bt8xx/bttv-cards.c            |   26 +++++-----
 drivers/media/video/em28xx/em28xx-video.c         |    2 
 drivers/media/video/meye.c                        |    2 
 drivers/media/video/meye.h                        |    2 
 drivers/media/video/saa5246a.c                    |    4 -
 drivers/media/video/saa5249.c                     |    4 -
 drivers/media/video/usbvideo/vicam.c              |    2 
 drivers/media/video/v4l2-common.c                 |    2 
 drivers/message/i2o/README                        |    4 -
 drivers/message/i2o/exec-osm.c                    |    4 -
 drivers/message/i2o/i2o_config.c                  |    6 +-
 drivers/message/i2o/i2o_proc.c                    |    4 -
 drivers/message/i2o/iop.c                         |    4 -
 drivers/message/i2o/pci.c                         |    4 -
 drivers/misc/ibmasm/remote.c                      |    2 
 drivers/misc/sony-laptop.c                        |    4 -
 drivers/net/8139too.c                             |    2 
 drivers/net/amd8111e.c                            |    4 -
 drivers/net/ariadne.c                             |    2 
 drivers/net/ariadne.h                             |    2 
 drivers/net/au1000_eth.c                          |    2 
 drivers/net/bonding/bond_sysfs.c                  |    2 
 drivers/net/e100.c                                |    2 
 drivers/net/fealnx.c                              |    1 
 drivers/net/hamradio/6pack.c                      |    2 
 drivers/net/irda/actisys-sir.c                    |    2 
 drivers/net/irda/actisys.c                        |    2 
 drivers/net/irda/donauboe.c                       |    2 
 drivers/net/irda/girbil-sir.c                     |    2 
 drivers/net/irda/girbil.c                         |    2 
 drivers/net/irda/irport.h                         |    2 
 drivers/net/irda/irtty-sir.c                      |    2 
 drivers/net/irda/nsc-ircc.c                       |    2 
 drivers/net/irda/nsc-ircc.h                       |    2 
 drivers/net/irda/tekram-sir.c                     |    2 
 drivers/net/irda/tekram.c                         |    2 
 drivers/net/irda/w83977af_ir.h                    |    2 
 drivers/net/smc911x.c                             |    2 
 drivers/net/spider_net.c                          |    2 
 drivers/net/tc35815.c                             |    4 -
 drivers/net/via-velocity.c                        |    2 
 drivers/net/wireless/bcm43xx/bcm43xx_xmit.h       |    2 
 drivers/net/wireless/ipw2100.c                    |    4 -
 drivers/net/wireless/ipw2200.c                    |    2 
 drivers/net/wireless/netwave_cs.c                 |    8 +--
 drivers/s390/block/dasd_3990_erp.c                |    4 -
 drivers/s390/char/sclp_cpi.c                      |    2 
 drivers/s390/cio/cmf.c                            |    2 
 drivers/s390/net/ctcmain.c                        |   10 ++--
 drivers/scsi/aacraid/aacraid.h                    |    2 
 drivers/scsi/aha152x.c                            |    6 +-
 drivers/scsi/aic7xxx/cam.h                        |    2 
 drivers/scsi/dc395x.c                             |    6 +-
 drivers/scsi/megaraid/megaraid_mbox.c             |    2 
 drivers/scsi/qla4xxx/ql4_init.c                   |    2 
 drivers/scsi/sd.c                                 |    2 
 drivers/scsi/sun3_NCR5380.c                       |    2 
 drivers/scsi/sym53c8xx_2/sym_fw2.h                |    2 
 drivers/scsi/wd33c93.h                            |    2 
 drivers/serial/s3c2410.c                          |    4 -
 drivers/spi/mpc52xx_psc_spi.c                     |    2 
 drivers/usb/gadget/lh7a40x_udc.c                  |    2 
 drivers/usb/host/ehci-hub.c                       |    2 
 drivers/usb/host/sl811-hcd.c                      |    2 
 drivers/usb/misc/cytherm.c                        |    2 
 drivers/usb/misc/emi26.c                          |    4 -
 drivers/usb/misc/emi62.c                          |    4 -
 drivers/usb/serial/ChangeLog.history              |    2 
 drivers/usb/serial/ftdi_sio.c                     |    2 
 drivers/usb/serial/ftdi_sio.h                     |    6 +-
 drivers/usb/serial/ipaq.c                         |    4 -
 drivers/usb/storage/isd200.c                      |    2 
 drivers/usb/storage/unusual_devs.h                |    4 -
 drivers/video/amifb.c                             |   14 ++---
 drivers/video/aty/atyfb_base.c                    |    2 
 drivers/video/intelfb/intelfbdrv.c                |    2 
 drivers/video/intelfb/intelfbhw.c                 |    2 
 drivers/video/s3c2410fb.c                         |    4 -
 drivers/video/tdfxfb.c                            |    2 
 drivers/video/vermilion/vermilion.c               |    4 -
 drivers/video/vermilion/vermilion.h               |    2 
 drivers/zorro/zorro.ids                           |    2 
 fs/binfmt_em86.c                                  |    2 
 fs/binfmt_misc.c                                  |    2 
 fs/binfmt_script.c                                |    2 
 fs/isofs/inode.c                                  |    2 
 fs/jfs/jfs_dtree.c                                |    2 
 fs/nfs/nfsroot.c                                  |    2 
 fs/ntfs/ChangeLog                                 |    2 
 fs/ntfs/sysctl.c                                  |    2 
 fs/ntfs/sysctl.h                                  |    2 
 fs/ocfs2/dcache.c                                 |    2 
 fs/reiserfs/super.c                               |    2 
 fs/super.c                                        |    6 +-
 include/asm-arm/arch-aaec2000/aaec2000.h          |    4 -
 include/asm-arm/dma-mapping.h                     |    2 
 include/asm-mips/pci/bridge.h                     |    2 
 include/asm-powerpc/io.h                          |    2 
 include/asm-sh/se7751.h                           |    2 
 include/asm-sh/systemh7751.h                      |    2 
 include/linux/cdrom.h                             |    2 
 include/linux/crypto.h                            |    2 
 include/linux/ipmi_smi.h                          |    2 
 include/net/irda/irttp.h                          |    4 -
 init/main.c                                       |    8 ---
 kernel/hrtimer.c                                  |    2 
 kernel/sched.c                                    |    4 -
 kernel/taskstats.c                                |    2 
 lib/kobject_uevent.c                              |    2 
 mm/nommu.c                                        |    3 -
 net/ax25/ax25_ds_in.c                             |    2 
 net/ax25/ax25_ds_subr.c                           |    2 
 net/bluetooth/bnep/core.c                         |    2 
 net/bluetooth/bnep/netdev.c                       |    2 
 net/bridge/netfilter/ebtables.c                   |    2 
 net/core/pktgen.c                                 |    2 
 net/ieee80211/ieee80211_wx.c                      |    2 
 net/irda/discovery.c                              |    2 
 net/irda/iriap.c                                  |    2 
 net/irda/iriap_event.c                            |    2 
 net/irda/irias_object.c                           |    2 
 net/irda/irlan/irlan_client.c                     |    2 
 net/irda/irlan/irlan_client_event.c               |    2 
 net/irda/irlan/irlan_common.c                     |    2 
 net/irda/irlan/irlan_eth.c                        |    2 
 net/irda/irlan/irlan_event.c                      |    2 
 net/irda/irlan/irlan_filter.c                     |    2 
 net/irda/irlan/irlan_provider.c                   |    2 
 net/irda/irlan/irlan_provider_event.c             |    2 
 net/irda/irlap_event.c                            |    2 
 net/irda/irlap_frame.c                            |    2 
 net/irda/irlmp.c                                  |    2 
 net/irda/irlmp_event.c                            |    2 
 net/irda/irlmp_frame.c                            |    2 
 net/irda/irmod.c                                  |    2 
 net/irda/irqueue.c                                |    2 
 net/irda/irsysctl.c                               |    2 
 net/irda/irttp.c                                  |    2 
 net/irda/timer.c                                  |    2 
 net/irda/wrapper.c                                |    2 
 net/iucv/iucv.c                                   |    2 
 net/netfilter/xt_CONNMARK.c                       |    2 
 net/netfilter/xt_connmark.c                       |    2 
 net/netfilter/xt_limit.c                          |    4 -
 net/sched/em_meta.c                               |    2 
 sound/core/seq/seq_midi_emul.c                    |    8 +--
 sound/drivers/opl3/opl3_midi.c                    |    2 
 sound/isa/es18xx.c                                |    4 -
 sound/mips/au1x00.c                               |    8 +--
 sound/pci/au88x0/au88x0.c                         |    2 
 sound/soc/soc-core.c                              |    2 
 sound/soc/soc-dapm.c                              |    2 
 sound/synth/emux/emux_synth.c                     |    2 
 301 files changed, 438 insertions(+), 452 deletions(-)

