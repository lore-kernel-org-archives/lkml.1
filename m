Return-Path: <linux-kernel-owner+w=401wt.eu-S1753946AbYKFIgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbYKFIgU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 03:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbYKFIgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 03:36:12 -0500
Received: from pne-smtpout2-sn2.hy.skanova.net ([81.228.8.164]:56180 "EHLO
	pne-smtpout2-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753221AbYKFIgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 03:36:11 -0500
Message-ID: <4912AB54.1030405@euromail.se>
Date: Thu, 06 Nov 2008 09:31:16 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Nicolas Boichat <nicolas@boichat.ch>, lm-sensors@lm-sensors.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] hwmon: applesmc: Add support for Macbook 4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds accelerometer and temperature sensor support for Macbook 4.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hwmon/applesmc.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index be32859..488e45c 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -1280,7 +1280,7 @@ static __initdata struct dmi_match_data applesmc_dmi_data[] = {
 	{ .accelerometer = 0, .light = 0, .temperature_set = 4 },
 /* iMac: temperature set 5 */
 	{ .accelerometer = 0, .light = 0, .temperature_set = 5 },
-/* MacBook3: accelerometer and temperature set 6 */
+/* MacBook3, MacBook4: accelerometer and temperature set 6 */
 	{ .accelerometer = 1, .light = 0, .temperature_set = 6 },
 /* MacBook Air: accelerometer, backlight and temperature set 7 */
 	{ .accelerometer = 1, .light = 1, .temperature_set = 7 },
@@ -1329,6 +1329,10 @@ static __initdata struct dmi_system_id applesmc_whitelist[] = {
 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME,"MacBook3") },
 		&applesmc_dmi_data[6]},
+	{ applesmc_dmi_match, "Apple MacBook 4", {
+	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
+	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBook4") },
+		&applesmc_dmi_data[6]},
 	{ applesmc_dmi_match, "Apple MacBook 5", {
 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBook5") },
-- 
1.5.6.3

