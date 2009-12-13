Return-Path: <linux-kernel-owner+w=401wt.eu-S1756063AbZLNATO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063AbZLNATO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:19:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754875AbZLMX5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 18:57:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34101 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754870AbZLMX5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:42 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, airlied@redhat.com, eric@anholt.net,
       alexdeucher@gmail.com, torvalds@linux-foundation.org,
       jbarnes@virtuousgeek.org
Subject: [PATCH 08/22] Constify struct backlight_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:59:00 +0100
Message-Id: <ef8a50ba97ea0d1b33e5bc4983334f96a454604e.1260662995.git.re.emese@gmail.com>
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
 drivers/gpu/drm/nouveau/nouveau_backlight.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_backlight.c b/drivers/gpu/drm/nouveau/nouveau_backlight.c
index 20564f8..9a8c990 100644
--- a/drivers/gpu/drm/nouveau/nouveau_backlight.c
+++ b/drivers/gpu/drm/nouveau/nouveau_backlight.c
@@ -58,7 +58,7 @@ static int nv40_set_intensity(struct backlight_device *bd)
 	return 0;
 }
 
-static struct backlight_ops nv40_bl_ops = {
+static const struct backlight_ops nv40_bl_ops = {
 	.options = BL_CORE_SUSPENDRESUME,
 	.get_brightness = nv40_get_intensity,
 	.update_status = nv40_set_intensity,
@@ -81,7 +81,7 @@ static int nv50_set_intensity(struct backlight_device *bd)
 	return 0;
 }
 
-static struct backlight_ops nv50_bl_ops = {
+static const struct backlight_ops nv50_bl_ops = {
 	.options = BL_CORE_SUSPENDRESUME,
 	.get_brightness = nv50_get_intensity,
 	.update_status = nv50_set_intensity,
-- 
1.6.5.3

