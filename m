Return-Path: <linux-kernel-owner+w=401wt.eu-S1756119AbZLNAVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbZLNAVH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:21:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754837AbZLMX5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 18:57:38 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33925 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754802AbZLMX5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:30 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, gregkh@suse.de,
       torvalds@linux-foundation.org
Subject: [PATCH 17/22] Constify struct backlight_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:59:09 +0100
Message-Id: <bdb20c5eb93a6bbc738bf8ee41bdf1af9e03ee84.1260662995.git.re.emese@gmail.com>
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
 drivers/staging/samsung-laptop/samsung-laptop.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/samsung-laptop/samsung-laptop.c b/drivers/staging/samsung-laptop/samsung-laptop.c
index 4877138..0cf2d58 100644
--- a/drivers/staging/samsung-laptop/samsung-laptop.c
+++ b/drivers/staging/samsung-laptop/samsung-laptop.c
@@ -268,7 +268,7 @@ static int update_status(struct backlight_device *bd)
 	return 0;
 }
 
-static struct backlight_ops backlight_ops = {
+static const struct backlight_ops backlight_ops = {
 	.get_brightness	= get_brightness,
 	.update_status	= update_status,
 };
-- 
1.6.5.3

