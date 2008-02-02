Return-Path: <linux-kernel-owner+w=401wt.eu-S933599AbYBBT44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933599AbYBBT44 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 14:56:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757949AbYBBT4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 14:56:49 -0500
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:40720 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbYBBT4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 14:56:48 -0500
Message-ID: <47A4CAFA.606@tiscali.nl>
Date: Sat, 02 Feb 2008 20:56:42 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: adaplas@gmail.com, linux-fbdev-devel@lists.sourceforge.net
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] [drivers/video/i810/i810_main.c] add parentheses
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'!' has a higher priority than '&': bitanding has no effect.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/video/i810/i810_main.c b/drivers/video/i810/i810_main.c
index 1a7d778..1d13dd0 100644
--- a/drivers/video/i810/i810_main.c
+++ b/drivers/video/i810/i810_main.c
@@ -1476,7 +1476,7 @@ static int i810fb_cursor(struct fb_info *info, struct fb_cursor *cursor)
 	struct i810fb_par *par = info->par;
 	u8 __iomem *mmio = par->mmio_start_virtual;
 
-	if (!par->dev_flags & LOCKUP)
+	if (!(par->dev_flags & LOCKUP))
 		return -ENXIO;
 
 	if (cursor->image.width > 64 || cursor->image.height > 64)

