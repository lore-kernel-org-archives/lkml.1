Return-Path: <linux-kernel-owner+w=401wt.eu-S1760607AbZLQAzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760607AbZLQAzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 19:55:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762083AbZLQAyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 19:54:49 -0500
Received: from kroah.org ([198.145.64.141]:44547 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761996AbZLQAyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 19:54:47 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 16:47:09 2009
Message-Id: <20091217004709.245425227@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 16:46:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jean Delvare <khali@linux-fr.org>,
       Richard Purdie <rpurdie@linux.intel.com>
Subject: [16/18] backlight: lcd - Fix wrong sizeof
In-Reply-To: <20091217005306.GA6230@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

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
@@ -41,7 +41,7 @@ static int fb_notifier_callback(struct n
 
 static int lcd_register_fb(struct lcd_device *ld)
 {
-	memset(&ld->fb_notif, 0, sizeof(&ld->fb_notif));
+	memset(&ld->fb_notif, 0, sizeof(ld->fb_notif));
 	ld->fb_notif.notifier_call = fb_notifier_callback;
 	return fb_register_client(&ld->fb_notif);
 }


