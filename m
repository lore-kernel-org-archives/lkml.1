Return-Path: <linux-kernel-owner+w=401wt.eu-S1754644AbZGDNrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbZGDNrk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 09:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbZGDNrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 09:47:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50254 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753249AbZGDNra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 09:47:30 -0400
Message-ID: <4A4F5D4F.5000104@redhat.com>
Date: Sat, 04 Jul 2009 09:46:55 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
       Mel Gorman <mel@csn.ul.ie>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH][mmotm] don't attempt to reclaim anon page in lumpy reclaim
 when no swap space is available
References: <20090704141818.0afa877a.minchan.kim@gmail.com>
In-Reply-To: <20090704141818.0afa877a.minchan.kim@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minchan Kim wrote:

> VM already avoids attempting to reclaim anon pages in various places, But
> it doesn't avoid it for lumpy reclaim.
> 
> It shuffles lru list unnecessary so that it is pointless.
> 
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
