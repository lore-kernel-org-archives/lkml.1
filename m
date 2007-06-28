Return-Path: <linux-kernel-owner+w=401wt.eu-S1758829AbXF1OJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829AbXF1OJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 10:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbXF1OJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 10:09:33 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:46102 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996AbXF1OJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 10:09:32 -0400
Date: Thu, 28 Jun 2007 18:09:21 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: dhowells@redhat.com
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] frv: fix fallout from "remove sched.h from mm.h" patch
Message-ID: <20070628140921.GA9753@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 include/asm-frv/pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/asm-frv/pgtable.h
+++ b/include/asm-frv/pgtable.h
@@ -25,7 +25,7 @@
 #include <linux/slab.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
-struct mm_struct;
+#include <linux/sched.h>
 struct vm_area_struct;
 #endif
 

