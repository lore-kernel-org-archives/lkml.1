Return-Path: <linux-kernel-owner+w=401wt.eu-S933439AbXGSKEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933439AbXGSKEm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759216AbXGSJzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:55:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:33061 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757467AbXGSJzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:55:06 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: yhlu.kernel@gmail.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [18/58] x86_64: remove extra extern declaring about dmi_ioremap
Message-Id: <20070719095503.288FC14E06@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:55:03 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Yinghai Lu" <yhlu.kernel@gmail.com>

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/asm-x86_64/dmi.h |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: linux/include/asm-x86_64/dmi.h
===================================================================
--- linux.orig/include/asm-x86_64/dmi.h
+++ linux/include/asm-x86_64/dmi.h
@@ -3,15 +3,12 @@
 
 #include <asm/io.h>
 
-extern void *dmi_ioremap(unsigned long addr, unsigned long size);
-extern void dmi_iounmap(void *addr, unsigned long size);
-
 #define DMI_MAX_DATA 2048
 
 extern int dmi_alloc_index;
 extern char dmi_alloc_data[DMI_MAX_DATA];
 
-/* This is so early that there is no good way to allocate dynamic memory. 
+/* This is so early that there is no good way to allocate dynamic memory.
    Allocate data in an BSS array. */
 static inline void *dmi_alloc(unsigned len)
 {
