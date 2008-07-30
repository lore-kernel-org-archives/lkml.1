Return-Path: <linux-kernel-owner+w=401wt.eu-S1753291AbYG3EjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbYG3EjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 00:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751172AbYG3EjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 00:39:05 -0400
Received: from ozlabs.org ([203.10.76.45]:34420 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbYG3EjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 00:39:04 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: lguest <lguest@ozlabs.org>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: [PATCH 1/2] Export get_user_pages_fast
Date: Wed, 30 Jul 2008 14:38:55 +1000
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807301438.55941.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After all, it was made for lguest wasn't it?  Still think it should be
called get_current_pages() though.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/mm/gup.c |    2 ++
 1 file changed, 2 insertions(+)

diff -r cb465381f6d5 arch/x86/mm/gup.c
--- a/arch/x86/mm/gup.c	Wed Jul 30 10:18:44 2008 +1000
+++ b/arch/x86/mm/gup.c	Wed Jul 30 14:22:53 2008 +1000
@@ -8,6 +8,7 @@
 #include <linux/mm.h>
 #include <linux/vmstat.h>
 #include <linux/highmem.h>
+#include <linux/module.h>
 
 #include <asm/pgtable.h>
 
@@ -296,3 +303,4 @@ slow_irqon:
 		return ret;
 	}
 }
+EXPORT_SYMBOL_GPL(get_user_pages_fast);
