Return-Path: <linux-kernel-owner+w=401wt.eu-S1756176AbZLNA1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbZLNA1R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:27:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755457AbZLNA0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:26:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33844 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754744AbZLMX5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:23 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, len.brown@intel.com,
       alan-jenkins@tuffmail.co.uk, torvalds@linux-foundation.org
Subject: [PATCH 01/22] Constify struct backlight_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:58:53 +0100
Message-Id: <36524af5614ab1114b75499c5b99755ccac1f188.1260662995.git.re.emese@gmail.com>
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
 drivers/platform/x86/acer-wmi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index 454970d..98f0e9a 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -918,7 +918,7 @@ static int update_bl_status(struct backlight_device *bd)
 	return 0;
 }
 
-static struct backlight_ops acer_bl_ops = {
+static const struct backlight_ops acer_bl_ops = {
 	.get_brightness = read_brightness,
 	.update_status = update_bl_status,
 };
-- 
1.6.5.3

