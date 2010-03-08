Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313Ab0CHN4B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 08:56:01 -0500
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:49136 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753822Ab0CHNz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 08:55:57 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAFaPlEtbstZK/2dsb2JhbACbJ3SsN4x6DYJBgioE
Date: Mon, 8 Mar 2010 14:55:50 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Martyn Welch <martyn.welch@ge.com>,
       Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
       Marc Zyngier <maz@misterjones.org>,
       Mika Westerberg <mika.westerberg@iki.fi>
Subject: [WATCHDOG] v2.6.34-rc patches
Message-ID: <20100308135550.GA4017@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 arch/arm/mach-ep93xx/include/mach/ts72xx.h |    2 
 arch/arm/mach-ep93xx/ts72xx.c              |   21 +
 arch/powerpc/platforms/52xx/mpc52xx_gpt.c  |    2 
 drivers/watchdog/Kconfig                   |   20 +
 drivers/watchdog/Makefile                  |    2 
 drivers/watchdog/acquirewdt.c              |    2 
 drivers/watchdog/advantechwdt.c            |    2 
 drivers/watchdog/adx_wdt.c                 |    2 
 drivers/watchdog/alim1535_wdt.c            |    2 
 drivers/watchdog/alim7101_wdt.c            |    2 
 drivers/watchdog/ar7_wdt.c                 |    2 
 drivers/watchdog/at32ap700x_wdt.c          |    2 
 drivers/watchdog/at91rm9200_wdt.c          |    2 
 drivers/watchdog/bcm47xx_wdt.c             |    2 
 drivers/watchdog/bfin_wdt.c                |   56 ---
 drivers/watchdog/booke_wdt.c               |    2 
 drivers/watchdog/coh901327_wdt.c           |    2 
 drivers/watchdog/cpu5wdt.c                 |    2 
 drivers/watchdog/cpwd.c                    |    2 
 drivers/watchdog/davinci_wdt.c             |    2 
 drivers/watchdog/ep93xx_wdt.c              |    2 
 drivers/watchdog/eurotechwdt.c             |    2 
 drivers/watchdog/gef_wdt.c                 |   16 
 drivers/watchdog/geodewdt.c                |    2 
 drivers/watchdog/hpwdt.c                   |    2 
 drivers/watchdog/i6300esb.c                |  101 ++---
 drivers/watchdog/iTCO_wdt.c                |   21 -
 drivers/watchdog/ib700wdt.c                |    2 
 drivers/watchdog/indydog.c                 |    2 
 drivers/watchdog/it8712f_wdt.c             |    2 
 drivers/watchdog/it87_wdt.c                |    2 
 drivers/watchdog/ixp2000_wdt.c             |    2 
 drivers/watchdog/ixp4xx_wdt.c              |    2 
 drivers/watchdog/ks8695_wdt.c              |    2 
 drivers/watchdog/machzwd.c                 |    2 
 drivers/watchdog/max63xx_wdt.c             |  397 ++++++++++++++++++++++
 drivers/watchdog/mixcomwd.c                |    2 
 drivers/watchdog/mpc8xxx_wdt.c             |    2 
 drivers/watchdog/mpcore_wdt.c              |    2 
 drivers/watchdog/mv64x60_wdt.c             |    2 
 drivers/watchdog/pc87413_wdt.c             |    2 
 drivers/watchdog/pcwd.c                    |    2 
 drivers/watchdog/pcwd_pci.c                |    2 
 drivers/watchdog/pcwd_usb.c                |    2 
 drivers/watchdog/pika_wdt.c                |    2 
 drivers/watchdog/pnx833x_wdt.c             |    2 
 drivers/watchdog/rc32434_wdt.c             |    2 
 drivers/watchdog/rdc321x_wdt.c             |    2 
 drivers/watchdog/riowd.c                   |    2 
 drivers/watchdog/sbc_fitpc2_wdt.c          |    2 
 drivers/watchdog/sch311x_wdt.c             |    2 
 drivers/watchdog/stmp3xxx_wdt.c            |    2 
 drivers/watchdog/ts72xx_wdt.c              |  520 +++++++++++++++++++++++++++++
 drivers/watchdog/txx9wdt.c                 |   25 -
 drivers/watchdog/w83627hf_wdt.c            |    2 
 drivers/watchdog/w83977f_wdt.c             |    2 
 drivers/watchdog/wdrtas.c                  |    2 
 drivers/watchdog/wdt.c                     |    2 
 drivers/watchdog/wdt_pci.c                 |    2 
 drivers/watchdog/wm831x_wdt.c              |    2 
 drivers/watchdog/wm8350_wdt.c              |    2 
 61 files changed, 1088 insertions(+), 193 deletions(-)

with these Changes:

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Mon Mar 8 13:48:01 2010 +0000

    [WATCHDOG] i6300esb.c: change platform_driver to pci_driver
    
    Since the intel 6300esb platform uses a dedicated PCI ID for
    it's watchdog timer (00:1d.4), it's better and easier to have
    this as a pci_driver.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Mon Mar 8 11:02:38 2010 +0000

    [WATCHDOG] i6300esb: fix unlock register with
    
    Before you can read or write from the i6300esb memeory mapped registers,
    you need to unlock these. This is done by writing the magic numbers 0x80
    and 0x86 to the reload register. The size of the reload register is 32bit
    though.
    
    Also binary 11 is hex 0x03 and not 0x11.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Andrew Morton <akpm@linux-foundation.org>
Date:   Wed Mar 3 11:57:40 2010 -0800

    [WATCHDOG] drivers/watchdog/wdt.c:wdt_ioctl(): make `ident' non-static
    
    Making this instance static exposes the code to SMP races, etc.
    
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Sat Dec 26 19:13:00 2009 +0000

    [WATCHDOG] change reboot_notifier to platform-shutdown method.
    
    Platform device drivers can use the .shutdown method to handle soft
    shutdown's instead of reboot_notifier's.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Sat Dec 26 18:55:22 2009 +0000

    [WATCHDOG] watchdog_info constify
    
    make the watchdog_info struct const where possible.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Martyn Welch <martyn.welch@ge.com>
Date:   Mon Mar 1 17:06:20 2010 +0000

    [WATCHDOG] gef_wdt: Author corrections following split of GE Fanuc joint venture
    
    This patch corrects author and copyright notices  following the split-up of
    the GE Fanuc joint venture.
    
    Signed-off-by: Martyn Welch <martyn.welch@ge.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Date:   Tue Feb 9 00:42:02 2010 +0100

    [WATCHDOG] iTCO_wdt: clean up probe(), modify err msg
    
    It's possible that the platform is not allowing reboot via TCO timer
    expiration.
    
    Also, differentiate between not finding a chipset that has TCO, and the case
    where TCO is present but the driver fails to initialize for some reason.
    
    Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Wed Feb 10 19:34:05 2010 +0000

    [WATCHDOG] ep93xx: watchdog timer driver for TS-72xx SBCs cleanup
    
    Clean-up driver:
    * make release the reverse of probe so that both are consistent
    * add WDIOC_GETSTATUS & WDIOC_GETBOOTSTATUS ioctls.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Marc Zyngier <maz@misterjones.org>
Date:   Thu Feb 4 20:08:56 2010 +0000

    [WATCHDOG] support for max63xx watchdog timer chips
    
    This driver adds support for the max63{69,70,71,72,73,74} family of
    watchdog timer chips.
    
    It has been tested on an Arcom Zeus (max6369).
    
    Signed-off-by: Marc Zyngier <maz@misterjones.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Mika Westerberg <mika.westerberg@iki.fi>
Date:   Sun Nov 29 17:03:03 2009 +0200

    [WATCHDOG] ep93xx: added platform side support for TS-72xx WDT driver
    
    Signed-off-by: Mika Westerberg <mika.westerberg@iki.fi>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Mika Westerberg <mika.westerberg@iki.fi>
Date:   Sun Nov 29 16:58:38 2009 +0200

    [WATCHDOG] ep93xx: implemented watchdog timer driver for TS-72xx SBCs
    
    Technologic Systems TS-72xx SBCs have external glue logic
    CPLD which includes watchdog timer. This driver implements
    kernel support for that.
    
    Signed-off-by: Mika Westerberg <mika.westerberg@iki.fi>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/arch/arm/mach-ep93xx/include/mach/ts72xx.h b/arch/arm/mach-ep93xx/include/mach/ts72xx.h
index 3bd934e..93107d8 100644
--- a/arch/arm/mach-ep93xx/include/mach/ts72xx.h
+++ b/arch/arm/mach-ep93xx/include/mach/ts72xx.h
@@ -65,6 +65,8 @@
 #define TS72XX_RTC_DATA_PHYS_BASE	0x11700000
 #define TS72XX_RTC_DATA_SIZE		0x00001000
 
+#define TS72XX_WDT_CONTROL_PHYS_BASE	0x23800000
+#define TS72XX_WDT_FEED_PHYS_BASE	0x23c00000
 
 #ifndef __ASSEMBLY__
 
diff --git a/arch/arm/mach-ep93xx/ts72xx.c b/arch/arm/mach-ep93xx/ts72xx.c
index 259f782..fac1ec7 100644
--- a/arch/arm/mach-ep93xx/ts72xx.c
+++ b/arch/arm/mach-ep93xx/ts72xx.c
@@ -166,6 +166,26 @@ static struct platform_device ts72xx_rtc_device = {
 	.num_resources	= 0,
 };
 
+static struct resource ts72xx_wdt_resources[] = {
+	{
+		.start	= TS72XX_WDT_CONTROL_PHYS_BASE,
+		.end	= TS72XX_WDT_CONTROL_PHYS_BASE + SZ_4K - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	{
+		.start	= TS72XX_WDT_FEED_PHYS_BASE,
+		.end	= TS72XX_WDT_FEED_PHYS_BASE + SZ_4K - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+};
+
+static struct platform_device ts72xx_wdt_device = {
+	.name		= "ts72xx-wdt",
+	.id		= -1,
+	.num_resources 	= ARRAY_SIZE(ts72xx_wdt_resources),
+	.resource	= ts72xx_wdt_resources,
+};
+
 static struct ep93xx_eth_data ts72xx_eth_data = {
 	.phy_id		= 1,
 };
@@ -175,6 +195,7 @@ static void __init ts72xx_init_machine(void)
 	ep93xx_init_devices();
 	ts72xx_register_flash();
 	platform_device_register(&ts72xx_rtc_device);
+	platform_device_register(&ts72xx_wdt_device);
 
 	ep93xx_register_eth(&ts72xx_eth_data, 1);
 }
diff --git a/arch/powerpc/platforms/52xx/mpc52xx_gpt.c b/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
index 6f8ebe1..072b948 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
@@ -553,7 +553,7 @@ static ssize_t mpc52xx_wdt_write(struct file *file, const char __user *data,
 	return 0;
 }
 
-static struct watchdog_info mpc5200_wdt_info = {
+static const struct watchdog_info mpc5200_wdt_info = {
 	.options	= WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
 	.identity	= WDT_IDENTITY,
 };
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 3da3f48..bdcdbd5 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -55,6 +55,11 @@ config SOFT_WATCHDOG
 	  To compile this driver as a module, choose M here: the
 	  module will be called softdog.
 
+config MAX63XX_WATCHDOG
+       tristate "Max63xx watchdog"
+       help
+         Support for memory mapped max63{69,70,71,72,73,74} watchdog timer.
+
 config WM831X_WATCHDOG
 	tristate "WM831x watchdog"
 	depends on MFD_WM831X
@@ -289,6 +294,17 @@ config ADX_WATCHDOG
 	  Say Y here if you want support for the watchdog timer on Avionic
 	  Design Xanthos boards.
 
+config TS72XX_WATCHDOG
+	tristate "TS-72XX SBC Watchdog"
+	depends on MACH_TS72XX
+	help
+	  Technologic Systems TS-7200, TS-7250 and TS-7260 boards have
+	  watchdog timer implemented in a external CPLD chip. Say Y here
+	  if you want to support for the watchdog timer on TS-72XX boards.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called ts72xx_wdt.
+
 # AVR32 Architecture
 
 config AT32AP700X_WDT
@@ -845,10 +861,10 @@ config TXX9_WDT
 # POWERPC Architecture
 
 config GEF_WDT
-	tristate "GE Fanuc Watchdog Timer"
+	tristate "GE Watchdog Timer"
 	depends on GEF_SBC610 || GEF_SBC310 || GEF_PPC9A
 	---help---
-	  Watchdog timer found in a number of GE Fanuc single board computers.
+	  Watchdog timer found in a number of GE single board computers.
 
 config MPC5200_WDT
 	bool "MPC52xx Watchdog Timer"
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 475c611..5e3cb95 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -46,6 +46,7 @@ obj-$(CONFIG_COH901327_WATCHDOG) += coh901327_wdt.o
 obj-$(CONFIG_STMP3XXX_WATCHDOG) += stmp3xxx_wdt.o
 obj-$(CONFIG_NUC900_WATCHDOG) += nuc900_wdt.o
 obj-$(CONFIG_ADX_WATCHDOG) += adx_wdt.o
+obj-$(CONFIG_TS72XX_WATCHDOG) += ts72xx_wdt.o
 
 # AVR32 Architecture
 obj-$(CONFIG_AT32AP700X_WDT) += at32ap700x_wdt.o
@@ -142,4 +143,5 @@ obj-$(CONFIG_WATCHDOG_CP1XXX)		+= cpwd.o
 # Architecture Independant
 obj-$(CONFIG_WM831X_WATCHDOG) += wm831x_wdt.o
 obj-$(CONFIG_WM8350_WATCHDOG) += wm8350_wdt.o
+obj-$(CONFIG_MAX63XX_WATCHDOG) += max63xx_wdt.o
 obj-$(CONFIG_SOFT_WATCHDOG) += softdog.o
diff --git a/drivers/watchdog/acquirewdt.c b/drivers/watchdog/acquirewdt.c
index 4d18c87..2ffce4d 100644
--- a/drivers/watchdog/acquirewdt.c
+++ b/drivers/watchdog/acquirewdt.c
@@ -150,7 +150,7 @@ static long acq_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	int options, retval = -EINVAL;
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options = WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
 		.firmware_version = 1,
 		.identity = WATCHDOG_NAME,
diff --git a/drivers/watchdog/advantechwdt.c b/drivers/watchdog/advantechwdt.c
index 824d076..4d40965 100644
--- a/drivers/watchdog/advantechwdt.c
+++ b/drivers/watchdog/advantechwdt.c
@@ -137,7 +137,7 @@ static long advwdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	int new_timeout;
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options = WDIOF_KEEPALIVEPING |
 			   WDIOF_SETTIMEOUT |
 			   WDIOF_MAGICCLOSE,
diff --git a/drivers/watchdog/adx_wdt.c b/drivers/watchdog/adx_wdt.c
index 9d7d155..a5ca7a6 100644
--- a/drivers/watchdog/adx_wdt.c
+++ b/drivers/watchdog/adx_wdt.c
@@ -37,7 +37,7 @@ struct adx_wdt {
 	spinlock_t lock;
 };
 
-static struct watchdog_info adx_wdt_info = {
+static const struct watchdog_info adx_wdt_info = {
 	.identity = "Avionic Design Xanthos Watchdog",
 	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
 };
diff --git a/drivers/watchdog/alim1535_wdt.c b/drivers/watchdog/alim1535_wdt.c
index 937a80f..1e9caea 100644
--- a/drivers/watchdog/alim1535_wdt.c
+++ b/drivers/watchdog/alim1535_wdt.c
@@ -180,7 +180,7 @@ static long ali_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options =		WDIOF_KEEPALIVEPING |
 					WDIOF_SETTIMEOUT |
 					WDIOF_MAGICCLOSE,
diff --git a/drivers/watchdog/alim7101_wdt.c b/drivers/watchdog/alim7101_wdt.c
index f90afdb..d8d4da9 100644
--- a/drivers/watchdog/alim7101_wdt.c
+++ b/drivers/watchdog/alim7101_wdt.c
@@ -238,7 +238,7 @@ static long fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT
 							| WDIOF_MAGICCLOSE,
 		.firmware_version = 1,
diff --git a/drivers/watchdog/ar7_wdt.c b/drivers/watchdog/ar7_wdt.c
index 2bb95cd..c764c52 100644
--- a/drivers/watchdog/ar7_wdt.c
+++ b/drivers/watchdog/ar7_wdt.c
@@ -219,7 +219,7 @@ static ssize_t ar7_wdt_write(struct file *file, const char *data,
 static long ar7_wdt_ioctl(struct file *file,
 					unsigned int cmd, unsigned long arg)
 {
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.identity = LONGNAME,
 		.firmware_version = 1,
 		.options = (WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING |
diff --git a/drivers/watchdog/at32ap700x_wdt.c b/drivers/watchdog/at32ap700x_wdt.c
index 0378479..6873376 100644
--- a/drivers/watchdog/at32ap700x_wdt.c
+++ b/drivers/watchdog/at32ap700x_wdt.c
@@ -202,7 +202,7 @@ static int at32_wdt_get_status(void)
 	return status;
 }
 
-static struct watchdog_info at32_wdt_info = {
+static const struct watchdog_info at32_wdt_info = {
 	.identity	= "at32ap700x watchdog",
 	.options	= WDIOF_SETTIMEOUT |
 			  WDIOF_KEEPALIVEPING |
diff --git a/drivers/watchdog/at91rm9200_wdt.c b/drivers/watchdog/at91rm9200_wdt.c
index b185daf..b3046dc 100644
--- a/drivers/watchdog/at91rm9200_wdt.c
+++ b/drivers/watchdog/at91rm9200_wdt.c
@@ -121,7 +121,7 @@ static int at91_wdt_settimeout(int new_time)
 	return 0;
 }
 
-static struct watchdog_info at91_wdt_info = {
+static const struct watchdog_info at91_wdt_info = {
 	.identity	= "at91 watchdog",
 	.options	= WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
 };
diff --git a/drivers/watchdog/bcm47xx_wdt.c b/drivers/watchdog/bcm47xx_wdt.c
index 751c003..5f24552 100644
--- a/drivers/watchdog/bcm47xx_wdt.c
+++ b/drivers/watchdog/bcm47xx_wdt.c
@@ -149,7 +149,7 @@ static ssize_t bcm47xx_wdt_write(struct file *file, const char __user *data,
 	return len;
 }
 
-static struct watchdog_info bcm47xx_wdt_info = {
+static const struct watchdog_info bcm47xx_wdt_info = {
 	.identity 	= DRV_NAME,
 	.options 	= WDIOF_SETTIMEOUT |
 				WDIOF_KEEPALIVEPING |
diff --git a/drivers/watchdog/bfin_wdt.c b/drivers/watchdog/bfin_wdt.c
index 2159e66..9c7ccd1 100644
--- a/drivers/watchdog/bfin_wdt.c
+++ b/drivers/watchdog/bfin_wdt.c
@@ -19,8 +19,6 @@
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
 #include <linux/fs.h>
-#include <linux/notifier.h>
-#include <linux/reboot.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/uaccess.h>
@@ -74,7 +72,7 @@
 
 static unsigned int timeout = WATCHDOG_TIMEOUT;
 static int nowayout = WATCHDOG_NOWAYOUT;
-static struct watchdog_info bfin_wdt_info;
+static const struct watchdog_info bfin_wdt_info;
 static unsigned long open_check;
 static char expect_close;
 static DEFINE_SPINLOCK(bfin_wdt_spinlock);
@@ -309,26 +307,6 @@ static long bfin_wdt_ioctl(struct file *file,
 	}
 }
 
-/**
- *	bfin_wdt_notify_sys - Notifier Handler
- *	@this: notifier block
- *	@code: notifier event
- *	@unused: unused
- *
- *	Handles specific events, such as turning off the watchdog during a
- *	shutdown event.
- */
-static int bfin_wdt_notify_sys(struct notifier_block *this,
-					unsigned long code, void *unused)
-{
-	stampit();
-
-	if (code == SYS_DOWN || code == SYS_HALT)
-		bfin_wdt_stop();
-
-	return NOTIFY_DONE;
-}
-
 #ifdef CONFIG_PM
 static int state_before_suspend;
 
@@ -388,40 +366,28 @@ static struct miscdevice bfin_wdt_miscdev = {
 	.fops     = &bfin_wdt_fops,
 };
 
-static struct watchdog_info bfin_wdt_info = {
+static const struct watchdog_info bfin_wdt_info = {
 	.identity = "Blackfin Watchdog",
 	.options  = WDIOF_SETTIMEOUT |
 		    WDIOF_KEEPALIVEPING |
 		    WDIOF_MAGICCLOSE,
 };
 
-static struct notifier_block bfin_wdt_notifier = {
-	.notifier_call = bfin_wdt_notify_sys,
-};
-
 /**
  *	bfin_wdt_probe - Initialize module
  *
- *	Registers the misc device and notifier handler.  Actual device
+ *	Registers the misc device.  Actual device
  *	initialization is handled by bfin_wdt_open().
  */
 static int __devinit bfin_wdt_probe(struct platform_device *pdev)
 {
 	int ret;
 
-	ret = register_reboot_notifier(&bfin_wdt_notifier);
-	if (ret) {
-		pr_devinit(KERN_ERR PFX
-			"cannot register reboot notifier (err=%d)\n", ret);
-		return ret;
-	}
-
 	ret = misc_register(&bfin_wdt_miscdev);
 	if (ret) {
 		pr_devinit(KERN_ERR PFX
 			"cannot register miscdev on minor=%d (err=%d)\n",
 				WATCHDOG_MINOR, ret);
-		unregister_reboot_notifier(&bfin_wdt_notifier);
 		return ret;
 	}
 
@@ -434,21 +400,33 @@ static int __devinit bfin_wdt_probe(struct platform_device *pdev)
 /**
  *	bfin_wdt_remove - Initialize module
  *
- *	Unregisters the misc device and notifier handler.  Actual device
+ *	Unregisters the misc device.  Actual device
  *	deinitialization is handled by bfin_wdt_close().
  */
 static int __devexit bfin_wdt_remove(struct platform_device *pdev)
 {
 	misc_deregister(&bfin_wdt_miscdev);
-	unregister_reboot_notifier(&bfin_wdt_notifier);
 	return 0;
 }
 
+/**
+ *	bfin_wdt_shutdown - Soft Shutdown Handler
+ *
+ *	Handles the soft shutdown event.
+ */
+static void bfin_wdt_shutdown(struct platform_device *pdev)
+{
+	stampit();
+
+	bfin_wdt_stop();
+}
+
 static struct platform_device *bfin_wdt_device;
 
 static struct platform_driver bfin_wdt_driver = {
 	.probe     = bfin_wdt_probe,
 	.remove    = __devexit_p(bfin_wdt_remove),
+	.shutdown  = bfin_wdt_shutdown,
 	.suspend   = bfin_wdt_suspend,
 	.resume    = bfin_wdt_resume,
 	.driver    = {
diff --git a/drivers/watchdog/booke_wdt.c b/drivers/watchdog/booke_wdt.c
index e8380ef..8b724aa 100644
--- a/drivers/watchdog/booke_wdt.c
+++ b/drivers/watchdog/booke_wdt.c
@@ -121,7 +121,7 @@ static ssize_t booke_wdt_write(struct file *file, const char __user *buf,
 	return count;
 }
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
 	.identity = "PowerPC Book-E Watchdog",
 };
diff --git a/drivers/watchdog/coh901327_wdt.c b/drivers/watchdog/coh901327_wdt.c
index 923cc68..9291506 100644
--- a/drivers/watchdog/coh901327_wdt.c
+++ b/drivers/watchdog/coh901327_wdt.c
@@ -257,7 +257,7 @@ static long coh901327_ioctl(struct file *file, unsigned int cmd,
 		struct watchdog_info __user *ident;
 		int __user *i;
 	} uarg;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options		= WDIOF_CARDRESET |
 					  WDIOF_SETTIMEOUT |
 					  WDIOF_KEEPALIVEPING,
diff --git a/drivers/watchdog/cpu5wdt.c b/drivers/watchdog/cpu5wdt.c
index 71f6d7e..edd3475 100644
--- a/drivers/watchdog/cpu5wdt.c
+++ b/drivers/watchdog/cpu5wdt.c
@@ -154,7 +154,7 @@ static long cpu5wdt_ioctl(struct file *file, unsigned int cmd,
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 	unsigned int value;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options = WDIOF_CARDRESET,
 		.identity = "CPU5 WDT",
 	};
diff --git a/drivers/watchdog/cpwd.c b/drivers/watchdog/cpwd.c
index 081f295..37ea052 100644
--- a/drivers/watchdog/cpwd.c
+++ b/drivers/watchdog/cpwd.c
@@ -403,7 +403,7 @@ static int cpwd_release(struct inode *inode, struct file *file)
 
 static long cpwd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	static struct watchdog_info info = {
+	static const struct watchdog_info info = {
 		.options		= WDIOF_SETTIMEOUT,
 		.firmware_version	= 1,
 		.identity		= DRIVER_NAME,
diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
index 887136d..56162c8 100644
--- a/drivers/watchdog/davinci_wdt.c
+++ b/drivers/watchdog/davinci_wdt.c
@@ -142,7 +142,7 @@ davinci_wdt_write(struct file *file, const char *data, size_t len,
 	return len;
 }
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options = WDIOF_KEEPALIVEPING,
 	.identity = "DaVinci Watchdog",
 };
diff --git a/drivers/watchdog/ep93xx_wdt.c b/drivers/watchdog/ep93xx_wdt.c
index cdd55e0..88ed54e 100644
--- a/drivers/watchdog/ep93xx_wdt.c
+++ b/drivers/watchdog/ep93xx_wdt.c
@@ -131,7 +131,7 @@ ep93xx_wdt_write(struct file *file, const char __user *data, size_t len,
 	return len;
 }
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options = WDIOF_CARDRESET | WDIOF_MAGICCLOSE,
 	.identity = "EP93xx Watchdog",
 };
diff --git a/drivers/watchdog/eurotechwdt.c b/drivers/watchdog/eurotechwdt.c
index 9add354..d1c4e55 100644
--- a/drivers/watchdog/eurotechwdt.c
+++ b/drivers/watchdog/eurotechwdt.c
@@ -238,7 +238,7 @@ static long eurwdt_ioctl(struct file *file,
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options	  = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT
 							| WDIOF_MAGICCLOSE,
 		.firmware_version = 1,
diff --git a/drivers/watchdog/gef_wdt.c b/drivers/watchdog/gef_wdt.c
index 734d980..abdbad0 100644
--- a/drivers/watchdog/gef_wdt.c
+++ b/drivers/watchdog/gef_wdt.c
@@ -1,9 +1,9 @@
 /*
- * GE Fanuc watchdog userspace interface
+ * GE watchdog userspace interface
  *
- * Author:  Martyn Welch <martyn.welch@gefanuc.com>
+ * Author:  Martyn Welch <martyn.welch@ge.com>
  *
- * Copyright 2008 GE Fanuc Intelligent Platforms Embedded Systems, Inc.
+ * Copyright 2008 GE Intelligent Platforms Embedded Systems, Inc.
  *
  * This program is free software; you can redistribute  it and/or modify it
  * under  the terms of  the GNU General  Public License as published by the
@@ -161,11 +161,11 @@ static long gef_wdt_ioctl(struct file *file, unsigned int cmd,
 	int timeout;
 	int options;
 	void __user *argp = (void __user *)arg;
-	static struct watchdog_info info = {
+	static const struct watchdog_info info = {
 		.options =	WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE |
 				WDIOF_KEEPALIVEPING,
 		.firmware_version = 0,
-		.identity = "GE Fanuc watchdog",
+		.identity = "GE watchdog",
 	};
 
 	switch (cmd) {
@@ -311,7 +311,7 @@ static struct of_platform_driver gef_wdt_driver = {
 
 static int __init gef_wdt_init(void)
 {
-	printk(KERN_INFO "GE Fanuc watchdog driver\n");
+	printk(KERN_INFO "GE watchdog driver\n");
 	return of_register_platform_driver(&gef_wdt_driver);
 }
 
@@ -323,8 +323,8 @@ static void __exit gef_wdt_exit(void)
 module_init(gef_wdt_init);
 module_exit(gef_wdt_exit);
 
-MODULE_AUTHOR("Martyn Welch <martyn.welch@gefanuc.com>");
-MODULE_DESCRIPTION("GE Fanuc watchdog driver");
+MODULE_AUTHOR("Martyn Welch <martyn.welch@ge.com>");
+MODULE_DESCRIPTION("GE watchdog driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 MODULE_ALIAS("platform: gef_wdt");
diff --git a/drivers/watchdog/geodewdt.c b/drivers/watchdog/geodewdt.c
index 38252ff..9b49b12 100644
--- a/drivers/watchdog/geodewdt.c
+++ b/drivers/watchdog/geodewdt.c
@@ -142,7 +142,7 @@ static long geodewdt_ioctl(struct file *file, unsigned int cmd,
 	int __user *p = argp;
 	int interval;
 
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING
 		| WDIOF_MAGICCLOSE,
 		.firmware_version =     1,
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index a6c5674..70c2c24 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -554,7 +554,7 @@ static ssize_t hpwdt_write(struct file *file, const char __user *data,
 	return len;
 }
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options = WDIOF_SETTIMEOUT |
 		   WDIOF_KEEPALIVEPING |
 		   WDIOF_MAGICCLOSE,
diff --git a/drivers/watchdog/i6300esb.c b/drivers/watchdog/i6300esb.c
index 7ba0b11..bb9750a 100644
--- a/drivers/watchdog/i6300esb.c
+++ b/drivers/watchdog/i6300esb.c
@@ -34,7 +34,6 @@
 #include <linux/mm.h>
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
-#include <linux/platform_device.h>
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/ioport.h>
@@ -42,7 +41,7 @@
 #include <linux/io.h>
 
 /* Module and version information */
-#define ESB_VERSION "0.04"
+#define ESB_VERSION "0.05"
 #define ESB_MODULE_NAME "i6300ESB timer"
 #define ESB_DRIVER_NAME ESB_MODULE_NAME ", v" ESB_VERSION
 #define PFX ESB_MODULE_NAME ": "
@@ -65,7 +64,7 @@
 /* Config register bits */
 #define ESB_WDT_REBOOT  (0x01 << 5)   /* Enable reboot on timeout          */
 #define ESB_WDT_FREQ    (0x01 << 2)   /* Decrement frequency               */
-#define ESB_WDT_INTTYPE (0x11 << 0)   /* Interrupt type on timer1 timeout  */
+#define ESB_WDT_INTTYPE (0x03 << 0)   /* Interrupt type on timer1 timeout  */
 
 /* Reload register bits */
 #define ESB_WDT_TIMEOUT (0x01 << 9)    /* Watchdog timed out                */
@@ -82,7 +81,9 @@ static unsigned long timer_alive;
 static struct pci_dev *esb_pci;
 static unsigned short triggered; /* The status of the watchdog upon boot */
 static char esb_expect_close;
-static struct platform_device *esb_platform_device;
+
+/* We can only use 1 card due to the /dev/watchdog restriction */
+static int cards_found;
 
 /* module parameters */
 /* 30 sec default heartbeat (1 < heartbeat < 2*1023) */
@@ -111,8 +112,8 @@ MODULE_PARM_DESC(nowayout,
  */
 static inline void esb_unlock_registers(void)
 {
-	writeb(ESB_UNLOCK1, ESB_RELOAD_REG);
-	writeb(ESB_UNLOCK2, ESB_RELOAD_REG);
+	writew(ESB_UNLOCK1, ESB_RELOAD_REG);
+	writew(ESB_UNLOCK2, ESB_RELOAD_REG);
 }
 
 static int esb_timer_start(void)
@@ -256,7 +257,7 @@ static long esb_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	int new_heartbeat;
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options =		WDIOF_SETTIMEOUT |
 					WDIOF_KEEPALIVEPING |
 					WDIOF_MAGICCLOSE,
@@ -332,11 +333,6 @@ static struct miscdevice esb_miscdev = {
 
 /*
  * Data for PCI driver interface
- *
- * This data only exists for exporting the supported
- * PCI ids via MODULE_DEVICE_TABLE.  We do not actually
- * register a pci_driver, because someone else might one day
- * want to register another driver on the same PCI id.
  */
 static struct pci_device_id esb_pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ESB_9), },
@@ -348,29 +344,19 @@ MODULE_DEVICE_TABLE(pci, esb_pci_tbl);
  *      Init & exit routines
  */
 
-static unsigned char __devinit esb_getdevice(void)
+static unsigned char __devinit esb_getdevice(struct pci_dev *pdev)
 {
-	/*
-	 *      Find the PCI device
-	 */
-
-	esb_pci = pci_get_device(PCI_VENDOR_ID_INTEL,
-					PCI_DEVICE_ID_INTEL_ESB_9, NULL);
-
-	if (!esb_pci)
-		return 0;
-
-	if (pci_enable_device(esb_pci)) {
+	if (pci_enable_device(pdev)) {
 		printk(KERN_ERR PFX "failed to enable device\n");
 		goto err_devput;
 	}
 
-	if (pci_request_region(esb_pci, 0, ESB_MODULE_NAME)) {
+	if (pci_request_region(pdev, 0, ESB_MODULE_NAME)) {
 		printk(KERN_ERR PFX "failed to request region\n");
 		goto err_disable;
 	}
 
-	BASEADDR = pci_ioremap_bar(esb_pci, 0);
+	BASEADDR = pci_ioremap_bar(pdev, 0);
 	if (BASEADDR == NULL) {
 		/* Something's wrong here, BASEADDR has to be set */
 		printk(KERN_ERR PFX "failed to get BASEADDR\n");
@@ -378,14 +364,14 @@ static unsigned char __devinit esb_getdevice(void)
 	}
 
 	/* Done */
+	esb_pci = pdev;
 	return 1;
 
 err_release:
-	pci_release_region(esb_pci, 0);
+	pci_release_region(pdev, 0);
 err_disable:
-	pci_disable_device(esb_pci);
+	pci_disable_device(pdev);
 err_devput:
-	pci_dev_put(esb_pci);
 	return 0;
 }
 
@@ -430,12 +416,23 @@ static void __devinit esb_initdevice(void)
 	esb_timer_set_heartbeat(heartbeat);
 }
 
-static int __devinit esb_probe(struct platform_device *dev)
+static int __devinit esb_probe(struct pci_dev *pdev,
+		const struct pci_device_id *ent)
 {
 	int ret;
 
+	cards_found++;
+	if (cards_found == 1)
+		printk(KERN_INFO PFX "Intel 6300ESB WatchDog Timer Driver v%s\n",
+			ESB_VERSION);
+
+	if (cards_found > 1) {
+		printk(KERN_ERR PFX "This driver only supports 1 device\n");
+		return -ENODEV;
+	}
+
 	/* Check whether or not the hardware watchdog is there */
-	if (!esb_getdevice() || esb_pci == NULL)
+	if (!esb_getdevice(pdev) || esb_pci == NULL)
 		return -ENODEV;
 
 	/* Check that the heartbeat value is within it's range;
@@ -467,11 +464,11 @@ err_unmap:
 	iounmap(BASEADDR);
 	pci_release_region(esb_pci, 0);
 	pci_disable_device(esb_pci);
-	pci_dev_put(esb_pci);
+	esb_pci = NULL;
 	return ret;
 }
 
-static int __devexit esb_remove(struct platform_device *dev)
+static void __devexit esb_remove(struct pci_dev *pdev)
 {
 	/* Stop the timer before we leave */
 	if (!nowayout)
@@ -482,54 +479,30 @@ static int __devexit esb_remove(struct platform_device *dev)
 	iounmap(BASEADDR);
 	pci_release_region(esb_pci, 0);
 	pci_disable_device(esb_pci);
-	pci_dev_put(esb_pci);
-	return 0;
+	esb_pci = NULL;
 }
 
-static void esb_shutdown(struct platform_device *dev)
+static void esb_shutdown(struct pci_dev *pdev)
 {
 	esb_timer_stop();
 }
 
-static struct platform_driver esb_platform_driver = {
+static struct pci_driver esb_driver = {
+	.name		= ESB_MODULE_NAME,
+	.id_table	= esb_pci_tbl,
 	.probe          = esb_probe,
 	.remove         = __devexit_p(esb_remove),
 	.shutdown       = esb_shutdown,
-	.driver         = {
-		.owner  = THIS_MODULE,
-		.name   = ESB_MODULE_NAME,
-	},
 };
 
 static int __init watchdog_init(void)
 {
-	int err;
-
-	printk(KERN_INFO PFX "Intel 6300ESB WatchDog Timer Driver v%s\n",
-		ESB_VERSION);
-
-	err = platform_driver_register(&esb_platform_driver);
-	if (err)
-		return err;
-
-	esb_platform_device = platform_device_register_simple(ESB_MODULE_NAME,
-								-1, NULL, 0);
-	if (IS_ERR(esb_platform_device)) {
-		err = PTR_ERR(esb_platform_device);
-		goto unreg_platform_driver;
-	}
-
-	return 0;
-
-unreg_platform_driver:
-	platform_driver_unregister(&esb_platform_driver);
-	return err;
+	return pci_register_driver(&esb_driver);
 }
 
 static void __exit watchdog_cleanup(void)
 {
-	platform_device_unregister(esb_platform_device);
-	platform_driver_unregister(&esb_platform_driver);
+	pci_unregister_driver(&esb_driver);
 	printk(KERN_INFO PFX "Watchdog Module Unloaded.\n");
 }
 
diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index 4bdb7f1..44bc6aa 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -584,7 +584,7 @@ static long iTCO_wdt_ioctl(struct file *file, unsigned int cmd,
 	int new_heartbeat;
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options =		WDIOF_SETTIMEOUT |
 					WDIOF_KEEPALIVEPING |
 					WDIOF_MAGICCLOSE,
@@ -698,7 +698,7 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 	if (iTCO_wdt_private.iTCO_version == 2) {
 		pci_read_config_dword(pdev, 0xf0, &base_address);
 		if ((base_address & 1) == 0) {
-			printk(KERN_ERR PFX "RCBA is disabled by harddware\n");
+			printk(KERN_ERR PFX "RCBA is disabled by hardware\n");
 			ret = -ENODEV;
 			goto out;
 		}
@@ -708,8 +708,8 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 
 	/* Check chipset's NO_REBOOT bit */
 	if (iTCO_wdt_unset_NO_REBOOT_bit() && iTCO_vendor_check_noreboot_on()) {
-		printk(KERN_ERR PFX "failed to reset NO_REBOOT flag, "
-					"reboot disabled by hardware\n");
+		printk(KERN_INFO PFX "unable to reset NO_REBOOT flag, "
+					"platform may have disabled it\n");
 		ret = -ENODEV;	/* Cannot reset NO_REBOOT bit */
 		goto out_unmap;
 	}
@@ -805,6 +805,7 @@ static void __devexit iTCO_wdt_cleanup(void)
 
 static int __devinit iTCO_wdt_probe(struct platform_device *dev)
 {
+	int ret = -ENODEV;
 	int found = 0;
 	struct pci_dev *pdev = NULL;
 	const struct pci_device_id *ent;
@@ -814,19 +815,17 @@ static int __devinit iTCO_wdt_probe(struct platform_device *dev)
 	for_each_pci_dev(pdev) {
 		ent = pci_match_id(iTCO_wdt_pci_tbl, pdev);
 		if (ent) {
-			if (!(iTCO_wdt_init(pdev, ent, dev))) {
-				found++;
+			found++;
+			ret = iTCO_wdt_init(pdev, ent, dev);
+			if (!ret)
 				break;
-			}
 		}
 	}
 
-	if (!found) {
+	if (!found)
 		printk(KERN_INFO PFX "No card detected\n");
-		return -ENODEV;
-	}
 
-	return 0;
+	return ret;
 }
 
 static int __devexit iTCO_wdt_remove(struct platform_device *dev)
diff --git a/drivers/watchdog/ib700wdt.c b/drivers/watchdog/ib700wdt.c
index 4bef3dd..0149d8d 100644
--- a/drivers/watchdog/ib700wdt.c
+++ b/drivers/watchdog/ib700wdt.c
@@ -174,7 +174,7 @@ static long ibwdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT
 							| WDIOF_MAGICCLOSE,
 		.firmware_version = 1,
diff --git a/drivers/watchdog/indydog.c b/drivers/watchdog/indydog.c
index bea8a12..1cc5609 100644
--- a/drivers/watchdog/indydog.c
+++ b/drivers/watchdog/indydog.c
@@ -111,7 +111,7 @@ static long indydog_ioctl(struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
 	int options, retval = -EINVAL;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options		= WDIOF_KEEPALIVEPING,
 		.firmware_version	= 0,
 		.identity		= "Hardware Watchdog for SGI IP22",
diff --git a/drivers/watchdog/it8712f_wdt.c b/drivers/watchdog/it8712f_wdt.c
index daed48d..f52c162 100644
--- a/drivers/watchdog/it8712f_wdt.c
+++ b/drivers/watchdog/it8712f_wdt.c
@@ -236,7 +236,7 @@ static long it8712f_wdt_ioctl(struct file *file, unsigned int cmd,
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.identity = "IT8712F Watchdog",
 		.firmware_version = 1,
 		.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING |
diff --git a/drivers/watchdog/it87_wdt.c b/drivers/watchdog/it87_wdt.c
index cc133c5..b709b3b 100644
--- a/drivers/watchdog/it87_wdt.c
+++ b/drivers/watchdog/it87_wdt.c
@@ -421,7 +421,7 @@ static ssize_t wdt_write(struct file *file, const char __user *buf,
 	return count;
 }
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options = WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE | WDIOF_KEEPALIVEPING,
 	.firmware_version =	1,
 	.identity = WATCHDOG_NAME,
diff --git a/drivers/watchdog/ixp2000_wdt.c b/drivers/watchdog/ixp2000_wdt.c
index 3c79dc5..e86952a 100644
--- a/drivers/watchdog/ixp2000_wdt.c
+++ b/drivers/watchdog/ixp2000_wdt.c
@@ -100,7 +100,7 @@ static ssize_t ixp2000_wdt_write(struct file *file, const char *data,
 }
 
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options	= WDIOF_MAGICCLOSE | WDIOF_SETTIMEOUT |
 				WDIOF_KEEPALIVEPING,
 	.identity	= "IXP2000 Watchdog",
diff --git a/drivers/watchdog/ixp4xx_wdt.c b/drivers/watchdog/ixp4xx_wdt.c
index 147b4d5..e02c0ec 100644
--- a/drivers/watchdog/ixp4xx_wdt.c
+++ b/drivers/watchdog/ixp4xx_wdt.c
@@ -89,7 +89,7 @@ ixp4xx_wdt_write(struct file *file, const char *data, size_t len, loff_t *ppos)
 	return len;
 }
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options	= WDIOF_CARDRESET | WDIOF_MAGICCLOSE |
 			  WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
 	.identity	= "IXP4xx Watchdog",
diff --git a/drivers/watchdog/ks8695_wdt.c b/drivers/watchdog/ks8695_wdt.c
index e1c8276..2852bb2 100644
--- a/drivers/watchdog/ks8695_wdt.c
+++ b/drivers/watchdog/ks8695_wdt.c
@@ -145,7 +145,7 @@ static int ks8695_wdt_close(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static struct watchdog_info ks8695_wdt_info = {
+static const struct watchdog_info ks8695_wdt_info = {
 	.identity	= "ks8695 watchdog",
 	.options	= WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
 };
diff --git a/drivers/watchdog/machzwd.c b/drivers/watchdog/machzwd.c
index 47d7197..2d118cf 100644
--- a/drivers/watchdog/machzwd.c
+++ b/drivers/watchdog/machzwd.c
@@ -101,7 +101,7 @@ MODULE_PARM_DESC(nowayout,
 
 #define PFX "machzwd"
 
-static struct watchdog_info zf_info = {
+static const struct watchdog_info zf_info = {
 	.options		= WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
 	.firmware_version	= 1,
 	.identity		= "ZF-Logic watchdog",
diff --git a/drivers/watchdog/max63xx_wdt.c b/drivers/watchdog/max63xx_wdt.c
new file mode 100644
index 0000000..6eb91d7
--- /dev/null
+++ b/drivers/watchdog/max63xx_wdt.c
@@ -0,0 +1,397 @@
+/*
+ * drivers/char/watchdog/max63xx_wdt.c
+ *
+ * Driver for max63{69,70,71,72,73,74} watchdog timers
+ *
+ * Copyright (C) 2009 Marc Zyngier <maz@misterjones.org>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ *
+ * This driver assumes the watchdog pins are memory mapped (as it is
+ * the case for the Arcom Zeus). Should it be connected over GPIOs or
+ * another interface, some abstraction will have to be introduced.
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
+#include <linux/watchdog.h>
+#include <linux/init.h>
+#include <linux/bitops.h>
+#include <linux/platform_device.h>
+#include <linux/spinlock.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
+#include <linux/device.h>
+
+#define DEFAULT_HEARTBEAT 60
+#define MAX_HEARTBEAT     60
+
+static int heartbeat = DEFAULT_HEARTBEAT;
+static int nowayout  = WATCHDOG_NOWAYOUT;
+
+/*
+ * Memory mapping: a single byte, 3 first lower bits to select bit 3
+ * to ping the watchdog.
+ */
+#define MAX6369_WDSET	(7 << 0)
+#define MAX6369_WDI   	(1 << 3)
+
+static DEFINE_SPINLOCK(io_lock);
+
+static unsigned long wdt_status;
+#define WDT_IN_USE	0
+#define WDT_RUNNING	1
+#define WDT_OK_TO_CLOSE 2
+
+static int nodelay;
+static struct resource	*wdt_mem;
+static void __iomem	*wdt_base;
+static struct platform_device *max63xx_pdev;
+
+/*
+ * The timeout values used are actually the absolute minimum the chip
+ * offers. Typical values on my board are slightly over twice as long
+ * (10s setting ends up with a 25s timeout), and can be up to 3 times
+ * the nominal setting (according to the datasheet). So please take
+ * these values with a grain of salt. Same goes for the initial delay
+ * "feature". Only max6373/74 have a few settings without this initial
+ * delay (selected with the "nodelay" parameter).
+ *
+ * I also decided to remove from the tables any timeout smaller than a
+ * second, as it looked completly overkill...
+ */
+
+/* Timeouts in second */
+struct max63xx_timeout {
+	u8 wdset;
+	u8 tdelay;
+	u8 twd;
+};
+
+static struct max63xx_timeout max6369_table[] = {
+	{ 5,  1,  1 },
+	{ 6, 10, 10 },
+	{ 7, 60, 60 },
+	{ },
+};
+
+static struct max63xx_timeout max6371_table[] = {
+	{ 6, 60,  3 },
+	{ 7, 60, 60 },
+	{ },
+};
+
+static struct max63xx_timeout max6373_table[] = {
+	{ 2, 60,  1 },
+	{ 5,  0,  1 },
+	{ 1,  3,  3 },
+	{ 7, 60, 10 },
+	{ 6,  0, 10 },
+	{ },
+};
+
+static struct max63xx_timeout *current_timeout;
+
+static struct max63xx_timeout *
+max63xx_select_timeout(struct max63xx_timeout *table, int value)
+{
+	while (table->twd) {
+		if (value <= table->twd) {
+			if (nodelay && table->tdelay == 0)
+				return table;
+
+			if (!nodelay)
+				return table;
+		}
+
+		table++;
+	}
+
+	return NULL;
+}
+
+static void max63xx_wdt_ping(void)
+{
+	u8 val;
+
+	spin_lock(&io_lock);
+
+	val = __raw_readb(wdt_base);
+
+	__raw_writeb(val | MAX6369_WDI, wdt_base);
+	__raw_writeb(val & ~MAX6369_WDI, wdt_base);
+
+	spin_unlock(&io_lock);
+}
+
+static void max63xx_wdt_enable(struct max63xx_timeout *entry)
+{
+	u8 val;
+
+	if (test_and_set_bit(WDT_RUNNING, &wdt_status))
+		return;
+
+	spin_lock(&io_lock);
+
+	val = __raw_readb(wdt_base);
+	val &= ~MAX6369_WDSET;
+	val |= entry->wdset;
+	__raw_writeb(val, wdt_base);
+
+	spin_unlock(&io_lock);
+
+	/* check for a edge triggered startup */
+	if (entry->tdelay == 0)
+		max63xx_wdt_ping();
+}
+
+static void max63xx_wdt_disable(void)
+{
+	spin_lock(&io_lock);
+
+	__raw_writeb(3, wdt_base);
+
+	spin_unlock(&io_lock);
+
+	clear_bit(WDT_RUNNING, &wdt_status);
+}
+
+static int max63xx_wdt_open(struct inode *inode, struct file *file)
+{
+	if (test_and_set_bit(WDT_IN_USE, &wdt_status))
+		return -EBUSY;
+
+	max63xx_wdt_enable(current_timeout);
+	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
+
+	return nonseekable_open(inode, file);
+}
+
+static ssize_t max63xx_wdt_write(struct file *file, const char *data,
+				 size_t len, loff_t *ppos)
+{
+	if (len) {
+		if (!nowayout) {
+			size_t i;
+
+			clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
+			for (i = 0; i != len; i++) {
+				char c;
+
+				if (get_user(c, data + i))
+					return -EFAULT;
+
+				if (c == 'V')
+					set_bit(WDT_OK_TO_CLOSE, &wdt_status);
+			}
+		}
+
+		max63xx_wdt_ping();
+	}
+
+	return len;
+}
+
+static const struct watchdog_info ident = {
+	.options = WDIOF_MAGICCLOSE | WDIOF_KEEPALIVEPING,
+	.identity = "max63xx Watchdog",
+};
+
+static long max63xx_wdt_ioctl(struct file *file, unsigned int cmd,
+			      unsigned long arg)
+{
+	int ret = -ENOTTY;
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		ret = copy_to_user((struct watchdog_info *)arg, &ident,
+				   sizeof(ident)) ? -EFAULT : 0;
+		break;
+
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		ret = put_user(0, (int *)arg);
+		break;
+
+	case WDIOC_KEEPALIVE:
+		max63xx_wdt_ping();
+		ret = 0;
+		break;
+
+	case WDIOC_GETTIMEOUT:
+		ret = put_user(heartbeat, (int *)arg);
+		break;
+	}
+	return ret;
+}
+
+static int max63xx_wdt_release(struct inode *inode, struct file *file)
+{
+	if (test_bit(WDT_OK_TO_CLOSE, &wdt_status))
+		max63xx_wdt_disable();
+	else
+		dev_crit(&max63xx_pdev->dev,
+			 "device closed unexpectedly - timer will not stop\n");
+
+	clear_bit(WDT_IN_USE, &wdt_status);
+	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
+
+	return 0;
+}
+
+static const struct file_operations max63xx_wdt_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.write		= max63xx_wdt_write,
+	.unlocked_ioctl	= max63xx_wdt_ioctl,
+	.open		= max63xx_wdt_open,
+	.release	= max63xx_wdt_release,
+};
+
+static struct miscdevice max63xx_wdt_miscdev = {
+	.minor	= WATCHDOG_MINOR,
+	.name	= "watchdog",
+	.fops	= &max63xx_wdt_fops,
+};
+
+static int __devinit max63xx_wdt_probe(struct platform_device *pdev)
+{
+	int ret = 0;
+	int size;
+	struct resource *res;
+	struct device *dev = &pdev->dev;
+	struct max63xx_timeout *table;
+
+	table = (struct max63xx_timeout *)pdev->id_entry->driver_data;
+
+	if (heartbeat < 1 || heartbeat > MAX_HEARTBEAT)
+		heartbeat = DEFAULT_HEARTBEAT;
+
+	dev_info(dev, "requesting %ds heartbeat\n", heartbeat);
+	current_timeout = max63xx_select_timeout(table, heartbeat);
+
+	if (!current_timeout) {
+		dev_err(dev, "unable to satisfy heartbeat request\n");
+		return -EINVAL;
+	}
+
+	dev_info(dev, "using %ds heartbeat with %ds initial delay\n",
+		 current_timeout->twd, current_timeout->tdelay);
+
+	heartbeat = current_timeout->twd;
+
+	max63xx_pdev = pdev;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res == NULL) {
+		dev_err(dev, "failed to get memory region resource\n");
+		return -ENOENT;
+	}
+
+	size = resource_size(res);
+	wdt_mem = request_mem_region(res->start, size, pdev->name);
+
+	if (wdt_mem == NULL) {
+		dev_err(dev, "failed to get memory region\n");
+		return -ENOENT;
+	}
+
+	wdt_base = ioremap(res->start, size);
+	if (!wdt_base) {
+		dev_err(dev, "failed to map memory region\n");
+		ret = -ENOMEM;
+		goto out_request;
+	}
+
+	ret = misc_register(&max63xx_wdt_miscdev);
+	if (ret < 0) {
+		dev_err(dev, "cannot register misc device\n");
+		goto out_unmap;
+	}
+
+	return 0;
+
+out_unmap:
+	iounmap(wdt_base);
+out_request:
+	release_resource(wdt_mem);
+	kfree(wdt_mem);
+
+	return ret;
+}
+
+static int __devexit max63xx_wdt_remove(struct platform_device *pdev)
+{
+	misc_deregister(&max63xx_wdt_miscdev);
+	if (wdt_mem) {
+		release_resource(wdt_mem);
+		kfree(wdt_mem);
+		wdt_mem = NULL;
+	}
+
+	if (wdt_base)
+		iounmap(wdt_base);
+
+	return 0;
+}
+
+static struct platform_device_id max63xx_id_table[] = {
+	{ "max6369_wdt", (kernel_ulong_t)max6369_table, },
+	{ "max6370_wdt", (kernel_ulong_t)max6369_table, },
+	{ "max6371_wdt", (kernel_ulong_t)max6371_table, },
+	{ "max6372_wdt", (kernel_ulong_t)max6371_table, },
+	{ "max6373_wdt", (kernel_ulong_t)max6373_table, },
+	{ "max6374_wdt", (kernel_ulong_t)max6373_table, },
+	{ },
+};
+MODULE_DEVICE_TABLE(platform, max63xx_id_table);
+
+static struct platform_driver max63xx_wdt_driver = {
+	.probe		= max63xx_wdt_probe,
+	.remove		= __devexit_p(max63xx_wdt_remove),
+	.id_table	= max63xx_id_table,
+	.driver		= {
+		.name	= "max63xx_wdt",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init max63xx_wdt_init(void)
+{
+	return platform_driver_register(&max63xx_wdt_driver);
+}
+
+static void __exit max63xx_wdt_exit(void)
+{
+	platform_driver_unregister(&max63xx_wdt_driver);
+}
+
+module_init(max63xx_wdt_init);
+module_exit(max63xx_wdt_exit);
+
+MODULE_AUTHOR("Marc Zyngier <maz@misterjones.org>");
+MODULE_DESCRIPTION("max63xx Watchdog Driver");
+
+module_param(heartbeat, int, 0);
+MODULE_PARM_DESC(heartbeat,
+		 "Watchdog heartbeat period in seconds from 1 to "
+		 __MODULE_STRING(MAX_HEARTBEAT) ", default "
+		 __MODULE_STRING(DEFAULT_HEARTBEAT));
+
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
+		 __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+module_param(nodelay, int, 0);
+MODULE_PARM_DESC(nodelay,
+		 "Force selection of a timeout setting without initial delay "
+		 "(max6373/74 only, default=0)");
+
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/drivers/watchdog/mixcomwd.c b/drivers/watchdog/mixcomwd.c
index 407b025..bc820d1 100644
--- a/drivers/watchdog/mixcomwd.c
+++ b/drivers/watchdog/mixcomwd.c
@@ -201,7 +201,7 @@ static long mixcomwd_ioctl(struct file *file,
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 	int status;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options = WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
 		.firmware_version = 1,
 		.identity = "MixCOM watchdog",
diff --git a/drivers/watchdog/mpc8xxx_wdt.c b/drivers/watchdog/mpc8xxx_wdt.c
index 38c588e..4e3941c 100644
--- a/drivers/watchdog/mpc8xxx_wdt.c
+++ b/drivers/watchdog/mpc8xxx_wdt.c
@@ -148,7 +148,7 @@ static long mpc8xxx_wdt_ioctl(struct file *file, unsigned int cmd,
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options = WDIOF_KEEPALIVEPING,
 		.firmware_version = 1,
 		.identity = "MPC8xxx",
diff --git a/drivers/watchdog/mpcore_wdt.c b/drivers/watchdog/mpcore_wdt.c
index a2dc07c..b0646da 100644
--- a/drivers/watchdog/mpcore_wdt.c
+++ b/drivers/watchdog/mpcore_wdt.c
@@ -213,7 +213,7 @@ static ssize_t mpcore_wdt_write(struct file *file, const char *data,
 	return len;
 }
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options		= WDIOF_SETTIMEOUT |
 				  WDIOF_KEEPALIVEPING |
 				  WDIOF_MAGICCLOSE,
diff --git a/drivers/watchdog/mv64x60_wdt.c b/drivers/watchdog/mv64x60_wdt.c
index a51dbe4..97f8a48 100644
--- a/drivers/watchdog/mv64x60_wdt.c
+++ b/drivers/watchdog/mv64x60_wdt.c
@@ -179,7 +179,7 @@ static long mv64x60_wdt_ioctl(struct file *file,
 	int timeout;
 	int options;
 	void __user *argp = (void __user *)arg;
-	static struct watchdog_info info = {
+	static const struct watchdog_info info = {
 		.options =	WDIOF_SETTIMEOUT	|
 				WDIOF_MAGICCLOSE	|
 				WDIOF_KEEPALIVEPING,
diff --git a/drivers/watchdog/pc87413_wdt.c b/drivers/watchdog/pc87413_wdt.c
index 1a2b916..d3aa2f1 100644
--- a/drivers/watchdog/pc87413_wdt.c
+++ b/drivers/watchdog/pc87413_wdt.c
@@ -407,7 +407,7 @@ static long pc87413_ioctl(struct file *file, unsigned int cmd,
 		int __user *i;
 	} uarg;
 
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options          = WDIOF_KEEPALIVEPING |
 				    WDIOF_SETTIMEOUT |
 				    WDIOF_MAGICCLOSE,
diff --git a/drivers/watchdog/pcwd.c b/drivers/watchdog/pcwd.c
index aa95123..06f7922 100644
--- a/drivers/watchdog/pcwd.c
+++ b/drivers/watchdog/pcwd.c
@@ -606,7 +606,7 @@ static long pcwd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	int temperature;
 	int new_heartbeat;
 	int __user *argp = (int __user *)arg;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options =		WDIOF_OVERHEAT |
 					WDIOF_CARDRESET |
 					WDIOF_KEEPALIVEPING |
diff --git a/drivers/watchdog/pcwd_pci.c b/drivers/watchdog/pcwd_pci.c
index 698f51b..64374d6 100644
--- a/drivers/watchdog/pcwd_pci.c
+++ b/drivers/watchdog/pcwd_pci.c
@@ -481,7 +481,7 @@ static long pcipcwd_ioctl(struct file *file, unsigned int cmd,
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options =		WDIOF_OVERHEAT |
 					WDIOF_CARDRESET |
 					WDIOF_KEEPALIVEPING |
diff --git a/drivers/watchdog/pcwd_usb.c b/drivers/watchdog/pcwd_usb.c
index 052fe45..8e4eacc 100644
--- a/drivers/watchdog/pcwd_usb.c
+++ b/drivers/watchdog/pcwd_usb.c
@@ -404,7 +404,7 @@ static long usb_pcwd_ioctl(struct file *file, unsigned int cmd,
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options =		WDIOF_KEEPALIVEPING |
 					WDIOF_SETTIMEOUT |
 					WDIOF_MAGICCLOSE,
diff --git a/drivers/watchdog/pika_wdt.c b/drivers/watchdog/pika_wdt.c
index 2d22e99..435ec2a 100644
--- a/drivers/watchdog/pika_wdt.c
+++ b/drivers/watchdog/pika_wdt.c
@@ -52,7 +52,7 @@ static struct {
 	struct timer_list timer;	/* The timer that pings the watchdog */
 } pikawdt_private;
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.identity	= DRV_NAME,
 	.options	= WDIOF_CARDRESET |
 			  WDIOF_SETTIMEOUT |
diff --git a/drivers/watchdog/pnx833x_wdt.c b/drivers/watchdog/pnx833x_wdt.c
index 538ec2c..09102f0 100644
--- a/drivers/watchdog/pnx833x_wdt.c
+++ b/drivers/watchdog/pnx833x_wdt.c
@@ -141,7 +141,7 @@ static long pnx833x_wdt_ioctl(struct file *file, unsigned int cmd,
 	int options, new_timeout = 0;
 	uint32_t timeout, timeout_left = 0;
 
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT,
 		.firmware_version = 0,
 		.identity = "Hardware Watchdog for PNX833x",
diff --git a/drivers/watchdog/rc32434_wdt.c b/drivers/watchdog/rc32434_wdt.c
index bf12d06..d4c29b5 100644
--- a/drivers/watchdog/rc32434_wdt.c
+++ b/drivers/watchdog/rc32434_wdt.c
@@ -198,7 +198,7 @@ static long rc32434_wdt_ioctl(struct file *file, unsigned int cmd,
 	void __user *argp = (void __user *)arg;
 	int new_timeout;
 	unsigned int value;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options =		WDIOF_SETTIMEOUT |
 					WDIOF_KEEPALIVEPING |
 					WDIOF_MAGICCLOSE,
diff --git a/drivers/watchdog/rdc321x_wdt.c b/drivers/watchdog/rdc321x_wdt.c
index 4976bfd..69c6adb 100644
--- a/drivers/watchdog/rdc321x_wdt.c
+++ b/drivers/watchdog/rdc321x_wdt.c
@@ -149,7 +149,7 @@ static long rdc321x_wdt_ioctl(struct file *file, unsigned int cmd,
 {
 	void __user *argp = (void __user *)arg;
 	unsigned int value;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options = WDIOF_CARDRESET,
 		.identity = "RDC321x WDT",
 	};
diff --git a/drivers/watchdog/riowd.c b/drivers/watchdog/riowd.c
index c14ae86..ae57bf9 100644
--- a/drivers/watchdog/riowd.c
+++ b/drivers/watchdog/riowd.c
@@ -85,7 +85,7 @@ static int riowd_release(struct inode *inode, struct file *filp)
 
 static long riowd_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
-	static struct watchdog_info info = {
+	static const struct watchdog_info info = {
 		.options		= WDIOF_SETTIMEOUT,
 		.firmware_version	= 1,
 		.identity		= DRIVER_NAME,
diff --git a/drivers/watchdog/sbc_fitpc2_wdt.c b/drivers/watchdog/sbc_fitpc2_wdt.c
index e6763d2..8d44c9b 100644
--- a/drivers/watchdog/sbc_fitpc2_wdt.c
+++ b/drivers/watchdog/sbc_fitpc2_wdt.c
@@ -111,7 +111,7 @@ out:
 }
 
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options	= WDIOF_MAGICCLOSE | WDIOF_SETTIMEOUT |
 				WDIOF_KEEPALIVEPING,
 	.identity	= WATCHDOG_NAME,
diff --git a/drivers/watchdog/sch311x_wdt.c b/drivers/watchdog/sch311x_wdt.c
index 569eb29..9c40f48 100644
--- a/drivers/watchdog/sch311x_wdt.c
+++ b/drivers/watchdog/sch311x_wdt.c
@@ -250,7 +250,7 @@ static long sch311x_wdt_ioctl(struct file *file, unsigned int cmd,
 	int new_timeout;
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options		= WDIOF_KEEPALIVEPING |
 					  WDIOF_SETTIMEOUT |
 					  WDIOF_MAGICCLOSE,
diff --git a/drivers/watchdog/stmp3xxx_wdt.c b/drivers/watchdog/stmp3xxx_wdt.c
index 5dd9526..b3421fd 100644
--- a/drivers/watchdog/stmp3xxx_wdt.c
+++ b/drivers/watchdog/stmp3xxx_wdt.c
@@ -94,7 +94,7 @@ static ssize_t stmp3xxx_wdt_write(struct file *file, const char __user *data,
 	return len;
 }
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options	= WDIOF_CARDRESET |
 			  WDIOF_MAGICCLOSE |
 			  WDIOF_SETTIMEOUT |
diff --git a/drivers/watchdog/ts72xx_wdt.c b/drivers/watchdog/ts72xx_wdt.c
new file mode 100644
index 0000000..565a2c3
--- /dev/null
+++ b/drivers/watchdog/ts72xx_wdt.c
@@ -0,0 +1,520 @@
+/*
+ * Watchdog driver for Technologic Systems TS-72xx based SBCs
+ * (TS-7200, TS-7250 and TS-7260). These boards have external
+ * glue logic CPLD chip, which includes programmable watchdog
+ * timer.
+ *
+ * Copyright (c) 2009 Mika Westerberg <mika.westerberg@iki.fi>
+ *
+ * This driver is based on ep93xx_wdt and wm831x_wdt drivers.
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/fs.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/miscdevice.h>
+#include <linux/mutex.h>
+#include <linux/platform_device.h>
+#include <linux/watchdog.h>
+#include <linux/uaccess.h>
+
+#define TS72XX_WDT_FEED_VAL		0x05
+#define TS72XX_WDT_DEFAULT_TIMEOUT	8
+
+static int timeout = TS72XX_WDT_DEFAULT_TIMEOUT;
+module_param(timeout, int, 0);
+MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. "
+			  "(1 <= timeout <= 8, default="
+			  __MODULE_STRING(TS72XX_WDT_DEFAULT_TIMEOUT)
+			  ")");
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Disable watchdog shutdown on close");
+
+/**
+ * struct ts72xx_wdt - watchdog control structure
+ * @lock: lock that protects this structure
+ * @regval: watchdog timeout value suitable for control register
+ * @flags: flags controlling watchdog device state
+ * @control_reg: watchdog control register
+ * @feed_reg: watchdog feed register
+ * @pdev: back pointer to platform dev
+ */
+struct ts72xx_wdt {
+	struct mutex	lock;
+	int		regval;
+
+#define TS72XX_WDT_BUSY_FLAG		1
+#define TS72XX_WDT_EXPECT_CLOSE_FLAG	2
+	int		flags;
+
+	void __iomem	*control_reg;
+	void __iomem	*feed_reg;
+
+	struct platform_device *pdev;
+};
+
+struct platform_device *ts72xx_wdt_pdev;
+
+/*
+ * TS-72xx Watchdog supports following timeouts (value written
+ * to control register):
+ *	value	description
+ *	-------------------------
+ * 	0x00	watchdog disabled
+ *	0x01	250ms
+ *	0x02	500ms
+ *	0x03	1s
+ *	0x04	reserved
+ *	0x05	2s
+ *	0x06	4s
+ *	0x07	8s
+ *
+ * Timeouts below 1s are not very usable so we don't
+ * allow them at all.
+ *
+ * We provide two functions that convert between these:
+ * timeout_to_regval() and regval_to_timeout().
+ */
+static const struct {
+	int	timeout;
+	int	regval;
+} ts72xx_wdt_map[] = {
+	{ 1, 3 },
+	{ 2, 5 },
+	{ 4, 6 },
+	{ 8, 7 },
+};
+
+/**
+ * timeout_to_regval() - converts given timeout to control register value
+ * @new_timeout: timeout in seconds to be converted
+ *
+ * Function converts given @new_timeout into valid value that can
+ * be programmed into watchdog control register. When conversion is
+ * not possible, function returns %-EINVAL.
+ */
+static int timeout_to_regval(int new_timeout)
+{
+	int i;
+
+	/* first limit it to 1 - 8 seconds */
+	new_timeout = clamp_val(new_timeout, 1, 8);
+
+	for (i = 0; i < ARRAY_SIZE(ts72xx_wdt_map); i++) {
+		if (ts72xx_wdt_map[i].timeout >= new_timeout)
+			return ts72xx_wdt_map[i].regval;
+	}
+
+	return -EINVAL;
+}
+
+/**
+ * regval_to_timeout() - converts control register value to timeout
+ * @regval: control register value to be converted
+ *
+ * Function converts given @regval to timeout in seconds (1, 2, 4 or 8).
+ * If @regval cannot be converted, function returns %-EINVAL.
+ */
+static int regval_to_timeout(int regval)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(ts72xx_wdt_map); i++) {
+		if (ts72xx_wdt_map[i].regval == regval)
+			return ts72xx_wdt_map[i].timeout;
+	}
+
+	return -EINVAL;
+}
+
+/**
+ * ts72xx_wdt_kick() - kick the watchdog
+ * @wdt: watchdog to be kicked
+ *
+ * Called with @wdt->lock held.
+ */
+static inline void ts72xx_wdt_kick(struct ts72xx_wdt *wdt)
+{
+	__raw_writeb(TS72XX_WDT_FEED_VAL, wdt->feed_reg);
+}
+
+/**
+ * ts72xx_wdt_start() - starts the watchdog timer
+ * @wdt: watchdog to be started
+ *
+ * This function programs timeout to watchdog timer
+ * and starts it.
+ *
+ * Called with @wdt->lock held.
+ */
+static void ts72xx_wdt_start(struct ts72xx_wdt *wdt)
+{
+	/*
+	 * To program the wdt, it first must be "fed" and
+	 * only after that (within 30 usecs) the configuration
+	 * can be changed.
+	 */
+	ts72xx_wdt_kick(wdt);
+	__raw_writeb((u8)wdt->regval, wdt->control_reg);
+}
+
+/**
+ * ts72xx_wdt_stop() - stops the watchdog timer
+ * @wdt: watchdog to be stopped
+ *
+ * Called with @wdt->lock held.
+ */
+static void ts72xx_wdt_stop(struct ts72xx_wdt *wdt)
+{
+	ts72xx_wdt_kick(wdt);
+	__raw_writeb(0, wdt->control_reg);
+}
+
+static int ts72xx_wdt_open(struct inode *inode, struct file *file)
+{
+	struct ts72xx_wdt *wdt = platform_get_drvdata(ts72xx_wdt_pdev);
+	int regval;
+
+	/*
+	 * Try to convert default timeout to valid register
+	 * value first.
+	 */
+	regval = timeout_to_regval(timeout);
+	if (regval < 0) {
+		dev_err(&wdt->pdev->dev,
+			"failed to convert timeout (%d) to register value\n",
+			timeout);
+		return -EINVAL;
+	}
+
+	if (mutex_lock_interruptible(&wdt->lock))
+		return -ERESTARTSYS;
+
+	if ((wdt->flags & TS72XX_WDT_BUSY_FLAG) != 0) {
+		mutex_unlock(&wdt->lock);
+		return -EBUSY;
+	}
+
+	wdt->flags = TS72XX_WDT_BUSY_FLAG;
+	wdt->regval = regval;
+	file->private_data = wdt;
+
+	ts72xx_wdt_start(wdt);
+
+	mutex_unlock(&wdt->lock);
+	return nonseekable_open(inode, file);
+}
+
+static int ts72xx_wdt_release(struct inode *inode, struct file *file)
+{
+	struct ts72xx_wdt *wdt = file->private_data;
+
+	if (mutex_lock_interruptible(&wdt->lock))
+		return -ERESTARTSYS;
+
+	if ((wdt->flags & TS72XX_WDT_EXPECT_CLOSE_FLAG) != 0) {
+		ts72xx_wdt_stop(wdt);
+	} else {
+		dev_warn(&wdt->pdev->dev,
+			 "TS-72XX WDT device closed unexpectly. "
+			 "Watchdog timer will not stop!\n");
+		/*
+		 * Kick it one more time, to give userland some time
+		 * to recover (for example, respawning the kicker
+		 * daemon).
+		 */
+		ts72xx_wdt_kick(wdt);
+	}
+
+	wdt->flags = 0;
+
+	mutex_unlock(&wdt->lock);
+	return 0;
+}
+
+static ssize_t ts72xx_wdt_write(struct file *file,
+				const char __user *data,
+				size_t len,
+				loff_t *ppos)
+{
+	struct ts72xx_wdt *wdt = file->private_data;
+
+	if (!len)
+		return 0;
+
+	if (mutex_lock_interruptible(&wdt->lock))
+		return -ERESTARTSYS;
+
+	ts72xx_wdt_kick(wdt);
+
+	/*
+	 * Support for magic character closing. User process
+	 * writes 'V' into the device, just before it is closed.
+	 * This means that we know that the wdt timer can be
+	 * stopped after user closes the device.
+	 */
+	if (!nowayout) {
+		int i;
+
+		for (i = 0; i < len; i++) {
+			char c;
+
+			/* In case it was set long ago */
+			wdt->flags &= ~TS72XX_WDT_EXPECT_CLOSE_FLAG;
+
+			if (get_user(c, data + i)) {
+				mutex_unlock(&wdt->lock);
+				return -EFAULT;
+			}
+			if (c == 'V') {
+				wdt->flags |= TS72XX_WDT_EXPECT_CLOSE_FLAG;
+				break;
+			}
+		}
+	}
+
+	mutex_unlock(&wdt->lock);
+	return len;
+}
+
+static const struct watchdog_info winfo = {
+	.options		= WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT |
+				  WDIOF_MAGICCLOSE,
+	.firmware_version	= 1,
+	.identity		= "TS-72XX WDT",
+};
+
+static long ts72xx_wdt_ioctl(struct file *file, unsigned int cmd,
+			     unsigned long arg)
+{
+	struct ts72xx_wdt *wdt = file->private_data;
+	void __user *argp = (void __user *)arg;
+	int __user *p = (int __user *)argp;
+	int error = 0;
+
+	if (mutex_lock_interruptible(&wdt->lock))
+		return -ERESTARTSYS;
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		error = copy_to_user(argp, &winfo, sizeof(winfo));
+		break;
+
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+
+	case WDIOC_KEEPALIVE:
+		ts72xx_wdt_kick(wdt);
+		break;
+
+	case WDIOC_SETOPTIONS: {
+		int options;
+
+		if (get_user(options, p)) {
+			error = -EFAULT;
+			break;
+		}
+
+		error = -EINVAL;
+
+		if ((options & WDIOS_DISABLECARD) != 0) {
+			ts72xx_wdt_stop(wdt);
+			error = 0;
+		}
+		if ((options & WDIOS_ENABLECARD) != 0) {
+			ts72xx_wdt_start(wdt);
+			error = 0;
+		}
+
+		break;
+	}
+
+	case WDIOC_SETTIMEOUT: {
+		int new_timeout;
+
+		if (get_user(new_timeout, p)) {
+			error = -EFAULT;
+		} else {
+			int regval;
+
+			regval = timeout_to_regval(new_timeout);
+			if (regval < 0) {
+				error = -EINVAL;
+			} else {
+				ts72xx_wdt_stop(wdt);
+				wdt->regval = regval;
+				ts72xx_wdt_start(wdt);
+			}
+		}
+		if (error)
+			break;
+
+		/*FALLTHROUGH*/
+	}
+
+	case WDIOC_GETTIMEOUT:
+		if (put_user(regval_to_timeout(wdt->regval), p))
+			error = -EFAULT;
+		break;
+
+	default:
+		error = -ENOTTY;
+		break;
+	}
+
+	mutex_unlock(&wdt->lock);
+	return error;
+}
+
+static const struct file_operations ts72xx_wdt_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.open		= ts72xx_wdt_open,
+	.release	= ts72xx_wdt_release,
+	.write		= ts72xx_wdt_write,
+	.unlocked_ioctl	= ts72xx_wdt_ioctl,
+};
+
+static struct miscdevice ts72xx_wdt_miscdev = {
+	.minor		= WATCHDOG_MINOR,
+	.name		= "watchdog",
+	.fops		= &ts72xx_wdt_fops,
+};
+
+static __devinit int ts72xx_wdt_probe(struct platform_device *pdev)
+{
+	struct ts72xx_wdt *wdt;
+	struct resource *r1, *r2;
+	int error = 0;
+
+	wdt = kzalloc(sizeof(struct ts72xx_wdt), GFP_KERNEL);
+	if (!wdt) {
+		dev_err(&pdev->dev, "failed to allocate memory\n");
+		return -ENOMEM;
+	}
+
+	r1 = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!r1) {
+		dev_err(&pdev->dev, "failed to get memory resource\n");
+		error = -ENODEV;
+		goto fail;
+	}
+
+	r1 = request_mem_region(r1->start, resource_size(r1), pdev->name);
+	if (!r1) {
+		dev_err(&pdev->dev, "cannot request memory region\n");
+		error = -EBUSY;
+		goto fail;
+	}
+
+	wdt->control_reg = ioremap(r1->start, resource_size(r1));
+	if (!wdt->control_reg) {
+		dev_err(&pdev->dev, "failed to map memory\n");
+		error = -ENODEV;
+		goto fail_free_control;
+	}
+
+	r2 = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	if (!r2) {
+		dev_err(&pdev->dev, "failed to get memory resource\n");
+		error = -ENODEV;
+		goto fail_unmap_control;
+	}
+
+	r2 = request_mem_region(r2->start, resource_size(r2), pdev->name);
+	if (!r2) {
+		dev_err(&pdev->dev, "cannot request memory region\n");
+		error = -EBUSY;
+		goto fail_unmap_control;
+	}
+
+	wdt->feed_reg = ioremap(r2->start, resource_size(r2));
+	if (!wdt->feed_reg) {
+		dev_err(&pdev->dev, "failed to map memory\n");
+		error = -ENODEV;
+		goto fail_free_feed;
+	}
+
+	platform_set_drvdata(pdev, wdt);
+	ts72xx_wdt_pdev = pdev;
+	wdt->pdev = pdev;
+	mutex_init(&wdt->lock);
+
+	error = misc_register(&ts72xx_wdt_miscdev);
+	if (error) {
+		dev_err(&pdev->dev, "failed to register miscdev\n");
+		goto fail_unmap_feed;
+	}
+
+	dev_info(&pdev->dev, "TS-72xx Watchdog driver\n");
+
+	return 0;
+
+fail_unmap_feed:
+	platform_set_drvdata(pdev, NULL);
+	iounmap(wdt->feed_reg);
+fail_free_feed:
+	release_mem_region(r2->start, resource_size(r2));
+fail_unmap_control:
+	iounmap(wdt->control_reg);
+fail_free_control:
+	release_mem_region(r1->start, resource_size(r1));
+fail:
+	kfree(wdt);
+	return error;
+}
+
+static __devexit int ts72xx_wdt_remove(struct platform_device *pdev)
+{
+	struct ts72xx_wdt *wdt = platform_get_drvdata(pdev);
+	struct resource *res;
+	int error;
+
+	error = misc_deregister(&ts72xx_wdt_miscdev);
+	platform_set_drvdata(pdev, NULL);
+
+	iounmap(wdt->feed_reg);
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	release_mem_region(res->start, resource_size(res));
+
+	iounmap(wdt->control_reg);
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	release_mem_region(res->start, resource_size(res));
+
+	kfree(wdt);
+	return error;
+}
+
+static struct platform_driver ts72xx_wdt_driver = {
+	.probe		= ts72xx_wdt_probe,
+	.remove		= __devexit_p(ts72xx_wdt_remove),
+	.driver		= {
+		.name	= "ts72xx-wdt",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static __init int ts72xx_wdt_init(void)
+{
+	return platform_driver_register(&ts72xx_wdt_driver);
+}
+module_init(ts72xx_wdt_init);
+
+static __exit void ts72xx_wdt_exit(void)
+{
+	platform_driver_unregister(&ts72xx_wdt_driver);
+}
+module_exit(ts72xx_wdt_exit);
+
+MODULE_AUTHOR("Mika Westerberg <mika.westerberg@iki.fi>");
+MODULE_DESCRIPTION("TS-72xx SBC Watchdog");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:ts72xx-wdt");
diff --git a/drivers/watchdog/txx9wdt.c b/drivers/watchdog/txx9wdt.c
index d635566..9e9ed7b 100644
--- a/drivers/watchdog/txx9wdt.c
+++ b/drivers/watchdog/txx9wdt.c
@@ -13,7 +13,6 @@
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
 #include <linux/fs.h>
-#include <linux/reboot.h>
 #include <linux/init.h>
 #include <linux/uaccess.h>
 #include <linux/platform_device.h>
@@ -166,14 +165,6 @@ static long txx9wdt_ioctl(struct file *file, unsigned int cmd,
 	}
 }
 
-static int txx9wdt_notify_sys(struct notifier_block *this, unsigned long code,
-	void *unused)
-{
-	if (code == SYS_DOWN || code == SYS_HALT)
-		txx9wdt_stop();
-	return NOTIFY_DONE;
-}
-
 static const struct file_operations txx9wdt_fops = {
 	.owner		=	THIS_MODULE,
 	.llseek		=	no_llseek,
@@ -189,10 +180,6 @@ static struct miscdevice txx9wdt_miscdev = {
 	.fops	=	&txx9wdt_fops,
 };
 
-static struct notifier_block txx9wdt_notifier = {
-	.notifier_call = txx9wdt_notify_sys,
-};
-
 static int __init txx9wdt_probe(struct platform_device *dev)
 {
 	struct resource *res;
@@ -221,13 +208,8 @@ static int __init txx9wdt_probe(struct platform_device *dev)
 	if (!txx9wdt_reg)
 		goto exit_busy;
 
-	ret = register_reboot_notifier(&txx9wdt_notifier);
-	if (ret)
-		goto exit;
-
 	ret = misc_register(&txx9wdt_miscdev);
 	if (ret) {
-		unregister_reboot_notifier(&txx9wdt_notifier);
 		goto exit;
 	}
 
@@ -249,14 +231,19 @@ exit:
 static int __exit txx9wdt_remove(struct platform_device *dev)
 {
 	misc_deregister(&txx9wdt_miscdev);
-	unregister_reboot_notifier(&txx9wdt_notifier);
 	clk_disable(txx9_imclk);
 	clk_put(txx9_imclk);
 	return 0;
 }
 
+static void txx9wdt_shutdown(struct platform_device *dev)
+{
+	txx9wdt_stop();
+}
+
 static struct platform_driver txx9wdt_driver = {
 	.remove = __exit_p(txx9wdt_remove),
+	.shutdown = txx9wdt_shutdown,
 	.driver = {
 		.name = "txx9wdt",
 		.owner = THIS_MODULE,
diff --git a/drivers/watchdog/w83627hf_wdt.c b/drivers/watchdog/w83627hf_wdt.c
index f201acc..0f5288d 100644
--- a/drivers/watchdog/w83627hf_wdt.c
+++ b/drivers/watchdog/w83627hf_wdt.c
@@ -201,7 +201,7 @@ static long wdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 	int new_timeout;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT |
 							WDIOF_MAGICCLOSE,
 		.firmware_version = 1,
diff --git a/drivers/watchdog/w83977f_wdt.c b/drivers/watchdog/w83977f_wdt.c
index 0560182..6e6743d 100644
--- a/drivers/watchdog/w83977f_wdt.c
+++ b/drivers/watchdog/w83977f_wdt.c
@@ -371,7 +371,7 @@ static ssize_t wdt_write(struct file *file, const char __user *buf,
  *      according to their available features.
  */
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options = WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE | WDIOF_KEEPALIVEPING,
 	.firmware_version =	1,
 	.identity = WATCHDOG_NAME,
diff --git a/drivers/watchdog/wdrtas.c b/drivers/watchdog/wdrtas.c
index 5bfb1f2..94ec22b 100644
--- a/drivers/watchdog/wdrtas.c
+++ b/drivers/watchdog/wdrtas.c
@@ -312,7 +312,7 @@ static long wdrtas_ioctl(struct file *file, unsigned int cmd,
 {
 	int __user *argp = (void __user *)arg;
 	int i;
-	static struct watchdog_info wdinfo = {
+	static const struct watchdog_info wdinfo = {
 		.options = WDRTAS_SUPPORTED_MASK,
 		.firmware_version = 0,
 		.identity = "wdrtas",
diff --git a/drivers/watchdog/wdt.c b/drivers/watchdog/wdt.c
index 3bbefe9..bfda2e9 100644
--- a/drivers/watchdog/wdt.c
+++ b/drivers/watchdog/wdt.c
@@ -358,7 +358,7 @@ static long wdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	int new_heartbeat;
 	int status;
 
-	static struct watchdog_info ident = {
+	struct watchdog_info ident = {
 		.options =		WDIOF_SETTIMEOUT|
 					WDIOF_MAGICCLOSE|
 					WDIOF_KEEPALIVEPING,
diff --git a/drivers/watchdog/wdt_pci.c b/drivers/watchdog/wdt_pci.c
index f368dd8..7b22e3c 100644
--- a/drivers/watchdog/wdt_pci.c
+++ b/drivers/watchdog/wdt_pci.c
@@ -412,7 +412,7 @@ static long wdtpci_ioctl(struct file *file, unsigned int cmd,
 	int new_heartbeat;
 	int status;
 
-	static struct watchdog_info ident = {
+	struct watchdog_info ident = {
 		.options =		WDIOF_SETTIMEOUT|
 					WDIOF_MAGICCLOSE|
 					WDIOF_KEEPALIVEPING,
diff --git a/drivers/watchdog/wm831x_wdt.c b/drivers/watchdog/wm831x_wdt.c
index 775bcd8..8c4b2d5 100644
--- a/drivers/watchdog/wm831x_wdt.c
+++ b/drivers/watchdog/wm831x_wdt.c
@@ -213,7 +213,7 @@ static ssize_t wm831x_wdt_write(struct file *file,
 	return count;
 }
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
 	.identity = "WM831x Watchdog",
 };
diff --git a/drivers/watchdog/wm8350_wdt.c b/drivers/watchdog/wm8350_wdt.c
index a2d2e8e..89dd7b0 100644
--- a/drivers/watchdog/wm8350_wdt.c
+++ b/drivers/watchdog/wm8350_wdt.c
@@ -177,7 +177,7 @@ static ssize_t wm8350_wdt_write(struct file *file,
 	return count;
 }
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
 	.identity = "WM8350 Watchdog",
 };
