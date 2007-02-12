Return-Path: <linux-kernel-owner+w=401wt.eu-S964980AbXBLQvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964980AbXBLQvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 11:51:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964984AbXBLQvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 11:51:32 -0500
Received: from mx2.suse.de ([195.135.220.15]:53597 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964980AbXBLQvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 11:51:31 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212551.664370000@suse.de>
In-Reply-To: <20070212551.664370000@suse.de>
To: Adrian Bunk <bunk@stusta.de>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review III] [5/29] i386: arch/i386/kernel/alternative.c should #include <asm/bugs.h>
Message-Id: <20070212165124.EC63213FA2@wotan.suse.de>
Date: Mon, 12 Feb 2007 17:51:24 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Adrian Bunk <bunk@stusta.de>

Every file should include the headers containing the prototypes for its
global functions.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/i386/kernel/alternative.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/arch/i386/kernel/alternative.c
===================================================================
--- linux.orig/arch/i386/kernel/alternative.c
+++ linux/arch/i386/kernel/alternative.c
@@ -4,6 +4,7 @@
 #include <linux/list.h>
 #include <asm/alternative.h>
 #include <asm/sections.h>
+#include <asm/bugs.h>
 
 static int no_replacement    = 0;
 static int smp_alt_once      = 0;
