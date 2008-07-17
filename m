Return-Path: <linux-kernel-owner+w=401wt.eu-S932117AbYGQTZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117AbYGQTZE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 15:25:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932341AbYGQTWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 15:22:52 -0400
Received: from harold.telenet-ops.be ([195.130.133.65]:50740 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759239AbYGQTWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 15:22:44 -0400
Message-Id: <20080717191751.364027005@mail.of.borg>
References: <20080717191607.955742542@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Thu, 17 Jul 2008 21:16:14 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@kernel.org>
Subject: [patch 07/29] m68k: make multi_defconfig the default defconfig
Content-Disposition: inline; filename=m68k-make-multi_defconfig-the-default-defconfig.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>

It seems to match the intention behind multi_defconfig to make it the 
default defconfig.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/m68k/Makefile
+++ b/arch/m68k/Makefile
@@ -13,7 +13,7 @@
 # Copyright (C) 1994 by Hamish Macdonald
 #
 
-KBUILD_DEFCONFIG := amiga_defconfig
+KBUILD_DEFCONFIG := multi_defconfig
 
 # override top level makefile
 AS += -m68020

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

