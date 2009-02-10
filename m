Return-Path: <linux-kernel-owner+w=401wt.eu-S1754504AbZBJKvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbZBJKvG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 05:51:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbZBJKuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 05:50:54 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41980 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbZBJKux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 05:50:53 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm: remove zone->prev_prioriy
Cc: kosaki.motohiro@jp.fujitsu.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090210104222.GB1740@cmpxchg.org>
References: <20090210184055.6FCB.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090210104222.GB1740@cmpxchg.org>
Message-Id: <20090210195002.6FE6.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 10 Feb 2009 19:50:50 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Feb 10, 2009 at 06:42:30PM +0900, KOSAKI Motohiro wrote:
> > 
> > KAMEZAWA Hiroyuki sugessted to remove zone->prev_priority.
> > it's because Split-LRU VM doesn't use this parameter at all.
> > 
> > 
> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > ---
> >  include/linux/memcontrol.h |   27 -------------------------
> >  include/linux/mmzone.h     |   15 --------------
> >  mm/memcontrol.c            |   31 -----------------------------
> >  mm/page_alloc.c            |    2 -
> >  mm/vmscan.c                |   48 ++-------------------------------------------
> >  mm/vmstat.c                |    2 -
> >  6 files changed, 3 insertions(+), 122 deletions(-)
> 
> > Index: b/include/linux/memcontrol.h
> > ===================================================================
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -88,14 +88,7 @@ extern void mem_cgroup_end_migration(str
> >  /*
> >   * For memory reclaim.
> >   */
> > -extern int mem_cgroup_calc_mapped_ratio(struct mem_cgroup *mem);
> 
> This bit crept in from the next patch, I think.

Grr.
I'll fix this soon.

Thanks for carefully reviewing! 



