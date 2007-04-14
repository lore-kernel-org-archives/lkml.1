Return-Path: <linux-kernel-owner+w=401wt.eu-S1753863AbXDNVXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbXDNVXI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 17:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753867AbXDNVVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 17:21:55 -0400
Received: from gw.goop.org ([64.81.55.164]:59549 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753846AbXDNVUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 17:20:18 -0400
Message-Id: <20070414204924.502214429@goop.org>
References: <20070414204154.871250608@goop.org>
User-Agent: quilt/0.46-1
Date: Sat, 14 Apr 2007 13:42:09 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Zachary Amsden <zach@vmware.com>
Subject: [PATCH 15/28] In compat mode, the return value here was uninitialized.
Content-Disposition: inline; filename=i386-sysenter-arch-pages-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zachary Amsden <zach@vmware.com>
Signed-off-by: Zachary Amsden <zach@vmware.com>

---
 arch/i386/kernel/sysenter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

===================================================================
--- a/arch/i386/kernel/sysenter.c
+++ b/arch/i386/kernel/sysenter.c
@@ -254,7 +254,7 @@ int arch_setup_additional_pages(struct l
 {
 	struct mm_struct *mm = current->mm;
 	unsigned long addr;
-	int ret;
+	int ret = 0;
 	bool compat;
 
 	down_write(&mm->mmap_sem);

-- 

