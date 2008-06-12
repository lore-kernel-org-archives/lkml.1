Return-Path: <linux-kernel-owner+w=401wt.eu-S1758456AbYFLIh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456AbYFLIh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 04:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755536AbYFLIgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 04:36:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36987 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754966AbYFLIgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 04:36:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] x86: Remove obsolete PM definitions from NMI header
Date: Thu, 12 Jun 2008 10:27:08 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>
References: <200806121025.24668.rjw@sisk.pl>
In-Reply-To: <200806121025.24668.rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806121027.09085.rjw@sisk.pl>
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Remove obsolete and no longer used PM-related definitions from
include/asm-x86/nmi.h .

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 include/asm-x86/nmi.h |   21 ---------------------
 1 file changed, 21 deletions(-)

Index: linux-2.6/include/asm-x86/nmi.h
===================================================================
--- linux-2.6.orig/include/asm-x86/nmi.h
+++ linux-2.6/include/asm-x86/nmi.h
@@ -15,27 +15,6 @@
  */
 int do_nmi_callback(struct pt_regs *regs, int cpu);
 
-#ifdef CONFIG_PM
-
-/** Replace the PM callback routine for NMI. */
-struct pm_dev *set_nmi_pm_callback(pm_callback callback);
-
-/** Unset the PM callback routine back to the default. */
-void unset_nmi_pm_callback(struct pm_dev *dev);
-
-#else
-
-static inline struct pm_dev *set_nmi_pm_callback(pm_callback callback)
-{
-	return 0;
-}
-
-static inline void unset_nmi_pm_callback(struct pm_dev *dev)
-{
-}
-
-#endif /* CONFIG_PM */
-
 #ifdef CONFIG_X86_64
 extern void default_do_nmi(struct pt_regs *);
 extern void die_nmi(char *str, struct pt_regs *regs, int do_panic);
