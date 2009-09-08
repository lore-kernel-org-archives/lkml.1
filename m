Return-Path: <linux-kernel-owner+w=401wt.eu-S1752434AbZIHWWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434AbZIHWWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 18:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbZIHWWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 18:22:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12985 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900AbZIHWWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 18:22:16 -0400
Message-ID: <4AA6D8D0.9050509@redhat.com>
Date: Tue, 08 Sep 2009 18:21:04 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 5/8] mm: follow_hugetlb_page flags
References: <Pine.LNX.4.64.0909072222070.15424@sister.anvils> <Pine.LNX.4.64.0909072235360.15430@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0909072235360.15430@sister.anvils>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> follow_hugetlb_page() shouldn't be guessing about the coredump case
> either: pass the foll_flags down to it, instead of just the write bit.
> 
> Remove that obscure huge_zeropage_ok() test.  The decision is easy,
> though unlike the non-huge case - here vm_ops->fault is always set.
> But we know that a fault would serve up zeroes, unless there's
> already a hugetlbfs pagecache page to back the range.
> 
> (Alternatively, since hugetlb pages aren't swapped out under pressure,
> you could save more dump space by arguing that a page not yet faulted
> into this process cannot be relevant to the dump; but that would be
> more surprising.)
> 
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
