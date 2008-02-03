Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbYBCVDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbYBCVDT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 16:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbYBCVDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 16:03:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41410 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbYBCVDC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 16:03:02 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 4/4] x86 PM: Update stale comments
Date: Sun, 3 Feb 2008 22:00:11 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
References: <200802032141.56887.rjw@sisk.pl>
In-Reply-To: <200802032141.56887.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802032200.11885.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

In some suspend and hibernation files in arch/x86/power there are
comments referring to arch/x86-64 and arch/i386 .  Update them to
reflect the current code layout.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/x86/power/hibernate_32.c |    4 ++--
 arch/x86/power/hibernate_64.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/power/hibernate_32.c
===================================================================
--- linux-2.6.orig/arch/x86/power/hibernate_32.c
+++ linux-2.6/arch/x86/power/hibernate_32.c
@@ -13,7 +13,7 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 
-/* Defined in arch/i386/power/swsusp.S */
+/* Defined in hibernate_asm_32.S */
 extern int restore_image(void);
 
 /* References to section boundaries */
@@ -23,7 +23,7 @@ extern const void __nosave_begin, __nosa
 pgd_t *resume_pg_dir;
 
 /* The following three functions are based on the analogous code in
- * arch/i386/mm/init.c
+ * arch/x86/mm/init_32.c
  */
 
 /*
Index: linux-2.6/arch/x86/power/hibernate_64.c
===================================================================
--- linux-2.6.orig/arch/x86/power/hibernate_64.c
+++ linux-2.6/arch/x86/power/hibernate_64.c
@@ -18,7 +18,7 @@
 /* References to section boundaries */
 extern const void __nosave_begin, __nosave_end;
 
-/* Defined in arch/x86_64/kernel/suspend_asm.S */
+/* Defined in hibernate_asm_64.S */
 extern int restore_image(void);
 
 /*
