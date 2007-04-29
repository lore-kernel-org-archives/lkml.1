Return-Path: <linux-kernel-owner+w=401wt.eu-S1756327AbXD2KyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327AbXD2KyG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 06:54:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756318AbXD2Kxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 06:53:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51333 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756331AbXD2Kxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:53:30 -0400
From: Andi Kleen <ak@suse.de>
References: <200704291252.514680000@suse.de>
In-Reply-To: <200704291252.514680000@suse.de>
To: "Parag Warudkar" <parag.warudkar@gmail.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [39/48] i386: remove the APM_RTC_IS_GMT config option.
Message-Id: <20070429105329.53332151CB@wotan.suse.de>
Date: Sun, 29 Apr 2007 12:53:29 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Parag Warudkar" <parag.warudkar@gmail.com>

Signed-off-by: Parag Warudkar <parag.warudkar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/i386/Kconfig |   13 -------------
 1 file changed, 13 deletions(-)

Index: linux/arch/i386/Kconfig
===================================================================
--- linux.orig/arch/i386/Kconfig
+++ linux/arch/i386/Kconfig
@@ -1029,19 +1029,6 @@ config APM_DISPLAY_BLANK
 	  backlight at all, or it might print a lot of errors to the console,
 	  especially if you are using gpm.
 
-config APM_RTC_IS_GMT
-	bool "RTC stores time in GMT"
-	depends on APM
-	help
-	  Say Y here if your RTC (Real Time Clock a.k.a. hardware clock)
-	  stores the time in GMT (Greenwich Mean Time). Say N if your RTC
-	  stores localtime.
-
-	  It is in fact recommended to store GMT in your RTC, because then you
-	  don't have to worry about daylight savings time changes. The only
-	  reason not to use GMT in your RTC is if you also run a broken OS
-	  that doesn't understand GMT.
-
 config APM_ALLOW_INTS
 	bool "Allow interrupts during APM BIOS calls"
 	depends on APM
