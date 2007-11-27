Return-Path: <linux-kernel-owner+w=401wt.eu-S1758226AbXK0PwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226AbXK0PwB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 10:52:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753936AbXK0Pvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 10:51:52 -0500
Received: from moutng.kundenserver.de ([212.227.126.179]:65151 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbXK0Pvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 10:51:51 -0500
From: Andre Haupt <andre@bitwigglers.org>
To: linux-kernel@vger.kernel.org
Cc: jsimmons@users.sourceforge.net, kernel-janitors@vger.kernel.org,
       adaplas@gmail.com, Andre Haupt <andre@bitwigglers.org>
Subject: [PATCH 1/2] fbmon: remove unnecessary local variable
Date: Tue, 27 Nov 2007 16:51:39 +0100
Message-Id: <1196178700387-git-send-email-andre@bitwigglers.org>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: y
References: y
Message-Id: <94ed2e6692de667821f02aacc69b8df99de683cf.1196176751.git.andre@bitwigglers.org>
X-Provags-ID: V01U2FsdGVkX1+uEzlNT0Po6MfNln9EVlkiUq05tHwnbkYF6Xk
 I86m5VGrIOe2ytl+iBt0yPDjFzw6RlMVTxaubkBDDYqAXoT156
 XT1VZUhl9qqLquls04idIuDl1KU+dDY7xk/yHCgwyY=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a sparse warning about symbol 'i' shadowing an earlier one.

From: Andre Haupt <andre@bitwigglers.org>
Signed-off-by: Andre Haupt <andre@bitwigglers.org>
---
 drivers/video/fbmon.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/fbmon.c b/drivers/video/fbmon.c
index 4ba9c08..3f3a4e9 100644
--- a/drivers/video/fbmon.c
+++ b/drivers/video/fbmon.c
@@ -686,7 +686,7 @@ static int fb_get_monitor_limits(unsigned char *edid, struct fb_monspecs *specs)
 	/* estimate monitor limits based on modes supported */
 	if (retval) {
 		struct fb_videomode *modes, *mode;
-		int num_modes, i, hz, hscan, pixclock;
+		int num_modes, hz, hscan, pixclock;
 		int vtotal, htotal;
 
 		modes = fb_create_modedb(edid, &num_modes);
-- 
1.4.4.4

