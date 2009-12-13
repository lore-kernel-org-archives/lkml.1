Return-Path: <linux-kernel-owner+w=401wt.eu-S1756325AbZLNA1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325AbZLNA1y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:27:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755443AbZLNA1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:27:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34564 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754739AbZLMX5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:22 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, len.brown@intel.com, adobriyan@gmail.com,
       bjorn.helgaas@hp.com, torvalds@linux-foundation.org
Subject: [PATCH 03/22] Constify struct backlight_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:58:55 +0100
Message-Id: <ef77bc2edc4618ec59eac54cd4497f2b54a100aa.1260662995.git.re.emese@gmail.com>
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
 drivers/platform/x86/asus-laptop.c |    2 +-
 drivers/platform/x86/asus_acpi.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index b39d2bb..c9a3dc4 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -249,7 +249,7 @@ static struct backlight_device *asus_backlight_device;
  */
 static int read_brightness(struct backlight_device *bd);
 static int update_bl_status(struct backlight_device *bd);
-static struct backlight_ops asusbl_ops = {
+static const struct backlight_ops asusbl_ops = {
 	.get_brightness = read_brightness,
 	.update_status = update_bl_status,
 };
diff --git a/drivers/platform/x86/asus_acpi.c b/drivers/platform/x86/asus_acpi.c
index ddf5240..61e6673 100644
--- a/drivers/platform/x86/asus_acpi.c
+++ b/drivers/platform/x86/asus_acpi.c
@@ -1402,7 +1402,7 @@ static int asus_hotk_remove(struct acpi_device *device, int type)
 	return 0;
 }
 
-static struct backlight_ops asus_backlight_data = {
+static const struct backlight_ops asus_backlight_data = {
 	.get_brightness = read_brightness,
 	.update_status  = set_brightness_status,
 };
-- 
1.6.5.3

