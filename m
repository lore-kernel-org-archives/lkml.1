Return-Path: <linux-kernel-owner+w=401wt.eu-S933573AbXCZEJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933573AbXCZEJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 00:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933580AbXCZEI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 00:08:56 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:34525 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933573AbXCZEIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 00:08:51 -0400
Date: Mon, 26 Mar 2007 06:08:55 +0200
From: Adrian Bunk <bunk@stusta.de>
To: mchehab@infradead.org
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/media/video/bt8xx/bttv-cards.c: fix off-by-one
Message-ID: <20070326040855.GA16477@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes an off-by-one error spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.21-rc4-mm1/drivers/media/video/bt8xx/bttv-cards.c.old	2007-03-26 00:00:07.000000000 +0200
+++ linux-2.6.21-rc4-mm1/drivers/media/video/bt8xx/bttv-cards.c	2007-03-26 00:00:55.000000000 +0200
@@ -2983,7 +2983,7 @@
 	bttv_tvcards[btv->c.type].gpiomask = (UNSET != gpiomask) ? gpiomask : gpiobits;
 	printk(KERN_INFO "bttv%d: gpio config override: mask=0x%x, mux=",
 	       btv->c.nr,bttv_tvcards[btv->c.type].gpiomask);
-	for (i = 0; i < 5; i++) {
+	for (i = 0; i < 4; i++) {
 		printk("%s0x%x", i ? "," : "", bttv_tvcards[btv->c.type].gpiomux[i]);
 	}
 	printk("\n");

