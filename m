Return-Path: <linux-kernel-owner+w=401wt.eu-S1755155AbXD2LFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbXD2LFh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 07:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756334AbXD2LA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 07:00:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:51254 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755147AbXD2KxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:53:04 -0400
From: Andi Kleen <ak@suse.de>
References: <200704291252.514680000@suse.de>
In-Reply-To: <200704291252.514680000@suse.de>
To: Adrian Bunk <bunk@stusta.de>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [15/48] x86_64: make simnow_init() static
Message-Id: <20070429105303.985FE151C5@wotan.suse.de>
Date: Sun, 29 Apr 2007 12:53:03 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/x86_64/kernel/early_printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86_64/kernel/early_printk.c
===================================================================
--- linux.orig/arch/x86_64/kernel/early_printk.c
+++ linux/arch/x86_64/kernel/early_printk.c
@@ -175,7 +175,7 @@ static noinline long simnow(long cmd, lo
 	return ret;
 }
 
-void __init simnow_init(char *str)
+static void __init simnow_init(char *str)
 {
 	char *fn = "klog";
 	if (*str == '=')
