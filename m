Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab0COKjh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 06:39:37 -0400
Received: from mail-fx0-f219.google.com ([209.85.220.219]:41581 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab0COKje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 06:39:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=NHETrnmmepuhrWMk+UHcf0uyWG+BZVh0jqkH+p8VQ/tUtFuA72kcaMiJPNilh7rx4a
         DqtwWEDno0AXe02Ci8eMQM9c1hZNPy7GrH5QObSs9FO4mIiU7++d71ZCmF/JHXHAv4Yl
         WgEQyd2nLBz+7yLNAPUUuBPDprrXpN4HeGfLw=
From: ruslanpisarev@gmail.com
To: gregkh@suse.de
Cc: andre@bitwigglers.org, eugeni@mandriva.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, ruslan <ruslan@rpisarev.org.ua>
Subject: [PATCH] Staging: asus_oled: fix spaces and TAB coding style issue in asus_oled.c
Date: Mon, 15 Mar 2010 12:39:27 +0200
Message-Id: <1268649567-14876-1-git-send-email-ruslan@rpisarev.org.ua>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ruslan <ruslan@rpisarev.org.ua>

This is a patch to the asus_oled.c file that fixed up a TAB and spaces
Errors found by the checkpatch.pl tools

Signed-off-by: Ruslan Pisarev <ruslan@rpisarev.org.ua>
---
 drivers/staging/asus_oled/asus_oled.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/asus_oled/asus_oled.c b/drivers/staging/asus_oled/asus_oled.c
index 7ebecc9..9f12f08 100644
--- a/drivers/staging/asus_oled/asus_oled.c
+++ b/drivers/staging/asus_oled/asus_oled.c
@@ -771,7 +771,7 @@ static struct usb_driver oled_driver = {
 };
 
 static CLASS_ATTR_STRING(version, S_IRUGO,
-		 	ASUS_OLED_UNDERSCORE_NAME " " ASUS_OLED_VERSION);
+		ASUS_OLED_UNDERSCORE_NAME " " ASUS_OLED_VERSION);
 
 static int __init asus_oled_init(void)
 {
-- 
1.6.3.3

