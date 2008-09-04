Return-Path: <linux-kernel-owner+w=401wt.eu-S1757650AbYIDSjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650AbYIDSjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 14:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757196AbYIDShs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 14:37:48 -0400
Received: from mail.work.de ([212.12.32.20]:58906 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756788AbYIDShr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 14:37:47 -0400
Message-ID: <48C02AF6.4010702@gmail.com>
Date: Thu, 04 Sep 2008 22:37:42 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org,
       akpm@linux-foundation.org
Subject: DVB Update [PATCH 8/31] multiproto tree
X-Enigmail-Version: 0.94.0.0
Content-Type: multipart/mixed;
 boundary="------------090300020701080305010809"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090300020701080305010809
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

>From 2766ee0ccad424cf0a8ac55cae8494d50fe0dc09 Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 12:31:18 +0200
Subject: [PATCH] DVB Code simplification: Remove an unnecessary print

* Remove an unnecessary printk for the newer delivery systems added

From: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

 dvb_frontend.c |    5 -----
 1 file changed, 5 deletions(-)

--------------090300020701080305010809
Content-Type: text/x-patch;
 name="8.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="8.patch"

>From 2766ee0ccad424cf0a8ac55cae8494d50fe0dc09 Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 12:31:18 +0200
Subject: [PATCH] DVB Code simplification: Remove an unnecessary print

* Remove an unnecessary printk for the newer delivery systems added

From: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index de49e4b..c830997 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -451,11 +451,6 @@ int newapi_to_olddrv(struct dvbfe_params *params,
 	case DVBFE_DELSYS_ATSC:
 		newmod_to_oldmod(atsc->modulation, &vsb->modulation);
 		break;
-	case DVBFE_DELSYS_DVBS2:
-	case DVBFE_DELSYS_DSS:
-	case DVBFE_DELSYS_DVBH:
-		printk("%s: SORRY ! Backward compatibility unavailable for these delivery systems !!\n", __func__);
-		break;
 	default:
 		dprintk("%s: Unsupported delivery system\n", __func__);
 		return -EINVAL;

--------------090300020701080305010809--
