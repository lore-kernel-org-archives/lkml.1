Return-Path: <linux-kernel-owner+w=401wt.eu-S964976AbXBLQ5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964976AbXBLQ5K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 11:57:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964984AbXBLQvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 11:51:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53599 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964981AbXBLQvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 11:51:31 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212551.664370000@suse.de>
In-Reply-To: <20070212551.664370000@suse.de>
To: "Robert P. J. Day" <rpjday@mindspring.com>, Andi Kleen <ak@muc.de>,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review III] [6/29] i386: Remove unused kernel config option X86_XADD
Message-Id: <20070212165126.07E1113FAB@wotan.suse.de>
Date: Mon, 12 Feb 2007 17:51:25 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove the unused kernel config option X86_XADD, which is unused in any
source or header file.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@muc.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/Kconfig.cpu |    5 -----
 1 file changed, 5 deletions(-)

Index: linux/arch/i386/Kconfig.cpu
===================================================================
--- linux.orig/arch/i386/Kconfig.cpu
+++ linux/arch/i386/Kconfig.cpu
@@ -226,11 +226,6 @@ config X86_CMPXCHG
 	depends on !M386
 	default y
 
-config X86_XADD
-	bool
-	depends on !M386
-	default y
-
 config X86_L1_CACHE_SHIFT
 	int
 	default "7" if MPENTIUM4 || X86_GENERIC
