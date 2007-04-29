Return-Path: <linux-kernel-owner+w=401wt.eu-S1756318AbXD2KyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbXD2KyG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 06:54:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755085AbXD2Kxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 06:53:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:51330 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756332AbXD2Kx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:53:29 -0400
From: Andi Kleen <ak@suse.de>
References: <200704291252.514680000@suse.de>
In-Reply-To: <200704291252.514680000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [38/48] x86_64: Remove unused stext symbol
Message-Id: <20070429105328.412ED151C5@wotan.suse.de>
Date: Sun, 29 Apr 2007 12:53:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


suggested by Jan Beulich

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/head.S |    1 -
 1 file changed, 1 deletion(-)

Index: linux/arch/x86_64/kernel/head.S
===================================================================
--- linux.orig/arch/x86_64/kernel/head.S
+++ linux/arch/x86_64/kernel/head.S
@@ -279,7 +279,6 @@ early_idt_ripmsg:
 	.asciz "RIP %s\n"
 
 .balign PAGE_SIZE
-ENTRY(stext)
 
 #define NEXT_PAGE(name) \
 	.balign	PAGE_SIZE; \
