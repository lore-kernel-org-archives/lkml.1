Return-Path: <linux-kernel-owner+w=401wt.eu-S1751586AbZGUEgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586AbZGUEgF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 00:36:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751009AbZGUEgC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 00:36:02 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4950 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbZGUEfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 00:35:54 -0400
From: Joe Perches <joe@perches.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-kernel@vger.kernel.org, Mike Rapoport <mike@compulab.co.il>,
       Denis Turischev <denis@compulab.co.il>,
       Andrey Panin <pazke@centrinvest.ru>
Subject: [PATCH 3/3] drivers/watchdog: use pr_fmt
Date: Mon, 20 Jul 2009 21:35:02 -0700
Message-Id: <6b967e9f3682c95b8eacf98772a863e659177edd.1248148948.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <4A6492EB.1080709@compulab.co.il>
References: <4A6492EB.1080709@compulab.co.il>
In-Reply-To: <cover.1248148947.git.joe@perches.com>
References: <cover.1248148947.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/watchdog/acquirewdt.c          |   21 ++++-----
 drivers/watchdog/advantechwdt.c        |   26 ++++-------
 drivers/watchdog/alim1535_wdt.c        |   22 ++++-----
 drivers/watchdog/alim7101_wdt.c        |   50 ++++++++------------
 drivers/watchdog/ar7_wdt.c             |   27 +++++------
 drivers/watchdog/at91rm9200_wdt.c      |    2 +-
 drivers/watchdog/at91sam9_wdt.c        |    8 ++-
 drivers/watchdog/bcm47xx_wdt.c         |   12 +++---
 drivers/watchdog/bfin_wdt.c            |   34 ++++++--------
 drivers/watchdog/booke_wdt.c           |   14 +++---
 drivers/watchdog/cpu5wdt.c             |   14 +++---
 drivers/watchdog/cpwd.c                |   20 ++++----
 drivers/watchdog/ep93xx_wdt.c          |   12 ++---
 drivers/watchdog/eurotechwdt.c         |   16 ++++---
 drivers/watchdog/gef_wdt.c             |    8 ++-
 drivers/watchdog/geodewdt.c            |    3 +-
 drivers/watchdog/hpwdt.c               |   18 ++++---
 drivers/watchdog/i6300esb.c            |   34 ++++++--------
 drivers/watchdog/iTCO_vendor_support.c |    7 +--
 drivers/watchdog/iTCO_wdt.c            |   52 +++++++++------------
 drivers/watchdog/ib700wdt.c            |   22 ++++-----
 drivers/watchdog/ibmasr.c              |   14 +++---
 drivers/watchdog/indydog.c             |   21 +++++----
 drivers/watchdog/iop_wdt.c             |   11 +++--
 drivers/watchdog/it8712f_wdt.c         |   26 +++++-----
 drivers/watchdog/it87_wdt.c            |   39 +++++++---------
 drivers/watchdog/ixp2000_wdt.c         |    5 +-
 drivers/watchdog/ixp4xx_wdt.c          |   12 ++---
 drivers/watchdog/ks8695_wdt.c          |   10 +++--
 drivers/watchdog/machzwd.c             |   33 ++++++-------
 drivers/watchdog/mixcomwd.c            |   22 +++------
 drivers/watchdog/mpcore_wdt.c          |   16 ++++---
 drivers/watchdog/mtx-1_wdt.c           |    6 ++-
 drivers/watchdog/mv64x60_wdt.c         |    8 ++-
 drivers/watchdog/omap_wdt.c            |    4 +-
 drivers/watchdog/orion_wdt.c           |   12 +++--
 drivers/watchdog/pc87413_wdt.c         |   35 ++++++--------
 drivers/watchdog/pcwd.c                |   77 ++++++++++++++------------------
 drivers/watchdog/pcwd_pci.c            |   72 +++++++++++++++--------------
 drivers/watchdog/pcwd_usb.c            |   67 ++++++++++++---------------
 drivers/watchdog/pika_wdt.c            |   19 ++++----
 drivers/watchdog/pnx4008_wdt.c         |   20 +++++----
 drivers/watchdog/pnx833x_wdt.c         |   26 +++++-----
 drivers/watchdog/rc32434_wdt.c         |   36 +++++++-------
 drivers/watchdog/rdc321x_wdt.c         |    7 ++-
 drivers/watchdog/riowd.c               |   11 +++--
 drivers/watchdog/rm9k_wdt.c            |   10 ++---
 drivers/watchdog/s3c2410_wdt.c         |   10 ++--
 drivers/watchdog/sa1100_wdt.c          |    7 ++-
 drivers/watchdog/sb_wdog.c             |   14 +++---
 drivers/watchdog/sbc60xxwdt.c          |   40 +++++++----------
 drivers/watchdog/sbc7240_wdt.c         |   40 ++++++----------
 drivers/watchdog/sbc8360.c             |   21 ++++-----
 drivers/watchdog/sbc_epx_c3.c          |   21 +++++----
 drivers/watchdog/sc1200wdt.c           |   34 +++++++-------
 drivers/watchdog/sc520_wdt.c           |   35 ++++++---------
 drivers/watchdog/sch311x_wdt.c         |   12 +++---
 drivers/watchdog/scx200_wdt.c          |   23 +++++-----
 drivers/watchdog/shwdt.c               |   34 ++++++--------
 drivers/watchdog/smsc37b787_wdt.c      |   34 ++++++--------
 drivers/watchdog/softdog.c             |   37 +++++++--------
 drivers/watchdog/stmp3xxx_wdt.c        |    6 ++-
 drivers/watchdog/txx9wdt.c             |   10 +++--
 drivers/watchdog/w83627hf_wdt.c        |   32 +++++--------
 drivers/watchdog/w83697hf_wdt.c        |   41 +++++++---------
 drivers/watchdog/w83697ug_wdt.c        |   28 +++++-------
 drivers/watchdog/w83877f_wdt.c         |   38 ++++++---------
 drivers/watchdog/w83977f_wdt.c         |   33 ++++++--------
 drivers/watchdog/wafer5823wdt.c        |   29 +++++-------
 drivers/watchdog/wdrtas.c              |   65 ++++++++++----------------
 drivers/watchdog/wdt.c                 |   28 ++++++-----
 drivers/watchdog/wdt285.c              |    4 +-
 drivers/watchdog/wdt977.c              |   35 ++++++--------
 drivers/watchdog/wdt_pci.c             |   61 ++++++++++++--------------
 74 files changed, 838 insertions(+), 975 deletions(-)

diff --git a/drivers/watchdog/acquirewdt.c b/drivers/watchdog/acquirewdt.c
index 69e7db4..e898008 100644
--- a/drivers/watchdog/acquirewdt.c
+++ b/drivers/watchdog/acquirewdt.c
@@ -48,6 +48,8 @@
  *		It can be 1, 2, 10, 20, 110 or 220 seconds.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 /*
  *	Includes, defines, variables, module parameters, ...
  */
@@ -70,7 +72,6 @@
 
 /* Module information */
 #define DRV_NAME "acquirewdt"
-#define PFX DRV_NAME ": "
 #define WATCHDOG_NAME "Acquire WDT"
 /* There is no way to see what the correct time-out period is */
 #define WATCHDOG_HEARTBEAT 0
@@ -208,8 +209,7 @@ static int acq_close(struct inode *inode, struct file *file)
 	if (expect_close == 42) {
 		acq_stop();
 	} else {
-		pr_crit(PFX
-			"Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		acq_keepalive();
 	}
 	clear_bit(0, &acq_is_open);
@@ -246,27 +246,24 @@ static int __devinit acq_probe(struct platform_device *dev)
 
 	if (wdt_stop != wdt_start) {
 		if (!request_region(wdt_stop, 1, WATCHDOG_NAME)) {
-			pr_err(PFX
-			    "I/O address 0x%04x already in use\n", wdt_stop);
+			pr_err("I/O address 0x%04x already in use\n", wdt_stop);
 			ret = -EIO;
 			goto out;
 		}
 	}
 
 	if (!request_region(wdt_start, 1, WATCHDOG_NAME)) {
-		pr_err(PFX "I/O address 0x%04x already in use\n",
-			wdt_start);
+		pr_err("I/O address 0x%04x already in use\n", wdt_start);
 		ret = -EIO;
 		goto unreg_stop;
 	}
 	ret = misc_register(&acq_miscdev);
 	if (ret != 0) {
-		pr_err(PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-							WATCHDOG_MINOR, ret);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, ret);
 		goto unreg_regions;
 	}
-	pr_info(PFX "initialized. (nowayout=%d)\n", nowayout);
+	pr_info("initialized. (nowayout=%d)\n", nowayout);
 
 	return 0;
 unreg_regions:
@@ -331,7 +328,7 @@ static void __exit acq_exit(void)
 {
 	platform_device_unregister(acq_platform_device);
 	platform_driver_unregister(&acquirewdt_driver);
-	pr_info(PFX "Watchdog Module Unloaded.\n");
+	pr_info("Watchdog Module Unloaded.\n");
 }
 
 module_init(acq_init);
diff --git a/drivers/watchdog/advantechwdt.c b/drivers/watchdog/advantechwdt.c
index 7b2c6e6..1ab38a5 100644
--- a/drivers/watchdog/advantechwdt.c
+++ b/drivers/watchdog/advantechwdt.c
@@ -28,6 +28,8 @@
  *	    add wdt_start and wdt_stop as parameters.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -43,7 +45,6 @@
 #include <asm/system.h>
 
 #define DRV_NAME "advantechwdt"
-#define PFX DRV_NAME ": "
 #define WATCHDOG_NAME "Advantech WDT"
 #define WATCHDOG_TIMEOUT 60		/* 60 sec default timeout */
 
@@ -207,8 +208,7 @@ static int advwdt_close(struct inode *inode, struct file *file)
 	if (adv_expect_close == 42) {
 		advwdt_disable();
 	} else {
-		pr_crit(PFX
-				"Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		advwdt_ping();
 	}
 	clear_bit(0, &advwdt_is_open);
@@ -245,18 +245,14 @@ static int __devinit advwdt_probe(struct platform_device *dev)
 
 	if (wdt_stop != wdt_start) {
 		if (!request_region(wdt_stop, 1, WATCHDOG_NAME)) {
-			pr_err(PFX
-				"I/O address 0x%04x already in use\n",
-								wdt_stop);
+			pr_err("I/O address 0x%04x already in use\n", wdt_stop);
 			ret = -EIO;
 			goto out;
 		}
 	}
 
 	if (!request_region(wdt_start, 1, WATCHDOG_NAME)) {
-		pr_err(PFX
-				"I/O address 0x%04x already in use\n",
-								wdt_start);
+		pr_err("I/O address 0x%04x already in use\n", wdt_start);
 		ret = -EIO;
 		goto unreg_stop;
 	}
@@ -265,18 +261,16 @@ static int __devinit advwdt_probe(struct platform_device *dev)
 	 * if not reset to the default */
 	if (advwdt_set_heartbeat(timeout)) {
 		advwdt_set_heartbeat(WATCHDOG_TIMEOUT);
-		pr_info(PFX
-			"timeout value must be 1<=x<=63, using %d\n", timeout);
+		pr_info("timeout value must be 1<=x<=63, using %d\n", timeout);
 	}
 
 	ret = misc_register(&advwdt_miscdev);
 	if (ret != 0) {
-		pr_err(PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-							WATCHDOG_MINOR, ret);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, ret);
 		goto unreg_regions;
 	}
-	pr_info(PFX "initialized. timeout=%d sec (nowayout=%d)\n",
+	pr_info("initialized. timeout=%d sec (nowayout=%d)\n",
 		timeout, nowayout);
 out:
 	return ret;
@@ -342,7 +336,7 @@ static void __exit advwdt_exit(void)
 {
 	platform_device_unregister(advwdt_platform_device);
 	platform_driver_unregister(&advwdt_driver);
-	pr_info(PFX "Watchdog Module Unloaded.\n");
+	pr_info("Watchdog Module Unloaded.\n");
 }
 
 module_init(advwdt_init);
diff --git a/drivers/watchdog/alim1535_wdt.c b/drivers/watchdog/alim1535_wdt.c
index 2d68918..39c6597 100644
--- a/drivers/watchdog/alim1535_wdt.c
+++ b/drivers/watchdog/alim1535_wdt.c
@@ -7,6 +7,8 @@
  *	2 of the License, or (at your option) any later version.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -21,8 +23,6 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 
-#define WATCHDOG_NAME "ALi_M1535"
-#define PFX WATCHDOG_NAME ": "
 #define WATCHDOG_TIMEOUT 60	/* 60 sec default timeout */
 
 /* internal variables */
@@ -268,8 +268,7 @@ static int ali_release(struct inode *inode, struct file *file)
 	if (ali_expect_release == 42)
 		ali_stop();
 	else {
-		pr_crit(PFX
-				"Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		ali_keepalive();
 	}
 	clear_bit(0, &ali_is_open);
@@ -399,9 +398,8 @@ static int __init watchdog_init(void)
 	   if not reset to the default */
 	if (timeout < 1 || timeout >= 18000) {
 		timeout = WATCHDOG_TIMEOUT;
-		pr_info(PFX
-		     "timeout value must be 0 < timeout < 18000, using %d\n",
-							timeout);
+		pr_info("timeout value must be 0 < timeout < 18000, using %d\n",
+			timeout);
 	}
 
 	/* Calculate the watchdog's timeout */
@@ -409,20 +407,18 @@ static int __init watchdog_init(void)
 
 	ret = register_reboot_notifier(&ali_notifier);
 	if (ret != 0) {
-		pr_err(PFX
-			"cannot register reboot notifier (err=%d)\n", ret);
+		pr_err("cannot register reboot notifier (err=%d)\n", ret);
 		goto out;
 	}
 
 	ret = misc_register(&ali_miscdev);
 	if (ret != 0) {
-		pr_err(PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-						WATCHDOG_MINOR, ret);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, ret);
 		goto unreg_reboot;
 	}
 
-	pr_info(PFX "initialized. timeout=%d sec (nowayout=%d)\n",
+	pr_info("initialized. timeout=%d sec (nowayout=%d)\n",
 		timeout, nowayout);
 
 out:
diff --git a/drivers/watchdog/alim7101_wdt.c b/drivers/watchdog/alim7101_wdt.c
index f2b9548..0c74b1b 100644
--- a/drivers/watchdog/alim7101_wdt.c
+++ b/drivers/watchdog/alim7101_wdt.c
@@ -19,6 +19,8 @@
  *                  -- Mike Waychison <michael.waychison@sun.com>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -36,9 +38,6 @@
 
 #include <asm/system.h>
 
-#define OUR_NAME "alim7101_wdt"
-#define PFX OUR_NAME ": "
-
 #define WDT_ENABLE 0x9C
 #define WDT_DISABLE 0x8C
 
@@ -112,8 +111,7 @@ static void wdt_timer_ping(unsigned long data)
 					ALI_7101_GPIO_O, tmp & ~0x20);
 		}
 	} else {
-		pr_warning(PFX
-			"Heartbeat lost! Will not ping the watchdog\n");
+		pr_warning("Heartbeat lost! Will not ping the watchdog\n");
 	}
 	/* Re-set the timer interval */
 	mod_timer(&timer, jiffies + WDT_INTERVAL);
@@ -162,7 +160,7 @@ static void wdt_startup(void)
 	/* Start the timer */
 	mod_timer(&timer, jiffies + WDT_INTERVAL);
 
-	pr_info(PFX "Watchdog timer is now enabled.\n");
+	pr_info("Watchdog timer is now enabled.\n");
 }
 
 static void wdt_turnoff(void)
@@ -170,7 +168,7 @@ static void wdt_turnoff(void)
 	/* Stop the timer */
 	del_timer_sync(&timer);
 	wdt_change(WDT_DISABLE);
-	pr_info(PFX "Watchdog timer is now disabled...\n");
+	pr_info("Watchdog timer is now disabled...\n");
 }
 
 static void wdt_keepalive(void)
@@ -226,8 +224,7 @@ static int fop_close(struct inode *inode, struct file *file)
 		wdt_turnoff();
 	else {
 		/* wim: shouldn't there be a: del_timer(&timer); */
-		pr_crit(PFX
-		  "device file closed unexpectedly. Will not stop the WDT!\n");
+		pr_crit("device file closed unexpectedly. Will not stop the WDT!\n");
 	}
 	clear_bit(0, &wdt_is_open);
 	wdt_expect_close = 0;
@@ -322,8 +319,8 @@ static int wdt_notify_sys(struct notifier_block *this,
 		 * watchdog on reboot with no heartbeat
 		 */
 		wdt_change(WDT_ENABLE);
-		pr_info(PFX "Watchdog timer is now enabled "
-			"with no heartbeat - should reboot in ~1 second.\n");
+		pr_info("Watchdog timer is now enabled with no heartbeat - "
+			"should reboot in ~1 second.\n");
 	}
 	return NOTIFY_DONE;
 }
@@ -352,12 +349,11 @@ static int __init alim7101_wdt_init(void)
 	struct pci_dev *ali1543_south;
 	char tmp;
 
-	pr_info(PFX "Steve Hill <steve@navaho.co.uk>.\n");
+	pr_info("Steve Hill <steve@navaho.co.uk>.\n");
 	alim7101_pmu = pci_get_device(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M7101,
 		NULL);
 	if (!alim7101_pmu) {
-		pr_info(PFX
-			"ALi M7101 PMU not present - WDT not set\n");
+		pr_info("ALi M7101 PMU not present - WDT not set\n");
 		return -EBUSY;
 	}
 
@@ -367,24 +363,21 @@ static int __init alim7101_wdt_init(void)
 	ali1543_south = pci_get_device(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M1533,
 		NULL);
 	if (!ali1543_south) {
-		pr_info(PFX
-			"ALi 1543 South-Bridge not present - WDT not set\n");
+		pr_info("ALi 1543 South-Bridge not present - WDT not set\n");
 		goto err_out;
 	}
 	pci_read_config_byte(ali1543_south, 0x5e, &tmp);
 	pci_dev_put(ali1543_south);
 	if ((tmp & 0x1e) == 0x00) {
 		if (!use_gpio) {
-			pr_info(PFX
-				"Detected old alim7101 revision 'a1d'.  "
+			pr_info("Detected old alim7101 revision 'a1d'.  "
 				"If this is a cobalt board, set the 'use_gpio' "
 				"module parameter.\n");
 			goto err_out;
 		}
 		nowayout = 1;
 	} else if ((tmp & 0x1e) != 0x12 && (tmp & 0x1e) != 0x00) {
-		pr_info(PFX
-			"ALi 1543 South-Bridge does not have the correct "
+		pr_info("ALi 1543 South-Bridge does not have the correct "
 			"revision number (???1001?) - WDT not set\n");
 		goto err_out;
 	}
@@ -392,31 +385,28 @@ static int __init alim7101_wdt_init(void)
 	if (timeout < 1 || timeout > 3600) {
 		/* arbitrary upper limit */
 		timeout = WATCHDOG_TIMEOUT;
-		pr_info(PFX
-			"timeout value must be 1 <= x <= 3600, using %d\n",
-								timeout);
+		pr_info("timeout value must be 1 <= x <= 3600, using %d\n",
+			timeout);
 	}
 
 	rc = register_reboot_notifier(&wdt_notifier);
 	if (rc) {
-		pr_err(PFX
-			"cannot register reboot notifier (err=%d)\n", rc);
+		pr_err("cannot register reboot notifier (err=%d)\n", rc);
 		goto err_out;
 	}
 
 	rc = misc_register(&wdt_miscdev);
 	if (rc) {
-		pr_err(PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-			wdt_miscdev.minor, rc);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       wdt_miscdev.minor, rc);
 		goto err_out_reboot;
 	}
 
 	if (nowayout)
 		__module_get(THIS_MODULE);
 
-	pr_info(PFX "WDT driver for ALi M7101 initialised. "
-					"timeout=%d sec (nowayout=%d)\n",
+	pr_info("WDT driver for ALi M7101 initialised. "
+		"timeout=%d sec (nowayout=%d)\n",
 		timeout, nowayout);
 	return 0;
 
diff --git a/drivers/watchdog/ar7_wdt.c b/drivers/watchdog/ar7_wdt.c
index 9a1390c..30fc217 100644
--- a/drivers/watchdog/ar7_wdt.c
+++ b/drivers/watchdog/ar7_wdt.c
@@ -23,6 +23,8 @@
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/errno.h>
@@ -105,7 +107,7 @@ static void ar7_wdt_kick(u32 value)
 			return;
 		}
 	}
-	pr_err(DRVNAME ": failed to unlock WDT kick reg\n");
+	pr_err("failed to unlock WDT kick reg\n");
 }
 
 static void ar7_wdt_prescale(u32 value)
@@ -118,7 +120,7 @@ static void ar7_wdt_prescale(u32 value)
 			return;
 		}
 	}
-	pr_err(DRVNAME ": failed to unlock WDT prescale reg\n");
+	pr_err("failed to unlock WDT prescale reg\n");
 }
 
 static void ar7_wdt_change(u32 value)
@@ -131,7 +133,7 @@ static void ar7_wdt_change(u32 value)
 			return;
 		}
 	}
-	pr_err(DRVNAME ": failed to unlock WDT change reg\n");
+	pr_err("failed to unlock WDT change reg\n");
 }
 
 static void ar7_wdt_disable(u32 value)
@@ -147,7 +149,7 @@ static void ar7_wdt_disable(u32 value)
 			}
 		}
 	}
-	pr_err(DRVNAME ": failed to unlock WDT disable reg\n");
+	pr_err("failed to unlock WDT disable reg\n");
 }
 
 static void ar7_wdt_update_margin(int new_margin)
@@ -161,9 +163,8 @@ static void ar7_wdt_update_margin(int new_margin)
 		change = 0xffff;
 	ar7_wdt_change(change);
 	margin = change * prescale_value / ar7_vbus_freq();
-	pr_info(DRVNAME
-	       ": timer margin %d seconds (prescale %d, change %d, freq %d)\n",
-	       margin, prescale_value, change, ar7_vbus_freq());
+	pr_info("timer margin %d seconds (prescale %d, change %d, freq %d)\n",
+		margin, prescale_value, change, ar7_vbus_freq());
 }
 
 static void ar7_wdt_enable_wdt(void)
@@ -193,9 +194,8 @@ static int ar7_wdt_open(struct inode *inode, struct file *file)
 static int ar7_wdt_release(struct inode *inode, struct file *file)
 {
 	if (!expect_close)
-		pr_warning(DRVNAME
-		": watchdog device closed unexpectedly,"
-		"will not disable the watchdog timer\n");
+		pr_warning("watchdog device closed unexpectedly, "
+			   "will not disable the watchdog timer\n");
 	else if (!nowayout)
 		ar7_wdt_disable_wdt();
 	clear_bit(0, &wdt_is_open);
@@ -309,7 +309,7 @@ static int __init ar7_wdt_init(void)
 
 	if (!request_mem_region(ar7_regs_wdt, sizeof(struct ar7_wdt),
 							LONGNAME)) {
-		pr_warning(DRVNAME ": watchdog I/O region busy\n");
+		pr_warning("watchdog I/O region busy\n");
 		return -EBUSY;
 	}
 
@@ -322,14 +322,13 @@ static int __init ar7_wdt_init(void)
 
 	rc = register_reboot_notifier(&ar7_wdt_notifier);
 	if (rc) {
-		pr_err(DRVNAME
-			": unable to register reboot notifier\n");
+		pr_err("unable to register reboot notifier\n");
 		goto out_alloc;
 	}
 
 	rc = misc_register(&ar7_wdt_miscdev);
 	if (rc) {
-		pr_err(DRVNAME ": unable to register misc device\n");
+		pr_err("unable to register misc device\n");
 		goto out_register;
 	}
 	goto out;
diff --git a/drivers/watchdog/at91rm9200_wdt.c b/drivers/watchdog/at91rm9200_wdt.c
index 27981eb..078ca86 100644
--- a/drivers/watchdog/at91rm9200_wdt.c
+++ b/drivers/watchdog/at91rm9200_wdt.c
@@ -210,7 +210,7 @@ static int __devinit at91wdt_probe(struct platform_device *pdev)
 		return res;
 
 	pr_info("AT91 Watchdog Timer enabled (%d seconds%s)\n",
-				wdt_time, nowayout ? ", nowayout" : "");
+		wdt_time, nowayout ? ", nowayout" : "");
 	return 0;
 }
 
diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
index 3baaf1e..2c174cf 100644
--- a/drivers/watchdog/at91sam9_wdt.c
+++ b/drivers/watchdog/at91sam9_wdt.c
@@ -15,6 +15,8 @@
  * bootloader doesn't write to this register.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/errno.h>
 #include <linux/fs.h>
 #include <linux/init.h>
@@ -90,7 +92,7 @@ static void at91_ping(unsigned long data)
 		at91_wdt_reset();
 		mod_timer(&at91wdt_private.timer, jiffies + WDT_TIMEOUT);
 	} else
-		pr_crit(DRV_NAME": I will reset your machine !\n");
+		pr_crit("I will reset your machine !\n");
 }
 
 /*
@@ -134,7 +136,7 @@ static int at91_wdt_settimeout(unsigned int timeout)
 	/* Check if disabled */
 	mr = at91_sys_read(AT91_WDT_MR);
 	if (mr & AT91_WDT_WDDIS) {
-		pr_err(DRV_NAME": sorry, watchdog is disabled\n");
+		pr_err("sorry, watchdog is disabled\n");
 		return -EIO;
 	}
 
@@ -267,7 +269,7 @@ static int __init at91wdt_probe(struct platform_device *pdev)
 	setup_timer(&at91wdt_private.timer, at91_ping, 0);
 	mod_timer(&at91wdt_private.timer, jiffies + WDT_TIMEOUT);
 
-	pr_info(DRV_NAME " enabled (heartbeat=%d sec, nowayout=%d)\n",
+	pr_info("enabled (heartbeat=%d sec, nowayout=%d)\n",
 		heartbeat, nowayout);
 
 	return 0;
diff --git a/drivers/watchdog/bcm47xx_wdt.c b/drivers/watchdog/bcm47xx_wdt.c
index eddb117..cfc824a 100644
--- a/drivers/watchdog/bcm47xx_wdt.c
+++ b/drivers/watchdog/bcm47xx_wdt.c
@@ -10,6 +10,8 @@
  *  2 of the License, or (at your option) any later version.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/bitops.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
@@ -68,7 +70,7 @@ static void bcm47xx_timer_tick(unsigned long unused)
 		bcm47xx_wdt_hw_start();
 		mod_timer(&wdt_timer, jiffies + HZ);
 	} else {
-		pr_crit(DRV_NAME "Watchdog will fire soon!!!\n");
+		pr_crit("Watchdog will fire soon!!!\n");
 	}
 }
 
@@ -117,8 +119,7 @@ static int bcm47xx_wdt_release(struct inode *inode, struct file *file)
 	if (expect_release == 42) {
 		bcm47xx_wdt_stop();
 	} else {
-		pr_crit(DRV_NAME
-			": Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		bcm47xx_wdt_start();
 	}
 
@@ -247,8 +248,7 @@ static int __init bcm47xx_wdt_init(void)
 
 	if (bcm47xx_wdt_settimeout(wdt_time)) {
 		bcm47xx_wdt_settimeout(WDT_DEFAULT_TIME);
-		pr_info(DRV_NAME ": "
-			"wdt_time value must be 0 < wdt_time < %d, using %d\n",
+		pr_info("wdt_time value must be 0 < wdt_time < %d, using %d\n",
 			(WDT_MAX_TIME + 1), wdt_time);
 	}
 
@@ -263,7 +263,7 @@ static int __init bcm47xx_wdt_init(void)
 	}
 
 	pr_info("BCM47xx Watchdog Timer enabled (%d seconds%s)\n",
-				wdt_time, nowayout ? ", nowayout" : "");
+		wdt_time, nowayout ? ", nowayout" : "");
 	return 0;
 }
 
diff --git a/drivers/watchdog/bfin_wdt.c b/drivers/watchdog/bfin_wdt.c
index 298d06b..4ac8d41 100644
--- a/drivers/watchdog/bfin_wdt.c
+++ b/drivers/watchdog/bfin_wdt.c
@@ -12,6 +12,8 @@
  * Licensed under the GPL-2 or later.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/platform_device.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
@@ -30,15 +32,8 @@
 #define stamp(fmt, args...) \
 	pr_debug("%s:%i: " fmt "\n", __func__, __LINE__, ## args)
 #define stampit() stamp("here i am")
-#define pr_devinit(fmt, args...) \
-	({ static const __devinitconst char __fmt[] = fmt; \
-	printk(__fmt, ## args); })
-#define pr_init(fmt, args...) \
-	({ static const __initconst char __fmt[] = fmt; \
-	printk(__fmt, ## args); })
 
 #define WATCHDOG_NAME "bfin-wdt"
-#define PFX WATCHDOG_NAME ": "
 
 /* The BF561 has two watchdogs (one per core), but since Linux
  * only runs on core A, we'll just work with that one.
@@ -144,7 +139,7 @@ static int bfin_wdt_set_timeout(unsigned long t)
 
 	cnt = t * get_sclk();
 	if (cnt < get_sclk()) {
-		pr_warning(PFX "timeout value is too large\n");
+		pr_warning("timeout value is too large\n");
 		return -EINVAL;
 	}
 
@@ -200,8 +195,7 @@ static int bfin_wdt_release(struct inode *inode, struct file *file)
 	if (expect_close == 42)
 		bfin_wdt_stop();
 	else {
-		pr_crit(PFX
-			"Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		bfin_wdt_keepalive();
 	}
 	expect_close = 0;
@@ -410,22 +404,24 @@ static int __devinit bfin_wdt_probe(struct platform_device *pdev)
 
 	ret = register_reboot_notifier(&bfin_wdt_notifier);
 	if (ret) {
-		pr_devinit(KERN_ERR PFX
-			"cannot register reboot notifier (err=%d)\n", ret);
+		pr_err_section(__devinitconst,
+			       "cannot register reboot notifier (err=%d)\n",
+			       ret);
 		return ret;
 	}
 
 	ret = misc_register(&bfin_wdt_miscdev);
 	if (ret) {
-		pr_devinit(KERN_ERR PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-				WATCHDOG_MINOR, ret);
+		pr_err_section(__devinitconst,
+			       "cannot register miscdev on minor=%d (err=%d)\n",
+			       WATCHDOG_MINOR, ret);
 		unregister_reboot_notifier(&bfin_wdt_notifier);
 		return ret;
 	}
 
-	pr_devinit(KERN_INFO PFX "initialized: timeout=%d sec (nowayout=%d)\n",
-	       timeout, nowayout);
+	pr_info_section(__devinitconst,
+			"initialized: timeout=%d sec (nowayout=%d)\n",
+			timeout, nowayout);
 
 	return 0;
 }
@@ -477,14 +473,14 @@ static int __init bfin_wdt_init(void)
 	 */
 	ret = platform_driver_register(&bfin_wdt_driver);
 	if (ret) {
-		pr_init(KERN_ERR PFX "unable to register driver\n");
+		pr_err_section(__initconst, "unable to register driver\n");
 		return ret;
 	}
 
 	bfin_wdt_device = platform_device_register_simple(WATCHDOG_NAME,
 								-1, NULL, 0);
 	if (IS_ERR(bfin_wdt_device)) {
-		pr_init(KERN_ERR PFX "unable to register device\n");
+		pr_err_section(__initconst, "unable to register device\n");
 		platform_driver_unregister(&bfin_wdt_driver);
 		return PTR_ERR(bfin_wdt_device);
 	}
diff --git a/drivers/watchdog/booke_wdt.c b/drivers/watchdog/booke_wdt.c
index e423c96..4cd8e67 100644
--- a/drivers/watchdog/booke_wdt.c
+++ b/drivers/watchdog/booke_wdt.c
@@ -12,6 +12,8 @@
  * option) any later version.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/smp.h>
@@ -135,8 +137,8 @@ static int booke_wdt_open(struct inode *inode, struct file *file)
 	if (booke_wdt_enabled == 0) {
 		booke_wdt_enabled = 1;
 		on_each_cpu(__booke_wdt_enable, NULL, 0);
-		pr_info("PowerPC Book-E Watchdog Timer Enabled (wdt_period=%d)\n",
-				booke_wdt_period);
+		pr_info("Watchdog Timer Enabled (wdt_period=%d)\n",
+			booke_wdt_period);
 	}
 	spin_unlock(&booke_wdt_lock);
 
@@ -166,20 +168,20 @@ static int __init booke_wdt_init(void)
 {
 	int ret = 0;
 
-	pr_info("PowerPC Book-E Watchdog Timer Loaded\n");
+	pr_info("Watchdog Timer Loaded\n");
 	ident.firmware_version = cur_cpu_spec->pvr_value;
 
 	ret = misc_register(&booke_wdt_miscdev);
 	if (ret) {
 		pr_crit("Cannot register miscdev on minor=%d: %d\n",
-				WATCHDOG_MINOR, ret);
+			WATCHDOG_MINOR, ret);
 		return ret;
 	}
 
 	spin_lock(&booke_wdt_lock);
 	if (booke_wdt_enabled == 1) {
-		pr_info("PowerPC Book-E Watchdog Timer Enabled (wdt_period=%d)\n",
-				booke_wdt_period);
+		pr_info("Watchdog Timer Enabled (wdt_period=%d)\n",
+			booke_wdt_period);
 		on_each_cpu(__booke_wdt_enable, NULL, 0);
 	}
 	spin_unlock(&booke_wdt_lock);
diff --git a/drivers/watchdog/cpu5wdt.c b/drivers/watchdog/cpu5wdt.c
index ff3647e..2f8fddb 100644
--- a/drivers/watchdog/cpu5wdt.c
+++ b/drivers/watchdog/cpu5wdt.c
@@ -19,6 +19,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -129,7 +131,7 @@ static int cpu5wdt_stop(void)
 	ticks = cpu5wdt_device.default_ticks;
 	spin_unlock_irqrestore(&cpu5wdt_lock, flags);
 	if (verbose)
-		pr_crit(PFX "stop not possible\n");
+		pr_crit("stop not possible\n");
 	return -EIO;
 }
 
@@ -220,7 +222,7 @@ static int __devinit cpu5wdt_init(void)
 
 	if (verbose)
 		printk(KERN_DEBUG PFX
-				"port=0x%x, verbose=%i\n", port, verbose);
+		       "port=0x%x, verbose=%i\n", port, verbose);
 
 	init_completion(&cpu5wdt_device.stop);
 	spin_lock_init(&cpu5wdt_lock);
@@ -229,7 +231,7 @@ static int __devinit cpu5wdt_init(void)
 	cpu5wdt_device.default_ticks = ticks;
 
 	if (!request_region(port, CPU5WDT_EXTENT, PFX)) {
-		pr_err(PFX "request_region failed\n");
+		pr_err("request_region failed\n");
 		err = -EBUSY;
 		goto no_port;
 	}
@@ -238,16 +240,16 @@ static int __devinit cpu5wdt_init(void)
 	val = inb(port + CPU5WDT_STATUS_REG);
 	val = (val >> 2) & 1;
 	if (!val)
-		pr_info(PFX "sorry, was my fault\n");
+		pr_info("sorry, was my fault\n");
 
 	err = misc_register(&cpu5wdt_misc);
 	if (err < 0) {
-		pr_err(PFX "misc_register failed\n");
+		pr_err("misc_register failed\n");
 		goto no_misc;
 	}
 
 
-	pr_info(PFX "init success\n");
+	pr_info("init success\n");
 	return 0;
 
 no_misc:
diff --git a/drivers/watchdog/cpwd.c b/drivers/watchdog/cpwd.c
index 5dc9ba8..93d38e4 100644
--- a/drivers/watchdog/cpwd.c
+++ b/drivers/watchdog/cpwd.c
@@ -14,6 +14,8 @@
  * Copyright (C) 2008 David S. Miller <davem@davemloft.net>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/fs.h>
@@ -34,7 +36,6 @@
 #include <asm/watchdog.h>
 
 #define DRIVER_NAME	"cpwd"
-#define PFX		DRIVER_NAME ": "
 
 #define WD_OBPNAME	"watchdog"
 #define WD_BADMODEL	"SUNW,501-5336"
@@ -383,8 +384,7 @@ static int cpwd_open(struct inode *inode, struct file *f)
 	if (!p->initialized) {
 		if (request_irq(p->irq, &cpwd_interrupt,
 				IRQF_SHARED, DRIVER_NAME, p)) {
-			pr_err(PFX "Cannot register IRQ %d\n",
-				p->irq);
+			pr_err("Cannot register IRQ %d\n", p->irq);
 			unlock_kernel();
 			return -EBUSY;
 		}
@@ -540,7 +540,7 @@ static int __devinit cpwd_probe(struct of_device *op,
 	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	err = -ENOMEM;
 	if (!p) {
-		pr_err(PFX "Unable to allocate struct cpwd.\n");
+		pr_err("Unable to allocate struct cpwd.\n");
 		goto out;
 	}
 
@@ -551,14 +551,14 @@ static int __devinit cpwd_probe(struct of_device *op,
 	p->regs = of_ioremap(&op->resource[0], 0,
 			     4 * WD_TIMER_REGSZ, DRIVER_NAME);
 	if (!p->regs) {
-		pr_err(PFX "Unable to map registers.\n");
+		pr_err("Unable to map registers.\n");
 		goto out_free;
 	}
 
 	options = of_find_node_by_path("/options");
 	err = -ENODEV;
 	if (!options) {
-		pr_err(PFX "Unable to find /options node.\n");
+		pr_err("Unable to find /options node.\n");
 		goto out_iounmap;
 	}
 
@@ -603,8 +603,8 @@ static int __devinit cpwd_probe(struct of_device *op,
 
 		err = misc_register(&p->devs[i].misc);
 		if (err) {
-			pr_err("Could not register misc device for "
-			       "dev %d\n", i);
+			pr_err("Could not register misc device for dev %d\n",
+			       i);
 			goto out_unregister;
 		}
 	}
@@ -615,8 +615,8 @@ static int __devinit cpwd_probe(struct of_device *op,
 		cpwd_timer.data		= (unsigned long) p;
 		cpwd_timer.expires	= WD_BTIMEOUT;
 
-		pr_info(PFX "PLD defect workaround enabled for "
-		       "model " WD_BADMODEL ".\n");
+		pr_info("PLD defect workaround enabled for model " WD_BADMODEL
+			".\n");
 	}
 
 	dev_set_drvdata(&op->dev, p);
diff --git a/drivers/watchdog/ep93xx_wdt.c b/drivers/watchdog/ep93xx_wdt.c
index f1a9b04..2c41400 100644
--- a/drivers/watchdog/ep93xx_wdt.c
+++ b/drivers/watchdog/ep93xx_wdt.c
@@ -23,6 +23,8 @@
  *	- Add a few missing ioctls
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/miscdevice.h>
@@ -33,7 +35,6 @@
 #include <mach/hardware.h>
 
 #define WDT_VERSION	"0.3"
-#define PFX		"ep93xx_wdt: "
 
 /* default timeout (secs) */
 #define WDT_TIMEOUT 30
@@ -173,8 +174,7 @@ static int ep93xx_wdt_release(struct inode *inode, struct file *file)
 	if (test_bit(WDT_OK_TO_CLOSE, &wdt_status))
 		wdt_shutdown();
 	else
-		pr_crit(PFX
-			"Device closed unexpectedly - timer will not stop\n");
+		pr_crit("Device closed unexpectedly - timer will not stop\n");
 
 	clear_bit(WDT_IN_USE, &wdt_status);
 	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
@@ -213,15 +213,13 @@ static int __init ep93xx_wdt_init(void)
 
 	boot_status = __raw_readl(EP93XX_WDT_WATCHDOG) & 0x01 ? 1 : 0;
 
-	pr_info(PFX "EP93XX watchdog, driver version "
-		WDT_VERSION "%s\n",
+	pr_info("EP93XX watchdog, driver version " WDT_VERSION "%s\n",
 		(__raw_readl(EP93XX_WDT_WATCHDOG) & 0x08)
 		? " (nCS1 disable detected)" : "");
 
 	if (timeout < 1 || timeout > 3600) {
 		timeout = WDT_TIMEOUT;
-		pr_info(PFX
-			"timeout value must be 1<=x<=3600, using %d\n",
+		pr_info("timeout value must be 1<=x<=3600, using %d\n",
 			timeout);
 	}
 
diff --git a/drivers/watchdog/eurotechwdt.c b/drivers/watchdog/eurotechwdt.c
index bcffe6c..b8bad38 100644
--- a/drivers/watchdog/eurotechwdt.c
+++ b/drivers/watchdog/eurotechwdt.c
@@ -45,6 +45,8 @@
  *	of the on-board SUPER I/O device SMSC FDC 37B782.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
@@ -145,11 +147,11 @@ static void eurwdt_activate_timer(void)
 
 	/* Setting interrupt line */
 	if (irq == 2 || irq > 15 || irq < 0) {
-		pr_err(": invalid irq number\n");
+		pr_err("invalid irq number\n");
 		irq = 0;	/* if invalid we disable interrupt */
 	}
 	if (irq == 0)
-		pr_info(": interrupt disabled\n");
+		pr_info("interrupt disabled\n");
 
 	eurwdt_write_reg(WDT_TIMER_CFG, irq << 4);
 
@@ -336,7 +338,7 @@ static int eurwdt_release(struct inode *inode, struct file *file)
 	if (eur_expect_close == 42)
 		eurwdt_disable_timer();
 	else {
-		pr_crit("eurwdt: Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		eurwdt_ping();
 	}
 	clear_bit(0, &eurwdt_is_open);
@@ -429,19 +431,19 @@ static int __init eurwdt_init(void)
 
 	ret = request_irq(irq, eurwdt_interrupt, IRQF_DISABLED, "eurwdt", NULL);
 	if (ret) {
-		pr_err("eurwdt: IRQ %d is not free.\n", irq);
+		pr_err("IRQ %d is not free.\n", irq);
 		goto out;
 	}
 
 	if (!request_region(io, 2, "eurwdt")) {
-		pr_err("eurwdt: IO %X is not free.\n", io);
+		pr_err("IO %X is not free.\n", io);
 		ret = -EBUSY;
 		goto outirq;
 	}
 
 	ret = register_reboot_notifier(&eurwdt_notifier);
 	if (ret) {
-		pr_err("eurwdt: can't register reboot notifier (err=%d)\n", ret);
+		pr_err("can't register reboot notifier (err=%d)\n", ret);
 		goto outreg;
 	}
 
@@ -449,7 +451,7 @@ static int __init eurwdt_init(void)
 
 	ret = misc_register(&eurwdt_miscdev);
 	if (ret) {
-		pr_err("eurwdt: can't misc_register on minor=%d\n",
+		pr_err("can't misc_register on minor=%d\n",
 		WATCHDOG_MINOR);
 		goto outreboot;
 	}
diff --git a/drivers/watchdog/gef_wdt.c b/drivers/watchdog/gef_wdt.c
index b1ce0df..fff507d 100644
--- a/drivers/watchdog/gef_wdt.c
+++ b/drivers/watchdog/gef_wdt.c
@@ -24,6 +24,8 @@
  * capabilities) a kernel-based watchdog.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/compiler.h>
 #include <linux/init.h>
@@ -109,7 +111,7 @@ static void gef_wdt_handler_enable(void)
 	if (gef_wdt_toggle_wdc(GEF_WDC_ENABLED_FALSE,
 				   GEF_WDC_ENABLE_SHIFT)) {
 		gef_wdt_service();
-		pr_notice("gef_wdt: watchdog activated\n");
+		pr_notice("watchdog activated\n");
 	}
 }
 
@@ -117,7 +119,7 @@ static void gef_wdt_handler_disable(void)
 {
 	if (gef_wdt_toggle_wdc(GEF_WDC_ENABLED_TRUE,
 				   GEF_WDC_ENABLE_SHIFT))
-		pr_notice("gef_wdt: watchdog deactivated\n");
+		pr_notice("watchdog deactivated\n");
 }
 
 static void gef_wdt_set_timeout(unsigned int timeout)
@@ -233,7 +235,7 @@ static int gef_wdt_release(struct inode *inode, struct file *file)
 	if (expect_close == 42)
 		gef_wdt_handler_disable();
 	else {
-		pr_crit("gef_wdt: unexpected close, not stopping timer!\n");
+		pr_crit("unexpected close, not stopping timer!\n");
 		gef_wdt_service();
 	}
 	expect_close = 0;
diff --git a/drivers/watchdog/geodewdt.c b/drivers/watchdog/geodewdt.c
index b1ebb9e..dbc157b 100644
--- a/drivers/watchdog/geodewdt.c
+++ b/drivers/watchdog/geodewdt.c
@@ -8,6 +8,7 @@
  * 2 of the License, or (at your option) any later version.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
@@ -220,7 +221,7 @@ static int __devinit geodewdt_probe(struct platform_device *dev)
 	timer = geode_mfgpt_alloc_timer(MFGPT_TIMER_ANY, MFGPT_DOMAIN_WORKING);
 
 	if (timer == -1) {
-		pr_err("geodewdt:  No timers were available\n");
+		pr_err("No timers were available\n");
 		return -ENODEV;
 	}
 
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 82fac35..3cec8c5 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -13,6 +13,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/device.h>
 #include <linux/fs.h>
 #include <linux/init.h>
@@ -223,8 +225,8 @@ static int __devinit cru_detect(unsigned long map_entry,
 	asminline_call(&cmn_regs, bios32_entrypoint);
 
 	if (cmn_regs.u1.ral != 0) {
-		pr_warning("hpwdt: Call succeeded but with an error: 0x%x\n",
-			cmn_regs.u1.ral);
+		pr_warning("Call succeeded but with an error: 0x%x\n",
+			   cmn_regs.u1.ral);
 	} else {
 		physical_bios_base = cmn_regs.u2.rebx;
 		physical_bios_offset = cmn_regs.u4.redx;
@@ -443,8 +445,8 @@ static int hpwdt_change_timer(int new_margin)
 {
 	/* Arbitrary, can't find the card's limits */
 	if (new_margin < 30 || new_margin > 600) {
-		pr_warning("hpwdt: New value passed in is invalid: %d seconds.\n",
-			new_margin);
+		pr_warning("New value passed in is invalid: %d seconds.\n",
+			   new_margin);
 		return -EINVAL;
 	}
 
@@ -476,8 +478,8 @@ static int hpwdt_pretimeout(struct notifier_block *nb, unsigned long ulReason,
 		die_nmi_called = 1;
 		spin_unlock_irqrestore(&rom_lock, rom_pl);
 		if (cmn_regs.u1.ral == 0) {
-			pr_warning("hpwdt: An NMI occurred, "
-				"but unable to determine source.\n");
+			pr_warning("An NMI occurred, "
+				   "but unable to determine source.\n");
 		} else {
 			if (allow_kdump)
 				hpwdt_stop();
@@ -510,7 +512,7 @@ static int hpwdt_release(struct inode *inode, struct file *file)
 	if (expect_release == 42) {
 		hpwdt_stop();
 	} else {
-		pr_crit("hpwdt: Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		hpwdt_ping();
 	}
 
@@ -737,7 +739,7 @@ static int __devinit hpwdt_init_one(struct pci_dev *dev,
 		goto error_misc_register;
 	}
 
-	pr_info("hp Watchdog Timer Driver: %s"
+	pr_info("Watchdog Timer Driver: %s"
 		", timer margin: %d seconds (nowayout=%d)"
 		", allow kernel dump: %s (default = 0/OFF)"
 		", priority: %s (default = 0/LAST).\n",
diff --git a/drivers/watchdog/i6300esb.c b/drivers/watchdog/i6300esb.c
index 26d6535..ed96339 100644
--- a/drivers/watchdog/i6300esb.c
+++ b/drivers/watchdog/i6300esb.c
@@ -27,6 +27,8 @@
  *      Includes, defines, variables, module parameters, ...
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
@@ -45,7 +47,6 @@
 #define ESB_VERSION "0.04"
 #define ESB_MODULE_NAME "i6300ESB timer"
 #define ESB_DRIVER_NAME ESB_MODULE_NAME ", v" ESB_VERSION
-#define PFX ESB_MODULE_NAME ": "
 
 /* PCI configuration registers */
 #define ESB_CONFIG_REG  0x60            /* Config register                   */
@@ -212,8 +213,7 @@ static int esb_release(struct inode *inode, struct file *file)
 	if (esb_expect_close == 42)
 		esb_timer_stop();
 	else {
-		pr_crit(PFX
-				"Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		esb_timer_keepalive();
 	}
 	clear_bit(0, &timer_alive);
@@ -361,19 +361,19 @@ static unsigned char __devinit esb_getdevice(void)
 		return 0;
 
 	if (pci_enable_device(esb_pci)) {
-		pr_err(PFX "failed to enable device\n");
+		pr_err("failed to enable device\n");
 		goto err_devput;
 	}
 
 	if (pci_request_region(esb_pci, 0, ESB_MODULE_NAME)) {
-		pr_err(PFX "failed to request region\n");
+		pr_err("failed to request region\n");
 		goto err_disable;
 	}
 
 	BASEADDR = pci_ioremap_bar(esb_pci, 0);
 	if (BASEADDR == NULL) {
 		/* Something's wrong here, BASEADDR has to be set */
-		pr_err(PFX "failed to get BASEADDR\n");
+		pr_err("failed to get BASEADDR\n");
 		goto err_release;
 	}
 
@@ -411,7 +411,7 @@ static void __devinit esb_initdevice(void)
 	/* Check that the WDT isn't already locked */
 	pci_read_config_byte(esb_pci, ESB_LOCK_REG, &val1);
 	if (val1 & ESB_WDT_LOCK)
-		pr_warning(PFX "nowayout already set\n");
+		pr_warning("nowayout already set\n");
 
 	/* Set the timer to watchdog mode and disable it for now */
 	pci_write_config_byte(esb_pci, ESB_LOCK_REG, 0x00);
@@ -442,9 +442,8 @@ static int __devinit esb_probe(struct platform_device *dev)
 	   if not reset to the default */
 	if (heartbeat < 0x1 || heartbeat > 2 * 0x03ff) {
 		heartbeat = WATCHDOG_HEARTBEAT;
-		pr_info(PFX
-			"heartbeat value must be 1<heartbeat<2046, using %d\n",
-								heartbeat);
+		pr_info("heartbeat value must be 1<heartbeat<2046, using %d\n",
+			heartbeat);
 	}
 
 	/* Initialize the watchdog and make sure it does not run */
@@ -453,14 +452,12 @@ static int __devinit esb_probe(struct platform_device *dev)
 	/* Register the watchdog so that userspace has access to it */
 	ret = misc_register(&esb_miscdev);
 	if (ret != 0) {
-		pr_err(PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-							WATCHDOG_MINOR, ret);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, ret);
 		goto err_unmap;
 	}
-	pr_info(PFX
-		"initialized (0x%p). heartbeat=%d sec (nowayout=%d)\n",
-						BASEADDR, heartbeat, nowayout);
+	pr_info("initialized (0x%p). heartbeat=%d sec (nowayout=%d)\n",
+		BASEADDR, heartbeat, nowayout);
 	return 0;
 
 err_unmap:
@@ -505,8 +502,7 @@ static int __init watchdog_init(void)
 {
 	int err;
 
-	pr_info(PFX "Intel 6300ESB WatchDog Timer Driver v%s\n",
-		ESB_VERSION);
+	pr_info("Intel 6300ESB WatchDog Timer Driver v%s\n", ESB_VERSION);
 
 	err = platform_driver_register(&esb_platform_driver);
 	if (err)
@@ -530,7 +526,7 @@ static void __exit watchdog_cleanup(void)
 {
 	platform_device_unregister(esb_platform_device);
 	platform_driver_unregister(&esb_platform_driver);
-	pr_info(PFX "Watchdog Module Unloaded.\n");
+	pr_info("Watchdog Module Unloaded.\n");
 }
 
 module_init(watchdog_init);
diff --git a/drivers/watchdog/iTCO_vendor_support.c b/drivers/watchdog/iTCO_vendor_support.c
index c54b872..9144af5 100644
--- a/drivers/watchdog/iTCO_vendor_support.c
+++ b/drivers/watchdog/iTCO_vendor_support.c
@@ -18,9 +18,8 @@
  */
 
 /* Module and version information */
-#define DRV_NAME	"iTCO_vendor_support"
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #define DRV_VERSION	"1.04"
-#define PFX		DRV_NAME ": "
 
 /* Includes */
 #include <linux/module.h>		/* For module specific items */
@@ -364,13 +363,13 @@ EXPORT_SYMBOL(iTCO_vendor_check_noreboot_on);
 
 static int __init iTCO_vendor_init_module(void)
 {
-	pr_info(PFX "vendor-support=%d\n", vendorsupport);
+	pr_info("vendor-support=%d\n", vendorsupport);
 	return 0;
 }
 
 static void __exit iTCO_vendor_exit_module(void)
 {
-	pr_info(PFX "Module Unloaded\n");
+	pr_info("Module Unloaded\n");
 }
 
 module_init(iTCO_vendor_init_module);
diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index 5b4df5f..a9e05ff 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -62,9 +62,9 @@
  */
 
 /* Module and version information */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #define DRV_NAME	"iTCO_wdt"
 #define DRV_VERSION	"1.05"
-#define PFX		DRV_NAME ": "
 
 /* Includes */
 #include <linux/module.h>		/* For module specific items */
@@ -348,8 +348,8 @@ static int iTCO_wdt_start(void)
 	/* disable chipset's NO_REBOOT bit */
 	if (iTCO_wdt_unset_NO_REBOOT_bit()) {
 		spin_unlock(&iTCO_wdt_private.io_lock);
-		pr_err(PFX "failed to reset NO_REBOOT flag, "
-					"reboot disabled by hardware\n");
+		pr_err("failed to reset NO_REBOOT flag, "
+		       "reboot disabled by hardware\n");
 		return -EIO;
 	}
 
@@ -508,8 +508,7 @@ static int iTCO_wdt_release(struct inode *inode, struct file *file)
 	if (expect_release == 42) {
 		iTCO_wdt_stop();
 	} else {
-		pr_crit(PFX
-			"Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		iTCO_wdt_keepalive();
 	}
 	clear_bit(0, &is_active);
@@ -651,7 +650,7 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 	base_address &= 0x0000ff80;
 	if (base_address == 0x00000000) {
 		/* Something's wrong here, ACPIBASE has to be set */
-		pr_err(PFX "failed to get TCOBASE address\n");
+		pr_err("failed to get TCOBASE address\n");
 		pci_dev_put(pdev);
 		return -ENODEV;
 	}
@@ -667,7 +666,7 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 	if (iTCO_wdt_private.iTCO_version == 2) {
 		pci_read_config_dword(pdev, 0xf0, &base_address);
 		if ((base_address & 1) == 0) {
-			pr_err(PFX "RCBA is disabled by harddware\n");
+			pr_err("RCBA is disabled by harddware\n");
 			ret = -ENODEV;
 			goto out;
 		}
@@ -677,8 +676,8 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 
 	/* Check chipset's NO_REBOOT bit */
 	if (iTCO_wdt_unset_NO_REBOOT_bit() && iTCO_vendor_check_noreboot_on()) {
-		pr_err(PFX "failed to reset NO_REBOOT flag, "
-					"reboot disabled by hardware\n");
+		pr_err("failed to reset NO_REBOOT flag, "
+		       "reboot disabled by hardware\n");
 		ret = -ENODEV;	/* Cannot reset NO_REBOOT bit */
 		goto out_unmap;
 	}
@@ -688,8 +687,7 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 
 	/* The TCO logic uses the TCO_EN bit in the SMI_EN register */
 	if (!request_region(SMI_EN, 4, "iTCO_wdt")) {
-		pr_err(PFX
-			"I/O address 0x%04lx already in use\n", SMI_EN);
+		pr_err("I/O address 0x%04lx already in use\n", SMI_EN);
 		ret = -EIO;
 		goto out_unmap;
 	}
@@ -701,17 +699,15 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 	/* The TCO I/O registers reside in a 32-byte range pointed to
 	   by the TCOBASE value */
 	if (!request_region(TCOBASE, 0x20, "iTCO_wdt")) {
-		pr_err(PFX "I/O address 0x%04lx already in use\n",
-			TCOBASE);
+		pr_err("I/O address 0x%04lx already in use\n", TCOBASE);
 		ret = -EIO;
 		goto unreg_smi_en;
 	}
 
-	pr_info(PFX
-		"Found a %s TCO device (Version=%d, TCOBASE=0x%04lx)\n",
-			iTCO_chipset_info[ent->driver_data].name,
-			iTCO_chipset_info[ent->driver_data].iTCO_version,
-			TCOBASE);
+	pr_info("Found a %s TCO device (Version=%d, TCOBASE=0x%04lx)\n",
+		iTCO_chipset_info[ent->driver_data].name,
+		iTCO_chipset_info[ent->driver_data].iTCO_version,
+		TCOBASE);
 
 	/* Clear out the (probably old) status */
 	outb(8, TCO1_STS);	/* Clear the Time Out Status bit */
@@ -725,21 +721,19 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 	   if not reset to the default */
 	if (iTCO_wdt_set_heartbeat(heartbeat)) {
 		iTCO_wdt_set_heartbeat(WATCHDOG_HEARTBEAT);
-		pr_info(PFX
-			"heartbeat value must be 2 < heartbeat < 39 (TCO v1) "
-				"or 613 (TCO v2), using %d\n", heartbeat);
+		pr_info("heartbeat value must be 2 < heartbeat < 39 (TCO v1) "
+			"or 613 (TCO v2), using %d\n", heartbeat);
 	}
 
 	ret = misc_register(&iTCO_wdt_miscdev);
 	if (ret != 0) {
-		pr_err(PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-							WATCHDOG_MINOR, ret);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, ret);
 		goto unreg_region;
 	}
 
-	pr_info(PFX "initialized. heartbeat=%d sec (nowayout=%d)\n",
-							heartbeat, nowayout);
+	pr_info("initialized. heartbeat=%d sec (nowayout=%d)\n",
+		heartbeat, nowayout);
 
 	return 0;
 
@@ -791,7 +785,7 @@ static int __devinit iTCO_wdt_probe(struct platform_device *dev)
 	}
 
 	if (!found) {
-		pr_info(PFX "No card detected\n");
+		pr_info("No card detected\n");
 		return -ENODEV;
 	}
 
@@ -830,7 +824,7 @@ static int __init iTCO_wdt_init_module(void)
 {
 	int err;
 
-	pr_info(PFX "Intel TCO WatchDog Timer Driver v%s\n",
+	pr_info("Intel TCO WatchDog Timer Driver v%s\n",
 		DRV_VERSION);
 
 	err = platform_driver_register(&iTCO_wdt_driver);
@@ -855,7 +849,7 @@ static void __exit iTCO_wdt_cleanup_module(void)
 {
 	platform_device_unregister(iTCO_wdt_platform_device);
 	platform_driver_unregister(&iTCO_wdt_driver);
-	pr_info(PFX "Watchdog Module Unloaded.\n");
+	pr_info("Watchdog Module Unloaded.\n");
 }
 
 module_init(iTCO_wdt_init_module);
diff --git a/drivers/watchdog/ib700wdt.c b/drivers/watchdog/ib700wdt.c
index bd374c7..86e537d 100644
--- a/drivers/watchdog/ib700wdt.c
+++ b/drivers/watchdog/ib700wdt.c
@@ -31,6 +31,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/miscdevice.h>
@@ -53,7 +55,6 @@ static char expect_close;
 
 /* Module information */
 #define DRV_NAME "ib700wdt"
-#define PFX DRV_NAME ": "
 
 /*
  *
@@ -246,8 +247,7 @@ static int ibwdt_close(struct inode *inode, struct file *file)
 	if (expect_close == 42) {
 		ibwdt_disable();
 	} else {
-		pr_crit(PFX
-		     "WDT device closed unexpectedly.  WDT will not stop!\n");
+		pr_crit("WDT device closed unexpectedly.  WDT will not stop!\n");
 		ibwdt_ping();
 	}
 	clear_bit(0, &ibwdt_is_open);
@@ -284,16 +284,14 @@ static int __devinit ibwdt_probe(struct platform_device *dev)
 
 #if WDT_START != WDT_STOP
 	if (!request_region(WDT_STOP, 1, "IB700 WDT")) {
-		pr_err(PFX "STOP method I/O %X is not available.\n",
-								WDT_STOP);
+		pr_err("STOP method I/O %X is not available.\n", WDT_STOP);
 		res = -EIO;
 		goto out_nostopreg;
 	}
 #endif
 
 	if (!request_region(WDT_START, 1, "IB700 WDT")) {
-		pr_err(PFX "START method I/O %X is not available.\n",
-								WDT_START);
+		pr_err("START method I/O %X is not available.\n", WDT_START);
 		res = -EIO;
 		goto out_nostartreg;
 	}
@@ -302,13 +300,12 @@ static int __devinit ibwdt_probe(struct platform_device *dev)
 	 * if not reset to the default */
 	if (ibwdt_set_heartbeat(timeout)) {
 		ibwdt_set_heartbeat(WATCHDOG_TIMEOUT);
-		pr_info(PFX
-			"timeout value must be 0<=x<=30, using %d\n", timeout);
+		pr_info("timeout value must be 0<=x<=30, using %d\n", timeout);
 	}
 
 	res = misc_register(&ibwdt_miscdev);
 	if (res) {
-		pr_err(PFX "failed to register misc device\n");
+		pr_err("failed to register misc device\n");
 		goto out_nomisc;
 	}
 	return 0;
@@ -353,8 +350,7 @@ static int __init ibwdt_init(void)
 {
 	int err;
 
-	pr_info(PFX
-		"WDT driver for IB700 single board computer initialising.\n");
+	pr_info("WDT driver for IB700 single board computer initialising.\n");
 
 	err = platform_driver_register(&ibwdt_driver);
 	if (err)
@@ -378,7 +374,7 @@ static void __exit ibwdt_exit(void)
 {
 	platform_device_unregister(ibwdt_platform_device);
 	platform_driver_unregister(&ibwdt_driver);
-	pr_info(PFX "Watchdog Module Unloaded.\n");
+	pr_info("Watchdog Module Unloaded.\n");
 }
 
 module_init(ibwdt_init);
diff --git a/drivers/watchdog/ibmasr.c b/drivers/watchdog/ibmasr.c
index a4a8bef..2b6da29 100644
--- a/drivers/watchdog/ibmasr.c
+++ b/drivers/watchdog/ibmasr.c
@@ -10,6 +10,8 @@
  * of the GNU Public License, incorporated herein by reference.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/fs.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
@@ -32,8 +34,6 @@ enum {
 	ASMTYPE_SPRUCE,
 };
 
-#define PFX "ibmasr: "
-
 #define TOPAZ_ASR_REG_OFFSET	4
 #define TOPAZ_ASR_TOGGLE	0x40
 #define TOPAZ_ASR_DISABLE	0x80
@@ -235,12 +235,11 @@ static int __init asr_get_base_address(void)
 	}
 
 	if (!request_region(asr_base, asr_length, "ibmasr")) {
-		pr_err(PFX "address %#x already in use\n",
-			asr_base);
+		pr_err("address %#x already in use\n", asr_base);
 		return -EBUSY;
 	}
 
-	pr_info(PFX "found %sASR @ addr %#x\n", type, asr_base);
+	pr_info("found %sASR @ addr %#x\n", type, asr_base);
 
 	return 0;
 }
@@ -333,8 +332,7 @@ static int asr_release(struct inode *inode, struct file *file)
 	if (asr_expect_close == 42)
 		asr_disable();
 	else {
-		pr_crit(PFX
-				"unexpected close, not stopping watchdog!\n");
+		pr_crit("unexpected close, not stopping watchdog!\n");
 		asr_toggle();
 	}
 	clear_bit(0, &asr_is_open);
@@ -396,7 +394,7 @@ static int __init ibmasr_init(void)
 	rc = misc_register(&asr_miscdev);
 	if (rc < 0) {
 		release_region(asr_base, asr_length);
-		pr_err(PFX "failed to register misc device\n");
+		pr_err("failed to register misc device\n");
 		return rc;
 	}
 
diff --git a/drivers/watchdog/indydog.c b/drivers/watchdog/indydog.c
index 570baa0..e90683d 100644
--- a/drivers/watchdog/indydog.c
+++ b/drivers/watchdog/indydog.c
@@ -12,6 +12,8 @@
  *	based on softdog.c by Alan Cox <alan@lxorguk.ukuu.org.uk>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -60,7 +62,7 @@ static void indydog_stop(void)
 	sgimc->cpuctrl0 = mc_ctrl0;
 	spin_unlock(&indydog_lock);
 
-	pr_info(PFX "Stopped watchdog timer.\n");
+	pr_info("Stopped watchdog timer.\n");
 }
 
 static void indydog_ping(void)
@@ -178,9 +180,6 @@ static struct notifier_block indydog_notifier = {
 	.notifier_call = indydog_notify_sys,
 };
 
-static char banner[] __initdata =
-	KERN_INFO PFX "Hardware Watchdog Timer for SGI IP22: 0.3\n";
-
 static int __init watchdog_init(void)
 {
 	int ret;
@@ -189,21 +188,23 @@ static int __init watchdog_init(void)
 
 	ret = register_reboot_notifier(&indydog_notifier);
 	if (ret) {
-		pr_err(PFX
-			"cannot register reboot notifier (err=%d)\n", ret);
+		pr_err_section(__initdata,
+			       "cannot register reboot notifier (err=%d)\n",
+			       ret);
 		return ret;
 	}
 
 	ret = misc_register(&indydog_miscdev);
 	if (ret) {
-		pr_err(PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-							WATCHDOG_MINOR, ret);
+		pr_err_section(__initdata,
+			       "cannot register miscdev on minor=%d (err=%d)\n",
+			       WATCHDOG_MINOR, ret);
 		unregister_reboot_notifier(&indydog_notifier);
 		return ret;
 	}
 
-	printk(banner);
+	pr_info_section(__initdata,
+			"Hardware Watchdog Timer for SGI IP22: 0.3\n");
 
 	return 0;
 }
diff --git a/drivers/watchdog/iop_wdt.c b/drivers/watchdog/iop_wdt.c
index dedc5c0..12a2621 100644
--- a/drivers/watchdog/iop_wdt.c
+++ b/drivers/watchdog/iop_wdt.c
@@ -24,6 +24,8 @@
  *	Dan Williams <dan.j.williams@intel.com>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/fs.h>
@@ -85,7 +87,7 @@ static int wdt_disable(void)
 		write_wdtcr(IOP_WDTCR_DIS);
 		clear_bit(WDT_ENABLED, &wdt_status);
 		spin_unlock(&wdt_lock);
-		pr_info("WATCHDOG: Disabled\n");
+		pr_info("Disabled\n");
 		return 0;
 	} else
 		return 1;
@@ -197,8 +199,8 @@ static int iop_wdt_release(struct inode *inode, struct file *file)
 	 */
 	if (state != 0) {
 		wdt_enable();
-		pr_crit("WATCHDOG: Device closed unexpectedly - "
-		       "reset in %lu seconds\n", iop_watchdog_timeout());
+		pr_crit("Device closed unexpectedly - reset in %lu seconds\n",
+			iop_watchdog_timeout());
 	}
 
 	clear_bit(WDT_IN_USE, &wdt_status);
@@ -241,8 +243,7 @@ static int __init iop_wdt_init(void)
 	   with an open */
 	ret = misc_register(&iop_wdt_miscdev);
 	if (ret == 0)
-		pr_info("iop watchdog timer: timeout %lu sec\n",
-		       iop_watchdog_timeout());
+		pr_info("timeout %lu sec\n", iop_watchdog_timeout());
 
 	return ret;
 }
diff --git a/drivers/watchdog/it8712f_wdt.c b/drivers/watchdog/it8712f_wdt.c
index c1846e8..a1f6847 100644
--- a/drivers/watchdog/it8712f_wdt.c
+++ b/drivers/watchdog/it8712f_wdt.c
@@ -20,6 +20,8 @@
  *	software is provided AS-IS with no warranties.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/init.h>
@@ -144,10 +146,10 @@ static void it8712f_wdt_update_margin(void)
 	 */
 	if (units <= max_units) {
 		config |= WDT_UNIT_SEC; /* else UNIT is MINUTES */
-		pr_info(NAME ": timer margin %d seconds\n", units);
+		pr_info("timer margin %d seconds\n", units);
 	} else {
 		units /= 60;
-		pr_info(NAME ": timer margin %d minutes\n", units);
+		pr_info("timer margin %d minutes\n", units);
 	}
 	superio_outb(config, WDT_CONFIG);
 
@@ -300,9 +302,8 @@ static int it8712f_wdt_open(struct inode *inode, struct file *file)
 static int it8712f_wdt_release(struct inode *inode, struct file *file)
 {
 	if (expect_close != 42) {
-		pr_warning(NAME
-			": watchdog device closed unexpectedly, will not"
-			" disable the watchdog timer\n");
+		pr_warning("watchdog device closed unexpectedly, "
+			   "will not disable the watchdog timer\n");
 	} else if (!nowayout) {
 		it8712f_wdt_disable();
 	}
@@ -340,13 +341,13 @@ static int __init it8712f_wdt_find(unsigned short *address)
 	superio_select(LDN_GAME);
 	superio_outb(1, ACT_REG);
 	if (!(superio_inb(ACT_REG) & 0x01)) {
-		pr_err(NAME ": Device not activated, skipping\n");
+		pr_err("Device not activated, skipping\n");
 		goto exit;
 	}
 
 	*address = superio_inw(BASE_REG);
 	if (*address == 0) {
-		pr_err(NAME ": Base address not set, skipping\n");
+		pr_err("Base address not set, skipping\n");
 		goto exit;
 	}
 
@@ -360,7 +361,7 @@ static int __init it8712f_wdt_find(unsigned short *address)
 	if (margin > (max_units * 60))
 		margin = (max_units * 60);
 
-	pr_info(NAME ": Found IT%04xF chip revision %d - "
+	pr_info("Found IT%04xF chip revision %d - "
 		"using DogFood address 0x%x\n",
 		chip_type, revision, *address);
 
@@ -379,7 +380,7 @@ static int __init it8712f_wdt_init(void)
 		return -ENODEV;
 
 	if (!request_region(address, 1, "IT8712F Watchdog")) {
-		pr_warning(NAME ": watchdog I/O region busy\n");
+		pr_warning("watchdog I/O region busy\n");
 		return -EBUSY;
 	}
 
@@ -387,15 +388,14 @@ static int __init it8712f_wdt_init(void)
 
 	err = register_reboot_notifier(&it8712f_wdt_notifier);
 	if (err) {
-		pr_err(NAME ": unable to register reboot notifier\n");
+		pr_err("unable to register reboot notifier\n");
 		goto out;
 	}
 
 	err = misc_register(&it8712f_wdt_miscdev);
 	if (err) {
-		pr_err(NAME
-			": cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, err);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, err);
 		goto reboot_out;
 	}
 
diff --git a/drivers/watchdog/it87_wdt.c b/drivers/watchdog/it87_wdt.c
index 57dbcb4..741f9f8 100644
--- a/drivers/watchdog/it87_wdt.c
+++ b/drivers/watchdog/it87_wdt.c
@@ -29,6 +29,8 @@
  *	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -47,7 +49,6 @@
 
 #define WATCHDOG_VERSION	"1.12"
 #define WATCHDOG_NAME		"IT87 WDT"
-#define PFX			WATCHDOG_NAME ": "
 #define DRIVER_VERSION		WATCHDOG_NAME " driver, v" WATCHDOG_VERSION "\n"
 #define WD_MAGIC		'V'
 
@@ -378,8 +379,7 @@ static int wdt_release(struct inode *inode, struct file *file)
 			clear_bit(WDTS_TIMER_RUN, &wdt_status);
 		} else {
 			wdt_keepalive();
-			pr_crit(PFX
-			       "unexpected close, not stopping watchdog!\n");
+			pr_crit("unexpected close, not stopping watchdog!\n");
 		}
 	}
 	clear_bit(WDTS_DEV_OPEN, &wdt_status);
@@ -549,16 +549,14 @@ static int __init it87_wdt_init(void)
 		if (chip_rev > 7)
 			break;
 	case IT8705_ID:
-		pr_err(PFX
-		       "Unsupported Chip found, Chip %04x Revision %02x\n",
+		pr_err("Unsupported Chip found, Chip %04x Revision %02x\n",
 		       chip_type, chip_rev);
 		return -ENODEV;
 	case NO_DEV_ID:
-		pr_err(PFX "no device\n");
+		pr_err("no device\n");
 		return -ENODEV;
 	default:
-		pr_err(PFX
-		       "Unknown Chip found, Chip %04x Revision %04x\n",
+		pr_err("Unknown Chip found, Chip %04x Revision %04x\n",
 		       chip_type, chip_rev);
 		return -ENODEV;
 	}
@@ -595,13 +593,11 @@ static int __init it87_wdt_init(void)
 	if (!test_bit(WDTS_USE_GP, &wdt_status)) {
 		if (!request_region(CIR_BASE, 8, WATCHDOG_NAME)) {
 			if (rc == -EIO)
-				pr_err(PFX
-					"I/O Address 0x%04x and 0x%04x"
-					" already in use\n", base, CIR_BASE);
+				pr_err("I/O Address 0x%04x and 0x%04x"
+				       " already in use\n", base, CIR_BASE);
 			else
-				pr_err(PFX
-					"I/O Address 0x%04x already in use\n",
-					CIR_BASE);
+				pr_err("I/O Address 0x%04x already in use\n",
+				       CIR_BASE);
 			rc = -EIO;
 			goto err_out;
 		}
@@ -625,23 +621,20 @@ static int __init it87_wdt_init(void)
 
 	if (timeout < 1 || timeout > 65535) {
 		timeout = DEFAULT_TIMEOUT;
-		pr_warning(PFX
-		       "Timeout value out of range, use default %d sec\n",
-		       DEFAULT_TIMEOUT);
+		pr_warning("Timeout value out of range, use default %d sec\n",
+			   DEFAULT_TIMEOUT);
 	}
 
 	rc = register_reboot_notifier(&wdt_notifier);
 	if (rc) {
-		pr_err(PFX
-		       "Cannot register reboot notifier (err=%d)\n", rc);
+		pr_err("Cannot register reboot notifier (err=%d)\n", rc);
 		goto err_out_region;
 	}
 
 	rc = misc_register(&wdt_miscdev);
 	if (rc) {
-		pr_err(PFX
-		       "Cannot register miscdev on minor=%d (err=%d)\n",
-			wdt_miscdev.minor, rc);
+		pr_err("Cannot register miscdev on minor=%d (err=%d)\n",
+		       wdt_miscdev.minor, rc);
 		goto err_out_reboot;
 	}
 
@@ -656,7 +649,7 @@ static int __init it87_wdt_init(void)
 		outb(0x09, CIR_IER(base));
 	}
 
-	pr_info(PFX "Chip it%04x revision %d initialized. "
+	pr_info("Chip it%04x revision %d initialized. "
 		"timeout=%d sec (nowayout=%d testmode=%d exclusive=%d "
 		"nogameport=%d)\n", chip_type, chip_rev, timeout,
 		nowayout, testmode, exclusive, nogameport);
diff --git a/drivers/watchdog/ixp2000_wdt.c b/drivers/watchdog/ixp2000_wdt.c
index 136fd18..75da796 100644
--- a/drivers/watchdog/ixp2000_wdt.c
+++ b/drivers/watchdog/ixp2000_wdt.c
@@ -16,6 +16,8 @@
  * warranty of any kind, whether express or implied.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -157,8 +159,7 @@ static int ixp2000_wdt_release(struct inode *inode, struct file *file)
 	if (test_bit(WDT_OK_TO_CLOSE, &wdt_status))
 		wdt_disable();
 	else
-		pr_crit("WATCHDOG: Device closed unexpectedly - "
-					"timer will not stop\n");
+		pr_crit("Device closed unexpectedly - timer will not stop\n");
 	clear_bit(WDT_IN_USE, &wdt_status);
 	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
 
diff --git a/drivers/watchdog/ixp4xx_wdt.c b/drivers/watchdog/ixp4xx_wdt.c
index 83cc249..02a5c75 100644
--- a/drivers/watchdog/ixp4xx_wdt.c
+++ b/drivers/watchdog/ixp4xx_wdt.c
@@ -13,6 +13,8 @@
  * warranty of any kind, whether express or implied.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -147,8 +149,7 @@ static int ixp4xx_wdt_release(struct inode *inode, struct file *file)
 	if (test_bit(WDT_OK_TO_CLOSE, &wdt_status))
 		wdt_disable();
 	else
-		pr_crit("WATCHDOG: Device closed unexpectedly - "
-					"timer will not stop\n");
+		pr_crit("Device closed unexpectedly - timer will not stop\n");
 	clear_bit(WDT_IN_USE, &wdt_status);
 	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
 
@@ -176,9 +177,7 @@ static int __init ixp4xx_wdt_init(void)
 	int ret;
 
 	if (!(read_cpuid_id() & 0xf) && !cpu_is_ixp46x()) {
-		pr_err("IXP4XXX Watchdog: Rev. A0 IXP42x CPU detected"
-			" - watchdog disabled\n");
-
+		pr_err("Rev. A0 IXP42x CPU detected - watchdog disabled\n");
 		return -ENODEV;
 	}
 	spin_lock_init(&wdt_lock);
@@ -186,8 +185,7 @@ static int __init ixp4xx_wdt_init(void)
 			WDIOF_CARDRESET : 0;
 	ret = misc_register(&ixp4xx_wdt_miscdev);
 	if (ret == 0)
-		pr_info("IXP4xx Watchdog Timer: heartbeat %d sec\n",
-			heartbeat);
+		pr_info("heartbeat %d sec\n", heartbeat);
 	return ret;
 }
 
diff --git a/drivers/watchdog/ks8695_wdt.c b/drivers/watchdog/ks8695_wdt.c
index a956500..7fc6349 100644
--- a/drivers/watchdog/ks8695_wdt.c
+++ b/drivers/watchdog/ks8695_wdt.c
@@ -8,6 +8,8 @@
  * published by the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/bitops.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
@@ -233,8 +235,8 @@ static int __devinit ks8695wdt_probe(struct platform_device *pdev)
 	if (res)
 		return res;
 
-	pr_info("KS8695 Watchdog Timer enabled (%d seconds%s)\n",
-				wdt_time, nowayout ? ", nowayout" : "");
+	pr_info("enabled (%d seconds%s)\n",
+		wdt_time, nowayout ? ", nowayout" : "");
 	return 0;
 }
 
@@ -293,8 +295,8 @@ static int __init ks8695_wdt_init(void)
 	   if not reset to the default */
 	if (ks8695_wdt_settimeout(wdt_time)) {
 		ks8695_wdt_settimeout(WDT_DEFAULT_TIME);
-		pr_info("ks8695_wdt: wdt_time value must be 1 <= wdt_time <= %i"
-					", using %d\n", wdt_time, WDT_MAX_TIME);
+		pr_info("wdt_time value must be 1 <= wdt_time <= %i, "
+			"using %d\n", wdt_time, WDT_MAX_TIME);
 	}
 	return platform_driver_register(&ks8695wdt_driver);
 }
diff --git a/drivers/watchdog/machzwd.c b/drivers/watchdog/machzwd.c
index 4c39d24..899d1ee 100644
--- a/drivers/watchdog/machzwd.c
+++ b/drivers/watchdog/machzwd.c
@@ -28,6 +28,8 @@
  *      Added nowayout module option to override CONFIG_WATCHDOG_NOWAYOUT
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -99,8 +101,6 @@ MODULE_PARM_DESC(nowayout,
 		"Watchdog cannot be stopped once started (default="
 				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
-#define PFX "machzwd"
-
 static struct watchdog_info zf_info = {
 	.options		= WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
 	.firmware_version	= 1,
@@ -143,7 +143,7 @@ static unsigned long next_heartbeat;
 #ifndef ZF_DEBUG
 #	define dprintk(format, args...)
 #else
-#	define dprintk(format, args...) printk(KERN_DEBUG PFX
+#	define dprintk(format, args...) printk(KERN_DEBUG KBUILD_MODNAME
 				":%s:%d: " format, __func__, __LINE__ , ## args)
 #endif
 
@@ -203,7 +203,7 @@ static void zf_timer_off(void)
 	zf_set_control(ctrl_reg);
 	spin_unlock_irqrestore(&zf_port_lock, flags);
 
-	pr_info(PFX ": Watchdog timer is now disabled\n");
+	pr_info("Watchdog timer is now disabled\n");
 }
 
 
@@ -233,7 +233,7 @@ static void zf_timer_on(void)
 	zf_set_control(ctrl_reg);
 	spin_unlock_irqrestore(&zf_port_lock, flags);
 
-	pr_info(PFX ": Watchdog timer is now enabled\n");
+	pr_info("Watchdog timer is now enabled\n");
 }
 
 
@@ -263,7 +263,7 @@ static void zf_ping(unsigned long data)
 
 		mod_timer(&zf_timer, jiffies + ZF_HW_TIMEO);
 	} else
-		pr_crit(PFX ": I will reset your machine\n");
+		pr_crit("I will reset your machine\n");
 }
 
 static ssize_t zf_write(struct file *file, const char __user *buf, size_t count,
@@ -342,8 +342,8 @@ static int zf_close(struct inode *inode, struct file *file)
 		zf_timer_off();
 	else {
 		del_timer(&zf_timer);
-		pr_err(PFX ": device file closed unexpectedly. "
-						"Will not stop the WDT!\n");
+		pr_err("device file closed unexpectedly. "
+		       "Will not stop the WDT!\n");
 	}
 	clear_bit(0, &zf_is_open);
 	zf_expect_close = 0;
@@ -390,19 +390,19 @@ static void __init zf_show_action(int act)
 {
 	char *str[] = { "RESET", "SMI", "NMI", "SCI" };
 
-	pr_info(PFX ": Watchdog using action = %s\n", str[act]);
+	pr_info("Watchdog using action = %s\n",
+		(act >= 0 && act < ARRAY_SIZE(str)) ? str[act] : "unknown");
 }
 
 static int __init zf_init(void)
 {
 	int ret;
 
-	pr_info(PFX
-		": MachZ ZF-Logic Watchdog driver initializing.\n");
+	pr_info("MachZ ZF-Logic Watchdog driver initializing.\n");
 
 	ret = zf_get_ZFL_version();
 	if (!ret || ret == 0xffff) {
-		pr_warning(PFX ": no ZF-Logic found\n");
+		pr_warning("no ZF-Logic found\n");
 		return -ENODEV;
 	}
 
@@ -414,23 +414,20 @@ static int __init zf_init(void)
 	zf_show_action(action);
 
 	if (!request_region(ZF_IOBASE, 3, "MachZ ZFL WDT")) {
-		pr_err("cannot reserve I/O ports at %d\n",
-							ZF_IOBASE);
+		pr_err("cannot reserve I/O ports at %d\n", ZF_IOBASE);
 		ret = -EBUSY;
 		goto no_region;
 	}
 
 	ret = register_reboot_notifier(&zf_notifier);
 	if (ret) {
-		pr_err("can't register reboot notifier (err=%d)\n",
-									ret);
+		pr_err("can't register reboot notifier (err=%d)\n", ret);
 		goto no_reboot;
 	}
 
 	ret = misc_register(&zf_miscdev);
 	if (ret) {
-		pr_err("can't misc_register on minor=%d\n",
-							WATCHDOG_MINOR);
+		pr_err("can't misc_register on minor=%d\n", WATCHDOG_MINOR);
 		goto no_misc;
 	}
 
diff --git a/drivers/watchdog/mixcomwd.c b/drivers/watchdog/mixcomwd.c
index 1f5d04c..c2d5cb9 100644
--- a/drivers/watchdog/mixcomwd.c
+++ b/drivers/watchdog/mixcomwd.c
@@ -39,9 +39,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #define VERSION "0.6"
-#define WATCHDOG_NAME "mixcomwd"
-#define PFX WATCHDOG_NAME ": "
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
@@ -156,15 +155,13 @@ static int mixcomwd_release(struct inode *inode, struct file *file)
 {
 	if (expect_close == 42) {
 		if (mixcomwd_timer_alive) {
-			pr_err(PFX
-				"release called while internal timer alive");
+			pr_err("release called while internal timer alive");
 			return -EBUSY;
 		}
 		mixcomwd_timer_alive = 1;
 		mod_timer(&mixcomwd_timer, jiffies + 5 * HZ);
 	} else
-		pr_crit(PFX
-		    "WDT device closed unexpectedly.  WDT will not stop!\n");
+		pr_crit("WDT device closed unexpectedly.  WDT will not stop!\n");
 
 	clear_bit(0, &mixcomwd_opened);
 	expect_close = 0;
@@ -274,21 +271,19 @@ static int __init mixcomwd_init(void)
 	}
 
 	if (!found) {
-		pr_err(PFX
-			"No card detected, or port not available.\n");
+		pr_err("No card detected, or port not available.\n");
 		return -ENODEV;
 	}
 
 	ret = misc_register(&mixcomwd_miscdev);
 	if (ret) {
-		pr_err(PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-					WATCHDOG_MINOR, ret);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, ret);
 		goto error_misc_register_watchdog;
 	}
 
 	pr_info("MixCOM watchdog driver v%s, watchdog port at 0x%3x\n",
-					VERSION, watchdog_port);
+		VERSION, watchdog_port);
 
 	return 0;
 
@@ -302,8 +297,7 @@ static void __exit mixcomwd_exit(void)
 {
 	if (!nowayout) {
 		if (mixcomwd_timer_alive) {
-			pr_warning(PFX "I quit now, hardware will"
-			       " probably reboot!\n");
+			pr_warning("quitting, hardware will likely reboot!\n");
 			del_timer_sync(&mixcomwd_timer);
 			mixcomwd_timer_alive = 0;
 		}
diff --git a/drivers/watchdog/mpcore_wdt.c b/drivers/watchdog/mpcore_wdt.c
index b523694..56854b3 100644
--- a/drivers/watchdog/mpcore_wdt.c
+++ b/drivers/watchdog/mpcore_wdt.c
@@ -19,6 +19,9 @@
  *	(c) Copyright 1995    Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -418,9 +421,6 @@ static struct platform_driver mpcore_wdt_driver = {
 	},
 };
 
-static char banner[] __initdata = KERN_INFO "MPcore Watchdog Timer: 0.1. "
-		"mpcore_noboot=%d mpcore_margin=%d sec (nowayout= %d)\n";
-
 static int __init mpcore_wdt_init(void)
 {
 	/*
@@ -429,11 +429,15 @@ static int __init mpcore_wdt_init(void)
 	 */
 	if (mpcore_wdt_set_heartbeat(mpcore_margin)) {
 		mpcore_wdt_set_heartbeat(TIMER_MARGIN);
-		pr_info("mpcore_margin value must be 0 < mpcore_margin < 65536, using %d\n",
-			TIMER_MARGIN);
+		pr_info_section(__initdata,
+	"mpcore_margin value must be 0 < mpcore_margin < 65536, using %d\n",
+				TIMER_MARGIN);
 	}
 
-	printk(banner, mpcore_noboot, mpcore_margin, nowayout);
+	pr_info_section(__initdata,
+			"MPcore Watchdog Timer: 0.1. mpcore_noboot=%d "
+			"mpcore_margin=%d sec (nowayout= %d)\n",
+			mpcore_noboot, mpcore_margin, nowayout);
 
 	return platform_driver_register(&mpcore_wdt_driver);
 }
diff --git a/drivers/watchdog/mtx-1_wdt.c b/drivers/watchdog/mtx-1_wdt.c
index 7c02ded..db06002 100644
--- a/drivers/watchdog/mtx-1_wdt.c
+++ b/drivers/watchdog/mtx-1_wdt.c
@@ -34,6 +34,8 @@
  *      it MUST be triggered every 2..95 seconds.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -221,11 +223,11 @@ static int __devinit mtx1_wdt_probe(struct platform_device *pdev)
 
 	ret = misc_register(&mtx1_wdt_misc);
 	if (ret < 0) {
-		pr_err(" mtx-1_wdt : failed to register\n");
+		pr_err_section(__devinitconst, "failed to register\n");
 		return ret;
 	}
 	mtx1_wdt_start();
-	pr_info("MTX-1 Watchdog driver\n");
+	pr_info_section(__devinitconst, "MTX-1 Watchdog driver\n");
 	return 0;
 }
 
diff --git a/drivers/watchdog/mv64x60_wdt.c b/drivers/watchdog/mv64x60_wdt.c
index 2aa0ed3..ec8f0ca 100644
--- a/drivers/watchdog/mv64x60_wdt.c
+++ b/drivers/watchdog/mv64x60_wdt.c
@@ -15,6 +15,8 @@
  * or implied.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -100,7 +102,7 @@ static void mv64x60_wdt_handler_enable(void)
 	if (mv64x60_wdt_toggle_wdc(MV64x60_WDC_ENABLED_FALSE,
 				   MV64x60_WDC_ENABLE_SHIFT)) {
 		mv64x60_wdt_service();
-		pr_notice("mv64x60_wdt: watchdog activated\n");
+		pr_notice("watchdog activated\n");
 	}
 }
 
@@ -108,7 +110,7 @@ static void mv64x60_wdt_handler_disable(void)
 {
 	if (mv64x60_wdt_toggle_wdc(MV64x60_WDC_ENABLED_TRUE,
 				   MV64x60_WDC_ENABLE_SHIFT))
-		pr_notice("mv64x60_wdt: watchdog deactivated\n");
+		pr_notice("watchdog deactivated\n");
 }
 
 static void mv64x60_wdt_set_timeout(unsigned int timeout)
@@ -139,7 +141,7 @@ static int mv64x60_wdt_release(struct inode *inode, struct file *file)
 	if (expect_close == 42)
 		mv64x60_wdt_handler_disable();
 	else {
-		pr_crit("mv64x60_wdt: unexpected close, not stopping timer!\n");
+		pr_crit("unexpected close, not stopping timer!\n");
 		mv64x60_wdt_service();
 	}
 	expect_close = 0;
diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index 5b98c19..2ea3334 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -26,6 +26,8 @@
  *	Use the driver model and standard identifiers; handle bigger timeouts.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
@@ -179,7 +181,7 @@ static int omap_wdt_release(struct inode *inode, struct file *file)
 	clk_disable(wdev->ick);
 	clk_disable(wdev->fck);
 #else
-	pr_crit("omap_wdt: Unexpected close, not stopping!\n");
+	pr_crit("Unexpected close, not stopping!\n");
 #endif
 	wdev->omap_wdt_users = 0;
 
diff --git a/drivers/watchdog/orion_wdt.c b/drivers/watchdog/orion_wdt.c
index ebacb53..39af63c 100644
--- a/drivers/watchdog/orion_wdt.c
+++ b/drivers/watchdog/orion_wdt.c
@@ -10,6 +10,8 @@
  * warranty of any kind, whether express or implied.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -209,8 +211,7 @@ static int orion_wdt_release(struct inode *inode, struct file *file)
 	if (test_bit(WDT_OK_TO_CLOSE, &wdt_status))
 		orion_wdt_disable();
 	else
-		pr_crit("WATCHDOG: Device closed unexpectedly - "
-					"timer will not stop\n");
+		pr_crit("Device closed unexpectedly - timer will not stop\n");
 	clear_bit(WDT_IN_USE, &wdt_status);
 	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
 
@@ -241,7 +242,8 @@ static int __devinit orion_wdt_probe(struct platform_device *pdev)
 	if (pdata) {
 		wdt_tclk = pdata->tclk;
 	} else {
-		pr_err("Orion Watchdog misses platform data\n");
+		pr_err_section(__devinitconst,
+			       "Orion Watchdog misses platform data\n");
 		return -ENODEV;
 	}
 
@@ -257,8 +259,8 @@ static int __devinit orion_wdt_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	pr_info("Orion Watchdog Timer: Initial timeout %d sec%s\n",
-				heartbeat, nowayout ? ", nowayout" : "");
+	pr_info_section(__devinitconst, "Initial timeout %d sec%s\n",
+			heartbeat, nowayout ? ", nowayout" : "");
 	return 0;
 }
 
diff --git a/drivers/watchdog/pc87413_wdt.c b/drivers/watchdog/pc87413_wdt.c
index de04e97..cd49ad3 100644
--- a/drivers/watchdog/pc87413_wdt.c
+++ b/drivers/watchdog/pc87413_wdt.c
@@ -18,6 +18,8 @@
  *      Release 1.1
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/miscdevice.h>
@@ -42,8 +44,7 @@
 
 #define VERSION             "1.1"
 #define MODNAME             "pc87413 WDT"
-#define PFX                 MODNAME ": "
-#define DPFX                MODNAME " - DEBUG: "
+#define DPFX                "DEBUG: "
 
 #define WDT_INDEX_IO_PORT   (io+0)	/* I/O port base (index register) */
 #define WDT_DATA_IO_PORT    (WDT_INDEX_IO_PORT+1)
@@ -86,7 +87,7 @@ static inline void pc87413_select_wdt_out(void)
 #ifdef DEBUG
 	pr_info(DPFX
 		"Select multiple pin,pin55,as WDT output: Bit7 to 1: %d\n",
-								cr_data);
+		cr_data);
 #endif
 }
 
@@ -132,7 +133,7 @@ static inline unsigned int pc87413_get_swc_base(void)
 #ifdef DEBUG
 	pr_info(DPFX
 		"Read SWC I/O Base Address: low %d, high %d, res %d\n",
-						addr_l, addr_h, swc_base_addr);
+		addr_l, addr_h, swc_base_addr);
 #endif
 	return swc_base_addr;
 }
@@ -299,8 +300,7 @@ static int pc87413_open(struct inode *inode, struct file *file)
 	/* Reload and activate timer */
 	pc87413_refresh();
 
-	pr_info(MODNAME
-		"Watchdog enabled. Timeout set to %d minute(s).\n", timeout);
+	pr_info("Watchdog enabled. Timeout set to %d minute(s).\n", timeout);
 
 	return nonseekable_open(inode, file);
 }
@@ -323,11 +323,9 @@ static int pc87413_release(struct inode *inode, struct file *file)
 
 	if (expect_close == 42) {
 		pc87413_disable();
-		pr_info(MODNAME
-				"Watchdog disabled, sleeping again...\n");
+		pr_info("Watchdog disabled, sleeping again...\n");
 	} else {
-		pr_crit(MODNAME
-				"Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		pc87413_refresh();
 	}
 	clear_bit(0, &timer_enabled);
@@ -523,26 +521,23 @@ static int __init pc87413_init(void)
 {
 	int ret;
 
-	pr_info(PFX "Version " VERSION " at io 0x%X\n",
-							WDT_INDEX_IO_PORT);
+	pr_info("Version " VERSION " at io 0x%X\n", WDT_INDEX_IO_PORT);
 
 	/* request_region(io, 2, "pc87413"); */
 
 	ret = register_reboot_notifier(&pc87413_notifier);
 	if (ret != 0) {
-		pr_err(PFX
-			"cannot register reboot notifier (err=%d)\n", ret);
+		pr_err("cannot register reboot notifier (err=%d)\n", ret);
 	}
 
 	ret = misc_register(&pc87413_miscdev);
 	if (ret != 0) {
-		pr_err(PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, ret);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, ret);
 		unregister_reboot_notifier(&pc87413_notifier);
 		return ret;
 	}
-	pr_info(PFX "initialized. timeout=%d min \n", timeout);
+	pr_info("initialized. timeout=%d min \n", timeout);
 	pc87413_enable();
 	return 0;
 }
@@ -562,14 +557,14 @@ static void __exit pc87413_exit(void)
 	/* Stop the timer before we leave */
 	if (!nowayout) {
 		pc87413_disable();
-		pr_info(MODNAME "Watchdog disabled.\n");
+		pr_info("Watchdog disabled.\n");
 	}
 
 	misc_deregister(&pc87413_miscdev);
 	unregister_reboot_notifier(&pc87413_notifier);
 	/* release_region(io, 2); */
 
-	pr_info(MODNAME " watchdog component driver removed.\n");
+	pr_info("watchdog component driver removed.\n");
 }
 
 module_init(pc87413_init);
diff --git a/drivers/watchdog/pcwd.c b/drivers/watchdog/pcwd.c
index 6392d38..e03aebc 100644
--- a/drivers/watchdog/pcwd.c
+++ b/drivers/watchdog/pcwd.c
@@ -51,6 +51,8 @@
  *	http://www.pcwatchdog.com/
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>	/* For module specific items */
 #include <linux/moduleparam.h>	/* For new moduleparam's */
 #include <linux/types.h>	/* For standard types (like size_t) */
@@ -336,16 +338,15 @@ static void pcwd_show_card_info(void)
 
 	/* Get some extra info from the hardware (in command/debug/diag mode) */
 	if (pcwd_private.revision == PCWD_REVISION_A)
-		pr_info(PFX
-			"ISA-PC Watchdog (REV.A) detected at port 0x%04x\n",
-							pcwd_private.io_addr);
+		pr_info("ISA-PC Watchdog (REV.A) detected at port 0x%04x\n",
+			pcwd_private.io_addr);
 	else if (pcwd_private.revision == PCWD_REVISION_C) {
 		pcwd_get_firmware();
-		pr_info(PFX "ISA-PC Watchdog (REV.C) detected at port "
+		pr_info("ISA-PC Watchdog (REV.C) detected at port "
 			"0x%04x (Firmware version: %s)\n",
 			pcwd_private.io_addr, pcwd_private.fw_ver_str);
 		option_switches = pcwd_get_option_switches();
-		pr_info(PFX "Option switches (0x%02x): "
+		pr_info("Option switches (0x%02x): "
 			"Temperature Reset Enable=%s, Power On Delay=%s\n",
 			option_switches,
 			((option_switches & 0x10) ? "ON" : "OFF"),
@@ -359,22 +360,18 @@ static void pcwd_show_card_info(void)
 	}
 
 	if (pcwd_private.supports_temp)
-		pr_info(PFX "Temperature Option Detected\n");
+		pr_info("Temperature Option Detected\n");
 
 	if (pcwd_private.boot_status & WDIOF_CARDRESET)
-		pr_info(PFX
-			"Previous reboot was caused by the card\n");
+		pr_info("Previous reboot was caused by the card\n");
 
 	if (pcwd_private.boot_status & WDIOF_OVERHEAT) {
-		printk(KERN_EMERG PFX
-			"Card senses a CPU Overheat. Panicking!\n");
-		printk(KERN_EMERG PFX
-			"CPU Overheat\n");
+		pr_emerg("Card senses a CPU Overheat. Panicking!\n");
+		pr_emerg("CPU Overheat\n");
 	}
 
 	if (pcwd_private.boot_status == 0)
-		pr_info(PFX
-			"No previous trip detected - Cold boot or reset\n");
+		pr_info("No previous trip detected - Cold boot or reset\n");
 }
 
 static void pcwd_timer_ping(unsigned long data)
@@ -404,8 +401,7 @@ static void pcwd_timer_ping(unsigned long data)
 
 		spin_unlock(&pcwd_private.io_lock);
 	} else {
-		pr_warning(PFX
-			"Heartbeat lost! Will not ping the watchdog\n");
+		pr_warning("Heartbeat lost! Will not ping the watchdog\n");
 	}
 }
 
@@ -426,7 +422,7 @@ static int pcwd_start(void)
 		stat_reg = inb_p(pcwd_private.io_addr + 2);
 		spin_unlock(&pcwd_private.io_lock);
 		if (stat_reg & WD_WDIS) {
-			pr_info(PFX "Could not start watchdog\n");
+			pr_info("Could not start watchdog\n");
 			return -EIO;
 		}
 	}
@@ -454,7 +450,7 @@ static int pcwd_stop(void)
 		stat_reg = inb_p(pcwd_private.io_addr + 2);
 		spin_unlock(&pcwd_private.io_lock);
 		if ((stat_reg & WD_WDIS) == 0) {
-			pr_info(PFX "Could not stop watchdog\n");
+			pr_info("Could not stop watchdog\n");
 			return -EIO;
 		}
 	}
@@ -518,8 +514,7 @@ static int pcwd_get_status(int *status)
 		if (control_status & WD_T110) {
 			*status |= WDIOF_OVERHEAT;
 			if (temp_panic) {
-				pr_info(PFX
-					"Temperature overheat trip!\n");
+				pr_info("Temperature overheat trip!\n");
 				kernel_power_off();
 			}
 		}
@@ -530,8 +525,7 @@ static int pcwd_get_status(int *status)
 		if (control_status & WD_REVC_TTRP) {
 			*status |= WDIOF_OVERHEAT;
 			if (temp_panic) {
-				pr_info(PFX
-					"Temperature overheat trip!\n");
+				pr_info("Temperature overheat trip!\n");
 				kernel_power_off();
 			}
 		}
@@ -548,8 +542,7 @@ static int pcwd_clear_status(void)
 		spin_lock(&pcwd_private.io_lock);
 
 		if (debug >= VERBOSE)
-			pr_info(PFX
-					"clearing watchdog trip status\n");
+			pr_info("clearing watchdog trip status\n");
 
 		control_status = inb_p(pcwd_private.io_addr + 1);
 
@@ -720,8 +713,7 @@ static int pcwd_close(struct inode *inode, struct file *file)
 	if (expect_close == 42)
 		pcwd_stop();
 	else {
-		pr_crit(PFX
-			"Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		pcwd_keepalive();
 	}
 	expect_close = 0;
@@ -832,7 +824,7 @@ static int __devinit pcwd_isa_match(struct device *dev, unsigned int id)
 			id);
 
 	if (!request_region(base_addr, 4, "PCWD")) {
-		pr_info(PFX "Port 0x%04x unavailable\n", base_addr);
+		pr_info("Port 0x%04x unavailable\n", base_addr);
 		return 0;
 	}
 
@@ -875,16 +867,16 @@ static int __devinit pcwd_isa_probe(struct device *dev, unsigned int id)
 
 	cards_found++;
 	if (cards_found == 1)
-		pr_info(PFX "v%s Ken Hollis (kenji@bitgate.com)\n",
-							WATCHDOG_VERSION);
+		pr_info("v%s Ken Hollis (kenji@bitgate.com)\n",
+			WATCHDOG_VERSION);
 
 	if (cards_found > 1) {
-		pr_err(PFX "This driver only supports 1 device\n");
+		pr_err("This driver only supports 1 device\n");
 		return -ENODEV;
 	}
 
 	if (pcwd_ioports[id] == 0x0000) {
-		pr_err(PFX "No I/O-Address for card detected\n");
+		pr_err("No I/O-Address for card detected\n");
 		return -ENODEV;
 	}
 	pcwd_private.io_addr = pcwd_ioports[id];
@@ -896,8 +888,8 @@ static int __devinit pcwd_isa_probe(struct device *dev, unsigned int id)
 
 	if (!request_region(pcwd_private.io_addr,
 		(pcwd_private.revision == PCWD_REVISION_A) ? 2 : 4, "PCWD")) {
-		pr_err(PFX "I/O address 0x%04x already in use\n",
-			pcwd_private.io_addr);
+		pr_err("I/O address 0x%04x already in use\n",
+		       pcwd_private.io_addr);
 		ret = -EIO;
 		goto error_request_region;
 	}
@@ -932,30 +924,27 @@ static int __devinit pcwd_isa_probe(struct device *dev, unsigned int id)
 	   if not reset to the default */
 	if (pcwd_set_heartbeat(heartbeat)) {
 		pcwd_set_heartbeat(WATCHDOG_HEARTBEAT);
-		pr_info(PFX
-		  "heartbeat value must be 2 <= heartbeat <= 7200, using %d\n",
-							WATCHDOG_HEARTBEAT);
+		pr_info("heartbeat value must be 2 <= heartbeat <= 7200, using %d\n",
+			WATCHDOG_HEARTBEAT);
 	}
 
 	if (pcwd_private.supports_temp) {
 		ret = misc_register(&temp_miscdev);
 		if (ret) {
-			pr_err(PFX
-			    "cannot register miscdev on minor=%d (err=%d)\n",
-							TEMP_MINOR, ret);
+			pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+			       TEMP_MINOR, ret);
 			goto error_misc_register_temp;
 		}
 	}
 
 	ret = misc_register(&pcwd_miscdev);
 	if (ret) {
-		pr_err(PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-					WATCHDOG_MINOR, ret);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, ret);
 		goto error_misc_register_watchdog;
 	}
 
-	pr_info(PFX "initialized. heartbeat=%d sec (nowayout=%d)\n",
+	pr_info("initialized. heartbeat=%d sec (nowayout=%d)\n",
 		heartbeat, nowayout);
 
 	return 0;
@@ -1025,7 +1014,7 @@ static int __init pcwd_init_module(void)
 static void __exit pcwd_cleanup_module(void)
 {
 	isa_unregister_driver(&pcwd_isa_driver);
-	pr_info(PFX "Watchdog Module Unloaded.\n");
+	pr_info("Watchdog Module Unloaded.\n");
 }
 
 module_init(pcwd_init_module);
diff --git a/drivers/watchdog/pcwd_pci.c b/drivers/watchdog/pcwd_pci.c
index 3f51f37..1b084b7 100644
--- a/drivers/watchdog/pcwd_pci.c
+++ b/drivers/watchdog/pcwd_pci.c
@@ -32,6 +32,8 @@
  *	Includes, defines, variables, module parameters, ...
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>	/* For module specific items */
 #include <linux/moduleparam.h>	/* For new moduleparam's */
 #include <linux/types.h>	/* For standard types (like size_t) */
@@ -243,27 +245,24 @@ static void pcipcwd_show_card_info(void)
 	/* Get switch settings */
 	option_switches = pcipcwd_get_option_switches();
 
-	pr_info(PFX "Found card at port "
-		"0x%04x (Firmware: %s) %s temp option\n",
+	pr_info("Found card at port 0x%04x (Firmware: %s) %s temp option\n",
 		(int) pcipcwd_private.io_addr, fw_ver_str,
 		(pcipcwd_private.supports_temp ? "with" : "without"));
 
-	pr_info(PFX "Option switches (0x%02x): "
+	pr_info("Option switches (0x%02x): "
 		"Temperature Reset Enable=%s, Power On Delay=%s\n",
 		option_switches,
 		((option_switches & 0x10) ? "ON" : "OFF"),
 		((option_switches & 0x08) ? "ON" : "OFF"));
 
 	if (pcipcwd_private.boot_status & WDIOF_CARDRESET)
-		pr_info(PFX
-			"Previous reset was caused by the Watchdog card\n");
+		pr_info("Previous reset was caused by the Watchdog card\n");
 
 	if (pcipcwd_private.boot_status & WDIOF_OVERHEAT)
-		pr_info(PFX "Card sensed a CPU Overheat\n");
+		pr_info("Card sensed a CPU Overheat\n");
 
 	if (pcipcwd_private.boot_status == 0)
-		pr_info(PFX
-			"No previous trip detected - Cold boot or reset\n");
+		pr_info("No previous trip detected - Cold boot or reset\n");
 }
 
 static int pcipcwd_start(void)
@@ -278,7 +277,7 @@ static int pcipcwd_start(void)
 	spin_unlock(&pcipcwd_private.io_lock);
 
 	if (stat_reg & WD_PCI_WDIS) {
-		pr_err(PFX "Card timer not enabled\n");
+		pr_err("Card timer not enabled\n");
 		return -1;
 	}
 
@@ -303,8 +302,7 @@ static int pcipcwd_stop(void)
 	spin_unlock(&pcipcwd_private.io_lock);
 
 	if (!(stat_reg & WD_PCI_WDIS)) {
-		pr_err(PFX
-			"Card did not acknowledge disable attempt\n");
+		pr_err("Card did not acknowledge disable attempt\n");
 		return -1;
 	}
 
@@ -374,7 +372,7 @@ static int pcipcwd_clear_status(void)
 	int reset_counter;
 
 	if (debug >= VERBOSE)
-		pr_info(PFX "clearing watchdog trip status & LED\n");
+		pr_info("clearing watchdog trip status & LED\n");
 
 	control_status = inb_p(pcipcwd_private.io_addr + 1);
 
@@ -583,8 +581,7 @@ static int pcipcwd_open(struct inode *inode, struct file *file)
 	/* /dev/watchdog can only be opened once */
 	if (test_and_set_bit(0, &is_active)) {
 		if (debug >= VERBOSE)
-			pr_err(PFX
-				"Attempt to open already opened device.\n");
+			pr_err("Attempt to open already opened device.\n");
 		return -EBUSY;
 	}
 
@@ -602,8 +599,7 @@ static int pcipcwd_release(struct inode *inode, struct file *file)
 	if (expect_release == 42) {
 		pcipcwd_stop();
 	} else {
-		pr_crit(PFX
-			"Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		pcipcwd_keepalive();
 	}
 	expect_release = 0;
@@ -703,20 +699,23 @@ static int __devinit pcipcwd_card_init(struct pci_dev *pdev,
 
 	cards_found++;
 	if (cards_found == 1)
-		pr_info(PFX DRIVER_VERSION);
+		pr_info_section(__devinitconst, DRIVER_VERSION);
 
 	if (cards_found > 1) {
-		pr_err(PFX "This driver only supports 1 device\n");
+		pr_err_section(__devinitconst,
+			       "This driver only supports 1 device\n");
 		return -ENODEV;
 	}
 
 	if (pci_enable_device(pdev)) {
-		pr_err(PFX "Not possible to enable PCI Device\n");
+		pr_err_section(__devinitconst,
+			       "Not possible to enable PCI Device\n");
 		return -ENODEV;
 	}
 
 	if (pci_resource_start(pdev, 0) == 0x0000) {
-		pr_err(PFX "No I/O-Address for card detected\n");
+		pr_err_section(__devinitconst,
+			       "No I/O-Address for card detected\n");
 		ret = -ENODEV;
 		goto err_out_disable_device;
 	}
@@ -725,8 +724,9 @@ static int __devinit pcipcwd_card_init(struct pci_dev *pdev,
 	pcipcwd_private.io_addr = pci_resource_start(pdev, 0);
 
 	if (pci_request_regions(pdev, WATCHDOG_NAME)) {
-		pr_err(PFX "I/O address 0x%04x already in use\n",
-			(int) pcipcwd_private.io_addr);
+		pr_err_section(__devinitconst,
+			       "I/O address 0x%04x already in use\n",
+			       (int)pcipcwd_private.io_addr);
 		ret = -EIO;
 		goto err_out_disable_device;
 	}
@@ -755,37 +755,39 @@ static int __devinit pcipcwd_card_init(struct pci_dev *pdev,
 	 * if not reset to the default */
 	if (pcipcwd_set_heartbeat(heartbeat)) {
 		pcipcwd_set_heartbeat(WATCHDOG_HEARTBEAT);
-		pr_info(PFX
-			"heartbeat value must be 0<heartbeat<65536, using %d\n",
-			WATCHDOG_HEARTBEAT);
+		pr_info_section(__devinitconst,
+				"heartbeat value must be 0<heartbeat<65536, "
+				"using %d\n", WATCHDOG_HEARTBEAT);
 	}
 
 	ret = register_reboot_notifier(&pcipcwd_notifier);
 	if (ret != 0) {
-		pr_err(PFX
-			"cannot register reboot notifier (err=%d)\n", ret);
+		pr_err_section(__devinitconst,
+			       "cannot register reboot notifier (err=%d)\n",
+			       ret);
 		goto err_out_release_region;
 	}
 
 	if (pcipcwd_private.supports_temp) {
 		ret = misc_register(&pcipcwd_temp_miscdev);
 		if (ret != 0) {
-			pr_err(PFX "cannot register miscdev on "
-				"minor=%d (err=%d)\n", TEMP_MINOR, ret);
+			pr_err_section(__devinitconst,
+	"cannot register miscdev on minor=%d (err=%d)\n", TEMP_MINOR, ret);
 			goto err_out_unregister_reboot;
 		}
 	}
 
 	ret = misc_register(&pcipcwd_miscdev);
 	if (ret != 0) {
-		pr_err(PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, ret);
+		pr_err_section(__devinitconst,
+			       "cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, ret);
 		goto err_out_misc_deregister;
 	}
 
-	pr_info(PFX "initialized. heartbeat=%d sec (nowayout=%d)\n",
-		heartbeat, nowayout);
+	pr_info_section(__devinitconst,
+			"initialized. heartbeat=%d sec (nowayout=%d)\n",
+			heartbeat, nowayout);
 
 	return 0;
 
@@ -842,7 +844,7 @@ static void __exit pcipcwd_cleanup_module(void)
 {
 	pci_unregister_driver(&pcipcwd_driver);
 
-	pr_info(PFX "Watchdog Module Unloaded.\n");
+	pr_info("Watchdog Module Unloaded.\n");
 }
 
 module_init(pcipcwd_init_module);
diff --git a/drivers/watchdog/pcwd_usb.c b/drivers/watchdog/pcwd_usb.c
index 430dbed..597c110 100644
--- a/drivers/watchdog/pcwd_usb.c
+++ b/drivers/watchdog/pcwd_usb.c
@@ -24,6 +24,8 @@
  *	http://www.berkprod.com/ or http://www.pcwatchdog.com/
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>	/* For module specific items */
 #include <linux/moduleparam.h>	/* For new moduleparam's */
 #include <linux/types.h>	/* For standard types (like size_t) */
@@ -51,8 +53,10 @@
 
 /* Use our own dbg macro */
 #undef dbg
-#define dbg(format, arg...) \
-	do { if (debug) printk(KERN_DEBUG PFX format "\n" , ## arg); } while (0)
+#define dbg(format, arg...)						\
+	do { if (debug)							\
+		printk(KERN_DEBUG KBUILD_MODNAME ": " format "\n", ##arg); \
+	} while (0)
 
 /* Module and Version Information */
 #define DRIVER_VERSION "1.02"
@@ -60,7 +64,6 @@
 #define DRIVER_DESC "Berkshire USB-PC Watchdog driver"
 #define DRIVER_LICENSE "GPL"
 #define DRIVER_NAME "pcwd_usb"
-#define PFX DRIVER_NAME ": "
 
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
@@ -220,8 +223,8 @@ static void usb_pcwd_intr_done(struct urb *urb)
 resubmit:
 	retval = usb_submit_urb(urb, GFP_ATOMIC);
 	if (retval)
-		pr_err(PFX "can't resubmit intr, "
-			"usb_submit_urb failed with result %d\n", retval);
+		pr_err("can't resubmit intr, "
+		       "usb_submit_urb failed with result %d\n", retval);
 }
 
 static int usb_pcwd_send_command(struct usb_pcwd_private *usb_pcwd,
@@ -284,8 +287,7 @@ static int usb_pcwd_start(struct usb_pcwd_private *usb_pcwd)
 								&msb, &lsb);
 
 	if ((retval == 0) || (lsb == 0)) {
-		pr_err(PFX
-				"Card did not acknowledge enable attempt\n");
+		pr_err("Card did not acknowledge enable attempt\n");
 		return -1;
 	}
 
@@ -303,8 +305,7 @@ static int usb_pcwd_stop(struct usb_pcwd_private *usb_pcwd)
 								&msb, &lsb);
 
 	if ((retval == 0) || (lsb != 0)) {
-		pr_err(PFX
-			"Card did not acknowledge disable attempt\n");
+		pr_err("Card did not acknowledge disable attempt\n");
 		return -1;
 	}
 
@@ -506,8 +507,7 @@ static int usb_pcwd_release(struct inode *inode, struct file *file)
 	if (expect_release == 42) {
 		usb_pcwd_stop(usb_pcwd_device);
 	} else {
-		pr_crit(PFX
-			"Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		usb_pcwd_keepalive(usb_pcwd_device);
 	}
 	expect_release = 0;
@@ -627,7 +627,7 @@ static int usb_pcwd_probe(struct usb_interface *interface,
 
 	cards_found++;
 	if (cards_found > 1) {
-		pr_err(PFX "This driver only supports 1 device\n");
+		pr_err("This driver only supports 1 device\n");
 		return -ENODEV;
 	}
 
@@ -636,8 +636,7 @@ static int usb_pcwd_probe(struct usb_interface *interface,
 
 	/* check out that we have a HID device */
 	if (!(iface_desc->desc.bInterfaceClass == USB_CLASS_HID)) {
-		pr_err(PFX
-			"The device isn't a Human Interface Device\n");
+		pr_err("The device isn't a Human Interface Device\n");
 		return -ENODEV;
 	}
 
@@ -646,7 +645,7 @@ static int usb_pcwd_probe(struct usb_interface *interface,
 
 	if (!usb_endpoint_is_int_in(endpoint)) {
 		/* we didn't find a Interrupt endpoint with direction IN */
-		pr_err(PFX "Couldn't find an INTR & IN endpoint\n");
+		pr_err("Couldn't find an INTR & IN endpoint\n");
 		return -ENODEV;
 	}
 
@@ -657,7 +656,7 @@ static int usb_pcwd_probe(struct usb_interface *interface,
 	/* allocate memory for our device and initialize it */
 	usb_pcwd = kzalloc(sizeof(struct usb_pcwd_private), GFP_KERNEL);
 	if (usb_pcwd == NULL) {
-		pr_err(PFX "Out of memory\n");
+		pr_err("Out of memory\n");
 		goto error;
 	}
 
@@ -674,14 +673,14 @@ static int usb_pcwd_probe(struct usb_interface *interface,
 	usb_pcwd->intr_buffer = usb_buffer_alloc(udev, usb_pcwd->intr_size,
 					GFP_ATOMIC, &usb_pcwd->intr_dma);
 	if (!usb_pcwd->intr_buffer) {
-		pr_err(PFX "Out of memory\n");
+		pr_err("Out of memory\n");
 		goto error;
 	}
 
 	/* allocate the urb's */
 	usb_pcwd->intr_urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!usb_pcwd->intr_urb) {
-		pr_err(PFX "Out of memory\n");
+		pr_err("Out of memory\n");
 		goto error;
 	}
 
@@ -694,7 +693,7 @@ static int usb_pcwd_probe(struct usb_interface *interface,
 
 	/* register our interrupt URB with the USB system */
 	if (usb_submit_urb(usb_pcwd->intr_urb, GFP_KERNEL)) {
-		pr_err(PFX "Problem registering interrupt URB\n");
+		pr_err("Problem registering interrupt URB\n");
 		retval = -EIO; /* failure */
 		goto error;
 	}
@@ -713,14 +712,14 @@ static int usb_pcwd_probe(struct usb_interface *interface,
 	else
 		sprintf(fw_ver_str, "<card no answer>");
 
-	pr_info(PFX "Found card (Firmware: %s) with temp option\n",
+	pr_info("Found card (Firmware: %s) with temp option\n",
 		fw_ver_str);
 
 	/* Get switch settings */
 	usb_pcwd_send_command(usb_pcwd, CMD_GET_DIP_SWITCH_SETTINGS, &dummy,
 							&option_switches);
 
-	pr_info(PFX "Option switches (0x%02x): "
+	pr_info("Option switches (0x%02x): "
 		"Temperature Reset Enable=%s, Power On Delay=%s\n",
 		option_switches,
 		((option_switches & 0x10) ? "ON" : "OFF"),
@@ -734,39 +733,34 @@ static int usb_pcwd_probe(struct usb_interface *interface,
 	 * if not reset to the default */
 	if (usb_pcwd_set_heartbeat(usb_pcwd, heartbeat)) {
 		usb_pcwd_set_heartbeat(usb_pcwd, WATCHDOG_HEARTBEAT);
-		pr_info(PFX
-			"heartbeat value must be 0<heartbeat<65536, using %d\n",
+		pr_info("heartbeat value must be 0<heartbeat<65536, using %d\n",
 			WATCHDOG_HEARTBEAT);
 	}
 
 	retval = register_reboot_notifier(&usb_pcwd_notifier);
 	if (retval != 0) {
-		pr_err(PFX
-			"cannot register reboot notifier (err=%d)\n",
-			retval);
+		pr_err("cannot register reboot notifier (err=%d)\n", retval);
 		goto error;
 	}
 
 	retval = misc_register(&usb_pcwd_temperature_miscdev);
 	if (retval != 0) {
-		pr_err(PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-			TEMP_MINOR, retval);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       TEMP_MINOR, retval);
 		goto err_out_unregister_reboot;
 	}
 
 	retval = misc_register(&usb_pcwd_miscdev);
 	if (retval != 0) {
-		pr_err(PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, retval);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, retval);
 		goto err_out_misc_deregister;
 	}
 
 	/* we can register the device now, as it is ready */
 	usb_set_intfdata(interface, usb_pcwd);
 
-	pr_info(PFX "initialized. heartbeat=%d sec (nowayout=%d)\n",
+	pr_info("initialized. heartbeat=%d sec (nowayout=%d)\n",
 		heartbeat, nowayout);
 
 	return 0;
@@ -824,7 +818,7 @@ static void usb_pcwd_disconnect(struct usb_interface *interface)
 
 	mutex_unlock(&disconnect_mutex);
 
-	pr_info(PFX "USB PC Watchdog disconnected\n");
+	pr_info("USB PC Watchdog disconnected\n");
 }
 
 
@@ -839,12 +833,11 @@ static int __init usb_pcwd_init(void)
 	/* register this driver with the USB subsystem */
 	result = usb_register(&usb_pcwd_driver);
 	if (result) {
-		pr_err(PFX "usb_register failed. Error number %d\n",
-		    result);
+		pr_err("usb_register failed. Error number %d\n", result);
 		return result;
 	}
 
-	pr_info(PFX DRIVER_DESC " v" DRIVER_VERSION "\n");
+	pr_info(DRIVER_DESC " v" DRIVER_VERSION "\n");
 	return 0;
 }
 
diff --git a/drivers/watchdog/pika_wdt.c b/drivers/watchdog/pika_wdt.c
index 29f651b..9eb8bce 100644
--- a/drivers/watchdog/pika_wdt.c
+++ b/drivers/watchdog/pika_wdt.c
@@ -5,6 +5,8 @@
  *   Sean MacLennan <smaclennan@pikatech.com>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/module.h>
@@ -23,7 +25,6 @@
 #include <linux/of_platform.h>
 
 #define DRV_NAME "PIKA-WDT"
-#define PFX DRV_NAME ": "
 
 /* Hardware timeout in seconds */
 #define WDT_HW_TIMEOUT 2
@@ -90,7 +91,7 @@ static void pikawdt_ping(unsigned long data)
 		pikawdt_reset();
 		mod_timer(&pikawdt_private.timer, jiffies + WDT_TIMEOUT);
 	} else
-		pr_crit(PFX "I will reset your machine !\n");
+		pr_crit("I will reset your machine !\n");
 }
 
 
@@ -228,14 +229,14 @@ static int __init pikawdt_init(void)
 
 	np = of_find_compatible_node(NULL, NULL, "pika,fpga");
 	if (np == NULL) {
-		pr_err(PFX "Unable to find fpga.\n");
+		pr_err("Unable to find fpga.\n");
 		return -ENOENT;
 	}
 
 	pikawdt_private.fpga = of_iomap(np, 0);
 	of_node_put(np);
 	if (pikawdt_private.fpga == NULL) {
-		pr_err(PFX "Unable to map fpga.\n");
+		pr_err("Unable to map fpga.\n");
 		return -ENOMEM;
 	}
 
@@ -244,7 +245,7 @@ static int __init pikawdt_init(void)
 	/* POST information is in the sd area. */
 	np = of_find_compatible_node(NULL, NULL, "pika,fpga-sd");
 	if (np == NULL) {
-		pr_err(PFX "Unable to find fpga-sd.\n");
+		pr_err("Unable to find fpga-sd.\n");
 		ret = -ENOENT;
 		goto out;
 	}
@@ -252,7 +253,7 @@ static int __init pikawdt_init(void)
 	fpga = of_iomap(np, 0);
 	of_node_put(np);
 	if (fpga == NULL) {
-		pr_err(PFX "Unable to map fpga-sd.\n");
+		pr_err("Unable to map fpga-sd.\n");
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -271,12 +272,12 @@ static int __init pikawdt_init(void)
 
 	ret = misc_register(&pikawdt_miscdev);
 	if (ret) {
-		pr_err(PFX "Unable to register miscdev.\n");
+		pr_err("Unable to register miscdev.\n");
 		goto out;
 	}
 
-	pr_info(PFX "initialized. heartbeat=%d sec (nowayout=%d)\n",
-							heartbeat, nowayout);
+	pr_info("initialized. heartbeat=%d sec (nowayout=%d)\n",
+		heartbeat, nowayout);
 	return 0;
 
 out:
diff --git a/drivers/watchdog/pnx4008_wdt.c b/drivers/watchdog/pnx4008_wdt.c
index 1eda79e..863bfe4 100644
--- a/drivers/watchdog/pnx4008_wdt.c
+++ b/drivers/watchdog/pnx4008_wdt.c
@@ -14,6 +14,8 @@
  * or implied.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -32,8 +34,6 @@
 #include <linux/io.h>
 #include <mach/hardware.h>
 
-#define MODULE_NAME "PNX4008-WDT: "
-
 /* WatchDog Timer - Chapter 23 Page 207 */
 
 #define DEFAULT_HEARTBEAT 19
@@ -222,7 +222,7 @@ static long pnx4008_wdt_ioctl(struct file *file, unsigned int cmd,
 static int pnx4008_wdt_release(struct inode *inode, struct file *file)
 {
 	if (!test_bit(WDT_OK_TO_CLOSE, &wdt_status))
-		pr_warning("WATCHDOG: Device closed unexpectdly\n");
+		pr_warning("Device closed unexpectdly\n");
 
 	wdt_disable();
 	clear_bit(WDT_IN_USE, &wdt_status);
@@ -254,13 +254,14 @@ static int __devinit pnx4008_wdt_probe(struct platform_device *pdev)
 	if (heartbeat < 1 || heartbeat > MAX_HEARTBEAT)
 		heartbeat = DEFAULT_HEARTBEAT;
 
-	pr_info(MODULE_NAME
-		"PNX4008 Watchdog Timer: heartbeat %d sec\n", heartbeat);
+	pr_info_section(__devinitconst,
+			"PNX4008 Watchdog Timer: heartbeat %d sec\n",
+			heartbeat);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (res == NULL) {
-		pr_info(MODULE_NAME
-			"failed to get memory region resouce\n");
+		pr_info_section(__devinitconst,
+				"failed to get memory region resouce\n");
 		return -ENOENT;
 	}
 
@@ -268,7 +269,8 @@ static int __devinit pnx4008_wdt_probe(struct platform_device *pdev)
 	wdt_mem = request_mem_region(res->start, size, pdev->name);
 
 	if (wdt_mem == NULL) {
-		pr_info(MODULE_NAME "failed to get memory region\n");
+		pr_info_section(__devinitconst,
+				"failed to get memory region\n");
 		return -ENOENT;
 	}
 	wdt_base = (void __iomem *)IO_ADDRESS(res->start);
@@ -284,7 +286,7 @@ static int __devinit pnx4008_wdt_probe(struct platform_device *pdev)
 
 	ret = misc_register(&pnx4008_wdt_miscdev);
 	if (ret < 0) {
-		pr_err(MODULE_NAME "cannot register misc device\n");
+		pr_err_section(__devinitconst, "cannot register misc device\n");
 		release_resource(wdt_mem);
 		kfree(wdt_mem);
 		clk_set_rate(wdt_clk, 0);
diff --git a/drivers/watchdog/pnx833x_wdt.c b/drivers/watchdog/pnx833x_wdt.c
index deef790..f370441 100644
--- a/drivers/watchdog/pnx833x_wdt.c
+++ b/drivers/watchdog/pnx833x_wdt.c
@@ -73,7 +73,7 @@ static void pnx833x_wdt_start(void)
 	PNX833X_REG(PNX833X_CONFIG +
 				PNX833X_CONFIG_CPU_COUNTERS_CONTROL) |= 0x1;
 
-	pr_info(PFX "Started watchdog timer.\n");
+	pr_info("Started watchdog timer.\n");
 }
 
 static void pnx833x_wdt_stop(void)
@@ -84,7 +84,7 @@ static void pnx833x_wdt_stop(void)
 	PNX833X_REG(PNX833X_CONFIG +
 			PNX833X_CONFIG_CPU_COUNTERS_CONTROL) &= 0xFFFFFFFE;
 
-	pr_info(PFX "Stopped watchdog timer.\n");
+	pr_info("Stopped watchdog timer.\n");
 }
 
 static void pnx833x_wdt_ping(void)
@@ -229,9 +229,6 @@ static struct notifier_block pnx833x_wdt_notifier = {
 	.notifier_call = pnx833x_wdt_notify_sys,
 };
 
-static char banner[] __initdata =
-	KERN_INFO PFX "Hardware Watchdog Timer for PNX833x: Version 0.1\n";
-
 static int __init watchdog_init(void)
 {
 	int ret, cause;
@@ -240,27 +237,30 @@ static int __init watchdog_init(void)
 	cause = PNX833X_REG(PNX833X_RESET);
 	/*If bit 31 is set then watchdog was cause of reset.*/
 	if (cause & 0x80000000) {
-		pr_info(PFX "The system was previously reset due to "
-			"the watchdog firing - please investigate...\n");
+		pr_info_section(__initdata,
+	"The system was previously reset due to the watchdog firing"
+	" - please investigate...\n");
 	}
 
 	ret = register_reboot_notifier(&pnx833x_wdt_notifier);
 	if (ret) {
-		pr_err(PFX
-			"cannot register reboot notifier (err=%d)\n", ret);
+		pr_err_section(__initdata,
+			       "cannot register reboot notifier (err=%d)\n",
+			       ret);
 		return ret;
 	}
 
 	ret = misc_register(&pnx833x_wdt_miscdev);
 	if (ret) {
-		pr_err(PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, ret);
+		pr_err_section(__initdata,
+			       "cannot register miscdev on minor=%d (err=%d)\n",
+			       WATCHDOG_MINOR, ret);
 		unregister_reboot_notifier(&pnx833x_wdt_notifier);
 		return ret;
 	}
 
-	printk(banner);
+	pr_info_section(__initdata,
+			"Hardware Watchdog Timer for PNX833x: Version 0.1\n");
 	if (start_enabled)
 		pnx833x_wdt_start();
 
diff --git a/drivers/watchdog/rc32434_wdt.c b/drivers/watchdog/rc32434_wdt.c
index 5ecfff9..f3ef529 100644
--- a/drivers/watchdog/rc32434_wdt.c
+++ b/drivers/watchdog/rc32434_wdt.c
@@ -17,6 +17,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>		/* For module specific items */
 #include <linux/moduleparam.h>		/* For new moduleparam's */
 #include <linux/types.h>		/* For standard types (like size_t) */
@@ -33,8 +35,6 @@
 
 #include <asm/mach-rc32434/integ.h>	/* For the Watchdog registers */
 
-#define PFX KBUILD_MODNAME ": "
-
 #define VERSION "1.0"
 
 static struct {
@@ -78,8 +78,7 @@ static int rc32434_wdt_set(int new_timeout)
 	int max_to = WTCOMP2SEC((u32)-1);
 
 	if (new_timeout < 0 || new_timeout > max_to) {
-		pr_err(PFX "timeout value must be between 0 and %d",
-			max_to);
+		pr_err("timeout value must be between 0 and %d", max_to);
 		return -EINVAL;
 	}
 	timeout = new_timeout;
@@ -119,7 +118,7 @@ static void rc32434_wdt_start(void)
 	SET_BITS(wdt_reg->wtc, or, nand);
 
 	spin_unlock(&rc32434_wdt_device.io_lock);
-	pr_info(PFX "Started watchdog timer.\n");
+	pr_info("Started watchdog timer.\n");
 }
 
 static void rc32434_wdt_stop(void)
@@ -130,7 +129,7 @@ static void rc32434_wdt_stop(void)
 	SET_BITS(wdt_reg->wtc, 0, 1 << RC32434_WTC_EN);
 
 	spin_unlock(&rc32434_wdt_device.io_lock);
-	pr_info(PFX "Stopped watchdog timer.\n");
+	pr_info("Stopped watchdog timer.\n");
 }
 
 static void rc32434_wdt_ping(void)
@@ -160,8 +159,7 @@ static int rc32434_wdt_release(struct inode *inode, struct file *file)
 		rc32434_wdt_stop();
 		module_put(THIS_MODULE);
 	} else {
-		pr_crit(PFX
-			"device closed unexpectedly. WDT will not stop!\n");
+		pr_crit("device closed unexpectedly. WDT will not stop!\n");
 		rc32434_wdt_ping();
 	}
 	clear_bit(0, &rc32434_wdt_device.inuse);
@@ -262,9 +260,6 @@ static struct miscdevice rc32434_wdt_miscdev = {
 	.fops	= &rc32434_wdt_fops,
 };
 
-static char banner[] __devinitdata = KERN_INFO PFX
-		"Watchdog Timer version " VERSION ", timer margin: %d sec\n";
-
 static int __devinit rc32434_wdt_probe(struct platform_device *pdev)
 {
 	int ret;
@@ -272,13 +267,15 @@ static int __devinit rc32434_wdt_probe(struct platform_device *pdev)
 
 	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "rb532_wdt_res");
 	if (!r) {
-		pr_err(PFX "failed to retrieve resources\n");
+		pr_err_section(__devinitconst,
+			       "failed to retrieve resources\n");
 		return -ENODEV;
 	}
 
 	wdt_reg = ioremap_nocache(r->start, r->end - r->start);
 	if (!wdt_reg) {
-		pr_err(PFX "failed to remap I/O resources\n");
+		pr_err_section(__devinitconst,
+			       "failed to remap I/O resources\n");
 		return -ENXIO;
 	}
 
@@ -291,18 +288,21 @@ static int __devinit rc32434_wdt_probe(struct platform_device *pdev)
 	 * if not reset to the default */
 	if (rc32434_wdt_set(timeout)) {
 		rc32434_wdt_set(WATCHDOG_TIMEOUT);
-		pr_info(PFX
-			"timeout value must be between 0 and %d\n",
-			WTCOMP2SEC((u32)-1));
+		pr_info_section(__devinitconst,
+				"timeout value must be between 0 and %d\n",
+				WTCOMP2SEC((u32)-1));
 	}
 
 	ret = misc_register(&rc32434_wdt_miscdev);
 	if (ret < 0) {
-		pr_err(PFX "failed to register watchdog device\n");
+		pr_err_section(__devinitconst,
+			       "failed to register watchdog device\n");
 		goto unmap;
 	}
 
-	printk(banner, timeout);
+	pr_info_section(__devinitconst,
+			"Watchdog Timer version " VERSION 
+			", timer margin: %d sec\n", timeout);
 
 	return 0;
 
diff --git a/drivers/watchdog/rdc321x_wdt.c b/drivers/watchdog/rdc321x_wdt.c
index 7c39d47..28d96a4 100644
--- a/drivers/watchdog/rdc321x_wdt.c
+++ b/drivers/watchdog/rdc321x_wdt.c
@@ -21,6 +21,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -222,7 +224,8 @@ static int __devinit rdc321x_wdt_probe(struct platform_device *pdev)
 
 	err = misc_register(&rdc321x_wdt_misc);
 	if (err < 0) {
-		pr_err(PFX "watchdog misc_register failed\n");
+		pr_err_section(__devinitconst,
+			       "watchdog misc_register failed\n");
 		return err;
 	}
 
@@ -240,7 +243,7 @@ static int __devinit rdc321x_wdt_probe(struct platform_device *pdev)
 
 	rdc321x_wdt_device.default_ticks = ticks;
 
-	pr_info(PFX "watchdog init success\n");
+	pr_info_section(__devinitconst, "watchdog init success\n");
 
 	return 0;
 }
diff --git a/drivers/watchdog/riowd.c b/drivers/watchdog/riowd.c
index 04bd27d..f7c5b92 100644
--- a/drivers/watchdog/riowd.c
+++ b/drivers/watchdog/riowd.c
@@ -3,6 +3,8 @@
  * Copyright (C) 2001, 2008 David S. Miller (davem@davemloft.net)
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/types.h>
@@ -48,7 +50,6 @@ MODULE_SUPPORTED_DEVICE("watchdog");
 MODULE_LICENSE("GPL");
 
 #define DRIVER_NAME	"riowd"
-#define PFX		DRIVER_NAME ": "
 
 struct riowd {
 	void __iomem		*regs;
@@ -191,18 +192,18 @@ static int __devinit riowd_probe(struct of_device *op,
 
 	p->regs = of_ioremap(&op->resource[0], 0, 2, DRIVER_NAME);
 	if (!p->regs) {
-		pr_err(PFX "Cannot map registers.\n");
+		pr_err("Cannot map registers.\n");
 		goto out_free;
 	}
 
 	err = misc_register(&riowd_miscdev);
 	if (err) {
-		pr_err(PFX "Cannot register watchdog misc device.\n");
+		pr_err("Cannot register watchdog misc device.\n");
 		goto out_iounmap;
 	}
 
-	pr_info(PFX "Hardware watchdog [%i minutes], "
-	       "regs at %p\n", riowd_timeout, p->regs);
+	pr_info("Hardware watchdog [%i minutes], regs at %p\n",
+		riowd_timeout, p->regs);
 
 	dev_set_drvdata(&op->dev, p);
 	riowd_device = p;
diff --git a/drivers/watchdog/rm9k_wdt.c b/drivers/watchdog/rm9k_wdt.c
index c4110c5..d9e95e9 100644
--- a/drivers/watchdog/rm9k_wdt.c
+++ b/drivers/watchdog/rm9k_wdt.c
@@ -124,8 +124,7 @@ static irqreturn_t wdt_gpi_irqhdl(int irq, void *ctxt)
 	__raw_writel(0x1, wd_regs + 0x0008);
 
 
-	pr_crit("%s: watchdog expired - resetting system\n",
-		wdt_gpi_name);
+	pr_crit("%s: watchdog expired - resetting system\n", wdt_gpi_name);
 
 	*(volatile char *) flagaddr |= 0x01;
 	*(volatile char *) resetaddr = powercycle ? 0x01 : 0x2;
@@ -218,11 +217,10 @@ static int wdt_gpi_release(struct inode *inode, struct file *file)
 		if (expect_close) {
 			wdt_gpi_stop();
 			free_irq(wd_irq, &miscdev);
-			pr_info("%s: watchdog stopped\n",
-							wdt_gpi_name);
+			pr_info("%s: watchdog stopped\n", wdt_gpi_name);
 		} else {
-			pr_crit("%s: unexpected close() -"
-				" watchdog left running\n",
+			pr_crit("%s: unexpected close() - "
+				"watchdog left running\n",
 				wdt_gpi_name);
 			wdt_gpi_set_timeout(timeout);
 			__module_get(THIS_MODULE);
diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index 27515fc..e60655b 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -23,6 +23,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -44,8 +46,6 @@
 
 #include <plat/regs-watchdog.h>
 
-#define PFX "s3c2410-wdt: "
-
 #define CONFIG_S3C2410_WATCHDOG_ATBOOT		(0)
 #define CONFIG_S3C2410_WATCHDOG_DEFAULT_TIME	(15)
 
@@ -86,7 +86,7 @@ static DEFINE_SPINLOCK(wdt_lock);
 
 #define DBG(msg...) do { \
 	if (debug) \
-		pr_info(msg); \
+		pr_info(msg);			\
 	} while (0)
 
 /* functions */
@@ -497,8 +497,8 @@ static int s3c2410wdt_resume(struct platform_device *dev)
 	writel(wtdat_save, wdt_base + S3C2410_WTCNT); /* Reset count */
 	writel(wtcon_save, wdt_base + S3C2410_WTCON);
 
-	pr_info(PFX "watchdog %sabled\n",
-	       (wtcon_save & S3C2410_WTCON_ENABLE) ? "en" : "dis");
+	pr_info("watchdog %sabled\n",
+		(wtcon_save & S3C2410_WTCON_ENABLE) ? "en" : "dis");
 
 	return 0;
 }
diff --git a/drivers/watchdog/sa1100_wdt.c b/drivers/watchdog/sa1100_wdt.c
index 1fb2ac9..d54e04d 100644
--- a/drivers/watchdog/sa1100_wdt.c
+++ b/drivers/watchdog/sa1100_wdt.c
@@ -17,6 +17,9 @@
  *
  *	27/11/2000 Initial release
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -66,7 +69,7 @@ static int sa1100dog_open(struct inode *inode, struct file *file)
  */
 static int sa1100dog_release(struct inode *inode, struct file *file)
 {
-	pr_crit("WATCHDOG: Device closed - timer will not stop\n");
+	pr_crit("Device closed - timer will not stop\n");
 	clear_bit(1, &sa1100wdt_users);
 	return 0;
 }
@@ -170,7 +173,7 @@ static int __init sa1100dog_init(void)
 	ret = misc_register(&sa1100dog_miscdev);
 	if (ret == 0)
 		pr_info("SA1100/PXA2xx Watchdog Timer: timer margin %d sec\n",
-						margin);
+			margin);
 	return ret;
 }
 
diff --git a/drivers/watchdog/sb_wdog.c b/drivers/watchdog/sb_wdog.c
index 5b82eeb..b43edc0 100644
--- a/drivers/watchdog/sb_wdog.c
+++ b/drivers/watchdog/sb_wdog.c
@@ -126,7 +126,7 @@ static int sbwdog_release(struct inode *inode, struct file *file)
 		module_put(THIS_MODULE);
 	} else {
 		pr_crit("%s: Unexpected close, not stopping watchdog!\n",
-						ident.identity);
+			ident.identity);
 		sbwdog_pet(user_dog);
 	}
 	clear_bit(0, &sbwdog_gate);
@@ -290,7 +290,7 @@ static int __init sbwdog_init(void)
 	ret = register_reboot_notifier(&sbwdog_notifier);
 	if (ret) {
 		pr_err("%s: cannot register reboot notifier (err=%d)\n",
-						ident.identity, ret);
+		       ident.identity, ret);
 		return ret;
 	}
 
@@ -302,15 +302,15 @@ static int __init sbwdog_init(void)
 		ident.identity, (void *)user_dog);
 	if (ret) {
 		pr_err("%s: failed to request irq 1 - %d\n",
-						ident.identity, ret);
+		       ident.identity, ret);
 		return ret;
 	}
 
 	ret = misc_register(&sbwdog_miscdev);
 	if (ret == 0) {
 		pr_info("%s: timeout is %ld.%ld secs\n",
-				ident.identity,
-				timeout / 1000000, (timeout / 100000) % 10);
+			ident.identity,
+			timeout / 1000000, (timeout / 100000) % 10);
 	} else
 		free_irq(1, (void *)user_dog);
 	return ret;
@@ -345,9 +345,9 @@ void platform_wd_setup(void)
 	ret = request_irq(1, sbwdog_interrupt, IRQF_DISABLED | IRQF_SHARED,
 		"Kernel Watchdog", IOADDR(A_SCD_WDOG_CFG_0));
 	if (ret) {
-		pr_crit("Watchdog IRQ zero(0) failed to be requested - %d\n", ret);
+	pr_crit("Watchdog IRQ zero(0) failed to be requested - %d\n", ret);
+	}
 	}
-}
 
 
  */
diff --git a/drivers/watchdog/sbc60xxwdt.c b/drivers/watchdog/sbc60xxwdt.c
index d51a15c..a2a62a6 100644
--- a/drivers/watchdog/sbc60xxwdt.c
+++ b/drivers/watchdog/sbc60xxwdt.c
@@ -48,6 +48,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -65,9 +67,6 @@
 
 #include <asm/system.h>
 
-#define OUR_NAME "sbc60xxwdt"
-#define PFX OUR_NAME ": "
-
 /*
  * You must set these - The driver cannot probe for the settings
  */
@@ -132,8 +131,7 @@ static void wdt_timer_ping(unsigned long data)
 		/* Re-set the timer interval */
 		mod_timer(&timer, jiffies + WDT_INTERVAL);
 	} else
-		pr_warning(PFX
-			"Heartbeat lost! Will not ping the watchdog\n");
+		pr_warning("Heartbeat lost! Will not ping the watchdog\n");
 }
 
 /*
@@ -146,7 +144,7 @@ static void wdt_startup(void)
 
 	/* Start the timer */
 	mod_timer(&timer, jiffies + WDT_INTERVAL);
-	pr_info(PFX "Watchdog timer is now enabled.\n");
+	pr_info("Watchdog timer is now enabled.\n");
 }
 
 static void wdt_turnoff(void)
@@ -154,7 +152,7 @@ static void wdt_turnoff(void)
 	/* Stop the timer */
 	del_timer(&timer);
 	inb_p(wdt_stop);
-	pr_info(PFX "Watchdog timer is now disabled...\n");
+	pr_info("Watchdog timer is now disabled...\n");
 }
 
 static void wdt_keepalive(void)
@@ -217,8 +215,7 @@ static int fop_close(struct inode *inode, struct file *file)
 		wdt_turnoff();
 	else {
 		del_timer(&timer);
-		pr_crit(PFX
-		  "device file closed unexpectedly. Will not stop the WDT!\n");
+		pr_crit("device file closed unexpectedly. Will not stop the WDT!\n");
 	}
 	clear_bit(0, &wdt_is_open);
 	wdt_expect_close = 0;
@@ -335,14 +332,13 @@ static int __init sbc60xxwdt_init(void)
 
 	if (timeout < 1 || timeout > 3600) { /* arbitrary upper limit */
 		timeout = WATCHDOG_TIMEOUT;
-		pr_info(PFX
-			"timeout value must be 1 <= x <= 3600, using %d\n",
-								timeout);
+		pr_info("timeout value must be 1 <= x <= 3600, using %d\n",
+			timeout);
 	}
 
 	if (!request_region(wdt_start, 1, "SBC 60XX WDT")) {
-		pr_err(PFX "I/O address 0x%04x already in use\n",
-			wdt_start);
+		pr_err("I/O address 0x%04x already in use\n",
+		       wdt_start);
 		rc = -EIO;
 		goto err_out;
 	}
@@ -350,9 +346,8 @@ static int __init sbc60xxwdt_init(void)
 	/* We cannot reserve 0x45 - the kernel already has! */
 	if (wdt_stop != 0x45 && wdt_stop != wdt_start) {
 		if (!request_region(wdt_stop, 1, "SBC 60XX WDT")) {
-			pr_err(PFX
-				"I/O address 0x%04x already in use\n",
-							wdt_stop);
+			pr_err("I/O address 0x%04x already in use\n",
+			       wdt_stop);
 			rc = -EIO;
 			goto err_out_region1;
 		}
@@ -360,20 +355,17 @@ static int __init sbc60xxwdt_init(void)
 
 	rc = register_reboot_notifier(&wdt_notifier);
 	if (rc) {
-		pr_err(PFX
-			"cannot register reboot notifier (err=%d)\n", rc);
+		pr_err("cannot register reboot notifier (err=%d)\n", rc);
 		goto err_out_region2;
 	}
 
 	rc = misc_register(&wdt_miscdev);
 	if (rc) {
-		pr_err(PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-						wdt_miscdev.minor, rc);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       wdt_miscdev.minor, rc);
 		goto err_out_reboot;
 	}
-	pr_info(PFX
-		"WDT driver for 60XX single board computer initialised. "
+	pr_info("WDT driver for 60XX single board computer initialised. "
 		"timeout=%d sec (nowayout=%d)\n", timeout, nowayout);
 
 	return 0;
diff --git a/drivers/watchdog/sbc7240_wdt.c b/drivers/watchdog/sbc7240_wdt.c
index 241a091..85d42a5 100644
--- a/drivers/watchdog/sbc7240_wdt.c
+++ b/drivers/watchdog/sbc7240_wdt.c
@@ -16,6 +16,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/ioport.h>
@@ -32,8 +34,6 @@
 #include <asm/atomic.h>
 #include <asm/system.h>
 
-#define SBC7240_PREFIX "sbc7240_wdt: "
-
 #define SBC7240_ENABLE_PORT		0x443
 #define SBC7240_DISABLE_PORT		0x043
 #define SBC7240_SET_TIMEOUT_PORT	SBC7240_ENABLE_PORT
@@ -65,8 +65,7 @@ static void wdt_disable(void)
 	/* disable the watchdog */
 	if (test_and_clear_bit(SBC7240_ENABLED_STATUS_BIT, &wdt_status)) {
 		inb_p(SBC7240_DISABLE_PORT);
-		pr_info(SBC7240_PREFIX
-		       "Watchdog timer is now disabled.\n");
+		pr_info("Watchdog timer is now disabled.\n");
 	}
 }
 
@@ -75,23 +74,20 @@ static void wdt_enable(void)
 	/* enable the watchdog */
 	if (!test_and_set_bit(SBC7240_ENABLED_STATUS_BIT, &wdt_status)) {
 		inb_p(SBC7240_ENABLE_PORT);
-		pr_info(SBC7240_PREFIX
-		       "Watchdog timer is now enabled.\n");
+		pr_info("Watchdog timer is now enabled.\n");
 	}
 }
 
 static int wdt_set_timeout(int t)
 {
 	if (t < 1 || t > SBC7240_MAX_TIMEOUT) {
-		pr_err(SBC7240_PREFIX
-		       "timeout value must be 1<=x<=%d\n",
-		       SBC7240_MAX_TIMEOUT);
+		pr_err("timeout value must be 1<=x<=%d\n", SBC7240_MAX_TIMEOUT);
 		return -1;
 	}
 	/* set the timeout */
 	outb_p((unsigned)t, SBC7240_SET_TIMEOUT_PORT);
 	timeout = t;
-	pr_info(SBC7240_PREFIX "timeout set to %d seconds\n", t);
+	pr_info("timeout set to %d seconds\n", t);
 	return 0;
 }
 
@@ -150,8 +146,7 @@ static int fop_close(struct inode *inode, struct file *file)
 	    || !nowayout) {
 		wdt_disable();
 	} else {
-		pr_crit(SBC7240_PREFIX
-		       "Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		wdt_keepalive();
 	}
 
@@ -252,7 +247,7 @@ static struct notifier_block wdt_notifier = {
 
 static void __exit sbc7240_wdt_unload(void)
 {
-	pr_info(SBC7240_PREFIX "Removing watchdog\n");
+	pr_info("Removing watchdog\n");
 	misc_deregister(&wdt_miscdev);
 
 	unregister_reboot_notifier(&wdt_notifier);
@@ -264,8 +259,7 @@ static int __init sbc7240_wdt_init(void)
 	int rc = -EBUSY;
 
 	if (!request_region(SBC7240_ENABLE_PORT, 1, "SBC7240 WDT")) {
-		pr_err(SBC7240_PREFIX
-		       "I/O address 0x%04x already in use\n",
+		pr_err("I/O address 0x%04x already in use\n",
 		       SBC7240_ENABLE_PORT);
 		rc = -EIO;
 		goto err_out;
@@ -277,31 +271,27 @@ static int __init sbc7240_wdt_init(void)
 
 	if (timeout < 1 || timeout > SBC7240_MAX_TIMEOUT) {
 		timeout = SBC7240_TIMEOUT;
-		pr_info(SBC7240_PREFIX
-		       "timeout value must be 1<=x<=%d, using %d\n",
-		       SBC7240_MAX_TIMEOUT, timeout);
+		pr_info("timeout value must be 1<=x<=%d, using %d\n",
+			SBC7240_MAX_TIMEOUT, timeout);
 	}
 	wdt_set_timeout(timeout);
 	wdt_disable();
 
 	rc = register_reboot_notifier(&wdt_notifier);
 	if (rc) {
-		pr_err(SBC7240_PREFIX
-		       "cannot register reboot notifier (err=%d)\n", rc);
+		pr_err("cannot register reboot notifier (err=%d)\n", rc);
 		goto err_out_region;
 	}
 
 	rc = misc_register(&wdt_miscdev);
 	if (rc) {
-		pr_err(SBC7240_PREFIX
-		       "cannot register miscdev on minor=%d (err=%d)\n",
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
 		       wdt_miscdev.minor, rc);
 		goto err_out_reboot_notifier;
 	}
 
-	pr_info(SBC7240_PREFIX
-	       "Watchdog driver for SBC7240 initialised (nowayout=%d)\n",
-	       nowayout);
+	pr_info("Watchdog driver for SBC7240 initialised (nowayout=%d)\n",
+		nowayout);
 
 	return 0;
 
diff --git a/drivers/watchdog/sbc8360.c b/drivers/watchdog/sbc8360.c
index 5fc2ee1..400bd25 100644
--- a/drivers/watchdog/sbc8360.c
+++ b/drivers/watchdog/sbc8360.c
@@ -36,6 +36,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/miscdevice.h>
@@ -56,8 +58,6 @@
 static unsigned long sbc8360_is_open;
 static char expect_close;
 
-#define PFX "sbc8360: "
-
 /*
  *
  * Watchdog Timer Configuration
@@ -280,8 +280,8 @@ static int sbc8360_close(struct inode *inode, struct file *file)
 	if (expect_close == 42)
 		sbc8360_stop();
 	else
-		pr_crit(PFX "SBC8360 device closed unexpectedly.  "
-						"SBC8360 will not stop!\n");
+		pr_crit("SBC8360 device closed unexpectedly.  "
+			"SBC8360 will not stop!\n");
 
 	clear_bit(0, &sbc8360_is_open);
 	expect_close = 0;
@@ -334,20 +334,19 @@ static int __init sbc8360_init(void)
 	unsigned long int mseconds = 60000;
 
 	if (timeout < 0 || timeout > 63) {
-		pr_err(PFX "Invalid timeout index (must be 0-63).\n");
+		pr_err("Invalid timeout index (must be 0-63).\n");
 		res = -EINVAL;
 		goto out;
 	}
 
 	if (!request_region(SBC8360_ENABLE, 1, "SBC8360")) {
-		pr_err(PFX "ENABLE method I/O %X is not available.\n",
+		pr_err("ENABLE method I/O %X is not available.\n",
 		       SBC8360_ENABLE);
 		res = -EIO;
 		goto out;
 	}
 	if (!request_region(SBC8360_BASETIME, 1, "SBC8360")) {
-		pr_err(PFX
-		       "BASETIME method I/O %X is not available.\n",
+		pr_err("BASETIME method I/O %X is not available.\n",
 		       SBC8360_BASETIME);
 		res = -EIO;
 		goto out_nobasetimereg;
@@ -355,13 +354,13 @@ static int __init sbc8360_init(void)
 
 	res = register_reboot_notifier(&sbc8360_notifier);
 	if (res) {
-		pr_err(PFX "Failed to register reboot notifier.\n");
+		pr_err("Failed to register reboot notifier.\n");
 		goto out_noreboot;
 	}
 
 	res = misc_register(&sbc8360_miscdev);
 	if (res) {
-		pr_err(PFX "failed to register misc device\n");
+		pr_err("failed to register misc device\n");
 		goto out_nomisc;
 	}
 
@@ -378,7 +377,7 @@ static int __init sbc8360_init(void)
 		mseconds = (wd_margin + 1) * 100000;
 
 	/* My kingdom for the ability to print "0.5 seconds" in the kernel! */
-	pr_info(PFX "Timeout set at %ld ms.\n", mseconds);
+	pr_info("Timeout set at %ld ms.\n", mseconds);
 
 	return 0;
 
diff --git a/drivers/watchdog/sbc_epx_c3.c b/drivers/watchdog/sbc_epx_c3.c
index 9cc207f..ae211af 100644
--- a/drivers/watchdog/sbc_epx_c3.c
+++ b/drivers/watchdog/sbc_epx_c3.c
@@ -13,6 +13,8 @@
  *	based on softdog.c by Alan Cox <alan@lxorguk.ukuu.org.uk>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -28,7 +30,6 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 
-#define PFX "epx_c3: "
 static int epx_c3_alive;
 
 #define WATCHDOG_TIMEOUT 1		/* 1 sec default timeout */
@@ -51,7 +52,7 @@ static void epx_c3_stop(void)
 
 	outb(0, EPXC3_WATCHDOG_CTL_REG);
 
-	pr_info(PFX "Stopped watchdog timer.\n");
+	pr_info("Stopped watchdog timer.\n");
 }
 
 static void epx_c3_pet(void)
@@ -173,9 +174,6 @@ static struct notifier_block epx_c3_notifier = {
 	.notifier_call = epx_c3_notify_sys,
 };
 
-static const char banner[] __initdata = KERN_INFO PFX
-	"Hardware Watchdog Timer for Winsystems EPX-C3 SBC: 0.1\n";
-
 static int __init watchdog_init(void)
 {
 	int ret;
@@ -185,20 +183,23 @@ static int __init watchdog_init(void)
 
 	ret = register_reboot_notifier(&epx_c3_notifier);
 	if (ret) {
-		pr_err(PFX "cannot register reboot notifier "
-			"(err=%d)\n", ret);
+		pr_err_section(__initdata,
+			       "cannot register reboot notifier (err=%d)\n",
+			       ret);
 		goto out;
 	}
 
 	ret = misc_register(&epx_c3_miscdev);
 	if (ret) {
-		pr_err(PFX "cannot register miscdev on minor=%d "
-			"(err=%d)\n", WATCHDOG_MINOR, ret);
+		pr_err_section(__initdata,
+			       "cannot register miscdev on minor=%d (err=%d)\n",
+			       WATCHDOG_MINOR, ret);
 		unregister_reboot_notifier(&epx_c3_notifier);
 		goto out;
 	}
 
-	printk(banner);
+	pr_info_section(__initdata,
+		"Hardware Watchdog Timer for Winsystems EPX-C3 SBC: 0.1\n");
 
 	return 0;
 
diff --git a/drivers/watchdog/sc1200wdt.c b/drivers/watchdog/sc1200wdt.c
index 637c707..d7d684e 100644
--- a/drivers/watchdog/sc1200wdt.c
+++ b/drivers/watchdog/sc1200wdt.c
@@ -31,6 +31,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/miscdevice.h>
@@ -48,7 +50,6 @@
 
 #define SC1200_MODULE_VER	"build 20020303"
 #define SC1200_MODULE_NAME	"sc1200wdt"
-#define PFX			SC1200_MODULE_NAME ": "
 
 #define	MAX_TIMEOUT	255	/* 255 minutes */
 #define PMIR		(io)	/* Power Management Index Register */
@@ -71,7 +72,6 @@
 #define UART2_IRQ	0x04	/* Serial1 */
 /* 5 -7 are reserved */
 
-static char banner[] __initdata = PFX SC1200_MODULE_VER;
 static int timeout = 1;
 static int io = -1;
 static int io_len = 2;		/* for non plug and play */
@@ -176,7 +176,7 @@ static int sc1200wdt_open(struct inode *inode, struct file *file)
 		timeout = MAX_TIMEOUT;
 
 	sc1200wdt_start();
-	pr_info(PFX "Watchdog enabled, timeout = %d min(s)", timeout);
+	pr_info("Watchdog enabled, timeout = %d min(s)", timeout);
 
 	return nonseekable_open(inode, file);
 }
@@ -254,11 +254,10 @@ static int sc1200wdt_release(struct inode *inode, struct file *file)
 {
 	if (expect_close == 42) {
 		sc1200wdt_stop();
-		pr_info(PFX "Watchdog disabled\n");
+		pr_info("Watchdog disabled\n");
 	} else {
 		sc1200wdt_write_data(WDTO, timeout);
-		pr_crit(PFX
-			"Unexpected close!, timeout = %d min(s)\n", timeout);
+		pr_crit("Unexpected close!, timeout = %d min(s)\n", timeout);
 	}
 	clear_bit(0, &open_flag);
 	expect_close = 0;
@@ -361,12 +360,11 @@ static int scl200wdt_pnp_probe(struct pnp_dev *dev,
 	io_len = pnp_port_len(wdt_dev, 0);
 
 	if (!request_region(io, io_len, SC1200_MODULE_NAME)) {
-		pr_err(PFX "Unable to register IO port %#x\n", io);
+		pr_err("Unable to register IO port %#x\n", io);
 		return -EBUSY;
 	}
 
-	pr_info("scl200wdt: PnP device found at io port %#x/%d\n",
-								io, io_len);
+	pr_info("scl200wdt: PnP device found at io port %#x/%d\n", io, io_len);
 	return 0;
 }
 
@@ -392,7 +390,7 @@ static int __init sc1200wdt_init(void)
 {
 	int ret;
 
-	pr_info("%s\n", banner);
+	pr_info_section(__initdata, SC1200_MODULE_VER);
 
 #if defined CONFIG_PNP
 	if (isapnp) {
@@ -403,7 +401,7 @@ static int __init sc1200wdt_init(void)
 #endif
 
 	if (io == -1) {
-		pr_err(PFX "io parameter must be specified\n");
+		pr_err_section(__initdata, "io parameter must be specified\n");
 		ret = -EINVAL;
 		goto out_pnp;
 	}
@@ -416,7 +414,8 @@ static int __init sc1200wdt_init(void)
 #endif
 
 	if (!request_region(io, io_len, SC1200_MODULE_NAME)) {
-		pr_err(PFX "Unable to register IO port %#x\n", io);
+		pr_err_section(__initdata, "Unable to register IO port %#x\n",
+			       io);
 		ret = -EBUSY;
 		goto out_pnp;
 	}
@@ -427,16 +426,17 @@ static int __init sc1200wdt_init(void)
 
 	ret = register_reboot_notifier(&sc1200wdt_notifier);
 	if (ret) {
-		pr_err(PFX
-			"Unable to register reboot notifier err = %d\n", ret);
+		pr_err_section(__initdata,
+			       "Unable to register reboot notifier err = %d\n",
+			       ret);
 		goto out_io;
 	}
 
 	ret = misc_register(&sc1200wdt_miscdev);
 	if (ret) {
-		pr_err(PFX
-			"Unable to register miscdev on minor %d\n",
-							WATCHDOG_MINOR);
+		pr_err_section(__initdata,
+			       "Unable to register miscdev on minor %d\n",
+			       WATCHDOG_MINOR);
 		goto out_rbt;
 	}
 
diff --git a/drivers/watchdog/sc520_wdt.c b/drivers/watchdog/sc520_wdt.c
index ab50e9e..f982990 100644
--- a/drivers/watchdog/sc520_wdt.c
+++ b/drivers/watchdog/sc520_wdt.c
@@ -52,6 +52,8 @@
  *  This driver uses memory mapped IO, and spinlock.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -69,9 +71,6 @@
 
 #include <asm/system.h>
 
-#define OUR_NAME "sc520_wdt"
-#define PFX OUR_NAME ": "
-
 /*
  * The AMD Elan SC520 timeout value is 492us times a power of 2 (0-7)
  *
@@ -151,8 +150,7 @@ static void wdt_timer_ping(unsigned long data)
 		/* Re-set the timer interval */
 		mod_timer(&timer, jiffies + WDT_INTERVAL);
 	} else
-		pr_warning(PFX
-			"Heartbeat lost! Will not ping the watchdog\n");
+		pr_warning("Heartbeat lost! Will not ping the watchdog\n");
 }
 
 /*
@@ -187,7 +185,7 @@ static int wdt_startup(void)
 	/* Start the watchdog */
 	wdt_config(WDT_ENB | WDT_WRST_ENB | WDT_EXP_SEL_04);
 
-	pr_info(PFX "Watchdog timer is now enabled.\n");
+	pr_info("Watchdog timer is now enabled.\n");
 	return 0;
 }
 
@@ -199,7 +197,7 @@ static int wdt_turnoff(void)
 	/* Stop the watchdog */
 	wdt_config(0);
 
-	pr_info(PFX "Watchdog timer is now disabled...\n");
+	pr_info("Watchdog timer is now disabled...\n");
 	return 0;
 }
 
@@ -270,8 +268,7 @@ static int fop_close(struct inode *inode, struct file *file)
 	if (wdt_expect_close == 42)
 		wdt_turnoff();
 	else {
-		pr_crit(PFX
-			"Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		wdt_keepalive();
 	}
 	clear_bit(0, &wdt_is_open);
@@ -393,36 +390,32 @@ static int __init sc520_wdt_init(void)
 	   if not reset to the default */
 	if (wdt_set_heartbeat(timeout)) {
 		wdt_set_heartbeat(WATCHDOG_TIMEOUT);
-		pr_info(PFX
-		    "timeout value must be 1 <= timeout <= 3600, using %d\n",
-							WATCHDOG_TIMEOUT);
+		pr_info("timeout value must be 1 <= timeout <= 3600, using %d\n",
+			WATCHDOG_TIMEOUT);
 	}
 
 	wdtmrctl = ioremap((unsigned long)(MMCR_BASE + OFFS_WDTMRCTL), 2);
 	if (!wdtmrctl) {
-		pr_err(PFX "Unable to remap memory\n");
+		pr_err("Unable to remap memory\n");
 		rc = -ENOMEM;
 		goto err_out_region2;
 	}
 
 	rc = register_reboot_notifier(&wdt_notifier);
 	if (rc) {
-		pr_err(PFX
-			"cannot register reboot notifier (err=%d)\n", rc);
+		pr_err("cannot register reboot notifier (err=%d)\n", rc);
 		goto err_out_ioremap;
 	}
 
 	rc = misc_register(&wdt_miscdev);
 	if (rc) {
-		pr_err(PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-							WATCHDOG_MINOR, rc);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, rc);
 		goto err_out_notifier;
 	}
 
-	pr_info(PFX
-	   "WDT driver for SC520 initialised. timeout=%d sec (nowayout=%d)\n",
-							timeout, nowayout);
+	pr_info("WDT driver for SC520 initialised. timeout=%d sec (nowayout=%d)\n",
+		timeout, nowayout);
 
 	return 0;
 
diff --git a/drivers/watchdog/sch311x_wdt.c b/drivers/watchdog/sch311x_wdt.c
index 3a15d36..41e3ca5 100644
--- a/drivers/watchdog/sch311x_wdt.c
+++ b/drivers/watchdog/sch311x_wdt.c
@@ -18,6 +18,8 @@
  *	Includes, defines, variables, module parameters, ...
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 /* Includes */
 #include <linux/module.h>		/* For module specific items */
 #include <linux/moduleparam.h>		/* For new moduleparam's */
@@ -37,7 +39,6 @@
 
 /* Module and version information */
 #define DRV_NAME	"sch311x_wdt"
-#define PFX		DRV_NAME ": "
 
 /* Runtime registers */
 #define RESGEN			0x1d
@@ -323,8 +324,7 @@ static int sch311x_wdt_close(struct inode *inode, struct file *file)
 	if (sch311x_wdt_expect_close == 42) {
 		sch311x_wdt_stop();
 	} else {
-		pr_crit(PFX
-				"Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		sch311x_wdt_keepalive();
 	}
 	clear_bit(0, &sch311x_wdt_is_open);
@@ -509,19 +509,19 @@ static int __init sch311x_detect(int sio_config_port, unsigned short *addr)
 
 	/* Check if Logical Device Register is currently active */
 	if (sch311x_sio_inb(sio_config_port, 0x30) && 0x01 == 0)
-		pr_info(PFX "Seems that LDN 0x0a is not active...\n");
+		pr_info("Seems that LDN 0x0a is not active...\n");
 
 	/* Get the base address of the runtime registers */
 	base_addr = (sch311x_sio_inb(sio_config_port, 0x60) << 8) |
 			   sch311x_sio_inb(sio_config_port, 0x61);
 	if (!base_addr) {
-		pr_err(PFX "Base address not set.\n");
+		pr_err("Base address not set.\n");
 		err = -ENODEV;
 		goto exit;
 	}
 	*addr = base_addr;
 
-	pr_info(PFX "Found an SMSC SCH311%d chip at 0x%04x\n",
+	pr_info("Found an SMSC SCH311%d chip at 0x%04x\n",
 		dev_id, base_addr);
 
 exit:
diff --git a/drivers/watchdog/scx200_wdt.c b/drivers/watchdog/scx200_wdt.c
index aa7d002..66f1a4f 100644
--- a/drivers/watchdog/scx200_wdt.c
+++ b/drivers/watchdog/scx200_wdt.c
@@ -17,6 +17,8 @@
    of any nature resulting due to the use of this software. This
    software is provided AS-IS with no warranties. */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/init.h>
@@ -30,13 +32,13 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 
-#define NAME "scx200_wdt"
-
 MODULE_AUTHOR("Christer Weinigel <wingel@nano-system.com>");
 MODULE_DESCRIPTION("NatSemi SCx200 Watchdog Driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 
+#define NAME KBUILD_MODNAME ": "
+
 static int margin = 60;		/* in seconds */
 module_param(margin, int, 0);
 MODULE_PARM_DESC(margin, "Watchdog margin in seconds");
@@ -66,13 +68,13 @@ static void scx200_wdt_ping(void)
 
 static void scx200_wdt_update_margin(void)
 {
-	pr_info(NAME ": timer margin %d seconds\n", margin);
+	pr_info("timer margin %d seconds\n", margin);
 	wdto_restart = margin * W_SCALE;
 }
 
 static void scx200_wdt_enable(void)
 {
-	printk(KERN_DEBUG NAME ": enabling watchdog timer, wdto_restart = %d\n",
+	printk(KERN_DEBUG NAME "enabling watchdog timer, wdto_restart = %d\n",
 	       wdto_restart);
 
 	spin_lock(&scx_lock);
@@ -86,7 +88,7 @@ static void scx200_wdt_enable(void)
 
 static void scx200_wdt_disable(void)
 {
-	printk(KERN_DEBUG NAME ": disabling watchdog timer\n");
+	printk(KERN_DEBUG NAME "disabling watchdog timer\n");
 
 	spin_lock(&scx_lock);
 	outw(0, scx200_cb_base + SCx200_WDT_WDTO);
@@ -108,9 +110,8 @@ static int scx200_wdt_open(struct inode *inode, struct file *file)
 static int scx200_wdt_release(struct inode *inode, struct file *file)
 {
 	if (expect_close != 42)
-		pr_warning(NAME
-			": watchdog device closed unexpectedly, "
-			"will not disable the watchdog timer\n");
+		pr_warning("watchdog device closed unexpectedly, "
+			   "will not disable the watchdog timer\n");
 	else if (!nowayout)
 		scx200_wdt_disable();
 	expect_close = 0;
@@ -219,7 +220,7 @@ static int __init scx200_wdt_init(void)
 {
 	int r;
 
-	printk(KERN_DEBUG NAME ": NatSemi SCx200 Watchdog Driver\n");
+	printk(KERN_DEBUG NAME "NatSemi SCx200 Watchdog Driver\n");
 
 	/* check that we have found the configuration block */
 	if (!scx200_cb_present())
@@ -228,7 +229,7 @@ static int __init scx200_wdt_init(void)
 	if (!request_region(scx200_cb_base + SCx200_WDT_OFFSET,
 			    SCx200_WDT_SIZE,
 			    "NatSemi SCx200 Watchdog")) {
-		pr_warning(NAME ": watchdog I/O region busy\n");
+		pr_warning("watchdog I/O region busy\n");
 		return -EBUSY;
 	}
 
@@ -237,7 +238,7 @@ static int __init scx200_wdt_init(void)
 
 	r = register_reboot_notifier(&scx200_wdt_notifier);
 	if (r) {
-		pr_err(NAME ": unable to register reboot notifier");
+		pr_err("unable to register reboot notifier");
 		release_region(scx200_cb_base + SCx200_WDT_OFFSET,
 				SCx200_WDT_SIZE);
 		return r;
diff --git a/drivers/watchdog/shwdt.c b/drivers/watchdog/shwdt.c
index 0203950..a554b69 100644
--- a/drivers/watchdog/shwdt.c
+++ b/drivers/watchdog/shwdt.c
@@ -17,6 +17,9 @@
  *     Added expect close support, made emulated timeout runtime changeable
  *     general cleanups, add some ioctls
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/init.h>
@@ -32,8 +35,6 @@
 #include <linux/uaccess.h>
 #include <asm/watchdog.h>
 
-#define PFX "shwdt: "
-
 /*
  * Default clock division ratio is 5.25 msecs. For an additional table of
  * values, consult the asm-sh/watchdog.h. Overload this at module load
@@ -201,8 +202,7 @@ static void sh_wdt_ping(unsigned long data)
 
 		mod_timer(&timer, next_ping_period(clock_division_ratio));
 	} else
-		pr_warning(PFX "Heartbeat lost! Will not ping "
-		       "the watchdog\n");
+		pr_warning("Heartbeat lost! Will not ping the watchdog\n");
 	spin_unlock_irqrestore(&shwdt_lock, flags);
 }
 
@@ -237,8 +237,7 @@ static int sh_wdt_close(struct inode *inode, struct file *file)
 	if (shwdt_expect_close == 42) {
 		sh_wdt_stop();
 	} else {
-		pr_crit(PFX "Unexpected close, not "
-		       "stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		sh_wdt_keepalive();
 	}
 
@@ -318,8 +317,7 @@ static int sh_wdt_mmap(struct file *file, struct vm_area_struct *vma)
 
 	if (io_remap_pfn_range(vma, vma->vm_start, addr >> PAGE_SHIFT,
 			       PAGE_SIZE, vma->vm_page_prot)) {
-		pr_err(PFX "%s: io_remap_pfn_range failed\n",
-		       __func__);
+		pr_err("%s: io_remap_pfn_range failed\n", __func__);
 		return -EAGAIN;
 	}
 
@@ -442,36 +440,32 @@ static int __init sh_wdt_init(void)
 
 	if (clock_division_ratio < 0x5 || clock_division_ratio > 0x7) {
 		clock_division_ratio = WTCSR_CKS_4096;
-		pr_info(PFX
-		  "clock_division_ratio value must be 0x5<=x<=0x7, using %d\n",
-				clock_division_ratio);
+		pr_info("clock_division_ratio value must be 0x5<=x<=0x7, using %d\n",
+			clock_division_ratio);
 	}
 
 	rc = sh_wdt_set_heartbeat(heartbeat);
 	if (unlikely(rc)) {
 		heartbeat = WATCHDOG_HEARTBEAT;
-		pr_info(PFX
-			"heartbeat value must be 1<=x<=3600, using %d\n",
-								heartbeat);
+		pr_info("heartbeat value must be 1<=x<=3600, using %d\n",
+			heartbeat);
 	}
 
 	rc = register_reboot_notifier(&sh_wdt_notifier);
 	if (unlikely(rc)) {
-		pr_err(PFX
-			"Can't register reboot notifier (err=%d)\n", rc);
+		pr_err("Can't register reboot notifier (err=%d)\n", rc);
 		return rc;
 	}
 
 	rc = misc_register(&sh_wdt_miscdev);
 	if (unlikely(rc)) {
-		pr_err(PFX
-			"Can't register miscdev on minor=%d (err=%d)\n",
-						sh_wdt_miscdev.minor, rc);
+		pr_err("Can't register miscdev on minor=%d (err=%d)\n",
+		       sh_wdt_miscdev.minor, rc);
 		unregister_reboot_notifier(&sh_wdt_notifier);
 		return rc;
 	}
 
-	pr_info(PFX "initialized. heartbeat=%d sec (nowayout=%d)\n",
+	pr_info("initialized. heartbeat=%d sec (nowayout=%d)\n",
 		heartbeat, nowayout);
 
 	return 0;
diff --git a/drivers/watchdog/smsc37b787_wdt.c b/drivers/watchdog/smsc37b787_wdt.c
index 7d2171e..06f4994 100644
--- a/drivers/watchdog/smsc37b787_wdt.c
+++ b/drivers/watchdog/smsc37b787_wdt.c
@@ -43,6 +43,8 @@
  *   Documentation/watchdog/watchdog.txt
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -70,7 +72,6 @@
 #define UNIT_SECOND     0
 #define UNIT_MINUTE     1
 
-#define MODNAME		"smsc37b787_wdt: "
 #define VERSION		"1.1"
 
 #define IOPORT		0x3F0
@@ -363,8 +364,7 @@ static int wb_smsc_wdt_open(struct inode *inode, struct file *file)
 	/* Reload and activate timer */
 	wb_smsc_wdt_enable();
 
-	pr_info(MODNAME
-		"Watchdog enabled. Timeout set to %d %s.\n",
+	pr_info("Watchdog enabled. Timeout set to %d %s.\n",
 		timeout, (unit == UNIT_SECOND) ? "second(s)" : "minute(s)");
 
 	return nonseekable_open(inode, file);
@@ -378,11 +378,9 @@ static int wb_smsc_wdt_release(struct inode *inode, struct file *file)
 
 	if (expect_close == 42) {
 		wb_smsc_wdt_disable();
-		pr_info(MODNAME
-				"Watchdog disabled, sleeping again...\n");
+		pr_info("Watchdog disabled, sleeping again...\n");
 	} else {
-		pr_crit(MODNAME
-				"Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		wb_smsc_wdt_reset_timer();
 	}
 
@@ -535,11 +533,10 @@ static int __init wb_smsc_wdt_init(void)
 	int ret;
 
 	pr_info("SMsC 37B787 watchdog component driver "
-					VERSION " initialising...\n");
+		VERSION " initialising...\n");
 
 	if (!request_region(IOPORT, IOPORT_SIZE, "SMsC 37B787 watchdog")) {
-		pr_err(MODNAME "Unable to register IO port %#x\n",
-								IOPORT);
+		pr_err("Unable to register IO port %#x\n", IOPORT);
 		ret = -EBUSY;
 		goto out_pnp;
 	}
@@ -553,25 +550,22 @@ static int __init wb_smsc_wdt_init(void)
 
 	ret = register_reboot_notifier(&wb_smsc_wdt_notifier);
 	if (ret) {
-		pr_err(MODNAME
-			"Unable to register reboot notifier err = %d\n", ret);
+		pr_err("Unable to register reboot notifier err = %d\n", ret);
 		goto out_io;
 	}
 
 	ret = misc_register(&wb_smsc_wdt_miscdev);
 	if (ret) {
-		pr_err(MODNAME
-			"Unable to register miscdev on minor %d\n",
-							WATCHDOG_MINOR);
+		pr_err("Unable to register miscdev on minor %d\n",
+		       WATCHDOG_MINOR);
 		goto out_rbt;
 	}
 
 	/* output info */
-	pr_info(MODNAME "Timeout set to %d %s.\n",
+	pr_info("Timeout set to %d %s.\n",
 		timeout, (unit == UNIT_SECOND) ? "second(s)" : "minute(s)");
-	pr_info(MODNAME
-		"Watchdog initialized and sleeping (nowayout=%d)...\n",
-								nowayout);
+	pr_info("Watchdog initialized and sleeping (nowayout=%d)...\n",
+		nowayout);
 out_clean:
 	return ret;
 
@@ -592,7 +586,7 @@ static void __exit wb_smsc_wdt_exit(void)
 	/* Stop the timer before we leave */
 	if (!nowayout) {
 		wb_smsc_wdt_shutdown();
-		pr_info(MODNAME "Watchdog disabled.\n");
+		pr_info("Watchdog disabled.\n");
 	}
 
 	misc_deregister(&wb_smsc_wdt_miscdev);
diff --git a/drivers/watchdog/softdog.c b/drivers/watchdog/softdog.c
index d6688cd..be40830 100644
--- a/drivers/watchdog/softdog.c
+++ b/drivers/watchdog/softdog.c
@@ -36,6 +36,8 @@
  *	Added Matt Domsch's nowayout module option.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -49,8 +51,6 @@
 #include <linux/jiffies.h>
 #include <linux/uaccess.h>
 
-#define PFX "SoftDog: "
-
 #define TIMER_MARGIN	60		/* Default is 60 seconds */
 static int soft_margin = TIMER_MARGIN;	/* in seconds */
 module_param(soft_margin, int, 0);
@@ -97,11 +97,11 @@ static void watchdog_fire(unsigned long data)
 		module_put(THIS_MODULE);
 
 	if (soft_noboot)
-		pr_crit(PFX "Triggered - Reboot ignored.\n");
+		pr_crit("Triggered - Reboot ignored.\n");
 	else {
-		pr_crit(PFX "Initiating system reboot.\n");
+		pr_crit("Initiating system reboot.\n");
 		emergency_restart();
-		pr_crit(PFX "Reboot didn't ?????\n");
+		pr_crit("Reboot didn't ?????\n");
 	}
 }
 
@@ -157,8 +157,7 @@ static int softdog_release(struct inode *inode, struct file *file)
 		softdog_stop();
 		module_put(THIS_MODULE);
 	} else {
-		pr_crit(PFX
-			"Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		set_bit(0, &orphan_timer);
 		softdog_keepalive();
 	}
@@ -266,9 +265,6 @@ static struct notifier_block softdog_notifier = {
 	.notifier_call	= softdog_notify_sys,
 };
 
-static char banner[] __initdata = KERN_INFO "Software Watchdog Timer: 0.07 "
-	"initialized. soft_noboot=%d soft_margin=%d sec (nowayout= %d)\n";
-
 static int __init watchdog_init(void)
 {
 	int ret;
@@ -277,28 +273,31 @@ static int __init watchdog_init(void)
 	   if not reset to the default */
 	if (softdog_set_heartbeat(soft_margin)) {
 		softdog_set_heartbeat(TIMER_MARGIN);
-		pr_info(PFX
-		    "soft_margin must be 0 < soft_margin < 65536, using %d\n",
-			TIMER_MARGIN);
+		pr_info_section(__initdata,
+				"soft_margin must be 0 < soft_margin < 65536, using %d\n",
+				TIMER_MARGIN);
 	}
 
 	ret = register_reboot_notifier(&softdog_notifier);
 	if (ret) {
-		pr_err(PFX
-			"cannot register reboot notifier (err=%d)\n", ret);
+		pr_err_section(__initdata,
+			       "cannot register reboot notifier (err=%d)\n",
+			       ret);
 		return ret;
 	}
 
 	ret = misc_register(&softdog_miscdev);
 	if (ret) {
-		pr_err(PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-						WATCHDOG_MINOR, ret);
+		pr_err_section(__initdata,
+			       "cannot register miscdev on minor=%d (err=%d)\n",
+			       WATCHDOG_MINOR, ret);
 		unregister_reboot_notifier(&softdog_notifier);
 		return ret;
 	}
 
-	printk(banner, soft_noboot, soft_margin, nowayout);
+	pr_info_section(__initdata, "Software Watchdog Timer: 0.07 initialized."
+			" soft_noboot=%d soft_margin=%d sec (nowayout= %d)\n",
+			soft_noboot, soft_margin, nowayout);
 
 	return 0;
 }
diff --git a/drivers/watchdog/stmp3xxx_wdt.c b/drivers/watchdog/stmp3xxx_wdt.c
index b53b1fd..e4fc729 100644
--- a/drivers/watchdog/stmp3xxx_wdt.c
+++ b/drivers/watchdog/stmp3xxx_wdt.c
@@ -6,6 +6,9 @@
  * Copyright 2008 Freescale Semiconductor, Inc. All Rights Reserved.
  * Copyright 2008 Embedded Alley Solutions, Inc All Rights Reserved.
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/fs.h>
@@ -220,8 +223,7 @@ static int __devinit stmp3xxx_wdt_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	pr_info("stmp3xxx watchdog: initialized, heartbeat %d sec\n",
-		heartbeat);
+	pr_info("initialized, heartbeat %d sec\n", heartbeat);
 
 	return ret;
 }
diff --git a/drivers/watchdog/txx9wdt.c b/drivers/watchdog/txx9wdt.c
index 0a3cbed..5aaa634 100644
--- a/drivers/watchdog/txx9wdt.c
+++ b/drivers/watchdog/txx9wdt.c
@@ -7,6 +7,9 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -97,8 +100,7 @@ static int txx9wdt_release(struct inode *inode, struct file *file)
 	if (expect_close)
 		txx9wdt_stop();
 	else {
-		pr_crit("txx9wdt: "
-		       "Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		txx9wdt_ping();
 	}
 	clear_bit(0, &txx9wdt_alive);
@@ -234,8 +236,8 @@ static int __init txx9wdt_probe(struct platform_device *dev)
 	}
 
 	pr_info("Hardware Watchdog Timer for TXx9: "
-	       "timeout=%d sec (max %ld) (nowayout= %d)\n",
-	       timeout, WD_MAX_TIMEOUT, nowayout);
+		"timeout=%d sec (max %ld) (nowayout= %d)\n",
+		timeout, WD_MAX_TIMEOUT, nowayout);
 
 	return 0;
 exit_busy:
diff --git a/drivers/watchdog/w83627hf_wdt.c b/drivers/watchdog/w83627hf_wdt.c
index 8f134e4..0c8354e 100644
--- a/drivers/watchdog/w83627hf_wdt.c
+++ b/drivers/watchdog/w83627hf_wdt.c
@@ -26,6 +26,8 @@
  *	(c) Copyright 1995    Alan Cox <alan@lxorguk.ukuu.org.uk>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -43,7 +45,6 @@
 #include <asm/system.h>
 
 #define WATCHDOG_NAME "w83627hf/thf/hg WDT"
-#define PFX WATCHDOG_NAME ": "
 #define WATCHDOG_TIMEOUT 60		/* 60 sec default timeout */
 
 static unsigned long wdt_is_open;
@@ -119,9 +120,8 @@ static void w83627hf_init(void)
 	outb_p(0xF6, WDT_EFER); /* Select CRF6 */
 	t = inb_p(WDT_EFDR);      /* read CRF6 */
 	if (t != 0) {
-		pr_info(PFX
-		     "Watchdog already running. Resetting timeout to %d sec\n",
-								timeout);
+		pr_info("Watchdog already running. Resetting timeout to %d sec\n",
+			timeout);
 		outb_p(timeout, WDT_EFDR);    /* Write back to CRF6 */
 	}
 
@@ -267,8 +267,7 @@ static int wdt_close(struct inode *inode, struct file *file)
 	if (expect_close == 42)
 		wdt_disable();
 	else {
-		pr_crit(PFX
-			"Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		wdt_ping();
 	}
 	expect_close = 0;
@@ -325,14 +324,12 @@ static int __init wdt_init(void)
 
 	if (wdt_set_heartbeat(timeout)) {
 		wdt_set_heartbeat(WATCHDOG_TIMEOUT);
-		pr_info(PFX
-		     "timeout value must be 1 <= timeout <= 255, using %d\n",
-				WATCHDOG_TIMEOUT);
+		pr_info("timeout value must be 1 <= timeout <= 255, using %d\n",
+			WATCHDOG_TIMEOUT);
 	}
 
 	if (!request_region(wdt_io, 1, WATCHDOG_NAME)) {
-		pr_err(PFX "I/O address 0x%04x already in use\n",
-			wdt_io);
+		pr_err("I/O address 0x%04x already in use\n", wdt_io);
 		ret = -EIO;
 		goto out;
 	}
@@ -341,22 +338,19 @@ static int __init wdt_init(void)
 
 	ret = register_reboot_notifier(&wdt_notifier);
 	if (ret != 0) {
-		pr_err(PFX
-			"cannot register reboot notifier (err=%d)\n", ret);
+		pr_err("cannot register reboot notifier (err=%d)\n", ret);
 		goto unreg_regions;
 	}
 
 	ret = misc_register(&wdt_miscdev);
 	if (ret != 0) {
-		pr_err(PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-							WATCHDOG_MINOR, ret);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, ret);
 		goto unreg_reboot;
 	}
 
-	pr_info(PFX
-			"initialized. timeout=%d sec (nowayout=%d)\n",
-							timeout, nowayout);
+	pr_info("initialized. timeout=%d sec (nowayout=%d)\n",
+		timeout, nowayout);
 
 out:
 	return ret;
diff --git a/drivers/watchdog/w83697hf_wdt.c b/drivers/watchdog/w83697hf_wdt.c
index b77a88d..2b5c1fe 100644
--- a/drivers/watchdog/w83697hf_wdt.c
+++ b/drivers/watchdog/w83697hf_wdt.c
@@ -25,6 +25,8 @@
  *	"AS-IS" and at no charge.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -42,7 +44,6 @@
 #include <asm/system.h>
 
 #define WATCHDOG_NAME "w83697hf/hg WDT"
-#define PFX WATCHDOG_NAME ": "
 #define WATCHDOG_TIMEOUT 60		/* 60 sec default timeout */
 #define WATCHDOG_EARLY_DISABLE 1	/* Disable until userland kicks in */
 
@@ -309,8 +310,7 @@ static int wdt_close(struct inode *inode, struct file *file)
 	if (expect_close == 42)
 		wdt_disable();
 	else {
-		pr_crit(PFX
-			"Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		wdt_ping();
 	}
 	expect_close = 0;
@@ -362,24 +362,22 @@ static struct notifier_block wdt_notifier = {
 static int w83697hf_check_wdt(void)
 {
 	if (!request_region(wdt_io, 2, WATCHDOG_NAME)) {
-		pr_err(PFX
-			"I/O address 0x%x already in use\n", wdt_io);
+		pr_err("I/O address 0x%x already in use\n", wdt_io);
 		return -EIO;
 	}
 
-	printk(KERN_DEBUG PFX
-			"Looking for watchdog at address 0x%x\n", wdt_io);
+	printk(KERN_DEBUG KBUILD_MODNAME ": "
+	       "Looking for watchdog at address 0x%x\n", wdt_io);
 	w83697hf_unlock();
 	if (w83697hf_get_reg(0x20) == 0x60) {
-		pr_info(PFX
-			"watchdog found at address 0x%x\n", wdt_io);
+		pr_info("watchdog found at address 0x%x\n", wdt_io);
 		w83697hf_lock();
 		return 0;
 	}
 	/* Reprotect in case it was a compatible device */
 	w83697hf_lock();
 
-	pr_info(PFX "watchdog not found at address 0x%x\n", wdt_io);
+	pr_info("watchdog not found at address 0x%x\n", wdt_io);
 	release_region(wdt_io, 2);
 	return -EIO;
 }
@@ -390,7 +388,7 @@ static int __init wdt_init(void)
 {
 	int ret, i, found = 0;
 
-	pr_info(PFX "WDT driver for W83697HF/HG initializing\n");
+	pr_info("WDT driver for W83697HF/HG initializing\n");
 
 	if (wdt_io == 0) {
 		/* we will autodetect the W83697HF/HG watchdog */
@@ -405,7 +403,7 @@ static int __init wdt_init(void)
 	}
 
 	if (!found) {
-		pr_err(PFX "No W83697HF/HG could be found\n");
+		pr_err("No W83697HF/HG could be found\n");
 		ret = -EIO;
 		goto out;
 	}
@@ -413,34 +411,31 @@ static int __init wdt_init(void)
 	w83697hf_init();
 	if (early_disable) {
 		if (wdt_running())
-			pr_warning(PFX "Stopping previously enabled "
-					"watchdog until userland kicks in\n");
+			pr_warning("Stopping previously enabled "
+				   "watchdog until userland kicks in\n");
 		wdt_disable();
 	}
 
 	if (wdt_set_heartbeat(timeout)) {
 		wdt_set_heartbeat(WATCHDOG_TIMEOUT);
-		pr_info(PFX
-		     "timeout value must be 1 <= timeout <= 255, using %d\n",
-							WATCHDOG_TIMEOUT);
+		pr_info("timeout value must be 1 <= timeout <= 255, using %d\n",
+			WATCHDOG_TIMEOUT);
 	}
 
 	ret = register_reboot_notifier(&wdt_notifier);
 	if (ret != 0) {
-		pr_err(PFX
-			"cannot register reboot notifier (err=%d)\n", ret);
+		pr_err("cannot register reboot notifier (err=%d)\n", ret);
 		goto unreg_regions;
 	}
 
 	ret = misc_register(&wdt_miscdev);
 	if (ret != 0) {
-		pr_err(PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-						WATCHDOG_MINOR, ret);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, ret);
 		goto unreg_reboot;
 	}
 
-	pr_info(PFX "initialized. timeout=%d sec (nowayout=%d)\n",
+	pr_info("initialized. timeout=%d sec (nowayout=%d)\n",
 		timeout, nowayout);
 
 out:
diff --git a/drivers/watchdog/w83697ug_wdt.c b/drivers/watchdog/w83697ug_wdt.c
index f091103..f91fd2a 100644
--- a/drivers/watchdog/w83697ug_wdt.c
+++ b/drivers/watchdog/w83697ug_wdt.c
@@ -30,6 +30,8 @@
  *	(c) Copyright 1995    Alan Cox <alan@redhat.com>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -47,7 +49,6 @@
 #include <asm/system.h>
 
 #define WATCHDOG_NAME "w83697ug/uf WDT"
-#define PFX WATCHDOG_NAME ": "
 #define WATCHDOG_TIMEOUT 60		/* 60 sec default timeout */
 
 static unsigned long wdt_is_open;
@@ -91,7 +92,7 @@ static int w83697ug_select_wd_register(void)
 	version = inb(WDT_EFDR);
 
 	if (version == 0x68) {	/* W83697UG 		*/
-		pr_info(PFX "Watchdog chip version 0x%02x = "
+		pr_info("Watchdog chip version 0x%02x = "
 			"W83697UG/UF found at 0x%04x\n", version, wdt_io);
 
 		outb_p(0x2b, WDT_EFER);
@@ -101,7 +102,7 @@ static int w83697ug_select_wd_register(void)
 		outb_p(c, WDT_EFDR);	/* set pin118 to WDT0 */
 
 	} else {
-		pr_err(PFX "No W83697UG/UF could be found\n");
+		pr_err("No W83697UG/UF could be found\n");
 		return -ENODEV;
 	}
 
@@ -131,7 +132,7 @@ static int w83697ug_init(void)
 	outb_p(0xF6, WDT_EFER); /* Select CRF6 */
 	t = inb_p(WDT_EFDR);    /* read CRF6 */
 	if (t != 0) {
-		pr_info(PFX "Watchdog already running."
+		pr_info("Watchdog already running."
 			" Resetting timeout to %d sec\n", timeout);
 		outb_p(timeout, WDT_EFDR);    /* Write back to CRF6 */
 	}
@@ -286,8 +287,7 @@ static int wdt_close(struct inode *inode, struct file *file)
 	if (expect_close == 42)
 		wdt_disable();
 	else {
-		pr_crit(PFX
-			"Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		wdt_ping();
 	}
 	expect_close = 0;
@@ -344,14 +344,12 @@ static int __init wdt_init(void)
 
 	if (wdt_set_heartbeat(timeout)) {
 		wdt_set_heartbeat(WATCHDOG_TIMEOUT);
-		pr_info(PFX
-			"timeout value must be 1<=timeout<=255, using %d\n",
+		pr_info("timeout value must be 1<=timeout<=255, using %d\n",
 			WATCHDOG_TIMEOUT);
 	}
 
 	if (!request_region(wdt_io, 1, WATCHDOG_NAME)) {
-		pr_err(PFX "I/O address 0x%04x already in use\n",
-			wdt_io);
+		pr_err("I/O address 0x%04x already in use\n", wdt_io);
 		ret = -EIO;
 		goto out;
 	}
@@ -362,20 +360,18 @@ static int __init wdt_init(void)
 
 	ret = register_reboot_notifier(&wdt_notifier);
 	if (ret != 0) {
-		pr_err(PFX
-			"cannot register reboot notifier (err=%d)\n", ret);
+		pr_err("cannot register reboot notifier (err=%d)\n", ret);
 		goto unreg_regions;
 	}
 
 	ret = misc_register(&wdt_miscdev);
 	if (ret != 0) {
-		pr_err(PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, ret);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, ret);
 		goto unreg_reboot;
 	}
 
-	pr_info(PFX "initialized. timeout=%d sec (nowayout=%d)\n",
+	pr_info("initialized. timeout=%d sec (nowayout=%d)\n",
 		timeout, nowayout);
 
 out:
diff --git a/drivers/watchdog/w83877f_wdt.c b/drivers/watchdog/w83877f_wdt.c
index 0bc34b7..a800b09 100644
--- a/drivers/watchdog/w83877f_wdt.c
+++ b/drivers/watchdog/w83877f_wdt.c
@@ -42,6 +42,8 @@
  *  daemon always getting scheduled within that time frame.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -58,9 +60,6 @@
 #include <linux/uaccess.h>
 #include <asm/system.h>
 
-#define OUR_NAME "w83877f_wdt"
-#define PFX OUR_NAME ": "
-
 #define ENABLE_W83877F_PORT 0x3F0
 #define ENABLE_W83877F 0x87
 #define DISABLE_W83877F 0xAA
@@ -126,8 +125,7 @@ static void wdt_timer_ping(unsigned long data)
 		spin_unlock(&wdt_spinlock);
 
 	} else
-		pr_warning(PFX
-			"Heartbeat lost! Will not ping the watchdog\n");
+		pr_warning("Heartbeat lost! Will not ping the watchdog\n");
 }
 
 /*
@@ -165,7 +163,7 @@ static void wdt_startup(void)
 
 	wdt_change(WDT_ENABLE);
 
-	pr_info(PFX "Watchdog timer is now enabled.\n");
+	pr_info("Watchdog timer is now enabled.\n");
 }
 
 static void wdt_turnoff(void)
@@ -175,7 +173,7 @@ static void wdt_turnoff(void)
 
 	wdt_change(WDT_DISABLE);
 
-	pr_info(PFX "Watchdog timer is now disabled...\n");
+	pr_info("Watchdog timer is now disabled...\n");
 }
 
 static void wdt_keepalive(void)
@@ -234,8 +232,7 @@ static int fop_close(struct inode *inode, struct file *file)
 		wdt_turnoff();
 	else {
 		del_timer(&timer);
-		pr_crit(PFX
-		  "device file closed unexpectedly. Will not stop the WDT!\n");
+		pr_crit("device file closed unexpectedly. Will not stop the WDT!\n");
 	}
 	clear_bit(0, &wdt_is_open);
 	wdt_expect_close = 0;
@@ -357,42 +354,37 @@ static int __init w83877f_wdt_init(void)
 
 	if (timeout < 1 || timeout > 3600) { /* arbitrary upper limit */
 		timeout = WATCHDOG_TIMEOUT;
-		pr_info(PFX
-			"timeout value must be 1 <= x <= 3600, using %d\n",
-							timeout);
+		pr_info("timeout value must be 1 <= x <= 3600, using %d\n",
+			timeout);
 	}
 
 	if (!request_region(ENABLE_W83877F_PORT, 2, "W83877F WDT")) {
-		pr_err(PFX "I/O address 0x%04x already in use\n",
-			ENABLE_W83877F_PORT);
+		pr_err("I/O address 0x%04x already in use\n",
+		       ENABLE_W83877F_PORT);
 		rc = -EIO;
 		goto err_out;
 	}
 
 	if (!request_region(WDT_PING, 1, "W8387FF WDT")) {
-		pr_err(PFX "I/O address 0x%04x already in use\n",
-			WDT_PING);
+		pr_err("I/O address 0x%04x already in use\n", WDT_PING);
 		rc = -EIO;
 		goto err_out_region1;
 	}
 
 	rc = register_reboot_notifier(&wdt_notifier);
 	if (rc) {
-		pr_err(PFX
-			"cannot register reboot notifier (err=%d)\n", rc);
+		pr_err("cannot register reboot notifier (err=%d)\n", rc);
 		goto err_out_region2;
 	}
 
 	rc = misc_register(&wdt_miscdev);
 	if (rc) {
-		pr_err(PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-							wdt_miscdev.minor, rc);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       wdt_miscdev.minor, rc);
 		goto err_out_reboot;
 	}
 
-	pr_info(PFX
-	  "WDT driver for W83877F initialised. timeout=%d sec (nowayout=%d)\n",
+	pr_info("WDT driver for W83877F initialised. timeout=%d sec (nowayout=%d)\n",
 		timeout, nowayout);
 
 	return 0;
diff --git a/drivers/watchdog/w83977f_wdt.c b/drivers/watchdog/w83977f_wdt.c
index 59ce385..242496c 100644
--- a/drivers/watchdog/w83977f_wdt.c
+++ b/drivers/watchdog/w83977f_wdt.c
@@ -15,6 +15,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -33,7 +35,6 @@
 
 #define WATCHDOG_VERSION  "1.00"
 #define WATCHDOG_NAME     "W83977F WDT"
-#define PFX WATCHDOG_NAME ": "
 #define DRIVER_VERSION    WATCHDOG_NAME " driver, v" WATCHDOG_VERSION "\n"
 
 #define IO_INDEX_PORT     0x3F0
@@ -131,7 +132,7 @@ static int wdt_start(void)
 
 	spin_unlock_irqrestore(&spinlock, flags);
 
-	pr_info(PFX "activated.\n");
+	pr_info("activated.\n");
 
 	return 0;
 }
@@ -185,7 +186,7 @@ static int wdt_stop(void)
 
 	spin_unlock_irqrestore(&spinlock, flags);
 
-	pr_info(PFX "shutdown.\n");
+	pr_info("shutdown.\n");
 
 	return 0;
 }
@@ -313,8 +314,7 @@ static int wdt_release(struct inode *inode, struct file *file)
 		clear_bit(0, &timer_alive);
 	} else {
 		wdt_keepalive();
-		pr_crit(PFX
-			"unexpected close, not stopping watchdog!\n");
+		pr_crit("unexpected close, not stopping watchdog!\n");
 	}
 	expect_close = 0;
 	return 0;
@@ -471,7 +471,7 @@ static int __init w83977f_wdt_init(void)
 {
 	int rc;
 
-	pr_info(PFX DRIVER_VERSION);
+	pr_info(DRIVER_VERSION);
 
 	/*
 	 * Check that the timeout value is within it's range;
@@ -479,36 +479,31 @@ static int __init w83977f_wdt_init(void)
 	 */
 	if (wdt_set_timeout(timeout)) {
 		wdt_set_timeout(DEFAULT_TIMEOUT);
-		pr_info(PFX
-		    "timeout value must be 15 <= timeout <= 7635, using %d\n",
-							DEFAULT_TIMEOUT);
+		pr_info("timeout value must be 15 <= timeout <= 7635, using %d\n",
+			DEFAULT_TIMEOUT);
 	}
 
 	if (!request_region(IO_INDEX_PORT, 2, WATCHDOG_NAME)) {
-		pr_err(PFX "I/O address 0x%04x already in use\n",
-			IO_INDEX_PORT);
+		pr_err("I/O address 0x%04x already in use\n", IO_INDEX_PORT);
 		rc = -EIO;
 		goto err_out;
 	}
 
 	rc = register_reboot_notifier(&wdt_notifier);
 	if (rc) {
-		pr_err(PFX
-			"cannot register reboot notifier (err=%d)\n", rc);
+		pr_err("cannot register reboot notifier (err=%d)\n", rc);
 		goto err_out_region;
 	}
 
 	rc = misc_register(&wdt_miscdev);
 	if (rc) {
-		pr_err(PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-						wdt_miscdev.minor, rc);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       wdt_miscdev.minor, rc);
 		goto err_out_reboot;
 	}
 
-	pr_info(PFX
-		"initialized. timeout=%d sec (nowayout=%d testmode=%d)\n",
-					timeout, nowayout, testmode);
+	pr_info("initialized. timeout=%d sec (nowayout=%d testmode=%d)\n",
+		timeout, nowayout, testmode);
 
 	return 0;
 
diff --git a/drivers/watchdog/wafer5823wdt.c b/drivers/watchdog/wafer5823wdt.c
index 8ab2038..b583d9f 100644
--- a/drivers/watchdog/wafer5823wdt.c
+++ b/drivers/watchdog/wafer5823wdt.c
@@ -26,6 +26,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/miscdevice.h>
@@ -39,8 +41,6 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 
-#define WATCHDOG_NAME "Wafer 5823 WDT"
-#define PFX WATCHDOG_NAME ": "
 #define WD_TIMO 60			/* 60 sec default timeout */
 
 static unsigned long wafwdt_is_open;
@@ -203,8 +203,7 @@ static int wafwdt_close(struct inode *inode, struct file *file)
 	if (expect_close == 42)
 		wafwdt_stop();
 	else {
-		pr_crit(PFX
-		    "WDT device closed unexpectedly.  WDT will not stop!\n");
+		pr_crit("WDT device closed unexpectedly.  WDT will not stop!\n");
 		wafwdt_ping();
 	}
 	clear_bit(0, &wafwdt_is_open);
@@ -260,44 +259,38 @@ static int __init wafwdt_init(void)
 
 	if (timeout < 1 || timeout > 255) {
 		timeout = WD_TIMO;
-		pr_info(PFX
-			"timeout value must be 1 <= x <= 255, using %d\n",
-								timeout);
+		pr_info("timeout value must be 1 <= x <= 255, using %d\n",
+			timeout);
 	}
 
 	if (wdt_stop != wdt_start) {
 		if (!request_region(wdt_stop, 1, "Wafer 5823 WDT")) {
-			pr_err(PFX
-				"I/O address 0x%04x already in use\n",
-								wdt_stop);
+			pr_err("I/O address 0x%04x already in use\n", wdt_stop);
 			ret = -EIO;
 			goto error;
 		}
 	}
 
 	if (!request_region(wdt_start, 1, "Wafer 5823 WDT")) {
-		pr_err(PFX "I/O address 0x%04x already in use\n",
-			wdt_start);
+		pr_err("I/O address 0x%04x already in use\n", wdt_start);
 		ret = -EIO;
 		goto error2;
 	}
 
 	ret = register_reboot_notifier(&wafwdt_notifier);
 	if (ret != 0) {
-		pr_err(PFX
-			"cannot register reboot notifier (err=%d)\n", ret);
+		pr_err("cannot register reboot notifier (err=%d)\n", ret);
 		goto error3;
 	}
 
 	ret = misc_register(&wafwdt_miscdev);
 	if (ret != 0) {
-		pr_err(PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-						WATCHDOG_MINOR, ret);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, ret);
 		goto error4;
 	}
 
-	pr_info(PFX "initialized. timeout=%d sec (nowayout=%d)\n",
+	pr_info("initialized. timeout=%d sec (nowayout=%d)\n",
 		timeout, nowayout);
 
 	return ret;
diff --git a/drivers/watchdog/wdrtas.c b/drivers/watchdog/wdrtas.c
index 6220837..68bc40c 100644
--- a/drivers/watchdog/wdrtas.c
+++ b/drivers/watchdog/wdrtas.c
@@ -26,6 +26,8 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -93,8 +95,8 @@ static int wdrtas_set_interval(int interval)
 	result = rtas_call(wdrtas_token_set_indicator, 3, 1, NULL,
 			   WDRTAS_SURVEILLANCE_IND, 0, interval);
 	if (result < 0 && print_msg) {
-		pr_err("wdrtas: setting the watchdog to %i "
-		       "timeout failed: %li\n", interval, result);
+		pr_err("setting the watchdog to %i timeout failed: %li\n",
+		       interval, result);
 		print_msg--;
 	}
 
@@ -128,8 +130,8 @@ static int wdrtas_get_interval(int fallback_value)
 	spin_unlock(&rtas_data_buf_lock);
 
 	if (value[0] != 0 || value[1] != 2 || value[3] != 0 || result < 0) {
-		pr_warning("wdrtas: could not get sp_spi watchdog "
-		       "timeout (%li). Continuing\n", result);
+		pr_warning("could not get sp_spi watchdog timeout (%li). "
+			   "Continuing\n", result);
 		return fallback_value;
 	}
 
@@ -167,21 +169,9 @@ static void wdrtas_timer_stop(void)
  */
 static void wdrtas_log_scanned_event(void)
 {
-	int i;
-
-	for (i = 0; i < WDRTAS_LOGBUFFER_LEN; i += 16)
-		pr_info("wdrtas: dumping event (line %i/%i), data = "
-		       "%02x %02x %02x %02x  %02x %02x %02x %02x   "
-		       "%02x %02x %02x %02x  %02x %02x %02x %02x\n",
-		       (i / 16) + 1, (WDRTAS_LOGBUFFER_LEN / 16),
-		       wdrtas_logbuffer[i + 0], wdrtas_logbuffer[i + 1],
-		       wdrtas_logbuffer[i + 2], wdrtas_logbuffer[i + 3],
-		       wdrtas_logbuffer[i + 4], wdrtas_logbuffer[i + 5],
-		       wdrtas_logbuffer[i + 6], wdrtas_logbuffer[i + 7],
-		       wdrtas_logbuffer[i + 8], wdrtas_logbuffer[i + 9],
-		       wdrtas_logbuffer[i + 10], wdrtas_logbuffer[i + 11],
-		       wdrtas_logbuffer[i + 12], wdrtas_logbuffer[i + 13],
-		       wdrtas_logbuffer[i + 14], wdrtas_logbuffer[i + 15]);
+	pr_info("dumping event, data follows:\n");
+	print_dump_hex(KERN_INFO, "", DUMP_PREFIX_OFFSET, 16, 1,
+		       wdrtas_logbuffer, WDRTAS_LOGBUFFER_LEN, true);
 }
 
 /**
@@ -201,8 +191,7 @@ static void wdrtas_timer_keepalive(void)
 				   (void *)__pa(wdrtas_logbuffer),
 				   WDRTAS_LOGBUFFER_LEN);
 		if (result < 0)
-			pr_err("wdrtas: event-scan failed: %li\n",
-			       result);
+			pr_err("event-scan failed: %li\n", result);
 		if (result == 0)
 			wdrtas_log_scanned_event();
 	} while (result == 0);
@@ -224,8 +213,7 @@ static int wdrtas_get_temperature(void)
 	result = rtas_get_sensor(WDRTAS_THERMAL_SENSOR, 0, &temperature);
 
 	if (result < 0)
-		pr_warning("wdrtas: reading the thermal sensor "
-		       "failed: %i\n", result);
+		pr_warning("reading the thermal sensor failed: %i\n", result);
 	else
 		temperature = ((temperature * 9) / 5) + 32; /* fahrenheit */
 
@@ -419,8 +407,7 @@ static int wdrtas_close(struct inode *inode, struct file *file)
 	if (wdrtas_expect_close == WDRTAS_MAGIC_CHAR)
 		wdrtas_timer_stop();
 	else {
-		pr_warning("wdrtas: got unexpected close. Watchdog "
-		       "not stopped.\n");
+		pr_warning("got unexpected close. Watchdog not stopped.\n");
 		wdrtas_timer_keepalive();
 	}
 
@@ -552,29 +539,28 @@ static int wdrtas_get_tokens(void)
 {
 	wdrtas_token_get_sensor_state = rtas_token("get-sensor-state");
 	if (wdrtas_token_get_sensor_state == RTAS_UNKNOWN_SERVICE) {
-		pr_warning("wdrtas: couldn't get token for "
-		       "get-sensor-state. Trying to continue without "
-		       "temperature support.\n");
+		pr_warning("couldn't get token for get-sensor-state. "
+			   "Trying to continue without temperature support.\n");
 	}
 
 	wdrtas_token_get_sp = rtas_token("ibm,get-system-parameter");
 	if (wdrtas_token_get_sp == RTAS_UNKNOWN_SERVICE) {
-		pr_warning("wdrtas: couldn't get token for "
-		       "ibm,get-system-parameter. Trying to continue with "
-		       "a default timeout value of %i seconds.\n",
-		       WDRTAS_DEFAULT_INTERVAL);
+		pr_warning("couldn't get token for "
+			   "ibm,get-system-parameter. Trying to continue with "
+			   "a default timeout value of %i seconds.\n",
+			   WDRTAS_DEFAULT_INTERVAL);
 	}
 
 	wdrtas_token_set_indicator = rtas_token("set-indicator");
 	if (wdrtas_token_set_indicator == RTAS_UNKNOWN_SERVICE) {
-		pr_err("wdrtas: couldn't get token for "
+		pr_err("couldn't get token for "
 		       "set-indicator. Terminating watchdog code.\n");
 		return -EIO;
 	}
 
 	wdrtas_token_event_scan = rtas_token("event-scan");
 	if (wdrtas_token_event_scan == RTAS_UNKNOWN_SERVICE) {
-		pr_err("wdrtas: couldn't get token for event-scan. "
+		pr_err("couldn't get token for event-scan. "
 		       "Terminating watchdog code.\n");
 		return -EIO;
 	}
@@ -609,17 +595,16 @@ static int wdrtas_register_devs(void)
 
 	result = misc_register(&wdrtas_miscdev);
 	if (result) {
-		pr_err("wdrtas: couldn't register watchdog misc "
-		       "device. Terminating watchdog code.\n");
+		pr_err("couldn't register watchdog misc device. "
+		       "Terminating watchdog code.\n");
 		return result;
 	}
 
 	if (wdrtas_token_get_sensor_state != RTAS_UNKNOWN_SERVICE) {
 		result = misc_register(&wdrtas_tempdev);
 		if (result) {
-			pr_warning("wdrtas: couldn't register "
-			       "watchdog temperature misc device. Continuing "
-			       "without temperature support.\n");
+			pr_warning("couldn't register watchdog temperature misc device. "
+				   "Continuing without temperature support.\n");
 			wdrtas_token_get_sensor_state = RTAS_UNKNOWN_SERVICE;
 		}
 	}
@@ -643,7 +628,7 @@ static int __init wdrtas_init(void)
 		return -ENODEV;
 
 	if (register_reboot_notifier(&wdrtas_notifier)) {
-		pr_err("wdrtas: could not register reboot notifier. "
+		pr_err("could not register reboot notifier. "
 		       "Terminating watchdog code.\n");
 		wdrtas_unregister_devs();
 		return -ENODEV;
diff --git a/drivers/watchdog/wdt.c b/drivers/watchdog/wdt.c
index f623015..5549d20 100644
--- a/drivers/watchdog/wdt.c
+++ b/drivers/watchdog/wdt.c
@@ -32,6 +32,8 @@
  *		Matt Domsch	:	Added nowayout module option
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
@@ -592,7 +594,7 @@ static int __init wdt_init(void)
 	int ret;
 
 	if (type != 500 && type != 501) {
-		pr_err("wdt: unknown card type '%d'.\n", type);
+		pr_err("unknown card type '%d'.\n", type);
 		return -ENODEV;
 	}
 
@@ -600,50 +602,50 @@ static int __init wdt_init(void)
 	   if not reset to the default */
 	if (wdt_set_heartbeat(heartbeat)) {
 		wdt_set_heartbeat(WD_TIMO);
-		pr_info("wdt: heartbeat value must be "
+		pr_info("heartbeat value must be "
 			"0 < heartbeat < 65536, using %d\n", WD_TIMO);
 	}
 
 	if (!request_region(io, 8, "wdt501p")) {
-		pr_err("wdt: I/O address 0x%04x already in use\n", io);
+		pr_err("I/O address 0x%04x already in use\n", io);
 		ret = -EBUSY;
 		goto out;
 	}
 
 	ret = request_irq(irq, wdt_interrupt, IRQF_DISABLED, "wdt501p", NULL);
 	if (ret) {
-		pr_err("wdt: IRQ %d is not free.\n", irq);
+		pr_err("IRQ %d is not free.\n", irq);
 		goto outreg;
 	}
 
 	ret = register_reboot_notifier(&wdt_notifier);
 	if (ret) {
-		pr_err("wdt: cannot register reboot notifier (err=%d)\n", ret);
+		pr_err("cannot register reboot notifier (err=%d)\n", ret);
 		goto outirq;
 	}
 
 	if (type == 501) {
 		ret = misc_register(&temp_miscdev);
 		if (ret) {
-			pr_err("wdt: cannot register miscdev "
-				"on minor=%d (err=%d)\n", TEMP_MINOR, ret);
+			pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+			       TEMP_MINOR, ret);
 			goto outrbt;
 		}
 	}
 
 	ret = misc_register(&wdt_miscdev);
 	if (ret) {
-		pr_err("wdt: cannot register miscdev on minor=%d (err=%d)\n",
-							WATCHDOG_MINOR, ret);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, ret);
 		goto outmisc;
 	}
 
-	pr_info("WDT500/501-P driver 0.10 "
-		"at 0x%04x (Interrupt %d). heartbeat=%d sec (nowayout=%d)\n",
+	pr_info("WDT500/501-P driver 0.10 at 0x%04x (Interrupt %d). "
+		"heartbeat=%d sec (nowayout=%d)\n",
 		io, irq, heartbeat, nowayout);
 	if (type == 501)
-		pr_info("wdt: Fan Tachometer is %s\n",
-				(tachometer ? "Enabled" : "Disabled"));
+		pr_info("Fan Tachometer is %s\n",
+			(tachometer ? "Enabled" : "Disabled"));
 	return 0;
 
 outmisc:
diff --git a/drivers/watchdog/wdt285.c b/drivers/watchdog/wdt285.c
index 37b88e2..8b622ef 100644
--- a/drivers/watchdog/wdt285.c
+++ b/drivers/watchdog/wdt285.c
@@ -16,6 +16,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -206,7 +208,7 @@ static int __init footbridge_watchdog_init(void)
 		return retval;
 
 	pr_info("Footbridge Watchdog Timer: 0.01, timer margin: %d sec\n",
-								soft_margin);
+		soft_margin);
 
 	if (machine_is_cats())
 		pr_warning("Warning: Watchdog reset may not work on this machine.\n");
diff --git a/drivers/watchdog/wdt977.c b/drivers/watchdog/wdt977.c
index f316a26..844a7cd 100644
--- a/drivers/watchdog/wdt977.c
+++ b/drivers/watchdog/wdt977.c
@@ -23,6 +23,8 @@
  *				    Netwinders only
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -42,7 +44,6 @@
 
 #define WATCHDOG_VERSION  "0.04"
 #define WATCHDOG_NAME     "Wdt977"
-#define PFX WATCHDOG_NAME ": "
 #define DRIVER_VERSION    WATCHDOG_NAME " driver, v" WATCHDOG_VERSION "\n"
 
 #define IO_INDEX_PORT	0x370		/* on some systems it can be 0x3F0 */
@@ -119,7 +120,7 @@ static int wdt977_start(void)
 	outb_p(LOCK_DATA, IO_INDEX_PORT);
 
 	spin_unlock_irqrestore(&spinlock, flags);
-	pr_info(PFX "activated.\n");
+	pr_info("activated.\n");
 
 	return 0;
 }
@@ -164,7 +165,7 @@ static int wdt977_stop(void)
 	outb_p(LOCK_DATA, IO_INDEX_PORT);
 
 	spin_unlock_irqrestore(&spinlock, flags);
-	pr_info(PFX "shutdown.\n");
+	pr_info("shutdown.\n");
 
 	return 0;
 }
@@ -288,8 +289,7 @@ static int wdt977_release(struct inode *inode, struct file *file)
 		clear_bit(0, &timer_alive);
 	} else {
 		wdt977_keepalive();
-		pr_crit(PFX
-			"Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 	}
 	expect_close = 0;
 	return 0;
@@ -446,15 +446,14 @@ static int __init wd977_init(void)
 {
 	int rc;
 
-	pr_info(PFX DRIVER_VERSION);
+	pr_info(DRIVER_VERSION);
 
 	/* Check that the timeout value is within its range;
 	   if not reset to the default */
 	if (wdt977_set_timeout(timeout)) {
 		wdt977_set_timeout(DEFAULT_TIMEOUT);
-		pr_info(PFX
-		      "timeout value must be 60 < timeout < 15300, using %d\n",
-							DEFAULT_TIMEOUT);
+		pr_info("timeout value must be 60 < timeout < 15300, using %d\n",
+			DEFAULT_TIMEOUT);
 	}
 
 	/* on Netwinder the IOports are already reserved by
@@ -462,9 +461,8 @@ static int __init wd977_init(void)
 	 */
 	if (!machine_is_netwinder()) {
 		if (!request_region(IO_INDEX_PORT, 2, WATCHDOG_NAME)) {
-			pr_err(PFX
-				"I/O address 0x%04x already in use\n",
-								IO_INDEX_PORT);
+			pr_err("I/O address 0x%04x already in use\n",
+			       IO_INDEX_PORT);
 			rc = -EIO;
 			goto err_out;
 		}
@@ -472,22 +470,19 @@ static int __init wd977_init(void)
 
 	rc = register_reboot_notifier(&wdt977_notifier);
 	if (rc) {
-		pr_err(PFX
-			"cannot register reboot notifier (err=%d)\n", rc);
+		pr_err("cannot register reboot notifier (err=%d)\n", rc);
 		goto err_out_region;
 	}
 
 	rc = misc_register(&wdt977_miscdev);
 	if (rc) {
-		pr_err(PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-						wdt977_miscdev.minor, rc);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       wdt977_miscdev.minor, rc);
 		goto err_out_reboot;
 	}
 
-	pr_info(PFX
-		"initialized. timeout=%d sec (nowayout=%d, testmode=%i)\n",
-						timeout, nowayout, testmode);
+	pr_info("initialized. timeout=%d sec (nowayout=%d, testmode=%i)\n",
+		timeout, nowayout, testmode);
 
 	return 0;
 
diff --git a/drivers/watchdog/wdt_pci.c b/drivers/watchdog/wdt_pci.c
index cb7c89f..7aa226a 100644
--- a/drivers/watchdog/wdt_pci.c
+++ b/drivers/watchdog/wdt_pci.c
@@ -37,6 +37,8 @@
  *		Matt Domsch	:	nowayout module option
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
@@ -58,8 +60,6 @@
 #define WDT_IS_PCI
 #include "wd501p.h"
 
-#define PFX "wdt_pci: "
-
 /*
  * Until Access I/O gets their application for a PCI vendor ID approved,
  * I don't think that it's appropriate to move these constants into the
@@ -325,33 +325,32 @@ static irqreturn_t wdtpci_interrupt(int irq, void *dev_id)
 	status = inb(WDT_SR);
 	udelay(8);
 
-	pr_crit(PFX "status %d\n", status);
+	pr_crit("status %d\n", status);
 
 	if (type == 501) {
 		if (!(status & WDC_SR_TGOOD)) {
-			pr_crit(PFX "Overheat alarm.(%d)\n",
-								inb(WDT_RT));
+			pr_crit("Overheat alarm.(%d)\n", inb(WDT_RT));
 			udelay(8);
 		}
 		if (!(status & WDC_SR_PSUOVER))
-			pr_crit(PFX "PSU over voltage.\n");
+			pr_crit("PSU over voltage.\n");
 		if (!(status & WDC_SR_PSUUNDR))
-			pr_crit(PFX "PSU under voltage.\n");
+			pr_crit("PSU under voltage.\n");
 		if (tachometer) {
 			if (!(status & WDC_SR_FANGOOD))
-				pr_crit(PFX "Possible fan fault.\n");
+				pr_crit("Possible fan fault.\n");
 		}
 	}
 	if (!(status & WDC_SR_WCCR)) {
 #ifdef SOFTWARE_REBOOT
 #ifdef ONLY_TESTING
-		pr_crit(PFX "Would Reboot.\n");
+		pr_crit("Would Reboot.\n");
 #else
-		pr_crit(PFX "Initiating system reboot.\n");
+		pr_crit("Initiating system reboot.\n");
 		emergency_restart(NULL);
 #endif
 #else
-		pr_crit(PFX "Reset in 5ms.\n");
+		pr_crit("Reset in 5ms.\n");
 #endif
 	}
 	spin_unlock(&wdtpci_lock);
@@ -497,7 +496,7 @@ static int wdtpci_release(struct inode *inode, struct file *file)
 	if (expect_close == 42) {
 		wdtpci_stop();
 	} else {
-		pr_crit(PFX "Unexpected close, not stopping timer!");
+		pr_crit("Unexpected close, not stopping timer!");
 		wdtpci_ping();
 	}
 	expect_close = 0;
@@ -627,22 +626,22 @@ static int __devinit wdtpci_init_one(struct pci_dev *dev,
 
 	dev_count++;
 	if (dev_count > 1) {
-		pr_err(PFX "This driver only supports one device\n");
+		pr_err("This driver only supports one device\n");
 		return -ENODEV;
 	}
 
 	if (type != 500 && type != 501) {
-		pr_err(PFX "unknown card type '%d'.\n", type);
+		pr_err("unknown card type '%d'.\n", type);
 		return -ENODEV;
 	}
 
 	if (pci_enable_device(dev)) {
-		pr_err(PFX "Not possible to enable PCI Device\n");
+		pr_err("Not possible to enable PCI Device\n");
 		return -ENODEV;
 	}
 
 	if (pci_resource_start(dev, 2) == 0x0000) {
-		pr_err(PFX "No I/O-Address for card detected\n");
+		pr_err("No I/O-Address for card detected\n");
 		ret = -ENODEV;
 		goto out_pci;
 	}
@@ -651,58 +650,54 @@ static int __devinit wdtpci_init_one(struct pci_dev *dev,
 	io = pci_resource_start(dev, 2);
 
 	if (request_region(io, 16, "wdt_pci") == NULL) {
-		pr_err(PFX "I/O address 0x%04x already in use\n", io);
+		pr_err("I/O address 0x%04x already in use\n", io);
 		goto out_pci;
 	}
 
 	if (request_irq(irq, wdtpci_interrupt, IRQF_DISABLED | IRQF_SHARED,
 			 "wdt_pci", &wdtpci_miscdev)) {
-		pr_err(PFX "IRQ %d is not free\n", irq);
+		pr_err("IRQ %d is not free\n", irq);
 		goto out_reg;
 	}
 
 	pr_info("PCI-WDT500/501 (PCI-WDG-CSM) driver 0.10 at 0x%04x (Interrupt %d)\n",
-								io, irq);
+		io, irq);
 
 	/* Check that the heartbeat value is within its range;
 	   if not reset to the default */
 	if (wdtpci_set_heartbeat(heartbeat)) {
 		wdtpci_set_heartbeat(WD_TIMO);
-		pr_info(PFX
-		  "heartbeat value must be 0 < heartbeat < 65536, using %d\n",
-								WD_TIMO);
+		pr_info("heartbeat value must be 0 < heartbeat < 65536, using %d\n",
+			WD_TIMO);
 	}
 
 	ret = register_reboot_notifier(&wdtpci_notifier);
 	if (ret) {
-		pr_err(PFX
-			"cannot register reboot notifier (err=%d)\n", ret);
+		pr_err("cannot register reboot notifier (err=%d)\n", ret);
 		goto out_irq;
 	}
 
 	if (type == 501) {
 		ret = misc_register(&temp_miscdev);
 		if (ret) {
-			pr_err(PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-							TEMP_MINOR, ret);
+			pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+			       TEMP_MINOR, ret);
 			goto out_rbt;
 		}
 	}
 
 	ret = misc_register(&wdtpci_miscdev);
 	if (ret) {
-		pr_err(PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-						WATCHDOG_MINOR, ret);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, ret);
 		goto out_misc;
 	}
 
-	pr_info(PFX "initialized. heartbeat=%d sec (nowayout=%d)\n",
+	pr_info("initialized. heartbeat=%d sec (nowayout=%d)\n",
 		heartbeat, nowayout);
 	if (type == 501)
-		pr_info("wdt: Fan Tachometer is %s\n",
-				(tachometer ? "Enabled" : "Disabled"));
+		pr_info("Fan Tachometer is %s\n",
+			(tachometer ? "Enabled" : "Disabled"));
 
 	ret = 0;
 out:
-- 
1.6.3.1.10.g659a0.dirty

