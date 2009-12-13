Return-Path: <linux-kernel-owner+w=401wt.eu-S1756167AbZLNAXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbZLNAXl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:23:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754808AbZLMX5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 18:57:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34622 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754771AbZLMX51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:27 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, len.brown@intel.com, adobriyan@gmail.com,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: [PATCH 20/22] Constify struct backlight_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:59:12 +0100
Message-Id: <d94c5c3f88b03eb7c7c36c8b4f908e3795ba8ae4.1260662995.git.re.emese@gmail.com>
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
 drivers/platform/x86/toshiba_acpi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 51c0a8b..0786629 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -671,7 +671,7 @@ static acpi_status remove_device(void)
 	return AE_OK;
 }
 
-static struct backlight_ops toshiba_backlight_data = {
+static const struct backlight_ops toshiba_backlight_data = {
         .get_brightness = get_lcd,
         .update_status  = set_lcd_status,
 };
-- 
1.6.5.3

