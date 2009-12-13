Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbZLMX5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbZLMX5i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 18:57:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754762AbZLMX52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 18:57:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34605 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753815AbZLMX5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:25 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, cezary.jackiewicz@gmail.com,
       len.brown@intel.com, torvalds@linux-foundation.org
Subject: [PATCH 06/22] Constify struct backlight_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:58:58 +0100
Message-Id: <cb60771f1fdc2d7ab0fad6e4921fac71176b256c.1260662995.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260662994.git.re.emese@gmail.com>
References: <cover.1260662994.git.re.emese@gmail.com>
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 drivers/platform/x86/compal-laptop.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/compal-laptop.c b/drivers/platform/x86/compal-laptop.c
index 11003bb..550ff1b 100644
--- a/drivers/platform/x86/compal-laptop.c
+++ b/drivers/platform/x86/compal-laptop.c
@@ -163,7 +163,7 @@ static int bl_update_status(struct backlight_device *b)
 	return set_lcd_level(b->props.brightness);
 }
 
-static struct backlight_ops compalbl_ops = {
+static const struct backlight_ops compalbl_ops = {
 	.get_brightness = bl_get_brightness,
 	.update_status	= bl_update_status,
 };
-- 
1.6.5.3

