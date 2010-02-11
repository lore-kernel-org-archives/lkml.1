Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865Ab0BKSr5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 13:47:57 -0500
Received: from mail-gx0-f224.google.com ([209.85.217.224]:33736 "EHLO
	mail-gx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756848Ab0BKSrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 13:47:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ohbSvJgtZbhXMhLd0yiolstAsXbxMshDsl5P12pnQeUqeS++uRPUtH9ZfYt56HvVca
         YpUOfhfEqpXeuN6BR89/tDatkAQqquLhYb30L8ldS2WLxVAA6fzZE419pCB0i4gJKpKf
         b4RQFa7ZHjHWwwMT/7lsXJ3WAafhUkiI2Orhs=
From: Chihau Chau <chihau@gmail.com>
To: gregkh@suse.de, pavel@ucw.cz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Chihau Chau <chihau@gmail.com>
Subject: [PATCH] Staging: dream: camera: msm_camera: fix coding style issues
Date: Thu, 11 Feb 2010 15:47:47 -0300
Message-Id: <1265914067-11150-1-git-send-email-chihau@gmail.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chihau Chau <chihau@gmail.com>

This fixes some coding style issues like to use __func__ instead
__FUNCTION__, "foo *bar" instead "foo* bar" and a initial comment with
"/* */" instead "//"

Signed-off-by: Chihau Chau <chihau@gmail.com>
---
 drivers/staging/dream/camera/msm_camera.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/dream/camera/msm_camera.c b/drivers/staging/dream/camera/msm_camera.c
index 7d93877..4f808dc 100644
--- a/drivers/staging/dream/camera/msm_camera.c
+++ b/drivers/staging/dream/camera/msm_camera.c
@@ -2,7 +2,7 @@
  * Copyright (C) 2008-2009 QUALCOMM Incorporated.
  */
 
-//FIXME: most allocations need not be GFP_ATOMIC
+/* FIXME: most allocations need not be GFP_ATOMIC */
 /* FIXME: management of mutexes */
 /* FIXME: msm_pmem_region_lookup return values */
 /* FIXME: way too many copy to/from user */
@@ -361,7 +361,7 @@ static int __msm_get_frame(struct msm_sync *sync,
 	if (!frame->buffer) {
 		pr_err("%s: cannot get frame, invalid lookup address "
 			"y=%x cbcr=%x offset=%d\n",
-			__FUNCTION__,
+			__func__,
 			pphy->y_phy,
 			pphy->cbcr_phy,
 			frame->y_off);
@@ -455,7 +455,7 @@ static int msm_disable_vfe(struct msm_sync *sync, void __user *arg)
 	return rc;
 }
 
-static struct msm_queue_cmd* __msm_control(struct msm_sync *sync,
+static struct msm_queue_cmd *__msm_control(struct msm_sync *sync,
 		struct msm_control_device_queue *queue,
 		struct msm_queue_cmd *qcmd,
 		int timeout)
-- 
1.5.6.3

