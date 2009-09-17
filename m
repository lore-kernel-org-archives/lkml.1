Return-Path: <linux-kernel-owner+w=401wt.eu-S1755262AbZIQAdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbZIQAdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 20:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753025AbZIQAdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 20:33:23 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35514 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867AbZIQAdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 20:33:22 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [PATCH 0/4] mm: mlock, hugetlb, zero followups
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       Mel Gorman <mel@csn.ul.ie>, Minchan Kim <minchan.kim@gmail.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <Pine.LNX.4.64.0909152127240.22199@sister.anvils>
References: <Pine.LNX.4.64.0909072222070.15424@sister.anvils> <Pine.LNX.4.64.0909152127240.22199@sister.anvils>
Message-Id: <20090917093227.93C9.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 17 Sep 2009 09:33:17 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Here's a gang of four patches against current mmotm, following
> on from the eight around get_user_pages flags, addressing
> concerns raised on those.  Best slotted in as a group after
> mm-foll-flags-for-gup-flags.patch
> 
>  arch/mips/include/asm/pgtable.h |   14 ++++++++
>  mm/hugetlb.c                    |   16 ++++++---
>  mm/internal.h                   |    3 +
>  mm/memory.c                     |   37 +++++++++++++++-------
>  mm/mlock.c                      |   49 ++++++++++++++++++++++--------
>  mm/page_alloc.c                 |    1 
>  6 files changed, 89 insertions(+), 31 deletions(-)

My stress load found no problem too.

Thanks.


