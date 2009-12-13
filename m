Return-Path: <linux-kernel-owner+w=401wt.eu-S1754851AbZLNAYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbZLNAYM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:24:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754803AbZLMX5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 18:57:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34618 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754768AbZLMX50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:26 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, gregkh@suse.de,
       torvalds@linux-foundation.org
Subject: [PATCH 21/22] Constify struct backlight_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:59:13 +0100
Message-Id: <8a5ff343bee02da0bf38bacca22cde6bfaeeeca6.1260662995.git.re.emese@gmail.com>
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
 drivers/usb/misc/appledisplay.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/misc/appledisplay.c b/drivers/usb/misc/appledisplay.c
index 1d8e39a..7aef786 100644
--- a/drivers/usb/misc/appledisplay.c
+++ b/drivers/usb/misc/appledisplay.c
@@ -178,7 +178,7 @@ static int appledisplay_bl_get_brightness(struct backlight_device *bd)
 		return pdata->msgdata[1];
 }
 
-static struct backlight_ops appledisplay_bl_data = {
+static const struct backlight_ops appledisplay_bl_data = {
 	.get_brightness	= appledisplay_bl_get_brightness,
 	.update_status	= appledisplay_bl_update_status,
 };
-- 
1.6.5.3

