Return-Path: <linux-kernel-owner+w=401wt.eu-S1759167AbYERTA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759167AbYERTA5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 15:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760399AbYERSyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:54:05 -0400
Received: from winston.telenet-ops.be ([195.130.137.75]:52073 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761361AbYERSx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:53:59 -0400
Message-Id: <20080518185150.538311549@mail.of.borg>
References: <20080518184706.631023070@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sun, 18 May 2008 20:47:09 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net
Subject: [patch 03/18] m68k: FB_HP300 depends on DIO and doesnt need FB_CFB_FILLRECT
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
@@ -629,8 +629,7 @@ config FB_MAC
 
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

