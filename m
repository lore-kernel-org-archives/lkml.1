Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbYHQOjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbYHQOjY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 10:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbYHQOjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 10:39:16 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:56850 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335AbYHQOjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 10:39:13 -0400
Date: Sun, 17 Aug 2008 17:36:59 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] removed unused #include <linux/version.h>'s
Message-ID: <20080817143659.GA24619@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch lets the files using linux/version.h match the files that
#include it.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 28 Apr 2008

@Linus:

I just noticed you take such patches directly.

I still haven't gotten the logic which patches you are taking directly 
and which not, and in this case this resulted in someone duplicating 
work I already did.

Please also apply this old patch of mine (rediffed against your tree) 
that does exactly the same, but for more files at once.

If Huang Weiyi's approach of splitting it is preferred I can also resend 
this patch to you as a patch series of 94 patches.

 arch/arm/plat-omap/clock.c                   |    1 -
 arch/cris/arch-v32/kernel/fasttimer.c        |    2 --
 arch/mn10300/kernel/mn10300-serial.c         |    1 -
 arch/powerpc/sysdev/bestcomm/gen_bd.c        |    1 -
 arch/x86/mach-rdc321x/platform.c             |    1 -
 drivers/atm/adummy.c                         |    1 -
 drivers/char/xilinx_hwicap/buffer_icap.h     |    1 -
 drivers/char/xilinx_hwicap/fifo_icap.h       |    1 -
 drivers/char/xilinx_hwicap/xilinx_hwicap.h   |    1 -
 drivers/edac/edac_core.h                     |    1 -
 drivers/i2c/busses/i2c-at91.c                |    1 -
 drivers/infiniband/hw/ehca/ehca_tools.h      |    1 -
 drivers/infiniband/hw/ipath/ipath_fs.c       |    1 -
 drivers/infiniband/hw/nes/nes.h              |    1 -
 drivers/infiniband/ulp/iser/iser_verbs.c     |    1 -
 drivers/input/keyboard/bf54x-keys.c          |    1 -
 drivers/input/keyboard/gpio_keys.c           |    2 --
 drivers/input/mouse/gpio_mouse.c             |    1 -
 drivers/input/tablet/gtco.c                  |    1 -
 drivers/input/touchscreen/mainstone-wm97xx.c |    1 -
 drivers/input/touchscreen/wm9705.c           |    1 -
 drivers/input/touchscreen/wm9712.c           |    1 -
 drivers/input/touchscreen/wm9713.c           |    1 -
 drivers/input/touchscreen/wm97xx-core.c      |    1 -
 drivers/mfd/asic3.c                          |    1 -
 drivers/misc/eeprom_93cx6.c                  |    1 -
 drivers/mtd/maps/amd76xrom.c                 |    1 -
 drivers/mtd/maps/ck804xrom.c                 |    1 -
 drivers/mtd/maps/esb2rom.c                   |    1 -
 drivers/mtd/nand/au1550nd.c                  |    1 -
 drivers/net/acenic.c                         |    1 -
 drivers/net/cpmac.c                          |    1 -
 drivers/net/gianfar_sysfs.c                  |    1 -
 drivers/net/ipg.h                            |    3 ---
 drivers/net/myri10ge/myri10ge.c              |    1 -
 drivers/net/netxen/netxen_nic.h              |    1 -
 drivers/net/netxen/netxen_nic_ethtool.c      |    1 -
 drivers/net/netxen/netxen_nic_hdr.h          |    2 --
 drivers/net/ppp_mppe.c                       |    1 -
 drivers/net/pppol2tp.c                       |    1 -
 drivers/net/r6040.c                          |    1 -
 drivers/net/sky2.c                           |    1 -
 drivers/net/tehuti.h                         |    1 -
 drivers/net/tokenring/lanstreamer.c          |    1 -
 drivers/net/tokenring/lanstreamer.h          |    2 --
 drivers/net/typhoon.c                        |    1 -
 drivers/net/wireless/ath5k/base.c            |    1 -
 drivers/net/wireless/b43/main.c              |    1 -
 drivers/net/wireless/b43legacy/main.c        |    1 -
 drivers/net/wireless/ipw2100.c               |    1 -
 drivers/net/wireless/ipw2200.c               |    1 -
 drivers/net/wireless/iwlwifi/iwl-3945-led.c  |    1 -
 drivers/net/wireless/iwlwifi/iwl-3945.c      |    1 -
 drivers/net/wireless/iwlwifi/iwl-4965.c      |    1 -
 drivers/net/wireless/iwlwifi/iwl-core.c      |    1 -
 drivers/net/wireless/iwlwifi/iwl-eeprom.c    |    1 -
 drivers/net/wireless/iwlwifi/iwl-hcmd.c      |    1 -
 drivers/net/wireless/iwlwifi/iwl-led.c       |    1 -
 drivers/net/wireless/iwlwifi/iwl-rfkill.c    |    1 -
 drivers/net/wireless/iwlwifi/iwl3945-base.c  |    1 -
 drivers/rtc/rtc-max6902.c                    |    2 --
 drivers/rtc/rtc-r9701.c                      |    1 -
 drivers/s390/net/ctcm_mpc.c                  |    1 -
 drivers/scsi/dpt/dpti_i2o.h                  |    1 -
 drivers/scsi/ips.c                           |    1 -
 drivers/scsi/ips.h                           |    1 -
 drivers/scsi/lpfc/lpfc_debugfs.c             |    1 -
 drivers/scsi/nsp32.c                         |    1 -
 drivers/scsi/nsp32.h                         |    1 -
 drivers/scsi/pcmcia/nsp_cs.c                 |    1 -
 drivers/scsi/qla2xxx/qla_mid.c               |    1 -
 drivers/usb/atm/ueagle-atm.c                 |    1 -
 drivers/usb/gadget/amd5536udc.c              |    1 -
 drivers/usb/gadget/s3c2410_udc.c             |    1 -
 drivers/usb/misc/iowarrior.c                 |    1 -
 drivers/usb/serial/garmin_gps.c              |    2 --
 drivers/video/arkfb.c                        |    1 -
 drivers/video/s3fb.c                         |    1 -
 drivers/video/vermilion/vermilion.h          |    1 -
 drivers/video/vt8623fb.c                     |    1 -
 drivers/video/xilinxfb.c                     |    1 -
 fs/jffs2/jffs2_fs_i.h                        |    1 -
 fs/xfs/xfs_dmapi.h                           |    1 -
 include/asm-x86/xen/hypervisor.h             |    1 -
 include/linux/fs_uart_pd.h                   |    1 -
 kernel/nsproxy.c                             |    1 -
 kernel/power/swap.c                          |    1 -
 kernel/user_namespace.c                      |    1 -
 kernel/utsname.c                             |    1 -
 kernel/utsname_sysctl.c                      |    1 -
 sound/mips/au1x00.c                          |    1 -
 sound/soc/at91/eti_b1_wm8731.c               |    1 -
 sound/soc/codecs/wm8753.c                    |    1 -
 sound/soc/codecs/wm9712.c                    |    1 -
 94 files changed, 102 deletions(-)

9f6b83a824e9b45f671c188cfa22e43b109eca29 
diff --git a/arch/arm/plat-omap/clock.c b/arch/arm/plat-omap/clock.c
index 23a0705..197974d 100644
--- a/arch/arm/plat-omap/clock.c
+++ b/arch/arm/plat-omap/clock.c
@@ -10,7 +10,6 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/module.h>
diff --git a/arch/cris/arch-v32/kernel/fasttimer.c b/arch/cris/arch-v32/kernel/fasttimer.c
index 2de9d58..111caa1 100644
--- a/arch/cris/arch-v32/kernel/fasttimer.c
+++ b/arch/cris/arch-v32/kernel/fasttimer.c
@@ -19,8 +19,6 @@
 #include <asm/irq.h>
 #include <asm/system.h>
 
-#include <linux/version.h>
-
 #include <hwregs/reg_map.h>
 #include <hwregs/reg_rdwr.h>
 #include <hwregs/timer_defs.h>
diff --git a/arch/mn10300/kernel/mn10300-serial.c b/arch/mn10300/kernel/mn10300-serial.c
index 8b054e7..aa07d0c 100644
--- a/arch/mn10300/kernel/mn10300-serial.c
+++ b/arch/mn10300/kernel/mn10300-serial.c
@@ -17,7 +17,6 @@ static const char serial_revdate[] = "2007-11-06";
 #define SUPPORT_SYSRQ
 #endif
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/serial.h>
 #include <linux/circ_buf.h>
diff --git a/arch/powerpc/sysdev/bestcomm/gen_bd.c b/arch/powerpc/sysdev/bestcomm/gen_bd.c
index a3a134c..e0a53e3 100644
--- a/arch/powerpc/sysdev/bestcomm/gen_bd.c
+++ b/arch/powerpc/sysdev/bestcomm/gen_bd.c
@@ -11,7 +11,6 @@
  *
  */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
diff --git a/arch/x86/mach-rdc321x/platform.c b/arch/x86/mach-rdc321x/platform.c
index a037041..4f4e50c 100644
--- a/arch/x86/mach-rdc321x/platform.c
+++ b/arch/x86/mach-rdc321x/platform.c
@@ -25,7 +25,6 @@
 #include <linux/list.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
-#include <linux/version.h>
 #include <linux/leds.h>
 
 #include <asm/gpio.h>
diff --git a/drivers/atm/adummy.c b/drivers/atm/adummy.c
index 2ebd07f..5effec6 100644
--- a/drivers/atm/adummy.c
+++ b/drivers/atm/adummy.c
@@ -3,7 +3,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/skbuff.h>
 #include <linux/errno.h>
diff --git a/drivers/char/xilinx_hwicap/buffer_icap.h b/drivers/char/xilinx_hwicap/buffer_icap.h
index c5b1840..8b0252b 100644
--- a/drivers/char/xilinx_hwicap/buffer_icap.h
+++ b/drivers/char/xilinx_hwicap/buffer_icap.h
@@ -38,7 +38,6 @@
 
 #include <linux/types.h>
 #include <linux/cdev.h>
-#include <linux/version.h>
 #include <linux/platform_device.h>
 
 #include <asm/io.h>
diff --git a/drivers/char/xilinx_hwicap/fifo_icap.h b/drivers/char/xilinx_hwicap/fifo_icap.h
index ffabd3b..62bda45 100644
--- a/drivers/char/xilinx_hwicap/fifo_icap.h
+++ b/drivers/char/xilinx_hwicap/fifo_icap.h
@@ -38,7 +38,6 @@
 
 #include <linux/types.h>
 #include <linux/cdev.h>
-#include <linux/version.h>
 #include <linux/platform_device.h>
 
 #include <asm/io.h>
diff --git a/drivers/char/xilinx_hwicap/xilinx_hwicap.h b/drivers/char/xilinx_hwicap/xilinx_hwicap.h
index 1f9c8b0..24d0d9b 100644
--- a/drivers/char/xilinx_hwicap/xilinx_hwicap.h
+++ b/drivers/char/xilinx_hwicap/xilinx_hwicap.h
@@ -38,7 +38,6 @@
 
 #include <linux/types.h>
 #include <linux/cdev.h>
-#include <linux/version.h>
 #include <linux/platform_device.h>
 
 #include <asm/io.h>
diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
index b27b13c..4b55ec6 100644
--- a/drivers/edac/edac_core.h
+++ b/drivers/edac/edac_core.h
@@ -34,7 +34,6 @@
 #include <linux/platform_device.h>
 #include <linux/sysdev.h>
 #include <linux/workqueue.h>
-#include <linux/version.h>
 
 #define EDAC_MC_LABEL_LEN	31
 #define EDAC_DEVICE_NAME_LEN	31
diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
index c1adcdb..9efb021 100644
--- a/drivers/i2c/busses/i2c-at91.c
+++ b/drivers/i2c/busses/i2c-at91.c
@@ -14,7 +14,6 @@
 */
 
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/err.h>
 #include <linux/slab.h>
diff --git a/drivers/infiniband/hw/ehca/ehca_tools.h b/drivers/infiniband/hw/ehca/ehca_tools.h
index ec950bf..21f7d06 100644
--- a/drivers/infiniband/hw/ehca/ehca_tools.h
+++ b/drivers/infiniband/hw/ehca/ehca_tools.h
@@ -54,7 +54,6 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/vmalloc.h>
-#include <linux/version.h>
 #include <linux/notifier.h>
 #include <linux/cpu.h>
 #include <linux/device.h>
diff --git a/drivers/infiniband/hw/ipath/ipath_fs.c b/drivers/infiniband/hw/ipath/ipath_fs.c
index 23faba9..8bb5170 100644
--- a/drivers/infiniband/hw/ipath/ipath_fs.c
+++ b/drivers/infiniband/hw/ipath/ipath_fs.c
@@ -31,7 +31,6 @@
  * SOFTWARE.
  */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/mount.h>
diff --git a/drivers/infiniband/hw/nes/nes.h b/drivers/infiniband/hw/nes/nes.h
index 39bd897..8eb7ae9 100644
--- a/drivers/infiniband/hw/nes/nes.h
+++ b/drivers/infiniband/hw/nes/nes.h
@@ -43,7 +43,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/workqueue.h>
 #include <linux/slab.h>
-#include <linux/version.h>
 #include <asm/io.h>
 #include <linux/crc32c.h>
 
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 63462ec..26ff621 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -33,7 +33,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/delay.h>
-#include <linux/version.h>
 
 #include "iscsi_iser.h"
 
diff --git a/drivers/input/keyboard/bf54x-keys.c b/drivers/input/keyboard/bf54x-keys.c
index 54ed8e2..6f227d3 100644
--- a/drivers/input/keyboard/bf54x-keys.c
+++ b/drivers/input/keyboard/bf54x-keys.c
@@ -29,7 +29,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/version.h>
 
 #include <linux/init.h>
 #include <linux/fs.h>
diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
index 3f48279..b11b30e 100644
--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -9,8 +9,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/version.h>
-
 #include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/interrupt.h>
diff --git a/drivers/input/mouse/gpio_mouse.c b/drivers/input/mouse/gpio_mouse.c
index 8617ee8..0db8d16 100644
--- a/drivers/input/mouse/gpio_mouse.c
+++ b/drivers/input/mouse/gpio_mouse.c
@@ -9,7 +9,6 @@
  */
 
 #include <linux/init.h>
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/input-polldev.h>
diff --git a/drivers/input/tablet/gtco.c b/drivers/input/tablet/gtco.c
index b9b7a98..7df0228 100644
--- a/drivers/input/tablet/gtco.c
+++ b/drivers/input/tablet/gtco.c
@@ -64,7 +64,6 @@ Scott Hill shill@gtcocalcomp.com
 #include <asm/byteorder.h>
 
 
-#include <linux/version.h>
 #include <linux/usb/input.h>
 
 /* Version with a Major number of 2 is for kernel inclusion only. */
diff --git a/drivers/input/touchscreen/mainstone-wm97xx.c b/drivers/input/touchscreen/mainstone-wm97xx.c
index 283f93a..37a555f 100644
--- a/drivers/input/touchscreen/mainstone-wm97xx.c
+++ b/drivers/input/touchscreen/mainstone-wm97xx.c
@@ -25,7 +25,6 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/delay.h>
diff --git a/drivers/input/touchscreen/wm9705.c b/drivers/input/touchscreen/wm9705.c
index 978e1a1..372efbc 100644
--- a/drivers/input/touchscreen/wm9705.c
+++ b/drivers/input/touchscreen/wm9705.c
@@ -17,7 +17,6 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/input.h>
 #include <linux/delay.h>
diff --git a/drivers/input/touchscreen/wm9712.c b/drivers/input/touchscreen/wm9712.c
index 4c5d85a..c8bb1e7 100644
--- a/drivers/input/touchscreen/wm9712.c
+++ b/drivers/input/touchscreen/wm9712.c
@@ -17,7 +17,6 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/input.h>
 #include <linux/delay.h>
diff --git a/drivers/input/touchscreen/wm9713.c b/drivers/input/touchscreen/wm9713.c
index 8384587..781ee83 100644
--- a/drivers/input/touchscreen/wm9713.c
+++ b/drivers/input/touchscreen/wm9713.c
@@ -17,7 +17,6 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/input.h>
 #include <linux/delay.h>
diff --git a/drivers/input/touchscreen/wm97xx-core.c b/drivers/input/touchscreen/wm97xx-core.c
index cdc24ad..d589ab0 100644
--- a/drivers/input/touchscreen/wm97xx-core.c
+++ b/drivers/input/touchscreen/wm97xx-core.c
@@ -37,7 +37,6 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/delay.h>
diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index c6408a6..bc2a807 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -16,7 +16,6 @@
  *
  */
 
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/irq.h>
 #include <linux/gpio.h>
diff --git a/drivers/misc/eeprom_93cx6.c b/drivers/misc/eeprom_93cx6.c
index ea55654..15b1780 100644
--- a/drivers/misc/eeprom_93cx6.c
+++ b/drivers/misc/eeprom_93cx6.c
@@ -26,7 +26,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/delay.h>
 #include <linux/eeprom_93cx6.h>
 
diff --git a/drivers/mtd/maps/amd76xrom.c b/drivers/mtd/maps/amd76xrom.c
index 948b86f..d1eec7d 100644
--- a/drivers/mtd/maps/amd76xrom.c
+++ b/drivers/mtd/maps/amd76xrom.c
@@ -6,7 +6,6 @@
 
 #include <linux/module.h>
 #include <linux/types.h>
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <asm/io.h>
diff --git a/drivers/mtd/maps/ck804xrom.c b/drivers/mtd/maps/ck804xrom.c
index effaf7c..1a6feb4 100644
--- a/drivers/mtd/maps/ck804xrom.c
+++ b/drivers/mtd/maps/ck804xrom.c
@@ -9,7 +9,6 @@
 
 #include <linux/module.h>
 #include <linux/types.h>
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <asm/io.h>
diff --git a/drivers/mtd/maps/esb2rom.c b/drivers/mtd/maps/esb2rom.c
index aa64a47..bbbcdd4 100644
--- a/drivers/mtd/maps/esb2rom.c
+++ b/drivers/mtd/maps/esb2rom.c
@@ -12,7 +12,6 @@
 
 #include <linux/module.h>
 #include <linux/types.h>
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <asm/io.h>
diff --git a/drivers/mtd/nand/au1550nd.c b/drivers/mtd/nand/au1550nd.c
index 761946e..92c334f 100644
--- a/drivers/mtd/nand/au1550nd.c
+++ b/drivers/mtd/nand/au1550nd.c
@@ -16,7 +16,6 @@
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/nand.h>
 #include <linux/mtd/partitions.h>
-#include <linux/version.h>
 #include <asm/io.h>
 
 #include <asm/mach-au1x00/au1xxx.h>
diff --git a/drivers/net/acenic.c b/drivers/net/acenic.c
index e4483de..66de80b 100644
--- a/drivers/net/acenic.c
+++ b/drivers/net/acenic.c
@@ -52,7 +52,6 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/version.h>
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/ioport.h>
diff --git a/drivers/net/cpmac.c b/drivers/net/cpmac.c
index a7800e5..ec6b0af 100644
--- a/drivers/net/cpmac.c
+++ b/drivers/net/cpmac.c
@@ -26,7 +26,6 @@
 #include <linux/errno.h>
 #include <linux/types.h>
 #include <linux/delay.h>
-#include <linux/version.h>
 
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
diff --git a/drivers/net/gianfar_sysfs.c b/drivers/net/gianfar_sysfs.c
index 5116f68..782c201 100644
--- a/drivers/net/gianfar_sysfs.c
+++ b/drivers/net/gianfar_sysfs.c
@@ -33,7 +33,6 @@
 
 #include <asm/uaccess.h>
 #include <linux/module.h>
-#include <linux/version.h>
 
 #include "gianfar.h"
 
diff --git a/drivers/net/ipg.h b/drivers/net/ipg.h
index e0e718a..dd6c12b 100644
--- a/drivers/net/ipg.h
+++ b/drivers/net/ipg.h
@@ -7,9 +7,7 @@
 #ifndef __LINUX_IPG_H
 #define __LINUX_IPG_H
 
-#include <linux/version.h>
 #include <linux/module.h>
-
 #include <linux/kernel.h>
 #include <linux/pci.h>
 #include <linux/ioport.h>
@@ -21,7 +19,6 @@
 #include <linux/etherdevice.h>
 #include <linux/init.h>
 #include <linux/skbuff.h>
-#include <linux/version.h>
 #include <asm/bitops.h>
 
 /*
diff --git a/drivers/net/myri10ge/myri10ge.c b/drivers/net/myri10ge/myri10ge.c
index f1de38f..f88e290 100644
--- a/drivers/net/myri10ge/myri10ge.c
+++ b/drivers/net/myri10ge/myri10ge.c
@@ -56,7 +56,6 @@
 #include <linux/ethtool.h>
 #include <linux/firmware.h>
 #include <linux/delay.h>
-#include <linux/version.h>
 #include <linux/timer.h>
 #include <linux/vmalloc.h>
 #include <linux/crc32.h>
diff --git a/drivers/net/netxen/netxen_nic.h b/drivers/net/netxen/netxen_nic.h
index 93a7b9b..bbf9616 100644
--- a/drivers/net/netxen/netxen_nic.h
+++ b/drivers/net/netxen/netxen_nic.h
@@ -45,7 +45,6 @@
 #include <linux/in.h>
 #include <linux/tcp.h>
 #include <linux/skbuff.h>
-#include <linux/version.h>
 
 #include <linux/ethtool.h>
 #include <linux/mii.h>
diff --git a/drivers/net/netxen/netxen_nic_ethtool.c b/drivers/net/netxen/netxen_nic_ethtool.c
index 4ad3e08..b974ca0 100644
--- a/drivers/net/netxen/netxen_nic_ethtool.c
+++ b/drivers/net/netxen/netxen_nic_ethtool.c
@@ -38,7 +38,6 @@
 #include <asm/io.h>
 #include <linux/netdevice.h>
 #include <linux/ethtool.h>
-#include <linux/version.h>
 
 #include "netxen_nic.h"
 #include "netxen_nic_hw.h"
diff --git a/drivers/net/netxen/netxen_nic_hdr.h b/drivers/net/netxen/netxen_nic_hdr.h
index e8e8d73..e80f9e3 100644
--- a/drivers/net/netxen/netxen_nic_hdr.h
+++ b/drivers/net/netxen/netxen_nic_hdr.h
@@ -32,8 +32,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/version.h>
-
 #include <linux/spinlock.h>
 #include <asm/irq.h>
 #include <linux/init.h>
diff --git a/drivers/net/ppp_mppe.c b/drivers/net/ppp_mppe.c
index b35d794..88f03c9 100644
--- a/drivers/net/ppp_mppe.c
+++ b/drivers/net/ppp_mppe.c
@@ -46,7 +46,6 @@
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/version.h>
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/slab.h>
diff --git a/drivers/net/pppol2tp.c b/drivers/net/pppol2tp.c
index f929882..ff175e8 100644
--- a/drivers/net/pppol2tp.c
+++ b/drivers/net/pppol2tp.c
@@ -61,7 +61,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/string.h>
 #include <linux/list.h>
 #include <asm/uaccess.h>
diff --git a/drivers/net/r6040.c b/drivers/net/r6040.c
index 6531ff5..5d86281 100644
--- a/drivers/net/r6040.c
+++ b/drivers/net/r6040.c
@@ -24,7 +24,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/moduleparam.h>
 #include <linux/string.h>
 #include <linux/timer.h>
diff --git a/drivers/net/sky2.c b/drivers/net/sky2.c
index 7d29edc..06dfc95 100644
--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -24,7 +24,6 @@
 
 #include <linux/crc32.h>
 #include <linux/kernel.h>
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
 #include <linux/dma-mapping.h>
diff --git a/drivers/net/tehuti.h b/drivers/net/tehuti.h
index c66dfc9..7db48f1 100644
--- a/drivers/net/tehuti.h
+++ b/drivers/net/tehuti.h
@@ -27,7 +27,6 @@
 #include <linux/sched.h>
 #include <linux/tty.h>
 #include <linux/if_vlan.h>
-#include <linux/version.h>
 #include <linux/interrupt.h>
 #include <linux/vmalloc.h>
 #include <asm/byteorder.h>
diff --git a/drivers/net/tokenring/lanstreamer.c b/drivers/net/tokenring/lanstreamer.c
index 47d84cd..59d1673 100644
--- a/drivers/net/tokenring/lanstreamer.c
+++ b/drivers/net/tokenring/lanstreamer.c
@@ -119,7 +119,6 @@
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/spinlock.h>
-#include <linux/version.h>
 #include <linux/bitops.h>
 #include <linux/jiffies.h>
 
diff --git a/drivers/net/tokenring/lanstreamer.h b/drivers/net/tokenring/lanstreamer.h
index e7bb349..13ccee6 100644
--- a/drivers/net/tokenring/lanstreamer.h
+++ b/drivers/net/tokenring/lanstreamer.h
@@ -60,8 +60,6 @@
  *
  */
 
-#include <linux/version.h>
-
 /* MAX_INTR - the maximum number of times we can loop
  * inside the interrupt function before returning
  * control to the OS (maximum value is 256)
diff --git a/drivers/net/typhoon.c b/drivers/net/typhoon.c
index 8549f11..734ce09 100644
--- a/drivers/net/typhoon.c
+++ b/drivers/net/typhoon.c
@@ -128,7 +128,6 @@ static const int multicast_filter_limit = 32;
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include <linux/in6.h>
-#include <linux/version.h>
 #include <linux/dma-mapping.h>
 
 #include "typhoon.h"
diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 2028866..88b9cb4 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -40,7 +40,6 @@
  *
  */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/hardirq.h>
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index a655bb5..6884ef7 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -33,7 +33,6 @@
 #include <linux/moduleparam.h>
 #include <linux/if_arp.h>
 #include <linux/etherdevice.h>
-#include <linux/version.h>
 #include <linux/firmware.h>
 #include <linux/wireless.h>
 #include <linux/workqueue.h>
diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index 2541c81..1cb77db 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -34,7 +34,6 @@
 #include <linux/moduleparam.h>
 #include <linux/if_arp.h>
 #include <linux/etherdevice.h>
-#include <linux/version.h>
 #include <linux/firmware.h>
 #include <linux/wireless.h>
 #include <linux/workqueue.h>
diff --git a/drivers/net/wireless/ipw2100.c b/drivers/net/wireless/ipw2100.c
index c6f886e..19a401c 100644
--- a/drivers/net/wireless/ipw2100.c
+++ b/drivers/net/wireless/ipw2100.c
@@ -157,7 +157,6 @@ that only one external action is invoked at a time.
 #include <linux/stringify.h>
 #include <linux/tcp.h>
 #include <linux/types.h>
-#include <linux/version.h>
 #include <linux/time.h>
 #include <linux/firmware.h>
 #include <linux/acpi.h>
diff --git a/drivers/net/wireless/ipw2200.c b/drivers/net/wireless/ipw2200.c
index 36e8d2f..dcce354 100644
--- a/drivers/net/wireless/ipw2200.c
+++ b/drivers/net/wireless/ipw2200.c
@@ -31,7 +31,6 @@
 ******************************************************************************/
 
 #include "ipw2200.h"
-#include <linux/version.h>
 
 
 #ifndef KBUILD_EXTMOD
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.c b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
index d333696..705c65b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
@@ -27,7 +27,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index b3931f6..3f51f36 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -26,7 +26,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 22bb269..10c9ba3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -26,7 +26,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 9bd6180..c72f725 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -28,7 +28,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/version.h>
 #include <net/mac80211.h>
 
 struct iwl_priv; /* FIXME: remove */
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index bce5383..61f3efd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -63,7 +63,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/init.h>
 
 #include <net/mac80211.h>
diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
index 6512834..2eb03ee 100644
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -28,7 +28,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/version.h>
 #include <net/mac80211.h>
 
 #include "iwl-dev.h" /* FIXME: remove */
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index cb11c4a..4eee1b1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -27,7 +27,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
diff --git a/drivers/net/wireless/iwlwifi/iwl-rfkill.c b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
index e5e5846..5d64229 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rfkill.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
@@ -27,7 +27,6 @@
  *****************************************************************************/
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/init.h>
 
 #include <net/mac80211.h>
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 444847a..10df3d0 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -29,7 +29,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
diff --git a/drivers/rtc/rtc-max6902.c b/drivers/rtc/rtc-max6902.c
index 3364788..2f6507d 100644
--- a/drivers/rtc/rtc-max6902.c
+++ b/drivers/rtc/rtc-max6902.c
@@ -20,8 +20,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/version.h>
-
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
 #include <linux/init.h>
diff --git a/drivers/rtc/rtc-r9701.c b/drivers/rtc/rtc-r9701.c
index 38e5da5..42028f2 100644
--- a/drivers/rtc/rtc-r9701.c
+++ b/drivers/rtc/rtc-r9701.c
@@ -14,7 +14,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
 #include <linux/device.h>
diff --git a/drivers/s390/net/ctcm_mpc.c b/drivers/s390/net/ctcm_mpc.c
index 49ae1cd..2de1e2f 100644
--- a/drivers/s390/net/ctcm_mpc.c
+++ b/drivers/s390/net/ctcm_mpc.c
@@ -19,7 +19,6 @@
 #undef DEBUGDATA
 #undef DEBUGCCW
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
diff --git a/drivers/scsi/dpt/dpti_i2o.h b/drivers/scsi/dpt/dpti_i2o.h
index 19406ce..179ad77 100644
--- a/drivers/scsi/dpt/dpti_i2o.h
+++ b/drivers/scsi/dpt/dpti_i2o.h
@@ -21,7 +21,6 @@
 
 #include <linux/i2o-dev.h>
 
-#include <linux/version.h>
 #include <linux/notifier.h>
 #include <asm/atomic.h>
 
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 7c615c7..bc9e6dd 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -165,7 +165,6 @@
 #include <asm/byteorder.h>
 #include <asm/page.h>
 #include <linux/stddef.h>
-#include <linux/version.h>
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
diff --git a/drivers/scsi/ips.h b/drivers/scsi/ips.h
index e0657b6..4e49fbc 100644
--- a/drivers/scsi/ips.h
+++ b/drivers/scsi/ips.h
@@ -50,7 +50,6 @@
 #ifndef _IPS_H_
    #define _IPS_H_
 
-#include <linux/version.h>
 #include <linux/nmi.h>
    #include <asm/uaccess.h>
    #include <asm/io.h>
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 90272e6..094b47e 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -27,7 +27,6 @@
 #include <linux/pci.h>
 #include <linux/spinlock.h>
 #include <linux/ctype.h>
-#include <linux/version.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index edf9fdb..22052bb 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -23,7 +23,6 @@
  *   1.2: PowerPC (big endian) support.
  */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
diff --git a/drivers/scsi/nsp32.h b/drivers/scsi/nsp32.h
index 6715ecb..9565acf 100644
--- a/drivers/scsi/nsp32.h
+++ b/drivers/scsi/nsp32.h
@@ -16,7 +16,6 @@
 #ifndef _NSP32_H
 #define _NSP32_H
 
-#include <linux/version.h>
 //#define NSP32_DEBUG 9
 
 /*
diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index a221b6e..24e6cb8 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -25,7 +25,6 @@
 
 ***********************************************************************/
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 50baf6a..93560cd 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -6,7 +6,6 @@
  */
 #include "qla_def.h"
 
-#include <linux/version.h>
 #include <linux/moduleparam.h>
 #include <linux/vmalloc.h>
 #include <linux/smp_lock.h>
diff --git a/drivers/usb/atm/ueagle-atm.c b/drivers/usb/atm/ueagle-atm.c
index cb01b51..b6483dd 100644
--- a/drivers/usb/atm/ueagle-atm.c
+++ b/drivers/usb/atm/ueagle-atm.c
@@ -64,7 +64,6 @@
 #include <linux/ctype.h>
 #include <linux/sched.h>
 #include <linux/kthread.h>
-#include <linux/version.h>
 #include <linux/mutex.h>
 #include <linux/freezer.h>
 
diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536udc.c
index 1500e1b..abf8192 100644
--- a/drivers/usb/gadget/amd5536udc.c
+++ b/drivers/usb/gadget/amd5536udc.c
@@ -44,7 +44,6 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/kernel.h>
-#include <linux/version.h>
 #include <linux/delay.h>
 #include <linux/ioport.h>
 #include <linux/sched.h>
diff --git a/drivers/usb/gadget/s3c2410_udc.c b/drivers/usb/gadget/s3c2410_udc.c
index 5388073..29d13eb 100644
--- a/drivers/usb/gadget/s3c2410_udc.c
+++ b/drivers/usb/gadget/s3c2410_udc.c
@@ -35,7 +35,6 @@
 #include <linux/list.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
-#include <linux/version.h>
 #include <linux/clk.h>
 
 #include <linux/debugfs.h>
diff --git a/drivers/usb/misc/iowarrior.c b/drivers/usb/misc/iowarrior.c
index e6ca997..a4ef77e 100644
--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -19,7 +19,6 @@
 #include <linux/slab.h>
 #include <linux/sched.h>
 #include <linux/poll.h>
-#include <linux/version.h>
 #include <linux/usb/iowarrior.h>
 
 /* Version Information */
diff --git a/drivers/usb/serial/garmin_gps.c b/drivers/usb/serial/garmin_gps.c
index 2e663f1..d953820 100644
--- a/drivers/usb/serial/garmin_gps.c
+++ b/drivers/usb/serial/garmin_gps.c
@@ -38,8 +38,6 @@
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 
-#include <linux/version.h>
-
 /* the mode to be set when the port ist opened */
 static int initial_mode = 1;
 
diff --git a/drivers/video/arkfb.c b/drivers/video/arkfb.c
index 4bd569e..314d186 100644
--- a/drivers/video/arkfb.c
+++ b/drivers/video/arkfb.c
@@ -11,7 +11,6 @@
  *  Code is based on s3fb
  */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
diff --git a/drivers/video/s3fb.c b/drivers/video/s3fb.c
index 8361bd0..4dcec48 100644
--- a/drivers/video/s3fb.c
+++ b/drivers/video/s3fb.c
@@ -11,7 +11,6 @@
  * which is based on the code of neofb.
  */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
diff --git a/drivers/video/vermilion/vermilion.h b/drivers/video/vermilion/vermilion.h
index c4aba59..7491abf 100644
--- a/drivers/video/vermilion/vermilion.h
+++ b/drivers/video/vermilion/vermilion.h
@@ -30,7 +30,6 @@
 #define _VERMILION_H_
 
 #include <linux/kernel.h>
-#include <linux/version.h>
 #include <linux/pci.h>
 #include <asm/atomic.h>
 #include <linux/mutex.h>
diff --git a/drivers/video/vt8623fb.c b/drivers/video/vt8623fb.c
index 34aae7a..3df17dc 100644
--- a/drivers/video/vt8623fb.c
+++ b/drivers/video/vt8623fb.c
@@ -12,7 +12,6 @@
  * (http://davesdomain.org.uk/viafb/)
  */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
diff --git a/drivers/video/xilinxfb.c b/drivers/video/xilinxfb.c
index 7b3a842..5da3d24 100644
--- a/drivers/video/xilinxfb.c
+++ b/drivers/video/xilinxfb.c
@@ -24,7 +24,6 @@
 #include <linux/device.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/version.h>
 #include <linux/errno.h>
 #include <linux/string.h>
 #include <linux/mm.h>
diff --git a/fs/jffs2/jffs2_fs_i.h b/fs/jffs2/jffs2_fs_i.h
index 31559f4..4c41db9 100644
--- a/fs/jffs2/jffs2_fs_i.h
+++ b/fs/jffs2/jffs2_fs_i.h
@@ -12,7 +12,6 @@
 #ifndef _JFFS2_FS_I
 #define _JFFS2_FS_I
 
-#include <linux/version.h>
 #include <linux/rbtree.h>
 #include <linux/posix_acl.h>
 #include <linux/mutex.h>
diff --git a/fs/xfs/xfs_dmapi.h b/fs/xfs/xfs_dmapi.h
index cdc2d34..2813cdd 100644
--- a/fs/xfs/xfs_dmapi.h
+++ b/fs/xfs/xfs_dmapi.h
@@ -18,7 +18,6 @@
 #ifndef __XFS_DMAPI_H__
 #define __XFS_DMAPI_H__
 
-#include <linux/version.h>
 /*	Values used to define the on-disk version of dm_attrname_t. All
  *	on-disk attribute names start with the 8-byte string "SGI_DMI_".
  *
diff --git a/include/asm-x86/xen/hypervisor.h b/include/asm-x86/xen/hypervisor.h
index 8e15dd2..04ee061 100644
--- a/include/asm-x86/xen/hypervisor.h
+++ b/include/asm-x86/xen/hypervisor.h
@@ -35,7 +35,6 @@
 
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/version.h>
 
 #include <xen/interface/xen.h>
 #include <xen/interface/version.h>
diff --git a/include/linux/fs_uart_pd.h b/include/linux/fs_uart_pd.h
index 809bb9f..36b61ff 100644
--- a/include/linux/fs_uart_pd.h
+++ b/include/linux/fs_uart_pd.h
@@ -12,7 +12,6 @@
 #ifndef FS_UART_PD_H
 #define FS_UART_PD_H
 
-#include <linux/version.h>
 #include <asm/types.h>
 
 enum fs_uart_id {
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index 21575fc..1d3ef29 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -14,7 +14,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/nsproxy.h>
 #include <linux/init_task.h>
 #include <linux/mnt_namespace.h>
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index a0abf9a..80ccac8 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -14,7 +14,6 @@
 #include <linux/module.h>
 #include <linux/file.h>
 #include <linux/utsname.h>
-#include <linux/version.h>
 #include <linux/delay.h>
 #include <linux/bitops.h>
 #include <linux/genhd.h>
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index a9ab059..532858f 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -6,7 +6,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/nsproxy.h>
 #include <linux/slab.h>
 #include <linux/user_namespace.h>
diff --git a/kernel/utsname.c b/kernel/utsname.c
index 64d398f..815237a 100644
--- a/kernel/utsname.c
+++ b/kernel/utsname.c
@@ -12,7 +12,6 @@
 #include <linux/module.h>
 #include <linux/uts.h>
 #include <linux/utsname.h>
-#include <linux/version.h>
 #include <linux/err.h>
 #include <linux/slab.h>
 
diff --git a/kernel/utsname_sysctl.c b/kernel/utsname_sysctl.c
index fe3a56c..4ab9659 100644
--- a/kernel/utsname_sysctl.c
+++ b/kernel/utsname_sysctl.c
@@ -12,7 +12,6 @@
 #include <linux/module.h>
 #include <linux/uts.h>
 #include <linux/utsname.h>
-#include <linux/version.h>
 #include <linux/sysctl.h>
 
 static void *get_uts(ctl_table *table, int write)
diff --git a/sound/mips/au1x00.c b/sound/mips/au1x00.c
index ee0741f..fbef38a 100644
--- a/sound/mips/au1x00.c
+++ b/sound/mips/au1x00.c
@@ -38,7 +38,6 @@
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <linux/version.h>
 #include <sound/core.h>
 #include <sound/initval.h>
 #include <sound/pcm.h>
diff --git a/sound/soc/at91/eti_b1_wm8731.c b/sound/soc/at91/eti_b1_wm8731.c
index b081e83..b81d6b2 100644
--- a/sound/soc/at91/eti_b1_wm8731.c
+++ b/sound/soc/at91/eti_b1_wm8731.c
@@ -22,7 +22,6 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/clk.h>
 #include <linux/timer.h>
diff --git a/sound/soc/codecs/wm8753.c b/sound/soc/codecs/wm8753.c
index 8604809..dc7b18f 100644
--- a/sound/soc/codecs/wm8753.c
+++ b/sound/soc/codecs/wm8753.c
@@ -34,7 +34,6 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/delay.h>
diff --git a/sound/soc/codecs/wm9712.c b/sound/soc/codecs/wm9712.c
index 1fb7f9a..2f1c91b 100644
--- a/sound/soc/codecs/wm9712.c
+++ b/sound/soc/codecs/wm9712.c
@@ -13,7 +13,6 @@
 
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/device.h>
 #include <sound/core.h>
