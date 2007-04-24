Return-Path: <linux-kernel-owner+w=401wt.eu-S1754640AbXDXUnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbXDXUnn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 16:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754641AbXDXUnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 16:43:42 -0400
Received: from smtp.nokia.com ([131.228.20.170]:65100 "EHLO
	mgw-ext11.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642AbXDXUnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 16:43:41 -0400
Message-ID: <462E6A75.9040800@indt.org.br>
Date: Tue, 24 Apr 2007 16:37:09 -0400
From: Carlos Aguiar <carlos.aguiar@indt.org.br>
User-Agent: Thunderbird 1.5.0.9 (X11/20070104)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>, linux-kernel@vger.kernel.org,
       "Anderson F. Briglia" <anderson.briglia@indt.org.br>
Subject: [PATCH 1/3] MMC: OMAP: Add missing =?ISO-8859-1?Q?=B4=5Cn=B4?=
X-Enigmail-Version: 0.94.0.0
Content-Type: multipart/mixed;
 boundary="------------030709090407020301080404"
X-OriginalArrivalTime: 24 Apr 2007 20:43:26.0126 (UTC) FILETIME=[351524E0:01C786B1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030709090407020301080404
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit



--------------030709090407020301080404
Content-Type: text/plain;
 name*0*=ISO-8859-1''%30%30%31%2D%4D%4D%43%2D%4F%4D%41%50%2D%61%64%64%2D%6D;
 name*1*=%69%73%73%69%6E%67%2D%B4%6E%B4%2E%64%69%66%66
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0*=ISO-8859-1''%30%30%31%2D%4D%4D%43%2D%4F%4D%41%50%2D%61%64%64;
 filename*1*=%2D%6D%69%73%73%69%6E%67%2D%B4%6E%B4%2E%64%69%66%66

This patch add a missing '\n' at the end of the 'cover is open' string
in mmc_omap_switch_handler().

Signed-off-by: Arnaud Patard <arnaud.patard@rtp-net.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>

Index: linux-2.6.20/drivers/mmc/omap.c
===================================================================
--- linux-2.6.20.orig/drivers/mmc/omap.c	2007-04-24 15:21:55.000000000 -0400
+++ linux-2.6.20/drivers/mmc/omap.c	2007-04-24 15:21:58.000000000 -0400
@@ -605,7 +605,7 @@ static void mmc_omap_switch_handler(stru
 	}
 	if (mmc_omap_cover_is_open(host)) {
 		if (!complained) {
-			dev_info(mmc_dev(host->mmc), "cover is open");
+			dev_info(mmc_dev(host->mmc), "cover is open\n");
 			complained = 1;
 		}
 		if (mmc_omap_enable_poll)

--------------030709090407020301080404--
