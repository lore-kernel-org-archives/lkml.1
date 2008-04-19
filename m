Return-Path: <linux-kernel-owner+w=401wt.eu-S1759911AbYDSIUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759911AbYDSIUV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 04:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752790AbYDSIUC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 04:20:02 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58239 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445AbYDSIUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 04:20:00 -0400
Date: Sat, 19 Apr 2008 10:19:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Subject: [patch] x86: KGDB build fix
Message-ID: <20080419081949.GA3477@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0030]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


latest -git 64-bit allyesconfig needs the build fix below.

	Ingo

----------->
Subject: x86: KGDB build fix
From: Ingo Molnar <mingo@elte.hu>

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/kgdb.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

Index: linux-x86.q/arch/x86/kernel/kgdb.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/kgdb.c
+++ linux-x86.q/arch/x86/kernel/kgdb.c
@@ -46,11 +46,7 @@
 #include <asm/apicdef.h>
 #include <asm/system.h>
 
-#ifdef CONFIG_X86_32
-# include <mach_ipi.h>
-#else
-# include <asm/mach_apic.h>
-#endif
+#include <mach_ipi.h>
 
 /*
  * Put the error code here just in case the user cares:
