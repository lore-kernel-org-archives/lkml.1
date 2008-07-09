Return-Path: <linux-kernel-owner+w=401wt.eu-S1756151AbYGIWwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151AbYGIWwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 18:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752522AbYGIWwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 18:52:10 -0400
Received: from www.tglx.de ([62.245.132.106]:43214 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345AbYGIWwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 18:52:09 -0400
Date: Thu, 10 Jul 2008 00:52:02 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] Fix a compile warning in arch/x86/mm/init_64.c
Message-ID: <20080709225202.GA3232@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a minor compile warning in arch/x86/mm/init_64.c about passing a
wrong pointer type as argument 2 to find_e820_area_size().
Tested with 2.6.26-rc9.

Signed-of-by: Hans J. Koch <hjk@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>

---
 arch/x86/mm/init_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.26-rc/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.26-rc.orig/arch/x86/mm/init_64.c	2008-07-10 00:18:52.000000000 +0200
+++ linux-2.6.26-rc/arch/x86/mm/init_64.c	2008-07-10 00:25:43.000000000 +0200
@@ -506,7 +506,7 @@
 
 static void __init early_memtest(unsigned long start, unsigned long end)
 {
-	u64 t_start, t_size;
+	unsigned long t_start, t_size;
 	unsigned pattern;
 
 	if (!memtest_pattern)
