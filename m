Return-Path: <linux-kernel-owner+w=401wt.eu-S1752164AbZCIN1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbZCIN1G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 09:27:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751271AbZCIN0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 09:26:31 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:35594 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751227AbZCIN01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 09:26:27 -0400
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Alessandro Zummo <alessandro.zummo@towertech.it>,
       Kyle McMartin <kyle@mcmartin.ca>
Cc: rtc-linux@googlegroups.com, linux-parisc@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
       Dann Frazier <dannf@dannf.org>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH 1/7] parisc: rtc: get_rtc_time() returns unsigned int
Date: Mon,  9 Mar 2009 14:26:17 +0100
Message-Id: <1236605183-22718-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1236605183-22718-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
References: <1236605183-22718-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 drivers/rtc/rtc-parisc.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-parisc.c b/drivers/rtc/rtc-parisc.c
index b966f56..620b949 100644
--- a/drivers/rtc/rtc-parisc.c
+++ b/drivers/rtc/rtc-parisc.c
@@ -13,9 +13,7 @@
 
 static int parisc_get_time(struct device *dev, struct rtc_time *tm)
 {
-	unsigned long ret;
-
-	ret = get_rtc_time(tm);
+	unsigned int ret = get_rtc_time(tm);
 
 	if (ret & RTC_BATT_BAD)
 		return -EOPNOTSUPP;
-- 
1.6.0.4

