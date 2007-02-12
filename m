Return-Path: <linux-kernel-owner+w=401wt.eu-S965009AbXBLQwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965009AbXBLQwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 11:52:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964974AbXBLQwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 11:52:16 -0500
Received: from ns2.suse.de ([195.135.220.15]:53634 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964995AbXBLQvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 11:51:41 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212551.664370000@suse.de>
In-Reply-To: <20070212551.664370000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review III] [20/29] i386: Fix warning in microcode.c
Message-Id: <20070212165140.DA4BE13F45@wotan.suse.de>
Date: Mon, 12 Feb 2007 17:51:40 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Fix bogus gcc warning

linux/arch/i386/kernel/microcode.c:387: warning: ‘new_mc’ may be used uninitialized in this function


Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/microcode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/i386/kernel/microcode.c
===================================================================
--- linux.orig/arch/i386/kernel/microcode.c
+++ linux/arch/i386/kernel/microcode.c
@@ -384,7 +384,7 @@ static int do_microcode_update (void)
 {
 	long cursor = 0;
 	int error = 0;
-	void *new_mc;
+	void *new_mc = NULL;
 	int cpu;
 	cpumask_t old;
 
