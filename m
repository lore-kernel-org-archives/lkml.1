Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751619Ab0BNOUT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 09:20:19 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49858 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751169Ab0BNOUP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 09:20:15 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-fbdev@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1266157055.10567.13.camel@localhost>
References: <1266157055.10567.13.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 14 Feb 2010 14:20:13 +0000
Message-ID: <1266157213.10567.16.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH 4/5] video: Fix first line of kernel-doc for a few functions
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function name must be followed by a space, hypen, space, and a
short description.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/video/modedb.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/video/modedb.c b/drivers/video/modedb.c
index 0129f1b..b895aae 100644
--- a/drivers/video/modedb.c
+++ b/drivers/video/modedb.c
@@ -893,7 +893,7 @@ const struct fb_videomode *fb_match_mode(const struct fb_var_screeninfo *var,
 }
 
 /**
- * fb_add_videomode: adds videomode entry to modelist
+ * fb_add_videomode - adds videomode entry to modelist
  * @mode: videomode to add
  * @head: struct list_head of modelist
  *
@@ -928,7 +928,7 @@ int fb_add_videomode(const struct fb_videomode *mode, struct list_head *head)
 }
 
 /**
- * fb_delete_videomode: removed videomode entry from modelist
+ * fb_delete_videomode - removed videomode entry from modelist
  * @mode: videomode to remove
  * @head: struct list_head of modelist
  *
@@ -953,7 +953,7 @@ void fb_delete_videomode(const struct fb_videomode *mode,
 }
 
 /**
- * fb_destroy_modelist: destroy modelist
+ * fb_destroy_modelist - destroy modelist
  * @head: struct list_head of modelist
  */
 void fb_destroy_modelist(struct list_head *head)
@@ -968,7 +968,7 @@ void fb_destroy_modelist(struct list_head *head)
 EXPORT_SYMBOL_GPL(fb_destroy_modelist);
 
 /**
- * fb_videomode_to_modelist: convert mode array to mode list
+ * fb_videomode_to_modelist - convert mode array to mode list
  * @modedb: array of struct fb_videomode
  * @num: number of entries in array
  * @head: struct list_head of modelist
-- 
1.6.6.2



