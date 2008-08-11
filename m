Return-Path: <linux-kernel-owner+w=401wt.eu-S1757021AbYHKXpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021AbYHKXpX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 19:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941AbYHKXpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 19:45:11 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:59124 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879AbYHKXpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 19:45:10 -0400
Date: Mon, 11 Aug 2008 16:45:53 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: lm-sensors <lm-sensors@lm-sensors.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] ibmaem: Update the documentation to reflect the current
	name
Message-ID: <20080811234553.GD28331@tree.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor documentation update to reflect the current full name of the power
management hardware interface and reflows the text a bit.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 Documentation/hwmon/ibmaem |   33 +++++++++++++++++----------------
 drivers/hwmon/ibmaem.c     |    6 +++---
 2 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/Documentation/hwmon/ibmaem b/Documentation/hwmon/ibmaem
index 2fefaf5..e98bdfe 100644
--- a/Documentation/hwmon/ibmaem
+++ b/Documentation/hwmon/ibmaem
@@ -1,8 +1,11 @@
 Kernel driver ibmaem
 ======================
 
+This driver talks to the IBM Systems Director Active Energy Manager, known
+henceforth as AEM.
+
 Supported systems:
-  * Any recent IBM System X server with Active Energy Manager support.
+  * Any recent IBM System X server with AEM support.
     This includes the x3350, x3550, x3650, x3655, x3755, x3850 M2,
     x3950 M2, and certain HS2x/LS2x/QS2x blades.  The IPMI host interface
     driver ("ipmi-si") needs to be loaded for this driver to do anything.
@@ -14,24 +17,22 @@ Author: Darrick J. Wong
 Description
 -----------
 
-This driver implements sensor reading support for the energy and power
-meters available on various IBM System X hardware through the BMC.  All
-sensor banks will be exported as platform devices; this driver can talk
-to both v1 and v2 interfaces.  This driver is completely separate from the
-older ibmpex driver.
+This driver implements sensor reading support for the energy and power meters
+available on various IBM System X hardware through the BMC.  All sensor banks
+will be exported as platform devices; this driver can talk to both v1 and v2
+interfaces.  This driver is completely separate from the older ibmpex driver.
 
-The v1 AEM interface has a simple set of features to monitor energy use.
-There is a register that displays an estimate of raw energy consumption
-since the last BMC reset, and a power sensor that returns average power
-use over a configurable interval.
+The v1 AEM interface has a simple set of features to monitor energy use.  There
+is a register that displays an estimate of raw energy consumption since the
+last BMC reset, and a power sensor that returns average power use over a
+configurable interval.
 
-The v2 AEM interface is a bit more sophisticated, being able to present
-a wider range of energy and power use registers, the power cap as
-set by the AEM software, and temperature sensors.
+The v2 AEM interface is a bit more sophisticated, being able to present a wider
+range of energy and power use registers, the power cap as set by the AEM
+software, and temperature sensors.
 
 Special Features
 ----------------
 
-The "power_cap" value displays the current system power cap, as set by
-the Active Energy Manager software.  Setting the power cap from the host
-is not currently supported.
+The "power_cap" value displays the current system power cap, as set by the AEM
+software.  Setting the power cap from the host is not currently supported.
diff --git a/drivers/hwmon/ibmaem.c b/drivers/hwmon/ibmaem.c
index f660216..c1ee7dd 100644
--- a/drivers/hwmon/ibmaem.c
+++ b/drivers/hwmon/ibmaem.c
@@ -1,6 +1,6 @@
 /*
- * A hwmon driver for the IBM Active Energy Manager temperature/power sensors
- * and capping functionality.
+ * A hwmon driver for the IBM System Director Active Energy Manager (AEM)
+ * temperature/power/energy sensors and capping functionality.
  * Copyright (C) 2008 IBM
  *
  * Author: Darrick J. Wong <djwong@us.ibm.com>
@@ -1112,7 +1112,7 @@ static void __exit aem_exit(void)
 }
 
 MODULE_AUTHOR("Darrick J. Wong <djwong@us.ibm.com>");
-MODULE_DESCRIPTION("IBM Active Energy Manager power/temp sensor driver");
+MODULE_DESCRIPTION("IBM AEM power/temp/energy sensor driver");
 MODULE_LICENSE("GPL");
 
 module_init(aem_init);
