Return-Path: <linux-kernel-owner+w=401wt.eu-S1752924Ab0AGUbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab0AGUbQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 15:31:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879Ab0AGUbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 15:31:13 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34790 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870Ab0AGUbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 15:31:12 -0500
Date: Thu, 7 Jan 2010 21:31:04 +0100
From: Pavel Machek <pavel@ucw.cz>
To: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz, zaurus-devel@www.linuxtogo.org,
       Andrew Morton <akpm@osdl.org>
Subject: [patch] fix strange characters in zaurus gpio .desc
Message-ID: <20100107203104.GA22681@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyril Hrubis <metan@ucw.cz>
    
Somehow, strange characters made their way zaurus gpio .desc
fields. Fix it.
    
Signed-off-by: Pavel Machek <pavel@ucw.cz>

--- a/arch/arm/mach-pxa/spitz.c
+++ b/arch/arm/mach-pxa/spitz.c
@@ -389,13 +389,13 @@ static struct gpio_keys_button spitz_gpio_keys[] = {
 		.type	= EV_SW,
 		.code	= 0,
 		.gpio	= SPITZ_GPIO_SWA,
-		.desc	= "ďťżDisplay Down",
+		.desc	= "Display Down",
 	},
 	{
 		.type	= EV_SW,
 		.code	= 1,
 		.gpio	= SPITZ_GPIO_SWB,
-		.desc	= "ďťżLid Closed",
+		.desc	= "Lid Closed",
 	},
 };
 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
