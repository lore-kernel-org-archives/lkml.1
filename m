Return-Path: <linux-kernel-owner+w=401wt.eu-S1759251AbZBBVre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759251AbZBBVre (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 16:47:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757470AbZBBVrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 16:47:23 -0500
Received: from edna.telenet-ops.be ([195.130.132.58]:48521 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756727AbZBBVrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 16:47:22 -0500
Date: Mon, 2 Feb 2009 22:47:20 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Ungerer <gerg@snapgear.com>
cc: uClinux development list <uclinux-dev@uclinux.org>,
       Greg Ungerer <gerg@uclinux.org>, Sam Ravnborg <sam@ravnborg.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [uClinux-dev] [PATCH] m68k: Unify arch/m68k/include/asm/unistd.h
In-Reply-To: <498599A6.7080202@snapgear.com>
Message-ID: <Pine.LNX.4.64.0902022246320.15898@anakin>
References: <Pine.LNX.4.64.0902011114410.30504@anakin> <498599A6.7080202@snapgear.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Feb 2009, Greg Ungerer wrote:
>       m68k: use non-mmu version of unaligned.h for all m68k

And another one. The rest looks OK.

>From f94c9409356de883fd343cc7c0f25dd955bcad42 Mon Sep 17 00:00:00 2001
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 2 Feb 2009 22:12:36 +0100
Subject: [PATCH] m68k: Restore correct include guards for <asm/unaligned.h>

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/include/asm/unaligned.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/m68k/include/asm/unaligned.h b/arch/m68k/include/asm/unaligned.h
index eb1ea4c..019caa7 100644
--- a/arch/m68k/include/asm/unaligned.h
+++ b/arch/m68k/include/asm/unaligned.h
@@ -1,5 +1,5 @@
-#ifndef _ASM_M68KNOMMU_UNALIGNED_H
-#define _ASM_M68KNOMMU_UNALIGNED_H
+#ifndef _ASM_M68K_UNALIGNED_H
+#define _ASM_M68K_UNALIGNED_H
 
 
 #ifdef CONFIG_COLDFIRE
@@ -22,4 +22,4 @@
 
 #endif
 
-#endif /* _ASM_M68KNOMMU_UNALIGNED_H */
+#endif /* _ASM_M68K_UNALIGNED_H */
-- 
1.5.6.5


Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
