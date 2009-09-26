Return-Path: <linux-kernel-owner+w=401wt.eu-S1751909AbZIZJ4D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbZIZJ4D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 05:56:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbZIZJ4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 05:56:01 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35790 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbZIZJ4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 05:56:00 -0400
Date: Sat, 26 Sep 2009 11:55:55 +0200
From: Pavel Machek <pavel@ucw.cz>
To: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz
Cc: cbou@mail.ru
Subject: something wrong in drivers/power
Message-ID: <20090926095555.GG1331@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Tosa battery driver seems to be confused about its own identity.


Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff -ur power.ofic/tosa_battery.c power/tosa_battery.c
--- linux/drivers/power.ofic/tosa_battery.c	2009-09-06 08:56:36.000000000 +0200
+++ linux/drivers/power/tosa_battery.c	2009-09-15 15:14:08.000000000 +0200
@@ -459,7 +459,7 @@
 }
 
 static struct platform_driver tosa_bat_driver = {
-	.driver.name	= "wm97xx-battery",
+	.driver.name	= "tosa-battery",
 	.driver.owner	= THIS_MODULE,
 	.probe		= tosa_bat_probe,
 	.remove		= __devexit_p(tosa_bat_remove),
@@ -483,4 +483,4 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Dmitry Baryshkov");
 MODULE_DESCRIPTION("Tosa battery driver");
-MODULE_ALIAS("platform:wm97xx-battery");
+MODULE_ALIAS("platform:tosa-battery");


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
