Return-Path: <linux-kernel-owner+w=401wt.eu-S933093AbXBLHoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933093AbXBLHoX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 02:44:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933109AbXBLHn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 02:43:57 -0500
Received: from mx1.suse.de ([195.135.220.2]:38412 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933098AbXBLHiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 02:38:16 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212837.963446000@suse.de>
In-Reply-To: <20070212837.963446000@suse.de>
To: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review II] [25/39] x86_64: Fix preprocessor condition
Message-Id: <20070212073813.0A2A713D01@wotan.suse.de>
Date: Mon, 12 Feb 2007 08:38:12 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/asm-x86_64/io.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/include/asm-x86_64/io.h
===================================================================
--- linux.orig/include/asm-x86_64/io.h
+++ linux/include/asm-x86_64/io.h
@@ -100,7 +100,7 @@ __OUTS(l)
 
 #define IO_SPACE_LIMIT 0xffff
 
-#if defined(__KERNEL__) && __x86_64__
+#if defined(__KERNEL__) && defined(__x86_64__)
 
 #include <linux/vmalloc.h>
 
