Return-Path: <linux-kernel-owner+w=401wt.eu-S1755522AbZFDVba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522AbZFDVba (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 17:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754649AbZFDV2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 17:28:43 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40882 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748AbZFDV2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 17:28:43 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <200906041128.112757038@firstfloor.org>
In-Reply-To: <200906041128.112757038@firstfloor.org>
To: akpm@linux-foundation.org, npiggin@suse.de, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, fengguang.wu@intel.com
Subject: [PATCH] [13/15] HWPOISON: FOR TESTING: Enable memory failure code unconditionally
Message-Id: <20090604212825.54B111D0292@basil.firstfloor.org>
Date: Thu,  4 Jun 2009 23:28:25 +0200 (CEST)
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
@@ -222,6 +222,8 @@ config KSM
 
 config MEMORY_FAILURE
 	bool
+	default y
+	depends on MMU
 
 config NOMMU_INITIAL_TRIM_EXCESS
 	int "Turn on mmap() excess space trimming before booting"
