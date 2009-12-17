Return-Path: <linux-kernel-owner+w=401wt.eu-S935239AbZLQB1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935239AbZLQB1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:27:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763854AbZLQB11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:27:27 -0500
Received: from kroah.org ([198.145.64.141]:41455 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763698AbZLQBU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:20:57 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:07 2009
Message-Id: <20091217011607.777680705@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:15:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jean Delvare <khali@linux-fr.org>,
       Richard Purdie <rpurdie@linux.intel.com>
Subject: [75/90] backlight: lcd - Fix wrong sizeof
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jean Delvare <khali@linux-fr.org>

commit 1e0fa6bd8c7468067f2e988c7a416dafd0651c34 upstream.

Which is why I have always preferred sizeof(struct foo) over
sizeof(var).

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Richard Purdie <rpurdie@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/video/backlight/lcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/video/backlight/lcd.c
+++ b/drivers/video/backlight/lcd.c
@@ -56,7 +56,7 @@ static int fb_notifier_callback(struct n
 
 static int lcd_register_fb(struct lcd_device *ld)
 {
-	memset(&ld->fb_notif, 0, sizeof(&ld->fb_notif));
+	memset(&ld->fb_notif, 0, sizeof(ld->fb_notif));
 	ld->fb_notif.notifier_call = fb_notifier_callback;
 	return fb_register_client(&ld->fb_notif);
 }


