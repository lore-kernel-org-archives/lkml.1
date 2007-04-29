Return-Path: <linux-kernel-owner+w=401wt.eu-S932950AbXD2LAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950AbXD2LAa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 07:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755175AbXD2Kxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 06:53:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51299 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755171AbXD2KxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:53:16 -0400
From: Andi Kleen <ak@suse.de>
References: <200704291252.514680000@suse.de>
In-Reply-To: <200704291252.514680000@suse.de>
To: Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [26/48] x86_64: Clarify CONFIG_REORDER explanation
Message-Id: <20070429105315.67BC615108@wotan.suse.de>
Date: Sun, 29 Apr 2007 12:53:15 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Rusty Russell <rusty@rustcorp.com.au>

if (1 && X) => if (X).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/arch/x86_64/Kconfig
===================================================================
--- linux.orig/arch/x86_64/Kconfig
+++ linux/arch/x86_64/Kconfig
@@ -665,8 +665,8 @@ config REORDER
 	default n
 	help
          This option enables the toolchain to reorder functions for a more 
-         optimal TLB usage. If you have pretty much any version of binutils, 
-	 this can increase your kernel build time by roughly one minute.
+         optimal TLB usage.  This will slow your kernel build by
+	 roughly one minute.
 
 config K8_NB
 	def_bool y
