Return-Path: <linux-kernel-owner+w=401wt.eu-S1756100AbZLNAVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100AbZLNAVA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:21:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756012AbZLNAUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:20:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34073 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754851AbZLMX5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:40 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, lenb@kernel.org, mjg@redhat.com,
       torvalds@linux-foundation.org
Subject: [PATCH 02/22] Constify struct backlight_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:58:54 +0100
Message-Id: <7fd2a4cef62039670e32710944f49e07afaa7e20.1260662995.git.re.emese@gmail.com>
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
 drivers/acpi/video.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 05dff63..b662ab7 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -359,7 +359,7 @@ static int acpi_video_set_brightness(struct backlight_device *bd)
 				vd->brightness->levels[request_level]);
 }
 
-static struct backlight_ops acpi_backlight_ops = {
+static const struct backlight_ops acpi_backlight_ops = {
 	.get_brightness = acpi_video_get_brightness,
 	.update_status  = acpi_video_set_brightness,
 };
-- 
1.6.5.3

