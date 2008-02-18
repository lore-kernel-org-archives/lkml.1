Return-Path: <linux-kernel-owner+w=401wt.eu-S1755349AbYBRVnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbYBRVnB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 16:43:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbYBRVmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 16:42:51 -0500
Received: from elvis.franken.de ([193.175.24.41]:48732 "EHLO elvis.franken.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbYBRVmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 16:42:50 -0500
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
cc: dmitry.torokhov@gmail.com, akpm@linux-foundation.org
Subject: [PATCH] I8042: Use SGI_HAS_I8042 to select SGI i8042 handlinig
Message-Id: <20080218214244.9DD55C2AE3@solo.franken.de>
Date: Mon, 18 Feb 2008 22:42:44 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use SGI_HAS_I8042 to select SGI i8042 handling

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
---

This is the only patch for SGO IP28 support, which didn't make it in the 
merge window. I hope this is patch is small enough to still get it in 
the 2.6.25-rc cycle.

 drivers/input/serio/i8042.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/serio/i8042.h b/drivers/input/serio/i8042.h
index dd22d91..c972e5d 100644
--- a/drivers/input/serio/i8042.h
+++ b/drivers/input/serio/i8042.h
@@ -16,7 +16,7 @@
 
 #if defined(CONFIG_MACH_JAZZ)
 #include "i8042-jazzio.h"
-#elif defined(CONFIG_SGI_IP22)
+#elif defined(CONFIG_SGI_HAS_I8042)
 #include "i8042-ip22io.h"
 #elif defined(CONFIG_PPC)
 #include "i8042-ppcio.h"
