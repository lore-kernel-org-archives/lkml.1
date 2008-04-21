Return-Path: <linux-kernel-owner+w=401wt.eu-S1759759AbYDUIzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759759AbYDUIzL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 04:55:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757491AbYDUIwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 04:52:12 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:36342 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759279AbYDUIwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 04:52:09 -0400
Date: Mon, 21 Apr 2008 11:51:40 +0300
From: Adrian Bunk <bunk@kernel.org>
To: dhowells@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] frv: unexport kmap_atomic_to_page
Message-ID: <20080421085140.GG26897@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the no longer used export of kmap_atomic_to_page.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
4c236584e175d39dbd522397fb642b82b58f9e31 diff --git a/arch/frv/mm/highmem.c b/arch/frv/mm/highmem.c
index 7f77db7..eadd076 100644
--- a/arch/frv/mm/highmem.c
+++ b/arch/frv/mm/highmem.c
@@ -36,6 +36,3 @@ struct page *kmap_atomic_to_page(void *ptr)
 {
 	return virt_to_page(ptr);
 }
-
-
-EXPORT_SYMBOL(kmap_atomic_to_page);

