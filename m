Return-Path: <linux-kernel-owner+w=401wt.eu-S1750977AbZG3Bk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750977AbZG3Bk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 21:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750774AbZG3BkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 21:40:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51785 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbZG3BkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 21:40:24 -0400
Message-ID: <4A70F9E9.5000007@redhat.com>
Date: Wed, 29 Jul 2009 21:39:53 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Larry Woodman <lwoodman@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 2/4] tracing, mm: Add trace events for anti-fragmentation
 falling back to other migratetypes
References: <1248901551-7072-1-git-send-email-mel@csn.ul.ie> <1248901551-7072-3-git-send-email-mel@csn.ul.ie>
In-Reply-To: <1248901551-7072-3-git-send-email-mel@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
> Fragmentation avoidance depends on being able to use free pages from
> lists of the appropriate migrate type. In the event this is not
> possible, __rmqueue_fallback() selects a different list and in some
> circumstances change the migratetype of the pageblock. Simplistically,
> the more times this event occurs, the more likely that fragmentation
> will be a problem later for hugepage allocation at least but there are
> other considerations such as the order of page being split to satisfy
> the allocation.

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
