Return-Path: <linux-kernel-owner+w=401wt.eu-S1761354AbYDXSfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761354AbYDXSfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 14:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755192AbYDXSeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 14:34:19 -0400
Received: from winston.telenet-ops.be ([195.130.137.75]:50934 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891AbYDXSeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 14:34:14 -0400
Message-Id: <20080424183241.286539069@mail.of.borg>
References: <20080424182940.424312704@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Thu, 24 Apr 2008 20:29:43 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net
Subject: [patch 03/15] m68k: FB_HP300 depends on DIO and doesnt need FB_CFB_FILLRECT
Content-Disposition: inline; filename=m68k-correct-FB_HP300-dependencies.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

Correct FB_HP300 dependencies:
  - FB_HP300 doesn't depend only on HP300, but also on DIO (which depends on
    HP300)
  - FB_HP300 does not need FB_CFB_FILLRECT

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/video/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -596,8 +596,7 @@ config FB_MAC
 
 config FB_HP300
 	bool
-	depends on (FB = y) && HP300
-	select FB_CFB_FILLRECT
+	depends on (FB = y) && DIO
 	select FB_CFB_IMAGEBLIT
 	default y
 

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

