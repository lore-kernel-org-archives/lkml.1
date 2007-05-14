Return-Path: <linux-kernel-owner+w=401wt.eu-S1758620AbXENWWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620AbXENWWX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 18:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754552AbXENWWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 18:22:16 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44823 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298AbXENWWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 18:22:14 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4648E0AE.6010709@s5r6.in-berlin.de>
Date: Tue, 15 May 2007 00:20:30 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       trivial@kernel.org
Subject: Re: [PATCH] Convert files to UTF-8 and some cleanups
References: <4647A52A.8000709@post.pl> <4647A868.4070201@post.pl> <46486EAE.3060009@s5r6.in-berlin.de> <Pine.LNX.4.61.0705141947390.9570@yvahk01.tjqt.qr> <tkrat.0d89f95b66d8bb2c@s5r6.in-berlin.de> <Pine.LNX.4.61.0705142209090.9570@yvahk01.tjqt.qr> <20070514202509.GA1515@stusta.de> <Pine.LNX.4.61.0705142235320.9570@yvahk01.tjqt.qr> <20070514204107.GB1515@stusta.de> <Pine.LNX.4.61.0705142258120.9570@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0705142258120.9570@yvahk01.tjqt.qr>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> Rebased to tonight's trivial.git and attached (yes, it's better than 
> inline), please consider to apply.

You forgot this in the plain-text part of your mail:

[quote]

  * Convert files to UTF-8.

  * Also correct some people's names
    (one example is Eißfeldt, which was found in a source file.
    Given that the author used an ß at all in a source file
    indicates that the real name has in fact a 'ß' and not an 'ss',
    which is commonly used as a substitute for 'ß' when limited to
    7bit.)

  * Correct town names (Goettingen -> Göttingen)

  * Update Eberhard Mönkeberg's address (http://lkml.org/lkml/2007/1/8/313)

[...]

 CREDITS                                     |   12 +++----
 Documentation/cdrom/aztcd                   |    6 +--
 Documentation/cdrom/cdrom-standard.tex      |    2 -
 Documentation/cdrom/sbpcd                   |   10 ++---
 Documentation/cdrom/sjcd                    |    2 -
 Documentation/cdrom/sonycd535               |    4 +-
 Documentation/isdn/CREDITS                  |    2 -
 Documentation/sound/oss/AD1816              |    2 -
 Documentation/spi/pxa2xx                    |    2 -
 MAINTAINERS                                 |    4 +-
 arch/arm/mach-omap1/irq.c                   |    2 -
 arch/arm/mach-omap2/io.c                    |    2 -
 arch/arm/mach-omap2/timer-gp.c              |    2 -
 arch/arm/nwfpe/fpopcode.h                   |   34 ++++++++++----------
 arch/arm/plat-omap/dma.c                    |    2 -
 arch/arm/plat-omap/gpio.c                   |    2 -
 arch/arm26/nwfpe/fpopcode.h                 |   34 ++++++++++----------
 arch/i386/kernel/cpu/cpufreq/powernow-k6.c  |    2 -
 arch/i386/kernel/cpu/cyrix.c                |    6 +--
 arch/m68k/ifpsp060/CHANGES                  |    2 -
 arch/m68k/ifpsp060/MISC                     |    2 -
 arch/m68k/ifpsp060/README                   |    2 -
 arch/m68k/ifpsp060/TEST.DOC                 |    2 -
 arch/m68k/ifpsp060/fplsp.doc                |    2 -
 arch/m68k/ifpsp060/fpsp.doc                 |    2 -
 arch/m68k/ifpsp060/fskeleton.S              |    2 -
 arch/m68k/ifpsp060/ilsp.doc                 |    2 -
 arch/m68k/ifpsp060/iskeleton.S              |    2 -
 arch/m68k/ifpsp060/isp.doc                  |    2 -
 arch/m68k/ifpsp060/os.S                     |    2 -
 arch/m68k/ifpsp060/src/fplsp.S              |    2 -
 arch/m68k/ifpsp060/src/fpsp.S               |    2 -
 arch/m68k/ifpsp060/src/ftest.S              |    2 -
 arch/m68k/ifpsp060/src/ilsp.S               |    2 -
 arch/m68k/ifpsp060/src/isp.S                |    2 -
 arch/m68k/ifpsp060/src/itest.S              |    2 -
 arch/m68k/ifpsp060/src/pfpsp.S              |    2 -
 arch/m68k/tools/amiga/dmesg.c               |    2 -
 arch/mips/kernel/vmlinux.lds.S              |    2 -
 arch/powerpc/kernel/l2cr_6xx.S              |    2 -
 arch/powerpc/platforms/cell/spufs/file.c    |    2 -
 arch/ppc/platforms/apus_pci.c               |    2 -
 crypto/api.c                                |    2 -
 drivers/block/loop.c                        |    2 -
 drivers/cdrom/aztcd.c                       |    8 ++--
 drivers/cdrom/cdu31a.c                      |    4 +-
 drivers/cdrom/cm206.c                       |    6 +--
 drivers/cdrom/gscd.c                        |    2 -
 drivers/cdrom/gscd.h                        |    2 -
 drivers/cdrom/mcdx.c                        |    4 +-
 drivers/cdrom/mcdx.h                        |    2 -
 drivers/cdrom/optcd.c                       |    2 -
 drivers/cdrom/sbpcd.c                       |    8 ++--
 drivers/cdrom/sbpcd.h                       |    2 -
 drivers/cdrom/sjcd.c                        |    2 -
 drivers/cdrom/sjcd.h                        |    2 -
 drivers/cdrom/sonycd535.c                   |    2 -
 drivers/char/cyclades.c                     |    2 -
 drivers/char/drm/drm_hashtab.c              |    2 -
 drivers/char/drm/drm_hashtab.h              |    2 -
 drivers/char/drm/drm_mm.c                   |    2 -
 drivers/char/drm/drm_pci.c                  |    4 +-
 drivers/char/drm/drm_sarea.h                |    2 -
 drivers/char/drm/drm_sman.c                 |    2 -
 drivers/char/drm/drm_sman.h                 |    2 -
 drivers/char/drm/r128_drv.h                 |    2 -
 drivers/char/drm/radeon_irq.c               |    2 -
 drivers/char/drm/radeon_state.c             |    2 -
 drivers/char/drm/sis_mm.c                   |    2 -
 drivers/char/drm/via_mm.c                   |    2 -
 drivers/char/drm/via_verifier.h             |    2 -
 drivers/char/esp.c                          |    2 -
 drivers/char/hw_random/omap-rng.c           |    2 -
 drivers/char/i8k.c                          |   14 ++++----
 drivers/char/sonypi.c                       |    2 -
 drivers/char/watchdog/i6300esb.c            |    6 +--
 drivers/char/watchdog/iTCO_vendor_support.c |    2 -
 drivers/char/watchdog/w83627hf_wdt.c        |    2 -
 drivers/char/watchdog/w83697hf_wdt.c        |    2 -
 drivers/hwmon/gl520sm.c                     |    4 +-
 drivers/hwmon/sis5595.c                     |    2 -
 drivers/hwmon/via686a.c                     |    4 +-
 drivers/i2c/algos/i2c-algo-bit.c            |    2 -
 drivers/i2c/algos/i2c-algo-pca.c            |    2 -
 drivers/i2c/algos/i2c-algo-pcf.c            |    2 -
 drivers/i2c/busses/i2c-elektor.c            |    2 -
 drivers/i2c/busses/i2c-hydra.c              |    2 -
 drivers/i2c/busses/i2c-ibm_iic.c            |    2 -
 drivers/i2c/busses/i2c-omap.c               |    2 -
 drivers/i2c/busses/i2c-parport-light.c      |    2 -
 drivers/i2c/busses/i2c-parport.c            |    2 -
 drivers/i2c/busses/i2c-via.c                |    4 +-
 drivers/i2c/busses/i2c-viapro.c             |    2 -
 drivers/i2c/i2c-core.c                      |    2 -
 drivers/ide/ide-cd.c                        |    6 +--
 drivers/ide/legacy/q40ide.c                 |    2 -
 drivers/infiniband/core/sa_query.c          |    2 -
 drivers/input/joystick/db9.c                |    2 -
 drivers/input/keyboard/omap-keypad.c        |    4 +-
 drivers/isdn/hisax/amd7930_fn.c             |    2 -
 drivers/isdn/hisax/enternow_pci.c           |   28 ++++++++--------
 drivers/isdn/hisax/hfc_pci.c                |    2 -
 drivers/isdn/hisax/isdnhdlc.c               |    4 +-
 drivers/isdn/hisax/isdnhdlc.h               |    2 -
 drivers/isdn/hisax/jade.c                   |    2 -
 drivers/isdn/pcbit/capi.c                   |    4 +-
 drivers/md/raid1.c                          |    2 -
 drivers/media/common/saa7146_hlp.c          |    2 -
 drivers/media/dvb/cinergyT2/cinergyT2.c     |    2 -
 drivers/media/video/bt8xx/bttv-cards.c      |    4 +-
 drivers/media/video/meye.c                  |    2 -
 drivers/media/video/meye.h                  |    2 -
 drivers/media/video/saa5249.c               |    4 +-
 drivers/media/video/usbvideo/vicam.c        |    2 -
 drivers/media/video/v4l2-common.c           |    2 -
 drivers/message/i2o/README                  |    4 +-
 drivers/message/i2o/exec-osm.c              |    4 +-
 drivers/message/i2o/i2o_config.c            |    6 +--
 drivers/message/i2o/i2o_proc.c              |    4 +-
 drivers/message/i2o/iop.c                   |    4 +-
 drivers/message/i2o/pci.c                   |    4 +-
 drivers/misc/ibmasm/command.c               |    2 -
 drivers/misc/ibmasm/dot_command.c           |    2 -
 drivers/misc/ibmasm/dot_command.h           |    2 -
 drivers/misc/ibmasm/event.c                 |    2 -
 drivers/misc/ibmasm/heartbeat.c             |    2 -
 drivers/misc/ibmasm/i2o.h                   |    2 -
 drivers/misc/ibmasm/ibmasm.h                |    2 -
 drivers/misc/ibmasm/ibmasmfs.c              |    2 -
 drivers/misc/ibmasm/lowlevel.c              |    2 -
 drivers/misc/ibmasm/lowlevel.h              |    2 -
 drivers/misc/ibmasm/module.c                |    2 -
 drivers/misc/ibmasm/r_heartbeat.c           |    2 -
 drivers/misc/ibmasm/remote.c                |    2 -
 drivers/misc/ibmasm/remote.h                |    2 -
 drivers/misc/ibmasm/uart.c                  |    2 -
 drivers/net/8139too.c                       |    2 -
 drivers/net/ariadne.c                       |    2 -
 drivers/net/ariadne.h                       |    2 -
 drivers/net/atari_pamsnet.c                 |    2 -
 drivers/net/hamradio/6pack.c                |    2 -
 drivers/net/irda/actisys-sir.c              |    2 -
 drivers/net/irda/actisys.c                  |    2 -
 drivers/net/irda/girbil-sir.c               |    2 -
 drivers/net/irda/girbil.c                   |    2 -
 drivers/net/irda/irport.h                   |    2 -
 drivers/net/irda/irtty-sir.c                |    2 -
 drivers/net/irda/nsc-ircc.c                 |    2 -
 drivers/net/irda/nsc-ircc.h                 |    2 -
 drivers/net/irda/tekram-sir.c               |    2 -
 drivers/net/irda/tekram.c                   |    2 -
 drivers/net/irda/w83977af_ir.h              |    2 -
 drivers/net/wireless/netwave_cs.c           |    8 ++--
 drivers/s390/block/dasd_3990_erp.c          |    2 -
 drivers/s390/cio/cmf.c                      |    2 -
 drivers/s390/net/ctcmain.c                  |   10 ++---
 drivers/scsi/aha152x.c                      |    6 +--
 drivers/scsi/sun3_NCR5380.c                 |    2 -
 drivers/serial/s3c2410.c                    |    4 +-
 drivers/usb/gadget/lh7a40x_udc.c            |    2 -
 drivers/usb/misc/cytherm.c                  |    2 -
 drivers/usb/misc/emi26.c                    |    4 +-
 drivers/usb/misc/emi62.c                    |    4 +-
 drivers/usb/serial/ChangeLog.history        |    2 -
 drivers/usb/serial/ftdi_sio.c               |    2 -
 drivers/usb/serial/ftdi_sio.h               |    6 +--
 drivers/usb/serial/ipaq.c                   |    4 +-
 drivers/usb/storage/isd200.c                |    2 -
 drivers/usb/storage/unusual_devs.h          |    4 +-
 drivers/video/amifb.c                       |   14 ++++----
 drivers/video/aty/atyfb_base.c              |    2 -
 drivers/video/intelfb/intelfbdrv.c          |    2 -
 drivers/video/intelfb/intelfbhw.c           |    2 -
 drivers/video/s3c2410fb.c                   |    4 +-
 drivers/video/tdfxfb.c                      |    2 -
 drivers/zorro/zorro.ids                     |    4 +-
 fs/binfmt_em86.c                            |    2 -
 fs/binfmt_misc.c                            |    2 -
 fs/binfmt_script.c                          |    2 -
 fs/isofs/inode.c                            |    2 -
 fs/nfs/nfsroot.c                            |    2 -
 fs/ntfs/ChangeLog                           |    2 -
 fs/ntfs/sysctl.c                            |    2 -
 fs/ntfs/sysctl.h                            |    2 -
 fs/super.c                                  |    2 -
 include/asm-arm/arch-aaec2000/aaec2000.h    |    4 +-
 include/linux/cdrom.h                       |    2 -
 include/linux/crypto.h                      |    2 -
 net/ax25/ax25_ds_in.c                       |    2 -
 net/ax25/ax25_ds_subr.c                     |    2 -
 net/bluetooth/bnep/core.c                   |    2 -
 net/bluetooth/bnep/netdev.c                 |    2 -
 net/bridge/netfilter/ebtables.c             |    2 -
 net/core/pktgen.c                           |    2 -
 net/irda/iriap.c                            |    2 -
 net/irda/iriap_event.c                      |    2 -
 net/irda/irias_object.c                     |    2 -
 net/irda/irlan/irlan_client.c               |    2 -
 net/irda/irlan/irlan_common.c               |    2 -
 net/irda/irlan/irlan_eth.c                  |    2 -
 net/irda/irlan/irlan_event.c                |    2 -
 net/irda/irlan/irlan_provider.c             |    2 -
 net/irda/irlan/irlan_provider_event.c       |    2 -
 net/irda/irlap_event.c                      |    2 -
 net/irda/irlap_frame.c                      |    2 -
 net/irda/irlmp.c                            |    2 -
 net/irda/irlmp_event.c                      |    2 -
 net/irda/irlmp_frame.c                      |    2 -
 net/irda/irmod.c                            |    2 -
 net/irda/irqueue.c                          |    2 -
 net/irda/irsysctl.c                         |    2 -
 net/irda/irttp.c                            |    2 -
 sound/oss/emu10k1/passthrough.c             |    4 +-
 sound/oss/emu10k1/passthrough.h             |    4 +-
 214 files changed, 337 insertions(+), 337 deletions(-)


-- 
Stefan Richter
-=====-=-=== -=-= -====
http://arcgraph.de/sr/
