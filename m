Return-Path: <linux-kernel-owner+w=401wt.eu-S1758372AbZIOUa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758372AbZIOUa5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 16:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754233AbZIOUaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 16:30:52 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:41824 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752196AbZIOUaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 16:30:52 -0400
X-Trace: 259122119/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.84.74/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.84.74
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlgFAJ6Wr0pPRVRK/2dsb2JhbACBU953hBcF
X-IronPort-AV: E=Sophos;i="4.44,391,1249254000"; 
   d="scan'208";a="259122119"
Date: Tue, 15 Sep 2009 21:30:09 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       Mel Gorman <mel@csn.ul.ie>, Minchan Kim <minchan.kim@gmail.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 0/4] mm: mlock, hugetlb, zero followups
In-Reply-To: <Pine.LNX.4.64.0909072222070.15424@sister.anvils>
Message-ID: <Pine.LNX.4.64.0909152127240.22199@sister.anvils>
References: <Pine.LNX.4.64.0909072222070.15424@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a gang of four patches against current mmotm, following
on from the eight around get_user_pages flags, addressing
concerns raised on those.  Best slotted in as a group after
mm-foll-flags-for-gup-flags.patch

 arch/mips/include/asm/pgtable.h |   14 ++++++++
 mm/hugetlb.c                    |   16 ++++++---
 mm/internal.h                   |    3 +
 mm/memory.c                     |   37 +++++++++++++++-------
 mm/mlock.c                      |   49 ++++++++++++++++++++++--------
 mm/page_alloc.c                 |    1 
 6 files changed, 89 insertions(+), 31 deletions(-)

Thanks,
Hugh
