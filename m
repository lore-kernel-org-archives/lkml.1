Return-Path: <linux-kernel-owner+w=401wt.eu-S1756947AbYAFM1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947AbYAFM1h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 07:27:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbYAFM1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 07:27:30 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:27586 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbYAFM13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 07:27:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=kqv2e0w0O7Z3fR6jFnlu0EWqv7WctuMsyWB0JdJ7E2wCoWbtATfL3aMHj5SYgGE8owuy76AtJjZi03UjgNRMRHCLmuMZsREeqM9Db5cEKc8nqdmLWsRE5TsOkaEUu106GvzWINEY6KIy7GyaV0weeAMV0Y87HPH9aAHTT5Zotu4=
Date: Sun, 6 Jan 2008 15:27:18 +0300
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: cbouatmailru@gmail.com, linux-kernel@vger.kernel.org, cbou@mail.ru,
       dwmw2@infradead.org
Subject: [PATCH 1/3] power_supply: add few more values and props
Message-ID: <20080106122659.GA13106@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add LiMn (one of the most common for small non-rechargable batteries)i
battery technology and voltage_min/_max properties support.

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>


diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index 249f61b..45d2f95 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -46,7 +46,8 @@ static ssize_t power_supply_show_property(struct device *dev,
 		"Unspecified failure"
 	};
 	static char *technology_text[] = {
-		"Unknown", "NiMH", "Li-ion", "Li-poly", "LiFe", "NiCd"
+		"Unknown", "NiMH", "Li-ion", "Li-poly", "LiFe", "NiCd",
+		"LiMn"
 	};
 	static char *capacity_level_text[] = {
 		"Unknown", "Critical", "Low", "Normal", "High", "Full"
@@ -88,6 +89,8 @@ static struct device_attribute power_supply_attrs[] = {
 	POWER_SUPPLY_ATTR(present),
 	POWER_SUPPLY_ATTR(online),
 	POWER_SUPPLY_ATTR(technology),
+	POWER_SUPPLY_ATTR(voltage_max),
+	POWER_SUPPLY_ATTR(voltage_min),
 	POWER_SUPPLY_ATTR(voltage_max_design),
 	POWER_SUPPLY_ATTR(voltage_min_design),
 	POWER_SUPPLY_ATTR(voltage_now),
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 606c095..cdbc5b8 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -54,6 +54,7 @@ enum {
 	POWER_SUPPLY_TECHNOLOGY_LIPO,
 	POWER_SUPPLY_TECHNOLOGY_LiFe,
 	POWER_SUPPLY_TECHNOLOGY_NiCd,
+	POWER_SUPPLY_TECHNOLOGY_LiMn,
 };
 
 enum {
@@ -72,6 +73,8 @@ enum power_supply_property {
 	POWER_SUPPLY_PROP_PRESENT,
 	POWER_SUPPLY_PROP_ONLINE,
 	POWER_SUPPLY_PROP_TECHNOLOGY,
+	POWER_SUPPLY_PROP_VOLTAGE_MAX,
+	POWER_SUPPLY_PROP_VOLTAGE_MIN,
 	POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN,
 	POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN,
 	POWER_SUPPLY_PROP_VOLTAGE_NOW,
-- 
With best wishes
Dmitry

