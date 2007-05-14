Return-Path: <linux-kernel-owner+w=401wt.eu-S1756899AbXENIKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899AbXENIKc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 04:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754910AbXENIKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 04:10:22 -0400
Received: from ozlabs.org ([203.10.76.45]:33880 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754895AbXENIKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 04:10:22 -0400
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Mon, 14 May 2007 18:09:52 +1000
Subject: [PATCH] Make __vunmap static
Message-Id: <20070514081020.DAC98DDEE3@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

__vunmap doesn't seem to be used outside of mm/vmalloc.c, and has
no prototype in any header so let's make it static

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-cell/mm/vmalloc.c
===================================================================
--- linux-cell.orig/mm/vmalloc.c	2007-05-14 18:04:48.000000000 +1000
+++ linux-cell/mm/vmalloc.c	2007-05-14 18:04:50.000000000 +1000
@@ -311,7 +311,7 @@ struct vm_struct *remove_vm_area(void *a
 	return v;
 }
 
-void __vunmap(void *addr, int deallocate_pages)
+static void __vunmap(void *addr, int deallocate_pages)
 {
 	struct vm_struct *area;
 
