Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935231Ab0BZEk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 23:40:59 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:50856 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935215Ab0BZEk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 23:40:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=kDY7xdyjZaZsnXKUlQTc+oUW0CXNBrmRcVPBdmzshi46vONcB8PXEFw60pd9Hj9js3
         01EZbAWaeGEp7nPmYP0DzyDV2ihrz7quA67Z+gbw0RbpDlwUaAiXOgSzPCbEgIikNv6n
         Nn5yz1rs4/cvVmOR6El8ywjp7W1urHv8ELCaA=
From: Chihau Chau <chihau@gmail.com>
To: gregkh@suse.de
Cc: pavel@ucw.cz, linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       Chihau Chau <chihau@gmail.com>
Subject: [PATCH] Staging: dream: camera: sk5k3e2fx: fix code style issues
Date: Thu, 25 Feb 2010 20:20:09 -0300
Message-Id: <1267140009-18775-1-git-send-email-chihau@gmail.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chihau Chau <chihau@gmail.com>

This fixes some code style issues about assignments in if conditions.

Signed-off-by: Chihau Chau <chihau@gmail.com>
---
 drivers/staging/dream/camera/s5k3e2fx.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/dream/camera/s5k3e2fx.c b/drivers/staging/dream/camera/s5k3e2fx.c
index edba198..2426f5e 100644
--- a/drivers/staging/dream/camera/s5k3e2fx.c
+++ b/drivers/staging/dream/camera/s5k3e2fx.c
@@ -743,12 +743,12 @@ static int s5k3e2fx_sensor_open_init(const struct msm_camera_sensor_info *data)
 	}
 
 	/* initialize AF */
-	if ((rc = s5k3e2fx_i2c_write_b(s5k3e2fx_client->addr,
-			0x3146, 0x3A)) < 0)
+	rc = s5k3e2fx_i2c_write_b(s5k3e2fx_client->addr, 0x3146, 0x3A);
+	if (rc < 0)
 		goto init_fail1;
 
-	if ((rc = s5k3e2fx_i2c_write_b(s5k3e2fx_client->addr,
-			0x3130, 0x03)) < 0)
+	rc = s5k3e2fx_i2c_write_b(s5k3e2fx_client->addr, 0x3130, 0x03);
+	if (rc < 0)
 		goto init_fail1;
 
 	goto init_done;
-- 
1.5.6.3

