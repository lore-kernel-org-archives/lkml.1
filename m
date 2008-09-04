Return-Path: <linux-kernel-owner+w=401wt.eu-S1759162AbYIDUeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759162AbYIDUeZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 16:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758161AbYIDU1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 16:27:35 -0400
Received: from mail.work.de ([212.12.32.20]:42160 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758096AbYIDU1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 16:27:33 -0400
Message-ID: <48C044B1.3020208@gmail.com>
Date: Fri, 05 Sep 2008 00:27:29 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org,
       akpm@linux-foundation.org
Subject: DVB Update [PATCH 28/31] fix wrong field usage
X-Enigmail-Version: 0.94.0.0
Content-Type: multipart/mixed;
 boundary="------------030004090002040506030703"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030004090002040506030703
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

>From 983684e316e3450f290588e55c299af6134a73d9 Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 14:53:34 +0200
Subject: [PATCH] DVB fix using a wrong field

A wrong field was used, although not a routine that we are
using after the API update.

From: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

 dvb_frontend.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


--------------030004090002040506030703
Content-Type: text/x-patch;
 name="28.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="28.patch"

>From 983684e316e3450f290588e55c299af6134a73d9 Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 14:53:34 +0200
Subject: [PATCH] DVB fix using a wrong field

A wrong field was used, although not a routine that we are
using after the API update.

From: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 70b6ca0..42ed894 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -623,7 +623,7 @@ static int dvbfe_sanity_check(struct dvb_frontend *fe)
 	    (fepriv->fe_params.frequency > fepriv->fe_info.frequency_max))
 		return -EINVAL;
 
-	switch (fepriv->fe_params.delivery) {
+	switch (fepriv->delsys) {
 	case DVBFE_DELSYS_DVBS:
 		if (!(fepriv->fe_params.delsys.dvbs.modulation &
 		      fepriv->fe_info.delsys.dvbs.modulation))


--------------030004090002040506030703--
