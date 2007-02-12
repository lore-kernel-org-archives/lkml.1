Return-Path: <linux-kernel-owner+w=401wt.eu-S964981AbXBLQ5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964981AbXBLQ5u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 11:57:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964987AbXBLQ5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 11:57:23 -0500
Received: from mail.suse.de ([195.135.220.2]:47937 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964981AbXBLQvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 11:51:36 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212551.664370000@suse.de>
In-Reply-To: <20070212551.664370000@suse.de>
To: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review III] [10/29] i386: don't include bugs.h
Message-Id: <20070212165130.450D413FCB@wotan.suse.de>
Date: Mon, 12 Feb 2007 17:51:30 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Andrew Morton <akpm@osdl.org>

That stupid non-inlined-static function in bugs.h causes:

include/asm/bugs.h:186: warning: 'check_bugs' defined but not used

But fortunately the include isn't needed.

Cc: Andi Kleen <ak@muc.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/i386/kernel/alternative.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux/arch/i386/kernel/alternative.c
===================================================================
--- linux.orig/arch/i386/kernel/alternative.c
+++ linux/arch/i386/kernel/alternative.c
@@ -4,7 +4,6 @@
 #include <linux/list.h>
 #include <asm/alternative.h>
 #include <asm/sections.h>
-#include <asm/bugs.h>
 
 static int no_replacement    = 0;
 static int smp_alt_once      = 0;
