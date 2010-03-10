Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab0CJBbQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 20:31:16 -0500
Received: from waldorf.bytemark.co.uk ([212.110.162.22]:45627 "EHLO
	waldorf.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab0CJBbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 20:31:14 -0500
X-Greylist: delayed 2901 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Mar 2010 20:31:14 EST
From: Mike Sheldon <mike@mikeasoft.com>
To: gregkh@suse.de, andre@bitwigglers.org, ak@linux.intel.com,
       peterhuewe@gmx.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       mike@mikeasoft.com
Subject: [PATCH] Staging: asus_oled: Remove space character mixed in with tab indentation.
Date: Wed, 10 Mar 2010 00:42:39 +0000
Message-Id: <1268181759-20639-1-git-send-email-mike@mikeasoft.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 This patches asus_oled.c to remove a space character in the middle of some tab indentation (found by checkpatch.pl).
 Signed-off-by: Mike Sheldon <mike@mikeasoft.com>

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
1.7.0

