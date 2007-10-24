Return-Path: <linux-kernel-owner+w=401wt.eu-S1761327AbXJXQai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761327AbXJXQai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758864AbXJXQXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:23:21 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33353 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758643AbXJXQXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:23:20 -0400
Date: Wed, 24 Oct 2007 18:23:49 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Adam Litke <agl@us.ibm.com>, wli@holomorphy.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] mm/hugetlb.c: make a function static
Message-ID: <20071024162349.GX30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

return_unused_surplus_pages() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
8932fe99341629d50863643229d25666e9f44e03 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 8b809ec..b65da0d 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -323,7 +323,7 @@ free:
  * allocated to satisfy the reservation must be explicitly freed if they were
  * never used.
  */
-void return_unused_surplus_pages(unsigned long unused_resv_pages)
+static void return_unused_surplus_pages(unsigned long unused_resv_pages)
 {
 	static int nid = -1;
 	struct page *page;

