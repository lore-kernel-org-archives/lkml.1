Return-Path: <linux-kernel-owner+w=401wt.eu-S1751898AbXJUGVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898AbXJUGVh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 02:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750927AbXJUGVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 02:21:30 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:31982 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750912AbXJUGV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 02:21:29 -0400
X-Greylist: delayed 1253 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Oct 2007 02:21:29 EDT
Date: Sun, 21 Oct 2007 08:10:12 +0200
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: linux-kernel@vger.kernel.org
Cc: Ben Dooks <ben-linux-arm@fluff.org>
Subject: [PATCH] s3c-rtc: remove unused variable
Message-Id: <20071021081012.15682463.krzysztof.h1@poczta.fm>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: e8c0b138
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch removes unused variable.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Acked-by: Ben Dooks <ben-linux@fluff.org> 

---
This patch was done against the 2.6.23-git13 kernel.

diff -urp linux-ref/drivers/rtc/rtc-s3c.c linux-new/drivers/rtc/rtc-s3c.c
--- linux-ref/drivers/rtc/rtc-s3c.c	2007-10-09 22:31:38.000000000 +0200
+++ linux-new/drivers/rtc/rtc-s3c.c	2007-10-18 23:01:07.601674574 +0200
@@ -542,8 +542,6 @@ static int s3c_rtc_probe(struct platform
 
 /* RTC Power management control */
 
-static struct timespec s3c_rtc_delta;
-
 static int ticnt_save;
 
 static int s3c_rtc_suspend(struct platform_device *pdev, pm_message_t state)


----------------------------------------------------------------------
Kandydaci na ring! Zagraj 
Kliknij >>> http://link.interia.pl/f1c32

