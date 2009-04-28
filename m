Return-Path: <linux-kernel-owner+w=401wt.eu-S1759830AbZD1BvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759830AbZD1BvZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 21:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbZD1BvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 21:51:14 -0400
Received: from mga03.intel.com ([143.182.124.21]:9251 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbZD1BvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 21:51:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,257,1239001200"; 
   d="scan'208";a="136585590"
Message-Id: <20090428010907.912554629@intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 28 Apr 2009 09:09:07 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: "Wu, Fengguang" <fengguang.wu@intel.com>, Andi Kleen <andi@firstfloor.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH 0/5] proc: export more page flags in /proc/kpageflags (take 4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Export 9 more flags to end users (and more for kernel developers):

        11. KPF_MMAP            (pseudo flag) memory mapped page
        12. KPF_ANON            (pseudo flag) memory mapped page (anonymous)
        13. KPF_SWAPCACHE       page is in swap cache
        14. KPF_SWAPBACKED      page is swap/RAM backed
        15. KPF_COMPOUND_HEAD   (*)
        16. KPF_COMPOUND_TAIL   (*)
        17. KPF_UNEVICTABLE     page is in the unevictable LRU list
        18. KPF_HWPOISON        hardware detected corruption
        19. KPF_NOPAGE          (pseudo flag) no page frame at the address

        (*) For compound pages, exporting _both_ head/tail info enables
            users to tell where a compound page starts/ends, and its order.

Please check the documentary patch and changelog of the final patch
for the details.

	[PATCH 1/5] pagemap: document clarifications                                             
	[PATCH 2/5] pagemap: documentation new page flags                                        
	[PATCH 3/5] mm: introduce PageHuge() for testing huge/gigantic pages                     
	[PATCH 4/5] proc: kpagecount/kpageflags code cleanup                                     
	[PATCH 5/5] proc: export more page flags in /proc/kpageflags                             

Thanks,
Fengguang
-- 

