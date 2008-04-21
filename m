Return-Path: <linux-kernel-owner+w=401wt.eu-S1759922AbYDUIys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759922AbYDUIys (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 04:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756474AbYDUIwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 04:52:08 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:41230 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759279AbYDUIwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 04:52:06 -0400
Date: Mon, 21 Apr 2008 11:51:37 +0300
From: Adrian Bunk <bunk@kernel.org>
To: ralf@linux-mips.org
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] mips: unexport __kmap_atomic_to_page
Message-ID: <20080421085137.GF26897@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the no longer used export of __kmap_atomic_to_page.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
4d052a402ef108fb899e725d3492b605b8921d15 diff --git a/arch/mips/mm/highmem.c b/arch/mips/mm/highmem.c
index 10dd2af..8f2cd8e 100644
--- a/arch/mips/mm/highmem.c
+++ b/arch/mips/mm/highmem.c
@@ -116,4 +116,3 @@ EXPORT_SYMBOL(__kmap);
 EXPORT_SYMBOL(__kunmap);
 EXPORT_SYMBOL(__kmap_atomic);
 EXPORT_SYMBOL(__kunmap_atomic);
-EXPORT_SYMBOL(__kmap_atomic_to_page);
