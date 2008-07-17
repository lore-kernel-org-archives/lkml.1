Return-Path: <linux-kernel-owner+w=401wt.eu-S933051AbYGQTcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933051AbYGQTcu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 15:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932446AbYGQTXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 15:23:32 -0400
Received: from winston.telenet-ops.be ([195.130.137.75]:35521 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759801AbYGQTWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 15:22:47 -0400
Message-Id: <20080717191751.920132090@mail.of.borg>
References: <20080717191607.955742542@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Thu, 17 Jul 2008 21:16:16 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: [patch 09/29] ZORRO: Replace deprecated __initcall with equivalent device_initcall.
Content-Disposition: inline; filename=zorro-replace-deprecated-__initcall-with-equivalent-device_initcall.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert P. J. Day <rpjday@crashcourse.ca>

ZORRO: Replace deprecated __initcall with equivalent device_initcall.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/zorro/proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/zorro/proc.c
+++ b/drivers/zorro/proc.c
@@ -158,4 +158,4 @@ static int __init zorro_proc_init(void)
 	return 0;
 }
 
-__initcall(zorro_proc_init);
+device_initcall(zorro_proc_init);

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

