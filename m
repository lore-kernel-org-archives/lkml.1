Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933719Ab0BESX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 13:23:58 -0500
Received: from mail-gx0-f224.google.com ([209.85.217.224]:43526 "EHLO
	mail-gx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933696Ab0BESX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 13:23:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Hmpqo9n2yCrbMm5XSU4mbm2PE+sygfSf1+JMpBVe9gEdgBl7ulrK0eLg2ea58TfHp/
         TDXLXpeYPheQnb49rIWl3z5R7dWAcGqb/GFB4DW69BO7Gos4n14Vo49pgd2dukl1id9H
         23M8+ei2P0CUQu72h3ZQ6QI2iL0S8Yc8oatW8=
From: Chihau Chau <chihau@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Chihau Chau <chihau@gmail.com>
Subject: [PATCH 2/2] Staging: samsung-laptop: fix coding style issues
Date: Fri,  5 Feb 2010 15:23:48 -0300
Message-Id: <1265394228-13080-1-git-send-email-chihau@gmail.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chihau Chau <chihau@gmail.com>

This is the new version of the patch, I have solved your correction.

This fixes some lines over 80 characters coding style issues.

Thanks! Greg.

Signed-off-by: Chihau Chau <chihau@gmail.com>
---
 drivers/staging/samsung-laptop/samsung-laptop.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/samsung-laptop/samsung-laptop.c b/drivers/staging/samsung-laptop/samsung-laptop.c
index 4877138..8019044 100644
--- a/drivers/staging/samsung-laptop/samsung-laptop.c
+++ b/drivers/staging/samsung-laptop/samsung-laptop.c
@@ -99,7 +99,8 @@ static struct rfkill *rfk;
 
 static int force;
 module_param(force, bool, 0);
-MODULE_PARM_DESC(force, "Disable the DMI check and forces the driver to be loaded");
+MODULE_PARM_DESC(force,
+		"Disable the DMI check and forces the driver to be loaded");
 
 static int debug;
 module_param(debug, bool, S_IRUGO | S_IWUSR);
@@ -370,7 +371,8 @@ static struct dmi_system_id __initdata samsung_dmi_table[] = {
 	{
 		.ident = "N128",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+			DMI_MATCH(DMI_SYS_VENDOR,
+					"SAMSUNG ELECTRONICS CO., LTD."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "N128"),
 			DMI_MATCH(DMI_BOARD_NAME, "N128"),
 		},
@@ -379,7 +381,8 @@ static struct dmi_system_id __initdata samsung_dmi_table[] = {
 	{
 		.ident = "N130",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+			DMI_MATCH(DMI_SYS_VENDOR,
+					"SAMSUNG ELECTRONICS CO., LTD."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "N130"),
 			DMI_MATCH(DMI_BOARD_NAME, "N130"),
 		},
-- 
1.5.6.3

