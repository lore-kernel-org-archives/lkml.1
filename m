Return-Path: <linux-kernel-owner+w=401wt.eu-S1754791AbZIJAdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbZIJAdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 20:33:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754777AbZIJAdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 20:33:04 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39598 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901AbZIJAdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 20:33:03 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [PATCH 0/8] mm: around get_user_pages flags
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20090908090009.0CC0.A69D9226@jp.fujitsu.com>
References: <Pine.LNX.4.64.0909072222070.15424@sister.anvils> <20090908090009.0CC0.A69D9226@jp.fujitsu.com>
Message-Id: <20090910093207.9CC6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 10 Sep 2009 09:33:00 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Here's a series of mm mods against current mmotm: mostly cleanup
> > of get_user_pages flags, but fixing munlock's OOM, sorting out the
> > "FOLL_ANON optimization", and reinstating ZERO_PAGE along the way.
> > 
> >  fs/binfmt_elf.c         |   42 ++------
> >  fs/binfmt_elf_fdpic.c   |   56 ++++-------
> >  include/linux/hugetlb.h |    4 
> >  include/linux/mm.h      |    4 
> >  mm/hugetlb.c            |   62 +++++++------
> >  mm/internal.h           |    7 -
> >  mm/memory.c             |  180 +++++++++++++++++++++++---------------
> >  mm/mlock.c              |   99 ++++++++------------
> >  mm/nommu.c              |   22 ++--
> >  9 files changed, 235 insertions(+), 241 deletions(-)
> 
> Great!
> I'll start to test this patch series. Thanks Hugh!!

At least, My 24H stress workload test didn't find any problem.
I'll continue testing.


