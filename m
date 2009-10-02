Return-Path: <linux-kernel-owner+w=401wt.eu-S1757908AbZJBNog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908AbZJBNog (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 09:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757900AbZJBNof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 09:44:35 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:18794 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757888AbZJBNo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 09:44:29 -0400
X-Spam-Flag: NO
X-Spam-Score: -14.389
Message-ID: <4AC60327.2080502@tremplin-utc.net>
Date: Fri, 02 Oct 2009 15:41:59 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20090830 Mandriva/2.0.0.23-2mdv2010.0 (2010.0) Thunderbird/2.0.0.23 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       =?UTF-8?B?SsO2cmdlbiBKb25zc3Nvbg==?= <jorgen.jonsson@saitek.se>
Subject: [PATCH 2/3] lis3: add support for the HP EliteBook 8530w
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct orientation for  HP EliteBook 8530w.

Reported-by: Jörgen Jonssson <jorgen.jonsson@saitek.se>
Signed-off-by: Éric Piel <eric.piel@tremplin-utc.net>
---
 drivers/hwmon/hp_accel.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/hp_accel.c b/drivers/hwmon/hp_accel.c
index 2d3f95c..1796b93 100644
--- a/drivers/hwmon/hp_accel.c
+++ b/drivers/hwmon/hp_accel.c
@@ -203,6 +203,7 @@ static struct dmi_system_id lis3lv02d_dmi_ids[] = {
 	AXIS_DMI_MATCH("NC6710x", "HP Compaq 6710", xy_swap_yz_inverted),
 	AXIS_DMI_MATCH("NC6715x", "HP Compaq 6715", y_inverted),
 	AXIS_DMI_MATCH("NC693xx", "HP EliteBook 693", xy_rotated_right),
+	AXIS_DMI_MATCH("NC693xx", "HP EliteBook 853", xy_swap),
 	/* Intel-based HP Pavilion dv5 */
 	AXIS_DMI_MATCH2("HPDV5_I",
 			PRODUCT_NAME, "HP Pavilion dv5",
-- 
1.6.4.4


