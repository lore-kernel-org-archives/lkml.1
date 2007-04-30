Return-Path: <linux-kernel-owner+w=401wt.eu-S965397AbXD3Kay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965397AbXD3Kay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 06:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965407AbXD3Kal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 06:30:41 -0400
Received: from ns1.suse.de ([195.135.220.2]:51240 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965301AbXD3K2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 06:28:06 -0400
From: Andi Kleen <ak@suse.de>
References: <200704301227.598020000@suse.de>
In-Reply-To: <200704301227.598020000@suse.de>
To: zach@vmware.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [31/40] i386: In compat mode, the return value here was uninitialized.
Message-Id: <20070430102805.E81DE151D3@wotan.suse.de>
Date: Mon, 30 Apr 2007 12:28:05 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Zachary Amsden <zach@vmware.com>
Signed-off-by: Zachary Amsden <zach@vmware.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/sysenter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

===================================================================
Index: linux/arch/i386/kernel/sysenter.c
===================================================================
--- linux.orig/arch/i386/kernel/sysenter.c
+++ linux/arch/i386/kernel/sysenter.c
@@ -268,7 +268,7 @@ int arch_setup_additional_pages(struct l
 {
 	struct mm_struct *mm = current->mm;
 	unsigned long addr;
-	int ret;
+	int ret = 0;
 	bool compat;
 
 	down_write(&mm->mmap_sem);
