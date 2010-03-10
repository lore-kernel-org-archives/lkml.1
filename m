Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab0CJBaf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 20:30:35 -0500
Received: from beaker.bytemark.co.uk ([80.68.81.2]:35583 "EHLO
	beaker.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787Ab0CJBad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 20:30:33 -0500
X-Greylist: delayed 3166 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Mar 2010 20:30:33 EST
From: Mike Sheldon <mike@mikeasoft.com>
To: gregkh@suse.de, andre@bitwigglers.org, ak@linux.intel.com,
       peterhuewe@gmx.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       mike@mikeasoft.com
Subject: [PATCH] Staging: asus_oled: Remove space character mixed in with tab indentation. This patches asus_oled.c to remove a space character in the middle of some tab indentation (found by checkpatch.pl). Signed-off-by: Mike Sheldon <mike@mikeasoft.com>
Date: Wed, 10 Mar 2010 00:37:35 +0000
Message-Id: <1268181455-20437-1-git-send-email-mike@mikeasoft.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

