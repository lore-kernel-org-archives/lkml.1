Return-Path: <linux-kernel-owner+w=401wt.eu-S967113AbXJSIAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967113AbXJSIAL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 04:00:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935687AbXJSH7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 03:59:03 -0400
Received: from havoc.gtf.org ([69.61.125.42]:52979 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935517AbXJSH6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 03:58:48 -0400
Date: Fri, 19 Oct 2007 03:58:46 -0400
From: Jeff Garzik <jeff@garzik.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Subject: [PATCH 8/9] irq-remove: driver trivial
Message-ID: <20071019075846.GI6407@havoc.gtf.org>
References: <20071019075443.GA6407@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071019075443.GA6407@havoc.gtf.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


commit 52afddf59be0049d4118b21bdb1ef6bd1c5a9165
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Oct 19 00:48:47 2007 -0400

    [IRQ ARG REMOVAL] trivial driver updates

 drivers/acpi/osl.c                         |    2 +-
 drivers/ata/ahci.c                         |    2 +-
 drivers/ata/libata-core.c                  |    2 +-
 drivers/ata/pdc_adma.c                     |    2 +-
 drivers/ata/sata_inic162x.c                |    2 +-
 drivers/ata/sata_mv.c                      |    2 +-
 drivers/ata/sata_nv.c                      |   20 ++++++++++----------
 drivers/ata/sata_promise.c                 |    2 +-
 drivers/ata/sata_qstor.c                   |    2 +-
 drivers/ata/sata_sil.c                     |    2 +-
 drivers/ata/sata_sil24.c                   |    2 +-
 drivers/ata/sata_sx4.c                     |    2 +-
 drivers/ata/sata_vsc.c                     |    2 +-
 drivers/atm/eni.c                          |    2 +-
 drivers/atm/firestream.c                   |    2 +-
 drivers/atm/fore200e.c                     |    2 +-
 drivers/atm/he.c                           |    4 ++--
 drivers/atm/idt77252.c                     |    2 +-
 drivers/atm/iphase.c                       |    2 +-
 drivers/atm/lanai.c                        |    2 +-
 drivers/atm/nicstar.c                      |    4 ++--
 drivers/atm/zatm.c                         |    2 +-
 drivers/block/DAC960.c                     |   21 +++++++--------------
 drivers/block/DAC960.h                     |   12 ++++++------
 drivers/block/amiflop.c                    |    4 ++--
 drivers/block/ataflop.c                    |    4 ++--
 drivers/block/cciss.c                      |    6 +++---
 drivers/block/cpqarray.c                   |    4 ++--
 drivers/block/floppy.c                     |    4 ++--
 drivers/block/lguest_blk.c                 |    2 +-
 drivers/block/ps2esdi.c                    |    4 ++--
 drivers/block/swim3.c                      |    8 ++++----
 drivers/block/sx8.c                        |    2 +-
 drivers/block/umem.c                       |    2 +-
 drivers/block/xd.c                         |    2 +-
 drivers/block/xd.h                         |    2 +-
 drivers/block/xen-blkfront.c               |    2 +-
 drivers/char/amiserial.c                   |    6 +++---
 drivers/char/applicom.c                    |    4 ++--
 drivers/char/drm/drm_os_linux.h            |    2 +-
 drivers/char/esp.c                         |    2 +-
 drivers/char/hpet.c                        |    2 +-
 drivers/char/hvc_console.c                 |    2 +-
 drivers/char/hvcs.c                        |    4 ++--
 drivers/char/hvsi.c                        |    2 +-
 drivers/char/ipmi/ipmi_si_intf.c           |    6 +++---
 drivers/char/isicom.c                      |    2 +-
 drivers/char/mbcs.c                        |    3 +--
 drivers/char/mmtimer.c                     |    3 +--
 drivers/char/mxser.c                       |    4 ++--
 drivers/char/mxser_new.c                   |    2 +-
 drivers/char/nwbutton.c                    |    2 +-
 drivers/char/nwbutton.h                    |    2 +-
 drivers/char/rtc.c                         |    6 +++---
 drivers/char/ser_a2232.c                   |    4 ++--
 drivers/char/serial167.c                   |    6 +++---
 drivers/char/snsc.c                        |    2 +-
 drivers/char/snsc_event.c                  |    2 +-
 drivers/char/sonypi.c                      |    2 +-
 drivers/char/tlclk.c                       |    4 ++--
 drivers/char/vme_scc.c                     |   16 ++++++++--------
 drivers/dma/ioat_dma.c                     |    4 ++--
 drivers/fc4/soc.c                          |    2 +-
 drivers/fc4/socal.c                        |    2 +-
 drivers/firewire/fw-ohci.c                 |    2 +-
 drivers/i2c/busses/i2c-elektor.c           |    2 +-
 drivers/i2c/busses/i2c-ibm_iic.c           |    2 +-
 drivers/i2c/busses/i2c-iop3xx.c            |    2 +-
 drivers/i2c/busses/i2c-mpc.c               |    2 +-
 drivers/i2c/busses/i2c-mv64xxx.c           |    2 +-
 drivers/i2c/busses/i2c-ocores.c            |    2 +-
 drivers/i2c/busses/i2c-omap.c              |    2 +-
 drivers/i2c/busses/i2c-pca-isa.c           |    2 +-
 drivers/i2c/busses/i2c-pxa.c               |    2 +-
 drivers/i2c/busses/i2c-s3c2410.c           |    2 +-
 drivers/i2c/chips/isp1301_omap.c           |    2 +-
 drivers/i2c/chips/tps65010.c               |    2 +-
 drivers/ide/legacy/hd.c                    |    2 +-
 drivers/ieee1394/ohci1394.c                |    2 +-
 drivers/ieee1394/pcilynx.c                 |    2 +-
 drivers/infiniband/hw/amso1100/c2.c        |    4 ++--
 drivers/infiniband/hw/ehca/ehca_irq.c      |    4 ++--
 drivers/infiniband/hw/ehca/ehca_irq.h      |    4 ++--
 drivers/infiniband/hw/ipath/ipath_intr.c   |    2 +-
 drivers/infiniband/hw/ipath/ipath_kernel.h |    2 +-
 drivers/infiniband/hw/mthca/mthca_eq.c     |    8 ++++----
 drivers/input/joystick/amijoy.c            |    2 +-
 drivers/input/keyboard/amikbd.c            |    2 +-
 drivers/input/keyboard/corgikbd.c          |    2 +-
 drivers/input/keyboard/hilkbd.c            |    2 +-
 drivers/input/keyboard/locomokbd.c         |    2 +-
 drivers/input/keyboard/omap-keypad.c       |    2 +-
 drivers/input/keyboard/spitzkbd.c          |    4 ++--
 drivers/input/misc/ixp4xx-beeper.c         |    2 +-
 drivers/input/mouse/amimouse.c             |    2 +-
 drivers/input/mouse/inport.c               |    2 +-
 drivers/input/mouse/logibm.c               |    2 +-
 drivers/input/mouse/pc110pad.c             |    8 ++++----
 drivers/input/mouse/rpcmouse.c             |    2 +-
 drivers/input/serio/ambakmi.c              |    2 +-
 drivers/input/serio/ct82c710.c             |    2 +-
 drivers/input/serio/gscps2.c               |    4 ++--
 drivers/input/serio/hp_sdc.c               |    6 +++---
 drivers/input/serio/maceps2.c              |    2 +-
 drivers/input/serio/pcips2.c               |    2 +-
 drivers/input/serio/q40kbd.c               |    2 +-
 drivers/input/serio/rpckbd.c               |    4 ++--
 drivers/input/serio/sa1111ps2.c            |    4 ++--
 drivers/input/touchscreen/ads7846.c        |    2 +-
 drivers/input/touchscreen/corgi_ts.c       |    2 +-
 drivers/input/touchscreen/h3600_ts_input.c |    4 ++--
 drivers/input/touchscreen/hp680_ts_input.c |    2 +-
 drivers/input/touchscreen/mk712.c          |    2 +-
 drivers/isdn/hardware/avm/avmcard.h        |    4 ++--
 drivers/isdn/hardware/avm/b1.c             |    2 +-
 drivers/isdn/hardware/avm/b1dma.c          |    2 +-
 drivers/isdn/hardware/avm/c4.c             |    2 +-
 drivers/isdn/hardware/avm/t1isa.c          |    2 +-
 drivers/isdn/hardware/eicon/divasmain.c    |    2 +-
 drivers/isdn/hisax/asuscom.c               |    4 ++--
 drivers/isdn/hisax/avm_a1.c                |    2 +-
 drivers/isdn/hisax/avm_a1p.c               |    2 +-
 drivers/isdn/hisax/avm_pci.c               |    2 +-
 drivers/isdn/hisax/bkm_a4t.c               |    2 +-
 drivers/isdn/hisax/bkm_a8.c                |    2 +-
 drivers/isdn/hisax/diva.c                  |    8 ++++----
 drivers/isdn/hisax/elsa.c                  |    8 ++++----
 drivers/isdn/hisax/elsa_ser.c              |    2 +-
 drivers/isdn/hisax/enternow_pci.c          |    2 +-
 drivers/isdn/hisax/gazel.c                 |    4 ++--
 drivers/isdn/hisax/hfc4s8s_l1.c            |    2 +-
 drivers/isdn/hisax/hfc_pci.c               |    2 +-
 drivers/isdn/hisax/hfc_sx.c                |    2 +-
 drivers/isdn/hisax/hfcscard.c              |    2 +-
 drivers/isdn/hisax/hisax_fcpcipnp.c        |    4 ++--
 drivers/isdn/hisax/isurf.c                 |    2 +-
 drivers/isdn/hisax/ix1_micro.c             |    2 +-
 drivers/isdn/hisax/mic.c                   |    2 +-
 drivers/isdn/hisax/netjet.h                |    2 +-
 drivers/isdn/hisax/niccy.c                 |    2 +-
 drivers/isdn/hisax/nj_s.c                  |    2 +-
 drivers/isdn/hisax/nj_u.c                  |    2 +-
 drivers/isdn/hisax/s0box.c                 |    2 +-
 drivers/isdn/hisax/saphir.c                |    2 +-
 drivers/isdn/hisax/sedlbauer.c             |    6 +++---
 drivers/isdn/hisax/sportster.c             |    2 +-
 drivers/isdn/hisax/teleint.c               |    2 +-
 drivers/isdn/hisax/teles0.c                |    2 +-
 drivers/isdn/hisax/teles3.c                |    2 +-
 drivers/isdn/hisax/telespci.c              |    2 +-
 drivers/isdn/hysdn/boardergo.c             |    2 +-
 drivers/isdn/pcbit/layer2.c                |    2 +-
 drivers/isdn/pcbit/layer2.h                |    2 +-
 drivers/isdn/sc/card.h                     |    2 +-
 drivers/macintosh/macio-adb.c              |    4 ++--
 drivers/macintosh/smu.c                    |    4 ++--
 drivers/macintosh/via-cuda.c               |    4 ++--
 drivers/macintosh/via-pmu.c                |    8 ++++----
 drivers/media/common/saa7146_core.c        |    2 +-
 drivers/media/dvb/b2c2/flexcop-pci.c       |    2 +-
 drivers/media/dvb/bt8xx/bt878.c            |    2 +-
 drivers/media/dvb/pluto2/pluto2.c          |    2 +-
 drivers/media/video/arv.c                  |    2 +-
 drivers/media/video/bt8xx/bttv-driver.c    |    2 +-
 drivers/media/video/cafe_ccic.c            |    2 +-
 drivers/media/video/cx23885/cx23885-core.c |    2 +-
 drivers/media/video/cx88/cx88-alsa.c       |    2 +-
 drivers/media/video/cx88/cx88-mpeg.c       |    2 +-
 drivers/media/video/cx88/cx88-video.c      |    2 +-
 drivers/media/video/ivtv/ivtv-irq.c        |    2 +-
 drivers/media/video/ivtv/ivtv-irq.h        |    2 +-
 drivers/media/video/meye.c                 |    2 +-
 drivers/media/video/saa7134/saa7134-alsa.c |    2 +-
 drivers/media/video/saa7134/saa7134-core.c |    2 +-
 drivers/media/video/saa7134/saa7134-oss.c  |    2 +-
 drivers/media/video/stradis.c              |    2 +-
 drivers/media/video/vino.c                 |    2 +-
 drivers/media/video/zoran_device.c         |    3 +--
 drivers/media/video/zoran_device.h         |    2 +-
 drivers/message/fusion/mptbase.c           |    4 ++--
 drivers/message/i2o/pci.c                  |    3 +--
 drivers/mfd/ucb1x00-core.c                 |    2 +-
 drivers/misc/ibmasm/ibmasm.h               |    2 +-
 drivers/misc/ibmasm/lowlevel.c             |    2 +-
 drivers/misc/phantom.c                     |    2 +-
 drivers/misc/sony-laptop.c                 |    2 +-
 drivers/misc/tifm_7xx1.c                   |    2 +-
 drivers/mmc/host/at91_mci.c                |    2 +-
 drivers/mmc/host/au1xmmc.c                 |    4 ++--
 drivers/mmc/host/imxmmc.c                  |    2 +-
 drivers/mmc/host/mmci.c                    |    4 ++--
 drivers/mmc/host/omap.c                    |    4 ++--
 drivers/mmc/host/pxamci.c                  |    4 ++--
 drivers/mmc/host/sdhci.c                   |    2 +-
 drivers/mmc/host/wbsd.c                    |    2 +-
 drivers/mtd/nand/cafe_nand.c               |    2 +-
 drivers/parisc/dino.c                      |    2 +-
 drivers/parisc/eisa.c                      |    2 +-
 drivers/parisc/gsc.c                       |    2 +-
 drivers/parisc/gsc.h                       |    2 +-
 drivers/parisc/superio.c                   |    2 +-
 drivers/pci/hotplug/cpci_hotplug_core.c    |    2 +-
 drivers/pci/hotplug/cpqphp.h               |    2 +-
 drivers/pci/hotplug/cpqphp_ctrl.c          |    2 +-
 drivers/pci/hotplug/pciehp_hpc.c           |    6 +++---
 drivers/pci/hotplug/shpchp_hpc.c           |    6 +++---
 drivers/pci/pcie/aer/aerdrv.c              |    3 +--
 drivers/pcmcia/at91_cf.c                   |    2 +-
 drivers/pcmcia/hd64465_ss.c                |    4 ++--
 drivers/pcmcia/i82092.c                    |    2 +-
 drivers/pcmcia/i82092aa.h                  |    2 +-
 drivers/pcmcia/m32r_cfc.c                  |    2 +-
 drivers/pcmcia/m32r_pcc.c                  |    4 ++--
 drivers/pcmcia/m8xx_pcmcia.c               |    4 ++--
 drivers/pcmcia/omap_cf.c                   |    2 +-
 drivers/pcmcia/pcmcia_resource.c           |    2 +-
 drivers/pcmcia/pd6729.c                    |    6 +++---
 drivers/pcmcia/soc_common.c                |    2 +-
 drivers/pcmcia/vrc4171_card.c              |    2 +-
 drivers/pcmcia/vrc4173_cardu.c             |    2 +-
 drivers/pcmcia/yenta_socket.c              |    6 +++---
 drivers/pnp/resource.c                     |    2 +-
 drivers/power/pda_power.c                  |    2 +-
 drivers/rtc/rtc-cmos.c                     |    2 +-
 drivers/rtc/rtc-ds1553.c                   |    2 +-
 drivers/rtc/rtc-m48t59.c                   |    2 +-
 drivers/rtc/rtc-pl031.c                    |    2 +-
 drivers/rtc/rtc-s3c.c                      |    4 ++--
 drivers/rtc/rtc-sa1100.c                   |    4 ++--
 drivers/rtc/rtc-sh.c                       |    6 +++---
 drivers/rtc/rtc-stk17ta8.c                 |    2 +-
 drivers/rtc/rtc-vr41xx.c                   |    4 ++--
 drivers/sbus/char/bbc_i2c.c                |    2 +-
 drivers/sbus/char/cpwatchdog.c             |    4 ++--
 drivers/sbus/char/uctrl.c                  |    2 +-
 drivers/serial/21285.c                     |    4 ++--
 drivers/serial/68328serial.c               |    2 +-
 drivers/serial/amba-pl010.c                |    2 +-
 drivers/serial/amba-pl011.c                |    2 +-
 drivers/serial/atmel_serial.c              |    2 +-
 drivers/serial/clps711x.c                  |    4 ++--
 drivers/serial/cpm_uart/cpm_uart_core.c    |    2 +-
 drivers/serial/crisv10.c                   |    6 +++---
 drivers/serial/dz.c                        |    2 +-
 drivers/serial/icom.c                      |    2 +-
 drivers/serial/imx.c                       |    6 +++---
 drivers/serial/ioc4_serial.c               |    3 +--
 drivers/serial/ip22zilog.c                 |    2 +-
 drivers/serial/jsm/jsm_neo.c               |    2 +-
 drivers/serial/m32r_sio.c                  |    2 +-
 drivers/serial/mcfserial.c                 |    2 +-
 drivers/serial/mpc52xx_uart.c              |    4 ++--
 drivers/serial/mpsc.c                      |    2 +-
 drivers/serial/netx-serial.c               |    2 +-
 drivers/serial/pmac_zilog.c                |    2 +-
 drivers/serial/pxa.c                       |    2 +-
 drivers/serial/s3c2410.c                   |    4 ++--
 drivers/serial/sa1100.c                    |    2 +-
 drivers/serial/serial_lh7a40x.c            |    2 +-
 drivers/serial/serial_txx9.c               |    2 +-
 drivers/serial/sh-sci.c                    |   10 +++++-----
 drivers/serial/sn_console.c                |    2 +-
 drivers/serial/sunhv.c                     |    2 +-
 drivers/serial/sunsab.c                    |    2 +-
 drivers/serial/sunsu.c                     |    4 ++--
 drivers/serial/sunzilog.c                  |    2 +-
 drivers/serial/v850e_uart.c                |    4 ++--
 drivers/serial/vr41xx_siu.c                |    2 +-
 drivers/sn/ioc3.c                          |    4 ++--
 drivers/spi/pxa2xx_spi.c                   |    2 +-
 drivers/spi/spi_mpc83xx.c                  |    2 +-
 drivers/spi/spi_s3c24xx.c                  |    2 +-
 drivers/uio/uio.c                          |    4 ++--
 drivers/uio/uio_cif.c                      |    3 ++-
 drivers/usb/core/hcd.c                     |    2 +-
 drivers/usb/core/hcd.h                     |    2 +-
 drivers/usb/gadget/amd5536udc.c            |    2 +-
 drivers/usb/gadget/at91_udc.c              |    2 +-
 drivers/usb/gadget/goku_udc.c              |    2 +-
 drivers/usb/gadget/lh7a40x_udc.c           |    2 +-
 drivers/usb/gadget/net2280.c               |    2 +-
 drivers/usb/gadget/omap_udc.c              |    6 +++---
 drivers/usb/gadget/pxa2xx_udc.c            |    6 +++---
 drivers/video/amifb.c                      |    4 ++--
 drivers/video/arcfb.c                      |    2 +-
 drivers/video/atafb.c                      |    2 +-
 drivers/video/aty/atyfb_base.c             |    2 +-
 drivers/video/au1200fb.c                   |    2 +-
 drivers/video/console/fbcon.c              |    4 ++--
 drivers/video/intelfb/intelfbhw.c          |    2 +-
 drivers/video/matrox/matroxfb_base.c       |    2 +-
 drivers/video/pvr2fb.c                     |    4 ++--
 drivers/video/pxafb.c                      |    2 +-
 drivers/video/s3c2410fb.c                  |    2 +-
 drivers/video/sa1100fb.c                   |    2 +-
 drivers/watchdog/eurotechwdt.c             |    2 +-
 drivers/watchdog/mpcore_wdt.c              |    2 +-
 drivers/watchdog/s3c2410_wdt.c             |    2 +-
 drivers/watchdog/wdt.c                     |    3 +--
 drivers/watchdog/wdt285.c                  |    2 +-
 drivers/watchdog/wdt_pci.c                 |    2 +-
 drivers/xen/xenbus/xenbus_comms.c          |    2 +-
 include/linux/arcdevice.h                  |    2 +-
 include/linux/ide.h                        |    2 +-
 include/linux/libata.h                     |    2 +-
 include/linux/rtc.h                        |    2 +-
 include/sound/cs4231.h                     |    2 +-
 include/sound/emu10k1.h                    |    2 +-
 include/sound/gus.h                        |    2 +-
 include/sound/initval.h                    |    2 +-
 include/sound/mpu401.h                     |    4 ++--
 include/sound/sb.h                         |    2 +-
 include/sound/vx_core.h                    |    2 +-
 313 files changed, 447 insertions(+), 460 deletions(-)

52afddf59be0049d4118b21bdb1ef6bd1c5a9165
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 352cf81..d154b1e 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -287,7 +287,7 @@ acpi_os_table_override(struct acpi_table_header * existing_table,
 	return AE_OK;
 }
 
-static irqreturn_t acpi_irq(int irq, void *dev_id)
+static irqreturn_t acpi_irq(void *dev_id)
 {
 	return (*acpi_irq_handler) (acpi_irq_context) ? IRQ_HANDLED : IRQ_NONE;
 }
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 10bc3f6..aec151e 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1545,7 +1545,7 @@ static void ahci_irq_clear(struct ata_port *ap)
 	/* TODO */
 }
 
-static irqreturn_t ahci_interrupt(int irq, void *dev_instance)
+static irqreturn_t ahci_interrupt(void *dev_instance)
 {
 	struct ata_host *host = dev_instance;
 	struct ahci_host_priv *hpriv;
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index bbaa545..5d51222 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6009,7 +6009,7 @@ idle_irq:
  *	IRQ_NONE or IRQ_HANDLED.
  */
 
-irqreturn_t ata_interrupt (int irq, void *dev_instance)
+irqreturn_t ata_interrupt (void *dev_instance)
 {
 	struct ata_host *host = dev_instance;
 	unsigned int i;
diff --git a/drivers/ata/pdc_adma.c b/drivers/ata/pdc_adma.c
index 199f7e1..2431d06 100644
--- a/drivers/ata/pdc_adma.c
+++ b/drivers/ata/pdc_adma.c
@@ -565,7 +565,7 @@ static inline unsigned int adma_intr_mmio(struct ata_host *host)
 	return handled;
 }
 
-static irqreturn_t adma_intr(int irq, void *dev_instance)
+static irqreturn_t adma_intr(void *dev_instance)
 {
 	struct ata_host *host = dev_instance;
 	unsigned int handled = 0;
diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index 08595f3..f78f0b0 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -320,7 +320,7 @@ static void inic_host_intr(struct ata_port *ap)
 		ata_port_abort(ap);
 }
 
-static irqreturn_t inic_interrupt(int irq, void *dev_instance)
+static irqreturn_t inic_interrupt(void *dev_instance)
 {
 	struct ata_host *host = dev_instance;
 	void __iomem *mmio_base = host->iomap[MMIO_BAR];
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 7f1b13e..dfd3c3d 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -1699,7 +1699,7 @@ static void mv_pci_error(struct ata_host *host, void __iomem *mmio)
  *      This routine holds the host lock while processing pending
  *      interrupts.
  */
-static irqreturn_t mv_interrupt(int irq, void *dev_instance)
+static irqreturn_t mv_interrupt(void *dev_instance)
 {
 	struct ata_host *host = dev_instance;
 	unsigned int hc, handled = 0, n_hcs;
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 240a892..10bb0ea 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -298,9 +298,9 @@ static int nv_init_one (struct pci_dev *pdev, const struct pci_device_id *ent);
 static int nv_pci_device_resume(struct pci_dev *pdev);
 #endif
 static void nv_ck804_host_stop(struct ata_host *host);
-static irqreturn_t nv_generic_interrupt(int irq, void *dev_instance);
-static irqreturn_t nv_nf2_interrupt(int irq, void *dev_instance);
-static irqreturn_t nv_ck804_interrupt(int irq, void *dev_instance);
+static irqreturn_t nv_generic_interrupt(void *dev_instance);
+static irqreturn_t nv_nf2_interrupt(void *dev_instance);
+static irqreturn_t nv_ck804_interrupt(void *dev_instance);
 static int nv_scr_read (struct ata_port *ap, unsigned int sc_reg, u32 *val);
 static int nv_scr_write (struct ata_port *ap, unsigned int sc_reg, u32 val);
 
@@ -313,7 +313,7 @@ static int nv_adma_slave_config(struct scsi_device *sdev);
 static int nv_adma_check_atapi_dma(struct ata_queued_cmd *qc);
 static void nv_adma_qc_prep(struct ata_queued_cmd *qc);
 static unsigned int nv_adma_qc_issue(struct ata_queued_cmd *qc);
-static irqreturn_t nv_adma_interrupt(int irq, void *dev_instance);
+static irqreturn_t nv_adma_interrupt(void *dev_instance);
 static void nv_adma_irq_clear(struct ata_port *ap);
 static int nv_adma_port_start(struct ata_port *ap);
 static void nv_adma_port_stop(struct ata_port *ap);
@@ -337,7 +337,7 @@ static void nv_swncq_qc_prep(struct ata_queued_cmd *qc);
 static void nv_swncq_fill_sg(struct ata_queued_cmd *qc);
 static unsigned int nv_swncq_qc_issue(struct ata_queued_cmd *qc);
 static void nv_swncq_irq_clear(struct ata_port *ap, u16 fis);
-static irqreturn_t nv_swncq_interrupt(int irq, void *dev_instance);
+static irqreturn_t nv_swncq_interrupt(void *dev_instance);
 #ifdef CONFIG_PM
 static int nv_swncq_port_suspend(struct ata_port *ap, pm_message_t mesg);
 static int nv_swncq_port_resume(struct ata_port *ap);
@@ -921,7 +921,7 @@ static int nv_host_intr(struct ata_port *ap, u8 irq_stat)
 	return ata_host_intr(ap, qc);
 }
 
-static irqreturn_t nv_adma_interrupt(int irq, void *dev_instance)
+static irqreturn_t nv_adma_interrupt(void *dev_instance)
 {
 	struct ata_host *host = dev_instance;
 	int i, handled = 0;
@@ -1451,7 +1451,7 @@ static unsigned int nv_adma_qc_issue(struct ata_queued_cmd *qc)
 	return 0;
 }
 
-static irqreturn_t nv_generic_interrupt(int irq, void *dev_instance)
+static irqreturn_t nv_generic_interrupt(void *dev_instance)
 {
 	struct ata_host *host = dev_instance;
 	unsigned int i;
@@ -1500,7 +1500,7 @@ static irqreturn_t nv_do_interrupt(struct ata_host *host, u8 irq_stat)
 	return IRQ_RETVAL(handled);
 }
 
-static irqreturn_t nv_nf2_interrupt(int irq, void *dev_instance)
+static irqreturn_t nv_nf2_interrupt(void *dev_instance)
 {
 	struct ata_host *host = dev_instance;
 	u8 irq_stat;
@@ -1514,7 +1514,7 @@ static irqreturn_t nv_nf2_interrupt(int irq, void *dev_instance)
 	return ret;
 }
 
-static irqreturn_t nv_ck804_interrupt(int irq, void *dev_instance)
+static irqreturn_t nv_ck804_interrupt(void *dev_instance)
 {
 	struct ata_host *host = dev_instance;
 	u8 irq_stat;
@@ -2318,7 +2318,7 @@ irq_error:
 	return;
 }
 
-static irqreturn_t nv_swncq_interrupt(int irq, void *dev_instance)
+static irqreturn_t nv_swncq_interrupt(void *dev_instance)
 {
 	struct ata_host *host = dev_instance;
 	unsigned int i;
diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index 9032131..20927b3 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -707,7 +707,7 @@ static inline unsigned int pdc_port_no_to_ata_no(unsigned int port_no, int is_sa
 	return is_sataii_tx4 ? sataii_tx4_port_remap[port_no] : port_no;
 }
 
-static irqreturn_t pdc_interrupt (int irq, void *dev_instance)
+static irqreturn_t pdc_interrupt (void *dev_instance)
 {
 	struct ata_host *host = dev_instance;
 	struct ata_port *ap;
diff --git a/drivers/ata/sata_qstor.c b/drivers/ata/sata_qstor.c
index c4c4cd2..5563c33 100644
--- a/drivers/ata/sata_qstor.c
+++ b/drivers/ata/sata_qstor.c
@@ -456,7 +456,7 @@ static inline unsigned int qs_intr_mmio(struct ata_host *host)
 	return handled;
 }
 
-static irqreturn_t qs_intr(int irq, void *dev_instance)
+static irqreturn_t qs_intr(void *dev_instance)
 {
 	struct ata_host *host = dev_instance;
 	unsigned int handled = 0;
diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index ea3a0ab..85db01c 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -466,7 +466,7 @@ static void sil_host_intr(struct ata_port *ap, u32 bmdma2)
 	ata_port_freeze(ap);
 }
 
-static irqreturn_t sil_interrupt(int irq, void *dev_instance)
+static irqreturn_t sil_interrupt(void *dev_instance)
 {
 	struct ata_host *host = dev_instance;
 	void __iomem *mmio_base = host->iomap[SIL_MMIO_BAR];
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index 26ebffc..50a90fc 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -1147,7 +1147,7 @@ static inline void sil24_host_intr(struct ata_port *ap)
 			slot_stat, ap->link.active_tag, ap->link.sactive);
 }
 
-static irqreturn_t sil24_interrupt(int irq, void *dev_instance)
+static irqreturn_t sil24_interrupt(void *dev_instance)
 {
 	struct ata_host *host = dev_instance;
 	void __iomem *host_base = host->iomap[SIL24_HOST_BAR];
diff --git a/drivers/ata/sata_sx4.c b/drivers/ata/sata_sx4.c
index 9f9f7b3..87f4153 100644
--- a/drivers/ata/sata_sx4.c
+++ b/drivers/ata/sata_sx4.c
@@ -803,7 +803,7 @@ static void pdc20621_irq_clear(struct ata_port *ap)
 	readl(mmio + PDC_20621_SEQMASK);
 }
 
-static irqreturn_t pdc20621_interrupt (int irq, void *dev_instance)
+static irqreturn_t pdc20621_interrupt (void *dev_instance)
 {
 	struct ata_host *host = dev_instance;
 	struct ata_port *ap;
diff --git a/drivers/ata/sata_vsc.c b/drivers/ata/sata_vsc.c
index 0d9be16..4242ff3 100644
--- a/drivers/ata/sata_vsc.c
+++ b/drivers/ata/sata_vsc.c
@@ -258,7 +258,7 @@ static void vsc_port_intr(u8 port_status, struct ata_port *ap)
  *
  * Read the interrupt register and process for the devices that have them pending.
  */
-static irqreturn_t vsc_sata_interrupt (int irq, void *dev_instance)
+static irqreturn_t vsc_sata_interrupt (void *dev_instance)
 {
 	struct ata_host *host = dev_instance;
 	unsigned int i;
diff --git a/drivers/atm/eni.c b/drivers/atm/eni.c
index 41b2204..4eded7e 100644
--- a/drivers/atm/eni.c
+++ b/drivers/atm/eni.c
@@ -1487,7 +1487,7 @@ static void bug_int(struct atm_dev *dev,unsigned long reason)
 }
 
 
-static irqreturn_t eni_int(int irq,void *dev_id)
+static irqreturn_t eni_int(void *dev_id)
 {
 	struct atm_dev *dev;
 	struct eni_dev *eni_dev;
diff --git a/drivers/atm/firestream.c b/drivers/atm/firestream.c
index 94ebc9d..821b183 100644
--- a/drivers/atm/firestream.c
+++ b/drivers/atm/firestream.c
@@ -1557,7 +1557,7 @@ static void __devexit free_freepool (struct fs_dev *dev, struct freepool *fp)
 
 
 
-static irqreturn_t fs_irq (int irq, void *dev_id) 
+static irqreturn_t fs_irq (void *dev_id) 
 {
 	int i;
 	u32 status;
diff --git a/drivers/atm/fore200e.c b/drivers/atm/fore200e.c
index 8b12925..036387b 100644
--- a/drivers/atm/fore200e.c
+++ b/drivers/atm/fore200e.c
@@ -1306,7 +1306,7 @@ fore200e_irq(struct fore200e* fore200e)
 
 
 static irqreturn_t
-fore200e_interrupt(int irq, void* dev)
+fore200e_interrupt(void *dev)
 {
     struct fore200e* fore200e = FORE200E_DEV((struct atm_dev*)dev);
 
diff --git a/drivers/atm/he.c b/drivers/atm/he.c
index d33aba6..18aa58e 100644
--- a/drivers/atm/he.c
+++ b/drivers/atm/he.c
@@ -109,7 +109,7 @@ static int he_open(struct atm_vcc *vcc);
 static void he_close(struct atm_vcc *vcc);
 static int he_send(struct atm_vcc *vcc, struct sk_buff *skb);
 static int he_ioctl(struct atm_dev *dev, unsigned int cmd, void __user *arg);
-static irqreturn_t he_irq_handler(int irq, void *dev_id);
+static irqreturn_t he_irq_handler(void *dev_id);
 static void he_tasklet(unsigned long data);
 static int he_proc_read(struct atm_dev *dev,loff_t *pos,char *page);
 static int he_start(struct atm_dev *dev);
@@ -2216,7 +2216,7 @@ he_tasklet(unsigned long data)
 }
 
 static irqreturn_t
-he_irq_handler(int irq, void *dev_id)
+he_irq_handler(void *dev_id)
 {
 	unsigned long flags;
 	struct he_dev *he_dev = (struct he_dev * )dev_id;
diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
index eee54c0..411bb1e 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -2780,7 +2780,7 @@ idt77252_collect_stat(struct idt77252_dev *card)
 }
 
 static irqreturn_t
-idt77252_interrupt(int irq, void *dev_id)
+idt77252_interrupt(void *dev_id)
 {
 	struct idt77252_dev *card = dev_id;
 	u32 stat;
diff --git a/drivers/atm/iphase.c b/drivers/atm/iphase.c
index ef52452..1848ecf 100644
--- a/drivers/atm/iphase.c
+++ b/drivers/atm/iphase.c
@@ -2195,7 +2195,7 @@ err_out:
 	return -ENOMEM;
 }   
    
-static irqreturn_t ia_int(int irq, void *dev_id)  
+static irqreturn_t ia_int(void *dev_id)  
 {  
    struct atm_dev *dev;  
    IADEV *iadev;  
diff --git a/drivers/atm/lanai.c b/drivers/atm/lanai.c
index 144a49f..a4fb1f7 100644
--- a/drivers/atm/lanai.c
+++ b/drivers/atm/lanai.c
@@ -1888,7 +1888,7 @@ static inline void lanai_int_1(struct lanai_dev *lanai, u32 reason)
 		reg_write(lanai, ack, IntAck_Reg);
 }
 
-static irqreturn_t lanai_int(int irq, void *devid)
+static irqreturn_t lanai_int(void *devid)
 {
 	struct lanai_dev *lanai = devid;
 	u32 reason;
diff --git a/drivers/atm/nicstar.c b/drivers/atm/nicstar.c
index 14ced85..1a0f2bd 100644
--- a/drivers/atm/nicstar.c
+++ b/drivers/atm/nicstar.c
@@ -214,7 +214,7 @@ static void __devinit ns_init_card_error(ns_dev *card, int error);
 static scq_info *get_scq(int size, u32 scd);
 static void free_scq(scq_info *scq, struct atm_vcc *vcc);
 static void push_rxbufs(ns_dev *, struct sk_buff *);
-static irqreturn_t ns_irq_handler(int irq, void *dev_id);
+static irqreturn_t ns_irq_handler(void *dev_id);
 static int ns_open(struct atm_vcc *vcc);
 static void ns_close(struct atm_vcc *vcc);
 static void fill_tst(ns_dev *card, int n, vc_map *vc);
@@ -1194,7 +1194,7 @@ static void push_rxbufs(ns_dev *card, struct sk_buff *skb)
 
 
 
-static irqreturn_t ns_irq_handler(int irq, void *dev_id)
+static irqreturn_t ns_irq_handler(void *dev_id)
 {
    u32 stat_r;
    ns_dev *card;
diff --git a/drivers/atm/zatm.c b/drivers/atm/zatm.c
index 58583c6..fe37cc3 100644
--- a/drivers/atm/zatm.c
+++ b/drivers/atm/zatm.c
@@ -1013,7 +1013,7 @@ static int start_tx(struct atm_dev *dev)
 /*------------------------------- interrupts --------------------------------*/
 
 
-static irqreturn_t zatm_int(int irq,void *dev_id)
+static irqreturn_t zatm_int(void *dev_id)
 {
 	struct atm_dev *dev;
 	struct zatm_dev *zatm_dev;
diff --git a/drivers/block/DAC960.c b/drivers/block/DAC960.c
index 84d6aa5..8ebeae2 100644
--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -5254,8 +5254,7 @@ static void DAC960_V2_ProcessCompletedCommand(DAC960_Command_T *Command)
   Controllers.
 */
 
-static irqreturn_t DAC960_GEM_InterruptHandler(int IRQ_Channel,
-				       void *DeviceIdentifier)
+static irqreturn_t DAC960_GEM_InterruptHandler(void *DeviceIdentifier)
 {
   DAC960_Controller_T *Controller = DeviceIdentifier;
   void __iomem *ControllerBaseAddress = Controller->BaseAddress;
@@ -5295,8 +5294,7 @@ static irqreturn_t DAC960_GEM_InterruptHandler(int IRQ_Channel,
   Controllers.
 */
 
-static irqreturn_t DAC960_BA_InterruptHandler(int IRQ_Channel,
-				       void *DeviceIdentifier)
+static irqreturn_t DAC960_BA_InterruptHandler(void *DeviceIdentifier)
 {
   DAC960_Controller_T *Controller = DeviceIdentifier;
   void __iomem *ControllerBaseAddress = Controller->BaseAddress;
@@ -5337,8 +5335,7 @@ static irqreturn_t DAC960_BA_InterruptHandler(int IRQ_Channel,
   Controllers.
 */
 
-static irqreturn_t DAC960_LP_InterruptHandler(int IRQ_Channel,
-				       void *DeviceIdentifier)
+static irqreturn_t DAC960_LP_InterruptHandler(void *DeviceIdentifier)
 {
   DAC960_Controller_T *Controller = DeviceIdentifier;
   void __iomem *ControllerBaseAddress = Controller->BaseAddress;
@@ -5379,8 +5376,7 @@ static irqreturn_t DAC960_LP_InterruptHandler(int IRQ_Channel,
   Controllers.
 */
 
-static irqreturn_t DAC960_LA_InterruptHandler(int IRQ_Channel,
-				       void *DeviceIdentifier)
+static irqreturn_t DAC960_LA_InterruptHandler(void *DeviceIdentifier)
 {
   DAC960_Controller_T *Controller = DeviceIdentifier;
   void __iomem *ControllerBaseAddress = Controller->BaseAddress;
@@ -5417,8 +5413,7 @@ static irqreturn_t DAC960_LA_InterruptHandler(int IRQ_Channel,
   Controllers.
 */
 
-static irqreturn_t DAC960_PG_InterruptHandler(int IRQ_Channel,
-				       void *DeviceIdentifier)
+static irqreturn_t DAC960_PG_InterruptHandler(void *DeviceIdentifier)
 {
   DAC960_Controller_T *Controller = DeviceIdentifier;
   void __iomem *ControllerBaseAddress = Controller->BaseAddress;
@@ -5455,8 +5450,7 @@ static irqreturn_t DAC960_PG_InterruptHandler(int IRQ_Channel,
   Controllers.
 */
 
-static irqreturn_t DAC960_PD_InterruptHandler(int IRQ_Channel,
-				       void *DeviceIdentifier)
+static irqreturn_t DAC960_PD_InterruptHandler(void *DeviceIdentifier)
 {
   DAC960_Controller_T *Controller = DeviceIdentifier;
   void __iomem *ControllerBaseAddress = Controller->BaseAddress;
@@ -5493,8 +5487,7 @@ static irqreturn_t DAC960_PD_InterruptHandler(int IRQ_Channel,
   an arbitrary buffer.
 */
 
-static irqreturn_t DAC960_P_InterruptHandler(int IRQ_Channel,
-				      void *DeviceIdentifier)
+static irqreturn_t DAC960_P_InterruptHandler(void *DeviceIdentifier)
 {
   DAC960_Controller_T *Controller = DeviceIdentifier;
   void __iomem *ControllerBaseAddress = Controller->BaseAddress;
diff --git a/drivers/block/DAC960.h b/drivers/block/DAC960.h
index 85fa9bb..323b3bf 100644
--- a/drivers/block/DAC960.h
+++ b/drivers/block/DAC960.h
@@ -4398,12 +4398,12 @@ static void DAC960_FinalizeController(DAC960_Controller_T *);
 static void DAC960_V1_QueueReadWriteCommand(DAC960_Command_T *);
 static void DAC960_V2_QueueReadWriteCommand(DAC960_Command_T *); 
 static void DAC960_RequestFunction(struct request_queue *);
-static irqreturn_t DAC960_BA_InterruptHandler(int, void *);
-static irqreturn_t DAC960_LP_InterruptHandler(int, void *);
-static irqreturn_t DAC960_LA_InterruptHandler(int, void *);
-static irqreturn_t DAC960_PG_InterruptHandler(int, void *);
-static irqreturn_t DAC960_PD_InterruptHandler(int, void *);
-static irqreturn_t DAC960_P_InterruptHandler(int, void *);
+static irqreturn_t DAC960_BA_InterruptHandler(void *);
+static irqreturn_t DAC960_LP_InterruptHandler(void *);
+static irqreturn_t DAC960_LA_InterruptHandler(void *);
+static irqreturn_t DAC960_PG_InterruptHandler(void *);
+static irqreturn_t DAC960_PD_InterruptHandler(void *);
+static irqreturn_t DAC960_P_InterruptHandler(void *);
 static void DAC960_V1_QueueMonitoringCommand(DAC960_Command_T *);
 static void DAC960_V2_QueueMonitoringCommand(DAC960_Command_T *);
 static void DAC960_MonitoringTimerFunction(unsigned long);
diff --git a/drivers/block/amiflop.c b/drivers/block/amiflop.c
index c9751b2..75ed236 100644
--- a/drivers/block/amiflop.c
+++ b/drivers/block/amiflop.c
@@ -209,7 +209,7 @@ static int fd_device[4] = { 0, 0, 0, 0 };
 
 /* Milliseconds timer */
 
-static irqreturn_t ms_isr(int irq, void *dummy)
+static irqreturn_t ms_isr(void *dummy)
 {
 	ms_busy = -1;
 	wake_up(&ms_wait);
@@ -560,7 +560,7 @@ static unsigned long fd_get_drive_id(int drive)
 	return (id);
 }
 
-static irqreturn_t fd_block_done(int irq, void *dummy)
+static irqreturn_t fd_block_done(void *dummy)
 {
 	if (block_flag)
 		custom.dsklen = 0x4000;
diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
index 94268c7..ccae320 100644
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -342,7 +342,7 @@ static void fd_select_drive( int drive );
 static void fd_deselect( void );
 static void fd_motor_off_timer( unsigned long dummy );
 static void check_change( unsigned long dummy );
-static irqreturn_t floppy_irq (int irq, void *dummy);
+static irqreturn_t floppy_irq (void *dummy);
 static void fd_error( void );
 static int do_format(int drive, int type, struct atari_format_descr *desc);
 static void do_fd_action( int drive );
@@ -573,7 +573,7 @@ static inline void copy_buffer(void *from, void *to)
 
 static void (*FloppyIRQHandler)( int status ) = NULL;
 
-static irqreturn_t floppy_irq (int irq, void *dummy)
+static irqreturn_t floppy_irq (void *dummy)
 {
 	unsigned char status;
 	void (*handler)( int );
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 7c2cfde..212d9a3 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -140,7 +140,7 @@ static struct board_type products[] = {
 static ctlr_info_t *hba[MAX_CTLR];
 
 static void do_cciss_request(struct request_queue *q);
-static irqreturn_t do_cciss_intr(int irq, void *dev_id);
+static irqreturn_t do_cciss_intr(void *dev_id);
 static int cciss_open(struct inode *inode, struct file *filep);
 static int cciss_release(struct inode *inode, struct file *filep);
 static int cciss_ioctl(struct inode *inode, struct file *filep,
@@ -2301,7 +2301,7 @@ static int sendcmd(__u8 cmd, int ctlr, void *buff, size_t size, unsigned int use
 #ifdef CONFIG_CISS_SCSI_TAPE
 	/* if we saved some commands for later, process them now. */
 	if (info_p->scsi_rejects.ncompletions > 0)
-		do_cciss_intr(0, info_p);
+		do_cciss_intr(info_p);
 #endif
 	cmd_free(info_p, c, 1);
 	return status;
@@ -2733,7 +2733,7 @@ static inline long interrupt_not_for_us(ctlr_info_t *h)
 #endif
 }
 
-static irqreturn_t do_cciss_intr(int irq, void *dev_id)
+static irqreturn_t do_cciss_intr(void *dev_id)
 {
 	ctlr_info_t *h = dev_id;
 	CommandList_struct *c;
diff --git a/drivers/block/cpqarray.c b/drivers/block/cpqarray.c
index 568603d..1dd7d83 100644
--- a/drivers/block/cpqarray.c
+++ b/drivers/block/cpqarray.c
@@ -169,7 +169,7 @@ static inline cmdlist_t *removeQ(cmdlist_t **Qptr, cmdlist_t *c);
 static inline void complete_buffers(struct bio *bio, int ok);
 static inline void complete_command(cmdlist_t *cmd, int timeout);
 
-static irqreturn_t do_ida_intr(int irq, void *dev_id);
+static irqreturn_t do_ida_intr(void *dev_id);
 static void ida_timer(unsigned long tdata);
 static int ida_revalidate(struct gendisk *disk);
 static int revalidate_allvol(ctlr_info_t *host);
@@ -1047,7 +1047,7 @@ static inline void complete_command(cmdlist_t *cmd, int timeout)
  *  Find the command on the completion queue, remove it, tell the OS and
  *  try to queue up more IO
  */
-static irqreturn_t do_ida_intr(int irq, void *dev_id)
+static irqreturn_t do_ida_intr(void *dev_id)
 {
 	ctlr_info_t *h = dev_id;
 	cmdlist_t *c;
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 639ed14..dfb0858 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -220,7 +220,7 @@ static DEFINE_SPINLOCK(floppy_lock);
 static struct completion device_release;
 
 static unsigned short virtual_dma_port = 0x3f0;
-irqreturn_t floppy_interrupt(int irq, void *dev_id);
+irqreturn_t floppy_interrupt(void *dev_id);
 static int set_dor(int fdc, char mask, char data);
 
 #define K_64	0x10000		/* 64KB */
@@ -1734,7 +1734,7 @@ static void print_result(char *message, int inr)
 }
 
 /* interrupt handler. Note that this can be called externally on the Sparc */
-irqreturn_t floppy_interrupt(int irq, void *dev_id)
+irqreturn_t floppy_interrupt(void *dev_id)
 {
 	int do_print;
 	unsigned long f;
diff --git a/drivers/block/lguest_blk.c b/drivers/block/lguest_blk.c
index fa8e423..2d5b4b4 100644
--- a/drivers/block/lguest_blk.c
+++ b/drivers/block/lguest_blk.c
@@ -94,7 +94,7 @@ static void end_entire_request(struct request *req, int uptodate)
 
 /*D:490 This is the interrupt handler, called when a block read or write has
  * been completed for us. */
-static irqreturn_t lgb_irq(int irq, void *_bd)
+static irqreturn_t lgb_irq(void *_bd)
 {
 	/* We handed our "struct blockdev" as the argument to request_irq(), so
 	 * it is passed through to us here.  This tells us which device we're
diff --git a/drivers/block/ps2esdi.c b/drivers/block/ps2esdi.c
index 3c796e2..ec99308 100644
--- a/drivers/block/ps2esdi.c
+++ b/drivers/block/ps2esdi.c
@@ -75,7 +75,7 @@ static int ps2esdi_out_cmd_blk(u_short * cmd_blk);
 
 static void ps2esdi_prep_dma(char *buffer, u_short length, u_char dma_xmode);
 
-static irqreturn_t ps2esdi_interrupt_handler(int irq, void *dev_id);
+static irqreturn_t ps2esdi_interrupt_handler(void *dev_id);
 static void (*current_int_handler) (u_int) = NULL;
 static void ps2esdi_normal_interrupt_handler(u_int);
 static void ps2esdi_initial_reset_int_handler(u_int);
@@ -686,7 +686,7 @@ static void ps2esdi_prep_dma(char *buffer, u_short length, u_char dma_xmode)
 
 
 
-static irqreturn_t ps2esdi_interrupt_handler(int irq, void *dev_id)
+static irqreturn_t ps2esdi_interrupt_handler(void *dev_id)
 {
 	u_int int_ret_code;
 
diff --git a/drivers/block/swim3.c b/drivers/block/swim3.c
index b4e462f..d8c6f2a 100644
--- a/drivers/block/swim3.c
+++ b/drivers/block/swim3.c
@@ -238,8 +238,8 @@ static void scan_timeout(unsigned long data);
 static void seek_timeout(unsigned long data);
 static void settle_timeout(unsigned long data);
 static void xfer_timeout(unsigned long data);
-static irqreturn_t swim3_interrupt(int irq, void *dev_id);
-/*static void fd_dma_interrupt(int irq, void *dev_id);*/
+static irqreturn_t swim3_interrupt(void *dev_id);
+/*static void fd_dma_interrupt(void *dev_id);*/
 static int grab_drive(struct floppy_state *fs, enum swim_state state,
 		      int interruptible);
 static void release_drive(struct floppy_state *fs);
@@ -624,7 +624,7 @@ static void xfer_timeout(unsigned long data)
 	start_request(fs);
 }
 
-static irqreturn_t swim3_interrupt(int irq, void *dev_id)
+static irqreturn_t swim3_interrupt(void *dev_id)
 {
 	struct floppy_state *fs = (struct floppy_state *) dev_id;
 	struct swim3 __iomem *sw = fs->swim3;
@@ -777,7 +777,7 @@ static irqreturn_t swim3_interrupt(int irq, void *dev_id)
 }
 
 /*
-static void fd_dma_interrupt(int irq, void *dev_id)
+static void fd_dma_interrupt(void *dev_id)
 {
 }
 */
diff --git a/drivers/block/sx8.c b/drivers/block/sx8.c
index 402209f..309597f 100644
--- a/drivers/block/sx8.c
+++ b/drivers/block/sx8.c
@@ -1200,7 +1200,7 @@ static inline void carm_handle_responses(struct carm_host *host)
 	host->resp_idx += work;
 }
 
-static irqreturn_t carm_interrupt(int irq, void *__host)
+static irqreturn_t carm_interrupt(void *__host)
 {
 	struct carm_host *host = __host;
 	void __iomem *mmio;
diff --git a/drivers/block/umem.c b/drivers/block/umem.c
index 99806f9..e9fdb4f 100644
--- a/drivers/block/umem.c
+++ b/drivers/block/umem.c
@@ -570,7 +570,7 @@ static int mm_make_request(struct request_queue *q, struct bio *bio)
 --                              mm_interrupt
 -----------------------------------------------------------------------------------
 */
-static irqreturn_t mm_interrupt(int irq, void *__card)
+static irqreturn_t mm_interrupt(void *__card)
 {
 	struct cardinfo *card = (struct cardinfo *) __card;
 	unsigned int dma_status;
diff --git a/drivers/block/xd.c b/drivers/block/xd.c
index 624d30f..aa19ae6 100644
--- a/drivers/block/xd.c
+++ b/drivers/block/xd.c
@@ -462,7 +462,7 @@ static void xd_recalibrate (u_char drive)
 }
 
 /* xd_interrupt_handler: interrupt service routine */
-static irqreturn_t xd_interrupt_handler(int irq, void *dev_id)
+static irqreturn_t xd_interrupt_handler(void *dev_id)
 {
 	if (inb(XD_STATUS) & STAT_INTERRUPT) {							/* check if it was our device */
 #ifdef DEBUG_OTHER
diff --git a/drivers/block/xd.h b/drivers/block/xd.h
index cffd44a..4f43623 100644
--- a/drivers/block/xd.h
+++ b/drivers/block/xd.h
@@ -109,7 +109,7 @@ static int xd_ioctl (struct inode *inode,struct file *file,unsigned int cmd,unsi
 static int xd_readwrite (u_char operation,XD_INFO *disk,char *buffer,u_int block,u_int count);
 static void xd_recalibrate (u_char drive);
 
-static irqreturn_t xd_interrupt_handler(int irq, void *dev_id);
+static irqreturn_t xd_interrupt_handler(void *dev_id);
 static u_char xd_setup_dma (u_char opcode,u_char *buffer,u_int count);
 static u_char *xd_build (u_char *cmdblk,u_char command,u_char drive,u_char head,u_short cylinder,u_char sector,u_char count,u_char control);
 static void xd_watchdog (unsigned long unused);
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 2bdebcb..7743400 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -445,7 +445,7 @@ static void blkif_completion(struct blk_shadow *s)
 		gnttab_end_foreign_access(s->req.seg[i].gref, 0, 0UL);
 }
 
-static irqreturn_t blkif_interrupt(int irq, void *dev_id)
+static irqreturn_t blkif_interrupt(void *dev_id)
 {
 	struct request *req;
 	struct blkif_response *bret;
diff --git a/drivers/char/amiserial.c b/drivers/char/amiserial.c
index 3d468f5..d57f2e2 100644
--- a/drivers/char/amiserial.c
+++ b/drivers/char/amiserial.c
@@ -447,7 +447,7 @@ static void check_modem_status(struct async_struct *info)
 	}
 }
 
-static irqreturn_t ser_vbl_int( int irq, void *data)
+static irqreturn_t ser_vbl_int(void *data)
 {
         /* vbl is just a periodic interrupt we tie into to update modem status */
 	struct async_struct * info = IRQ_ports;
@@ -460,7 +460,7 @@ static irqreturn_t ser_vbl_int( int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t ser_rx_int(int irq, void *dev_id)
+static irqreturn_t ser_rx_int(void *dev_id)
 {
 	struct async_struct * info;
 
@@ -480,7 +480,7 @@ static irqreturn_t ser_rx_int(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t ser_tx_int(int irq, void *dev_id)
+static irqreturn_t ser_tx_int(void *dev_id)
 {
 	struct async_struct * info;
 
diff --git a/drivers/char/applicom.c b/drivers/char/applicom.c
index 1f0b752..6f03607 100644
--- a/drivers/char/applicom.c
+++ b/drivers/char/applicom.c
@@ -110,7 +110,7 @@ static ssize_t ac_read (struct file *, char __user *, size_t, loff_t *);
 static ssize_t ac_write (struct file *, const char __user *, size_t, loff_t *);
 static int ac_ioctl(struct inode *, struct file *, unsigned int,
 		    unsigned long);
-static irqreturn_t ac_interrupt(int, void *);
+static irqreturn_t ac_interrupt(void *);
 
 static const struct file_operations ac_fops = {
 	.owner = THIS_MODULE,
@@ -617,7 +617,7 @@ static ssize_t ac_read (struct file *filp, char __user *buf, size_t count, loff_
 	} 
 }
 
-static irqreturn_t ac_interrupt(int vec, void *dev_instance)
+static irqreturn_t ac_interrupt(void *dev_instance)
 {
 	unsigned int i;
 	unsigned int FlagInt;
diff --git a/drivers/char/drm/drm_os_linux.h b/drivers/char/drm/drm_os_linux.h
index 114e54e..cda69c8 100644
--- a/drivers/char/drm/drm_os_linux.h
+++ b/drivers/char/drm/drm_os_linux.h
@@ -30,7 +30,7 @@
 #define DRM_MEMORYBARRIER()		mb()
 
 /** IRQ handler arguments and return type and values */
-#define DRM_IRQ_ARGS		int irq, void *arg
+#define DRM_IRQ_ARGS		void *arg
 
 /** AGP types */
 #if __OS_HAS_AGP
diff --git a/drivers/char/esp.c b/drivers/char/esp.c
index 2e7ae42..9ac4eb5 100644
--- a/drivers/char/esp.c
+++ b/drivers/char/esp.c
@@ -615,7 +615,7 @@ static inline void check_modem_status(struct esp_struct *info)
 /*
  * This is the serial driver's interrupt routine
  */
-static irqreturn_t rs_interrupt_single(int irq, void *dev_id)
+static irqreturn_t rs_interrupt_single(void *dev_id)
 {
 	struct esp_struct * info;
 	unsigned err_status;
diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index 4c16778..a51b853 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -140,7 +140,7 @@ static inline void writeq(unsigned long long v, void __iomem *addr)
 }
 #endif
 
-static irqreturn_t hpet_interrupt(int irq, void *data)
+static irqreturn_t hpet_interrupt(void *data)
 {
 	struct hpet_dev *devp;
 	unsigned long isr;
diff --git a/drivers/char/hvc_console.c b/drivers/char/hvc_console.c
index 8252f86..4c2e0f5 100644
--- a/drivers/char/hvc_console.c
+++ b/drivers/char/hvc_console.c
@@ -295,7 +295,7 @@ static int hvc_poll(struct hvc_struct *hp);
  * NOTE: This API isn't used if the console adapter doesn't support interrupts.
  * In this case the console is poll driven.
  */
-static irqreturn_t hvc_handle_interrupt(int irq, void *dev_instance)
+static irqreturn_t hvc_handle_interrupt(void *dev_instance)
 {
 	/* if hvc_poll request a repoll, then kick the hvcd thread */
 	if (hvc_poll(dev_instance))
diff --git a/drivers/char/hvcs.c b/drivers/char/hvcs.c
index 69d8866..19c99bc 100644
--- a/drivers/char/hvcs.c
+++ b/drivers/char/hvcs.c
@@ -315,7 +315,7 @@ static DEFINE_SPINLOCK(hvcs_structs_lock);
 
 static void hvcs_unthrottle(struct tty_struct *tty);
 static void hvcs_throttle(struct tty_struct *tty);
-static irqreturn_t hvcs_handle_interrupt(int irq, void *dev_instance);
+static irqreturn_t hvcs_handle_interrupt(void *dev_instance);
 
 static int hvcs_write(struct tty_struct *tty,
 		const unsigned char *buf, int count);
@@ -549,7 +549,7 @@ static void hvcs_throttle(struct tty_struct *tty)
  * handler taking any further interrupts because they are disabled which means
  * the hvcs_struct will always be valid in this handler.
  */
-static irqreturn_t hvcs_handle_interrupt(int irq, void *dev_instance)
+static irqreturn_t hvcs_handle_interrupt(void *dev_instance)
 {
 	struct hvcs_struct *hvcsd = dev_instance;
 
diff --git a/drivers/char/hvsi.c b/drivers/char/hvsi.c
index d5a752d..069264f 100644
--- a/drivers/char/hvsi.c
+++ b/drivers/char/hvsi.c
@@ -554,7 +554,7 @@ static void hvsi_send_overflow(struct hvsi_struct *hp)
  * must get all pending data because we only get an irq on empty->non-empty
  * transition
  */
-static irqreturn_t hvsi_interrupt(int irq, void *arg)
+static irqreturn_t hvsi_interrupt(void *arg)
 {
 	struct hvsi_struct *hp = (struct hvsi_struct *)arg;
 	struct tty_struct *flip;
diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 4f560d0..b0c21dc 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -969,7 +969,7 @@ static void smi_timeout(unsigned long data)
 	add_timer(&(smi_info->si_timer));
 }
 
-static irqreturn_t si_irq_handler(int irq, void *data)
+static irqreturn_t si_irq_handler(void *data)
 {
 	struct smi_info *smi_info = data;
 	unsigned long   flags;
@@ -992,14 +992,14 @@ static irqreturn_t si_irq_handler(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t si_bt_irq_handler(int irq, void *data)
+static irqreturn_t si_bt_irq_handler(void *data)
 {
 	struct smi_info *smi_info = data;
 	/* We need to clear the IRQ flag for the BT interface. */
 	smi_info->io.outputb(&smi_info->io, IPMI_BT_INTMASK_REG,
 			     IPMI_BT_INTMASK_CLEAR_IRQ_BIT
 			     | IPMI_BT_INTMASK_ENABLE_IRQ_BIT);
-	return si_irq_handler(irq, data);
+	return si_irq_handler(data);
 }
 
 static int smi_start_processing(void       *send_info,
diff --git a/drivers/char/isicom.c b/drivers/char/isicom.c
index 85d596a..897f843 100644
--- a/drivers/char/isicom.c
+++ b/drivers/char/isicom.c
@@ -506,7 +506,7 @@ sched_again:
  *	Main interrupt handler routine
  */
 
-static irqreturn_t isicom_interrupt(int irq, void *dev_id)
+static irqreturn_t isicom_interrupt(void *dev_id)
 {
 	struct isi_board *card = dev_id;
 	struct isi_port *port;
diff --git a/drivers/char/mbcs.c b/drivers/char/mbcs.c
index 3c5802a..9347b92 100644
--- a/drivers/char/mbcs.c
+++ b/drivers/char/mbcs.c
@@ -513,12 +513,11 @@ static int mbcs_gscr_mmap(struct file *fp, struct vm_area_struct *vma)
 
 /**
  * mbcs_completion_intr_handler - Primary completion handler.
- * @irq: irq
  * @arg: soft struct for device
  *
  */
 static irqreturn_t
-mbcs_completion_intr_handler(int irq, void *arg)
+mbcs_completion_intr_handler(void *arg)
 {
 	struct mbcs_soft *soft = (struct mbcs_soft *)arg;
 	void *mmr_base;
diff --git a/drivers/char/mmtimer.c b/drivers/char/mmtimer.c
index e60a74c..0792019 100644
--- a/drivers/char/mmtimer.c
+++ b/drivers/char/mmtimer.c
@@ -421,7 +421,6 @@ static int inline reschedule_periodic_timer(mmtimer_t *x)
 
 /**
  * mmtimer_interrupt - timer interrupt handler
- * @irq: irq received
  * @dev_id: device the irq came from
  *
  * Called when one of the comarators matches the counter, This
@@ -433,7 +432,7 @@ static int inline reschedule_periodic_timer(mmtimer_t *x)
  * registers.
  */
 static irqreturn_t
-mmtimer_interrupt(int irq, void *dev_id)
+mmtimer_interrupt(void *dev_id)
 {
 	int i;
 	unsigned long expires = 0;
diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
index 661aca0..7ba3eec 100644
--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -401,7 +401,7 @@ static void mxser_stop(struct tty_struct *);
 static void mxser_start(struct tty_struct *);
 static void mxser_hangup(struct tty_struct *);
 static void mxser_rs_break(struct tty_struct *, int);
-static irqreturn_t mxser_interrupt(int, void *);
+static irqreturn_t mxser_interrupt(void *);
 static void mxser_receive_chars(struct mxser_struct *, int *);
 static void mxser_transmit_chars(struct mxser_struct *);
 static void mxser_check_modem_status(struct mxser_struct *, int);
@@ -1890,7 +1890,7 @@ static void mxser_rs_break(struct tty_struct *tty, int break_state)
 /*
  * This is the serial driver's generic interrupt routine
  */
-static irqreturn_t mxser_interrupt(int irq, void *dev_id)
+static irqreturn_t mxser_interrupt(void *dev_id)
 {
 	int status, iir, i;
 	struct mxser_struct *info;
diff --git a/drivers/char/mxser_new.c b/drivers/char/mxser_new.c
index 854dbf5..0e0ce9a 100644
--- a/drivers/char/mxser_new.c
+++ b/drivers/char/mxser_new.c
@@ -2264,7 +2264,7 @@ static void mxser_transmit_chars(struct mxser_port *port)
 /*
  * This is the serial driver's generic interrupt routine
  */
-static irqreturn_t mxser_interrupt(int irq, void *dev_id)
+static irqreturn_t mxser_interrupt(void *dev_id)
 {
 	int status, iir, i;
 	struct mxser_board *brd = NULL;
diff --git a/drivers/char/nwbutton.c b/drivers/char/nwbutton.c
index 2604246..20049da 100644
--- a/drivers/char/nwbutton.c
+++ b/drivers/char/nwbutton.c
@@ -147,7 +147,7 @@ static void button_sequence_finished (unsigned long parameters)
  *  increments the counter.
  */ 
 
-static irqreturn_t button_handler (int irq, void *dev_id)
+static irqreturn_t button_handler (void *dev_id)
 {
 	button_press_count++;
 	mod_timer(&button_timer, jiffies + bdelay);
diff --git a/drivers/char/nwbutton.h b/drivers/char/nwbutton.h
index c3ebc16..39e2468 100644
--- a/drivers/char/nwbutton.h
+++ b/drivers/char/nwbutton.h
@@ -25,7 +25,7 @@ struct button_callback {
 /* Function prototypes: */
 
 static void button_sequence_finished (unsigned long parameters);
-static irqreturn_t button_handler (int irq, void *dev_id);
+static irqreturn_t button_handler (void *dev_id);
 int button_init (void);
 int button_add_callback (void (*callback) (void), int count);
 int button_del_callback (void (*callback) (void));
diff --git a/drivers/char/rtc.c b/drivers/char/rtc.c
index ec6b65e..ff7bc27 100644
--- a/drivers/char/rtc.c
+++ b/drivers/char/rtc.c
@@ -111,13 +111,13 @@ static int rtc_has_irq = 1;
 #define hpet_rtc_timer_init() 			do { } while (0)
 #define hpet_rtc_dropped_irq() 			0
 #ifdef RTC_IRQ
-static irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id)
+static irqreturn_t hpet_rtc_interrupt(void *dev_id)
 {
 	return 0;
 }
 #endif
 #else
-extern irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id);
+extern irqreturn_t hpet_rtc_interrupt(void *dev_id);
 #endif
 
 /*
@@ -233,7 +233,7 @@ static inline unsigned char rtc_is_updating(void)
  *	(See ./arch/XXXX/kernel/time.c for the set_rtc_mmss() function.)
  */
 
-irqreturn_t rtc_interrupt(int irq, void *dev_id)
+irqreturn_t rtc_interrupt(void *dev_id)
 {
 	/*
 	 *	Can be an alarm interrupt, update complete interrupt,
diff --git a/drivers/char/ser_a2232.c b/drivers/char/ser_a2232.c
index 3c86914..0be33fc 100644
--- a/drivers/char/ser_a2232.c
+++ b/drivers/char/ser_a2232.c
@@ -110,7 +110,7 @@
 
 /***************************** Prototypes ***************************/
 /* The interrupt service routine */
-static irqreturn_t a2232_vbl_inter(int irq, void *data);
+static irqreturn_t a2232_vbl_inter(void *data);
 /* Initialize the port structures */
 static void a2232_init_portstructs(void);
 /* Initialize and register TTY drivers. */
@@ -503,7 +503,7 @@ static int  a2232_open(struct tty_struct * tty, struct file * filp)
 }
 /*** END OF FUNCTIONS EXPECTED BY TTY DRIVER STRUCTS ***/
 
-static irqreturn_t a2232_vbl_inter(int irq, void *data)
+static irqreturn_t a2232_vbl_inter(void *data)
 {
 #if A2232_IOBUFLEN != 256
 #error "Re-Implement a2232_vbl_inter()!"
diff --git a/drivers/char/serial167.c b/drivers/char/serial167.c
index f1497ce..d481b02 100644
--- a/drivers/char/serial167.c
+++ b/drivers/char/serial167.c
@@ -375,7 +375,7 @@ static inline void cy_sched_event(struct cyclades_port *info, int event)
    whenever the card wants its hand held--chars
    received, out buffer empty, modem change, etc.
  */
-static irqreturn_t cd2401_rxerr_interrupt(int irq, void *dev_id)
+static irqreturn_t cd2401_rxerr_interrupt(void *dev_id)
 {
 	struct tty_struct *tty;
 	struct cyclades_port *info;
@@ -517,7 +517,7 @@ static irqreturn_t cd2401_modem_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }				/* cy_modem_interrupt */
 
-static irqreturn_t cd2401_tx_interrupt(int irq, void *dev_id)
+static irqreturn_t cd2401_tx_interrupt(void *dev_id)
 {
 	struct cyclades_port *info;
 	volatile unsigned char *base_addr = (unsigned char *)BASE_ADDR;
@@ -636,7 +636,7 @@ static irqreturn_t cd2401_tx_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }				/* cy_tx_interrupt */
 
-static irqreturn_t cd2401_rx_interrupt(int irq, void *dev_id)
+static irqreturn_t cd2401_rx_interrupt(void *dev_id)
 {
 	struct tty_struct *tty;
 	struct cyclades_port *info;
diff --git a/drivers/char/snsc.c b/drivers/char/snsc.c
index b9c1dba..e0d94c9 100644
--- a/drivers/char/snsc.c
+++ b/drivers/char/snsc.c
@@ -34,7 +34,7 @@
 #define SCDRV_TIMEOUT	1000
 
 static irqreturn_t
-scdrv_interrupt(int irq, void *subch_data)
+scdrv_interrupt(void *subch_data)
 {
 	struct subch_data_s *sd = subch_data;
 	unsigned long flags;
diff --git a/drivers/char/snsc_event.c b/drivers/char/snsc_event.c
index 1b75b0b..44e0297 100644
--- a/drivers/char/snsc_event.c
+++ b/drivers/char/snsc_event.c
@@ -36,7 +36,7 @@ DECLARE_TASKLET(sn_sysctl_event, scdrv_event, 0);
  * destination.
  */
 static irqreturn_t
-scdrv_event_interrupt(int irq, void *subch_data)
+scdrv_event_interrupt(void *subch_data)
 {
 	struct subch_data_s *sd = subch_data;
 	unsigned long flags;
diff --git a/drivers/char/sonypi.c b/drivers/char/sonypi.c
index 8598585..334e9ec 100644
--- a/drivers/char/sonypi.c
+++ b/drivers/char/sonypi.c
@@ -832,7 +832,7 @@ static void sonypi_report_input_event(u8 event)
 }
 
 /* Interrupt handler: some event is available */
-static irqreturn_t sonypi_irq(int irq, void *dev_id)
+static irqreturn_t sonypi_irq(void *dev_id)
 {
 	u8 v1, v2, event = 0;
 	int i, j;
diff --git a/drivers/char/tlclk.c b/drivers/char/tlclk.c
index 35e5803..4a1e647 100644
--- a/drivers/char/tlclk.c
+++ b/drivers/char/tlclk.c
@@ -193,7 +193,7 @@ static DEFINE_SPINLOCK(event_lock);
 
 static int tlclk_major = TLCLK_MAJOR;
 
-static irqreturn_t tlclk_interrupt(int irq, void *dev_id);
+static irqreturn_t tlclk_interrupt(void *dev_id);
 
 static DECLARE_WAIT_QUEUE_HEAD(wq);
 
@@ -864,7 +864,7 @@ static void switchover_timeout(unsigned long data)
 	wake_up(&wq);
 }
 
-static irqreturn_t tlclk_interrupt(int irq, void *dev_id)
+static irqreturn_t tlclk_interrupt(void *dev_id)
 {
 	unsigned long flags;
 
diff --git a/drivers/char/vme_scc.c b/drivers/char/vme_scc.c
index e122a0e..abca6a4 100644
--- a/drivers/char/vme_scc.c
+++ b/drivers/char/vme_scc.c
@@ -80,10 +80,10 @@ static int scc_ioctl(struct tty_struct * tty, struct file * filp,
                      unsigned int cmd, unsigned long arg);
 static void scc_throttle(struct tty_struct *tty);
 static void scc_unthrottle(struct tty_struct *tty);
-static irqreturn_t scc_tx_int(int irq, void *data);
-static irqreturn_t scc_rx_int(int irq, void *data);
-static irqreturn_t scc_stat_int(int irq, void *data);
-static irqreturn_t scc_spcond_int(int irq, void *data);
+static irqreturn_t scc_tx_int(void *data);
+static irqreturn_t scc_rx_int(void *data);
+static irqreturn_t scc_stat_int(void *data);
+static irqreturn_t scc_spcond_int(void *data);
 static void scc_setsignals(struct scc_port *port, int dtr, int rts);
 static void scc_break_ctl(struct tty_struct *tty, int break_state);
 
@@ -420,7 +420,7 @@ module_init(vme_scc_init);
  * Interrupt handlers
  *--------------------------------------------------------------------------*/
 
-static irqreturn_t scc_rx_int(int irq, void *data)
+static irqreturn_t scc_rx_int(void *data)
 {
 	unsigned char	ch;
 	struct scc_port *port = data;
@@ -452,7 +452,7 @@ static irqreturn_t scc_rx_int(int irq, void *data)
 }
 
 
-static irqreturn_t scc_spcond_int(int irq, void *data)
+static irqreturn_t scc_spcond_int(void *data)
 {
 	struct scc_port *port = data;
 	struct tty_struct *tty = port->gs.tty;
@@ -497,7 +497,7 @@ static irqreturn_t scc_spcond_int(int irq, void *data)
 }
 
 
-static irqreturn_t scc_tx_int(int irq, void *data)
+static irqreturn_t scc_tx_int(void *data)
 {
 	struct scc_port *port = data;
 	SCC_ACCESS_INIT(port);
@@ -539,7 +539,7 @@ static irqreturn_t scc_tx_int(int irq, void *data)
 }
 
 
-static irqreturn_t scc_stat_int(int irq, void *data)
+static irqreturn_t scc_stat_int(void *data)
 {
 	struct scc_port *port = data;
 	unsigned channel = port->channel;
diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
index 7e4a785..0f4f5ab 100644
--- a/drivers/dma/ioat_dma.c
+++ b/drivers/dma/ioat_dma.c
@@ -61,7 +61,7 @@ static inline struct ioat_dma_chan *ioat_lookup_chan_by_index(
  * @irq: interrupt id
  * @data: interrupt data
  */
-static irqreturn_t ioat_dma_do_interrupt(int irq, void *data)
+static irqreturn_t ioat_dma_do_interrupt(void *data)
 {
 	struct ioatdma_device *instance = data;
 	struct ioat_dma_chan *ioat_chan;
@@ -94,7 +94,7 @@ static irqreturn_t ioat_dma_do_interrupt(int irq, void *data)
  * @irq: interrupt id
  * @data: interrupt data
  */
-static irqreturn_t ioat_dma_do_interrupt_msix(int irq, void *data)
+static irqreturn_t ioat_dma_do_interrupt_msix(void *data)
 {
 	struct ioat_dma_chan *ioat_chan = data;
 
diff --git a/drivers/fc4/soc.c b/drivers/fc4/soc.c
index d517734..d163ce5 100644
--- a/drivers/fc4/soc.c
+++ b/drivers/fc4/soc.c
@@ -333,7 +333,7 @@ update_out:
 	}
 }
 
-static irqreturn_t soc_intr(int irq, void *dev_id)
+static irqreturn_t soc_intr(void *dev_id)
 {
 	u32 cmd;
 	unsigned long flags;
diff --git a/drivers/fc4/socal.c b/drivers/fc4/socal.c
index c903ebf..9dd04ca 100644
--- a/drivers/fc4/socal.c
+++ b/drivers/fc4/socal.c
@@ -403,7 +403,7 @@ update_out:
 	}
 }
 
-static irqreturn_t socal_intr(int irq, void *dev_id)
+static irqreturn_t socal_intr(void *dev_id)
 {
 	u32 cmd;
 	unsigned long flags;
diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
index 2f307c4..6537c18 100644
--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -1012,7 +1012,7 @@ static void bus_reset_tasklet(unsigned long data)
 				 self_id_count, ohci->self_id_buffer);
 }
 
-static irqreturn_t irq_handler(int irq, void *data)
+static irqreturn_t irq_handler(void *data)
 {
 	struct fw_ohci *ohci = data;
 	u32 event, iso_event, cycle_time;
diff --git a/drivers/i2c/busses/i2c-elektor.c b/drivers/i2c/busses/i2c-elektor.c
index 804f0a5..9c88be5 100644
--- a/drivers/i2c/busses/i2c-elektor.c
+++ b/drivers/i2c/busses/i2c-elektor.c
@@ -132,7 +132,7 @@ static void pcf_isa_waitforpin(void) {
 }
 
 
-static irqreturn_t pcf_isa_handler(int this_irq, void *dev_id) {
+static irqreturn_t pcf_isa_handler(void *dev_id) {
 	spin_lock(&lock);
 	pcf_pending = 1;
 	spin_unlock(&lock);
diff --git a/drivers/i2c/busses/i2c-ibm_iic.c b/drivers/i2c/busses/i2c-ibm_iic.c
index e08baca..0d1ae77 100644
--- a/drivers/i2c/busses/i2c-ibm_iic.c
+++ b/drivers/i2c/busses/i2c-ibm_iic.c
@@ -320,7 +320,7 @@ err:
 /*
  * IIC interrupt handler
  */
-static irqreturn_t iic_handler(int irq, void *dev_id)
+static irqreturn_t iic_handler(void *dev_id)
 {
 	struct ibm_iic_private* dev = (struct ibm_iic_private*)dev_id;
 	volatile struct iic_regs __iomem *iic = dev->vaddr;
diff --git a/drivers/i2c/busses/i2c-iop3xx.c b/drivers/i2c/busses/i2c-iop3xx.c
index c70146e..786e844 100644
--- a/drivers/i2c/busses/i2c-iop3xx.c
+++ b/drivers/i2c/busses/i2c-iop3xx.c
@@ -119,7 +119,7 @@ iop3xx_i2c_transaction_cleanup(struct i2c_algo_iop3xx_data *iop3xx_adap)
  * Then it passes the SR flags of interest to BH via adap data
  */
 static irqreturn_t 
-iop3xx_i2c_irq_handler(int this_irq, void *dev_id) 
+iop3xx_i2c_irq_handler(void *dev_id) 
 {
 	struct i2c_algo_iop3xx_data *iop3xx_adap = dev_id;
 	u32 sr = __raw_readl(iop3xx_adap->ioaddr + SR_OFFSET);
diff --git a/drivers/i2c/busses/i2c-mpc.c b/drivers/i2c/busses/i2c-mpc.c
index d8de4ac..311f76d 100644
--- a/drivers/i2c/busses/i2c-mpc.c
+++ b/drivers/i2c/busses/i2c-mpc.c
@@ -62,7 +62,7 @@ static __inline__ void writeccr(struct mpc_i2c *i2c, u32 x)
 	writeb(x, i2c->base + MPC_I2C_CR);
 }
 
-static irqreturn_t mpc_i2c_isr(int irq, void *dev_id)
+static irqreturn_t mpc_i2c_isr(void *dev_id)
 {
 	struct mpc_i2c *i2c = dev_id;
 	if (readb(i2c->base + MPC_I2C_SR) & CSR_MIF) {
diff --git a/drivers/i2c/busses/i2c-mv64xxx.c b/drivers/i2c/busses/i2c-mv64xxx.c
index bb7bf68..088cfb1 100644
--- a/drivers/i2c/busses/i2c-mv64xxx.c
+++ b/drivers/i2c/busses/i2c-mv64xxx.c
@@ -293,7 +293,7 @@ mv64xxx_i2c_do_action(struct mv64xxx_i2c_data *drv_data)
 }
 
 static int
-mv64xxx_i2c_intr(int irq, void *dev_id)
+mv64xxx_i2c_intr(void *dev_id)
 {
 	struct mv64xxx_i2c_data	*drv_data = dev_id;
 	unsigned long	flags;
diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-ocores.c
index e417c2c..32bc101 100644
--- a/drivers/i2c/busses/i2c-ocores.c
+++ b/drivers/i2c/busses/i2c-ocores.c
@@ -142,7 +142,7 @@ static void ocores_process(struct ocores_i2c *i2c)
 	}
 }
 
-static irqreturn_t ocores_isr(int irq, void *dev_id)
+static irqreturn_t ocores_isr(void *dev_id)
 {
 	struct ocores_i2c *i2c = dev_id;
 
diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index e471e3b..0b0924b 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -400,7 +400,7 @@ omap_i2c_ack_stat(struct omap_i2c_dev *dev, u16 stat)
 }
 
 static irqreturn_t
-omap_i2c_rev1_isr(int this_irq, void *dev_id)
+omap_i2c_rev1_isr(void *dev_id)
 {
 	struct omap_i2c_dev *dev = dev_id;
 	u16 iv, w;
diff --git a/drivers/i2c/busses/i2c-pca-isa.c b/drivers/i2c/busses/i2c-pca-isa.c
index 5161aaf..48ee444 100644
--- a/drivers/i2c/busses/i2c-pca-isa.c
+++ b/drivers/i2c/busses/i2c-pca-isa.c
@@ -99,7 +99,7 @@ static int pca_isa_waitforinterrupt(struct i2c_algo_pca_data *adap)
 	return ret;
 }
 
-static irqreturn_t pca_handler(int this_irq, void *dev_id) {
+static irqreturn_t pca_handler(void *dev_id) {
 	wake_up_interruptible(&pca_wait);
 	return IRQ_HANDLED;
 }
diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
index 00fad11..45bf486 100644
--- a/drivers/i2c/busses/i2c-pxa.c
+++ b/drivers/i2c/busses/i2c-pxa.c
@@ -759,7 +759,7 @@ static void i2c_pxa_irq_rxfull(struct pxa_i2c *i2c, u32 isr)
 	writel(icr, _ICR(i2c));
 }
 
-static irqreturn_t i2c_pxa_handler(int this_irq, void *dev_id)
+static irqreturn_t i2c_pxa_handler(void *dev_id)
 {
 	struct pxa_i2c *i2c = dev_id;
 	u32 isr = readl(_ISR(i2c));
diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index c44ada5..b962e38 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -435,7 +435,7 @@ static int i2s_s3c_irq_nextbyte(struct s3c24xx_i2c *i2c, unsigned long iicstat)
  * top level IRQ servicing routine
 */
 
-static irqreturn_t s3c24xx_i2c_irq(int irqno, void *dev_id)
+static irqreturn_t s3c24xx_i2c_irq(void *dev_id)
 {
 	struct s3c24xx_i2c *i2c = dev_id;
 	unsigned long status;
diff --git a/drivers/i2c/chips/isp1301_omap.c b/drivers/i2c/chips/isp1301_omap.c
index fe04e46..0669053 100644
--- a/drivers/i2c/chips/isp1301_omap.c
+++ b/drivers/i2c/chips/isp1301_omap.c
@@ -668,7 +668,7 @@ pulldown:
 	dump_regs(isp, "otg->isp1301");
 }
 
-static irqreturn_t omap_otg_irq(int irq, void *_isp)
+static irqreturn_t omap_otg_irq(void *_isp)
 {
 	u16		otg_irq = OTG_IRQ_SRC_REG;
 	u32		otg_ctrl;
diff --git a/drivers/i2c/chips/tps65010.c b/drivers/i2c/chips/tps65010.c
index e320994..6ee510d 100644
--- a/drivers/i2c/chips/tps65010.c
+++ b/drivers/i2c/chips/tps65010.c
@@ -437,7 +437,7 @@ static void tps65010_work(struct work_struct *work)
 	mutex_unlock(&tps->lock);
 }
 
-static irqreturn_t tps65010_irq(int irq, void *_tps)
+static irqreturn_t tps65010_irq(void *_tps)
 {
 	struct tps65010		*tps = _tps;
 
diff --git a/drivers/ide/legacy/hd.c b/drivers/ide/legacy/hd.c
index 8e05d88..4ccfb51 100644
--- a/drivers/ide/legacy/hd.c
+++ b/drivers/ide/legacy/hd.c
@@ -674,7 +674,7 @@ static int hd_getgeo(struct block_device *bdev, struct hd_geometry *geo)
  * be forgotten about...
  */
 
-static irqreturn_t hd_interrupt(int irq, void *dev_id)
+static irqreturn_t hd_interrupt(void *dev_id)
 {
 	void (*handler)(void) = do_hd;
 
diff --git a/drivers/ieee1394/ohci1394.c b/drivers/ieee1394/ohci1394.c
index 372c5c1..fbaa4b0 100644
--- a/drivers/ieee1394/ohci1394.c
+++ b/drivers/ieee1394/ohci1394.c
@@ -2135,7 +2135,7 @@ static void ohci_schedule_iso_tasklets(struct ti_ohci *ohci,
 	spin_unlock_irqrestore(&ohci->iso_tasklet_list_lock, flags);
 }
 
-static irqreturn_t ohci_irq_handler(int irq, void *dev_id)
+static irqreturn_t ohci_irq_handler(void *dev_id)
 {
 	quadlet_t event, node_id;
 	struct ti_ohci *ohci = (struct ti_ohci *)dev_id;
diff --git a/drivers/ieee1394/pcilynx.c b/drivers/ieee1394/pcilynx.c
index 8af01ab..1b874fc 100644
--- a/drivers/ieee1394/pcilynx.c
+++ b/drivers/ieee1394/pcilynx.c
@@ -828,7 +828,7 @@ static int lynx_devctl(struct hpsb_host *host, enum devctl_cmd cmd, int arg)
  ********************************************************/
 
 
-static irqreturn_t lynx_irq_handler(int irq, void *dev_id)
+static irqreturn_t lynx_irq_handler(void *dev_id)
 {
         struct ti_lynx *lynx = (struct ti_lynx *)dev_id;
         struct hpsb_host *host = lynx->host;
diff --git a/drivers/infiniband/hw/amso1100/c2.c b/drivers/infiniband/hw/amso1100/c2.c
index f283a9f..078cdb8 100644
--- a/drivers/infiniband/hw/amso1100/c2.c
+++ b/drivers/infiniband/hw/amso1100/c2.c
@@ -72,7 +72,7 @@ static int c2_down(struct net_device *netdev);
 static int c2_xmit_frame(struct sk_buff *skb, struct net_device *netdev);
 static void c2_tx_interrupt(struct net_device *netdev);
 static void c2_rx_interrupt(struct net_device *netdev);
-static irqreturn_t c2_interrupt(int irq, void *dev_id);
+static irqreturn_t c2_interrupt(void *dev_id);
 static void c2_tx_timeout(struct net_device *netdev);
 static int c2_change_mtu(struct net_device *netdev, int new_mtu);
 static void c2_reset(struct c2_port *c2_port);
@@ -544,7 +544,7 @@ static void c2_rx_interrupt(struct net_device *netdev)
 /*
  * Handle netisr0 TX & RX interrupts.
  */
-static irqreturn_t c2_interrupt(int irq, void *dev_id)
+static irqreturn_t c2_interrupt(void *dev_id)
 {
 	unsigned int netisr0, dmaisr;
 	int handled = 0;
diff --git a/drivers/infiniband/hw/ehca/ehca_irq.c b/drivers/infiniband/hw/ehca/ehca_irq.c
index 3f617b2..e3b2ea9 100644
--- a/drivers/infiniband/hw/ehca/ehca_irq.c
+++ b/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -414,7 +414,7 @@ static inline void reset_eq_pending(struct ehca_cq *cq)
 	return;
 }
 
-irqreturn_t ehca_interrupt_neq(int irq, void *dev_id)
+irqreturn_t ehca_interrupt_neq(void *dev_id)
 {
 	struct ehca_shca *shca = (struct ehca_shca*)dev_id;
 
@@ -447,7 +447,7 @@ void ehca_tasklet_neq(unsigned long data)
 	return;
 }
 
-irqreturn_t ehca_interrupt_eq(int irq, void *dev_id)
+irqreturn_t ehca_interrupt_eq(void *dev_id)
 {
 	struct ehca_shca *shca = (struct ehca_shca*)dev_id;
 
diff --git a/drivers/infiniband/hw/ehca/ehca_irq.h b/drivers/infiniband/hw/ehca/ehca_irq.h
index 3346cb0..332665e 100644
--- a/drivers/infiniband/hw/ehca/ehca_irq.h
+++ b/drivers/infiniband/hw/ehca/ehca_irq.h
@@ -50,10 +50,10 @@ struct ehca_shca;
 
 int ehca_error_data(struct ehca_shca *shca, void *data, u64 resource);
 
-irqreturn_t ehca_interrupt_neq(int irq, void *dev_id);
+irqreturn_t ehca_interrupt_neq(void *dev_id);
 void ehca_tasklet_neq(unsigned long data);
 
-irqreturn_t ehca_interrupt_eq(int irq, void *dev_id);
+irqreturn_t ehca_interrupt_eq(void *dev_id);
 void ehca_tasklet_eq(unsigned long data);
 void ehca_process_eq(struct ehca_shca *shca, int is_irq);
 
diff --git a/drivers/infiniband/hw/ipath/ipath_intr.c b/drivers/infiniband/hw/ipath/ipath_intr.c
index 6a5dd5c..b63b515 100644
--- a/drivers/infiniband/hw/ipath/ipath_intr.c
+++ b/drivers/infiniband/hw/ipath/ipath_intr.c
@@ -1001,7 +1001,7 @@ static void handle_urcv(struct ipath_devdata *dd, u32 istat)
 	}
 }
 
-irqreturn_t ipath_intr(int irq, void *data)
+irqreturn_t ipath_intr(void *data)
 {
 	struct ipath_devdata *dd = data;
 	u32 istat, chk0rcv = 0;
diff --git a/drivers/infiniband/hw/ipath/ipath_kernel.h b/drivers/infiniband/hw/ipath/ipath_kernel.h
index 8786dd7..114e617 100644
--- a/drivers/infiniband/hw/ipath/ipath_kernel.h
+++ b/drivers/infiniband/hw/ipath/ipath_kernel.h
@@ -667,7 +667,7 @@ struct sk_buff *ipath_alloc_skb(struct ipath_devdata *dd, gfp_t);
 
 extern int ipath_diag_inuse;
 
-irqreturn_t ipath_intr(int irq, void *devid);
+irqreturn_t ipath_intr(void *devid);
 int ipath_decode_err(char *buf, size_t blen, ipath_err_t err);
 #if __IPATH_INFO || __IPATH_DBG
 extern const char *ipath_ibcstatus_str[];
diff --git a/drivers/infiniband/hw/mthca/mthca_eq.c b/drivers/infiniband/hw/mthca/mthca_eq.c
index 8592b26..e6ad6af 100644
--- a/drivers/infiniband/hw/mthca/mthca_eq.c
+++ b/drivers/infiniband/hw/mthca/mthca_eq.c
@@ -404,7 +404,7 @@ static int mthca_eq_int(struct mthca_dev *dev, struct mthca_eq *eq)
 	return eqes_found;
 }
 
-static irqreturn_t mthca_tavor_interrupt(int irq, void *dev_ptr)
+static irqreturn_t mthca_tavor_interrupt(void *dev_ptr)
 {
 	struct mthca_dev *dev = dev_ptr;
 	u32 ecr;
@@ -431,7 +431,7 @@ static irqreturn_t mthca_tavor_interrupt(int irq, void *dev_ptr)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t mthca_tavor_msi_x_interrupt(int irq, void *eq_ptr)
+static irqreturn_t mthca_tavor_msi_x_interrupt(void *eq_ptr)
 {
 	struct mthca_eq  *eq  = eq_ptr;
 	struct mthca_dev *dev = eq->dev;
@@ -444,7 +444,7 @@ static irqreturn_t mthca_tavor_msi_x_interrupt(int irq, void *eq_ptr)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t mthca_arbel_interrupt(int irq, void *dev_ptr)
+static irqreturn_t mthca_arbel_interrupt(void *dev_ptr)
 {
 	struct mthca_dev *dev = dev_ptr;
 	int work = 0;
@@ -465,7 +465,7 @@ static irqreturn_t mthca_arbel_interrupt(int irq, void *dev_ptr)
 	return IRQ_RETVAL(work);
 }
 
-static irqreturn_t mthca_arbel_msi_x_interrupt(int irq, void *eq_ptr)
+static irqreturn_t mthca_arbel_msi_x_interrupt(void *eq_ptr)
 {
 	struct mthca_eq  *eq  = eq_ptr;
 	struct mthca_dev *dev = eq->dev;
diff --git a/drivers/input/joystick/amijoy.c b/drivers/input/joystick/amijoy.c
index b0f5541..448c16c 100644
--- a/drivers/input/joystick/amijoy.c
+++ b/drivers/input/joystick/amijoy.c
@@ -55,7 +55,7 @@ static DEFINE_MUTEX(amijoy_mutex);
 static struct input_dev *amijoy_dev[2];
 static char *amijoy_phys[2] = { "amijoy/input0", "amijoy/input1" };
 
-static irqreturn_t amijoy_interrupt(int irq, void *dummy)
+static irqreturn_t amijoy_interrupt(void *dummy)
 {
 	int i, data = 0, button = 0;
 
diff --git a/drivers/input/keyboard/amikbd.c b/drivers/input/keyboard/amikbd.c
index c67e84e..44dbde2 100644
--- a/drivers/input/keyboard/amikbd.c
+++ b/drivers/input/keyboard/amikbd.c
@@ -158,7 +158,7 @@ static const char *amikbd_messages[8] = {
 
 static struct input_dev *amikbd_dev;
 
-static irqreturn_t amikbd_interrupt(int irq, void *dummy)
+static irqreturn_t amikbd_interrupt(void *dummy)
 {
 	unsigned char scancode, down;
 
diff --git a/drivers/input/keyboard/corgikbd.c b/drivers/input/keyboard/corgikbd.c
index 6578bff..f0040d6 100644
--- a/drivers/input/keyboard/corgikbd.c
+++ b/drivers/input/keyboard/corgikbd.c
@@ -188,7 +188,7 @@ static void corgikbd_scankeyboard(struct corgikbd *corgikbd_data)
 /*
  * corgi keyboard interrupt handler.
  */
-static irqreturn_t corgikbd_interrupt(int irq, void *dev_id)
+static irqreturn_t corgikbd_interrupt(void *dev_id)
 {
 	struct corgikbd *corgikbd_data = dev_id;
 
diff --git a/drivers/input/keyboard/hilkbd.c b/drivers/input/keyboard/hilkbd.c
index 499b697..123b55f 100644
--- a/drivers/input/keyboard/hilkbd.c
+++ b/drivers/input/keyboard/hilkbd.c
@@ -155,7 +155,7 @@ static inline void handle_data(unsigned char s, unsigned char c)
 
 
 /* handle HIL interrupts */
-static irqreturn_t hil_interrupt(int irq, void *handle)
+static irqreturn_t hil_interrupt(void *handle)
 {
 	unsigned char s, c;
 
diff --git a/drivers/input/keyboard/locomokbd.c b/drivers/input/keyboard/locomokbd.c
index 7a41b27..124605d 100644
--- a/drivers/input/keyboard/locomokbd.c
+++ b/drivers/input/keyboard/locomokbd.c
@@ -169,7 +169,7 @@ static void locomokbd_scankeyboard(struct locomokbd *locomokbd)
 /*
  * LoCoMo keyboard interrupt handler.
  */
-static irqreturn_t locomokbd_interrupt(int irq, void *dev_id)
+static irqreturn_t locomokbd_interrupt(void *dev_id)
 {
 	struct locomokbd *locomokbd = dev_id;
 	/** wait chattering delay **/
diff --git a/drivers/input/keyboard/omap-keypad.c b/drivers/input/keyboard/omap-keypad.c
index 76f1969..a7daa57 100644
--- a/drivers/input/keyboard/omap-keypad.c
+++ b/drivers/input/keyboard/omap-keypad.c
@@ -97,7 +97,7 @@ static u8 get_row_gpio_val(struct omap_kp *omap_kp)
 #define		get_row_gpio_val(x)	0
 #endif
 
-static irqreturn_t omap_kp_interrupt(int irq, void *dev_id)
+static irqreturn_t omap_kp_interrupt(void *dev_id)
 {
 	struct omap_kp *omap_kp = dev_id;
 
diff --git a/drivers/input/keyboard/spitzkbd.c b/drivers/input/keyboard/spitzkbd.c
index 41b8038..d3c4cc4 100644
--- a/drivers/input/keyboard/spitzkbd.c
+++ b/drivers/input/keyboard/spitzkbd.c
@@ -237,7 +237,7 @@ static void spitzkbd_scankeyboard(struct spitzkbd *spitzkbd_data)
 /*
  * spitz keyboard interrupt handler.
  */
-static irqreturn_t spitzkbd_interrupt(int irq, void *dev_id)
+static irqreturn_t spitzkbd_interrupt(void *dev_id)
 {
 	struct spitzkbd *spitzkbd_data = dev_id;
 
@@ -265,7 +265,7 @@ static void spitzkbd_timer_callback(unsigned long data)
  * We debounce the switches and pass them to the input system.
  */
 
-static irqreturn_t spitzkbd_hinge_isr(int irq, void *dev_id)
+static irqreturn_t spitzkbd_hinge_isr(void *dev_id)
 {
 	struct spitzkbd *spitzkbd_data = dev_id;
 
diff --git a/drivers/input/misc/ixp4xx-beeper.c b/drivers/input/misc/ixp4xx-beeper.c
index e759944..81db8d5 100644
--- a/drivers/input/misc/ixp4xx-beeper.c
+++ b/drivers/input/misc/ixp4xx-beeper.c
@@ -79,7 +79,7 @@ static int ixp4xx_spkr_event(struct input_dev *dev, unsigned int type, unsigned
 	return 0;
 }
 
-static irqreturn_t ixp4xx_spkr_interrupt(int irq, void *dev_id)
+static irqreturn_t ixp4xx_spkr_interrupt(void *dev_id)
 {
 	/* clear interrupt */
 	*IXP4XX_OSST = IXP4XX_OSST_TIMER_2_PEND;
diff --git a/drivers/input/mouse/amimouse.c b/drivers/input/mouse/amimouse.c
index 239a0e1..19405de 100644
--- a/drivers/input/mouse/amimouse.c
+++ b/drivers/input/mouse/amimouse.c
@@ -36,7 +36,7 @@ MODULE_LICENSE("GPL");
 static int amimouse_lastx, amimouse_lasty;
 static struct input_dev *amimouse_dev;
 
-static irqreturn_t amimouse_interrupt(int irq, void *dummy)
+static irqreturn_t amimouse_interrupt(void *dummy)
 {
 	unsigned short joy0dat, potgor;
 	int nx, ny, dx, dy;
diff --git a/drivers/input/mouse/inport.c b/drivers/input/mouse/inport.c
index 79b624f..f972af7 100644
--- a/drivers/input/mouse/inport.c
+++ b/drivers/input/mouse/inport.c
@@ -86,7 +86,7 @@ MODULE_PARM_DESC(irq, "IRQ number (5=default)");
 
 static struct input_dev *inport_dev;
 
-static irqreturn_t inport_interrupt(int irq, void *dev_id)
+static irqreturn_t inport_interrupt(void *dev_id)
 {
 	unsigned char buttons;
 
diff --git a/drivers/input/mouse/logibm.c b/drivers/input/mouse/logibm.c
index 26c3b2e..e3f3baa 100644
--- a/drivers/input/mouse/logibm.c
+++ b/drivers/input/mouse/logibm.c
@@ -77,7 +77,7 @@ MODULE_PARM_DESC(irq, "IRQ number (5=default)");
 
 static struct input_dev *logibm_dev;
 
-static irqreturn_t logibm_interrupt(int irq, void *dev_id)
+static irqreturn_t logibm_interrupt(void *dev_id)
 {
 	char dx, dy;
 	unsigned char buttons;
diff --git a/drivers/input/mouse/pc110pad.c b/drivers/input/mouse/pc110pad.c
index 05d992e..2a61c18 100644
--- a/drivers/input/mouse/pc110pad.c
+++ b/drivers/input/mouse/pc110pad.c
@@ -57,7 +57,7 @@ static struct input_dev *pc110pad_dev;
 static int pc110pad_data[3];
 static int pc110pad_count;
 
-static irqreturn_t pc110pad_interrupt(int irq, void *ptr)
+static irqreturn_t pc110pad_interrupt(void *ptr)
 {
 	int value     = inb_p(pc110pad_io);
 	int handshake = inb_p(pc110pad_io + 2);
@@ -90,9 +90,9 @@ static void pc110pad_close(struct input_dev *dev)
 
 static int pc110pad_open(struct input_dev *dev)
 {
-	pc110pad_interrupt(0, NULL);
-	pc110pad_interrupt(0, NULL);
-	pc110pad_interrupt(0, NULL);
+	pc110pad_interrupt(NULL);
+	pc110pad_interrupt(NULL);
+	pc110pad_interrupt(NULL);
 	outb(PC110PAD_ON, pc110pad_io + 2);
 	pc110pad_count = 0;
 
diff --git a/drivers/input/mouse/rpcmouse.c b/drivers/input/mouse/rpcmouse.c
index 355efd0..e9ac3f1 100644
--- a/drivers/input/mouse/rpcmouse.c
+++ b/drivers/input/mouse/rpcmouse.c
@@ -35,7 +35,7 @@ MODULE_LICENSE("GPL");
 static short rpcmouse_lastx, rpcmouse_lasty;
 static struct input_dev *rpcmouse_dev;
 
-static irqreturn_t rpcmouse_irq(int irq, void *dev_id)
+static irqreturn_t rpcmouse_irq(void *dev_id)
 {
 	struct input_dev *dev = dev_id;
 	short x, y, dx, dy, b;
diff --git a/drivers/input/serio/ambakmi.c b/drivers/input/serio/ambakmi.c
index b10ffae..593ee12 100644
--- a/drivers/input/serio/ambakmi.c
+++ b/drivers/input/serio/ambakmi.c
@@ -37,7 +37,7 @@ struct amba_kmi_port {
 	unsigned int		open;
 };
 
-static irqreturn_t amba_kmi_int(int irq, void *dev_id)
+static irqreturn_t amba_kmi_int(void *dev_id)
 {
 	struct amba_kmi_port *kmi = dev_id;
 	unsigned int status = readb(KMIIR);
diff --git a/drivers/input/serio/ct82c710.c b/drivers/input/serio/ct82c710.c
index 0d35018..ad740f8 100644
--- a/drivers/input/serio/ct82c710.c
+++ b/drivers/input/serio/ct82c710.c
@@ -71,7 +71,7 @@ static struct resource ct82c710_iores;
  * is waiting in the 82C710.
  */
 
-static irqreturn_t ct82c710_interrupt(int cpl, void *dev_id)
+static irqreturn_t ct82c710_interrupt(void *dev_id)
 {
 	return serio_interrupt(ct82c710_port, inb(CT82C710_DATA), 0);
 }
diff --git a/drivers/input/serio/gscps2.c b/drivers/input/serio/gscps2.c
index 3e99df6..f2e460b 100644
--- a/drivers/input/serio/gscps2.c
+++ b/drivers/input/serio/gscps2.c
@@ -82,7 +82,7 @@ MODULE_DEVICE_TABLE(parisc, gscps2_device_tbl);
 #define GSC_ID_MOUSE		1
 
 
-static irqreturn_t gscps2_interrupt(int irq, void *dev);
+static irqreturn_t gscps2_interrupt(void *dev);
 
 #define BUFFER_SIZE 0x0f
 
@@ -226,7 +226,7 @@ static LIST_HEAD(ps2port_list);
  * later.
  */
 
-static irqreturn_t gscps2_interrupt(int irq, void *dev)
+static irqreturn_t gscps2_interrupt(void *dev)
 {
 	struct gscps2port *ps2port;
 
diff --git a/drivers/input/serio/hp_sdc.c b/drivers/input/serio/hp_sdc.c
index 6af1998..2d60d90 100644
--- a/drivers/input/serio/hp_sdc.c
+++ b/drivers/input/serio/hp_sdc.c
@@ -174,7 +174,7 @@ static inline void hp_sdc_spin_ibf(void)
 
 
 /************************ Interrupt context functions ************************/
-static void hp_sdc_take(int irq, void *dev_id, uint8_t status, uint8_t data)
+static void hp_sdc_take(void *dev_id, uint8_t status, uint8_t data)
 {
 	hp_sdc_transaction *curr;
 
@@ -212,7 +212,7 @@ static void hp_sdc_take(int irq, void *dev_id, uint8_t status, uint8_t data)
 	}
 }
 
-static irqreturn_t hp_sdc_isr(int irq, void *dev_id)
+static irqreturn_t hp_sdc_isr(void *dev_id)
 {
 	uint8_t status, data;
 
@@ -270,7 +270,7 @@ static irqreturn_t hp_sdc_isr(int irq, void *dev_id)
 }
 
 
-static irqreturn_t hp_sdc_nmisr(int irq, void *dev_id)
+static irqreturn_t hp_sdc_nmisr(void *dev_id)
 {
 	int status;
 
diff --git a/drivers/input/serio/maceps2.c b/drivers/input/serio/maceps2.c
index 558200e..7faf062 100644
--- a/drivers/input/serio/maceps2.c
+++ b/drivers/input/serio/maceps2.c
@@ -72,7 +72,7 @@ static int maceps2_write(struct serio *dev, unsigned char val)
 	return -1;
 }
 
-static irqreturn_t maceps2_interrupt(int irq, void *dev_id)
+static irqreturn_t maceps2_interrupt(void *dev_id)
 {
 	struct serio *dev = dev_id;
 	struct mace_ps2port *port = ((struct maceps2_data *)dev->port_data)->port;
diff --git a/drivers/input/serio/pcips2.c b/drivers/input/serio/pcips2.c
index 1b404f9..819dcb1 100644
--- a/drivers/input/serio/pcips2.c
+++ b/drivers/input/serio/pcips2.c
@@ -58,7 +58,7 @@ static int pcips2_write(struct serio *io, unsigned char val)
 	return 0;
 }
 
-static irqreturn_t pcips2_interrupt(int irq, void *devid)
+static irqreturn_t pcips2_interrupt(void *devid)
 {
 	struct pcips2_data *ps2if = devid;
 	unsigned char status, scancode;
diff --git a/drivers/input/serio/q40kbd.c b/drivers/input/serio/q40kbd.c
index cb89aff..a7a77d2 100644
--- a/drivers/input/serio/q40kbd.c
+++ b/drivers/input/serio/q40kbd.c
@@ -53,7 +53,7 @@ DEFINE_SPINLOCK(q40kbd_lock);
 static struct serio *q40kbd_port;
 static struct platform_device *q40kbd_device;
 
-static irqreturn_t q40kbd_interrupt(int irq, void *dev_id)
+static irqreturn_t q40kbd_interrupt(void *dev_id)
 {
 	unsigned long flags;
 
diff --git a/drivers/input/serio/rpckbd.c b/drivers/input/serio/rpckbd.c
index 49f8431..8e37827 100644
--- a/drivers/input/serio/rpckbd.c
+++ b/drivers/input/serio/rpckbd.c
@@ -56,7 +56,7 @@ static int rpckbd_write(struct serio *port, unsigned char val)
 	return 0;
 }
 
-static irqreturn_t rpckbd_rx(int irq, void *dev_id)
+static irqreturn_t rpckbd_rx(void *dev_id)
 {
 	struct serio *port = dev_id;
 	unsigned int byte;
@@ -71,7 +71,7 @@ static irqreturn_t rpckbd_rx(int irq, void *dev_id)
 	return handled;
 }
 
-static irqreturn_t rpckbd_tx(int irq, void *dev_id)
+static irqreturn_t rpckbd_tx(void *dev_id)
 {
 	return IRQ_HANDLED;
 }
diff --git a/drivers/input/serio/sa1111ps2.c b/drivers/input/serio/sa1111ps2.c
index 2ad8878..291aff9 100644
--- a/drivers/input/serio/sa1111ps2.c
+++ b/drivers/input/serio/sa1111ps2.c
@@ -40,7 +40,7 @@ struct ps2if {
  * at the most one, but we loop for safety.  If there was a
  * framing error, we have to manually clear the status.
  */
-static irqreturn_t ps2_rxint(int irq, void *dev_id)
+static irqreturn_t ps2_rxint(void *dev_id)
 {
 	struct ps2if *ps2if = dev_id;
 	unsigned int scancode, flag, status;
@@ -69,7 +69,7 @@ static irqreturn_t ps2_rxint(int irq, void *dev_id)
 /*
  * Completion of ps2 write
  */
-static irqreturn_t ps2_txint(int irq, void *dev_id)
+static irqreturn_t ps2_txint(void *dev_id)
 {
 	struct ps2if *ps2if = dev_id;
 	unsigned int status;
diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
index 51ae4fb..620f20a 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -722,7 +722,7 @@ static enum hrtimer_restart ads7846_timer(struct hrtimer *handle)
 	return HRTIMER_NORESTART;
 }
 
-static irqreturn_t ads7846_irq(int irq, void *handle)
+static irqreturn_t ads7846_irq(void *handle)
 {
 	struct ads7846 *ts = handle;
 	unsigned long flags;
diff --git a/drivers/input/touchscreen/corgi_ts.c b/drivers/input/touchscreen/corgi_ts.c
index e6a31d1..6ebbcbb 100644
--- a/drivers/input/touchscreen/corgi_ts.c
+++ b/drivers/input/touchscreen/corgi_ts.c
@@ -225,7 +225,7 @@ static void corgi_ts_timer(unsigned long data)
 	ts_interrupt_main(corgits_data, 1);
 }
 
-static irqreturn_t ts_interrupt(int irq, void *dev_id)
+static irqreturn_t ts_interrupt(void *dev_id)
 {
 	struct corgi_ts *corgits_data = dev_id;
 
diff --git a/drivers/input/touchscreen/h3600_ts_input.c b/drivers/input/touchscreen/h3600_ts_input.c
index 09ed780..07d2e77 100644
--- a/drivers/input/touchscreen/h3600_ts_input.c
+++ b/drivers/input/touchscreen/h3600_ts_input.c
@@ -106,7 +106,7 @@ struct h3600_dev {
 	char phys[32];
 };
 
-static irqreturn_t action_button_handler(int irq, void *dev_id)
+static irqreturn_t action_button_handler(void *dev_id)
 {
 	int down = (GPLR & GPIO_BITSY_ACTION_BUTTON) ? 0 : 1;
 	struct input_dev *dev = (struct input_dev *) dev_id;
@@ -117,7 +117,7 @@ static irqreturn_t action_button_handler(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t npower_button_handler(int irq, void *dev_id)
+static irqreturn_t npower_button_handler(void *dev_id)
 {
 	int down = (GPLR & GPIO_BITSY_NPOWER_BUTTON) ? 0 : 1;
 	struct input_dev *dev = (struct input_dev *) dev_id;
diff --git a/drivers/input/touchscreen/hp680_ts_input.c b/drivers/input/touchscreen/hp680_ts_input.c
index 1a15475..e7424de 100644
--- a/drivers/input/touchscreen/hp680_ts_input.c
+++ b/drivers/input/touchscreen/hp680_ts_input.c
@@ -65,7 +65,7 @@ static void do_softint(struct work_struct *work)
 	enable_irq(HP680_TS_IRQ);
 }
 
-static irqreturn_t hp680_ts_interrupt(int irq, void *dev)
+static irqreturn_t hp680_ts_interrupt(void *dev)
 {
 	disable_irq_nosync(irq);
 	schedule_delayed_work(&work, HZ / 20);
diff --git a/drivers/input/touchscreen/mk712.c b/drivers/input/touchscreen/mk712.c
index 44140fe..a99e717 100644
--- a/drivers/input/touchscreen/mk712.c
+++ b/drivers/input/touchscreen/mk712.c
@@ -80,7 +80,7 @@ MODULE_PARM_DESC(irq, "IRQ of MK712 touchscreen controller");
 static struct input_dev *mk712_dev;
 static DEFINE_SPINLOCK(mk712_lock);
 
-static irqreturn_t mk712_interrupt(int irq, void *dev_id)
+static irqreturn_t mk712_interrupt(void *dev_id)
 {
 	unsigned char status;
 	static int debounce = 1;
diff --git a/drivers/isdn/hardware/avm/avmcard.h b/drivers/isdn/hardware/avm/avmcard.h
index d964f07..38eb5c9 100644
--- a/drivers/isdn/hardware/avm/avmcard.h
+++ b/drivers/isdn/hardware/avm/avmcard.h
@@ -554,7 +554,7 @@ void b1_register_appl(struct capi_ctr *ctrl, u16 appl,
 void b1_release_appl(struct capi_ctr *ctrl, u16 appl);
 u16  b1_send_message(struct capi_ctr *ctrl, struct sk_buff *skb);
 void b1_parse_version(avmctrl_info *card);
-irqreturn_t b1_interrupt(int interrupt, void *devptr);
+irqreturn_t b1_interrupt(void *devptr);
 
 int b1ctl_read_proc(char *page, char **start, off_t off,
         		int count, int *eof, struct capi_ctr *ctrl);
@@ -567,7 +567,7 @@ void avmcard_dma_free(avmcard_dmainfo *);
 int b1pciv4_detect(avmcard *card);
 int t1pci_detect(avmcard *card);
 void b1dma_reset(avmcard *card);
-irqreturn_t b1dma_interrupt(int interrupt, void *devptr);
+irqreturn_t b1dma_interrupt(void *devptr);
 
 int b1dma_load_firmware(struct capi_ctr *ctrl, capiloaddata *data);
 void b1dma_reset_ctr(struct capi_ctr *ctrl);
diff --git a/drivers/isdn/hardware/avm/b1.c b/drivers/isdn/hardware/avm/b1.c
index 4484a64..1686b24 100644
--- a/drivers/isdn/hardware/avm/b1.c
+++ b/drivers/isdn/hardware/avm/b1.c
@@ -484,7 +484,7 @@ void b1_parse_version(avmctrl_info *cinfo)
 
 /* ------------------------------------------------------------- */
 
-irqreturn_t b1_interrupt(int interrupt, void *devptr)
+irqreturn_t b1_interrupt(void *devptr)
 {
 	avmcard *card = devptr;
 	avmctrl_info *cinfo = &card->ctrlinfo[0];
diff --git a/drivers/isdn/hardware/avm/b1dma.c b/drivers/isdn/hardware/avm/b1dma.c
index 428872b..345d7b1 100644
--- a/drivers/isdn/hardware/avm/b1dma.c
+++ b/drivers/isdn/hardware/avm/b1dma.c
@@ -629,7 +629,7 @@ static void b1dma_handle_interrupt(avmcard *card)
 	spin_unlock(&card->lock);
 }
 
-irqreturn_t b1dma_interrupt(int interrupt, void *devptr)
+irqreturn_t b1dma_interrupt(void *devptr)
 {
 	avmcard *card = devptr;
 
diff --git a/drivers/isdn/hardware/avm/c4.c b/drivers/isdn/hardware/avm/c4.c
index 8710cf6..aa4edaa 100644
--- a/drivers/isdn/hardware/avm/c4.c
+++ b/drivers/isdn/hardware/avm/c4.c
@@ -714,7 +714,7 @@ static irqreturn_t c4_handle_interrupt(avmcard *card)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t c4_interrupt(int interrupt, void *devptr)
+static irqreturn_t c4_interrupt(void *devptr)
 {
 	avmcard *card = devptr;
 
diff --git a/drivers/isdn/hardware/avm/t1isa.c b/drivers/isdn/hardware/avm/t1isa.c
index c925020..9126fa9 100644
--- a/drivers/isdn/hardware/avm/t1isa.c
+++ b/drivers/isdn/hardware/avm/t1isa.c
@@ -131,7 +131,7 @@ static int t1_detectandinit(unsigned int base, unsigned irq, int cardnr)
         return 0;
 }
 
-static irqreturn_t t1isa_interrupt(int interrupt, void *devptr)
+static irqreturn_t t1isa_interrupt(void *devptr)
 {
 	avmcard *card = devptr;
 	avmctrl_info *cinfo = &card->ctrlinfo[0];
diff --git a/drivers/isdn/hardware/eicon/divasmain.c b/drivers/isdn/hardware/eicon/divasmain.c
index 6d39f93..cdfa22c 100644
--- a/drivers/isdn/hardware/eicon/divasmain.c
+++ b/drivers/isdn/hardware/eicon/divasmain.c
@@ -56,7 +56,7 @@ static char *DRIVERLNAME = "divas";
 static char *DEVNAME = "Divas";
 char *DRIVERRELEASE_DIVAS = "2.0";
 
-extern irqreturn_t diva_os_irq_wrapper(int irq, void *context);
+extern irqreturn_t diva_os_irq_wrapper(void *context);
 extern int create_divas_proc(void);
 extern void remove_divas_proc(void);
 extern void diva_get_vserial_number(PISDN_ADAPTER IoAdapter, char *buf);
diff --git a/drivers/isdn/hisax/asuscom.c b/drivers/isdn/hisax/asuscom.c
index 61e69e9..b8ba79a 100644
--- a/drivers/isdn/hisax/asuscom.c
+++ b/drivers/isdn/hisax/asuscom.c
@@ -156,7 +156,7 @@ WriteHSCX(struct IsdnCardState *cs, int hscx, u_char offset, u_char value)
 #include "hscx_irq.c"
 
 static irqreturn_t
-asuscom_interrupt(int intno, void *dev_id)
+asuscom_interrupt(void *dev_id)
 {
 	struct IsdnCardState *cs = dev_id;
 	u_char val;
@@ -194,7 +194,7 @@ asuscom_interrupt(int intno, void *dev_id)
 }
 
 static irqreturn_t
-asuscom_interrupt_ipac(int intno, void *dev_id)
+asuscom_interrupt_ipac(void *dev_id)
 {
 	struct IsdnCardState *cs = dev_id;
 	u_char ista, val, icnt = 5;
diff --git a/drivers/isdn/hisax/avm_a1.c b/drivers/isdn/hisax/avm_a1.c
index d9028e9..440aaf4 100644
--- a/drivers/isdn/hisax/avm_a1.c
+++ b/drivers/isdn/hisax/avm_a1.c
@@ -101,7 +101,7 @@ WriteHSCX(struct IsdnCardState *cs, int hscx, u_char offset, u_char value)
 #include "hscx_irq.c"
 
 static irqreturn_t
-avm_a1_interrupt(int intno, void *dev_id)
+avm_a1_interrupt(void *dev_id)
 {
 	struct IsdnCardState *cs = dev_id;
 	u_char val, sval;
diff --git a/drivers/isdn/hisax/avm_a1p.c b/drivers/isdn/hisax/avm_a1p.c
index c87fa3f..2eb7f44 100644
--- a/drivers/isdn/hisax/avm_a1p.c
+++ b/drivers/isdn/hisax/avm_a1p.c
@@ -140,7 +140,7 @@ WriteHSCXfifo(struct IsdnCardState *cs, int hscx, u_char * data, int size)
 #include "hscx_irq.c"
 
 static irqreturn_t
-avm_a1p_interrupt(int intno, void *dev_id)
+avm_a1p_interrupt(void *dev_id)
 {
 	struct IsdnCardState *cs = dev_id;
 	u_char val, sval;
diff --git a/drivers/isdn/hisax/avm_pci.c b/drivers/isdn/hisax/avm_pci.c
index f8b7978..8b8a5e2 100644
--- a/drivers/isdn/hisax/avm_pci.c
+++ b/drivers/isdn/hisax/avm_pci.c
@@ -650,7 +650,7 @@ inithdlc(struct IsdnCardState *cs)
 }
 
 static irqreturn_t
-avm_pcipnp_interrupt(int intno, void *dev_id)
+avm_pcipnp_interrupt(void *dev_id)
 {
 	struct IsdnCardState *cs = dev_id;
 	u_long flags;
diff --git a/drivers/isdn/hisax/bkm_a4t.c b/drivers/isdn/hisax/bkm_a4t.c
index 3d1bdc8..9456606 100644
--- a/drivers/isdn/hisax/bkm_a4t.c
+++ b/drivers/isdn/hisax/bkm_a4t.c
@@ -125,7 +125,7 @@ WriteJADE(struct IsdnCardState *cs, int jade, u_char offset, u_char value)
 #include "jade_irq.c"
 
 static irqreturn_t
-bkm_interrupt(int intno, void *dev_id)
+bkm_interrupt(void *dev_id)
 {
 	struct IsdnCardState *cs = dev_id;
 	u_char val = 0;
diff --git a/drivers/isdn/hisax/bkm_a8.c b/drivers/isdn/hisax/bkm_a8.c
index 99ef3b4..8e13b93 100644
--- a/drivers/isdn/hisax/bkm_a8.c
+++ b/drivers/isdn/hisax/bkm_a8.c
@@ -138,7 +138,7 @@ set_ipac_active(struct IsdnCardState *cs, u_int active)
 #include "hscx_irq.c"
 
 static irqreturn_t
-bkm_interrupt_ipac(int intno, void *dev_id)
+bkm_interrupt_ipac(void *dev_id)
 {
 	struct IsdnCardState *cs = dev_id;
 	u_char ista, val, icnt = 5;
diff --git a/drivers/isdn/hisax/diva.c b/drivers/isdn/hisax/diva.c
index 8267450..bd0193a 100644
--- a/drivers/isdn/hisax/diva.c
+++ b/drivers/isdn/hisax/diva.c
@@ -287,7 +287,7 @@ MemWriteHSCX_IPACX(struct IsdnCardState *cs, int hscx, u_char offset, u_char val
 #include "hscx_irq.c"
 
 static irqreturn_t
-diva_interrupt(int intno, void *dev_id)
+diva_interrupt(void *dev_id)
 {
 	struct IsdnCardState *cs = dev_id;
 	u_char val, sval;
@@ -317,7 +317,7 @@ diva_interrupt(int intno, void *dev_id)
 }
 
 static irqreturn_t
-diva_irq_ipac_isa(int intno, void *dev_id)
+diva_irq_ipac_isa(void *dev_id)
 {
 	struct IsdnCardState *cs = dev_id;
 	u_char ista,val;
@@ -628,7 +628,7 @@ Memhscx_int_main(struct IsdnCardState *cs, u_char val)
 }
 
 static irqreturn_t
-diva_irq_ipac_pci(int intno, void *dev_id)
+diva_irq_ipac_pci(void *dev_id)
 {
 	struct IsdnCardState *cs = dev_id;
 	u_char ista,val;
@@ -683,7 +683,7 @@ Start_IPACPCI:
 }
 
 static irqreturn_t
-diva_irq_ipacx_pci(int intno, void *dev_id)
+diva_irq_ipacx_pci(void *dev_id)
 {
 	struct IsdnCardState *cs = dev_id;
 	u_char val;
diff --git a/drivers/isdn/hisax/elsa.c b/drivers/isdn/hisax/elsa.c
index 948a9b2..223c4ba 100644
--- a/drivers/isdn/hisax/elsa.c
+++ b/drivers/isdn/hisax/elsa.c
@@ -280,7 +280,7 @@ TimerRun(struct IsdnCardState *cs)
 #include "hscx_irq.c"
 
 static irqreturn_t
-elsa_interrupt(int intno, void *dev_id)
+elsa_interrupt(void *dev_id)
 {
 	struct IsdnCardState *cs = dev_id;
 	u_long flags;
@@ -299,7 +299,7 @@ elsa_interrupt(int intno, void *dev_id)
 		val = serial_inp(cs, UART_IIR);
 		if (!(val & UART_IIR_NO_INT)) {
 			debugl1(cs,"IIR %02x", val);
-			rs_interrupt_elsa(intno, cs);
+			rs_interrupt_elsa(cs);
 		}
 	}
 #endif
@@ -359,7 +359,7 @@ elsa_interrupt(int intno, void *dev_id)
 }
 
 static irqreturn_t
-elsa_interrupt_ipac(int intno, void *dev_id)
+elsa_interrupt_ipac(void *dev_id)
 {
 	struct IsdnCardState *cs = dev_id;
 	u_long flags;
@@ -379,7 +379,7 @@ elsa_interrupt_ipac(int intno, void *dev_id)
 		val = serial_inp(cs, UART_IIR);
 		if (!(val & UART_IIR_NO_INT)) {
 			debugl1(cs,"IIR %02x", val);
-			rs_interrupt_elsa(intno, cs);
+			rs_interrupt_elsa(cs);
 		}
 	}
 #endif
diff --git a/drivers/isdn/hisax/elsa_ser.c b/drivers/isdn/hisax/elsa_ser.c
index 1642dca..d0606c3 100644
--- a/drivers/isdn/hisax/elsa_ser.c
+++ b/drivers/isdn/hisax/elsa_ser.c
@@ -384,7 +384,7 @@ static inline void transmit_chars(struct IsdnCardState *cs, int *intr_done)
 }
 
 
-static void rs_interrupt_elsa(int irq, struct IsdnCardState *cs)
+static void rs_interrupt_elsa(struct IsdnCardState *cs)
 {
 	int status, iir, msr;
 	int pass_counter = 0;
diff --git a/drivers/isdn/hisax/enternow_pci.c b/drivers/isdn/hisax/enternow_pci.c
index b73027f..3b57ebb 100644
--- a/drivers/isdn/hisax/enternow_pci.c
+++ b/drivers/isdn/hisax/enternow_pci.c
@@ -240,7 +240,7 @@ enpci_card_msg(struct IsdnCardState *cs, int mt, void *arg)
 }
 
 static irqreturn_t
-enpci_interrupt(int intno, void *dev_id)
+enpci_interrupt(void *dev_id)
 {
 	struct IsdnCardState *cs = dev_id;
 	unsigned char s0val, s1val, ir;
diff --git a/drivers/isdn/hisax/gazel.c b/drivers/isdn/hisax/gazel.c
index 3efa719..c99ca73 100644
--- a/drivers/isdn/hisax/gazel.c
+++ b/drivers/isdn/hisax/gazel.c
@@ -243,7 +243,7 @@ WriteHSCX(struct IsdnCardState *cs, int hscx, u_char offset, u_char value)
 #include "hscx_irq.c"
 
 static irqreturn_t
-gazel_interrupt(int intno, void *dev_id)
+gazel_interrupt(void *dev_id)
 {
 #define MAXCOUNT 5
 	struct IsdnCardState *cs = dev_id;
@@ -274,7 +274,7 @@ gazel_interrupt(int intno, void *dev_id)
 
 
 static irqreturn_t
-gazel_interrupt_ipac(int intno, void *dev_id)
+gazel_interrupt_ipac(void *dev_id)
 {
 	struct IsdnCardState *cs = dev_id;
 	u_char ista, val;
diff --git a/drivers/isdn/hisax/hfc4s8s_l1.c b/drivers/isdn/hisax/hfc4s8s_l1.c
index ab98e13..4b26da9 100644
--- a/drivers/isdn/hisax/hfc4s8s_l1.c
+++ b/drivers/isdn/hisax/hfc4s8s_l1.c
@@ -1269,7 +1269,7 @@ hfc4s8s_bh(struct work_struct *work)
 /* interrupt handler */
 /*********************/
 static irqreturn_t
-hfc4s8s_interrupt(int intno, void *dev_id)
+hfc4s8s_interrupt(void *dev_id)
 {
 	hfc4s8s_hw *hw = dev_id;
 	u_char b, ovr;
diff --git a/drivers/isdn/hisax/hfc_pci.c b/drivers/isdn/hisax/hfc_pci.c
index 077080a..1cb85bd 100644
--- a/drivers/isdn/hisax/hfc_pci.c
+++ b/drivers/isdn/hisax/hfc_pci.c
@@ -925,7 +925,7 @@ receive_emsg(struct IsdnCardState *cs)
 /* Interrupt handler */
 /*********************/
 static irqreturn_t
-hfcpci_interrupt(int intno, void *dev_id)
+hfcpci_interrupt(void *dev_id)
 {
 	u_long flags;
 	struct IsdnCardState *cs = dev_id;
diff --git a/drivers/isdn/hisax/hfc_sx.c b/drivers/isdn/hisax/hfc_sx.c
index 4fd09d2..3f38d5e 100644
--- a/drivers/isdn/hisax/hfc_sx.c
+++ b/drivers/isdn/hisax/hfc_sx.c
@@ -691,7 +691,7 @@ receive_emsg(struct IsdnCardState *cs)
 /* Interrupt handler */
 /*********************/
 static irqreturn_t
-hfcsx_interrupt(int intno, void *dev_id)
+hfcsx_interrupt(void *dev_id)
 {
 	struct IsdnCardState *cs = dev_id;
 	u_char exval;
diff --git a/drivers/isdn/hisax/hfcscard.c b/drivers/isdn/hisax/hfcscard.c
index 57670dc..56bdcd8 100644
--- a/drivers/isdn/hisax/hfcscard.c
+++ b/drivers/isdn/hisax/hfcscard.c
@@ -21,7 +21,7 @@ extern const char *CardType[];
 static const char *hfcs_revision = "$Revision: 1.10.2.4 $";
 
 static irqreturn_t
-hfcs_interrupt(int intno, void *dev_id)
+hfcs_interrupt(void *dev_id)
 {
 	struct IsdnCardState *cs = dev_id;
 	u_char val, stat;
diff --git a/drivers/isdn/hisax/hisax_fcpcipnp.c b/drivers/isdn/hisax/hisax_fcpcipnp.c
index 7993e01..55f63df 100644
--- a/drivers/isdn/hisax/hisax_fcpcipnp.c
+++ b/drivers/isdn/hisax/hisax_fcpcipnp.c
@@ -651,7 +651,7 @@ static void fritz_b_l2l1(struct hisax_if *ifc, int pr, void *arg)
 // ----------------------------------------------------------------------
 
 static irqreturn_t
-fcpci2_irq(int intno, void *dev)
+fcpci2_irq(void *dev)
 {
 	struct fritz_adapter *adapter = dev;
 	unsigned char val;
@@ -671,7 +671,7 @@ fcpci2_irq(int intno, void *dev)
 }
 
 static irqreturn_t
-fcpci_irq(int intno, void *dev)
+fcpci_irq(void *dev)
 {
 	struct fritz_adapter *adapter = dev;
 	unsigned char sval;
diff --git a/drivers/isdn/hisax/isurf.c b/drivers/isdn/hisax/isurf.c
index 55de069..42af46f 100644
--- a/drivers/isdn/hisax/isurf.c
+++ b/drivers/isdn/hisax/isurf.c
@@ -83,7 +83,7 @@ WriteISAR(struct IsdnCardState *cs, int mode, u_char offset, u_char value)
 }
 
 static irqreturn_t
-isurf_interrupt(int intno, void *dev_id)
+isurf_interrupt(void *dev_id)
 {
 	struct IsdnCardState *cs = dev_id;
 	u_char val;
diff --git a/drivers/isdn/hisax/ix1_micro.c b/drivers/isdn/hisax/ix1_micro.c
index 252d79d..a99acc8 100644
--- a/drivers/isdn/hisax/ix1_micro.c
+++ b/drivers/isdn/hisax/ix1_micro.c
@@ -125,7 +125,7 @@ WriteHSCX(struct IsdnCardState *cs, int hscx, u_char offset, u_char value)
 #include "hscx_irq.c"
 
 static irqreturn_t
-ix1micro_interrupt(int intno, void *dev_id)
+ix1micro_interrupt(void *dev_id)
 {
 	struct IsdnCardState *cs = dev_id;
 	u_char val;
diff --git a/drivers/isdn/hisax/mic.c b/drivers/isdn/hisax/mic.c
index a81d175..c974b99 100644
--- a/drivers/isdn/hisax/mic.c
+++ b/drivers/isdn/hisax/mic.c
@@ -120,7 +120,7 @@ WriteHSCX(struct IsdnCardState *cs, int hscx, u_char offset, u_char value)
 #include "hscx_irq.c"
 
 static irqreturn_t
-mic_interrupt(int intno, void *dev_id)
+mic_interrupt(void *dev_id)
 {
 	struct IsdnCardState *cs = dev_id;
 	u_char val;
diff --git a/drivers/isdn/hisax/netjet.h b/drivers/isdn/hisax/netjet.h
index 4d89d3e..d9bf2b0 100644
--- a/drivers/isdn/hisax/netjet.h
+++ b/drivers/isdn/hisax/netjet.h
@@ -66,7 +66,7 @@ void read_tiger(struct IsdnCardState *cs);
 void write_tiger(struct IsdnCardState *cs);
 
 void netjet_fill_dma(struct BCState *bcs);
-void netjet_interrupt(int intno, void *dev_id);
+void netjet_interrupt(void *dev_id);
 void inittiger(struct IsdnCardState *cs);
 void release_io_netjet(struct IsdnCardState *cs);
 
diff --git a/drivers/isdn/hisax/niccy.c b/drivers/isdn/hisax/niccy.c
index e5918c6..b057294 100644
--- a/drivers/isdn/hisax/niccy.c
+++ b/drivers/isdn/hisax/niccy.c
@@ -122,7 +122,7 @@ static void WriteHSCX(struct IsdnCardState *cs, int hscx, u_char offset,
 
 #include "hscx_irq.c"
 
-static irqreturn_t niccy_interrupt(int intno, void *dev_id)
+static irqreturn_t niccy_interrupt(void *dev_id)
 {
 	struct IsdnCardState *cs = dev_id;
 	u_char val;
diff --git a/drivers/isdn/hisax/nj_s.c b/drivers/isdn/hisax/nj_s.c
index a895dfe..2764820 100644
--- a/drivers/isdn/hisax/nj_s.c
+++ b/drivers/isdn/hisax/nj_s.c
@@ -26,7 +26,7 @@ static void dummywr(struct IsdnCardState *cs, int chan, u_char off, u_char value
 }
 
 static irqreturn_t
-netjet_s_interrupt(int intno, void *dev_id)
+netjet_s_interrupt(void *dev_id)
 {
 	struct IsdnCardState *cs = dev_id;
 	u_char val, s1val, s0val;
diff --git a/drivers/isdn/hisax/nj_u.c b/drivers/isdn/hisax/nj_u.c
index f017d38..09fea1d 100644
--- a/drivers/isdn/hisax/nj_u.c
+++ b/drivers/isdn/hisax/nj_u.c
@@ -26,7 +26,7 @@ static void dummywr(struct IsdnCardState *cs, int chan, u_char off, u_char value
 }
 
 static irqreturn_t
-netjet_u_interrupt(int intno, void *dev_id)
+netjet_u_interrupt(void *dev_id)
 {
 	struct IsdnCardState *cs = dev_id;
 	u_char val, sval;
diff --git a/drivers/isdn/hisax/s0box.c b/drivers/isdn/hisax/s0box.c
index 150ef68..99e5862 100644
--- a/drivers/isdn/hisax/s0box.c
+++ b/drivers/isdn/hisax/s0box.c
@@ -141,7 +141,7 @@ WriteHSCX(struct IsdnCardState *cs, int hscx, u_char offset, u_char value)
 #include "hscx_irq.c"
 
 static irqreturn_t
-s0box_interrupt(int intno, void *dev_id)
+s0box_interrupt(void *dev_id)
 {
 #define MAXCOUNT 5
 	struct IsdnCardState *cs = dev_id;
diff --git a/drivers/isdn/hisax/saphir.c b/drivers/isdn/hisax/saphir.c
index c99b166..32adb33 100644
--- a/drivers/isdn/hisax/saphir.c
+++ b/drivers/isdn/hisax/saphir.c
@@ -117,7 +117,7 @@ WriteHSCX(struct IsdnCardState *cs, int hscx, u_char offset, u_char value)
 #include "hscx_irq.c"
 
 static irqreturn_t
-saphir_interrupt(int intno, void *dev_id)
+saphir_interrupt(void *dev_id)
 {
 	struct IsdnCardState *cs = dev_id;
 	u_char val;
diff --git a/drivers/isdn/hisax/sedlbauer.c b/drivers/isdn/hisax/sedlbauer.c
index 03dfc32..b4e818a 100644
--- a/drivers/isdn/hisax/sedlbauer.c
+++ b/drivers/isdn/hisax/sedlbauer.c
@@ -260,7 +260,7 @@ WriteISAR(struct IsdnCardState *cs, int mode, u_char offset, u_char value)
 #include "hscx_irq.c"
 
 static irqreturn_t
-sedlbauer_interrupt(int intno, void *dev_id)
+sedlbauer_interrupt(void *dev_id)
 {
 	struct IsdnCardState *cs = dev_id;
 	u_char val;
@@ -306,7 +306,7 @@ sedlbauer_interrupt(int intno, void *dev_id)
 }
 
 static irqreturn_t
-sedlbauer_interrupt_ipac(int intno, void *dev_id)
+sedlbauer_interrupt_ipac(void *dev_id)
 {
 	struct IsdnCardState *cs = dev_id;
 	u_char ista, val, icnt = 5;
@@ -353,7 +353,7 @@ Start_IPAC:
 }
 
 static irqreturn_t
-sedlbauer_interrupt_isar(int intno, void *dev_id)
+sedlbauer_interrupt_isar(void *dev_id)
 {
 	struct IsdnCardState *cs = dev_id;
 	u_char val;
diff --git a/drivers/isdn/hisax/sportster.c b/drivers/isdn/hisax/sportster.c
index 0220950..cab3572 100644
--- a/drivers/isdn/hisax/sportster.c
+++ b/drivers/isdn/hisax/sportster.c
@@ -99,7 +99,7 @@ WriteHSCX(struct IsdnCardState *cs, int hscx, u_char offset, u_char value)
 #include "hscx_irq.c"
 
 static irqreturn_t
-sportster_interrupt(int intno, void *dev_id)
+sportster_interrupt(void *dev_id)
 {
 	struct IsdnCardState *cs = dev_id;
 	u_char val;
diff --git a/drivers/isdn/hisax/teleint.c b/drivers/isdn/hisax/teleint.c
index 0909662..b6e93c2 100644
--- a/drivers/isdn/hisax/teleint.c
+++ b/drivers/isdn/hisax/teleint.c
@@ -157,7 +157,7 @@ WriteHFC(struct IsdnCardState *cs, int data, u_char reg, u_char value)
 }
 
 static irqreturn_t
-TeleInt_interrupt(int intno, void *dev_id)
+TeleInt_interrupt(void *dev_id)
 {
 	struct IsdnCardState *cs = dev_id;
 	u_char val;
diff --git a/drivers/isdn/hisax/teles0.c b/drivers/isdn/hisax/teles0.c
index 4858133..6bd3756 100644
--- a/drivers/isdn/hisax/teles0.c
+++ b/drivers/isdn/hisax/teles0.c
@@ -144,7 +144,7 @@ WriteHSCX(struct IsdnCardState *cs, int hscx, u_char offset, u_char value)
 #include "hscx_irq.c"
 
 static irqreturn_t
-teles0_interrupt(int intno, void *dev_id)
+teles0_interrupt(void *dev_id)
 {
 	struct IsdnCardState *cs = dev_id;
 	u_char val;
diff --git a/drivers/isdn/hisax/teles3.c b/drivers/isdn/hisax/teles3.c
index 6a5e379..0dd2d28 100644
--- a/drivers/isdn/hisax/teles3.c
+++ b/drivers/isdn/hisax/teles3.c
@@ -101,7 +101,7 @@ WriteHSCX(struct IsdnCardState *cs, int hscx, u_char offset, u_char value)
 #include "hscx_irq.c"
 
 static irqreturn_t
-teles3_interrupt(int intno, void *dev_id)
+teles3_interrupt(void *dev_id)
 {
 #define MAXCOUNT 5
 	struct IsdnCardState *cs = dev_id;
diff --git a/drivers/isdn/hisax/telespci.c b/drivers/isdn/hisax/telespci.c
index 4393003..f970330 100644
--- a/drivers/isdn/hisax/telespci.c
+++ b/drivers/isdn/hisax/telespci.c
@@ -226,7 +226,7 @@ WriteHSCX(struct IsdnCardState *cs, int hscx, u_char offset, u_char value)
 #include "hscx_irq.c"
 
 static irqreturn_t
-telespci_interrupt(int intno, void *dev_id)
+telespci_interrupt(void *dev_id)
 {
 	struct IsdnCardState *cs = dev_id;
 	u_char hval, ival;
diff --git a/drivers/isdn/hysdn/boardergo.c b/drivers/isdn/hysdn/boardergo.c
index 6cdbad3..80a1e33 100644
--- a/drivers/isdn/hysdn/boardergo.c
+++ b/drivers/isdn/hysdn/boardergo.c
@@ -32,7 +32,7 @@
 /* The cards interrupt handler. Called from system */
 /***************************************************/
 static irqreturn_t
-ergo_interrupt(int intno, void *dev_id)
+ergo_interrupt(void *dev_id)
 {
 	hysdn_card *card = dev_id;	/* parameter from irq */
 	tErgDpram *dpr;
diff --git a/drivers/isdn/pcbit/layer2.c b/drivers/isdn/pcbit/layer2.c
index 5ba2a87..03392b6 100644
--- a/drivers/isdn/pcbit/layer2.c
+++ b/drivers/isdn/pcbit/layer2.c
@@ -495,7 +495,7 @@ pcbit_firmware_bug(struct pcbit_dev *dev)
 }
 
 irqreturn_t
-pcbit_irq_handler(int interrupt, void *devptr)
+pcbit_irq_handler(void *devptr)
 {
 	struct pcbit_dev *dev;
 	u_char info,
diff --git a/drivers/isdn/pcbit/layer2.h b/drivers/isdn/pcbit/layer2.h
index 2ac295e..b549004 100644
--- a/drivers/isdn/pcbit/layer2.h
+++ b/drivers/isdn/pcbit/layer2.h
@@ -124,7 +124,7 @@ struct frame_buf {
 extern int pcbit_l2_write(struct pcbit_dev * dev, ulong msg, ushort refnum, 
                           struct sk_buff *skb, unsigned short hdr_len);
 
-extern irqreturn_t pcbit_irq_handler(int interrupt, void *);
+extern irqreturn_t pcbit_irq_handler(void *);
 
 extern struct pcbit_dev * dev_pcbit[MAX_PCBIT_CARDS];
 
diff --git a/drivers/isdn/sc/card.h b/drivers/isdn/sc/card.h
index 5992f63..5ee1a4e 100644
--- a/drivers/isdn/sc/card.h
+++ b/drivers/isdn/sc/card.h
@@ -108,7 +108,7 @@ void memcpy_toshmem(int card, void *dest, const void *src, size_t n);
 void memcpy_fromshmem(int card, void *dest, const void *src, size_t n);
 int get_card_from_id(int driver);
 int indicate_status(int card, int event, ulong Channel, char *Data);
-irqreturn_t interrupt_handler(int interrupt, void *cardptr);
+irqreturn_t interrupt_handler(void *cardptr);
 int sndpkt(int devId, int channel, struct sk_buff *data);
 void rcvpkt(int card, RspMessage *rcvmsg);
 int command(isdn_ctrl *cmd);
diff --git a/drivers/macintosh/macio-adb.c b/drivers/macintosh/macio-adb.c
index 79119f5..7a11510 100644
--- a/drivers/macintosh/macio-adb.c
+++ b/drivers/macintosh/macio-adb.c
@@ -63,7 +63,7 @@ static DEFINE_SPINLOCK(macio_lock);
 
 static int macio_probe(void);
 static int macio_init(void);
-static irqreturn_t macio_adb_interrupt(int irq, void *arg);
+static irqreturn_t macio_adb_interrupt(void *arg);
 static int macio_send_request(struct adb_request *req, int sync);
 static int macio_adb_autopoll(int devs);
 static void macio_adb_poll(void);
@@ -198,7 +198,7 @@ static int macio_send_request(struct adb_request *req, int sync)
 	return 0;
 }
 
-static irqreturn_t macio_adb_interrupt(int irq, void *arg)
+static irqreturn_t macio_adb_interrupt(void *arg)
 {
 	int i, n, err;
 	struct adb_request *req = NULL;
diff --git a/drivers/macintosh/smu.c b/drivers/macintosh/smu.c
index d409f67..282098d 100644
--- a/drivers/macintosh/smu.c
+++ b/drivers/macintosh/smu.c
@@ -146,7 +146,7 @@ static void smu_start_cmd(void)
 }
 
 
-static irqreturn_t smu_db_intr(int irq, void *arg)
+static irqreturn_t smu_db_intr(void *arg)
 {
 	unsigned long flags;
 	struct smu_cmd *cmd;
@@ -225,7 +225,7 @@ static irqreturn_t smu_db_intr(int irq, void *arg)
 }
 
 
-static irqreturn_t smu_msg_intr(int irq, void *arg)
+static irqreturn_t smu_msg_intr(void *arg)
 {
 	/* I don't quite know what to do with this one, we seem to never
 	 * receive it, so I suspect we have to arm it someway in the SMU
diff --git a/drivers/macintosh/via-cuda.c b/drivers/macintosh/via-cuda.c
index 741a93a..2480a41 100644
--- a/drivers/macintosh/via-cuda.c
+++ b/drivers/macintosh/via-cuda.c
@@ -98,7 +98,7 @@ static int cuda_reset_adb_bus(void);
 
 static int cuda_init_via(void);
 static void cuda_start(void);
-static irqreturn_t cuda_interrupt(int irq, void *arg);
+static irqreturn_t cuda_interrupt(void *arg);
 static void cuda_input(unsigned char *buf, int nb);
 void cuda_poll(void);
 static int cuda_write(struct adb_request *req);
@@ -437,7 +437,7 @@ cuda_poll(void)
 }
 
 static irqreturn_t
-cuda_interrupt(int irq, void *arg)
+cuda_interrupt(void *arg)
 {
     int status;
     struct adb_request *req = NULL;
diff --git a/drivers/macintosh/via-pmu.c b/drivers/macintosh/via-pmu.c
index f7c509b..ff86ea3 100644
--- a/drivers/macintosh/via-pmu.c
+++ b/drivers/macintosh/via-pmu.c
@@ -192,8 +192,8 @@ static int pmu_adb_reset_bus(void);
 
 static int init_pmu(void);
 static void pmu_start(void);
-static irqreturn_t via_pmu_interrupt(int irq, void *arg);
-static irqreturn_t gpio1_interrupt(int irq, void *arg);
+static irqreturn_t via_pmu_interrupt(void *arg);
+static irqreturn_t gpio1_interrupt(void *arg);
 static int proc_get_info(char *page, char **start, off_t off,
 			  int count, int *eof, void *data);
 static int proc_get_irqstats(char *page, char **start, off_t off,
@@ -1542,7 +1542,7 @@ pmu_sr_intr(void)
 }
 
 static irqreturn_t
-via_pmu_interrupt(int irq, void *arg)
+via_pmu_interrupt(void *arg)
 {
 	unsigned long flags;
 	int intr;
@@ -1643,7 +1643,7 @@ pmu_unlock(void)
 
 
 static irqreturn_t
-gpio1_interrupt(int irq, void *arg)
+gpio1_interrupt(void *arg)
 {
 	unsigned long flags;
 
diff --git a/drivers/media/common/saa7146_core.c b/drivers/media/common/saa7146_core.c
index 365a221..d99dd60 100644
--- a/drivers/media/common/saa7146_core.c
+++ b/drivers/media/common/saa7146_core.c
@@ -245,7 +245,7 @@ int saa7146_pgtable_build_single(struct pci_dev *pci, struct saa7146_pgtable *pt
 
 /********************************************************************************/
 /* interrupt handler */
-static irqreturn_t interrupt_hw(int irq, void *dev_id)
+static irqreturn_t interrupt_hw(void *dev_id)
 {
 	struct saa7146_dev *dev = dev_id;
 	u32 isr;
diff --git a/drivers/media/dvb/b2c2/flexcop-pci.c b/drivers/media/dvb/b2c2/flexcop-pci.c
index 01af4d2..18a67fb 100644
--- a/drivers/media/dvb/b2c2/flexcop-pci.c
+++ b/drivers/media/dvb/b2c2/flexcop-pci.c
@@ -123,7 +123,7 @@ static void flexcop_pci_irq_check_work(struct work_struct *work)
 /* When PID filtering is turned on, we use the timer IRQ, because small amounts
  * of data need to be passed to the user space instantly as well. When PID
  * filtering is turned off, we use the page-change-IRQ */
-static irqreturn_t flexcop_pci_isr(int irq, void *dev_id)
+static irqreturn_t flexcop_pci_isr(void *dev_id)
 {
 	struct flexcop_pci *fc_pci = dev_id;
 	struct flexcop_device *fc = fc_pci->fc_dev;
diff --git a/drivers/media/dvb/bt8xx/bt878.c b/drivers/media/dvb/bt8xx/bt878.c
index eca602d..49b726f 100644
--- a/drivers/media/dvb/bt8xx/bt878.c
+++ b/drivers/media/dvb/bt8xx/bt878.c
@@ -265,7 +265,7 @@ EXPORT_SYMBOL(bt878_stop);
 /* Interrupt service routine */
 /*****************************/
 
-static irqreturn_t bt878_irq(int irq, void *dev_id)
+static irqreturn_t bt878_irq(void *dev_id)
 {
 	u32 stat, astat, mask;
 	int count;
diff --git a/drivers/media/dvb/pluto2/pluto2.c b/drivers/media/dvb/pluto2/pluto2.c
index 08a2599..ac0fa89 100644
--- a/drivers/media/dvb/pluto2/pluto2.c
+++ b/drivers/media/dvb/pluto2/pluto2.c
@@ -323,7 +323,7 @@ static void pluto_dma_end(struct pluto *pluto, unsigned int nbpackets)
 			TS_DMA_BYTES, PCI_DMA_FROMDEVICE);
 }
 
-static irqreturn_t pluto_irq(int irq, void *dev_id)
+static irqreturn_t pluto_irq(void *dev_id)
 {
 	struct pluto *pluto = dev_id;
 	u32 tscr;
diff --git a/drivers/media/video/arv.c b/drivers/media/video/arv.c
index 19e9929..c0d24d3 100644
--- a/drivers/media/video/arv.c
+++ b/drivers/media/video/arv.c
@@ -548,7 +548,7 @@ static int ar_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 /*
  * Interrupt handler
  */
-static void ar_interrupt(int irq, void *dev)
+static void ar_interrupt(void *dev)
 {
 	struct ar_device *ar = dev;
 	unsigned int line_count;
diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index 7a332b3..1cc1370 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -4440,7 +4440,7 @@ bttv_irq_switch_vbi(struct bttv *btv)
 	spin_unlock(&btv->s_lock);
 }
 
-static irqreturn_t bttv_irq(int irq, void *dev_id)
+static irqreturn_t bttv_irq(void *dev_id)
 {
 	u32 stat,astat;
 	u32 dstat;
diff --git a/drivers/media/video/cafe_ccic.c b/drivers/media/video/cafe_ccic.c
index b63cab3..20d6fb9 100644
--- a/drivers/media/video/cafe_ccic.c
+++ b/drivers/media/video/cafe_ccic.c
@@ -1934,7 +1934,7 @@ static void cafe_frame_irq(struct cafe_camera *cam, unsigned int irqs)
 
 
 
-static irqreturn_t cafe_irq(int irq, void *data)
+static irqreturn_t cafe_irq(void *data)
 {
 	struct cafe_camera *cam = data;
 	unsigned int irqs;
diff --git a/drivers/media/video/cx23885/cx23885-core.c b/drivers/media/video/cx23885/cx23885-core.c
index af16505..3523a94 100644
--- a/drivers/media/video/cx23885/cx23885-core.c
+++ b/drivers/media/video/cx23885/cx23885-core.c
@@ -1323,7 +1323,7 @@ static int cx23885_irq_ts(struct cx23885_tsport *port, u32 status)
 	return handled;
 }
 
-static irqreturn_t cx23885_irq(int irq, void *dev_id)
+static irqreturn_t cx23885_irq(void *dev_id)
 {
 	struct cx23885_dev *dev = dev_id;
 	struct cx23885_tsport *ts1 = &dev->ts1;
diff --git a/drivers/media/video/cx88/cx88-alsa.c b/drivers/media/video/cx88/cx88-alsa.c
index 141dadf..a45e1d8 100644
--- a/drivers/media/video/cx88/cx88-alsa.c
+++ b/drivers/media/video/cx88/cx88-alsa.c
@@ -242,7 +242,7 @@ static void cx8801_aud_irq(snd_cx88_card_t *chip)
 /*
  * BOARD Specific: Handles IRQ calls
  */
-static irqreturn_t cx8801_irq(int irq, void *dev_id)
+static irqreturn_t cx8801_irq(void *dev_id)
 {
 	snd_cx88_card_t *chip = dev_id;
 	struct cx88_core *core = chip->core;
diff --git a/drivers/media/video/cx88/cx88-mpeg.c b/drivers/media/video/cx88/cx88-mpeg.c
index a652f29..32b21d8 100644
--- a/drivers/media/video/cx88/cx88-mpeg.c
+++ b/drivers/media/video/cx88/cx88-mpeg.c
@@ -405,7 +405,7 @@ static void cx8802_mpeg_irq(struct cx8802_dev *dev)
 
 #define MAX_IRQ_LOOP 10
 
-static irqreturn_t cx8802_irq(int irq, void *dev_id)
+static irqreturn_t cx8802_irq(void *dev_id)
 {
 	struct cx8802_dev *dev = dev_id;
 	struct cx88_core *core = dev->core;
diff --git a/drivers/media/video/cx88/cx88-video.c b/drivers/media/video/cx88/cx88-video.c
index 231ae6c..8b1711b 100644
--- a/drivers/media/video/cx88/cx88-video.c
+++ b/drivers/media/video/cx88/cx88-video.c
@@ -1572,7 +1572,7 @@ static void cx8800_vid_irq(struct cx8800_dev *dev)
 	}
 }
 
-static irqreturn_t cx8800_irq(int irq, void *dev_id)
+static irqreturn_t cx8800_irq(void *dev_id)
 {
 	struct cx8800_dev *dev = dev_id;
 	struct cx88_core *core = dev->core;
diff --git a/drivers/media/video/ivtv/ivtv-irq.c b/drivers/media/video/ivtv/ivtv-irq.c
index fd1688e..5481c48 100644
--- a/drivers/media/video/ivtv/ivtv-irq.c
+++ b/drivers/media/video/ivtv/ivtv-irq.c
@@ -800,7 +800,7 @@ static void ivtv_irq_vsync(struct ivtv *itv)
 
 #define IVTV_IRQ_DMA (IVTV_IRQ_DMA_READ | IVTV_IRQ_ENC_DMA_COMPLETE | IVTV_IRQ_DMA_ERR | IVTV_IRQ_ENC_START_CAP | IVTV_IRQ_ENC_VBI_CAP | IVTV_IRQ_DEC_DATA_REQ | IVTV_IRQ_DEC_VBI_RE_INSERT)
 
-irqreturn_t ivtv_irq_handler(int irq, void *dev_id)
+irqreturn_t ivtv_irq_handler(void *dev_id)
 {
 	struct ivtv *itv = (struct ivtv *)dev_id;
 	u32 combo;
diff --git a/drivers/media/video/ivtv/ivtv-irq.h b/drivers/media/video/ivtv/ivtv-irq.h
index f879a58..0f9e376 100644
--- a/drivers/media/video/ivtv/ivtv-irq.h
+++ b/drivers/media/video/ivtv/ivtv-irq.h
@@ -44,7 +44,7 @@
 #define IVTV_IRQ_MASK_CAPTURE (IVTV_IRQ_ENC_START_CAP | IVTV_IRQ_ENC_EOS)
 #define IVTV_IRQ_MASK_DECODE  (IVTV_IRQ_DEC_DATA_REQ|IVTV_IRQ_DEC_AUD_MODE_CHG)
 
-irqreturn_t ivtv_irq_handler(int irq, void *dev_id);
+irqreturn_t ivtv_irq_handler(void *dev_id);
 
 void ivtv_irq_work_handler(struct work_struct *work);
 void ivtv_dma_stream_dec_prepare(struct ivtv_stream *s, u32 offset, int lock);
diff --git a/drivers/media/video/meye.c b/drivers/media/video/meye.c
index 7533fc2..d96cc3e 100644
--- a/drivers/media/video/meye.c
+++ b/drivers/media/video/meye.c
@@ -785,7 +785,7 @@ static void mchip_cont_compression_start(void)
 /* Interrupt handling                                                       */
 /****************************************************************************/
 
-static irqreturn_t meye_irq(int irq, void *dev_id)
+static irqreturn_t meye_irq(void *dev_id)
 {
 	u32 v;
 	int reqnr;
diff --git a/drivers/media/video/saa7134/saa7134-alsa.c b/drivers/media/video/saa7134/saa7134-alsa.c
index c6f7279..cddf476 100644
--- a/drivers/media/video/saa7134/saa7134-alsa.c
+++ b/drivers/media/video/saa7134/saa7134-alsa.c
@@ -208,7 +208,7 @@ static void saa7134_irq_alsa_done(struct saa7134_dev *dev,
  *
  */
 
-static irqreturn_t saa7134_alsa_irq(int irq, void *dev_id)
+static irqreturn_t saa7134_alsa_irq(void *dev_id)
 {
 	struct saa7134_dmasound *dmasound = dev_id;
 	struct saa7134_dev *dev = dmasound->priv_data;
diff --git a/drivers/media/video/saa7134/saa7134-core.c b/drivers/media/video/saa7134/saa7134-core.c
index 1a4a244..ac72264 100644
--- a/drivers/media/video/saa7134/saa7134-core.c
+++ b/drivers/media/video/saa7134/saa7134-core.c
@@ -557,7 +557,7 @@ static void print_irqstatus(struct saa7134_dev *dev, int loop,
 	printk("\n");
 }
 
-static irqreturn_t saa7134_irq(int irq, void *dev_id)
+static irqreturn_t saa7134_irq(void *dev_id)
 {
 	struct saa7134_dev *dev = (struct saa7134_dev*) dev_id;
 	unsigned long report,status;
diff --git a/drivers/media/video/saa7134/saa7134-oss.c b/drivers/media/video/saa7134/saa7134-oss.c
index aedf046..6935ee5 100644
--- a/drivers/media/video/saa7134/saa7134-oss.c
+++ b/drivers/media/video/saa7134/saa7134-oss.c
@@ -805,7 +805,7 @@ const struct file_operations saa7134_mixer_fops = {
 
 /* ------------------------------------------------------------------ */
 
-static irqreturn_t saa7134_oss_irq(int irq, void *dev_id)
+static irqreturn_t saa7134_oss_irq(void *dev_id)
 {
 	struct saa7134_dmasound *dmasound = dev_id;
 	struct saa7134_dev *dev = dmasound->priv_data;
diff --git a/drivers/media/video/stradis.c b/drivers/media/video/stradis.c
index eb22046..ab5a3d9 100644
--- a/drivers/media/video/stradis.c
+++ b/drivers/media/video/stradis.c
@@ -406,7 +406,7 @@ static void send_osd_data(struct saa7146 *saa)
 	}
 }
 
-static irqreturn_t saa7146_irq(int irq, void *dev_id)
+static irqreturn_t saa7146_irq(void *dev_id)
 {
 	struct saa7146 *saa = dev_id;
 	u32 stat, astat;
diff --git a/drivers/media/video/vino.c b/drivers/media/video/vino.c
index 9a03dc8..c3d73d3 100644
--- a/drivers/media/video/vino.c
+++ b/drivers/media/video/vino.c
@@ -2322,7 +2322,7 @@ static void vino_capture_tasklet(unsigned long channel) {
 	}
 }
 
-static irqreturn_t vino_interrupt(int irq, void *dev_id)
+static irqreturn_t vino_interrupt(void *dev_id)
 {
 	u32 ctrl, intr;
 	unsigned int fc_a, fc_b;
diff --git a/drivers/media/video/zoran_device.c b/drivers/media/video/zoran_device.c
index 68c7c50..dfaea89 100644
--- a/drivers/media/video/zoran_device.c
+++ b/drivers/media/video/zoran_device.c
@@ -1377,8 +1377,7 @@ error_handler (struct zoran *zr,
 }
 
 irqreturn_t
-zoran_irq (int             irq,
-	   void           *dev_id)
+zoran_irq (void *dev_id)
 {
 	u32 stat, astat;
 	int count;
diff --git a/drivers/media/video/zoran_device.h b/drivers/media/video/zoran_device.h
index 37fa86a..8d34bfe 100644
--- a/drivers/media/video/zoran_device.h
+++ b/drivers/media/video/zoran_device.h
@@ -64,7 +64,7 @@ extern int wait_grab_pending(struct zoran *zr);
 /* interrupts */
 extern void print_interrupts(struct zoran *zr);
 extern void clear_interrupt_counters(struct zoran *zr);
-extern irqreturn_t zoran_irq(int irq, void *dev_id);
+extern irqreturn_t zoran_irq(void *dev_id);
 
 /* JPEG codec access */
 extern void jpeg_start(struct zoran *zr);
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 52fb216..1fd0b59 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -135,7 +135,7 @@ static u8 last_drv_idx;
 /*
  *  Forward protos...
  */
-static irqreturn_t mpt_interrupt(int irq, void *bus_id);
+static irqreturn_t mpt_interrupt(void *bus_id);
 static int	mpt_base_reply(MPT_ADAPTER *ioc, MPT_FRAME_HDR *req, MPT_FRAME_HDR *reply);
 static int	mpt_handshake_req_reply_wait(MPT_ADAPTER *ioc, int reqBytes,
 			u32 *req, int replyBytes, u16 *u16reply, int maxwait,
@@ -405,7 +405,7 @@ mpt_reply(MPT_ADAPTER *ioc, u32 pa)
  *	the protocol-specific details of the MPT request completion.
  */
 static irqreturn_t
-mpt_interrupt(int irq, void *bus_id)
+mpt_interrupt(void *bus_id)
 {
 	MPT_ADAPTER *ioc = bus_id;
 	u32 pa = CHIPREG_READ32_dmasync(&ioc->chip->ReplyFifo);
diff --git a/drivers/message/i2o/pci.c b/drivers/message/i2o/pci.c
index 3661e6e..6ffd188 100644
--- a/drivers/message/i2o/pci.c
+++ b/drivers/message/i2o/pci.c
@@ -222,13 +222,12 @@ static int __devinit i2o_pci_alloc(struct i2o_controller *c)
 
 /**
  *	i2o_pci_interrupt - Interrupt handler for I2O controller
- *	@irq: interrupt line
  *	@dev_id: pointer to the I2O controller
  *
  *	Handle an interrupt from a PCI based I2O controller. This turns out
  *	to be rather simple. We keep the controller pointer in the cookie.
  */
-static irqreturn_t i2o_pci_interrupt(int irq, void *dev_id)
+static irqreturn_t i2o_pci_interrupt(void *dev_id)
 {
 	struct i2o_controller *c = dev_id;
 	u32 m;
diff --git a/drivers/mfd/ucb1x00-core.c b/drivers/mfd/ucb1x00-core.c
index e03f1bc..817b7b0 100644
--- a/drivers/mfd/ucb1x00-core.c
+++ b/drivers/mfd/ucb1x00-core.c
@@ -203,7 +203,7 @@ void ucb1x00_adc_disable(struct ucb1x00 *ucb)
  * SIBCLK to talk to the chip.  We leave the clock running until
  * we have finished processing all interrupts from the chip.
  */
-static irqreturn_t ucb1x00_irq(int irqnr, void *devid)
+static irqreturn_t ucb1x00_irq(void *devid)
 {
 	struct ucb1x00 *ucb = devid;
 	struct ucb1x00_irq *irq;
diff --git a/drivers/misc/ibmasm/ibmasm.h b/drivers/misc/ibmasm/ibmasm.h
index de860bc..fd44241 100644
--- a/drivers/misc/ibmasm/ibmasm.h
+++ b/drivers/misc/ibmasm/ibmasm.h
@@ -196,7 +196,7 @@ int ibmasm_send_os_state(struct service_processor *sp, int os_state);
 
 /* low level message processing */
 int ibmasm_send_i2o_message(struct service_processor *sp);
-irqreturn_t ibmasm_interrupt_handler(int irq, void * dev_id);
+irqreturn_t ibmasm_interrupt_handler(void * dev_id);
 
 /* remote console */
 void ibmasm_handle_mouse_interrupt(struct service_processor *sp);
diff --git a/drivers/misc/ibmasm/lowlevel.c b/drivers/misc/ibmasm/lowlevel.c
index 4b2398e..a112f54 100644
--- a/drivers/misc/ibmasm/lowlevel.c
+++ b/drivers/misc/ibmasm/lowlevel.c
@@ -54,7 +54,7 @@ int ibmasm_send_i2o_message(struct service_processor *sp)
 	return 0;
 }
 
-irqreturn_t ibmasm_interrupt_handler(int irq, void * dev_id)
+irqreturn_t ibmasm_interrupt_handler(void *dev_id)
 {
 	u32	mfa;
 	struct service_processor *sp = (struct service_processor *)dev_id;
diff --git a/drivers/misc/phantom.c b/drivers/misc/phantom.c
index 5108b7c..ab36eb8 100644
--- a/drivers/misc/phantom.c
+++ b/drivers/misc/phantom.c
@@ -217,7 +217,7 @@ static struct file_operations phantom_file_ops = {
 	.poll = phantom_poll,
 };
 
-static irqreturn_t phantom_isr(int irq, void *data)
+static irqreturn_t phantom_isr(void *data)
 {
 	struct phantom_device *dev = data;
 
diff --git a/drivers/misc/sony-laptop.c b/drivers/misc/sony-laptop.c
index e73a71f..2debd98 100644
--- a/drivers/misc/sony-laptop.c
+++ b/drivers/misc/sony-laptop.c
@@ -2259,7 +2259,7 @@ end:
  * ISR: some event is available
  *
  *****************/
-static irqreturn_t sony_pic_irq(int irq, void *dev_id)
+static irqreturn_t sony_pic_irq(void *dev_id)
 {
 	int i, j;
 	u8 ev = 0;
diff --git a/drivers/misc/tifm_7xx1.c b/drivers/misc/tifm_7xx1.c
index 2d1b3df..a1a6783 100644
--- a/drivers/misc/tifm_7xx1.c
+++ b/drivers/misc/tifm_7xx1.c
@@ -36,7 +36,7 @@ static void tifm_7xx1_eject(struct tifm_adapter *fm, struct tifm_dev *sock)
 	spin_unlock_irqrestore(&fm->lock, flags);
 }
 
-static irqreturn_t tifm_7xx1_isr(int irq, void *dev_id)
+static irqreturn_t tifm_7xx1_isr(void *dev_id)
 {
 	struct tifm_adapter *fm = dev_id;
 	struct tifm_dev *sock;
diff --git a/drivers/mmc/host/at91_mci.c b/drivers/mmc/host/at91_mci.c
index 7a452c2..570a8d2 100644
--- a/drivers/mmc/host/at91_mci.c
+++ b/drivers/mmc/host/at91_mci.c
@@ -672,7 +672,7 @@ static void at91_mci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 /*
  * Handle an interrupt
  */
-static irqreturn_t at91_mci_irq(int irq, void *devid)
+static irqreturn_t at91_mci_irq(void *devid)
 {
 	struct at91mci_host *host = devid;
 	int completed = 0;
diff --git a/drivers/mmc/host/au1xmmc.c b/drivers/mmc/host/au1xmmc.c
index 92c4d0d..b4d7c4d 100644
--- a/drivers/mmc/host/au1xmmc.c
+++ b/drivers/mmc/host/au1xmmc.c
@@ -731,7 +731,7 @@ static void au1xmmc_set_ios(struct mmc_host* mmc, struct mmc_ios* ios)
 	}
 }
 
-static void au1xmmc_dma_callback(int irq, void *dev_id)
+static void au1xmmc_dma_callback(void *dev_id)
 {
 	struct au1xmmc_host *host = (struct au1xmmc_host *) dev_id;
 
@@ -750,7 +750,7 @@ static void au1xmmc_dma_callback(int irq, void *dev_id)
 #define STATUS_DATA_IN  (SD_STATUS_NE)
 #define STATUS_DATA_OUT (SD_STATUS_TH)
 
-static irqreturn_t au1xmmc_irq(int irq, void *dev_id)
+static irqreturn_t au1xmmc_irq(void *dev_id)
 {
 
 	u32 status;
diff --git a/drivers/mmc/host/imxmmc.c b/drivers/mmc/host/imxmmc.c
index 6ebc41e..e4adae6 100644
--- a/drivers/mmc/host/imxmmc.c
+++ b/drivers/mmc/host/imxmmc.c
@@ -650,7 +650,7 @@ static void imxmci_dma_irq(int dma, void *devid)
 	tasklet_schedule(&host->tasklet);
 }
 
-static irqreturn_t imxmci_irq(int irq, void *devid)
+static irqreturn_t imxmci_irq(void *devid)
 {
 	struct imxmci_host *host = devid;
 	uint32_t stat = MMC_STATUS;
diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index d0eb0a2..fe55ed9 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -265,7 +265,7 @@ static int mmci_pio_write(struct mmci_host *host, char *buffer, unsigned int rem
 /*
  * PIO data transfer IRQ handler.
  */
-static irqreturn_t mmci_pio_irq(int irq, void *dev_id)
+static irqreturn_t mmci_pio_irq(void *dev_id)
 {
 	struct mmci_host *host = dev_id;
 	void __iomem *base = host->base;
@@ -351,7 +351,7 @@ static irqreturn_t mmci_pio_irq(int irq, void *dev_id)
 /*
  * Handle completion of command and data transfers.
  */
-static irqreturn_t mmci_irq(int irq, void *dev_id)
+static irqreturn_t mmci_irq(void *dev_id)
 {
 	struct mmci_host *host = dev_id;
 	u32 status;
diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index 60a67df..ebb6b71 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -430,7 +430,7 @@ static inline void mmc_omap_report_irq(u16 status)
 		}
 }
 
-static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
+static irqreturn_t mmc_omap_irq(void *dev_id)
 {
 	struct mmc_omap_host * host = (struct mmc_omap_host *)dev_id;
 	u16 status;
@@ -549,7 +549,7 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t mmc_omap_switch_irq(int irq, void *dev_id)
+static irqreturn_t mmc_omap_switch_irq(void *dev_id)
 {
 	struct mmc_omap_host *host = (struct mmc_omap_host *) dev_id;
 
diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
index 0601e01..23f170b 100644
--- a/drivers/mmc/host/pxamci.c
+++ b/drivers/mmc/host/pxamci.c
@@ -299,7 +299,7 @@ static int pxamci_data_done(struct pxamci_host *host, unsigned int stat)
 	return 1;
 }
 
-static irqreturn_t pxamci_irq(int irq, void *devid)
+static irqreturn_t pxamci_irq(void *devid)
 {
 	struct pxamci_host *host = devid;
 	unsigned int ireg;
@@ -442,7 +442,7 @@ static void pxamci_dma_irq(int dma, void *devid)
 	}
 }
 
-static irqreturn_t pxamci_detect_irq(int irq, void *devid)
+static irqreturn_t pxamci_detect_irq(void *devid)
 {
 	struct pxamci_host *host = mmc_priv(devid);
 
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index b397121..611a594 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1033,7 +1033,7 @@ static void sdhci_data_irq(struct sdhci_host *host, u32 intmask)
 	}
 }
 
-static irqreturn_t sdhci_irq(int irq, void *dev_id)
+static irqreturn_t sdhci_irq(void *dev_id)
 {
 	irqreturn_t result;
 	struct sdhci_host* host = dev_id;
diff --git a/drivers/mmc/host/wbsd.c b/drivers/mmc/host/wbsd.c
index 80db11c..9265942 100644
--- a/drivers/mmc/host/wbsd.c
+++ b/drivers/mmc/host/wbsd.c
@@ -1153,7 +1153,7 @@ end:
  * Interrupt handling
  */
 
-static irqreturn_t wbsd_irq(int irq, void *dev_id)
+static irqreturn_t wbsd_irq(void *dev_id)
 {
 	struct wbsd_host *host = dev_id;
 	int isr;
diff --git a/drivers/mtd/nand/cafe_nand.c b/drivers/mtd/nand/cafe_nand.c
index 1e81171..fd4eb89 100644
--- a/drivers/mtd/nand/cafe_nand.c
+++ b/drivers/mtd/nand/cafe_nand.c
@@ -323,7 +323,7 @@ static void cafe_select_chip(struct mtd_info *mtd, int chipnr)
 		cafe->ctl1 &= ~CTRL1_CHIPSELECT;
 }
 
-static int cafe_nand_interrupt(int irq, void *id)
+static int cafe_nand_interrupt(void *id)
 {
 	struct mtd_info *mtd = id;
 	struct cafe_priv *cafe = mtd->priv;
diff --git a/drivers/parisc/dino.c b/drivers/parisc/dino.c
index 03c763c..d1e80f3 100644
--- a/drivers/parisc/dino.c
+++ b/drivers/parisc/dino.c
@@ -368,7 +368,7 @@ static struct hw_interrupt_type dino_interrupt_type = {
  * ilr_loop counter is a kluge to prevent a "stuck" IRQ line from
  * wedging the CPU. Could be removed or made optional at some point.
  */
-static irqreturn_t dino_isr(int irq, void *intr_dev)
+static irqreturn_t dino_isr(void *intr_dev)
 {
 	struct dino_device *dino_dev = intr_dev;
 	u32 mask;
diff --git a/drivers/parisc/eisa.c b/drivers/parisc/eisa.c
index 771cef5..43a7523 100644
--- a/drivers/parisc/eisa.c
+++ b/drivers/parisc/eisa.c
@@ -198,7 +198,7 @@ static struct hw_interrupt_type eisa_interrupt_type = {
 	.end =		no_end_irq,
 };
 
-static irqreturn_t eisa_irq(int wax_irq, void *intr_dev)
+static irqreturn_t eisa_irq(void *intr_dev)
 {
 	int irq = gsc_readb(0xfc01f000); /* EISA supports 16 irqs */
 	unsigned long flags;
diff --git a/drivers/parisc/gsc.c b/drivers/parisc/gsc.c
index 1b3e3fd..e4e9476 100644
--- a/drivers/parisc/gsc.c
+++ b/drivers/parisc/gsc.c
@@ -73,7 +73,7 @@ EXPORT_SYMBOL(gsc_alloc_irq);
 EXPORT_SYMBOL(gsc_claim_irq);
 
 /* Common interrupt demultiplexer used by Asp, Lasi & Wax.  */
-irqreturn_t gsc_asic_intr(int gsc_asic_irq, void *dev)
+irqreturn_t gsc_asic_intr(void *dev)
 {
 	unsigned long irr;
 	struct gsc_asic *gsc_asic = dev;
diff --git a/drivers/parisc/gsc.h b/drivers/parisc/gsc.h
index 762a1ba..fa5a906 100644
--- a/drivers/parisc/gsc.h
+++ b/drivers/parisc/gsc.h
@@ -44,4 +44,4 @@ void gsc_fixup_irqs(struct parisc_device *parent, void *ctrl,
 		void (*choose)(struct parisc_device *child, void *ctrl));
 void gsc_asic_assign_irq(struct gsc_asic *asic, int local_irq, int *irqp);
 
-irqreturn_t gsc_asic_intr(int irq, void *dev);
+irqreturn_t gsc_asic_intr(void *dev);
diff --git a/drivers/parisc/superio.c b/drivers/parisc/superio.c
index 38cdf9f..82f9793 100644
--- a/drivers/parisc/superio.c
+++ b/drivers/parisc/superio.c
@@ -95,7 +95,7 @@ static struct superio_device sio_dev;
 #define PFX	SUPERIO ": "
 
 static irqreturn_t
-superio_interrupt(int parent_irq, void *devp)
+superio_interrupt(void *devp)
 {
 	u8 results;
 	u8 local_irq;
diff --git a/drivers/pci/hotplug/cpci_hotplug_core.c b/drivers/pci/hotplug/cpci_hotplug_core.c
index ed4d44e..cccfcf9 100644
--- a/drivers/pci/hotplug/cpci_hotplug_core.c
+++ b/drivers/pci/hotplug/cpci_hotplug_core.c
@@ -342,7 +342,7 @@ cpci_hp_unregister_bus(struct pci_bus *bus)
 
 /* This is the interrupt mode interrupt handler */
 static irqreturn_t
-cpci_hp_intr(int irq, void *data)
+cpci_hp_intr(void *data)
 {
 	dbg("entered cpci_hp_intr");
 
diff --git a/drivers/pci/hotplug/cpqphp.h b/drivers/pci/hotplug/cpqphp.h
index 298ad7f..1200f1a 100644
--- a/drivers/pci/hotplug/cpqphp.h
+++ b/drivers/pci/hotplug/cpqphp.h
@@ -408,7 +408,7 @@ extern void cpqhp_remove_debugfs_files		(struct controller *ctrl);
 
 /* controller functions */
 extern void	cpqhp_pushbutton_thread		(unsigned long event_pointer);
-extern irqreturn_t cpqhp_ctrl_intr		(int IRQ, void *data);
+extern irqreturn_t cpqhp_ctrl_intr		(void *data);
 extern int	cpqhp_find_available_resources	(struct controller *ctrl, void __iomem *rom_start);
 extern int	cpqhp_event_start_thread	(void);
 extern void	cpqhp_event_stop_thread		(void);
diff --git a/drivers/pci/hotplug/cpqphp_ctrl.c b/drivers/pci/hotplug/cpqphp_ctrl.c
index 3ef0a48..b0dbe52 100644
--- a/drivers/pci/hotplug/cpqphp_ctrl.c
+++ b/drivers/pci/hotplug/cpqphp_ctrl.c
@@ -877,7 +877,7 @@ int cpqhp_resource_sort_and_combine(struct pci_resource **head)
 }
 
 
-irqreturn_t cpqhp_ctrl_intr(int IRQ, void *data)
+irqreturn_t cpqhp_ctrl_intr(void *data)
 {
 	struct controller *ctrl = data;
 	u8 schedule_flag = 0;
diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index 06d025b..afad9e6 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -190,7 +190,7 @@ static inline int pciehp_writel(struct controller *ctrl, int reg, u32 value)
 #define EMI_STATE		0x0080
 #define EMI_STATUS_BIT		7
 
-static irqreturn_t pcie_isr(int irq, void *dev_id);
+static irqreturn_t pcie_isr(void *dev_id);
 static void start_int_poll_timer(struct controller *ctrl, int sec);
 
 /* This is the interrupt polling timeout function. */
@@ -199,7 +199,7 @@ static void int_poll_timeout(unsigned long data)
 	struct controller *ctrl = (struct controller *)data;
 
 	/* Poll for interrupt events.  regs == NULL => polling */
-	pcie_isr(0, ctrl);
+	pcie_isr(ctrl);
 
 	init_timer(&ctrl->poll_timer);
 	if (!pciehp_poll_time)
@@ -677,7 +677,7 @@ static int hpc_power_off_slot(struct slot * slot)
 	return retval;
 }
 
-static irqreturn_t pcie_isr(int irq, void *dev_id)
+static irqreturn_t pcie_isr(void *dev_id)
 {
 	struct controller *ctrl = (struct controller *)dev_id;
 	u16 slot_status, intr_detect, intr_loc;
diff --git a/drivers/pci/hotplug/shpchp_hpc.c b/drivers/pci/hotplug/shpchp_hpc.c
index 5183a45..2c56914 100644
--- a/drivers/pci/hotplug/shpchp_hpc.c
+++ b/drivers/pci/hotplug/shpchp_hpc.c
@@ -181,7 +181,7 @@
 
 static atomic_t shpchp_num_controllers = ATOMIC_INIT(0);
 
-static irqreturn_t shpc_isr(int irq, void *dev_id);
+static irqreturn_t shpc_isr(void *dev_id);
 static void start_int_poll_timer(struct controller *ctrl, int sec);
 static int hpc_check_cmd_status(struct controller *ctrl);
 
@@ -236,7 +236,7 @@ static void int_poll_timeout(unsigned long data)
 	struct controller *ctrl = (struct controller *)data;
 
 	/* Poll for interrupt events.  regs == NULL => polling */
-	shpc_isr(0, ctrl);
+	shpc_isr(ctrl);
 
 	init_timer(&ctrl->poll_timer);
 	if (!shpchp_poll_time)
@@ -724,7 +724,7 @@ static int hpc_set_bus_speed_mode(struct slot * slot, enum pci_bus_speed value)
 	return retval;
 }
 
-static irqreturn_t shpc_isr(int irq, void *dev_id)
+static irqreturn_t shpc_isr(void *dev_id)
 {
 	struct controller *ctrl = (struct controller *)dev_id;
 	u32 serr_int, slot_reg, intr_loc, intr_loc2;
diff --git a/drivers/pci/pcie/aer/aerdrv.c b/drivers/pci/pcie/aer/aerdrv.c
index 7a62f7d..411c975 100644
--- a/drivers/pci/pcie/aer/aerdrv.c
+++ b/drivers/pci/pcie/aer/aerdrv.c
@@ -90,12 +90,11 @@ void pci_no_aer(void)
 
 /**
  * aer_irq - Root Port's ISR
- * @irq: IRQ assigned to Root Port
  * @context: pointer to Root Port data structure
  *
  * Invoked when Root Port detects AER messages.
  **/
-static irqreturn_t aer_irq(int irq, void *context)
+static irqreturn_t aer_irq(void *context)
 {
 	unsigned int status, id;
 	struct pcie_device *pdev = (struct pcie_device *)context;
diff --git a/drivers/pcmcia/at91_cf.c b/drivers/pcmcia/at91_cf.c
index eb6abd3..5a1eb99 100644
--- a/drivers/pcmcia/at91_cf.c
+++ b/drivers/pcmcia/at91_cf.c
@@ -66,7 +66,7 @@ static int at91_cf_ss_init(struct pcmcia_socket *s)
 	return 0;
 }
 
-static irqreturn_t at91_cf_irq(int irq, void *_cf)
+static irqreturn_t at91_cf_irq(void *_cf)
 {
 	struct at91_cf_socket *cf = _cf;
 
diff --git a/drivers/pcmcia/hd64465_ss.c b/drivers/pcmcia/hd64465_ss.c
index f2e810f..8c98066 100644
--- a/drivers/pcmcia/hd64465_ss.c
+++ b/drivers/pcmcia/hd64465_ss.c
@@ -648,7 +648,7 @@ static int hs_set_mem_map(struct pcmcia_socket *s, struct pccard_mem_map *mem)
  * mapping the IREQ request from the card to a standard Linux
  * IRQ, as requested by SocketServices.
  */
-static int hs_irq_demux(int irq, void *dev)
+static int hs_irq_demux(void *dev)
 {
     	hs_socket_t *sp = dev;
 	u_int cscr;
@@ -671,7 +671,7 @@ static int hs_irq_demux(int irq, void *dev)
  * Interrupt handling routine.
  */
  
-static irqreturn_t hs_interrupt(int irq, void *dev)
+static irqreturn_t hs_interrupt(void *dev)
 {
     	hs_socket_t *sp = dev;
 	u_int events = 0;
diff --git a/drivers/pcmcia/i82092.c b/drivers/pcmcia/i82092.c
index df21e2d..31f651b 100644
--- a/drivers/pcmcia/i82092.c
+++ b/drivers/pcmcia/i82092.c
@@ -319,7 +319,7 @@ static int to_cycles(int ns)
 
 /* Interrupt handler functionality */
 
-static irqreturn_t i82092aa_interrupt(int irq, void *dev)
+static irqreturn_t i82092aa_interrupt(void *dev)
 {
 	int i;
 	int loopcount = 0;
diff --git a/drivers/pcmcia/i82092aa.h b/drivers/pcmcia/i82092aa.h
index b0d4533..709b84a 100644
--- a/drivers/pcmcia/i82092aa.h
+++ b/drivers/pcmcia/i82092aa.h
@@ -23,7 +23,7 @@
 static int  i82092aa_pci_probe(struct pci_dev *dev, const struct pci_device_id *id);
 static void i82092aa_pci_remove(struct pci_dev *dev);
 static int card_present(int socketno);
-static irqreturn_t i82092aa_interrupt(int irq, void *dev);
+static irqreturn_t i82092aa_interrupt(void *dev);
 
 
 
diff --git a/drivers/pcmcia/m32r_cfc.c b/drivers/pcmcia/m32r_cfc.c
index 91da15b..7ead634 100644
--- a/drivers/pcmcia/m32r_cfc.c
+++ b/drivers/pcmcia/m32r_cfc.c
@@ -371,7 +371,7 @@ static void add_pcc_socket(ulong base, int irq, ulong mapaddr, kio_addr_t ioaddr
 
 /*====================================================================*/
 
-static irqreturn_t pcc_interrupt(int irq, void *dev)
+static irqreturn_t pcc_interrupt(void *dev)
 {
 	int i;
 	u_int events = 0;
diff --git a/drivers/pcmcia/m32r_pcc.c b/drivers/pcmcia/m32r_pcc.c
index 67d28ee..9ae6311 100644
--- a/drivers/pcmcia/m32r_pcc.c
+++ b/drivers/pcmcia/m32r_pcc.c
@@ -266,7 +266,7 @@ static pcc_t pcc[] = {
 	{ "xnux2", 0 }, { "xnux2", 0 },
 };
 
-static irqreturn_t pcc_interrupt(int, void *);
+static irqreturn_t pcc_interrupt(void *);
 
 /*====================================================================*/
 
@@ -351,7 +351,7 @@ static void add_pcc_socket(ulong base, int irq, ulong mapaddr, kio_addr_t ioaddr
 
 /*====================================================================*/
 
-static irqreturn_t pcc_interrupt(int irq, void *dev)
+static irqreturn_t pcc_interrupt(void *dev)
 {
 	int i, j, irc;
 	u_int events, active;
diff --git a/drivers/pcmcia/m8xx_pcmcia.c b/drivers/pcmcia/m8xx_pcmcia.c
index b019854..bdc67f8 100644
--- a/drivers/pcmcia/m8xx_pcmcia.c
+++ b/drivers/pcmcia/m8xx_pcmcia.c
@@ -262,7 +262,7 @@ static const u32 m8xx_size_to_gray[M8XX_SIZES_NO] = {
 
 /* ------------------------------------------------------------------------- */
 
-static irqreturn_t m8xx_interrupt(int irq, void *dev);
+static irqreturn_t m8xx_interrupt(void *dev);
 
 #define PCMCIA_BMT_LIMIT (15*4)	/* Bus Monitor Timeout value */
 
@@ -559,7 +559,7 @@ static int voltage_set(int slot, int vcc, int vpp)
 static u32 pending_events[PCMCIA_SOCKETS_NO];
 static DEFINE_SPINLOCK(pending_event_lock);
 
-static irqreturn_t m8xx_interrupt(int irq, void *dev)
+static irqreturn_t m8xx_interrupt(void *dev)
 {
 	struct socket_info *s;
 	struct event_table *e;
diff --git a/drivers/pcmcia/omap_cf.c b/drivers/pcmcia/omap_cf.c
index 2df216b..59b3a95 100644
--- a/drivers/pcmcia/omap_cf.c
+++ b/drivers/pcmcia/omap_cf.c
@@ -101,7 +101,7 @@ static void omap_cf_timer(unsigned long _cf)
  * claim the card's IRQ.  It may also detect some card insertions, but
  * not removals; it can't always eliminate timer irqs.
  */
-static irqreturn_t omap_cf_irq(int irq, void *_cf)
+static irqreturn_t omap_cf_irq(void *_cf)
 {
 	omap_cf_timer((unsigned long)_cf);
 	return IRQ_HANDLED;
diff --git a/drivers/pcmcia/pcmcia_resource.c b/drivers/pcmcia/pcmcia_resource.c
index 0ce39de..09fe356 100644
--- a/drivers/pcmcia/pcmcia_resource.c
+++ b/drivers/pcmcia/pcmcia_resource.c
@@ -783,7 +783,7 @@ EXPORT_SYMBOL(pcmcia_request_io);
  */
 
 #ifdef CONFIG_PCMCIA_PROBE
-static irqreturn_t test_action(int cpl, void *dev_id)
+static irqreturn_t test_action(void *dev_id)
 {
 	return IRQ_NONE;
 }
diff --git a/drivers/pcmcia/pd6729.c b/drivers/pcmcia/pd6729.c
index abc10fe..d51ab87 100644
--- a/drivers/pcmcia/pd6729.c
+++ b/drivers/pcmcia/pd6729.c
@@ -182,7 +182,7 @@ static void indirect_write16(struct pd6729_socket *socket, unsigned short reg,
 
 /* Interrupt handler functionality */
 
-static irqreturn_t pd6729_interrupt(int irq, void *dev)
+static irqreturn_t pd6729_interrupt(void *dev)
 {
 	struct pd6729_socket *socket = (struct pd6729_socket *)dev;
 	int i;
@@ -249,7 +249,7 @@ static void pd6729_interrupt_wrapper(unsigned long data)
 {
 	struct pd6729_socket *socket = (struct pd6729_socket *) data;
 
-	pd6729_interrupt(0, (void *)socket);
+	pd6729_interrupt(socket);
 	mod_timer(&socket->poll_timer, jiffies + HZ);
 }
 
@@ -575,7 +575,7 @@ static struct pccard_operations pd6729_operations = {
 	.set_mem_map		= pd6729_set_mem_map,
 };
 
-static irqreturn_t pd6729_test(int irq, void *dev)
+static irqreturn_t pd6729_test(void *dev)
 {
 	dprintk("-> hit on irq %d\n", irq);
 	return IRQ_HANDLED;
diff --git a/drivers/pcmcia/soc_common.c b/drivers/pcmcia/soc_common.c
index aa7779d..1e2eee6 100644
--- a/drivers/pcmcia/soc_common.c
+++ b/drivers/pcmcia/soc_common.c
@@ -256,7 +256,7 @@ static void soc_common_pcmcia_poll_event(unsigned long dummy)
  * handling code performs scheduling operations which cannot be
  * executed from within an interrupt context.
  */
-static irqreturn_t soc_common_pcmcia_interrupt(int irq, void *dev)
+static irqreturn_t soc_common_pcmcia_interrupt(void *dev)
 {
 	struct soc_pcmcia_socket *skt = dev;
 
diff --git a/drivers/pcmcia/vrc4171_card.c b/drivers/pcmcia/vrc4171_card.c
index eee2f1c..ca2785e 100644
--- a/drivers/pcmcia/vrc4171_card.c
+++ b/drivers/pcmcia/vrc4171_card.c
@@ -513,7 +513,7 @@ static inline unsigned int get_events(int slot)
 	return events;
 }
 
-static irqreturn_t pccard_interrupt(int irq, void *dev_id)
+static irqreturn_t pccard_interrupt(void *dev_id)
 {
 	vrc4171_socket_t *socket;
 	unsigned int events;
diff --git a/drivers/pcmcia/vrc4173_cardu.c b/drivers/pcmcia/vrc4173_cardu.c
index 812f038..491bbb4 100644
--- a/drivers/pcmcia/vrc4173_cardu.c
+++ b/drivers/pcmcia/vrc4173_cardu.c
@@ -440,7 +440,7 @@ static uint16_t get_events(vrc4173_socket_t *socket)
 	return events;
 }
 
-static void cardu_interrupt(int irq, void *dev_id)
+static void cardu_interrupt(void *dev_id)
 {
 	vrc4173_socket_t *socket = (vrc4173_socket_t *)dev_id;
 	uint16_t events;
diff --git a/drivers/pcmcia/yenta_socket.c b/drivers/pcmcia/yenta_socket.c
index 20853a0..a4e9f91 100644
--- a/drivers/pcmcia/yenta_socket.c
+++ b/drivers/pcmcia/yenta_socket.c
@@ -441,7 +441,7 @@ static int yenta_set_mem_map(struct pcmcia_socket *sock, struct pccard_mem_map *
 
 
 
-static irqreturn_t yenta_interrupt(int irq, void *dev_id)
+static irqreturn_t yenta_interrupt(void *dev_id)
 {
 	unsigned int events;
 	struct yenta_socket *socket = (struct yenta_socket *) dev_id;
@@ -477,7 +477,7 @@ static void yenta_interrupt_wrapper(unsigned long data)
 {
 	struct yenta_socket *socket = (struct yenta_socket *) data;
 
-	yenta_interrupt(0, (void *)socket);
+	yenta_interrupt(socket);
 	socket->poll_timer.expires = jiffies + HZ;
 	add_timer(&socket->poll_timer);
 }
@@ -895,7 +895,7 @@ static unsigned int yenta_probe_irq(struct yenta_socket *socket, u32 isa_irq_mas
 #ifdef CONFIG_YENTA_TI
 
 /* interrupt handler, only used during probing */
-static irqreturn_t yenta_probe_handler(int irq, void *dev_id)
+static irqreturn_t yenta_probe_handler(void *dev_id)
 {
 	struct yenta_socket *socket = (struct yenta_socket *) dev_id;
 	u8 csc;
diff --git a/drivers/pnp/resource.c b/drivers/pnp/resource.c
index 41d73a5..d0c1811 100644
--- a/drivers/pnp/resource.c
+++ b/drivers/pnp/resource.c
@@ -329,7 +329,7 @@ int pnp_check_mem(struct pnp_dev *dev, int idx)
 	return 1;
 }
 
-static irqreturn_t pnp_test_handler(int irq, void *dev_id)
+static irqreturn_t pnp_test_handler(void *dev_id)
 {
 	return IRQ_HANDLED;
 }
diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
index c058f28..6bd215f 100644
--- a/drivers/power/pda_power.c
+++ b/drivers/power/pda_power.c
@@ -117,7 +117,7 @@ static void charger_timer_func(unsigned long power_supply_ptr)
 		  jiffies + msecs_to_jiffies(pdata->wait_for_charger));
 }
 
-static irqreturn_t power_changed_isr(int irq, void *power_supply)
+static irqreturn_t power_changed_isr(void *power_supply)
 {
 	/* Wait a bit before reading ac/usb line status and setting charger,
 	 * because ac/usb status readings may lag from irq. */
diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index e3fe83a..e2812b0 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -394,7 +394,7 @@ static const struct rtc_class_ops cmos_rtc_ops = {
 
 static struct cmos_rtc	cmos_rtc;
 
-static irqreturn_t cmos_interrupt(int irq, void *p)
+static irqreturn_t cmos_interrupt(void *p)
 {
 	u8		irqstat;
 
diff --git a/drivers/rtc/rtc-ds1553.c b/drivers/rtc/rtc-ds1553.c
index bb53c09..429bf98 100644
--- a/drivers/rtc/rtc-ds1553.c
+++ b/drivers/rtc/rtc-ds1553.c
@@ -189,7 +189,7 @@ static int ds1553_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	return 0;
 }
 
-static irqreturn_t ds1553_rtc_interrupt(int irq, void *dev_id)
+static irqreturn_t ds1553_rtc_interrupt(void *dev_id)
 {
 	struct platform_device *pdev = dev_id;
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
diff --git a/drivers/rtc/rtc-m48t59.c b/drivers/rtc/rtc-m48t59.c
index bf60d35..cedcf9e 100644
--- a/drivers/rtc/rtc-m48t59.c
+++ b/drivers/rtc/rtc-m48t59.c
@@ -281,7 +281,7 @@ static int m48t59_rtc_proc(struct device *dev, struct seq_file *seq)
 /*
  * IRQ handler for the RTC
  */
-static irqreturn_t m48t59_rtc_interrupt(int irq, void *dev_id)
+static irqreturn_t m48t59_rtc_interrupt(void *dev_id)
 {
 	struct device *dev = (struct device *)dev_id;
 	struct platform_device *pdev = to_platform_device(dev);
diff --git a/drivers/rtc/rtc-pl031.c b/drivers/rtc/rtc-pl031.c
index e4bf68c..b6359f8 100644
--- a/drivers/rtc/rtc-pl031.c
+++ b/drivers/rtc/rtc-pl031.c
@@ -47,7 +47,7 @@ struct pl031_local {
 	void __iomem *base;
 };
 
-static irqreturn_t pl031_interrupt(int irq, void *dev_id)
+static irqreturn_t pl031_interrupt(void *dev_id)
 {
 	struct rtc_device *rtc = dev_id;
 
diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
index 8c1012b..1505d36 100644
--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -46,7 +46,7 @@ static unsigned int tick_count;
 
 /* IRQ Handlers */
 
-static irqreturn_t s3c_rtc_alarmirq(int irq, void *id)
+static irqreturn_t s3c_rtc_alarmirq(void *id)
 {
 	struct rtc_device *rdev = id;
 
@@ -54,7 +54,7 @@ static irqreturn_t s3c_rtc_alarmirq(int irq, void *id)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t s3c_rtc_tickirq(int irq, void *id)
+static irqreturn_t s3c_rtc_tickirq(void *id)
 {
 	struct rtc_device *rdev = id;
 
diff --git a/drivers/rtc/rtc-sa1100.c b/drivers/rtc/rtc-sa1100.c
index 0918b78..85b17a5 100644
--- a/drivers/rtc/rtc-sa1100.c
+++ b/drivers/rtc/rtc-sa1100.c
@@ -68,7 +68,7 @@ static int rtc_update_alarm(struct rtc_time *alrm)
 	return ret;
 }
 
-static irqreturn_t sa1100_rtc_interrupt(int irq, void *dev_id)
+static irqreturn_t sa1100_rtc_interrupt(void *dev_id)
 {
 	struct platform_device *pdev = to_platform_device(dev_id);
 	struct rtc_device *rtc = platform_get_drvdata(pdev);
@@ -105,7 +105,7 @@ static irqreturn_t sa1100_rtc_interrupt(int irq, void *dev_id)
 
 static int rtc_timer1_count;
 
-static irqreturn_t timer1_interrupt(int irq, void *dev_id)
+static irqreturn_t timer1_interrupt(void *dev_id)
 {
 	struct platform_device *pdev = to_platform_device(dev_id);
 	struct rtc_device *rtc = platform_get_drvdata(pdev);
diff --git a/drivers/rtc/rtc-sh.c b/drivers/rtc/rtc-sh.c
index 78277a1..22500da 100644
--- a/drivers/rtc/rtc-sh.c
+++ b/drivers/rtc/rtc-sh.c
@@ -86,7 +86,7 @@ struct sh_rtc {
 	unsigned long capabilities;	/* See asm-sh/rtc.h for cap bits */
 };
 
-static irqreturn_t sh_rtc_interrupt(int irq, void *dev_id)
+static irqreturn_t sh_rtc_interrupt(void *dev_id)
 {
 	struct platform_device *pdev = to_platform_device(dev_id);
 	struct sh_rtc *rtc = platform_get_drvdata(pdev);
@@ -115,7 +115,7 @@ static irqreturn_t sh_rtc_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t sh_rtc_alarm(int irq, void *dev_id)
+static irqreturn_t sh_rtc_alarm(void *dev_id)
 {
 	struct platform_device *pdev = to_platform_device(dev_id);
 	struct sh_rtc *rtc = platform_get_drvdata(pdev);
@@ -150,7 +150,7 @@ static irqreturn_t sh_rtc_alarm(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t sh_rtc_periodic(int irq, void *dev_id)
+static irqreturn_t sh_rtc_periodic(void *dev_id)
 {
 	struct platform_device *pdev = to_platform_device(dev_id);
 	struct sh_rtc *rtc = platform_get_drvdata(pdev);
diff --git a/drivers/rtc/rtc-stk17ta8.c b/drivers/rtc/rtc-stk17ta8.c
index 8288b6b..0e98f29 100644
--- a/drivers/rtc/rtc-stk17ta8.c
+++ b/drivers/rtc/rtc-stk17ta8.c
@@ -197,7 +197,7 @@ static int stk17ta8_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	return 0;
 }
 
-static irqreturn_t stk17ta8_rtc_interrupt(int irq, void *dev_id)
+static irqreturn_t stk17ta8_rtc_interrupt(void *dev_id)
 {
 	struct platform_device *pdev = dev_id;
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
diff --git a/drivers/rtc/rtc-vr41xx.c b/drivers/rtc/rtc-vr41xx.c
index ce2f78d..8dfbad8 100644
--- a/drivers/rtc/rtc-vr41xx.c
+++ b/drivers/rtc/rtc-vr41xx.c
@@ -274,7 +274,7 @@ static int vr41xx_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long
 	return 0;
 }
 
-static irqreturn_t elapsedtime_interrupt(int irq, void *dev_id)
+static irqreturn_t elapsedtime_interrupt(void *dev_id)
 {
 	struct platform_device *pdev = (struct platform_device *)dev_id;
 	struct rtc_device *rtc = platform_get_drvdata(pdev);
@@ -286,7 +286,7 @@ static irqreturn_t elapsedtime_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t rtclong1_interrupt(int irq, void *dev_id)
+static irqreturn_t rtclong1_interrupt(void *dev_id)
 {
 	struct platform_device *pdev = (struct platform_device *)dev_id;
 	struct rtc_device *rtc = platform_get_drvdata(pdev);
diff --git a/drivers/sbus/char/bbc_i2c.c b/drivers/sbus/char/bbc_i2c.c
index ac8ef2c..988f534 100644
--- a/drivers/sbus/char/bbc_i2c.c
+++ b/drivers/sbus/char/bbc_i2c.c
@@ -332,7 +332,7 @@ EXPORT_SYMBOL(bbc_i2c_readb);
 EXPORT_SYMBOL(bbc_i2c_write_buf);
 EXPORT_SYMBOL(bbc_i2c_read_buf);
 
-static irqreturn_t bbc_i2c_interrupt(int irq, void *dev_id)
+static irqreturn_t bbc_i2c_interrupt(void *dev_id)
 {
 	struct bbc_i2c_bus *bp = dev_id;
 
diff --git a/drivers/sbus/char/cpwatchdog.c b/drivers/sbus/char/cpwatchdog.c
index 7b5773d..b926988 100644
--- a/drivers/sbus/char/cpwatchdog.c
+++ b/drivers/sbus/char/cpwatchdog.c
@@ -185,7 +185,7 @@ MODULE_SUPPORTED_DEVICE
 #ifdef WD_DEBUG
 static void wd_dumpregs(void);
 #endif
-static irqreturn_t wd_interrupt(int irq, void *dev_id);
+static irqreturn_t wd_interrupt(void *dev_id);
 static void wd_toggleintr(struct wd_timer* pTimer, int enable);
 static void wd_pingtimer(struct wd_timer* pTimer);
 static void wd_starttimer(struct wd_timer* pTimer);
@@ -444,7 +444,7 @@ static ssize_t wd_read(struct file * file, char __user *buffer,
 #endif /* ifdef WD_DEBUG */
 }
 
-static irqreturn_t wd_interrupt(int irq, void *dev_id)
+static irqreturn_t wd_interrupt(void *dev_id)
 {
 	/* Only WD0 will interrupt-- others are NMI and we won't
 	 * see them here....
diff --git a/drivers/sbus/char/uctrl.c b/drivers/sbus/char/uctrl.c
index 44d2ef9..5a1ed8d 100644
--- a/drivers/sbus/char/uctrl.c
+++ b/drivers/sbus/char/uctrl.c
@@ -216,7 +216,7 @@ uctrl_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static irqreturn_t uctrl_interrupt(int irq, void *dev_id)
+static irqreturn_t uctrl_interrupt(void *dev_id)
 {
 	struct uctrl_driver *driver = (struct uctrl_driver *)dev_id;
 	printk("in uctrl_interrupt\n");
diff --git a/drivers/serial/21285.c b/drivers/serial/21285.c
index facb678..d15c39e 100644
--- a/drivers/serial/21285.c
+++ b/drivers/serial/21285.c
@@ -85,7 +85,7 @@ static void serial21285_enable_ms(struct uart_port *port)
 {
 }
 
-static irqreturn_t serial21285_rx_chars(int irq, void *dev_id)
+static irqreturn_t serial21285_rx_chars(void *dev_id)
 {
 	struct uart_port *port = dev_id;
 	struct tty_struct *tty = port->info->tty;
@@ -123,7 +123,7 @@ static irqreturn_t serial21285_rx_chars(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t serial21285_tx_chars(int irq, void *dev_id)
+static irqreturn_t serial21285_tx_chars(void *dev_id)
 {
 	struct uart_port *port = dev_id;
 	struct circ_buf *xmit = &port->info->xmit;
diff --git a/drivers/serial/68328serial.c b/drivers/serial/68328serial.c
index aad4012..092bc5e 100644
--- a/drivers/serial/68328serial.c
+++ b/drivers/serial/68328serial.c
@@ -375,7 +375,7 @@ clear_and_return:
 /*
  * This is the serial driver's generic interrupt routine
  */
-irqreturn_t rs_interrupt(int irq, void *dev_id)
+irqreturn_t rs_interrupt(void *dev_id)
 {
 	struct m68k_serial * info;
 	m68328_uart *uart;
diff --git a/drivers/serial/amba-pl010.c b/drivers/serial/amba-pl010.c
index e88da72..8047dc6 100644
--- a/drivers/serial/amba-pl010.c
+++ b/drivers/serial/amba-pl010.c
@@ -230,7 +230,7 @@ static void pl010_modem_status(struct uart_amba_port *uap)
 	wake_up_interruptible(&uap->port.info->delta_msr_wait);
 }
 
-static irqreturn_t pl010_int(int irq, void *dev_id)
+static irqreturn_t pl010_int(void *dev_id)
 {
 	struct uart_amba_port *uap = dev_id;
 	unsigned int status, pass_counter = AMBA_ISR_PASS_LIMIT;
diff --git a/drivers/serial/amba-pl011.c b/drivers/serial/amba-pl011.c
index 72229df..fb11364 100644
--- a/drivers/serial/amba-pl011.c
+++ b/drivers/serial/amba-pl011.c
@@ -214,7 +214,7 @@ static void pl011_modem_status(struct uart_amba_port *uap)
 	wake_up_interruptible(&uap->port.info->delta_msr_wait);
 }
 
-static irqreturn_t pl011_int(int irq, void *dev_id)
+static irqreturn_t pl011_int(void *dev_id)
 {
 	struct uart_amba_port *uap = dev_id;
 	unsigned int status, pass_counter = AMBA_ISR_PASS_LIMIT;
diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index 4d6b3c5..ba3703d 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -358,7 +358,7 @@ static void atmel_tx_chars(struct uart_port *port)
 /*
  * Interrupt handler
  */
-static irqreturn_t atmel_interrupt(int irq, void *dev_id)
+static irqreturn_t atmel_interrupt(void *dev_id)
 {
 	struct uart_port *port = dev_id;
 	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *) port;
diff --git a/drivers/serial/clps711x.c b/drivers/serial/clps711x.c
index 2382718..ef4c6d7 100644
--- a/drivers/serial/clps711x.c
+++ b/drivers/serial/clps711x.c
@@ -93,7 +93,7 @@ static void clps711xuart_enable_ms(struct uart_port *port)
 {
 }
 
-static irqreturn_t clps711xuart_int_rx(int irq, void *dev_id)
+static irqreturn_t clps711xuart_int_rx(void *dev_id)
 {
 	struct uart_port *port = dev_id;
 	struct tty_struct *tty = port->info->tty;
@@ -147,7 +147,7 @@ static irqreturn_t clps711xuart_int_rx(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t clps711xuart_int_tx(int irq, void *dev_id)
+static irqreturn_t clps711xuart_int_tx(void *dev_id)
 {
 	struct uart_port *port = dev_id;
 	struct circ_buf *xmit = &port->info->xmit;
diff --git a/drivers/serial/cpm_uart/cpm_uart_core.c b/drivers/serial/cpm_uart/cpm_uart_core.c
index b5e4478..9a62717 100644
--- a/drivers/serial/cpm_uart/cpm_uart_core.c
+++ b/drivers/serial/cpm_uart/cpm_uart_core.c
@@ -377,7 +377,7 @@ static void cpm_uart_int_rx(struct uart_port *port)
 /*
  * Asynchron mode interrupt handler
  */
-static irqreturn_t cpm_uart_int(int irq, void *data)
+static irqreturn_t cpm_uart_int(void *data)
 {
 	u8 events;
 	struct uart_port *port = (struct uart_port *)data;
diff --git a/drivers/serial/crisv10.c b/drivers/serial/crisv10.c
index 7e8724d..868288c 100644
--- a/drivers/serial/crisv10.c
+++ b/drivers/serial/crisv10.c
@@ -2348,7 +2348,7 @@ start_receive(struct e100_serial *info)
 */
 
 static irqreturn_t
-tr_interrupt(int irq, void *dev_id)
+tr_interrupt(void *dev_id)
 {
 	struct e100_serial *info;
 	unsigned long ireg;
@@ -2397,7 +2397,7 @@ tr_interrupt(int irq, void *dev_id)
 /* dma input channel interrupt handler */
 
 static irqreturn_t
-rec_interrupt(int irq, void *dev_id)
+rec_interrupt(void *dev_id)
 {
 	struct e100_serial *info;
 	unsigned long ireg;
@@ -3011,7 +3011,7 @@ static void handle_ser_tx_interrupt(struct e100_serial *info)
  * ser_int duration: just sending: 8-15 us normally, up to 73 us
  */
 static irqreturn_t
-ser_interrupt(int irq, void *dev_id)
+ser_interrupt(void *dev_id)
 {
 	static volatile int tx_started = 0;
 	struct e100_serial *info;
diff --git a/drivers/serial/dz.c b/drivers/serial/dz.c
index d31721f..92b0bee 100644
--- a/drivers/serial/dz.c
+++ b/drivers/serial/dz.c
@@ -322,7 +322,7 @@ static inline void check_modem_status(struct dz_port *dport)
  * It deals with the multiple ports.
  * ------------------------------------------------------------
  */
-static irqreturn_t dz_interrupt(int irq, void *dev)
+static irqreturn_t dz_interrupt(void *dev)
 {
 	struct dz_port *dport = (struct dz_port *)dev;
 	unsigned short status;
diff --git a/drivers/serial/icom.c b/drivers/serial/icom.c
index 9d3105b..f665789 100644
--- a/drivers/serial/icom.c
+++ b/drivers/serial/icom.c
@@ -849,7 +849,7 @@ static void process_interrupt(u16 port_int_reg,
 	spin_unlock(&icom_port->uart_port.lock);
 }
 
-static irqreturn_t icom_interrupt(int irq, void *dev_id)
+static irqreturn_t icom_interrupt(void *dev_id)
 {
 	void __iomem * int_reg;
 	u32 adapter_interrupts;
diff --git a/drivers/serial/imx.c b/drivers/serial/imx.c
index dc19671..2c2625e 100644
--- a/drivers/serial/imx.c
+++ b/drivers/serial/imx.c
@@ -306,7 +306,7 @@ static void imx_start_tx(struct uart_port *port)
 		imx_transmit_buffer(sport);
 }
 
-static irqreturn_t imx_rtsint(int irq, void *dev_id)
+static irqreturn_t imx_rtsint(void *dev_id)
 {
 	struct imx_port *sport = (struct imx_port *)dev_id;
 	unsigned int val = readl(sport->port.membase + USR1) & USR1_RTSS;
@@ -322,7 +322,7 @@ static irqreturn_t imx_rtsint(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t imx_txint(int irq, void *dev_id)
+static irqreturn_t imx_txint(void *dev_id)
 {
 	struct imx_port *sport = (struct imx_port *)dev_id;
 	struct circ_buf *xmit = &sport->port.info->xmit;
@@ -351,7 +351,7 @@ out:
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t imx_rxint(int irq, void *dev_id)
+static irqreturn_t imx_rxint(void *dev_id)
 {
 	struct imx_port *sport = dev_id;
 	unsigned int rx,flg,ignored = 0;
diff --git a/drivers/serial/ioc4_serial.c b/drivers/serial/ioc4_serial.c
index 0c17938..90bb3cb 100644
--- a/drivers/serial/ioc4_serial.c
+++ b/drivers/serial/ioc4_serial.c
@@ -985,11 +985,10 @@ intr_connect(struct ioc4_soft *soft, int type,
 
 /**
  * ioc4_intr - Top level IOC4 interrupt handler.
- * @irq: irq value
  * @arg: handler arg
  */
 
-static irqreturn_t ioc4_intr(int irq, void *arg)
+static irqreturn_t ioc4_intr(void *arg)
 {
 	struct ioc4_soft *soft;
 	uint32_t this_ir, this_mir;
diff --git a/drivers/serial/ip22zilog.c b/drivers/serial/ip22zilog.c
index f3257f7..4611c29 100644
--- a/drivers/serial/ip22zilog.c
+++ b/drivers/serial/ip22zilog.c
@@ -440,7 +440,7 @@ ack_tx_int:
 	ZS_WSYNC(channel);
 }
 
-static irqreturn_t ip22zilog_interrupt(int irq, void *dev_id)
+static irqreturn_t ip22zilog_interrupt(void *dev_id)
 {
 	struct uart_ip22zilog_port *up = dev_id;
 
diff --git a/drivers/serial/jsm/jsm_neo.c b/drivers/serial/jsm/jsm_neo.c
index b2d6f5b..0faa7e0 100644
--- a/drivers/serial/jsm/jsm_neo.c
+++ b/drivers/serial/jsm/jsm_neo.c
@@ -1119,7 +1119,7 @@ static void neo_param(struct jsm_channel *ch)
  *
  * Neo specific interrupt handler.
  */
-static irqreturn_t neo_intr(int irq, void *voidbrd)
+static irqreturn_t neo_intr(void *voidbrd)
 {
 	struct jsm_board *brd = voidbrd;
 	struct jsm_channel *ch;
diff --git a/drivers/serial/m32r_sio.c b/drivers/serial/m32r_sio.c
index 348ee2c..35653cd 100644
--- a/drivers/serial/m32r_sio.c
+++ b/drivers/serial/m32r_sio.c
@@ -462,7 +462,7 @@ static inline void m32r_sio_handle_port(struct uart_sio_port *up,
  * This means we need to loop through all ports. checking that they
  * don't have an interrupt pending.
  */
-static irqreturn_t m32r_sio_interrupt(int irq, void *dev_id)
+static irqreturn_t m32r_sio_interrupt(void *dev_id)
 {
 	struct irq_info *i = dev_id;
 	struct list_head *l, *end = NULL;
diff --git a/drivers/serial/mcfserial.c b/drivers/serial/mcfserial.c
index 99af084..363e97c 100644
--- a/drivers/serial/mcfserial.c
+++ b/drivers/serial/mcfserial.c
@@ -404,7 +404,7 @@ static inline void transmit_chars(struct mcf_serial *info)
 /*
  * This is the serial driver's generic interrupt routine
  */
-irqreturn_t mcfrs_interrupt(int irq, void *dev_id)
+irqreturn_t mcfrs_interrupt(void *dev_id)
 {
 	struct mcf_serial	*info;
 	unsigned char		isr;
diff --git a/drivers/serial/mpc52xx_uart.c b/drivers/serial/mpc52xx_uart.c
index ec36ad7..d6e1dfa 100644
--- a/drivers/serial/mpc52xx_uart.c
+++ b/drivers/serial/mpc52xx_uart.c
@@ -114,7 +114,7 @@ static void mpc52xx_uart_of_enumerate(void);
 
 
 /* Forward declaration of the interruption handling routine */
-static irqreturn_t mpc52xx_uart_int(int irq,void *dev_id);
+static irqreturn_t mpc52xx_uart_int(void *dev_id);
 
 
 /* Simple macro to test if a port is console or not. This one is taken
@@ -548,7 +548,7 @@ mpc52xx_uart_int_tx_chars(struct uart_port *port)
 }
 
 static irqreturn_t
-mpc52xx_uart_int(int irq, void *dev_id)
+mpc52xx_uart_int(void *dev_id)
 {
 	struct uart_port *port = dev_id;
 	unsigned long pass = ISR_PASS_LIMIT;
diff --git a/drivers/serial/mpsc.c b/drivers/serial/mpsc.c
index 4d643c9..97ba6e8 100644
--- a/drivers/serial/mpsc.c
+++ b/drivers/serial/mpsc.c
@@ -1196,7 +1196,7 @@ static int mpsc_tx_intr(struct mpsc_port_info *pi)
  * the interrupt, then handle any completed Rx/Tx descriptors.  When done
  * handling those descriptors, we restart the Rx/Tx engines if they're stopped.
  */
-static irqreturn_t mpsc_sdma_intr(int irq, void *dev_id)
+static irqreturn_t mpsc_sdma_intr(void *dev_id)
 {
 	struct mpsc_port_info *pi = dev_id;
 	ulong iflags;
diff --git a/drivers/serial/netx-serial.c b/drivers/serial/netx-serial.c
index b56f7db..e707567 100644
--- a/drivers/serial/netx-serial.c
+++ b/drivers/serial/netx-serial.c
@@ -245,7 +245,7 @@ static void netx_rxint(struct uart_port *port)
 	return;
 }
 
-static irqreturn_t netx_int(int irq, void *dev_id)
+static irqreturn_t netx_int(void *dev_id)
 {
 	struct uart_port *port = dev_id;
 	unsigned long flags;
diff --git a/drivers/serial/pmac_zilog.c b/drivers/serial/pmac_zilog.c
index 794bd0f..e58cdd9 100644
--- a/drivers/serial/pmac_zilog.c
+++ b/drivers/serial/pmac_zilog.c
@@ -448,7 +448,7 @@ ack_tx_int:
 }
 
 /* Hrm... we register that twice, fixme later.... */
-static irqreturn_t pmz_interrupt(int irq, void *dev_id)
+static irqreturn_t pmz_interrupt(void *dev_id)
 {
 	struct uart_pmac_port *uap = dev_id;
 	struct uart_pmac_port *uap_a;
diff --git a/drivers/serial/pxa.c b/drivers/serial/pxa.c
index af3a011..d9c3205 100644
--- a/drivers/serial/pxa.c
+++ b/drivers/serial/pxa.c
@@ -231,7 +231,7 @@ static inline void check_modem_status(struct uart_pxa_port *up)
 /*
  * This handles the interrupt from one port.
  */
-static inline irqreturn_t serial_pxa_irq(int irq, void *dev_id)
+static inline irqreturn_t serial_pxa_irq(void *dev_id)
 {
 	struct uart_pxa_port *up = dev_id;
 	unsigned int iir, lsr;
diff --git a/drivers/serial/s3c2410.c b/drivers/serial/s3c2410.c
index 3f26c4b..0dcfb6f 100644
--- a/drivers/serial/s3c2410.c
+++ b/drivers/serial/s3c2410.c
@@ -310,7 +310,7 @@ static int s3c24xx_serial_rx_fifocnt(struct s3c24xx_uart_port *ourport,
 #define S3C2410_UERSTAT_PARITY (0x1000)
 
 static irqreturn_t
-s3c24xx_serial_rx_chars(int irq, void *dev_id)
+s3c24xx_serial_rx_chars(void *dev_id)
 {
 	struct s3c24xx_uart_port *ourport = dev_id;
 	struct uart_port *port = &ourport->port;
@@ -393,7 +393,7 @@ s3c24xx_serial_rx_chars(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t s3c24xx_serial_tx_chars(int irq, void *id)
+static irqreturn_t s3c24xx_serial_tx_chars(void *id)
 {
 	struct s3c24xx_uart_port *ourport = id;
 	struct uart_port *port = &ourport->port;
diff --git a/drivers/serial/sa1100.c b/drivers/serial/sa1100.c
index 58a83c2..e016ad6 100644
--- a/drivers/serial/sa1100.c
+++ b/drivers/serial/sa1100.c
@@ -281,7 +281,7 @@ static void sa1100_tx_chars(struct sa1100_port *sport)
 		sa1100_stop_tx(&sport->port);
 }
 
-static irqreturn_t sa1100_int(int irq, void *dev_id)
+static irqreturn_t sa1100_int(void *dev_id)
 {
 	struct sa1100_port *sport = dev_id;
 	unsigned int status, pass_counter = 0;
diff --git a/drivers/serial/serial_lh7a40x.c b/drivers/serial/serial_lh7a40x.c
index eb18d42..5f8934d 100644
--- a/drivers/serial/serial_lh7a40x.c
+++ b/drivers/serial/serial_lh7a40x.c
@@ -243,7 +243,7 @@ static void lh7a40xuart_modem_status (struct uart_port* port)
 	wake_up_interruptible (&port->info->delta_msr_wait);
 }
 
-static irqreturn_t lh7a40xuart_int (int irq, void* dev_id)
+static irqreturn_t lh7a40xuart_int (void *dev_id)
 {
 	struct uart_port* port = dev_id;
 	unsigned int cLoopLimit = ISR_LOOP_LIMIT;
diff --git a/drivers/serial/serial_txx9.c b/drivers/serial/serial_txx9.c
index 6846a6c..3ce9905 100644
--- a/drivers/serial/serial_txx9.c
+++ b/drivers/serial/serial_txx9.c
@@ -378,7 +378,7 @@ static inline void transmit_chars(struct uart_txx9_port *up)
 		serial_txx9_stop_tx(&up->port);
 }
 
-static irqreturn_t serial_txx9_interrupt(int irq, void *dev_id)
+static irqreturn_t serial_txx9_interrupt(void *dev_id)
 {
 	int pass_counter = 0;
 	struct uart_txx9_port *up = dev_id;
diff --git a/drivers/serial/sh-sci.c b/drivers/serial/sh-sci.c
index 73440e2..9f982da 100644
--- a/drivers/serial/sh-sci.c
+++ b/drivers/serial/sh-sci.c
@@ -734,7 +734,7 @@ static irqreturn_t sci_rx_interrupt(int irq, void *port)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t sci_tx_interrupt(int irq, void *ptr)
+static irqreturn_t sci_tx_interrupt(void *ptr)
 {
 	struct uart_port *port = ptr;
 
@@ -745,7 +745,7 @@ static irqreturn_t sci_tx_interrupt(int irq, void *ptr)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t sci_er_interrupt(int irq, void *ptr)
+static irqreturn_t sci_er_interrupt(void *ptr)
 {
 	struct uart_port *port = ptr;
 
@@ -778,7 +778,7 @@ static irqreturn_t sci_er_interrupt(int irq, void *ptr)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t sci_br_interrupt(int irq, void *ptr)
+static irqreturn_t sci_br_interrupt(void *ptr)
 {
 	struct uart_port *port = ptr;
 
@@ -789,7 +789,7 @@ static irqreturn_t sci_br_interrupt(int irq, void *ptr)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t sci_mpxed_interrupt(int irq, void *ptr)
+static irqreturn_t sci_mpxed_interrupt(void *ptr)
 {
         unsigned short ssr_status, scr_status;
         struct uart_port *port = ptr;
@@ -860,7 +860,7 @@ static struct notifier_block sci_nb = { &sci_notifier, NULL, 0 };
 static int sci_request_irq(struct sci_port *port)
 {
 	int i;
-	irqreturn_t (*handlers[4])(int irq, void *ptr) = {
+	irqreturn_t (*handlers[4])(void *ptr) = {
 		sci_er_interrupt, sci_rx_interrupt, sci_tx_interrupt,
 		sci_br_interrupt,
 	};
diff --git a/drivers/serial/sn_console.c b/drivers/serial/sn_console.c
index 41fc612..06ce7db 100644
--- a/drivers/serial/sn_console.c
+++ b/drivers/serial/sn_console.c
@@ -615,7 +615,7 @@ static void sn_transmit_chars(struct sn_cons_port *port, int raw)
  * @dev_id: our pointer to our port (sn_cons_port which contains the uart port)
  *
  */
-static irqreturn_t sn_sal_interrupt(int irq, void *dev_id)
+static irqreturn_t sn_sal_interrupt(void *dev_id)
 {
 	struct sn_cons_port *port = (struct sn_cons_port *)dev_id;
 	unsigned long flags;
diff --git a/drivers/serial/sunhv.c b/drivers/serial/sunhv.c
index 8ff900b..80edbf0 100644
--- a/drivers/serial/sunhv.c
+++ b/drivers/serial/sunhv.c
@@ -210,7 +210,7 @@ static void transmit_chars(struct uart_port *port)
 		uart_write_wakeup(port);
 }
 
-static irqreturn_t sunhv_interrupt(int irq, void *dev_id)
+static irqreturn_t sunhv_interrupt(void *dev_id)
 {
 	struct uart_port *port = dev_id;
 	struct tty_struct *tty;
diff --git a/drivers/serial/sunsab.c b/drivers/serial/sunsab.c
index ff610c2..91de430 100644
--- a/drivers/serial/sunsab.c
+++ b/drivers/serial/sunsab.c
@@ -300,7 +300,7 @@ static void check_status(struct uart_sunsab_port *up,
 	wake_up_interruptible(&up->port.info->delta_msr_wait);
 }
 
-static irqreturn_t sunsab_interrupt(int irq, void *dev_id)
+static irqreturn_t sunsab_interrupt(void *dev_id)
 {
 	struct uart_sunsab_port *up = dev_id;
 	struct tty_struct *tty;
diff --git a/drivers/serial/sunsu.c b/drivers/serial/sunsu.c
index e074943..f9b832e 100644
--- a/drivers/serial/sunsu.c
+++ b/drivers/serial/sunsu.c
@@ -444,7 +444,7 @@ static void check_modem_status(struct uart_sunsu_port *up)
 	wake_up_interruptible(&up->port.info->delta_msr_wait);
 }
 
-static irqreturn_t sunsu_serial_interrupt(int irq, void *dev_id)
+static irqreturn_t sunsu_serial_interrupt(void *dev_id)
 {
 	struct uart_sunsu_port *up = dev_id;
 	unsigned long flags;
@@ -526,7 +526,7 @@ static void receive_kbd_ms_chars(struct uart_sunsu_port *up, int is_break)
 	} while (serial_in(up, UART_LSR) & UART_LSR_DR);
 }
 
-static irqreturn_t sunsu_kbd_ms_interrupt(int irq, void *dev_id)
+static irqreturn_t sunsu_kbd_ms_interrupt(void *dev_id)
 {
 	struct uart_sunsu_port *up = dev_id;
 
diff --git a/drivers/serial/sunzilog.c b/drivers/serial/sunzilog.c
index 283bef0..ffc7f73 100644
--- a/drivers/serial/sunzilog.c
+++ b/drivers/serial/sunzilog.c
@@ -533,7 +533,7 @@ ack_tx_int:
 	ZS_WSYNC(channel);
 }
 
-static irqreturn_t sunzilog_interrupt(int irq, void *dev_id)
+static irqreturn_t sunzilog_interrupt(void *dev_id)
 {
 	struct uart_sunzilog_port *up = dev_id;
 
diff --git a/drivers/serial/v850e_uart.c b/drivers/serial/v850e_uart.c
index dd98aca..4220655 100644
--- a/drivers/serial/v850e_uart.c
+++ b/drivers/serial/v850e_uart.c
@@ -271,14 +271,14 @@ void v850e_uart_tx (struct uart_port *port)
 		v850e_uart_stop_tx (port, stopped);
 }
 
-static irqreturn_t v850e_uart_tx_irq(int irq, void *data)
+static irqreturn_t v850e_uart_tx_irq(void *data)
 {
 	struct uart_port *port = data;
 	v850e_uart_tx (port);
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t v850e_uart_rx_irq(int irq, void *data)
+static irqreturn_t v850e_uart_rx_irq(void *data)
 {
 	struct uart_port *port = data;
 	unsigned ch_stat = TTY_NORMAL;
diff --git a/drivers/serial/vr41xx_siu.c b/drivers/serial/vr41xx_siu.c
index 6fd51b0..ebac087 100644
--- a/drivers/serial/vr41xx_siu.c
+++ b/drivers/serial/vr41xx_siu.c
@@ -423,7 +423,7 @@ static inline void transmit_chars(struct uart_port *port)
 		siu_stop_tx(port);
 }
 
-static irqreturn_t siu_interrupt(int irq, void *dev_id)
+static irqreturn_t siu_interrupt(void *dev_id)
 {
 	struct uart_port *port;
 	uint8_t iir, lsr;
diff --git a/drivers/sn/ioc3.c b/drivers/sn/ioc3.c
index 29fcd6d..a463cd2 100644
--- a/drivers/sn/ioc3.c
+++ b/drivers/sn/ioc3.c
@@ -398,7 +398,7 @@ static inline uint32_t get_pending_intrs(struct ioc3_driver_data *idd)
 	return intrs;
 }
 
-static irqreturn_t ioc3_intr_io(int irq, void *arg)
+static irqreturn_t ioc3_intr_io(void *arg)
 {
 	unsigned long flags;
 	struct ioc3_driver_data *idd = arg;
@@ -441,7 +441,7 @@ static irqreturn_t ioc3_intr_io(int irq, void *arg)
 	return handled?IRQ_HANDLED:IRQ_NONE;
 }
 
-static irqreturn_t ioc3_intr_eth(int irq, void *arg)
+static irqreturn_t ioc3_intr_eth(void *arg)
 {
 	unsigned long flags;
 	struct ioc3_driver_data *idd = (struct ioc3_driver_data *)arg;
diff --git a/drivers/spi/pxa2xx_spi.c b/drivers/spi/pxa2xx_spi.c
index 5f3d808..d4bdab6 100644
--- a/drivers/spi/pxa2xx_spi.c
+++ b/drivers/spi/pxa2xx_spi.c
@@ -659,7 +659,7 @@ static irqreturn_t interrupt_transfer(struct driver_data *drv_data)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t ssp_int(int irq, void *dev_id)
+static irqreturn_t ssp_int(void *dev_id)
 {
 	struct driver_data *drv_data = dev_id;
 	void *reg = drv_data->ioaddr;
diff --git a/drivers/spi/spi_mpc83xx.c b/drivers/spi/spi_mpc83xx.c
index 4580b9c..b64c85e 100644
--- a/drivers/spi/spi_mpc83xx.c
+++ b/drivers/spi/spi_mpc83xx.c
@@ -356,7 +356,7 @@ static int mpc83xx_spi_bufs(struct spi_device *spi, struct spi_transfer *t)
 	return t->len - mpc83xx_spi->count;
 }
 
-irqreturn_t mpc83xx_spi_irq(s32 irq, void *context_data)
+irqreturn_t mpc83xx_spi_irq(void *context_data)
 {
 	struct mpc83xx_spi *mpc83xx_spi = context_data;
 	u32 event;
diff --git a/drivers/spi/spi_s3c24xx.c b/drivers/spi/spi_s3c24xx.c
index 89d6685..8d7af13 100644
--- a/drivers/spi/spi_s3c24xx.c
+++ b/drivers/spi/spi_s3c24xx.c
@@ -199,7 +199,7 @@ static int s3c24xx_spi_txrx(struct spi_device *spi, struct spi_transfer *t)
 	return hw->count;
 }
 
-static irqreturn_t s3c24xx_spi_irq(int irq, void *dev)
+static irqreturn_t s3c24xx_spi_irq(void *dev)
 {
 	struct s3c24xx_spi *hw = dev;
 	unsigned int spsta = readb(hw->regs + S3C2410_SPSTA);
diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 865f32b..8dafdd5 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -250,10 +250,10 @@ EXPORT_SYMBOL_GPL(uio_event_notify);
  * @irq: IRQ number, can be UIO_IRQ_CYCLIC for cyclic timer
  * @dev_id: Pointer to the devices uio_device structure
  */
-static irqreturn_t uio_interrupt(int irq, void *dev_id)
+static irqreturn_t uio_interrupt(void *dev_id)
 {
 	struct uio_device *idev = (struct uio_device *)dev_id;
-	irqreturn_t ret = idev->info->handler(irq, idev->info);
+	irqreturn_t ret = idev->info->handler(idev->info);
 
 	if (ret == IRQ_HANDLED)
 		uio_event_notify(idev->info);
diff --git a/drivers/uio/uio_cif.c b/drivers/uio/uio_cif.c
index 838bae4..bed6398 100644
--- a/drivers/uio/uio_cif.c
+++ b/drivers/uio/uio_cif.c
@@ -29,8 +29,9 @@
 #define CIF_SUBDEVICE_DEVICENET	0x432
 
 
-static irqreturn_t hilscher_handler(int irq, struct uio_info *dev_info)
+static irqreturn_t hilscher_handler(void *_dev_info)
 {
+	struct uio_info *dev_info = _dev_info;
 	void __iomem *plx_intscr = dev_info->mem[0].internal_addr
 					+ PLX9030_INTCSR;
 
diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 3dd997d..97dae5e 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1546,7 +1546,7 @@ EXPORT_SYMBOL (usb_bus_start_enum);
  * If the controller isn't HALTed, calls the driver's irq handler.
  * Checks whether the controller is now dead.
  */
-irqreturn_t usb_hcd_irq (int irq, void *__hcd)
+irqreturn_t usb_hcd_irq (void *__hcd)
 {
 	struct usb_hcd		*hcd = __hcd;
 	int			start = hcd->state;
diff --git a/drivers/usb/core/hcd.h b/drivers/usb/core/hcd.h
index 98e2419..5c0714b 100644
--- a/drivers/usb/core/hcd.h
+++ b/drivers/usb/core/hcd.h
@@ -264,7 +264,7 @@ void hcd_buffer_free (struct usb_bus *bus, size_t size,
 	void *addr, dma_addr_t dma);
 
 /* generic bus glue, needed for host controllers that don't use PCI */
-extern irqreturn_t usb_hcd_irq (int irq, void *__hcd);
+extern irqreturn_t usb_hcd_irq (void *__hcd);
 
 extern void usb_hc_died (struct usb_hcd *hcd);
 extern void usb_hcd_poll_rh_status(struct usb_hcd *hcd);
diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536udc.c
index 1c80406..8c6a63b 100644
--- a/drivers/usb/gadget/amd5536udc.c
+++ b/drivers/usb/gadget/amd5536udc.c
@@ -3041,7 +3041,7 @@ __acquires(dev->lock)
 }
 
 /* Interrupt Service Routine, see Linux Kernel Doc for parameters */
-static irqreturn_t udc_irq(int irq, void *pdev)
+static irqreturn_t udc_irq(void *pdev)
 {
 	struct udc *dev = pdev;
 	u32 reg;
diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
index a6adf7e..a344b96 100644
--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
@@ -1368,7 +1368,7 @@ static void handle_ep0(struct at91_udc *udc)
 	}
 }
 
-static irqreturn_t at91_udc_irq (int irq, void *_udc)
+static irqreturn_t at91_udc_irq (void *_udc)
 {
 	struct at91_udc		*udc = _udc;
 	u32			rescans = 5;
diff --git a/drivers/usb/gadget/goku_udc.c b/drivers/usb/gadget/goku_udc.c
index 2ec9d19..fde447d 100644
--- a/drivers/usb/gadget/goku_udc.c
+++ b/drivers/usb/gadget/goku_udc.c
@@ -1546,7 +1546,7 @@ stall:
 		handled = 1; \
 		}
 
-static irqreturn_t goku_irq(int irq, void *_dev)
+static irqreturn_t goku_irq(void *_dev)
 {
 	struct goku_udc			*dev = _dev;
 	struct goku_udc_regs __iomem	*regs = dev->regs;
diff --git a/drivers/usb/gadget/lh7a40x_udc.c b/drivers/usb/gadget/lh7a40x_udc.c
index e78c2dd..47b0e97 100644
--- a/drivers/usb/gadget/lh7a40x_udc.c
+++ b/drivers/usb/gadget/lh7a40x_udc.c
@@ -915,7 +915,7 @@ static void lh7a40x_reset_intr(struct lh7a40x_udc *dev)
 /*
  *	lh7a40x usb client interrupt handler.
  */
-static irqreturn_t lh7a40x_udc_irq(int irq, void *_dev)
+static irqreturn_t lh7a40x_udc_irq(void *_dev)
 {
 	struct lh7a40x_udc *dev = _dev;
 
diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
index d5d473f..901f553 100644
--- a/drivers/usb/gadget/net2280.c
+++ b/drivers/usb/gadget/net2280.c
@@ -2667,7 +2667,7 @@ static void handle_stat1_irqs (struct net2280 *dev, u32 stat)
 		DEBUG (dev, "unhandled irqstat1 %08x\n", stat);
 }
 
-static irqreturn_t net2280_irq (int irq, void *_dev)
+static irqreturn_t net2280_irq (void *_dev)
 {
 	struct net2280		*dev = _dev;
 
diff --git a/drivers/usb/gadget/omap_udc.c b/drivers/usb/gadget/omap_udc.c
index 87c4f50..72c051a 100644
--- a/drivers/usb/gadget/omap_udc.c
+++ b/drivers/usb/gadget/omap_udc.c
@@ -1826,7 +1826,7 @@ static void devstate_irq(struct omap_udc *udc, u16 irq_src)
 	UDC_IRQ_SRC_REG = UDC_DS_CHG;
 }
 
-static irqreturn_t omap_udc_irq(int irq, void *_udc)
+static irqreturn_t omap_udc_irq(void *_udc)
 {
 	struct omap_udc	*udc = _udc;
 	u16		irq_src;
@@ -1898,7 +1898,7 @@ static void pio_out_timer(unsigned long _ep)
 	spin_unlock_irqrestore(&ep->udc->lock, flags);
 }
 
-static irqreturn_t omap_udc_pio_irq(int irq, void *_dev)
+static irqreturn_t omap_udc_pio_irq(void *_dev)
 {
 	u16		epn_stat, irq_src;
 	irqreturn_t	status = IRQ_NONE;
@@ -1977,7 +1977,7 @@ static irqreturn_t omap_udc_pio_irq(int irq, void *_dev)
 }
 
 #ifdef	USE_ISO
-static irqreturn_t omap_udc_iso_irq(int irq, void *_dev)
+static irqreturn_t omap_udc_iso_irq(void *_dev)
 {
 	struct omap_udc	*udc = _dev;
 	struct omap_ep	*ep;
diff --git a/drivers/usb/gadget/pxa2xx_udc.c b/drivers/usb/gadget/pxa2xx_udc.c
index 3173b39..8c64baa 100644
--- a/drivers/usb/gadget/pxa2xx_udc.c
+++ b/drivers/usb/gadget/pxa2xx_udc.c
@@ -1365,7 +1365,7 @@ EXPORT_SYMBOL(usb_gadget_unregister_driver);
  */
 
 static irqreturn_t
-lubbock_vbus_irq(int irq, void *_dev)
+lubbock_vbus_irq(void *_dev)
 {
 	struct pxa2xx_udc	*dev = _dev;
 	int			vbus;
@@ -1392,7 +1392,7 @@ lubbock_vbus_irq(int irq, void *_dev)
 
 #endif
 
-static irqreturn_t udc_vbus_irq(int irq, void *_dev)
+static irqreturn_t udc_vbus_irq(void *_dev)
 {
 	struct pxa2xx_udc	*dev = _dev;
 	int			vbus = gpio_get_value(dev->mach->gpio_vbus);
@@ -1709,7 +1709,7 @@ static void handle_ep(struct pxa2xx_ep *ep)
  * could cause usb protocol errors.
  */
 static irqreturn_t
-pxa2xx_udc_irq(int irq, void *_dev)
+pxa2xx_udc_irq(void *_dev)
 {
 	struct pxa2xx_udc	*dev = _dev;
 	int			handled;
diff --git a/drivers/video/amifb.c b/drivers/video/amifb.c
index f2e243c..983818b 100644
--- a/drivers/video/amifb.c
+++ b/drivers/video/amifb.c
@@ -1144,7 +1144,7 @@ static void amifb_deinit(void);
 	 */
 
 static int flash_cursor(void);
-static irqreturn_t amifb_interrupt(int irq, void *dev_id);
+static irqreturn_t amifb_interrupt(void *dev_id);
 static u_long chipalloc(u_long size);
 static void chipfree(void);
 
@@ -2494,7 +2494,7 @@ static int flash_cursor(void)
 	 * VBlank Display Interrupt
 	 */
 
-static irqreturn_t amifb_interrupt(int irq, void *dev_id)
+static irqreturn_t amifb_interrupt(void *dev_id)
 {
 	if (do_vmode_pan || do_vmode_full)
 		ami_update_display();
diff --git a/drivers/video/arcfb.c b/drivers/video/arcfb.c
index c343169..6db1004 100644
--- a/drivers/video/arcfb.c
+++ b/drivers/video/arcfb.c
@@ -218,7 +218,7 @@ static int arcfb_pan_display(struct fb_var_screeninfo *var,
 	return -EINVAL;
 }
 
-static irqreturn_t arcfb_interrupt(int vec, void *dev_instance)
+static irqreturn_t arcfb_interrupt(void *dev_instance)
 {
 	struct fb_info *info = dev_instance;
 	unsigned char ctl2status;
diff --git a/drivers/video/atafb.c b/drivers/video/atafb.c
index 5d4fbaa..60f0afd 100644
--- a/drivers/video/atafb.c
+++ b/drivers/video/atafb.c
@@ -1631,7 +1631,7 @@ static void falcon_set_par(struct atafb_par *par)
 	f_change_mode = 1;
 }
 
-static irqreturn_t falcon_vbl_switcher(int irq, void *dummy)
+static irqreturn_t falcon_vbl_switcher(void *dummy)
 {
 	struct falcon_hw *hw = &f_new_mode;
 
diff --git a/drivers/video/aty/atyfb_base.c b/drivers/video/aty/atyfb_base.c
index abe0c43..b529166 100644
--- a/drivers/video/aty/atyfb_base.c
+++ b/drivers/video/aty/atyfb_base.c
@@ -1527,7 +1527,7 @@ static int atyfb_open(struct fb_info *info, int user)
 	return (0);
 }
 
-static irqreturn_t aty_irq(int irq, void *dev_id)
+static irqreturn_t aty_irq(void *dev_id)
 {
 	struct atyfb_par *par = dev_id;
 	int handled = 0;
diff --git a/drivers/video/au1200fb.c b/drivers/video/au1200fb.c
index 03e57ef..a3993dc 100644
--- a/drivers/video/au1200fb.c
+++ b/drivers/video/au1200fb.c
@@ -1545,7 +1545,7 @@ static struct fb_ops au1200fb_fb_ops = {
 
 /*-------------------------------------------------------------------------*/
 
-static irqreturn_t au1200fb_handle_irq(int irq, void* dev_id)
+static irqreturn_t au1200fb_handle_irq(void *dev_id)
 {
 	/* Nothing to do for now, just clear any pending interrupt */
 	lcd->intstatus = lcd->intstatus;
diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 0f32f4a..c38c7f1 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -218,7 +218,7 @@ static struct device *fbcon_device;
  */
 static int vbl_detected;
 
-static irqreturn_t fb_vbl_detect(int irq, void *dummy)
+static irqreturn_t fb_vbl_detect(void *dummy)
 {
 	vbl_detected++;
 	return IRQ_HANDLED;
@@ -428,7 +428,7 @@ static void fb_flashcursor(struct work_struct *work)
 
 #if defined(CONFIG_ATARI) || defined(CONFIG_MAC)
 static int cursor_blink_rate;
-static irqreturn_t fb_vbl_handler(int irq, void *dev_id)
+static irqreturn_t fb_vbl_handler(void *dev_id)
 {
 	struct fb_info *info = dev_id;
 
diff --git a/drivers/video/intelfb/intelfbhw.c b/drivers/video/intelfb/intelfbhw.c
index 2a0e320..91d5315 100644
--- a/drivers/video/intelfb/intelfbhw.c
+++ b/drivers/video/intelfb/intelfbhw.c
@@ -1968,7 +1968,7 @@ void intelfbhw_cursor_reset(struct intelfb_info *dinfo)
 	}
 }
 
-static irqreturn_t intelfbhw_irq(int irq, void *dev_id)
+static irqreturn_t intelfbhw_irq(void *dev_id)
 {
 	u16 tmp;
 	struct intelfb_info *dinfo = (struct intelfb_info *)dev_id;
diff --git a/drivers/video/matrox/matroxfb_base.c b/drivers/video/matrox/matroxfb_base.c
index b25972a..587b27e 100644
--- a/drivers/video/matrox/matroxfb_base.c
+++ b/drivers/video/matrox/matroxfb_base.c
@@ -198,7 +198,7 @@ static void matroxfb_crtc1_panpos(WPMINFO2) {
 	}
 }
 
-static irqreturn_t matrox_irq(int irq, void *dev_id)
+static irqreturn_t matrox_irq(void *dev_id)
 {
 	u_int32_t status;
 	int handled = 0;
diff --git a/drivers/video/pvr2fb.c b/drivers/video/pvr2fb.c
index 6a3d0b5..f7f4fca 100644
--- a/drivers/video/pvr2fb.c
+++ b/drivers/video/pvr2fb.c
@@ -207,7 +207,7 @@ static int pvr2fb_set_par(struct fb_info *info);
 static void pvr2_update_display(struct fb_info *info);
 static void pvr2_init_display(struct fb_info *info);
 static void pvr2_do_blank(void);
-static irqreturn_t pvr2fb_interrupt(int irq, void *dev_id);
+static irqreturn_t pvr2fb_interrupt(void *dev_id);
 static int pvr2_init_cable(void);
 static int pvr2_get_param(const struct pvr2_params *p, const char *s,
                             int val, int size);
@@ -626,7 +626,7 @@ static void pvr2_do_blank(void)
 	is_blanked = do_blank > 0 ? do_blank : 0;
 }
 
-static irqreturn_t pvr2fb_interrupt(int irq, void *dev_id)
+static irqreturn_t pvr2fb_interrupt(void *dev_id)
 {
 	struct fb_info *info = dev_id;
 
diff --git a/drivers/video/pxafb.c b/drivers/video/pxafb.c
index 10f912d..6ff9032 100644
--- a/drivers/video/pxafb.c
+++ b/drivers/video/pxafb.c
@@ -879,7 +879,7 @@ static void pxafb_disable_controller(struct pxafb_info *fbi)
 /*
  *  pxafb_handle_irq: Handle 'LCD DONE' interrupts.
  */
-static irqreturn_t pxafb_handle_irq(int irq, void *dev_id)
+static irqreturn_t pxafb_handle_irq(void *dev_id)
 {
 	struct pxafb_info *fbi = dev_id;
 	unsigned int lcsr = LCSR;
diff --git a/drivers/video/s3c2410fb.c b/drivers/video/s3c2410fb.c
index ae08d45..c580b45 100644
--- a/drivers/video/s3c2410fb.c
+++ b/drivers/video/s3c2410fb.c
@@ -760,7 +760,7 @@ static void s3c2410fb_write_palette(struct s3c2410fb_info *fbi)
 	}
 }
 
-static irqreturn_t s3c2410fb_irq(int irq, void *dev_id)
+static irqreturn_t s3c2410fb_irq(void *dev_id)
 {
 	struct s3c2410fb_info *fbi = dev_id;
 	void __iomem *regs = fbi->io;
diff --git a/drivers/video/sa1100fb.c b/drivers/video/sa1100fb.c
index ab2b211..ba3207a 100644
--- a/drivers/video/sa1100fb.c
+++ b/drivers/video/sa1100fb.c
@@ -1084,7 +1084,7 @@ static void sa1100fb_disable_controller(struct sa1100fb_info *fbi)
 /*
  *  sa1100fb_handle_irq: Handle 'LCD DONE' interrupts.
  */
-static irqreturn_t sa1100fb_handle_irq(int irq, void *dev_id)
+static irqreturn_t sa1100fb_handle_irq(void *dev_id)
 {
 	struct sa1100fb_info *fbi = dev_id;
 	unsigned int lcsr = LCSR;
diff --git a/drivers/watchdog/eurotechwdt.c b/drivers/watchdog/eurotechwdt.c
index b14e9d1..df7c31e 100644
--- a/drivers/watchdog/eurotechwdt.c
+++ b/drivers/watchdog/eurotechwdt.c
@@ -158,7 +158,7 @@ static void eurwdt_activate_timer(void)
  * Kernel methods.
  */
 
-static irqreturn_t eurwdt_interrupt(int irq, void *dev_id)
+static irqreturn_t eurwdt_interrupt(void *dev_id)
 {
 	printk(KERN_CRIT "timeout WDT timeout\n");
 
diff --git a/drivers/watchdog/mpcore_wdt.c b/drivers/watchdog/mpcore_wdt.c
index 0d2b277..bbe85b3 100644
--- a/drivers/watchdog/mpcore_wdt.c
+++ b/drivers/watchdog/mpcore_wdt.c
@@ -64,7 +64,7 @@ MODULE_PARM_DESC(mpcore_noboot, "MPcore watchdog action, set to 1 to ignore rebo
  *	This is the interrupt handler.  Note that we only use this
  *	in testing mode, so don't actually do a reboot here.
  */
-static irqreturn_t mpcore_wdt_fire(int irq, void *arg)
+static irqreturn_t mpcore_wdt_fire(void *arg)
 {
 	struct mpcore_wdt *wdt = arg;
 
diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index 5d1c15f..5a0e060 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -337,7 +337,7 @@ static struct miscdevice s3c2410wdt_miscdev = {
 
 /* interrupt handler code */
 
-static irqreturn_t s3c2410wdt_irq(int irqno, void *param)
+static irqreturn_t s3c2410wdt_irq(void *param)
 {
 	dev_info(wdt_dev, "watchdog timer expired (irq)\n");
 
diff --git a/drivers/watchdog/wdt.c b/drivers/watchdog/wdt.c
index 0a3de6a..98e1b69 100644
--- a/drivers/watchdog/wdt.c
+++ b/drivers/watchdog/wdt.c
@@ -223,7 +223,6 @@ static int wdt_get_temperature(int *temperature)
 
 /**
  *	wdt_interrupt:
- *	@irq:		Interrupt number
  *	@dev_id:	Unused as we don't allow multiple devices.
  *
  *	Handle an interrupt from the board. These are raised when the status
@@ -231,7 +230,7 @@ static int wdt_get_temperature(int *temperature)
  *	a failure condition occurring.
  */
 
-static irqreturn_t wdt_interrupt(int irq, void *dev_id)
+static irqreturn_t wdt_interrupt(void *dev_id)
 {
 	/*
 	 *	Read the status register see what is up and
diff --git a/drivers/watchdog/wdt285.c b/drivers/watchdog/wdt285.c
index e4cf661..97aa733 100644
--- a/drivers/watchdog/wdt285.c
+++ b/drivers/watchdog/wdt285.c
@@ -46,7 +46,7 @@ static unsigned long timer_alive;
 /*
  *	If the timer expires..
  */
-static void watchdog_fire(int irq, void *dev_id)
+static void watchdog_fire(void *dev_id)
 {
 	printk(KERN_CRIT "Watchdog: Would Reboot.\n");
 	*CSR_TIMER4_CNTL = 0;
diff --git a/drivers/watchdog/wdt_pci.c b/drivers/watchdog/wdt_pci.c
index 6baf4ae..479ecec 100644
--- a/drivers/watchdog/wdt_pci.c
+++ b/drivers/watchdog/wdt_pci.c
@@ -276,7 +276,7 @@ static int wdtpci_get_temperature(int *temperature)
  *	a failure condition occurring.
  */
 
-static irqreturn_t wdtpci_interrupt(int irq, void *dev_id)
+static irqreturn_t wdtpci_interrupt(void *dev_id)
 {
 	/*
 	 *	Read the status register see what is up and
diff --git a/drivers/xen/xenbus/xenbus_comms.c b/drivers/xen/xenbus/xenbus_comms.c
index 6efbe3f..92b7924 100644
--- a/drivers/xen/xenbus/xenbus_comms.c
+++ b/drivers/xen/xenbus/xenbus_comms.c
@@ -46,7 +46,7 @@ static DECLARE_WORK(probe_work, xenbus_probe);
 
 static DECLARE_WAIT_QUEUE_HEAD(xb_waitq);
 
-static irqreturn_t wake_waiting(int irq, void *unused)
+static irqreturn_t wake_waiting(void *unused)
 {
 	if (unlikely(xenstored_ready == 0)) {
 		xenstored_ready = 1;
diff --git a/include/linux/arcdevice.h b/include/linux/arcdevice.h
index fde6758..2e69484 100644
--- a/include/linux/arcdevice.h
+++ b/include/linux/arcdevice.h
@@ -334,7 +334,7 @@ void arcnet_dump_skb(struct net_device *dev, struct sk_buff *skb, char *desc);
 #endif
 
 void arcnet_unregister_proto(struct ArcProto *proto);
-irqreturn_t arcnet_interrupt(int irq, void *dev_id);
+irqreturn_t arcnet_interrupt(void *dev_id);
 struct net_device *alloc_arcdev(char *name);
 
 #endif				/* __KERNEL__ */
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 19db0a4..b5ae4a1 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1185,7 +1185,7 @@ extern void ide_stall_queue(ide_drive_t *drive, unsigned long timeout);
 
 extern int ide_spin_wait_hwgroup(ide_drive_t *);
 extern void ide_timer_expiry(unsigned long);
-extern irqreturn_t ide_intr(int irq, void *dev_id);
+extern irqreturn_t ide_intr(void *dev_id);
 extern void do_ide_request(struct request_queue *);
 
 void ide_init_disk(struct gendisk *, ide_drive_t *);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index bc3b6fc..05cd982 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -823,7 +823,7 @@ extern u8 ata_altstatus(struct ata_port *ap);
 extern void ata_exec_command(struct ata_port *ap, const struct ata_taskfile *tf);
 extern int ata_port_start (struct ata_port *ap);
 extern int ata_sff_port_start (struct ata_port *ap);
-extern irqreturn_t ata_interrupt (int irq, void *dev_instance);
+extern irqreturn_t ata_interrupt (void *dev_instance);
 extern void ata_data_xfer(struct ata_device *adev, unsigned char *buf,
 			  unsigned int buflen, int write_data);
 extern void ata_data_xfer_noirq(struct ata_device *adev, unsigned char *buf,
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index 6d5e4a4..3ac7e0e 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -206,7 +206,7 @@ int rtc_register(rtc_task_t *task);
 int rtc_unregister(rtc_task_t *task);
 int rtc_control(rtc_task_t *t, unsigned int cmd, unsigned long arg);
 void rtc_get_rtc_time(struct rtc_time *rtc_tm);
-irqreturn_t rtc_interrupt(int irq, void *dev_id);
+irqreturn_t rtc_interrupt(void *dev_id);
 
 #endif /* __KERNEL__ */
 
diff --git a/include/sound/cs4231.h b/include/sound/cs4231.h
index 66055d7..6b4630b 100644
--- a/include/sound/cs4231.h
+++ b/include/sound/cs4231.h
@@ -120,7 +120,7 @@ unsigned char snd_cs4236_ext_in(struct snd_cs4231 *chip, unsigned char reg);
 void snd_cs4231_mce_up(struct snd_cs4231 *chip);
 void snd_cs4231_mce_down(struct snd_cs4231 *chip);
 
-irqreturn_t snd_cs4231_interrupt(int irq, void *dev_id);
+irqreturn_t snd_cs4231_interrupt(void *dev_id);
 
 const char *snd_cs4231_chip_id(struct snd_cs4231 *chip);
 
diff --git a/include/sound/emu10k1.h b/include/sound/emu10k1.h
index 441aa06..76e4687 100644
--- a/include/sound/emu10k1.h
+++ b/include/sound/emu10k1.h
@@ -1585,7 +1585,7 @@ int snd_emu10k1_mixer(struct snd_emu10k1 * emu, int pcm_device, int multi_device
 int snd_emu10k1_timer(struct snd_emu10k1 * emu, int device);
 int snd_emu10k1_fx8010_new(struct snd_emu10k1 *emu, int device, struct snd_hwdep ** rhwdep);
 
-irqreturn_t snd_emu10k1_interrupt(int irq, void *dev_id);
+irqreturn_t snd_emu10k1_interrupt(void *dev_id);
 
 void snd_emu10k1_voice_init(struct snd_emu10k1 * emu, int voice);
 int snd_emu10k1_init_efx(struct snd_emu10k1 *emu);
diff --git a/include/sound/gus.h b/include/sound/gus.h
index e5433d8..c1731a2 100644
--- a/include/sound/gus.h
+++ b/include/sound/gus.h
@@ -638,7 +638,7 @@ int snd_gus_initialize(struct snd_gus_card * gus);
 
 /* gus_irq.c */
 
-irqreturn_t snd_gus_interrupt(int irq, void *dev_id);
+irqreturn_t snd_gus_interrupt(void *dev_id);
 #ifdef CONFIG_SND_DEBUG
 void snd_gus_irq_profile_init(struct snd_gus_card *gus);
 #endif
diff --git a/include/sound/initval.h b/include/sound/initval.h
index 1daa6df..93709e4 100644
--- a/include/sound/initval.h
+++ b/include/sound/initval.h
@@ -53,7 +53,7 @@
 #ifdef SNDRV_LEGACY_FIND_FREE_IRQ
 #include <linux/interrupt.h>
 
-static irqreturn_t snd_legacy_empty_irq_handler(int irq, void *dev_id)
+static irqreturn_t snd_legacy_empty_irq_handler(void *dev_id)
 {
 	return IRQ_HANDLED;
 }
diff --git a/include/sound/mpu401.h b/include/sound/mpu401.h
index d45218b..f132ee0 100644
--- a/include/sound/mpu401.h
+++ b/include/sound/mpu401.h
@@ -106,8 +106,8 @@ struct snd_mpu401 {
 
  */
 
-irqreturn_t snd_mpu401_uart_interrupt(int irq, void *dev_id);
-irqreturn_t snd_mpu401_uart_interrupt_tx(int irq, void *dev_id);
+irqreturn_t snd_mpu401_uart_interrupt(void *dev_id);
+irqreturn_t snd_mpu401_uart_interrupt_tx(void *dev_id);
 
 int snd_mpu401_uart_new(struct snd_card *card,
 			int device,
diff --git a/include/sound/sb.h b/include/sound/sb.h
index d0c9ed3..ac03a99 100644
--- a/include/sound/sb.h
+++ b/include/sound/sb.h
@@ -317,7 +317,7 @@ int snd_sb16dsp_pcm(struct snd_sb *chip, int device, struct snd_pcm ** rpcm);
 const struct snd_pcm_ops *snd_sb16dsp_get_pcm_ops(int direction);
 int snd_sb16dsp_configure(struct snd_sb *chip);
 /* sb16.c */
-irqreturn_t snd_sb16dsp_interrupt(int irq, void *dev_id);
+irqreturn_t snd_sb16dsp_interrupt(void *dev_id);
 
 /* exported mixer stuffs */
 enum {
diff --git a/include/sound/vx_core.h b/include/sound/vx_core.h
index 4830651..9db8d7c 100644
--- a/include/sound/vx_core.h
+++ b/include/sound/vx_core.h
@@ -228,7 +228,7 @@ void snd_vx_free_firmware(struct vx_core *chip);
 /*
  * interrupt handler; exported for pcmcia
  */
-irqreturn_t snd_vx_irq_handler(int irq, void *dev);
+irqreturn_t snd_vx_irq_handler(void *dev);
 
 /*
  * lowlevel functions
