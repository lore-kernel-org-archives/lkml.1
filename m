Return-Path: <linux-kernel-owner+w=401wt.eu-S1753172AbYDWHS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172AbYDWHS3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 03:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750927AbYDWHST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 03:18:19 -0400
Received: from monty.telenet-ops.be ([195.130.132.56]:52810 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbYDWHSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 03:18:18 -0400
Date: Wed, 23 Apr 2008 09:18:13 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Matthew Wilcox <matthew@wil.cx>
cc: Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: Pull request for semaphore include changes
In-Reply-To: <20080419184029.GO20637@parisc-linux.org>
Message-ID: <Pine.LNX.4.64.0804230917330.9710@anakin>
References: <20080419184029.GO20637@parisc-linux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Apr 2008, Matthew Wilcox wrote:
> Thanks for pulling the generic semaphores.  This follow-on series
> removes all in-tree references to asm/semaphore.h.  Many of the existing
> references are in files which do not use semaphores, so they are simply
> deleted.  The remainder are converted to use linux/semaphore.h.

Subject: [PATCH] drivers/input/serio/hp_sdc.c needs <linux/semaphore.h>

From: Geert Uytterhoeven <geert@linux-m68k.org>

drivers/input/serio/hp_sdc.c: In function 'hp_sdc_take':
drivers/input/serio/hp_sdc.c:198: error: implicit declaration of function 'up'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/input/serio/hp_sdc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/serio/hp_sdc.c
+++ b/drivers/input/serio/hp_sdc.c
@@ -69,6 +69,7 @@
 #include <linux/time.h>
 #include <linux/slab.h>
 #include <linux/hil.h>
+#include <linux/semaphore.h>
 #include <asm/io.h>
 #include <asm/system.h>
 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
