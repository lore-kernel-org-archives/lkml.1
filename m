Return-Path: <linux-kernel-owner+w=401wt.eu-S1756811AbZBKKw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811AbZBKKw0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 05:52:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754899AbZBKKwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 05:52:17 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39596 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892AbZBKKwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 05:52:16 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] vmscan: initialize sc->nr_reclaimed properly take2
Cc: kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, hannes@cmpxchg.org,
       riel@redhat.com, wli@movementarian.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20090210140637.902e4dcc.akpm@linux-foundation.org>
References: <20090210215718.700D.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090210140637.902e4dcc.akpm@linux-foundation.org>
Message-Id: <20090211195116.C3BA.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Wed, 11 Feb 2009 19:52:12 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > @@ -2245,6 +2247,7 @@ static int __zone_reclaim(struct zone *z
> >  	struct reclaim_state reclaim_state;
> >  	int priority;
> >  	struct scan_control sc = {
> > +		.nr_reclaimed = 0,
> >  		.may_writepage = !!(zone_reclaim_mode & RECLAIM_WRITE),
> >  		.may_swap = !!(zone_reclaim_mode & RECLAIM_SWAP),
> >  		.swap_cluster_max = max_t(unsigned long, nr_pages,
> 
> Confused.  The compiler already initialises any unmentioned fields to zero,
> so this patch has no effect.

maybe, I was slept too ;-/




