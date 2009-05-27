Return-Path: <linux-kernel-owner+w=401wt.eu-S1759685AbZE0Fbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759685AbZE0Fbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 01:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbZE0Fbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 01:31:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41318 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751553AbZE0Fbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 01:31:45 -0400
Date: Tue, 26 May 2009 22:30:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Mel Gorman <mel@csn.ul.ie>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: [PATCH 2/3] add inactive ratio calculation function of each
 zone V2
Message-Id: <20090526223002.f283bcd2.akpm@linux-foundation.org>
In-Reply-To: <20090521092321.ee57585e.minchan.kim@barrios-desktop>
References: <20090521092321.ee57585e.minchan.kim@barrios-desktop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 May 2009 09:23:21 +0900 Minchan Kim <minchan.kim@gmail.com> wrote:

> Changelog since V1 
>  o Change function name from calculate_zone_inactive_ratio to calculate_inactive_ratio
>    - by Mel Gorman advise
>  o Modify tab indent - by Mel Gorman advise

The first two patches still had various trivial whitespace bustages. 
You don't need Mel to find these things when we have the very nice
scripts/checkpatch.pl.  Please incorporate that script into your patch
preparation tools

> This patch devide setup_per_zone_inactive_ratio with
> per-zone inactive ratio calculaton.

The above sentence appears to be the changelog for this patch but it
doesn't make a lot of sense.

afaict the changelog should be:

"factor the per-zone arithemetic inside
setup_per_zone_inactive_ratio()'s loop into a a separate function,
calculate_zone_inactive_ratio().  This function will be used in a later
patch".

yes?


> This patch is just for helping my next patch.
> (reset wmark_min and inactive ratio of zone when hotplug happens)
> 
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Rik van Riel <riel@redhat.com>
> CC: Johannes Weiner <hannes@cmpxchg.org>
