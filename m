Return-Path: <linux-kernel-owner+w=401wt.eu-S1758128AbYIDU12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128AbYIDU12 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 16:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757282AbYIDUZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 16:25:13 -0400
Received: from mail.work.de ([212.12.32.20]:34119 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757130AbYIDUZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 16:25:11 -0400
Message-ID: <48C04423.90407@gmail.com>
Date: Fri, 05 Sep 2008 00:25:07 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org,
       akpm@linux-foundation.org
Subject: DVB Update [PATCH 12/31] temporarily disable lok_loss debugging
X-Enigmail-Version: 0.94.0.0
Content-Type: multipart/mixed;
 boundary="------------090301020307080001060201"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090301020307080001060201
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

>From 705b34307663720ff09ec529d2756c392408097c Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 13:42:51 +0200
Subject: [PATCH] DVB Temporarily disable LOCK LOSS debugging

From: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Manu Abraham ,manu@linuxtv.org>


 dvb_frontend.c |    2 ++
 1 file changed, 2 insertions(+)



--------------090301020307080001060201
Content-Type: text/x-patch;
 name="12.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="12.patch"

>From 705b34307663720ff09ec529d2756c392408097c Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 13:42:51 +0200
Subject: [PATCH] DVB Temporarily disable LOCK LOSS debugging

From: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Manu Abraham ,manu@linuxtv.org>

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 60fd371..125facb 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1226,10 +1226,12 @@ restart:
 					fepriv->status = s;
 					if (fe->ops.track) {
 						dprintk("%s: TRACK callback exists at 0x%p\n", __func__, fe->ops.track);
+#if 0
 						if (fe->ops.tuner_ops.get_status)
 							fe->ops.tuner_ops.get_status(fe, &status);
 						if (!status)
 							printk("%s: Tuner LOCK LOST!\n", __func__);
+#endif
 						fe->ops.track(fe, fe_params, &fepriv->delay);
 					}
 				}


--------------090301020307080001060201--
