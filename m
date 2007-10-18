Return-Path: <linux-kernel-owner+w=401wt.eu-S933673AbXJRTpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933673AbXJRTpk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 15:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758893AbXJRTpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 15:45:33 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:63546 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758879AbXJRTpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 15:45:32 -0400
X-Belgacom-Dynamic: yes
Date: Thu, 18 Oct 2007 21:51:30 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [WATCHDOG] mv watchdog tree under drivers
Message-ID: <20071018195130.GA2680@infomag.infomag.iguana.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will move the watchdog tree from drivers/char/watchdog to drivers/watchdog.

Thanks in advance,
Wim.

---
 drivers/Kconfig                                   |    2 ++
 drivers/Makefile                                  |    2 +-
 drivers/char/Kconfig                              |    2 --
 drivers/{char => }/watchdog/Kconfig               |    0 
 drivers/{char => }/watchdog/Makefile              |    0 
 drivers/{char => }/watchdog/acquirewdt.c          |    0 
 drivers/{char => }/watchdog/advantechwdt.c        |    0 
 drivers/{char => }/watchdog/alim1535_wdt.c        |    0 
 drivers/{char => }/watchdog/alim7101_wdt.c        |    0 
 drivers/{char => }/watchdog/at32ap700x_wdt.c      |    0 
 drivers/{char => }/watchdog/at91rm9200_wdt.c      |    0 
 drivers/{char => }/watchdog/bfin_wdt.c            |    0 
 drivers/{char => }/watchdog/booke_wdt.c           |    0 
 drivers/{char => }/watchdog/cpu5wdt.c             |    0 
 drivers/{char => }/watchdog/davinci_wdt.c         |    0 
 drivers/{char => }/watchdog/ep93xx_wdt.c          |    0 
 drivers/{char => }/watchdog/eurotechwdt.c         |    0 
 drivers/{char => }/watchdog/i6300esb.c            |    0 
 drivers/{char => }/watchdog/iTCO_vendor_support.c |    0 
 drivers/{char => }/watchdog/iTCO_wdt.c            |    0 
 drivers/{char => }/watchdog/ib700wdt.c            |    0 
 drivers/{char => }/watchdog/ibmasr.c              |    0 
 drivers/{char => }/watchdog/indydog.c             |    0 
 drivers/{char => }/watchdog/iop_wdt.c             |    0 
 drivers/{char => }/watchdog/ixp2000_wdt.c         |    0 
 drivers/{char => }/watchdog/ixp4xx_wdt.c          |    0 
 drivers/{char => }/watchdog/ks8695_wdt.c          |    0 
 drivers/{char => }/watchdog/machzwd.c             |    0 
 drivers/{char => }/watchdog/mixcomwd.c            |    0 
 drivers/{char => }/watchdog/mpc5200_wdt.c         |    0 
 drivers/{char => }/watchdog/mpc83xx_wdt.c         |    0 
 drivers/{char => }/watchdog/mpc8xx_wdt.c          |    0 
 drivers/{char => }/watchdog/mpcore_wdt.c          |    0 
 drivers/{char => }/watchdog/mtx-1_wdt.c           |    0 
 drivers/{char => }/watchdog/mv64x60_wdt.c         |    0 
 drivers/{char => }/watchdog/omap_wdt.c            |    0 
 drivers/{char => }/watchdog/omap_wdt.h            |    0 
 drivers/{char => }/watchdog/pc87413_wdt.c         |    0 
 drivers/{char => }/watchdog/pcwd.c                |    0 
 drivers/{char => }/watchdog/pcwd_pci.c            |    0 
 drivers/{char => }/watchdog/pcwd_usb.c            |    0 
 drivers/{char => }/watchdog/pnx4008_wdt.c         |    0 
 drivers/{char => }/watchdog/rm9k_wdt.c            |    0 
 drivers/{char => }/watchdog/s3c2410_wdt.c         |    0 
 drivers/{char => }/watchdog/sa1100_wdt.c          |    0 
 drivers/{char => }/watchdog/sbc60xxwdt.c          |    0 
 drivers/{char => }/watchdog/sbc8360.c             |    0 
 drivers/{char => }/watchdog/sbc_epx_c3.c          |    0 
 drivers/{char => }/watchdog/sc1200wdt.c           |    0 
 drivers/{char => }/watchdog/sc520_wdt.c           |    0 
 drivers/{char => }/watchdog/scx200_wdt.c          |    0 
 drivers/{char => }/watchdog/shwdt.c               |    0 
 drivers/{char => }/watchdog/smsc37b787_wdt.c      |    0 
 drivers/{char => }/watchdog/softdog.c             |    0 
 drivers/{char => }/watchdog/w83627hf_wdt.c        |    0 
 drivers/{char => }/watchdog/w83697hf_wdt.c        |    0 
 drivers/{char => }/watchdog/w83877f_wdt.c         |    0 
 drivers/{char => }/watchdog/w83977f_wdt.c         |    0 
 drivers/{char => }/watchdog/wafer5823wdt.c        |    0 
 drivers/{char => }/watchdog/wd501p.h              |    0 
 drivers/{char => }/watchdog/wdrtas.c              |    0 
 drivers/{char => }/watchdog/wdt.c                 |    0 
 drivers/{char => }/watchdog/wdt285.c              |    0 
 drivers/{char => }/watchdog/wdt977.c              |    0 
 drivers/{char => }/watchdog/wdt_pci.c             |    0 
 65 files changed, 3 insertions(+), 3 deletions(-)
 rename drivers/{char => }/watchdog/Kconfig (100%)
 rename drivers/{char => }/watchdog/Makefile (100%)
 rename drivers/{char => }/watchdog/acquirewdt.c (100%)
 rename drivers/{char => }/watchdog/advantechwdt.c (100%)
 rename drivers/{char => }/watchdog/alim1535_wdt.c (100%)
 rename drivers/{char => }/watchdog/alim7101_wdt.c (100%)
 rename drivers/{char => }/watchdog/at32ap700x_wdt.c (100%)
 rename drivers/{char => }/watchdog/at91rm9200_wdt.c (100%)
 rename drivers/{char => }/watchdog/bfin_wdt.c (100%)
 rename drivers/{char => }/watchdog/booke_wdt.c (100%)
 rename drivers/{char => }/watchdog/cpu5wdt.c (100%)
 rename drivers/{char => }/watchdog/davinci_wdt.c (100%)
 rename drivers/{char => }/watchdog/ep93xx_wdt.c (100%)
 rename drivers/{char => }/watchdog/eurotechwdt.c (100%)
 rename drivers/{char => }/watchdog/i6300esb.c (100%)
 rename drivers/{char => }/watchdog/iTCO_vendor_support.c (100%)
 rename drivers/{char => }/watchdog/iTCO_wdt.c (100%)
 rename drivers/{char => }/watchdog/ib700wdt.c (100%)
 rename drivers/{char => }/watchdog/ibmasr.c (100%)
 rename drivers/{char => }/watchdog/indydog.c (100%)
 rename drivers/{char => }/watchdog/iop_wdt.c (100%)
 rename drivers/{char => }/watchdog/ixp2000_wdt.c (100%)
 rename drivers/{char => }/watchdog/ixp4xx_wdt.c (100%)
 rename drivers/{char => }/watchdog/ks8695_wdt.c (100%)
 rename drivers/{char => }/watchdog/machzwd.c (100%)
 rename drivers/{char => }/watchdog/mixcomwd.c (100%)
 rename drivers/{char => }/watchdog/mpc5200_wdt.c (100%)
 rename drivers/{char => }/watchdog/mpc83xx_wdt.c (100%)
 rename drivers/{char => }/watchdog/mpc8xx_wdt.c (100%)
 rename drivers/{char => }/watchdog/mpcore_wdt.c (100%)
 rename drivers/{char => }/watchdog/mtx-1_wdt.c (100%)
 rename drivers/{char => }/watchdog/mv64x60_wdt.c (100%)
 rename drivers/{char => }/watchdog/omap_wdt.c (100%)
 rename drivers/{char => }/watchdog/omap_wdt.h (100%)
 rename drivers/{char => }/watchdog/pc87413_wdt.c (100%)
 rename drivers/{char => }/watchdog/pcwd.c (100%)
 rename drivers/{char => }/watchdog/pcwd_pci.c (100%)
 rename drivers/{char => }/watchdog/pcwd_usb.c (100%)
 rename drivers/{char => }/watchdog/pnx4008_wdt.c (100%)
 rename drivers/{char => }/watchdog/rm9k_wdt.c (100%)
 rename drivers/{char => }/watchdog/s3c2410_wdt.c (100%)
 rename drivers/{char => }/watchdog/sa1100_wdt.c (100%)
 rename drivers/{char => }/watchdog/sbc60xxwdt.c (100%)
 rename drivers/{char => }/watchdog/sbc8360.c (100%)
 rename drivers/{char => }/watchdog/sbc_epx_c3.c (100%)
 rename drivers/{char => }/watchdog/sc1200wdt.c (100%)
 rename drivers/{char => }/watchdog/sc520_wdt.c (100%)
 rename drivers/{char => }/watchdog/scx200_wdt.c (100%)
 rename drivers/{char => }/watchdog/shwdt.c (100%)
 rename drivers/{char => }/watchdog/smsc37b787_wdt.c (100%)
 rename drivers/{char => }/watchdog/softdog.c (100%)
 rename drivers/{char => }/watchdog/w83627hf_wdt.c (100%)
 rename drivers/{char => }/watchdog/w83697hf_wdt.c (100%)
 rename drivers/{char => }/watchdog/w83877f_wdt.c (100%)
 rename drivers/{char => }/watchdog/w83977f_wdt.c (100%)
 rename drivers/{char => }/watchdog/wafer5823wdt.c (100%)
 rename drivers/{char => }/watchdog/wd501p.h (100%)
 rename drivers/{char => }/watchdog/wdrtas.c (100%)
 rename drivers/{char => }/watchdog/wdt.c (100%)
 rename drivers/{char => }/watchdog/wdt285.c (100%)
 rename drivers/{char => }/watchdog/wdt977.c (100%)
 rename drivers/{char => }/watchdog/wdt_pci.c (100%)

diff --git a/drivers/Kconfig b/drivers/Kconfig
index 3e1c442..6d5e5cf 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -58,6 +58,8 @@ source "drivers/power/Kconfig"
 
 source "drivers/hwmon/Kconfig"
 
+source "drivers/watchdog/Kconfig"
+
 source "drivers/ssb/Kconfig"
 
 source "drivers/mfd/Kconfig"
diff --git a/drivers/Makefile b/drivers/Makefile
index f0878b2..d48f521 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -66,7 +66,7 @@ obj-y				+= i2c/
 obj-$(CONFIG_W1)		+= w1/
 obj-$(CONFIG_POWER_SUPPLY)	+= power/
 obj-$(CONFIG_HWMON)		+= hwmon/
-obj-$(CONFIG_WATCHDOG)		+= char/watchdog/
+obj-$(CONFIG_WATCHDOG)		+= watchdog/
 obj-$(CONFIG_PHONE)		+= telephony/
 obj-$(CONFIG_MD)		+= md/
 obj-$(CONFIG_BT)		+= bluetooth/
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index b391776..a94d28b 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -632,8 +632,6 @@ config HVCS
 
 source "drivers/char/ipmi/Kconfig"
 
-source "drivers/char/watchdog/Kconfig"
-
 config DS1620
 	tristate "NetWinder thermometer support"
 	depends on ARCH_NETWINDER
diff --git a/drivers/char/watchdog/Kconfig b/drivers/watchdog/Kconfig
similarity index 100%
rename from drivers/char/watchdog/Kconfig
rename to drivers/watchdog/Kconfig
diff --git a/drivers/char/watchdog/Makefile b/drivers/watchdog/Makefile
similarity index 100%
rename from drivers/char/watchdog/Makefile
rename to drivers/watchdog/Makefile
diff --git a/drivers/char/watchdog/acquirewdt.c b/drivers/watchdog/acquirewdt.c
similarity index 100%
rename from drivers/char/watchdog/acquirewdt.c
rename to drivers/watchdog/acquirewdt.c
diff --git a/drivers/char/watchdog/advantechwdt.c b/drivers/watchdog/advantechwdt.c
similarity index 100%
rename from drivers/char/watchdog/advantechwdt.c
rename to drivers/watchdog/advantechwdt.c
diff --git a/drivers/char/watchdog/alim1535_wdt.c b/drivers/watchdog/alim1535_wdt.c
similarity index 100%
rename from drivers/char/watchdog/alim1535_wdt.c
rename to drivers/watchdog/alim1535_wdt.c
diff --git a/drivers/char/watchdog/alim7101_wdt.c b/drivers/watchdog/alim7101_wdt.c
similarity index 100%
rename from drivers/char/watchdog/alim7101_wdt.c
rename to drivers/watchdog/alim7101_wdt.c
diff --git a/drivers/char/watchdog/at32ap700x_wdt.c b/drivers/watchdog/at32ap700x_wdt.c
similarity index 100%
rename from drivers/char/watchdog/at32ap700x_wdt.c
rename to drivers/watchdog/at32ap700x_wdt.c
diff --git a/drivers/char/watchdog/at91rm9200_wdt.c b/drivers/watchdog/at91rm9200_wdt.c
similarity index 100%
rename from drivers/char/watchdog/at91rm9200_wdt.c
rename to drivers/watchdog/at91rm9200_wdt.c
diff --git a/drivers/char/watchdog/bfin_wdt.c b/drivers/watchdog/bfin_wdt.c
similarity index 100%
rename from drivers/char/watchdog/bfin_wdt.c
rename to drivers/watchdog/bfin_wdt.c
diff --git a/drivers/char/watchdog/booke_wdt.c b/drivers/watchdog/booke_wdt.c
similarity index 100%
rename from drivers/char/watchdog/booke_wdt.c
rename to drivers/watchdog/booke_wdt.c
diff --git a/drivers/char/watchdog/cpu5wdt.c b/drivers/watchdog/cpu5wdt.c
similarity index 100%
rename from drivers/char/watchdog/cpu5wdt.c
rename to drivers/watchdog/cpu5wdt.c
diff --git a/drivers/char/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
similarity index 100%
rename from drivers/char/watchdog/davinci_wdt.c
rename to drivers/watchdog/davinci_wdt.c
diff --git a/drivers/char/watchdog/ep93xx_wdt.c b/drivers/watchdog/ep93xx_wdt.c
similarity index 100%
rename from drivers/char/watchdog/ep93xx_wdt.c
rename to drivers/watchdog/ep93xx_wdt.c
diff --git a/drivers/char/watchdog/eurotechwdt.c b/drivers/watchdog/eurotechwdt.c
similarity index 100%
rename from drivers/char/watchdog/eurotechwdt.c
rename to drivers/watchdog/eurotechwdt.c
diff --git a/drivers/char/watchdog/i6300esb.c b/drivers/watchdog/i6300esb.c
similarity index 100%
rename from drivers/char/watchdog/i6300esb.c
rename to drivers/watchdog/i6300esb.c
diff --git a/drivers/char/watchdog/iTCO_vendor_support.c b/drivers/watchdog/iTCO_vendor_support.c
similarity index 100%
rename from drivers/char/watchdog/iTCO_vendor_support.c
rename to drivers/watchdog/iTCO_vendor_support.c
diff --git a/drivers/char/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
similarity index 100%
rename from drivers/char/watchdog/iTCO_wdt.c
rename to drivers/watchdog/iTCO_wdt.c
diff --git a/drivers/char/watchdog/ib700wdt.c b/drivers/watchdog/ib700wdt.c
similarity index 100%
rename from drivers/char/watchdog/ib700wdt.c
rename to drivers/watchdog/ib700wdt.c
diff --git a/drivers/char/watchdog/ibmasr.c b/drivers/watchdog/ibmasr.c
similarity index 100%
rename from drivers/char/watchdog/ibmasr.c
rename to drivers/watchdog/ibmasr.c
diff --git a/drivers/char/watchdog/indydog.c b/drivers/watchdog/indydog.c
similarity index 100%
rename from drivers/char/watchdog/indydog.c
rename to drivers/watchdog/indydog.c
diff --git a/drivers/char/watchdog/iop_wdt.c b/drivers/watchdog/iop_wdt.c
similarity index 100%
rename from drivers/char/watchdog/iop_wdt.c
rename to drivers/watchdog/iop_wdt.c
diff --git a/drivers/char/watchdog/ixp2000_wdt.c b/drivers/watchdog/ixp2000_wdt.c
similarity index 100%
rename from drivers/char/watchdog/ixp2000_wdt.c
rename to drivers/watchdog/ixp2000_wdt.c
diff --git a/drivers/char/watchdog/ixp4xx_wdt.c b/drivers/watchdog/ixp4xx_wdt.c
similarity index 100%
rename from drivers/char/watchdog/ixp4xx_wdt.c
rename to drivers/watchdog/ixp4xx_wdt.c
diff --git a/drivers/char/watchdog/ks8695_wdt.c b/drivers/watchdog/ks8695_wdt.c
similarity index 100%
rename from drivers/char/watchdog/ks8695_wdt.c
rename to drivers/watchdog/ks8695_wdt.c
diff --git a/drivers/char/watchdog/machzwd.c b/drivers/watchdog/machzwd.c
similarity index 100%
rename from drivers/char/watchdog/machzwd.c
rename to drivers/watchdog/machzwd.c
diff --git a/drivers/char/watchdog/mixcomwd.c b/drivers/watchdog/mixcomwd.c
similarity index 100%
rename from drivers/char/watchdog/mixcomwd.c
rename to drivers/watchdog/mixcomwd.c
diff --git a/drivers/char/watchdog/mpc5200_wdt.c b/drivers/watchdog/mpc5200_wdt.c
similarity index 100%
rename from drivers/char/watchdog/mpc5200_wdt.c
rename to drivers/watchdog/mpc5200_wdt.c
diff --git a/drivers/char/watchdog/mpc83xx_wdt.c b/drivers/watchdog/mpc83xx_wdt.c
similarity index 100%
rename from drivers/char/watchdog/mpc83xx_wdt.c
rename to drivers/watchdog/mpc83xx_wdt.c
diff --git a/drivers/char/watchdog/mpc8xx_wdt.c b/drivers/watchdog/mpc8xx_wdt.c
similarity index 100%
rename from drivers/char/watchdog/mpc8xx_wdt.c
rename to drivers/watchdog/mpc8xx_wdt.c
diff --git a/drivers/char/watchdog/mpcore_wdt.c b/drivers/watchdog/mpcore_wdt.c
similarity index 100%
rename from drivers/char/watchdog/mpcore_wdt.c
rename to drivers/watchdog/mpcore_wdt.c
diff --git a/drivers/char/watchdog/mtx-1_wdt.c b/drivers/watchdog/mtx-1_wdt.c
similarity index 100%
rename from drivers/char/watchdog/mtx-1_wdt.c
rename to drivers/watchdog/mtx-1_wdt.c
diff --git a/drivers/char/watchdog/mv64x60_wdt.c b/drivers/watchdog/mv64x60_wdt.c
similarity index 100%
rename from drivers/char/watchdog/mv64x60_wdt.c
rename to drivers/watchdog/mv64x60_wdt.c
diff --git a/drivers/char/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
similarity index 100%
rename from drivers/char/watchdog/omap_wdt.c
rename to drivers/watchdog/omap_wdt.c
diff --git a/drivers/char/watchdog/omap_wdt.h b/drivers/watchdog/omap_wdt.h
similarity index 100%
rename from drivers/char/watchdog/omap_wdt.h
rename to drivers/watchdog/omap_wdt.h
diff --git a/drivers/char/watchdog/pc87413_wdt.c b/drivers/watchdog/pc87413_wdt.c
similarity index 100%
rename from drivers/char/watchdog/pc87413_wdt.c
rename to drivers/watchdog/pc87413_wdt.c
diff --git a/drivers/char/watchdog/pcwd.c b/drivers/watchdog/pcwd.c
similarity index 100%
rename from drivers/char/watchdog/pcwd.c
rename to drivers/watchdog/pcwd.c
diff --git a/drivers/char/watchdog/pcwd_pci.c b/drivers/watchdog/pcwd_pci.c
similarity index 100%
rename from drivers/char/watchdog/pcwd_pci.c
rename to drivers/watchdog/pcwd_pci.c
diff --git a/drivers/char/watchdog/pcwd_usb.c b/drivers/watchdog/pcwd_usb.c
similarity index 100%
rename from drivers/char/watchdog/pcwd_usb.c
rename to drivers/watchdog/pcwd_usb.c
diff --git a/drivers/char/watchdog/pnx4008_wdt.c b/drivers/watchdog/pnx4008_wdt.c
similarity index 100%
rename from drivers/char/watchdog/pnx4008_wdt.c
rename to drivers/watchdog/pnx4008_wdt.c
diff --git a/drivers/char/watchdog/rm9k_wdt.c b/drivers/watchdog/rm9k_wdt.c
similarity index 100%
rename from drivers/char/watchdog/rm9k_wdt.c
rename to drivers/watchdog/rm9k_wdt.c
diff --git a/drivers/char/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
similarity index 100%
rename from drivers/char/watchdog/s3c2410_wdt.c
rename to drivers/watchdog/s3c2410_wdt.c
diff --git a/drivers/char/watchdog/sa1100_wdt.c b/drivers/watchdog/sa1100_wdt.c
similarity index 100%
rename from drivers/char/watchdog/sa1100_wdt.c
rename to drivers/watchdog/sa1100_wdt.c
diff --git a/drivers/char/watchdog/sbc60xxwdt.c b/drivers/watchdog/sbc60xxwdt.c
similarity index 100%
rename from drivers/char/watchdog/sbc60xxwdt.c
rename to drivers/watchdog/sbc60xxwdt.c
diff --git a/drivers/char/watchdog/sbc8360.c b/drivers/watchdog/sbc8360.c
similarity index 100%
rename from drivers/char/watchdog/sbc8360.c
rename to drivers/watchdog/sbc8360.c
diff --git a/drivers/char/watchdog/sbc_epx_c3.c b/drivers/watchdog/sbc_epx_c3.c
similarity index 100%
rename from drivers/char/watchdog/sbc_epx_c3.c
rename to drivers/watchdog/sbc_epx_c3.c
diff --git a/drivers/char/watchdog/sc1200wdt.c b/drivers/watchdog/sc1200wdt.c
similarity index 100%
rename from drivers/char/watchdog/sc1200wdt.c
rename to drivers/watchdog/sc1200wdt.c
diff --git a/drivers/char/watchdog/sc520_wdt.c b/drivers/watchdog/sc520_wdt.c
similarity index 100%
rename from drivers/char/watchdog/sc520_wdt.c
rename to drivers/watchdog/sc520_wdt.c
diff --git a/drivers/char/watchdog/scx200_wdt.c b/drivers/watchdog/scx200_wdt.c
similarity index 100%
rename from drivers/char/watchdog/scx200_wdt.c
rename to drivers/watchdog/scx200_wdt.c
diff --git a/drivers/char/watchdog/shwdt.c b/drivers/watchdog/shwdt.c
similarity index 100%
rename from drivers/char/watchdog/shwdt.c
rename to drivers/watchdog/shwdt.c
diff --git a/drivers/char/watchdog/smsc37b787_wdt.c b/drivers/watchdog/smsc37b787_wdt.c
similarity index 100%
rename from drivers/char/watchdog/smsc37b787_wdt.c
rename to drivers/watchdog/smsc37b787_wdt.c
diff --git a/drivers/char/watchdog/softdog.c b/drivers/watchdog/softdog.c
similarity index 100%
rename from drivers/char/watchdog/softdog.c
rename to drivers/watchdog/softdog.c
diff --git a/drivers/char/watchdog/w83627hf_wdt.c b/drivers/watchdog/w83627hf_wdt.c
similarity index 100%
rename from drivers/char/watchdog/w83627hf_wdt.c
rename to drivers/watchdog/w83627hf_wdt.c
diff --git a/drivers/char/watchdog/w83697hf_wdt.c b/drivers/watchdog/w83697hf_wdt.c
similarity index 100%
rename from drivers/char/watchdog/w83697hf_wdt.c
rename to drivers/watchdog/w83697hf_wdt.c
diff --git a/drivers/char/watchdog/w83877f_wdt.c b/drivers/watchdog/w83877f_wdt.c
similarity index 100%
rename from drivers/char/watchdog/w83877f_wdt.c
rename to drivers/watchdog/w83877f_wdt.c
diff --git a/drivers/char/watchdog/w83977f_wdt.c b/drivers/watchdog/w83977f_wdt.c
similarity index 100%
rename from drivers/char/watchdog/w83977f_wdt.c
rename to drivers/watchdog/w83977f_wdt.c
diff --git a/drivers/char/watchdog/wafer5823wdt.c b/drivers/watchdog/wafer5823wdt.c
similarity index 100%
rename from drivers/char/watchdog/wafer5823wdt.c
rename to drivers/watchdog/wafer5823wdt.c
diff --git a/drivers/char/watchdog/wd501p.h b/drivers/watchdog/wd501p.h
similarity index 100%
rename from drivers/char/watchdog/wd501p.h
rename to drivers/watchdog/wd501p.h
diff --git a/drivers/char/watchdog/wdrtas.c b/drivers/watchdog/wdrtas.c
similarity index 100%
rename from drivers/char/watchdog/wdrtas.c
rename to drivers/watchdog/wdrtas.c
diff --git a/drivers/char/watchdog/wdt.c b/drivers/watchdog/wdt.c
similarity index 100%
rename from drivers/char/watchdog/wdt.c
rename to drivers/watchdog/wdt.c
diff --git a/drivers/char/watchdog/wdt285.c b/drivers/watchdog/wdt285.c
similarity index 100%
rename from drivers/char/watchdog/wdt285.c
rename to drivers/watchdog/wdt285.c
diff --git a/drivers/char/watchdog/wdt977.c b/drivers/watchdog/wdt977.c
similarity index 100%
rename from drivers/char/watchdog/wdt977.c
rename to drivers/watchdog/wdt977.c
diff --git a/drivers/char/watchdog/wdt_pci.c b/drivers/watchdog/wdt_pci.c
similarity index 100%
rename from drivers/char/watchdog/wdt_pci.c
rename to drivers/watchdog/wdt_pci.c
-- 
1.5.3.4

