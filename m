Return-Path: <linux-kernel-owner+w=401wt.eu-S1756911AbYKTTV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbYKTTV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 14:21:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756261AbYKTTVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 14:21:13 -0500
Received: from csmtp1.one.com ([195.47.247.21]:57036 "EHLO csmtp1.b-one.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756162AbYKTTVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 14:21:12 -0500
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Nov 2008 14:21:12 EST
Message-ID: <4925B6F8.5040500@bitmath.org>
Date: Thu, 20 Nov 2008 20:14:00 +0100
From: Henrik Rydberg <rydberg@bitmath.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Nicolas Boichat <nicolas@boichat.ch>, lm-sensors@lm-sensors.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] hwmon: applesmc: Make applesmc load automatically on startup
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes use of the new dmi device loading support to
automatically load the applesmc driver based on the dmi_match table.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hwmon/applesmc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 488e45c..3e18f19 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -1551,3 +1551,4 @@ module_exit(applesmc_exit);
 MODULE_AUTHOR("Nicolas Boichat");
 MODULE_DESCRIPTION("Apple SMC");
 MODULE_LICENSE("GPL v2");
+MODULE_DEVICE_TABLE(dmi, applesmc_whitelist);
-- 
1.5.6.3


