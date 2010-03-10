Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab0CJVDd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 16:03:33 -0500
Received: from mail-ew0-f216.google.com ([209.85.219.216]:37267 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757113Ab0CJVDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 16:03:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=RdW+BA5OQMF68CgPKNvEEb2Ynmfa8YXpEyxvWPayx/DEr2YiY7++vnN+Ldn/IwAhXR
         Hxla+Mr2igBrGg+n3VlXWKnSQLr4KOWUGu0pOBtANii1S5IaTqeOeq58fL0ujv0jR7UR
         P+NWpb+R8M6L/Oc6ALHiEKgYtKVMqEsCaYWS8=
From: wouter.vanrooy@gmail.com
To: gregkh@suse.de
Cc: andre@bitwigglers.org, ak@linux.intel.com, peterhuewe@gmx.de,
       kevin.granade@gmail.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: asus_oled: fix space where tab should be This patches the asus_oled.c file so that checkpatch.pl doesn't provide any more warnings. Signed-off-by: Wouter Van Rooy <wouter.vanrooy@gmail.com>
Date: Wed, 10 Mar 2010 22:00:15 +0100
Message-Id: <1268254815-11995-1-git-send-email-wouter.vanrooy@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: wouter <wouter@wouter-desktop.(none)>

---
 drivers/staging/asus_oled/asus_oled.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/asus_oled/asus_oled.c b/drivers/staging/asus_oled/asus_oled.c
index 7ebecc9..5b279fb 100644
--- a/drivers/staging/asus_oled/asus_oled.c
+++ b/drivers/staging/asus_oled/asus_oled.c
@@ -771,7 +771,7 @@ static struct usb_driver oled_driver = {
 };
 
 static CLASS_ATTR_STRING(version, S_IRUGO,
-		 	ASUS_OLED_UNDERSCORE_NAME " " ASUS_OLED_VERSION);
+			ASUS_OLED_UNDERSCORE_NAME " " ASUS_OLED_VERSION);
 
 static int __init asus_oled_init(void)
 {
-- 
1.6.3.3

