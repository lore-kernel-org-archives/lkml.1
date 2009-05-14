Return-Path: <linux-kernel-owner+w=401wt.eu-S1759524AbZENL0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759524AbZENL0Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 07:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753761AbZENLZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 07:25:59 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49251 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472AbZENLZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 07:25:58 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH] mmtom: Prevent shrinking of active anon lru list in case of no swap space V2
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>
In-Reply-To: <20090514201150.8536f86e.minchan.kim@barrios-desktop>
References: <20090514201150.8536f86e.minchan.kim@barrios-desktop>
Message-Id: <20090514202538.9B81.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 14 May 2009 20:25:56 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Changelog since V2
>  o Add new function - can_reclaim_anon : it tests anon_list can be reclaim 
> 
> Changelog since V1 
>  o Use nr_swap_pages <= 0 in shrink_active_list to prevent scanning  of active anon list.
> 
> Now shrink_active_list is called several places.
> But if we don't have a swap space, we can't reclaim anon pages.
> So, we don't need deactivating anon pages in anon lru list.
> 
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Rik van Riel <riel@redhat.com>	

looks good to me. thanks :)



