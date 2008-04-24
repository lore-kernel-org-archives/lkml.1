Return-Path: <linux-kernel-owner+w=401wt.eu-S1759273AbYDXSed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759273AbYDXSed (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 14:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754203AbYDXSeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 14:34:15 -0400
Received: from nelson.telenet-ops.be ([195.130.133.66]:55477 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615AbYDXSeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 14:34:14 -0400
Message-Id: <20080424183241.052803569@mail.of.borg>
References: <20080424182940.424312704@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Thu, 24 Apr 2008 20:29:42 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net
Subject: [patch 02/15] m68k: Kill CONFIG_FB_DAFB
Content-Disposition: inline; filename=m68k-kill-CONFIG_FB_DAFB.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

CONFIG_FB_DAFB is a leftover from pre-Kconfig

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/video/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -594,7 +594,6 @@ config FB_MAC
 	select FB_CFB_IMAGEBLIT
 	select FB_MACMODES
 
-#      bool '  Apple DAFB display support' CONFIG_FB_DAFB
 config FB_HP300
 	bool
 	depends on (FB = y) && HP300

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

