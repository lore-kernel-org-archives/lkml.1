Return-Path: <linux-kernel-owner+w=401wt.eu-S1754493AbYFOW1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbYFOW1L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 18:27:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751131AbYFOW1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 18:27:00 -0400
Received: from baikonur.stro.at ([213.239.196.228]:36190 "EHLO
	baikonur.stro.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbYFOW07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 18:26:59 -0400
From: maximilian attems <max@stro.at>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
       maximilian attems <max@stro.at>,
       "Klaus S. Madsen" <ubuntu@hjernemadsen.org>,
       Chuck Short <zulcss@ubuntu.com>,
       Tim Gardner <tim.gardner@canonical.com>
Subject: [PATCH] hdaps add support for various newer Lenovo thinkpads
Date: Mon, 16 Jun 2008 00:26:48 +0200
Message-Id: <1213568808-6184-1-git-send-email-max@stro.at>
X-Mailer: git-send-email 1.5.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

adds R61, T61p, X61s, X61, Z61m, Z61p models to whitelist.

originally based on an Ubuntu patch that got it wrong,
the dmidecode output of the corresponding laptops
shows LENOVO as the manufacturer.
https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.22/+bug/133636

tested on X61s:
[  184.893588] hdaps: inverting axis readings.
[  184.893588] hdaps: LENOVO ThinkPad X61s detected.
[  184.893588] input: hdaps as /class/input/input12
[  184.924326] hdaps: driver successfully loaded.

original authors below on Cc.

Cc: Klaus S. Madsen <ubuntu@hjernemadsen.org>
Cc: Chuck Short <zulcss@ubuntu.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: maximilian attems <max@stro.at>
---
 drivers/hwmon/hdaps.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/hdaps.c b/drivers/hwmon/hdaps.c
index 26df06f..50f2269 100644
--- a/drivers/hwmon/hdaps.c
+++ b/drivers/hwmon/hdaps.c
@@ -516,17 +516,23 @@ static struct dmi_system_id __initdata hdaps_whitelist[] = {
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad R51"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad R52"),
 	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad R61i"),
+	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad R61"),
 	HDAPS_DMI_MATCH_INVERT("IBM", "ThinkPad T41p"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T41"),
 	HDAPS_DMI_MATCH_INVERT("IBM", "ThinkPad T42p"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T42"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T43"),
 	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T60"),
+	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T61p"),
 	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T61"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad X40"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad X41"),
 	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad X60"),
+	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad X61s"),
+	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad X61"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad Z60m"),
+	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad Z61m"),
+	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad Z61p"),
 	{ .ident = NULL }
 };
 
-- 
1.5.5.3

