Return-Path: <linux-kernel-owner+w=401wt.eu-S932942AbXBVJ5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932942AbXBVJ5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 04:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932939AbXBVJ5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 04:57:20 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:36089 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932942AbXBVJ5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 04:57:19 -0500
X-Originating-Ip: 74.109.98.130
Date: Thu, 22 Feb 2007 04:39:40 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: trivial@kernel.org
Subject: [PATCH] Fix "deprecated" typoes.
Message-ID: <Pine.LNX.4.64.0702220437370.22382@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Fix remaining misspellings of "depreciated" to "deprecated."

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  happy now, randy?  :-)

 Documentation/arm/Interrupts             |    2 +-
 drivers/net/hamradio/Kconfig             |    2 +-
 drivers/net/wireless/prism54/isl_ioctl.c |    2 +-
 include/asm-arm26/io.h                   |    2 +-
 include/asm-arm26/memory.h               |    4 ++--
 include/asm-arm26/setup.h                |    2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/arm/Interrupts b/Documentation/arm/Interrupts
index 72c93de..0d3dbf1 100644
--- a/Documentation/arm/Interrupts
+++ b/Documentation/arm/Interrupts
@@ -149,7 +149,7 @@ So, what's changed?

 3. set_GPIO_IRQ_edge() is obsolete, and should be replaced by set_irq_type.

-4. Direct access to SA1111 INTPOL is depreciated.  Use set_irq_type instead.
+4. Direct access to SA1111 INTPOL is deprecated.  Use set_irq_type instead.

 5. A handler is expected to perform any necessary acknowledgement of the
    parent IRQ via the correct chip specific function.  For instance, if
diff --git a/drivers/net/hamradio/Kconfig b/drivers/net/hamradio/Kconfig
index 6e90619..36d2c7d 100644
--- a/drivers/net/hamradio/Kconfig
+++ b/drivers/net/hamradio/Kconfig
@@ -140,7 +140,7 @@ config BAYCOM_SER_HDX
 	  modems that connect to a serial interface. The driver supports the
 	  ser12 design in half-duplex mode. This is the old driver.  It is
 	  still provided in case your serial interface chip does not work with
-	  the full-duplex driver. This driver is depreciated.  To configure
+	  the full-duplex driver. This driver is deprecated.  To configure
 	  the driver, use the sethdlc utility available in the standard ax25
 	  utilities package. For information on the modems, see
 	  <http://www.baycom.de/> and
diff --git a/drivers/net/wireless/prism54/isl_ioctl.c b/drivers/net/wireless/prism54/isl_ioctl.c
index 841b3c1..283be4a 100644
--- a/drivers/net/wireless/prism54/isl_ioctl.c
+++ b/drivers/net/wireless/prism54/isl_ioctl.c
@@ -3054,7 +3054,7 @@ static const iw_handler prism54_handler[] = {
 	(iw_handler) prism54_set_wap,	/* SIOCSIWAP */
 	(iw_handler) prism54_get_wap,	/* SIOCGIWAP */
 	(iw_handler) NULL,	/* -- hole -- */
-	(iw_handler) NULL,	/* SIOCGIWAPLIST depreciated */
+	(iw_handler) NULL,	/* SIOCGIWAPLIST deprecated */
 	(iw_handler) prism54_set_scan,	/* SIOCSIWSCAN */
 	(iw_handler) prism54_get_scan,	/* SIOCGIWSCAN */
 	(iw_handler) prism54_set_essid,	/* SIOCSIWESSID */
diff --git a/include/asm-arm26/io.h b/include/asm-arm26/io.h
index 2aa033b..a5a7a4d 100644
--- a/include/asm-arm26/io.h
+++ b/include/asm-arm26/io.h
@@ -321,7 +321,7 @@ DECLARE_IO(int,l,"")

 #define mmiowb()

-/* the following macro is depreciated */
+/* the following macro is deprecated */
 #define ioaddr(port)                    __ioaddr((port))

 /*
diff --git a/include/asm-arm26/memory.h b/include/asm-arm26/memory.h
index a65f10b..7c1e5be 100644
--- a/include/asm-arm26/memory.h
+++ b/include/asm-arm26/memory.h
@@ -60,7 +60,7 @@ static inline void *phys_to_virt(unsigned long x)
 /*
  * Virtual <-> DMA view memory address translations
  * Again, these are *only* valid on the kernel direct mapped RAM
- * memory.  Use of these is *depreciated*.
+ * memory.  Use of these is *deprecated*.
  */
 #define virt_to_bus(x)		((unsigned long)(x))
 #define bus_to_virt(x)		((void *)((unsigned long)(x)))
@@ -93,7 +93,7 @@ static inline void *phys_to_virt(unsigned long x)
 #define page_to_phys(page)	(page_to_pfn(page) << PAGE_SHIFT)

 /*
- * We should really eliminate virt_to_bus() here - it's depreciated.
+ * We should really eliminate virt_to_bus() here - it's deprecated.
  */
 #define page_to_bus(page)	(page_address(page))

diff --git a/include/asm-arm26/setup.h b/include/asm-arm26/setup.h
index 1a867b4..670a9f4 100644
--- a/include/asm-arm26/setup.h
+++ b/include/asm-arm26/setup.h
@@ -70,7 +70,7 @@ struct tag_ramdisk {
 /* describes where the compressed ramdisk image lives */
 /*
  * this one accidentally used virtual addresses - as such,
- * its depreciated.
+ * it's deprecated.
  */
 #define ATAG_INITRD	0x54410005

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
