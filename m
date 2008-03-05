Return-Path: <linux-kernel-owner+w=401wt.eu-S1761568AbYCERzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761568AbYCERzu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 12:55:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754007AbYCERzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 12:55:41 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:41812 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234AbYCERzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 12:55:40 -0500
Message-ID: <47CEDE8D.7090707@tiscali.nl>
Date: Wed, 05 Mar 2008 18:55:25 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org
CC: video4linux-list@redhat.com, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] em28xx-core.c: add missing parentheses in em28xx_write_ac97()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mind that the patch below was not yet tested
---
! has a higher priority than &

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/media/video/em28xx/em28xx-core.c b/drivers/media/video/em28xx/em28xx-core.c
index 7d1537c..da8189a 100644
--- a/drivers/media/video/em28xx/em28xx-core.c
+++ b/drivers/media/video/em28xx/em28xx-core.c
@@ -267,7 +267,7 @@ static int em28xx_write_ac97(struct em28xx *dev, u8 reg, u8 *val)
 	for (i = 0; i < 10; i++) {
 		if ((ret = em28xx_read_reg(dev, AC97BUSY_REG)) < 0)
 			return ret;
-		if (!((u8) ret) & 0x01)
+		if (!(((u8) ret) & 0x01))
 			return 0;
 		msleep(5);
 	}
