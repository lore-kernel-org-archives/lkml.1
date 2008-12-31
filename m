Return-Path: <linux-kernel-owner+w=401wt.eu-S1756172AbYLaLOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172AbYLaLOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 06:14:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755389AbYLaLOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 06:14:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:41563 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963AbYLaLOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 06:14:39 -0500
Subject: [PATCH] x86: ldt.c fix style problems
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 31 Dec 2008 16:42:20 +0530
Message-Id: <1230721940.3738.5.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, fix style problems

Fixes style problems:
WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
ERROR: space required before the open parenthesis '('

total: 1 errors, 1 warnings

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/ldt.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/ldt.c b/arch/x86/kernel/ldt.c
index eee32b4..71f1d99 100644
--- a/arch/x86/kernel/ldt.c
+++ b/arch/x86/kernel/ldt.c
@@ -12,8 +12,8 @@
 #include <linux/mm.h>
 #include <linux/smp.h>
 #include <linux/vmalloc.h>
+#include <linux/uaccess.h>
 
-#include <asm/uaccess.h>
 #include <asm/system.h>
 #include <asm/ldt.h>
 #include <asm/desc.h>
@@ -93,7 +93,7 @@ static inline int copy_ldt(mm_context_t *new, mm_context_t *old)
 	if (err < 0)
 		return err;
 
-	for(i = 0; i < old->size; i++)
+	for (i = 0; i < old->size; i++)
 		write_ldt_entry(new->ldt, i, old->ldt + i * LDT_ENTRY_SIZE);
 	return 0;
 }
-- 
1.5.5.1



