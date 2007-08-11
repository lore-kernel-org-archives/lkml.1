Return-Path: <linux-kernel-owner+w=401wt.eu-S1761673AbXHKOmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761673AbXHKOmV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 10:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755594AbXHKOmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 10:42:08 -0400
Received: from ipn26-148.piekary.net ([83.238.26.148]:52099 "EHLO spock.one.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757386AbXHKOmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 10:42:07 -0400
Date: Sat, 11 Aug 2007 16:41:43 +0200
From: Michal Januszewski <spock@gentoo.org>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] uvesafb: use VISUAL_TRUECOLOR as the default visual
Message-ID: <20070811144143.GF13632@spock.one.pl>
Reply-To: spock@gentoo.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
X-PGP-Key: http://dev.gentoo.org/~spock/spock.gpg
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Set uvesafb's default visual to truecolor.  This prevents fbcon
from being detected as 'mono' when using uvesafb.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
---
diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
index e480670..2f1e5af 100644
--- a/drivers/video/uvesafb.c
+++ b/drivers/video/uvesafb.c
@@ -37,6 +37,7 @@ static struct fb_fix_screeninfo uvesafb_fix __devinitdata = {
 	.id	= "VESA VGA",
 	.type	= FB_TYPE_PACKED_PIXELS,
 	.accel	= FB_ACCEL_NONE,
+	.visual = FB_VISUAL_TRUECOLOR,
 };
 
 static int mtrr		__devinitdata = 3; /* enable mtrr by default */

