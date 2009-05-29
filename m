Return-Path: <linux-kernel-owner+w=401wt.eu-S1759660AbZE2Vit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759660AbZE2Vit (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 17:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbZE2Vfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 17:35:53 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60593 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445AbZE2Vfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 17:35:51 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <200905291135.124267638@firstfloor.org>
In-Reply-To: <200905291135.124267638@firstfloor.org>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, fengguang.wu@intel.com
Subject: [PATCH] [14/16] HWPOISON: FOR TESTING: Enable memory failure code unconditionally
Message-Id: <20090529213540.540A81D028F@basil.firstfloor.org>
Date: Fri, 29 May 2009 23:35:40 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Normally the memory-failure.c code is enabled by the architecture, but
for easier testing independent of architecture changes enable it unconditionally.

This should not be merged into mainline.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 mm/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/mm/Kconfig
===================================================================
--- linux.orig/mm/Kconfig	2009-05-29 23:32:11.000000000 +0200
+++ linux/mm/Kconfig	2009-05-29 23:33:28.000000000 +0200
@@ -228,6 +228,8 @@
 
 config MEMORY_FAILURE
 	bool
+	default y
+	depends on MMU
 
 config NOMMU_INITIAL_TRIM_EXCESS
 	int "Turn on mmap() excess space trimming before booting"
