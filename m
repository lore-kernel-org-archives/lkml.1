Return-Path: <linux-kernel-owner+w=401wt.eu-S932693AbYGQT3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693AbYGQT3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 15:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759608AbYGQTXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 15:23:12 -0400
Received: from winston.telenet-ops.be ([195.130.137.75]:35556 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151AbYGQTWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 15:22:51 -0400
Message-Id: <20080717191755.382083574@mail.of.borg>
References: <20080717191607.955742542@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Thu, 17 Jul 2008 21:16:28 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@kernel.org>
Subject: [patch 21/29] m68k: remove stale ARCH_SUN4 #define
Content-Disposition: inline; filename=m68k-remove-stale-ARCH_SUN4-define.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@stusta.de>

m68k: remove stale ARCH_SUN4 #define

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 include/asm-m68k/sbus.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/asm-m68k/sbus.h
+++ b/include/asm-m68k/sbus.h
@@ -12,8 +12,6 @@ struct sbus_dev {
 	} reg_addrs[1];
 };
 
-#define ARCH_SUN4  0
-
 /* sbus IO functions stolen from include/asm-sparc/io.h for the serial driver */
 /* No SBUS on the Sun3, kludge -- sam */
 

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

