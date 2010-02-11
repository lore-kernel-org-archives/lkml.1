Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab0BKQJb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 11:09:31 -0500
Received: from palm.sejo.be ([86.39.155.213]:53928 "EHLO palm.sejo.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755859Ab0BKQJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 11:09:29 -0500
From: Jochen Maes <jochen.maes@sejo.be>
To: gregkh@suse.de
Cc: pavel@ucw.cz, linux-kernel@vger.kernel.org,
       Jochen Maes <jochen.maes@sejo.be>
Subject: [PATCH 4/4] drivers: dream: Code style fix
Date: Thu, 11 Feb 2010 17:10:42 +0100
Message-Id: <1265904642-21535-1-git-send-email-jochen.maes@sejo.be>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed parenthesis from return statements,
split up assignment and if condition

Signed-off-by: Jochen Maes <jochen.maes@sejo.be>
---
 drivers/staging/dream/camera/s5k3e2fx.c |   22 ++++++++++++----------
 1 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/dream/camera/s5k3e2fx.c b/drivers/staging/dream/camera/s5k3e2fx.c
index edba198..689b70f 100644
--- a/drivers/staging/dream/camera/s5k3e2fx.c
+++ b/drivers/staging/dream/camera/s5k3e2fx.c
@@ -743,12 +743,14 @@ static int s5k3e2fx_sensor_open_init(const struct msm_camera_sensor_info *data)
 	}
 
 	/* initialize AF */
-	if ((rc = s5k3e2fx_i2c_write_b(s5k3e2fx_client->addr,
-			0x3146, 0x3A)) < 0)
+	rc = s5k3e2fx_i2c_write_b(s5k3e2fx_client->addr,
+			0x3146, 0x3A)
+	if (rc < 0)
 		goto init_fail1;
 
-	if ((rc = s5k3e2fx_i2c_write_b(s5k3e2fx_client->addr,
-			0x3130, 0x03)) < 0)
+	rc = s5k3e2fx_i2c_write_b(s5k3e2fx_client->addr,
+			0x3130, 0x03)
+	if (rc < 0)
 		goto init_fail1;
 
 	goto init_done;
@@ -814,20 +816,20 @@ static uint16_t s5k3e2fx_get_prev_lines_pf(void)
 
 static uint16_t s5k3e2fx_get_prev_pixels_pl(void)
 {
-	return (s5k3e2fx_reg_pat[S_RES_PREVIEW].size_w +
-		s5k3e2fx_reg_pat[S_RES_PREVIEW].blk_p);
+	return s5k3e2fx_reg_pat[S_RES_PREVIEW].size_w +
+		s5k3e2fx_reg_pat[S_RES_PREVIEW].blk_p;
 }
 
 static uint16_t s5k3e2fx_get_pict_lines_pf(void)
 {
-	return (s5k3e2fx_reg_pat[S_RES_CAPTURE].size_h +
-		s5k3e2fx_reg_pat[S_RES_CAPTURE].blk_l);
+	return s5k3e2fx_reg_pat[S_RES_CAPTURE].size_h +
+		s5k3e2fx_reg_pat[S_RES_CAPTURE].blk_l;
 }
 
 static uint16_t s5k3e2fx_get_pict_pixels_pl(void)
 {
-	return (s5k3e2fx_reg_pat[S_RES_CAPTURE].size_w +
-		s5k3e2fx_reg_pat[S_RES_CAPTURE].blk_p);
+	return s5k3e2fx_reg_pat[S_RES_CAPTURE].size_w +
+		s5k3e2fx_reg_pat[S_RES_CAPTURE].blk_p;
 }
 
 static uint32_t s5k3e2fx_get_pict_max_exp_lc(void)
-- 
1.6.6

