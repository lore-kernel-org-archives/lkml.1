Return-Path: <linux-kernel-owner+w=401wt.eu-S932563AbZHMU5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932563AbZHMU5B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:57:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756249AbZHMU5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:57:00 -0400
Received: from exprod6ob109.obsmtp.com ([64.18.1.22]:49156 "HELO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756238AbZHMU47 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 16:56:59 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] hwmon: include <linux/io.h> instead of <asm/io.h>
Date: Thu, 13 Aug 2009 16:56:56 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901BE9DA3@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] hwmon: include <linux/io.h> instead of <asm/io.h>
Thread-Index: AcocWJfD364c2obaQpCiWn1G/SY73g==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <lm-sensors@lm-sensors.org>, <mactel-linux-devel@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>
Cc: <alistair@devzero.co.uk>, <nicolas@boichat.ch>, <juergh@gmail.com>,
       <khali@linux-fr.org>, <frank@f-seidel.de>, <jim.cromie@gmail.com>,
       <mhoffman@lightlink.com>, <vt8231@hiddenengine.co.uk>
X-OriginalArrivalTime: 13 Aug 2009 20:56:57.0559 (UTC) FILETIME=[988D7E70:01CA1C58]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers should be including <linux/io.h> instead of <asm/io.h>.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Alistair John Strachan <alistair@devzero.co.uk>
Cc: Nicolas Boichat <nicolas@boichat.ch>
Cc: Juerg Haefliger <juergh@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Frank Seidel <frank@f-seidel.de>
Cc: Jim Cromie <jim.cromie@gmail.com>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: Roger Lucas <vt8231@hiddenengine.co.uk>

---

diff --git a/drivers/hwmon/abituguru.c b/drivers/hwmon/abituguru.c
index 4dbdb81..03694cc 100644
--- a/drivers/hwmon/abituguru.c
+++ b/drivers/hwmon/abituguru.c
@@ -32,7 +32,7 @@
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
 #include <linux/dmi.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 /* Banks */
 #define ABIT_UGURU_ALARM_BANK			0x20 /* 1x 3 bytes */
diff --git a/drivers/hwmon/abituguru3.c b/drivers/hwmon/abituguru3.c
index 7d3f15d..ad6f8b7 100644
--- a/drivers/hwmon/abituguru3.c
+++ b/drivers/hwmon/abituguru3.c
@@ -34,7 +34,7 @@
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
 #include <linux/dmi.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 /* uGuru3 bank addresses */
 #define ABIT_UGURU3_SETTINGS_BANK		0x01
diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 678e34b..753b348 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -35,7 +35,7 @@
 #include <linux/dmi.h>
 #include <linux/mutex.h>
 #include <linux/hwmon-sysfs.h>
-#include <asm/io.h>
+#include <linux/io.h>
 #include <linux/leds.h>
 #include <linux/hwmon.h>
 #include <linux/workqueue.h>
diff --git a/drivers/hwmon/dme1737.c b/drivers/hwmon/dme1737.c
index 3df202a..9814d51 100644
--- a/drivers/hwmon/dme1737.c
+++ b/drivers/hwmon/dme1737.c
@@ -35,7 +35,7 @@
 #include <linux/err.h>
 #include <linux/mutex.h>
 #include <linux/acpi.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 /* ISA device, if found */
 static struct platform_device *pdev;
diff --git a/drivers/hwmon/f71805f.c b/drivers/hwmon/f71805f.c
index 8998765..525a00b 100644
--- a/drivers/hwmon/f71805f.c
+++ b/drivers/hwmon/f71805f.c
@@ -40,7 +40,7 @@
 #include <linux/sysfs.h>
 #include <linux/ioport.h>
 #include <linux/acpi.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 static unsigned short force_id;
 module_param(force_id, ushort, 0);
diff --git a/drivers/hwmon/hdaps.c b/drivers/hwmon/hdaps.c
index d3612a1..be2d131 100644
--- a/drivers/hwmon/hdaps.c
+++ b/drivers/hwmon/hdaps.c
@@ -35,8 +35,7 @@
 #include <linux/timer.h>
 #include <linux/dmi.h>
 #include <linux/jiffies.h>
-
-#include <asm/io.h>
+#include <linux/io.h>
 
 #define HDAPS_LOW_PORT		0x1600	/* first port used by hdaps */
 #define HDAPS_NR_PORTS		0x30	/* number of ports: 0x1600 - 0x162f */
diff --git a/drivers/hwmon/it87.c b/drivers/hwmon/it87.c
index 9157247..ffeb2a1 100644
--- a/drivers/hwmon/it87.c
+++ b/drivers/hwmon/it87.c
@@ -50,7 +50,7 @@
 #include <linux/string.h>
 #include <linux/dmi.h>
 #include <linux/acpi.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 #define DRVNAME "it87"
 
diff --git a/drivers/hwmon/lm78.c b/drivers/hwmon/lm78.c
index a1787fd..f7e7016 100644
--- a/drivers/hwmon/lm78.c
+++ b/drivers/hwmon/lm78.c
@@ -31,7 +31,7 @@
 #include <linux/hwmon-sysfs.h>
 #include <linux/err.h>
 #include <linux/mutex.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 /* ISA device, if found */
 static struct platform_device *pdev;
diff --git a/drivers/hwmon/pc87360.c b/drivers/hwmon/pc87360.c
index fb052fe..4a64b85 100644
--- a/drivers/hwmon/pc87360.c
+++ b/drivers/hwmon/pc87360.c
@@ -44,7 +44,7 @@
 #include <linux/err.h>
 #include <linux/mutex.h>
 #include <linux/acpi.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 static u8 devid;
 static struct platform_device *pdev;
diff --git a/drivers/hwmon/pc87427.c b/drivers/hwmon/pc87427.c
index 3a8a0f7..4e0de0e 100644
--- a/drivers/hwmon/pc87427.c
+++ b/drivers/hwmon/pc87427.c
@@ -33,7 +33,7 @@
 #include <linux/sysfs.h>
 #include <linux/ioport.h>
 #include <linux/acpi.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 static unsigned short force_id;
 module_param(force_id, ushort, 0);
diff --git a/drivers/hwmon/sis5595.c b/drivers/hwmon/sis5595.c
index aa2e831..12f2e70 100644
--- a/drivers/hwmon/sis5595.c
+++ b/drivers/hwmon/sis5595.c
@@ -63,7 +63,7 @@
 #include <linux/mutex.h>
 #include <linux/sysfs.h>
 #include <linux/acpi.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 
 /* If force_addr is set to anything different from 0, we forcibly enable
diff --git a/drivers/hwmon/smsc47b397.c b/drivers/hwmon/smsc47b397.c
index 6f6d52b..f46d936 100644
--- a/drivers/hwmon/smsc47b397.c
+++ b/drivers/hwmon/smsc47b397.c
@@ -37,7 +37,7 @@
 #include <linux/init.h>
 #include <linux/mutex.h>
 #include <linux/acpi.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 static unsigned short force_id;
 module_param(force_id, ushort, 0);
diff --git a/drivers/hwmon/smsc47m1.c b/drivers/hwmon/smsc47m1.c
index ba75bfc..8ad50fd 100644
--- a/drivers/hwmon/smsc47m1.c
+++ b/drivers/hwmon/smsc47m1.c
@@ -38,7 +38,7 @@
 #include <linux/mutex.h>
 #include <linux/sysfs.h>
 #include <linux/acpi.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 static unsigned short force_id;
 module_param(force_id, ushort, 0);
diff --git a/drivers/hwmon/via686a.c b/drivers/hwmon/via686a.c
index a022aed..39e82a4 100644
--- a/drivers/hwmon/via686a.c
+++ b/drivers/hwmon/via686a.c
@@ -42,7 +42,7 @@
 #include <linux/mutex.h>
 #include <linux/sysfs.h>
 #include <linux/acpi.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 
 /* If force_addr is set to anything different from 0, we forcibly enable
diff --git a/drivers/hwmon/vt1211.c b/drivers/hwmon/vt1211.c
index 73f77a9..120b5d6 100644
--- a/drivers/hwmon/vt1211.c
+++ b/drivers/hwmon/vt1211.c
@@ -33,7 +33,7 @@
 #include <linux/mutex.h>
 #include <linux/ioport.h>
 #include <linux/acpi.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 static int uch_config = -1;
 module_param(uch_config, int, 0);
diff --git a/drivers/hwmon/vt8231.c b/drivers/hwmon/vt8231.c
index 9982b45..470a122 100644
--- a/drivers/hwmon/vt8231.c
+++ b/drivers/hwmon/vt8231.c
@@ -36,7 +36,7 @@
 #include <linux/err.h>
 #include <linux/mutex.h>
 #include <linux/acpi.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 static int force_addr;
 module_param(force_addr, int, 0);
diff --git a/drivers/hwmon/w83627ehf.c b/drivers/hwmon/w83627ehf.c
index 0e97469..bb5e787 100644
--- a/drivers/hwmon/w83627ehf.c
+++ b/drivers/hwmon/w83627ehf.c
@@ -51,7 +51,7 @@
 #include <linux/err.h>
 #include <linux/mutex.h>
 #include <linux/acpi.h>
-#include <asm/io.h>
+#include <linux/io.h>
 #include "lm75.h"
 
 enum kinds { w83627ehf, w83627dhg, w83627dhg_p, w83667hg };
diff --git a/drivers/hwmon/w83627hf.c b/drivers/hwmon/w83627hf.c
index 389150b..2be28ac 100644
--- a/drivers/hwmon/w83627hf.c
+++ b/drivers/hwmon/w83627hf.c
@@ -51,7 +51,7 @@
 #include <linux/mutex.h>
 #include <linux/ioport.h>
 #include <linux/acpi.h>
-#include <asm/io.h>
+#include <linux/io.h>
 #include "lm75.h"
 
 static struct platform_device *pdev;
diff --git a/drivers/hwmon/w83781d.c b/drivers/hwmon/w83781d.c
index 0bdab95..d27ed1b 100644
--- a/drivers/hwmon/w83781d.c
+++ b/drivers/hwmon/w83781d.c
@@ -48,7 +48,7 @@
 #ifdef CONFIG_ISA
 #include <linux/platform_device.h>
 #include <linux/ioport.h>
-#include <asm/io.h>
+#include <linux/io.h>
 #endif
 
 #include "lm75.h" 
