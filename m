Return-Path: <linux-kernel-owner+w=401wt.eu-S1759708AbXKTBzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759708AbXKTBzP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:55:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756385AbXKTBtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:49:20 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2067 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756355AbXKTBtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:49:03 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Roger Lucas <roger@planbit.co.uk>, lm-sensors@lm-sensors.org
Subject: [PATCH 15/59] drivers/hwmon: Add missing "space"
Date: Mon, 19 Nov 2007 17:48:07 -0800
Message-Id: <1195523331-15303-16-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.6.728.gea559
In-Reply-To: <1195523331-15303-15-git-send-email-joe@perches.com>
References: 1234567
 <1195523331-15303-1-git-send-email-joe@perches.com>
 <1195523331-15303-2-git-send-email-joe@perches.com>
 <1195523331-15303-3-git-send-email-joe@perches.com>
 <1195523331-15303-4-git-send-email-joe@perches.com>
 <1195523331-15303-5-git-send-email-joe@perches.com>
 <1195523331-15303-6-git-send-email-joe@perches.com>
 <1195523331-15303-7-git-send-email-joe@perches.com>
 <1195523331-15303-8-git-send-email-joe@perches.com>
 <1195523331-15303-9-git-send-email-joe@perches.com>
 <1195523331-15303-10-git-send-email-joe@perches.com>
 <1195523331-15303-11-git-send-email-joe@perches.com>
 <1195523331-15303-12-git-send-email-joe@perches.com>
 <1195523331-15303-13-git-send-email-joe@perches.com>
 <1195523331-15303-14-git-send-email-joe@perches.com>
 <1195523331-15303-15-git-send-email-joe@perches.com>
Message-Id: <e2a957ca2937d67956712a66e7388dcd2f95cf90.1195454435.git.joe@perches.com>
In-Reply-To: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/hwmon/vt8231.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/vt8231.c b/drivers/hwmon/vt8231.c
index 2196a84..f876617 100644
--- a/drivers/hwmon/vt8231.c
+++ b/drivers/hwmon/vt8231.c
@@ -504,7 +504,7 @@ static ssize_t set_fan_div(struct device *dev, struct device_attribute *attr,
 	case 4: data->fan_div[nr] = 2; break;
 	case 8: data->fan_div[nr] = 3; break;
 	default:
-		dev_err(dev, "fan_div value %ld not supported."
+		dev_err(dev, "fan_div value %ld not supported. "
 		        "Choose one of 1, 2, 4 or 8!\n", val);
 		mutex_unlock(&data->update_lock);
 		return -EINVAL;
-- 
1.5.3.5.652.gf192c

