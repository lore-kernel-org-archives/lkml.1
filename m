Return-Path: <linux-kernel-owner+w=401wt.eu-S1753973AbZFLE56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbZFLE56 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 00:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbZFLE5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 00:57:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:14528 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310AbZFLE5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 00:57:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,207,1243839600"; 
   d="scan'208";a="465687196"
Date: Fri, 12 Jun 2009 12:57:52 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: [PATCH trival]x64: make one __init to __meminit
Message-ID: <20090612045752.GA827@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel_physical_mapping_init could be called in memory hotplug path.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 52bb951..52e1bff 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -527,7 +527,7 @@ phys_pud_update(pgd_t *pgd, unsigned long addr, unsigned long end,
 	return phys_pud_init(pud, addr, end, page_size_mask);
 }
 
-unsigned long __init
+unsigned long __meminit
 kernel_physical_mapping_init(unsigned long start,
 			     unsigned long end,
 			     unsigned long page_size_mask)
