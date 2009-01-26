Return-Path: <linux-kernel-owner+w=401wt.eu-S1752924AbZAZAVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924AbZAZAVi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 19:21:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbZAZAVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 19:21:10 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:11353 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbZAZAVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 19:21:09 -0500
X-Spam-Flag: NO
X-Spam-Score: -12.589
Message-ID: <497D01F0.3060908@tremplin-utc.net>
Date: Mon, 26 Jan 2009 01:21:04 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.19) Gecko/20081231 Mandriva/2.0.0.19-1mdv2009.1 (2009.1) Thunderbird/2.0.0.19 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       Pavel Herrmann <morpheus.ibis@gmail.com>
Subject: [PATCH 3/4] lis3lv02d: add axes knowledge for HP 6730
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Herrmann <morpheus.ibis@gmail.com>

Add support for the HP laptops of model 6730x for having correctly setup
axes.
Signed-off-by: Pavel Herrmann <morpheus.ibis@gmail.com>
Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>
---
 drivers/hwmon/hp_accel.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/hp_accel.c b/drivers/hwmon/hp_accel.c
index f0d3556..0eb53d2 100644
--- a/drivers/hwmon/hp_accel.c
+++ b/drivers/hwmon/hp_accel.c
@@ -175,6 +175,7 @@ static struct dmi_system_id lis3lv02d_dmi_ids[] = {
 	AXIS_DMI_MATCH("NC8510", "HP Compaq 8510", xy_swap_inverted),
 	AXIS_DMI_MATCH("HP2133", "HP 2133", xy_rotated_left),
 	AXIS_DMI_MATCH("NC653x", "HP Compaq 653", xy_rotated_left_usd),
+	AXIS_DMI_MATCH("NC673x", "HP Compaq 673", xy_rotated_left_usd),
 	AXIS_DMI_MATCH("NC651xx", "HP Compaq 651", xy_rotated_right),
 	{ NULL, }
 /* Laptop models without axis info (yet):
-- 
1.6.1


