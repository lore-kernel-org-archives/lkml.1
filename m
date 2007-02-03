Return-Path: <linux-kernel-owner+w=401wt.eu-S1750965AbXBCSK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750965AbXBCSK0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 13:10:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750979AbXBCSK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 13:10:26 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:49678 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbXBCSKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 13:10:25 -0500
Date: Sat, 3 Feb 2007 19:10:18 +0100 (MET)
From: Richard Knutsson <ricknu-0@student.ltu.se>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, Richard Knutsson <ricknu-0@student.ltu.se>
Message-Id: <20070203181014.15639.10284.sendpatchset@thinktank.campus.ltu.se>
Subject: [PATCH] include/linux/kernel.h: Remove labs()
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove labs() since it is not used/needed.

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Could not find any references to it (other then defined in gcc's stdlib.h),
compile-tested with "allyes" on i386 just to be sure.
If abs()'s int is not sufficient, it then should be replaced with typeof (imho).


diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 63fb18d..a029430 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -92,11 +92,6 @@ extern int cond_resched(void);
 		(__x < 0) ? -__x : __x;		\
 	})
 
-#define labs(x) ({				\
-		long __x = (x);			\
-		(__x < 0) ? -__x : __x;		\
-	})
-
 extern struct atomic_notifier_head panic_notifier_list;
 extern long (*panic_blink)(long time);
 NORET_TYPE void panic(const char * fmt, ...)
