Return-Path: <linux-kernel-owner+w=401wt.eu-S1757919AbZJBNoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919AbZJBNoh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 09:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757899AbZJBNoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 09:44:34 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:18603 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757890AbZJBNo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 09:44:29 -0400
X-Spam-Flag: NO
X-Spam-Score: -14.389
Message-ID: <4AC60383.4030005@tremplin-utc.net>
Date: Fri, 02 Oct 2009 15:43:31 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20090830 Mandriva/2.0.0.23-2mdv2010.0 (2010.0) Thunderbird/2.0.0.23 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Ian E. Morgan" <penguin.wrangler@gmail.com>
Subject: [PATCH 3/3] lis3: add support for the HP HDX 18
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian E. Morgan <penguin.wrangler@gmail.com>

I have an HP HDX 18 laptop, and noted that the configuration of the
accelerometer needs to be x_inverted.

Signed-off-by: Ian E. Morgan <penguin.wrangler@gmail.com>
Signed-off-by: Éric Piel <eric.piel@tremplin-utc.net>
---
 drivers/hwmon/hp_accel.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/hp_accel.c b/drivers/hwmon/hp_accel.c
index 1796b93..be475e8 100644
--- a/drivers/hwmon/hp_accel.c
+++ b/drivers/hwmon/hp_accel.c
@@ -216,6 +216,7 @@ static struct dmi_system_id lis3lv02d_dmi_ids[] = {
 			y_inverted),
 	AXIS_DMI_MATCH("DV7", "HP Pavilion dv7", x_inverted),
 	AXIS_DMI_MATCH("HP8710", "HP Compaq 8710", y_inverted),
+	AXIS_DMI_MATCH("HDX18", "HP HDX 18", x_inverted),
 	{ NULL, }
 /* Laptop models without axis info (yet):
  * "NC6910" "HP Compaq 6910"
-- 
1.6.4.4


