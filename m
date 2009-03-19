Return-Path: <linux-kernel-owner+w=401wt.eu-S1756851AbZCSWGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851AbZCSWGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 18:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755143AbZCSWG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 18:06:27 -0400
Received: from pne-smtpout2-sn1.fre.skanova.net ([81.228.11.159]:49061 "EHLO
	pne-smtpout2-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751983AbZCSWG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 18:06:26 -0400
X-Greylist: delayed 4152 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Mar 2009 18:06:26 EDT
From: =?utf-8?q?Erik=20Andr=C3=A9n?= <erik.andren@gmail.com>
To: greg@kroah.com
Cc: sjakub@gmail.com, linux-kernel@vger.kernel.org,
       =?utf-8?q?Erik=20Andr=C3=A9n?= <erik.andren@gmail.com>
Subject: [PATCH 1/1] Fixup asus_oled.c
Date: Thu, 19 Mar 2009 21:57:07 +0100
Message-Id: <1237496227-6078-2-git-send-email-erik.andren@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1237496227-6078-1-git-send-email-erik.andren@gmail.com>
References: <1>
 <1237496227-6078-1-git-send-email-erik.andren@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/asus_oled/asus_oled.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/asus_oled/asus_oled.c b/drivers/staging/asus_oled/asus_oled.c
index d81f4bd..7a40f61 100644
--- a/drivers/staging/asus_oled/asus_oled.c
+++ b/drivers/staging/asus_oled/asus_oled.c
@@ -522,7 +522,7 @@ static ssize_t odev_set_picture(struct asus_oled_dev *odev, const char *buf, siz
 			line were equal to the last character in this line. */
 			if (odev->buf_offs % odev->width != 0) {
 				ret = append_values(odev, odev->last_val,
-					odev->width - (odev->buf_offs % odev->width);
+					odev->width - (odev->buf_offs % odev->width));
 				if (ret < 0)
 					return ret;
 			}
-- 
1.6.0.4

