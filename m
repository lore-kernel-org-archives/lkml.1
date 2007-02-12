Return-Path: <linux-kernel-owner+w=401wt.eu-S933074AbXBLHrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933074AbXBLHrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 02:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933079AbXBLHq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 02:46:57 -0500
Received: from cantor.suse.de ([195.135.220.2]:38372 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933074AbXBLHhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 02:37:54 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212837.963446000@suse.de>
In-Reply-To: <20070212837.963446000@suse.de>
To: Adrian Bunk <bunk@stusta.de>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review II] [3/39] i386: arch/i386/kernel/cpu/mcheck/mce.c should #include <asm/mce.h>
Message-Id: <20070212073749.2F4DF13D01@wotan.suse.de>
Date: Mon, 12 Feb 2007 08:37:49 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Adrian Bunk <bunk@stusta.de>

Every file should include the headers containing the prototypes for
it's global functions.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/i386/kernel/cpu/mcheck/mce.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/arch/i386/kernel/cpu/mcheck/mce.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/mcheck/mce.c
+++ linux/arch/i386/kernel/cpu/mcheck/mce.c
@@ -12,6 +12,7 @@
 
 #include <asm/processor.h> 
 #include <asm/system.h>
+#include <asm/mce.h>
 
 #include "mce.h"
 
