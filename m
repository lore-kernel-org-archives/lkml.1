Return-Path: <linux-kernel-owner+w=401wt.eu-S1762576AbZDBSge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762576AbZDBSge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 14:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753639AbZDBSgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 14:36:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33306 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984AbZDBSgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 14:36:20 -0400
Date: Thu, 02 Apr 2009 13:36:10 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: rpurdie@rpsys.net
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH] leds: Increase trigger name maximum size
Message-ID: <49d5059a.f3z10uf0HvyIItSz%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my HP dv2815 laptop, the total length of the triggers for my b43legacy
wireless device exceeds the maximum value of 50 defined in
include/linux/leds.h. As a result, the list is garbled.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Richard,

This is 2.6.31 material.

Larry
---

Index: wireless-testing/include/linux/leds.h
===================================================================
--- wireless-testing.orig/include/linux/leds.h
+++ wireless-testing/include/linux/leds.h
@@ -74,7 +74,7 @@ extern void led_classdev_resume(struct l
  */
 #ifdef CONFIG_LEDS_TRIGGERS
 
-#define TRIG_NAME_MAX 50
+#define TRIG_NAME_MAX 70
 
 struct led_trigger {
 	/* Trigger Properties */
