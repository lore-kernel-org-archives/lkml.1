Return-Path: <linux-kernel-owner+w=401wt.eu-S1755490AbYK1ToS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbYK1ToS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 14:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753609AbYK1Tn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 14:43:58 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:55851 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbYK1Tn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 14:43:57 -0500
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Cc: trivial@kernel.org
Date: Fri, 28 Nov 2008 17:01:35 +0100
Subject: [PATCH] rtc-ds1511: fix sparse warning
From: Hannes Eder <hannes@hanneseder.net>
Message-ID: <493049fa.06a1660a.3655.ffffab3c@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warning:

  drivers/rtc/rtc-ds1511.c:634:2: warning: returning void-valued expression

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/rtc/rtc-ds1511.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-ds1511.c b/drivers/rtc/rtc-ds1511.c
index 25caada..062a1d1 100644
--- a/drivers/rtc/rtc-ds1511.c
+++ b/drivers/rtc/rtc-ds1511.c
@@ -631,7 +631,7 @@ ds1511_rtc_init(void)
  static void __exit
 ds1511_rtc_exit(void)
 {
-	return platform_driver_unregister(&ds1511_rtc_driver);
+	platform_driver_unregister(&ds1511_rtc_driver);
 }
 
 module_init(ds1511_rtc_init);
-- 
1.5.6.3

