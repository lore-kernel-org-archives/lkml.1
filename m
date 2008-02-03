Return-Path: <linux-kernel-owner+w=401wt.eu-S1763428AbYBCLdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763428AbYBCLdB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 06:33:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbYBCLcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 06:32:50 -0500
Received: from qb-out-0506.google.com ([72.14.204.232]:43262 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbYBCLct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 06:32:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=BOeV0La0ZwVgCpXW4hn2URk9ggIvJ+B8AdPipIsiPB61T/Zzkv5dByT/74TNSguynvJ1nvobwO3XmAqecyJ7K5BZdS101a8NazTUYedzXgBGKSIR8XSfk2a8fSMO/WHx7w8+AhfSxe6M9bjIvTX7nqTSMnJA4PLOHYyKZUM1x4s=
References: <20080203112217.126814108@gmail.com>>
User-Agent: quilt/0.46-1
Date: Sun, 03 Feb 2008 14:22:19 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: linux-kernel@vger.kernel.org, davem@davemloft.net, bryan.wu@analog.com,
       hskinnemoen@atmel.co, dhowells@redhat.com
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 2/4] BLACKFIN: cleanup - use _AC macro to define PAGE_SIZE
Content-Disposition: inline; filename=blackfin-page.diff
Message-ID: <47a5a65d.0422300a.1ac1.3061@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

 page.h |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

Index: linux-2.6.git/include/asm-blackfin/page.h
===================================================================
--- linux-2.6.git.orig/include/asm-blackfin/page.h	2008-02-03 13:39:38.000000000 +0300
+++ linux-2.6.git/include/asm-blackfin/page.h	2008-02-03 13:42:10.000000000 +0300
@@ -1,14 +1,12 @@
 #ifndef _BLACKFIN_PAGE_H
 #define _BLACKFIN_PAGE_H
 
+#include <linux/const.h>
+
 /* PAGE_SHIFT determines the page size */
 
 #define PAGE_SHIFT	12
-#ifdef __ASSEMBLY__
-#define PAGE_SIZE	(1 << PAGE_SHIFT)
-#else
-#define PAGE_SIZE	(1UL << PAGE_SHIFT)
-#endif
+#define PAGE_SIZE	(_AC(1, UL) << PAGE_SHIFT)
 #define PAGE_MASK	(~(PAGE_SIZE-1))
 
 #ifdef __KERNEL__

-- 
