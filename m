Return-Path: <linux-kernel-owner+w=401wt.eu-S933405AbZHDVxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933405AbZHDVxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 17:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933296AbZHDVxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 17:53:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43947 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933274AbZHDVxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 17:53:12 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <200908041152.240876191@firstfloor.org>
In-Reply-To: <200908041152.240876191@firstfloor.org>
To: akpm@linux-foundation.org, linux-mm@vger.kernel.org,
       linux-kernel@vger.kernel.org, fengguang.wu@intel.com
Subject: [PATCH] [13/15] HWPOISON: FOR TESTING: Enable memory failure code unconditionally
Message-Id: <20090804215312.5FEA5B15D8@basil.firstfloor.org>
Date: Tue,  4 Aug 2009 23:53:12 +0200 (CEST)
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
--- linux.orig/mm/Kconfig
+++ linux/mm/Kconfig
@@ -235,6 +235,8 @@ config DEFAULT_MMAP_MIN_ADDR
 
 config MEMORY_FAILURE
 	bool
+	default y
+	depends on MMU
 
 config NOMMU_INITIAL_TRIM_EXCESS
 	int "Turn on mmap() excess space trimming before booting"
