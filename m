Return-Path: <linux-kernel-owner+w=401wt.eu-S1753589AbXJHH7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbXJHH7R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 03:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbXJHH7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 03:59:03 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:60237 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432AbXJHH7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 03:59:01 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Typo: depricated -> deprecated
Date: Sun, 7 Oct 2007 10:35:44 +0200
User-Agent: KMail/1.9.7
Cc: akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710071035.44781.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Typo: depricated -> deprecated

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>

---
commit b7ec07d26c9fd915fd32b759aa05a1ead8c432f5
tree 6f6dafac4072fddd670a97f68cbd64bf505d0408
parent 43dcafe3f7bfc07bdaf55d353fd4c5112c5f2be6
author Rolf Eike Beer <eike-kernel@sf-tec.de> Sun, 07 Oct 2007 10:29:39 +0200
committer Rolf Eike Beer <eike-kernel@sf-tec.de> Sun, 07 Oct 2007 10:29:39 +0200

 drivers/acpi/Kconfig            |    2 +-
 drivers/net/natsemi.c           |    2 +-
 drivers/net/tulip/winbond-840.c |    2 +-
 include/linux/cdrom.h           |    4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 4875f01..efd9690 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -52,7 +52,7 @@ config ACPI_PROCFS
 	depends on PROC_FS
 	---help---
 	  For backwards compatibility, this option allows
-	  depricated /proc/acpi/ files to exist, even when
+	  deprecated /proc/acpi/ files to exist, even when
 	  they have been replaced by functions in /sys.
 	  The deprecated files (and their replacements) include:
 
diff --git a/drivers/net/natsemi.c b/drivers/net/natsemi.c
index b47a12d..4df046d 100644
--- a/drivers/net/natsemi.c
+++ b/drivers/net/natsemi.c
@@ -997,7 +997,7 @@ static int __devinit natsemi_probe1 (struct pci_dev *pdev,
    a delay.  Note that pre-2.0.34 kernels had a cache-alignment bug that
    made udelay() unreliable.
    The old method of using an ISA access as a delay, __SLOW_DOWN_IO__, is
-   depricated.
+   deprecated.
 */
 #define eeprom_delay(ee_addr)	readl(ee_addr)
 
diff --git a/drivers/net/tulip/winbond-840.c b/drivers/net/tulip/winbond-840.c
index 5824f6a..2fad782 100644
--- a/drivers/net/tulip/winbond-840.c
+++ b/drivers/net/tulip/winbond-840.c
@@ -485,7 +485,7 @@ err_out_netdev:
    a delay.  Note that pre-2.0.34 kernels had a cache-alignment bug that
    made udelay() unreliable.
    The old method of using an ISA access as a delay, __SLOW_DOWN_IO__, is
-   depricated.
+   deprecated.
 */
 #define eeprom_delay(ee_addr)	ioread32(ee_addr)
 
diff --git a/include/linux/cdrom.h b/include/linux/cdrom.h
index 2b641b1..5394d47 100644
--- a/include/linux/cdrom.h
+++ b/include/linux/cdrom.h
@@ -76,7 +76,7 @@
                                            (struct cdrom_multisession) */
 #define CDROM_GET_MCN		0x5311 /* Obtain the "Universal Product Code" 
                                            if available (struct cdrom_mcn) */
-#define CDROM_GET_UPC		CDROM_GET_MCN  /* This one is depricated, 
+#define CDROM_GET_UPC		CDROM_GET_MCN  /* This one is deprecated, 
                                           but here anyway for compatibility */
 #define CDROMRESET		0x5312 /* hard-reset the drive */
 #define CDROMVOLREAD		0x5313 /* Get the drive's volume setting 
@@ -506,7 +506,7 @@ struct cdrom_generic_command
 #define GPMODE_TO_PROTECT_PAGE		0x1d
 #define GPMODE_CAPABILITIES_PAGE	0x2a
 #define GPMODE_ALL_PAGES		0x3f
-/* Not in Mt. Fuji, but in ATAPI 2.6 -- depricated now in favor
+/* Not in Mt. Fuji, but in ATAPI 2.6 -- deprecated now in favor
  * of MODE_SENSE_POWER_PAGE */
 #define GPMODE_CDROM_PAGE		0x0d
 
