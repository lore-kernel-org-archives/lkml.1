Return-Path: <linux-kernel-owner+w=401wt.eu-S1756478AbZCERhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478AbZCERhq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 12:37:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbZCERhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 12:37:38 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:50311 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753321AbZCERhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 12:37:37 -0500
Date: Thu, 5 Mar 2009 09:37:33 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: [PATCH] lm90: Document support for the MAX6648/6692 chips
Message-ID: <20090305173732.GM6550@plum>
Reply-To: djwong@us.ibm.com
References: <20090302210106.GD6550@plum> <20090305152517.4e0b8983@hyperion.delvare> <20090305154729.GL6550@plum> <20090305174418.02fd9593@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090305174418.02fd9593@hyperion.delvare>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update documentation to prevent further confusion/duplication.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/hwmon/Kconfig |    4 ++--
 drivers/hwmon/lm90.c  |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 8c312c6..7da49d3 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -550,8 +550,8 @@ config SENSORS_LM90
 	help
 	  If you say yes here you get support for National Semiconductor LM90,
 	  LM86, LM89 and LM99, Analog Devices ADM1032 and ADT7461, and Maxim
-	  MAX6646, MAX6647, MAX6649, MAX6657, MAX6658, MAX6659, MAX6680 and
-	  MAX6681 sensor chips.
+	  MAX6646, MAX6647, MAX6649, MAX6657, MAX6658, MAX6659, MAX6680,
+	  MAX6648, MAX6692 and MAX6681 sensor chips.
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called lm90.
diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index 96a7018..58012b7 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -32,10 +32,10 @@
  * supported by this driver. These chips lack the remote temperature
  * offset feature.
  *
- * This driver also supports the MAX6646, MAX6647 and MAX6649 chips
- * made by Maxim.  These are again similar to the LM86, but they use
- * unsigned temperature values and can report temperatures from 0 to
- * 145 degrees.
+ * This driver also supports the MAX6646, MAX6647, MAX6648, MAX6649, and
+ * MAX6692 chips made by Maxim.  These are again similar to the LM86,
+ * but they use unsigned temperature values and can report temperatures
+ * from 0 to 145 degrees.
  *
  * This driver also supports the MAX6680 and MAX6681, two other sensor
  * chips made by Maxim. These are quite similar to the other Maxim
