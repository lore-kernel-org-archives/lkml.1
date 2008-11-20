Return-Path: <linux-kernel-owner+w=401wt.eu-S1755364AbYKTPYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbYKTPYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 10:24:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755140AbYKTPXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 10:23:45 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41459 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754951AbYKTPXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 10:23:43 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Samuel Ortiz <sameo@openedhand.com>, linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] power_supply: Add cold to the POWER_SUPPLY_HEALTH report values
Date: Thu, 20 Nov 2008 15:23:40 +0000
Message-Id: <1227194621-16442-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20081120152044.GA15434@rakim.wolfsonmicro.main>
References: <20081120152044.GA15434@rakim.wolfsonmicro.main>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some systems are able to report problems with batteries being under
temperature.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/power/power_supply_sysfs.c |    2 +-
 include/linux/power_supply.h       |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index 23ae846..ac01e06 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -45,7 +45,7 @@ static ssize_t power_supply_show_property(struct device *dev,
 	};
 	static char *health_text[] = {
 		"Unknown", "Good", "Overheat", "Dead", "Over voltage",
-		"Unspecified failure"
+		"Unspecified failure", "Cold",
 	};
 	static char *technology_text[] = {
 		"Unknown", "NiMH", "Li-ion", "Li-poly", "LiFe", "NiCd",
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index f9348cb..8ff25e0 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -45,6 +45,7 @@ enum {
 	POWER_SUPPLY_HEALTH_DEAD,
 	POWER_SUPPLY_HEALTH_OVERVOLTAGE,
 	POWER_SUPPLY_HEALTH_UNSPEC_FAILURE,
+	POWER_SUPPLY_HEALTH_COLD,
 };
 
 enum {
-- 
1.5.6.5

