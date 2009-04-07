Return-Path: <linux-kernel-owner+w=401wt.eu-S1761263AbZDGUwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761263AbZDGUwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 16:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755935AbZDGUv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 16:51:59 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:56622 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753377AbZDGUv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 16:51:58 -0400
Date: Tue, 7 Apr 2009 13:51:54 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Jean Delvare <khali@linux-fr.org>
Cc: lm-sensors <lm-sensors@lm-sensors.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] ibmaem: Automatically load on HC10 blade
Message-ID: <20090407205153.GA8311@plum>
Reply-To: djwong@us.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable auto-probing for the HC10 blade and amend the supported system list.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 Documentation/hwmon/ibmaem |    2 +-
 drivers/hwmon/Kconfig      |    2 +-
 drivers/hwmon/ibmaem.c     |    1 +
 3 files changed, 3 insertions(+), 2 deletions(-)


diff --git a/Documentation/hwmon/ibmaem b/Documentation/hwmon/ibmaem
index e98bdfe..1e0d59e 100644
--- a/Documentation/hwmon/ibmaem
+++ b/Documentation/hwmon/ibmaem
@@ -7,7 +7,7 @@ henceforth as AEM.
 Supported systems:
   * Any recent IBM System X server with AEM support.
     This includes the x3350, x3550, x3650, x3655, x3755, x3850 M2,
-    x3950 M2, and certain HS2x/LS2x/QS2x blades.  The IPMI host interface
+    x3950 M2, and certain HC10/HS2x/LS2x/QS2x blades.  The IPMI host interface
     driver ("ipmi-si") needs to be loaded for this driver to do anything.
     Prefix: 'ibmaem'
     Datasheet: Not available
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index b4eea02..208d0c7 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -395,7 +395,7 @@ config SENSORS_IBMAEM
 	  power sensors and capping hardware in various IBM System X
 	  servers that support Active Energy Manager.  This includes
 	  the x3350, x3550, x3650, x3655, x3755, x3850 M2, x3950 M2,
-	  and certain HS2x/LS2x/QS2x blades.
+	  and certain HC10/HS2x/LS2x/QS2x blades.
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called ibmaem.
diff --git a/drivers/hwmon/ibmaem.c b/drivers/hwmon/ibmaem.c
index fe74609..405d3fb 100644
--- a/drivers/hwmon/ibmaem.c
+++ b/drivers/hwmon/ibmaem.c
@@ -1127,3 +1127,4 @@ MODULE_ALIAS("dmi:bvnIBM:*:pnIBMSystemx3650-*");
 MODULE_ALIAS("dmi:bvnIBM:*:pnIBMSystemx3655-*");
 MODULE_ALIAS("dmi:bvnIBM:*:pnIBMSystemx3755-*");
 MODULE_ALIAS("dmi:bvnIBM:*:pnIBM3850M2/x3950M2-*");
+MODULE_ALIAS("dmi:bvnIBM:*:pnIBMBladeHC10-*");
