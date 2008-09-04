Return-Path: <linux-kernel-owner+w=401wt.eu-S1756901AbYIDSmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901AbYIDSmn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 14:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756665AbYIDSjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 14:39:25 -0400
Received: from mail.work.de ([212.12.32.20]:58964 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757682AbYIDSjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 14:39:24 -0400
Message-ID: <48C02B57.20002@gmail.com>
Date: Thu, 04 Sep 2008 22:39:19 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org,
       akpm@linux-foundation.org
CC: Arvo Jarve <arvo@softshark.ee>
Subject: DVB Update [PATCH 17/31] multiproto tree
X-Enigmail-Version: 0.94.0.0
Content-Type: multipart/mixed;
 boundary="------------040400010509000103030500"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040400010509000103030500
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

>From 0d44d9b7b6a6819b9599fa593ae888ed1a8d13da Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 14:04:07 +0200
Subject: [PATCH] DVB typo "&" and "&&" got swapped

From: Arvo Jarve <arvo@softshark.ee>
Signed-off-by: Arvo Jarve <arvo@softshark.ee>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

 dvb_frontend.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)


--------------040400010509000103030500
Content-Type: text/x-patch;
 name="17.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="17.patch"

>From 0d44d9b7b6a6819b9599fa593ae888ed1a8d13da Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 14:04:07 +0200
Subject: [PATCH] DVB typo "&" and "&&" got swapped

From: Arvo Jarve <arvo@softshark.ee>
Signed-off-by: Arvo Jarve <arvo@softshark.ee>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 784acbd..d8261b6 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1737,10 +1737,10 @@ static int dvb_frontend_ioctl(struct inode *inode, struct file *file,
 		memset(&fetunesettings, 0, sizeof (struct dvb_frontend_tune_settings));
 		memcpy(&fetunesettings.fe_params, parg, sizeof (struct dvbfe_params));
 
-		if ((delsys && DVBFE_DELSYS_DVBS) ||
-		    (delsys && DVBFE_DELSYS_DVBC) ||
-		    (delsys && DVBFE_DELSYS_DVBT) ||
-		    (delsys && DVBFE_DELSYS_ATSC)) {
+		if ((delsys & DVBFE_DELSYS_DVBS) ||
+		    (delsys & DVBFE_DELSYS_DVBC) ||
+		    (delsys & DVBFE_DELSYS_DVBT) ||
+		    (delsys & DVBFE_DELSYS_ATSC)) {
 
 			if (newapi_to_olddrv(&fepriv->fe_params, &fepriv->parameters, fepriv->fe_info.delivery)  == -EINVAL)
 				printk("%s: ERROR !!! Converting New parameters --> Old parameters\n", __func__);

--------------040400010509000103030500--
