Return-Path: <linux-kernel-owner+w=401wt.eu-S1946158AbXBPWGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946158AbXBPWGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 17:06:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946248AbXBPWGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 17:06:42 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:47271 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946158AbXBPWGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 17:06:41 -0500
Date: Fri, 16 Feb 2007 23:06:54 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org
Subject: [PATCH] Remove stack hard limit on ia64
Message-ID: <20070216220654.GA11135@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: schwab@suse.de

Un-Breaks pthreads, since Oct 2003.


Signed-off-by: Olaf Hering <olaf@aepfle.de>

---
 include/asm-ia64/resource.h |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6/include/asm-ia64/resource.h
===================================================================
--- linux-2.6.orig/include/asm-ia64/resource.h
+++ linux-2.6/include/asm-ia64/resource.h
@@ -2,7 +2,6 @@
 #define _ASM_IA64_RESOURCE_H
 
 #include <asm/ustack.h>
-#define _STK_LIM_MAX	DEFAULT_USER_STACK_SIZE
 #include <asm-generic/resource.h>
 
 #endif /* _ASM_IA64_RESOURCE_H */
