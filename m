Return-Path: <linux-kernel-owner+w=401wt.eu-S1760297AbYBCPt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760297AbYBCPt3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 10:49:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753634AbYBCPtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 10:49:21 -0500
Received: from monty.telenet-ops.be ([195.130.132.56]:43580 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbYBCPtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 10:49:19 -0500
Date: Sun, 3 Feb 2008 16:49:09 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Johannes Berg <johannes@sipsolutions.net>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] ADB: Add missing #include <linux/platform_device.h>
Message-ID: <Pine.LNX.4.64.0802031647560.27760@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ADB: Add missing #include <linux/platform_device.h>

Commit c9f6d3d5c6d4f4cd3a53549a69c92951180e2a76

    [POWERPC] adb: Replace sleep notifier with platform driver suspend/resume hooks

introduced compile errors on m68k because <linux/platform_device.h> is not
explicitly included.  On powerpc, it's pulled in through <asm/prom.h>.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/macintosh/adb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/macintosh/adb.c
+++ b/drivers/macintosh/adb.c
@@ -36,6 +36,7 @@
 #include <linux/completion.h>
 #include <linux/device.h>
 #include <linux/kthread.h>
+#include <linux/platform_device.h>
 
 #include <asm/uaccess.h>
 #include <asm/semaphore.h>

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
