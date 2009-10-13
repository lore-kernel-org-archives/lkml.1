Return-Path: <linux-kernel-owner+w=401wt.eu-S933741AbZJMIEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933741AbZJMIEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 04:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759000AbZJMIEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 04:04:36 -0400
Received: from mga03.intel.com ([143.182.124.21]:52983 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754488AbZJMIEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 04:04:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,550,1249282800"; 
   d="scan'208";a="198263513"
Date: Tue, 13 Oct 2009 16:03:55 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org
Cc: Rik van Riel <riel@redhat.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Elladan <elladan@eskimo.com>, Nick Piggin <npiggin@suse.de>,
       Andi Kleen <andi@firstfloor.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH][BUGFIX] vmscan: limit VM_EXEC protection to file pages
Message-ID: <20091013080355.GA20927@localhost>
References: <200910122244.19666.borntraeger@de.ibm.com> <20091013022650.GB7345@localhost> <4AD3E6C4.805@redhat.com> <20091013080054.GA20395@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091013080054.GA20395@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This bug fix applies to both 2.6.31 and 2.6.32.

Christoph did the hard work of catching/testing it, thanks!
