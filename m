Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab0BBHza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 02:55:30 -0500
Received: from iksaif.net ([88.191.73.63]:50270 "EHLO iksaif.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755862Ab0BBHwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 02:52:10 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Corentin Chary <corentincj@iksaif.net>
Subject: [PATCH 19/28] asus-laptop: rename wireless_status to wlan_status to avoid confusion
Date: Tue,  2 Feb 2010 08:39:02 +0100
Message-Id: <1265096351-15239-20-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1265096351-15239-19-git-send-email-corentincj@iksaif.net>
References: <1265096351-15239-1-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-2-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-3-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-4-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-5-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-6-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-7-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-8-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-9-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-10-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-11-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-12-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-13-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-14-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-15-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-16-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-17-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-18-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-19-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/asus-laptop.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index aad6b93..bb8fb45 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -76,11 +76,11 @@ static uint wapf = 1;
 module_param(wapf, uint, 0644);
 MODULE_PARM_DESC(wapf, "WAPF value");
 
-static uint wireless_status = 1;
+static uint wlan_status = 1;
 static uint bluetooth_status = 1;
 
-module_param(wireless_status, uint, 0644);
-MODULE_PARM_DESC(wireless_status, "Set the wireless status on boot "
+module_param(wlan_status, uint, 0644);
+MODULE_PARM_DESC(wlan_status, "Set the wireless status on boot "
 		 "(0 = disabled, 1 = enabled, -1 = don't do anything). "
 		 "default is 1");
 
@@ -1446,8 +1446,8 @@ static int __devinit asus_acpi_init(struct asus_laptop *asus)
 	if (bluetooth_status >= 0)
 		asus_bluetooth_set(asus, !!bluetooth_status);
 
-	if (wireless_status >= 0)
-		asus_wlan_set(asus, !!wireless_status);
+	if (wlan_status >= 0)
+		asus_wlan_set(asus, !!wlan_status);
 
 	/* Keyboard Backlight is on by default */
 	if (!acpi_check_handle(asus->handle, METHOD_KBD_LIGHT_SET, NULL))
-- 
1.6.6.1

