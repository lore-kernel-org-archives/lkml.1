Return-Path: <linux-kernel-owner+w=401wt.eu-S933832AbZHEJ0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933832AbZHEJ0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 05:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932964AbZHEJ0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 05:26:36 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37318 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932946AbZHEJ0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 05:26:35 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 2/4] tracing, mm: Add trace events for anti-fragmentation falling back to other migratetypes
Cc: kosaki.motohiro@jp.fujitsu.com, Larry Woodman <lwoodman@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, riel@redhat.com,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
In-Reply-To: <1249409546-6343-3-git-send-email-mel@csn.ul.ie>
References: <1249409546-6343-1-git-send-email-mel@csn.ul.ie> <1249409546-6343-3-git-send-email-mel@csn.ul.ie>
Message-Id: <20090805182518.5BD0.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  5 Aug 2009 18:26:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Fragmentation avoidance depends on being able to use free pages from
> lists of the appropriate migrate type. In the event this is not
> possible, __rmqueue_fallback() selects a different list and in some
> circumstances change the migratetype of the pageblock. Simplistically,
> the more times this event occurs, the more likely that fragmentation
> will be a problem later for hugepage allocation at least but there are
> other considerations such as the order of page being split to satisfy
> the allocation.
> 
> This patch adds a trace event for __rmqueue_fallback() that reports what
> page is being used for the fallback, the orders of relevant pages, the
> desired migratetype and the migratetype of the lists being used, whether
> the pageblock changed type and whether this event is important with
> respect to fragmentation avoidance or not. This information can be used
> to help analyse fragmentation avoidance and help decide whether
> min_free_kbytes should be increased or not.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> Acked-by: Rik van Riel <riel@redhat.com>

Looks good to me.
but I don't put my reviewed-by because I am not so familiar this area.



