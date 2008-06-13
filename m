Return-Path: <linux-kernel-owner+w=401wt.eu-S1758875AbYFML13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758875AbYFML13 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 07:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754841AbYFML1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 07:27:21 -0400
Received: from baikonur.stro.at ([213.239.196.228]:51989 "EHLO
	baikonur.stro.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbYFML1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 07:27:20 -0400
From: maximilian attems <max@stro.at>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
       maximilian attems <max@stro.at>,
       "Klaus S. Madsen" <ubuntu@hjernemadsen.org>,
       Chuck Short <zulcss@ubuntu.com>,
       Tim Gardner <tim.gardner@canonical.com>
Subject: [PATCH] hdaps add support for various IBM thinkpads R61/T61/T61P
Date: Fri, 13 Jun 2008 13:26:47 +0200
Message-Id: <1213356407-1220-1-git-send-email-max@stro.at>
X-Mailer: git-send-email 1.5.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

last missing hdaps ubuntu sync.
add the ubuntu entries in alphabetical order.
original authors below on Cc.

Cc: Klaus S. Madsen <ubuntu@hjernemadsen.org>
Cc: Chuck Short <zulcss@ubuntu.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: maximilian attems <max@stro.at>
---
 drivers/hwmon/hdaps.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/hdaps.c b/drivers/hwmon/hdaps.c
index 26df06f..e07c712 100644
--- a/drivers/hwmon/hdaps.c
+++ b/drivers/hwmon/hdaps.c
@@ -515,6 +515,7 @@ static struct dmi_system_id __initdata hdaps_whitelist[] = {
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad R50"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad R51"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad R52"),
+	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad R61"),
 	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad R61i"),
 	HDAPS_DMI_MATCH_INVERT("IBM", "ThinkPad T41p"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T41"),
@@ -523,6 +524,8 @@ static struct dmi_system_id __initdata hdaps_whitelist[] = {
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T43"),
 	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T60"),
 	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T61"),
+	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T61"),
+	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T61P"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad X40"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad X41"),
 	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad X60"),
-- 
1.5.5.3

