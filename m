Return-Path: <linux-kernel-owner+w=401wt.eu-S1764792AbXG2PAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764792AbXG2PAX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:00:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764043AbXG2O50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 10:57:26 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:47771 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763833AbXG2O5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 10:57:24 -0400
Date: Sun, 29 Jul 2007 16:57:01 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Hans de Goede <j.w.r.degoede@hhs.nl>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make abituguru3_read_increment_offset() static
Message-ID: <20070729145701.GJ16817@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

abituguru3_read_increment_offset() can become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.23-rc1-mm1/drivers/hwmon/abituguru3.c.old	2007-07-26 08:56:33.000000000 +0200
+++ linux-2.6.23-rc1-mm1/drivers/hwmon/abituguru3.c	2007-07-26 08:57:00.000000000 +0200
@@ -691,8 +691,9 @@
 
 /* Sensor settings are stored 1 byte per offset with the bytes
    placed add consecutive offsets. */
-int abituguru3_read_increment_offset(struct abituguru3_data *data, u8 bank,
-	u8 offset, u8 count, u8 *buf, int offset_count)
+static int abituguru3_read_increment_offset(struct abituguru3_data *data,
+					    u8 bank, u8 offset, u8 count,
+					    u8 *buf, int offset_count)
 {
 	int i, x;
 

