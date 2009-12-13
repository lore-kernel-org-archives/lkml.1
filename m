Return-Path: <linux-kernel-owner+w=401wt.eu-S1756160AbZLNAX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160AbZLNAX0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:23:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754823AbZLMX5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 18:57:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34590 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754722AbZLMX5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:24 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, adaplas@gmail.com,
       rant.likely@secretlab.ca, torvalds@linux-foundation.org
Subject: [PATCH 18/22] Constify struct backlight_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:59:10 +0100
Message-Id: <faa8aebcb35d596e2cdee32bb6a2f25ba5bbfe1d.1260662995.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260662994.git.re.emese@gmail.com>
References: <cover.1260662994.git.re.emese@gmail.com>
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 drivers/video/riva/fbdev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/riva/fbdev.c b/drivers/video/riva/fbdev.c
index d94c57f..912984c 100644
--- a/drivers/video/riva/fbdev.c
+++ b/drivers/video/riva/fbdev.c
@@ -331,7 +331,7 @@ static int riva_bl_get_brightness(struct backlight_device *bd)
 	return bd->props.brightness;
 }
 
-static struct backlight_ops riva_bl_ops = {
+static const struct backlight_ops riva_bl_ops = {
 	.get_brightness = riva_bl_get_brightness,
 	.update_status	= riva_bl_update_status,
 };
-- 
1.6.5.3

