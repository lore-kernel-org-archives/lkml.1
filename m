Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508AbYA1WOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbYA1WOc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:14:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759084AbYA1WKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:10:36 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:52246 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759033AbYA1WKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:10:35 -0500
Date: Tue, 29 Jan 2008 00:11:01 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Jaime Velasco Juan <jsagarribay@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make stk_camera_cleanup() static
Message-ID: <20080128221101.GU8767@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stk_camera_cleanup() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
8e9cfe740957a7a486df202d65cedc1a86d62f96 
diff --git a/drivers/media/video/stk-webcam.c b/drivers/media/video/stk-webcam.c
index d37e5e2..a4bfc06 100644
--- a/drivers/media/video/stk-webcam.c
+++ b/drivers/media/video/stk-webcam.c
@@ -63,7 +63,7 @@ static struct usb_device_id stkwebcam_table[] = {
 };
 MODULE_DEVICE_TABLE(usb, stkwebcam_table);
 
-void stk_camera_cleanup(struct kref *kref)
+static void stk_camera_cleanup(struct kref *kref)
 {
 	struct stk_camera *dev = to_stk_camera(kref);
 

