Return-Path: <linux-kernel-owner+w=401wt.eu-S1755674AbZHKXdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674AbZHKXdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 19:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754309AbZHKXdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 19:33:40 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59475 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021AbZHKXdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 19:33:39 -0400
Date: Wed, 12 Aug 2009 08:31:02 +0900 (JST)
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 1/6] tracing, page-allocator: Add trace events for page allocation and page freeing
Cc: kosaki.motohiro@jp.fujitsu.com, Larry Woodman <lwoodman@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       riel@redhat.com, Peter Zijlstra <peterz@infradead.org>,
       Li Ming Chun <macli@brc.ubc.ca>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
In-Reply-To: <1249918915-16061-2-git-send-email-mel@csn.ul.ie>
References: <1249918915-16061-1-git-send-email-mel@csn.ul.ie> <1249918915-16061-2-git-send-email-mel@csn.ul.ie>
Message-Id: <20090811163939.9ADF.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch adds trace events for the allocation and freeing of pages,
> including the freeing of pagevecs.  Using the events, it will be known what
> struct page and pfns are being allocated and freed and what the call site
> was in many cases.
> 
> The page alloc tracepoints be used as an indicator as to whether the workload
> was heavily dependant on the page allocator or not. You can make a guess based
> on vmstat but you can't get a per-process breakdown. Depending on the call
> path, the call_site for page allocation may be __get_free_pages() instead
> of a useful callsite. Instead of passing down a return address similar to
> slab debugging, the user should enable the stacktrace and seg-addr options
> to get a proper stack trace.
> 
> The pagevec free tracepoint has a different usecase. It can be used to get
> a idea of how many pages are being dumped off the LRU and whether it is
> kswapd doing the work or a process doing direct reclaim.

Looks good to me.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>




