Return-Path: <linux-kernel-owner+w=401wt.eu-S1751401AbZJPD74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751401AbZJPD74 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 23:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751118AbZJPD7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 23:59:54 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:54202 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbZJPD7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 23:59:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=S3VjEdIIoAsTNibg1QrRz/5TBC5jpFWUvR8hQjbIIjQpufbsieY60JBHqJssRcfKx8
         kWOs+73SZm+KbV75Vq4+tB2WAVd4vSsmttQDW+bQq+zk3pRXAkMEV+JndpaeZQU+2kbK
         nzmO5Dj2oVjINDqAuR3vkpIqm3LEF579JQH9s=
Date: Fri, 16 Oct 2009 07:59:13 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] const: constify remaining dev_pm_ops
Message-ID: <20091016035913.GA4669@x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/arm/plat-omap/debug-leds.c            |    2 +-
 arch/arm/plat-omap/gpio.c                  |    2 +-
 arch/s390/appldata/appldata_base.c         |    2 +-
 drivers/block/floppy.c                     |    2 +-
 drivers/char/hvc_iucv.c                    |    2 +-
 drivers/clocksource/sh_cmt.c               |    2 +-
 drivers/dma/at_hdmac.c                     |    2 +-
 drivers/dma/dw_dmac.c                      |    2 +-
 drivers/dma/txx9dmac.c                     |    2 +-
 drivers/hwmon/applesmc.c                   |    2 +-
 drivers/i2c/busses/i2c-pxa.c               |    2 +-
 drivers/i2c/busses/i2c-s3c2410.c           |    2 +-
 drivers/i2c/busses/i2c-sh_mobile.c         |    2 +-
 drivers/input/keyboard/adp5588-keys.c      |    2 +-
 drivers/input/keyboard/sh_keysc.c          |    2 +-
 drivers/input/misc/bfin_rotary.c           |    2 +-
 drivers/input/misc/pcspkr.c                |    2 +-
 drivers/input/touchscreen/pcap_ts.c        |    2 +-
 drivers/media/video/davinci/vpfe_capture.c |    2 +-
 drivers/media/video/davinci/vpif_capture.c |    2 +-
 drivers/media/video/sh_mobile_ceu_camera.c |    2 +-
 drivers/mmc/host/pxamci.c                  |    2 +-
 drivers/mmc/host/s3cmci.c                  |    2 +-
 drivers/mtd/nand/nomadik_nand.c            |    2 +-
 drivers/net/3c59x.c                        |    2 +-
 drivers/net/dm9000.c                       |    2 +-
 drivers/net/r8169.c                        |    2 +-
 drivers/net/smsc911x.c                     |    2 +-
 drivers/net/vmxnet3/vmxnet3_drv.c          |    2 +-
 drivers/pci/pcie/portdrv_pci.c             |    2 +-
 drivers/pcmcia/pxa2xx_base.c               |    2 +-
 drivers/pcmcia/yenta_socket.c              |    2 +-
 drivers/platform/x86/acerhdf.c             |    2 +-
 drivers/platform/x86/eeepc-laptop.c        |    2 +-
 drivers/platform/x86/hp-wmi.c              |    2 +-
 drivers/power/wm97xx_battery.c             |    2 +-
 drivers/rtc/rtc-pxa.c                      |    2 +-
 drivers/rtc/rtc-sa1100.c                   |    2 +-
 drivers/rtc/rtc-sh.c                       |    2 +-
 drivers/rtc/rtc-wm831x.c                   |    2 +-
 drivers/s390/block/dcssblk.c               |    2 +-
 drivers/s390/block/xpram.c                 |    2 +-
 drivers/s390/char/monreader.c              |    2 +-
 drivers/s390/char/monwriter.c              |    2 +-
 drivers/s390/char/sclp.c                   |    2 +-
 drivers/s390/char/sclp_cmd.c               |    2 +-
 drivers/s390/char/vmlogrdr.c               |    2 +-
 drivers/s390/cio/ccwgroup.c                |    2 +-
 drivers/s390/cio/css.c                     |    2 +-
 drivers/s390/cio/device.c                  |    2 +-
 drivers/s390/net/netiucv.c                 |    2 +-
 drivers/s390/net/smsgiucv.c                |    2 +-
 drivers/serial/pxa.c                       |    2 +-
 drivers/serial/sh-sci.c                    |    2 +-
 drivers/spi/pxa2xx_spi.c                   |    2 +-
 drivers/spi/spi_s3c24xx.c                  |    2 +-
 drivers/uio/uio_pdrv_genirq.c              |    2 +-
 drivers/usb/core/hcd-pci.c                 |    2 +-
 drivers/usb/core/hcd.h                     |    2 +-
 drivers/usb/core/usb.c                     |    2 +-
 drivers/usb/host/ehci-au1xxx.c             |    2 +-
 drivers/usb/host/ohci-au1xxx.c             |    2 +-
 drivers/usb/host/ohci-pxa27x.c             |    2 +-
 drivers/usb/host/r8a66597-hcd.c            |    2 +-
 drivers/usb/musb/musb_core.c               |    2 +-
 drivers/video/backlight/da903x_bl.c        |    2 +-
 drivers/video/hitfb.c                      |    2 +-
 drivers/video/pxafb.c                      |    2 +-
 drivers/video/sh_mobile_lcdcfb.c           |    2 +-
 drivers/watchdog/adx_wdt.c                 |    2 +-
 include/linux/pm.h                         |    2 +-
 net/iucv/af_iucv.c                         |    2 +-
 net/iucv/iucv.c                            |    2 +-
 sound/arm/pxa2xx-ac97.c                    |    2 +-
 sound/soc/s3c24xx/s3c24xx_simtec.c         |    2 +-
 sound/soc/s3c24xx/s3c24xx_simtec.h         |    2 +-
 sound/soc/soc-core.c                       |    2 +-
 77 files changed, 77 insertions(+), 77 deletions(-)

--- a/arch/arm/plat-omap/debug-leds.c
+++ b/arch/arm/plat-omap/debug-leds.c
@@ -293,7 +293,7 @@ static int fpga_resume_noirq(struct device *dev)
 	return 0;
 }
 
-static struct dev_pm_ops fpga_dev_pm_ops = {
+static const struct dev_pm_ops fpga_dev_pm_ops = {
 	.suspend_noirq = fpga_suspend_noirq,
 	.resume_noirq = fpga_resume_noirq,
 };
--- a/arch/arm/plat-omap/gpio.c
+++ b/arch/arm/plat-omap/gpio.c
@@ -1447,7 +1447,7 @@ static int omap_mpuio_resume_noirq(struct device *dev)
 	return 0;
 }
 
-static struct dev_pm_ops omap_mpuio_dev_pm_ops = {
+static const struct dev_pm_ops omap_mpuio_dev_pm_ops = {
 	.suspend_noirq = omap_mpuio_suspend_noirq,
 	.resume_noirq = omap_mpuio_resume_noirq,
 };
--- a/arch/s390/appldata/appldata_base.c
+++ b/arch/s390/appldata/appldata_base.c
@@ -551,7 +551,7 @@ static int appldata_thaw(struct device *dev)
 	return appldata_restore(dev);
 }
 
-static struct dev_pm_ops appldata_pm_ops = {
+static const struct dev_pm_ops appldata_pm_ops = {
 	.freeze		= appldata_freeze,
 	.thaw		= appldata_thaw,
 	.restore	= appldata_restore,
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4162,7 +4162,7 @@ static int floppy_resume(struct device *dev)
 	return 0;
 }
 
-static struct dev_pm_ops floppy_pm_ops = {
+static const struct dev_pm_ops floppy_pm_ops = {
 	.resume = floppy_resume,
 	.restore = floppy_resume,
 };
--- a/drivers/char/hvc_iucv.c
+++ b/drivers/char/hvc_iucv.c
@@ -931,7 +931,7 @@ static struct hv_ops hvc_iucv_ops = {
 };
 
 /* Suspend / resume device operations */
-static struct dev_pm_ops hvc_iucv_pm_ops = {
+static const struct dev_pm_ops hvc_iucv_pm_ops = {
 	.freeze	  = hvc_iucv_pm_freeze,
 	.thaw	  = hvc_iucv_pm_restore_thaw,
 	.restore  = hvc_iucv_pm_restore_thaw,
--- a/drivers/clocksource/sh_cmt.c
+++ b/drivers/clocksource/sh_cmt.c
@@ -689,7 +689,7 @@ static int sh_cmt_resume(struct device *dev)
 	return 0;
 }
 
-static struct dev_pm_ops sh_cmt_dev_pm_ops = {
+static const struct dev_pm_ops sh_cmt_dev_pm_ops = {
 	.suspend = sh_cmt_suspend,
 	.resume = sh_cmt_resume,
 };
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1188,7 +1188,7 @@ static int at_dma_resume_noirq(struct device *dev)
 	return 0;
 }
 
-static struct dev_pm_ops at_dma_dev_pm_ops = {
+static const struct dev_pm_ops at_dma_dev_pm_ops = {
 	.suspend_noirq = at_dma_suspend_noirq,
 	.resume_noirq = at_dma_resume_noirq,
 };
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1427,7 +1427,7 @@ static int dw_resume_noirq(struct device *dev)
 	return 0;
 }
 
-static struct dev_pm_ops dw_dev_pm_ops = {
+static const struct dev_pm_ops dw_dev_pm_ops = {
 	.suspend_noirq = dw_suspend_noirq,
 	.resume_noirq = dw_resume_noirq,
 };
--- a/drivers/dma/txx9dmac.c
+++ b/drivers/dma/txx9dmac.c
@@ -1313,7 +1313,7 @@ static int txx9dmac_resume_noirq(struct device *dev)
 
 }
 
-static struct dev_pm_ops txx9dmac_dev_pm_ops = {
+static const struct dev_pm_ops txx9dmac_dev_pm_ops = {
 	.suspend_noirq = txx9dmac_suspend_noirq,
 	.resume_noirq = txx9dmac_resume_noirq,
 };
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -518,7 +518,7 @@ static int applesmc_pm_restore(struct device *dev)
 	return applesmc_pm_resume(dev);
 }
 
-static struct dev_pm_ops applesmc_pm_ops = {
+static const struct dev_pm_ops applesmc_pm_ops = {
 	.resume = applesmc_pm_resume,
 	.restore = applesmc_pm_restore,
 };
--- a/drivers/i2c/busses/i2c-pxa.c
+++ b/drivers/i2c/busses/i2c-pxa.c
@@ -1155,7 +1155,7 @@ static int i2c_pxa_resume_noirq(struct device *dev)
 	return 0;
 }
 
-static struct dev_pm_ops i2c_pxa_dev_pm_ops = {
+static const struct dev_pm_ops i2c_pxa_dev_pm_ops = {
 	.suspend_noirq = i2c_pxa_suspend_noirq,
 	.resume_noirq = i2c_pxa_resume_noirq,
 };
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -967,7 +967,7 @@ static int s3c24xx_i2c_resume(struct device *dev)
 	return 0;
 }
 
-static struct dev_pm_ops s3c24xx_i2c_dev_pm_ops = {
+static const struct dev_pm_ops s3c24xx_i2c_dev_pm_ops = {
 	.suspend_noirq = s3c24xx_i2c_suspend_noirq,
 	.resume = s3c24xx_i2c_resume,
 };
--- a/drivers/i2c/busses/i2c-sh_mobile.c
+++ b/drivers/i2c/busses/i2c-sh_mobile.c
@@ -647,7 +647,7 @@ static int sh_mobile_i2c_runtime_nop(struct device *dev)
 	return 0;
 }
 
-static struct dev_pm_ops sh_mobile_i2c_dev_pm_ops = {
+static const struct dev_pm_ops sh_mobile_i2c_dev_pm_ops = {
 	.runtime_suspend = sh_mobile_i2c_runtime_nop,
 	.runtime_resume = sh_mobile_i2c_runtime_nop,
 };
--- a/drivers/input/keyboard/adp5588-keys.c
+++ b/drivers/input/keyboard/adp5588-keys.c
@@ -319,7 +319,7 @@ static int adp5588_resume(struct device *dev)
 	return 0;
 }
 
-static struct dev_pm_ops adp5588_dev_pm_ops = {
+static const struct dev_pm_ops adp5588_dev_pm_ops = {
 	.suspend = adp5588_suspend,
 	.resume  = adp5588_resume,
 };
--- a/drivers/input/keyboard/sh_keysc.c
+++ b/drivers/input/keyboard/sh_keysc.c
@@ -295,7 +295,7 @@ static int sh_keysc_resume(struct device *dev)
 	return 0;
 }
 
-static struct dev_pm_ops sh_keysc_dev_pm_ops = {
+static const struct dev_pm_ops sh_keysc_dev_pm_ops = {
 	.suspend = sh_keysc_suspend,
 	.resume = sh_keysc_resume,
 };
--- a/drivers/input/misc/bfin_rotary.c
+++ b/drivers/input/misc/bfin_rotary.c
@@ -247,7 +247,7 @@ static int bfin_rotary_resume(struct device *dev)
 	return 0;
 }
 
-static struct dev_pm_ops bfin_rotary_pm_ops = {
+static const struct dev_pm_ops bfin_rotary_pm_ops = {
 	.suspend	= bfin_rotary_suspend,
 	.resume		= bfin_rotary_resume,
 };
--- a/drivers/input/misc/pcspkr.c
+++ b/drivers/input/misc/pcspkr.c
@@ -127,7 +127,7 @@ static void pcspkr_shutdown(struct platform_device *dev)
 	pcspkr_event(NULL, EV_SND, SND_BELL, 0);
 }
 
-static struct dev_pm_ops pcspkr_pm_ops = {
+static const struct dev_pm_ops pcspkr_pm_ops = {
 	.suspend = pcspkr_suspend,
 };
 
--- a/drivers/input/touchscreen/pcap_ts.c
+++ b/drivers/input/touchscreen/pcap_ts.c
@@ -233,7 +233,7 @@ static int pcap_ts_resume(struct device *dev)
 	return 0;
 }
 
-static struct dev_pm_ops pcap_ts_pm_ops = {
+static const struct dev_pm_ops pcap_ts_pm_ops = {
 	.suspend	= pcap_ts_suspend,
 	.resume		= pcap_ts_resume,
 };
--- a/drivers/media/video/davinci/vpfe_capture.c
+++ b/drivers/media/video/davinci/vpfe_capture.c
@@ -2090,7 +2090,7 @@ vpfe_resume(struct device *dev)
 	return -1;
 }
 
-static struct dev_pm_ops vpfe_dev_pm_ops = {
+static const struct dev_pm_ops vpfe_dev_pm_ops = {
 	.suspend = vpfe_suspend,
 	.resume = vpfe_resume,
 };
--- a/drivers/media/video/davinci/vpif_capture.c
+++ b/drivers/media/video/davinci/vpif_capture.c
@@ -2107,7 +2107,7 @@ vpif_resume(struct device *dev)
 	return -1;
 }
 
-static struct dev_pm_ops vpif_dev_pm_ops = {
+static const struct dev_pm_ops vpif_dev_pm_ops = {
 	.suspend = vpif_suspend,
 	.resume = vpif_resume,
 };
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -1767,7 +1767,7 @@ static int sh_mobile_ceu_runtime_nop(struct device *dev)
 	return 0;
 }
 
-static struct dev_pm_ops sh_mobile_ceu_dev_pm_ops = {
+static const struct dev_pm_ops sh_mobile_ceu_dev_pm_ops = {
 	.runtime_suspend = sh_mobile_ceu_runtime_nop,
 	.runtime_resume = sh_mobile_ceu_runtime_nop,
 };
--- a/drivers/mmc/host/pxamci.c
+++ b/drivers/mmc/host/pxamci.c
@@ -826,7 +826,7 @@ static int pxamci_resume(struct device *dev)
 	return ret;
 }
 
-static struct dev_pm_ops pxamci_pm_ops = {
+static const struct dev_pm_ops pxamci_pm_ops = {
 	.suspend	= pxamci_suspend,
 	.resume		= pxamci_resume,
 };
--- a/drivers/mmc/host/s3cmci.c
+++ b/drivers/mmc/host/s3cmci.c
@@ -1892,7 +1892,7 @@ static int s3cmci_resume(struct device *dev)
 	return mmc_resume_host(mmc);
 }
 
-static struct dev_pm_ops s3cmci_pm = {
+static const struct dev_pm_ops s3cmci_pm = {
 	.suspend	= s3cmci_suspend,
 	.resume		= s3cmci_resume,
 };
--- a/drivers/mtd/nand/nomadik_nand.c
+++ b/drivers/mtd/nand/nomadik_nand.c
@@ -216,7 +216,7 @@ static int nomadik_nand_resume(struct device *dev)
 	return 0;
 }
 
-static struct dev_pm_ops nomadik_nand_pm_ops = {
+static const struct dev_pm_ops nomadik_nand_pm_ops = {
 	.suspend = nomadik_nand_suspend,
 	.resume = nomadik_nand_resume,
 };
--- a/drivers/net/3c59x.c
+++ b/drivers/net/3c59x.c
@@ -837,7 +837,7 @@ static int vortex_resume(struct device *dev)
 	return 0;
 }
 
-static struct dev_pm_ops vortex_pm_ops = {
+static const struct dev_pm_ops vortex_pm_ops = {
 	.suspend = vortex_suspend,
 	.resume = vortex_resume,
 	.freeze = vortex_suspend,
--- a/drivers/net/dm9000.c
+++ b/drivers/net/dm9000.c
@@ -1519,7 +1519,7 @@ dm9000_drv_resume(struct device *dev)
 	return 0;
 }
 
-static struct dev_pm_ops dm9000_drv_pm_ops = {
+static const struct dev_pm_ops dm9000_drv_pm_ops = {
 	.suspend	= dm9000_drv_suspend,
 	.resume		= dm9000_drv_resume,
 };
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -4845,7 +4845,7 @@ out:
 	return 0;
 }
 
-static struct dev_pm_ops rtl8169_pm_ops = {
+static const struct dev_pm_ops rtl8169_pm_ops = {
 	.suspend = rtl8169_suspend,
 	.resume = rtl8169_resume,
 	.freeze = rtl8169_suspend,
--- a/drivers/net/smsc911x.c
+++ b/drivers/net/smsc911x.c
@@ -2151,7 +2151,7 @@ static int smsc911x_resume(struct device *dev)
 	return (to == 0) ? -EIO : 0;
 }
 
-static struct dev_pm_ops smsc911x_pm_ops = {
+static const struct dev_pm_ops smsc911x_pm_ops = {
 	.suspend	= smsc911x_suspend,
 	.resume		= smsc911x_resume,
 };
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -2523,7 +2523,7 @@ vmxnet3_resume(struct device *device)
 	return 0;
 }
 
-static struct dev_pm_ops vmxnet3_pm_ops = {
+static const struct dev_pm_ops vmxnet3_pm_ops = {
 	.suspend = vmxnet3_suspend,
 	.resume = vmxnet3_resume,
 };
--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -43,7 +43,7 @@ static int pcie_portdrv_restore_config(struct pci_dev *dev)
 }
 
 #ifdef CONFIG_PM
-static struct dev_pm_ops pcie_portdrv_pm_ops = {
+static const struct dev_pm_ops pcie_portdrv_pm_ops = {
 	.suspend	= pcie_port_device_suspend,
 	.resume		= pcie_port_device_resume,
 	.freeze		= pcie_port_device_suspend,
--- a/drivers/pcmcia/pxa2xx_base.c
+++ b/drivers/pcmcia/pxa2xx_base.c
@@ -311,7 +311,7 @@ static int pxa2xx_drv_pcmcia_resume(struct device *dev)
 	return pcmcia_socket_dev_resume(dev);
 }
 
-static struct dev_pm_ops  pxa2xx_drv_pcmcia_pm_ops = {
+static const struct dev_pm_ops pxa2xx_drv_pcmcia_pm_ops = {
 	.suspend	= pxa2xx_drv_pcmcia_suspend,
 	.resume		= pxa2xx_drv_pcmcia_resume,
 };
--- a/drivers/pcmcia/yenta_socket.c
+++ b/drivers/pcmcia/yenta_socket.c
@@ -1278,7 +1278,7 @@ static int yenta_dev_resume_noirq(struct device *dev)
 	return pcmcia_socket_dev_resume(dev);
 }
 
-static struct dev_pm_ops yenta_pm_ops = {
+static const struct dev_pm_ops yenta_pm_ops = {
 	.suspend_noirq = yenta_dev_suspend_noirq,
 	.resume_noirq = yenta_dev_resume_noirq,
 	.freeze_noirq = yenta_dev_suspend_noirq,
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -460,7 +460,7 @@ static int acerhdf_remove(struct platform_device *device)
 	return 0;
 }
 
-static struct dev_pm_ops acerhdf_pm_ops = {
+static const struct dev_pm_ops acerhdf_pm_ops = {
 	.suspend = acerhdf_suspend,
 	.freeze  = acerhdf_suspend,
 };
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -156,7 +156,7 @@ static void eeepc_rfkill_hotplug(bool real);
 static int eeepc_hotk_thaw(struct device *device);
 static int eeepc_hotk_restore(struct device *device);
 
-static struct dev_pm_ops eeepc_pm_ops = {
+static const struct dev_pm_ops eeepc_pm_ops = {
 	.thaw = eeepc_hotk_thaw,
 	.restore = eeepc_hotk_restore,
 };
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -94,7 +94,7 @@ static struct rfkill *wifi_rfkill;
 static struct rfkill *bluetooth_rfkill;
 static struct rfkill *wwan_rfkill;
 
-static struct dev_pm_ops hp_wmi_pm_ops = {
+static const struct dev_pm_ops hp_wmi_pm_ops = {
 	.resume  = hp_wmi_resume_handler,
 	.restore  = hp_wmi_resume_handler,
 };
--- a/drivers/power/wm97xx_battery.c
+++ b/drivers/power/wm97xx_battery.c
@@ -157,7 +157,7 @@ static int wm97xx_bat_resume(struct device *dev)
 	return 0;
 }
 
-static struct dev_pm_ops wm97xx_bat_pm_ops = {
+static const struct dev_pm_ops wm97xx_bat_pm_ops = {
 	.suspend	= wm97xx_bat_suspend,
 	.resume		= wm97xx_bat_resume,
 };
--- a/drivers/rtc/rtc-pxa.c
+++ b/drivers/rtc/rtc-pxa.c
@@ -456,7 +456,7 @@ static int pxa_rtc_resume(struct device *dev)
 	return 0;
 }
 
-static struct dev_pm_ops pxa_rtc_pm_ops = {
+static const struct dev_pm_ops pxa_rtc_pm_ops = {
 	.suspend	= pxa_rtc_suspend,
 	.resume		= pxa_rtc_resume,
 };
--- a/drivers/rtc/rtc-sa1100.c
+++ b/drivers/rtc/rtc-sa1100.c
@@ -407,7 +407,7 @@ static int sa1100_rtc_resume(struct device *dev)
 	return 0;
 }
 
-static struct dev_pm_ops sa1100_rtc_pm_ops = {
+static const struct dev_pm_ops sa1100_rtc_pm_ops = {
 	.suspend	= sa1100_rtc_suspend,
 	.resume		= sa1100_rtc_resume,
 };
--- a/drivers/rtc/rtc-sh.c
+++ b/drivers/rtc/rtc-sh.c
@@ -826,7 +826,7 @@ static int sh_rtc_resume(struct device *dev)
 	return 0;
 }
 
-static struct dev_pm_ops sh_rtc_dev_pm_ops = {
+static const struct dev_pm_ops sh_rtc_dev_pm_ops = {
 	.suspend = sh_rtc_suspend,
 	.resume = sh_rtc_resume,
 };
--- a/drivers/rtc/rtc-wm831x.c
+++ b/drivers/rtc/rtc-wm831x.c
@@ -485,7 +485,7 @@ static int __devexit wm831x_rtc_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static struct dev_pm_ops wm831x_rtc_pm_ops = {
+static const struct dev_pm_ops wm831x_rtc_pm_ops = {
 	.suspend = wm831x_rtc_suspend,
 	.resume = wm831x_rtc_resume,
 
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -1005,7 +1005,7 @@ static int dcssblk_thaw(struct device *dev)
 	return 0;
 }
 
-static struct dev_pm_ops dcssblk_pm_ops = {
+static const struct dev_pm_ops dcssblk_pm_ops = {
 	.freeze		= dcssblk_freeze,
 	.thaw		= dcssblk_thaw,
 	.restore	= dcssblk_restore,
--- a/drivers/s390/block/xpram.c
+++ b/drivers/s390/block/xpram.c
@@ -407,7 +407,7 @@ static int xpram_restore(struct device *dev)
 	return 0;
 }
 
-static struct dev_pm_ops xpram_pm_ops = {
+static const struct dev_pm_ops xpram_pm_ops = {
 	.restore	= xpram_restore,
 };
 
--- a/drivers/s390/char/monreader.c
+++ b/drivers/s390/char/monreader.c
@@ -532,7 +532,7 @@ static int monreader_restore(struct device *dev)
 	return monreader_thaw(dev);
 }
 
-static struct dev_pm_ops monreader_pm_ops = {
+static const struct dev_pm_ops monreader_pm_ops = {
 	.freeze  = monreader_freeze,
 	.thaw	 = monreader_thaw,
 	.restore = monreader_restore,
--- a/drivers/s390/char/monwriter.c
+++ b/drivers/s390/char/monwriter.c
@@ -326,7 +326,7 @@ static int monwriter_thaw(struct device *dev)
 	return monwriter_restore(dev);
 }
 
-static struct dev_pm_ops monwriter_pm_ops = {
+static const struct dev_pm_ops monwriter_pm_ops = {
 	.freeze		= monwriter_freeze,
 	.thaw		= monwriter_thaw,
 	.restore	= monwriter_restore,
--- a/drivers/s390/char/sclp.c
+++ b/drivers/s390/char/sclp.c
@@ -1019,7 +1019,7 @@ static int sclp_restore(struct device *dev)
 	return sclp_undo_suspend(SCLP_PM_EVENT_RESTORE);
 }
 
-static struct dev_pm_ops sclp_pm_ops = {
+static const struct dev_pm_ops sclp_pm_ops = {
 	.freeze		= sclp_freeze,
 	.thaw		= sclp_thaw,
 	.restore	= sclp_restore,
--- a/drivers/s390/char/sclp_cmd.c
+++ b/drivers/s390/char/sclp_cmd.c
@@ -546,7 +546,7 @@ struct read_storage_sccb {
 	u32 entries[0];
 } __packed;
 
-static struct dev_pm_ops sclp_mem_pm_ops = {
+static const struct dev_pm_ops sclp_mem_pm_ops = {
 	.freeze		= sclp_mem_freeze,
 };
 
--- a/drivers/s390/char/vmlogrdr.c
+++ b/drivers/s390/char/vmlogrdr.c
@@ -679,7 +679,7 @@ static int vmlogrdr_pm_prepare(struct device *dev)
 }
 
 
-static struct dev_pm_ops vmlogrdr_pm_ops = {
+static const struct dev_pm_ops vmlogrdr_pm_ops = {
 	.prepare = vmlogrdr_pm_prepare,
 };
 
--- a/drivers/s390/cio/ccwgroup.c
+++ b/drivers/s390/cio/ccwgroup.c
@@ -560,7 +560,7 @@ static int ccwgroup_pm_restore(struct device *dev)
 	return gdrv->restore ? gdrv->restore(gdev) : 0;
 }
 
-static struct dev_pm_ops ccwgroup_pm_ops = {
+static const struct dev_pm_ops ccwgroup_pm_ops = {
 	.prepare = ccwgroup_pm_prepare,
 	.complete = ccwgroup_pm_complete,
 	.freeze = ccwgroup_pm_freeze,
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -1095,7 +1095,7 @@ static int css_pm_restore(struct device *dev)
 	return drv->restore ? drv->restore(sch) : 0;
 }
 
-static struct dev_pm_ops css_pm_ops = {
+static const struct dev_pm_ops css_pm_ops = {
 	.prepare = css_pm_prepare,
 	.complete = css_pm_complete,
 	.freeze = css_pm_freeze,
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -2147,7 +2147,7 @@ out_unlock:
 	return ret;
 }
 
-static struct dev_pm_ops ccw_pm_ops = {
+static const struct dev_pm_ops ccw_pm_ops = {
 	.prepare = ccw_device_pm_prepare,
 	.complete = ccw_device_pm_complete,
 	.freeze = ccw_device_pm_freeze,
--- a/drivers/s390/net/netiucv.c
+++ b/drivers/s390/net/netiucv.c
@@ -161,7 +161,7 @@ static void netiucv_pm_complete(struct device *);
 static int netiucv_pm_freeze(struct device *);
 static int netiucv_pm_restore_thaw(struct device *);
 
-static struct dev_pm_ops netiucv_pm_ops = {
+static const struct dev_pm_ops netiucv_pm_ops = {
 	.prepare = netiucv_pm_prepare,
 	.complete = netiucv_pm_complete,
 	.freeze = netiucv_pm_freeze,
--- a/drivers/s390/net/smsgiucv.c
+++ b/drivers/s390/net/smsgiucv.c
@@ -163,7 +163,7 @@ static int smsg_pm_restore_thaw(struct device *dev)
 	return 0;
 }
 
-static struct dev_pm_ops smsg_pm_ops = {
+static const struct dev_pm_ops smsg_pm_ops = {
 	.freeze = smsg_pm_freeze,
 	.thaw = smsg_pm_restore_thaw,
 	.restore = smsg_pm_restore_thaw,
--- a/drivers/serial/pxa.c
+++ b/drivers/serial/pxa.c
@@ -747,7 +747,7 @@ static int serial_pxa_resume(struct device *dev)
         return 0;
 }
 
-static struct dev_pm_ops serial_pxa_pm_ops = {
+static const struct dev_pm_ops serial_pxa_pm_ops = {
 	.suspend	= serial_pxa_suspend,
 	.resume		= serial_pxa_resume,
 };
--- a/drivers/serial/sh-sci.c
+++ b/drivers/serial/sh-sci.c
@@ -1363,7 +1363,7 @@ static int sci_resume(struct device *dev)
 	return 0;
 }
 
-static struct dev_pm_ops sci_dev_pm_ops = {
+static const struct dev_pm_ops sci_dev_pm_ops = {
 	.suspend	= sci_suspend,
 	.resume		= sci_resume,
 };
--- a/drivers/spi/pxa2xx_spi.c
+++ b/drivers/spi/pxa2xx_spi.c
@@ -1709,7 +1709,7 @@ static int pxa2xx_spi_resume(struct device *dev)
 	return 0;
 }
 
-static struct dev_pm_ops pxa2xx_spi_pm_ops = {
+static const struct dev_pm_ops pxa2xx_spi_pm_ops = {
 	.suspend	= pxa2xx_spi_suspend,
 	.resume		= pxa2xx_spi_resume,
 };
--- a/drivers/spi/spi_s3c24xx.c
+++ b/drivers/spi/spi_s3c24xx.c
@@ -489,7 +489,7 @@ static int s3c24xx_spi_resume(struct device *dev)
 	return 0;
 }
 
-static struct dev_pm_ops s3c24xx_spi_pmops = {
+static const struct dev_pm_ops s3c24xx_spi_pmops = {
 	.suspend	= s3c24xx_spi_suspend,
 	.resume		= s3c24xx_spi_resume,
 };
--- a/drivers/uio/uio_pdrv_genirq.c
+++ b/drivers/uio/uio_pdrv_genirq.c
@@ -209,7 +209,7 @@ static int uio_pdrv_genirq_runtime_nop(struct device *dev)
 	return 0;
 }
 
-static struct dev_pm_ops uio_pdrv_genirq_dev_pm_ops = {
+static const struct dev_pm_ops uio_pdrv_genirq_dev_pm_ops = {
 	.runtime_suspend = uio_pdrv_genirq_runtime_nop,
 	.runtime_resume = uio_pdrv_genirq_runtime_nop,
 };
--- a/drivers/usb/core/hcd-pci.c
+++ b/drivers/usb/core/hcd-pci.c
@@ -363,7 +363,7 @@ static int hcd_pci_restore(struct device *dev)
 	return resume_common(dev, true);
 }
 
-struct dev_pm_ops usb_hcd_pci_pm_ops = {
+const struct dev_pm_ops usb_hcd_pci_pm_ops = {
 	.suspend	= hcd_pci_suspend,
 	.suspend_noirq	= hcd_pci_suspend_noirq,
 	.resume_noirq	= hcd_pci_resume_noirq,
--- a/drivers/usb/core/hcd.h
+++ b/drivers/usb/core/hcd.h
@@ -315,7 +315,7 @@ extern void usb_hcd_pci_remove(struct pci_dev *dev);
 extern void usb_hcd_pci_shutdown(struct pci_dev *dev);
 
 #ifdef CONFIG_PM_SLEEP
-extern struct dev_pm_ops	usb_hcd_pci_pm_ops;
+extern const struct dev_pm_ops usb_hcd_pci_pm_ops;
 #endif
 #endif /* CONFIG_PCI */
 
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -291,7 +291,7 @@ static int usb_dev_restore(struct device *dev)
 	return usb_resume(dev, PMSG_RESTORE);
 }
 
-static struct dev_pm_ops usb_device_pm_ops = {
+static const struct dev_pm_ops usb_device_pm_ops = {
 	.prepare =	usb_dev_prepare,
 	.complete =	usb_dev_complete,
 	.suspend =	usb_dev_suspend,
--- a/drivers/usb/host/ehci-au1xxx.c
+++ b/drivers/usb/host/ehci-au1xxx.c
@@ -297,7 +297,7 @@ static int ehci_hcd_au1xxx_drv_resume(struct device *dev)
 	return 0;
 }
 
-static struct dev_pm_ops au1xxx_ehci_pmops = {
+static const struct dev_pm_ops au1xxx_ehci_pmops = {
 	.suspend	= ehci_hcd_au1xxx_drv_suspend,
 	.resume		= ehci_hcd_au1xxx_drv_resume,
 };
--- a/drivers/usb/host/ohci-au1xxx.c
+++ b/drivers/usb/host/ohci-au1xxx.c
@@ -294,7 +294,7 @@ static int ohci_hcd_au1xxx_drv_resume(struct device *dev)
 	return 0;
 }
 
-static struct dev_pm_ops au1xxx_ohci_pmops = {
+static const struct dev_pm_ops au1xxx_ohci_pmops = {
 	.suspend	= ohci_hcd_au1xxx_drv_suspend,
 	.resume		= ohci_hcd_au1xxx_drv_resume,
 };
--- a/drivers/usb/host/ohci-pxa27x.c
+++ b/drivers/usb/host/ohci-pxa27x.c
@@ -518,7 +518,7 @@ static int ohci_hcd_pxa27x_drv_resume(struct device *dev)
 	return 0;
 }
 
-static struct dev_pm_ops ohci_hcd_pxa27x_pm_ops = {
+static const struct dev_pm_ops ohci_hcd_pxa27x_pm_ops = {
 	.suspend	= ohci_hcd_pxa27x_drv_suspend,
 	.resume		= ohci_hcd_pxa27x_drv_resume,
 };
--- a/drivers/usb/host/r8a66597-hcd.c
+++ b/drivers/usb/host/r8a66597-hcd.c
@@ -2354,7 +2354,7 @@ static int r8a66597_resume(struct device *dev)
 	return 0;
 }
 
-static struct dev_pm_ops r8a66597_dev_pm_ops = {
+static const struct dev_pm_ops r8a66597_dev_pm_ops = {
 	.suspend = r8a66597_suspend,
 	.resume = r8a66597_resume,
 	.poweroff = r8a66597_suspend,
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -2216,7 +2216,7 @@ static int musb_resume_noirq(struct device *dev)
 	return 0;
 }
 
-static struct dev_pm_ops musb_dev_pm_ops = {
+static const struct dev_pm_ops musb_dev_pm_ops = {
 	.suspend	= musb_suspend,
 	.resume_noirq	= musb_resume_noirq,
 };
--- a/drivers/video/backlight/da903x_bl.c
+++ b/drivers/video/backlight/da903x_bl.c
@@ -170,7 +170,7 @@ static int da903x_backlight_resume(struct device *dev)
 	return 0;
 }
 
-static struct dev_pm_ops da903x_backlight_pm_ops = {
+static const struct dev_pm_ops da903x_backlight_pm_ops = {
 	.suspend	= da903x_backlight_suspend,
 	.resume		= da903x_backlight_resume,
 };
--- a/drivers/video/hitfb.c
+++ b/drivers/video/hitfb.c
@@ -456,7 +456,7 @@ static int hitfb_resume(struct device *dev)
 	return 0;
 }
 
-static struct dev_pm_ops hitfb_dev_pm_ops = {
+static const struct dev_pm_ops hitfb_dev_pm_ops = {
 	.suspend	= hitfb_suspend,
 	.resume		= hitfb_resume,
 };
--- a/drivers/video/pxafb.c
+++ b/drivers/video/pxafb.c
@@ -1654,7 +1654,7 @@ static int pxafb_resume(struct device *dev)
 	return 0;
 }
 
-static struct dev_pm_ops pxafb_pm_ops = {
+static const struct dev_pm_ops pxafb_pm_ops = {
 	.suspend	= pxafb_suspend,
 	.resume		= pxafb_resume,
 };
--- a/drivers/video/sh_mobile_lcdcfb.c
+++ b/drivers/video/sh_mobile_lcdcfb.c
@@ -874,7 +874,7 @@ static int sh_mobile_lcdc_runtime_resume(struct device *dev)
 	return 0;
 }
 
-static struct dev_pm_ops sh_mobile_lcdc_dev_pm_ops = {
+static const struct dev_pm_ops sh_mobile_lcdc_dev_pm_ops = {
 	.suspend = sh_mobile_lcdc_suspend,
 	.resume = sh_mobile_lcdc_resume,
 	.runtime_suspend = sh_mobile_lcdc_runtime_suspend,
--- a/drivers/watchdog/adx_wdt.c
+++ b/drivers/watchdog/adx_wdt.c
@@ -314,7 +314,7 @@ static int adx_wdt_resume(struct device *dev)
 	return 0;
 }
 
-static struct dev_pm_ops adx_wdt_pm_ops = {
+static const struct dev_pm_ops adx_wdt_pm_ops = {
 	.suspend = adx_wdt_suspend,
 	.resume = adx_wdt_resume,
 };
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -218,7 +218,7 @@ struct dev_pm_ops {
  * to RAM and hibernation.
  */
 #define SIMPLE_DEV_PM_OPS(name, suspend_fn, resume_fn) \
-struct dev_pm_ops name = { \
+const struct dev_pm_ops name = { \
 	.suspend = suspend_fn, \
 	.resume = resume_fn, \
 	.freeze = suspend_fn, \
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -221,7 +221,7 @@ static int afiucv_pm_restore_thaw(struct device *dev)
 	return 0;
 }
 
-static struct dev_pm_ops afiucv_pm_ops = {
+static const struct dev_pm_ops afiucv_pm_ops = {
 	.prepare = afiucv_pm_prepare,
 	.complete = afiucv_pm_complete,
 	.freeze = afiucv_pm_freeze,
--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -93,7 +93,7 @@ static int iucv_pm_freeze(struct device *);
 static int iucv_pm_thaw(struct device *);
 static int iucv_pm_restore(struct device *);
 
-static struct dev_pm_ops iucv_pm_ops = {
+static const struct dev_pm_ops iucv_pm_ops = {
 	.prepare = iucv_pm_prepare,
 	.complete = iucv_pm_complete,
 	.freeze = iucv_pm_freeze,
--- a/sound/arm/pxa2xx-ac97.c
+++ b/sound/arm/pxa2xx-ac97.c
@@ -159,7 +159,7 @@ static int pxa2xx_ac97_resume(struct device *dev)
 	return ret;
 }
 
-static struct dev_pm_ops pxa2xx_ac97_pm_ops = {
+static const struct dev_pm_ops pxa2xx_ac97_pm_ops = {
 	.suspend	= pxa2xx_ac97_suspend,
 	.resume		= pxa2xx_ac97_resume,
 };
--- a/sound/soc/s3c24xx/s3c24xx_simtec.c
+++ b/sound/soc/s3c24xx/s3c24xx_simtec.c
@@ -312,7 +312,7 @@ int simtec_audio_resume(struct device *dev)
 	return 0;
 }
 
-struct dev_pm_ops simtec_audio_pmops = {
+const struct dev_pm_ops simtec_audio_pmops = {
 	.resume	= simtec_audio_resume,
 };
 EXPORT_SYMBOL_GPL(simtec_audio_pmops);
--- a/sound/soc/s3c24xx/s3c24xx_simtec.h
+++ b/sound/soc/s3c24xx/s3c24xx_simtec.h
@@ -15,7 +15,7 @@ extern int simtec_audio_core_probe(struct platform_device *pdev,
 extern int simtec_audio_remove(struct platform_device *pdev);
 
 #ifdef CONFIG_PM
-extern struct dev_pm_ops simtec_audio_pmops;
+extern const struct dev_pm_ops simtec_audio_pmops;
 #define simtec_audio_pm &simtec_audio_pmops
 #else
 #define simtec_audio_pm NULL
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1040,7 +1040,7 @@ static int soc_poweroff(struct device *dev)
 	return 0;
 }
 
-static struct dev_pm_ops soc_pm_ops = {
+static const struct dev_pm_ops soc_pm_ops = {
 	.suspend = soc_suspend,
 	.resume = soc_resume,
 	.poweroff = soc_poweroff,
