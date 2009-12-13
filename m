Return-Path: <linux-kernel-owner+w=401wt.eu-S1756213AbZLNAZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbZLNAZB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:25:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754791AbZLMX53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 18:57:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34606 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754763AbZLMX5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:25 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, len.brown@intel.com, tony@linx.net,
       jwoithe@physics.adelaide.edu.au, torvalds@linux-foundation.org
Subject: [PATCH 10/22] Constify struct backlight_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:59:02 +0100
Message-Id: <d9e382d265c6c101d536284758dc8b6cb608ab6b.1260662995.git.re.emese@gmail.com>
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
 drivers/platform/x86/fujitsu-laptop.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
index bcd4ba8..a249b35 100644
--- a/drivers/platform/x86/fujitsu-laptop.c
+++ b/drivers/platform/x86/fujitsu-laptop.c
@@ -436,7 +436,7 @@ static int bl_update_status(struct backlight_device *b)
 	return ret;
 }
 
-static struct backlight_ops fujitsubl_ops = {
+static const struct backlight_ops fujitsubl_ops = {
 	.get_brightness = bl_get_brightness,
 	.update_status = bl_update_status,
 };
-- 
1.6.5.3

