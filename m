Return-Path: <linux-kernel-owner+w=401wt.eu-S1759980AbXKERQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759980AbXKERQh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 12:16:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754833AbXKERIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 12:08:12 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:59533 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757698AbXKERII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 12:08:08 -0500
Date: Mon, 5 Nov 2007 18:07:45 +0100
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] power_supply_{leds,sysfs}.c should #include
	"power_supply.h"
Message-ID: <20071105170745.GU12045@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Every file should include the headers containing the prototypes for
its global functions.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/power/power_supply_leds.c  |    2 ++
 drivers/power/power_supply_sysfs.c |    2 ++
 2 files changed, 4 insertions(+)

e34cc994731ec9102bf5b1c7d6585c0aa87d1fa2 
diff --git a/drivers/power/power_supply_leds.c b/drivers/power/power_supply_leds.c
index 7f8f359..80ca288 100644
--- a/drivers/power/power_supply_leds.c
+++ b/drivers/power/power_supply_leds.c
@@ -12,6 +12,8 @@
 
 #include <linux/power_supply.h>
 
+#include "power_supply.h"
+
 /* Battery specific LEDs triggers. */
 
 static void power_supply_update_bat_leds(struct power_supply *psy)
diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index 249f61b..e8ad1fd 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -14,6 +14,8 @@
 #include <linux/ctype.h>
 #include <linux/power_supply.h>
 
+#include "power_supply.h"
+
 /*
  * This is because the name "current" breaks the device attr macro.
  * The "current" word resolves to "(get_current())" so instead of

