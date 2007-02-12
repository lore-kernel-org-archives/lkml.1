Return-Path: <linux-kernel-owner+w=401wt.eu-S964974AbXBLQxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964974AbXBLQxe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 11:53:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964999AbXBLQwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 11:52:14 -0500
Received: from mail.suse.de ([195.135.220.2]:47960 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964998AbXBLQvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 11:51:43 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212551.664370000@suse.de>
In-Reply-To: <20070212551.664370000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review III] [21/29] i386: Fix warning in cpu initialization
Message-Id: <20070212165141.E983213E1A@wotan.suse.de>
Date: Mon, 12 Feb 2007 17:51:41 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Fix bogus warning

linux/arch/i386/kernel/cpu/transmeta.c:12: warning: ‘cpu_freq’ may be used uninitialized in this function

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/cpu/transmeta.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/i386/kernel/cpu/transmeta.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/transmeta.c
+++ linux/arch/i386/kernel/cpu/transmeta.c
@@ -9,7 +9,7 @@ static void __cpuinit init_transmeta(str
 {
 	unsigned int cap_mask, uk, max, dummy;
 	unsigned int cms_rev1, cms_rev2;
-	unsigned int cpu_rev, cpu_freq, cpu_flags, new_cpu_rev;
+	unsigned int cpu_rev, cpu_freq = 0, cpu_flags, new_cpu_rev;
 	char cpu_info[65];
 
 	get_model_name(c);	/* Same as AMD/Cyrix */
