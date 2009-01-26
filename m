Return-Path: <linux-kernel-owner+w=401wt.eu-S1751286AbZAZAVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751286AbZAZAVV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 19:21:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbZAZAVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 19:21:00 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:11438 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbZAZAU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 19:20:59 -0500
X-Spam-Flag: NO
X-Spam-Score: -12.589
Message-ID: <497D01E8.4020106@tremplin-utc.net>
Date: Mon, 26 Jan 2009 01:20:56 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.19) Gecko/20081231 Mandriva/2.0.0.19-1mdv2009.1 (2009.1) Thunderbird/2.0.0.19 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       Jerome Poulin <jeromepoulin@gmail.com>
Subject: [PATCH 2/4] lis3lv02d: add axes knowledge for HP 6530 
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the HP laptops of model 6530x for having correctly setup
axes.
Reported-by: Jerome Poulin <jeromepoulin@gmail.com>
Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>
---
 drivers/hwmon/hp_accel.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/hp_accel.c b/drivers/hwmon/hp_accel.c
index 9d133be..f0d3556 100644
--- a/drivers/hwmon/hp_accel.c
+++ b/drivers/hwmon/hp_accel.c
@@ -153,6 +153,7 @@ static struct axis_conversion lis3lv02d_axis_y_inverted = {1, -2, 3};
 static struct axis_conversion lis3lv02d_axis_x_inverted = {-1, 2, 3};
 static struct axis_conversion lis3lv02d_axis_z_inverted = {1, 2, -3};
 static struct axis_conversion lis3lv02d_axis_xy_rotated_left = {-2, 1, 3};
+static struct axis_conversion lis3lv02d_axis_xy_rotated_left_usd = {-2, 1, -3};
 static struct axis_conversion lis3lv02d_axis_xy_swap_inverted = {-2, -1, 3};
 static struct axis_conversion lis3lv02d_axis_xy_rotated_right = {2, -1, 3};
 
@@ -173,6 +174,7 @@ static struct dmi_system_id lis3lv02d_dmi_ids[] = {
 	AXIS_DMI_MATCH("NC2510", "HP Compaq 2510", y_inverted),
 	AXIS_DMI_MATCH("NC8510", "HP Compaq 8510", xy_swap_inverted),
 	AXIS_DMI_MATCH("HP2133", "HP 2133", xy_rotated_left),
+	AXIS_DMI_MATCH("NC653x", "HP Compaq 653", xy_rotated_left_usd),
 	AXIS_DMI_MATCH("NC651xx", "HP Compaq 651", xy_rotated_right),
 	{ NULL, }
 /* Laptop models without axis info (yet):
-- 
1.6.1


