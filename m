Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab0BPNJt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 08:09:49 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:40443 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919Ab0BPNJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 08:09:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=W3S2K/q/Jyqs8ybYQmy7cZ+8vDkMWEQ1s0Pi+Ul1FtKf/RfDtYyoEJV8e49LJTCnz3
         UTnvMnIr2jhjnquYmWg4c40HefmY0bCnwgxcep9q45iHzrv/fWXoEtL3HE7lL1+S4r8G
         p7bck1goVqXLeS3s8LcecSyul15n8OJH8AuRQ=
From: Tom Van Braeckel <tomvanbraeckel@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Tom Van Braeckel <tomvanbraeckel@gmail.com>
Subject: [PATCH 1/1] Staging: samsung-laptop: fix coding style
Date: Tue, 16 Feb 2010 14:09:35 +0100
Message-Id: <1266325775-30119-1-git-send-email-tomvanbraeckel@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Tom Van Braeckel <tomvanbraeckel@gmail.com>
---
 drivers/staging/samsung-laptop/samsung-laptop.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/samsung-laptop/samsung-laptop.c b/drivers/staging/samsung-laptop/samsung-laptop.c
index 4877138..dd7ea4c 100644
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
1.6.3.3

