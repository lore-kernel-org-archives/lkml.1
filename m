Return-Path: <linux-kernel-owner+w=401wt.eu-S1759078AbXIXPTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759078AbXIXPTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 11:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbXIXPTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 11:19:46 -0400
Received: from mailhub.hp.com ([192.151.27.10]:34088 "EHLO mailhub.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754690AbXIXPTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 11:19:46 -0400
From: "Bob Picco" <bob.picco@hp.com>
Date: Mon, 24 Sep 2007 11:18:51 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, bob.picco@hp.com
Subject: Re: 2.6.23-rc7-mm1 ia64 build issue in efi.c
Message-ID: <20070924151851.GA20296@localhost>
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


There isn't a total_memory identifier within this function's scope. The
patch was compile/link tested.

Signed-off-by: Bob Picco <bob.picco@hp.com>

 arch/ia64/kernel/efi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.23-rc7-mm1/arch/ia64/kernel/efi.c
===================================================================
--- linux-2.6.23-rc7-mm1.orig/arch/ia64/kernel/efi.c	2007-09-24 09:54:40.000000000 -0400
+++ linux-2.6.23-rc7-mm1/arch/ia64/kernel/efi.c	2007-09-24 10:50:51.000000000 -0400
@@ -1085,7 +1085,7 @@ efi_memmap_init(unsigned long *s, unsign
 	*s = (u64)kern_memmap;
 	*e = (u64)++k;
 
-	return total_memory;
+	return total_mem;
 }
 
 void
