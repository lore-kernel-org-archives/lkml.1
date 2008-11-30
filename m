Return-Path: <linux-kernel-owner+w=401wt.eu-S1751563AbYK3GbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563AbYK3GbJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 01:31:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750771AbYK3Gaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 01:30:55 -0500
Received: from fgwmail.fujitsu.co.jp ([164.71.1.133]:47411 "EHLO
	fgwmail.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbYK3Gay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 01:30:54 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] vmscan: bail out of page reclaim after swap_cluster_max pages
Cc: kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, mel@csn.ul.ie
In-Reply-To: <49316CAF.2010006@redhat.com>
References: <20081129164624.8134.KOSAKI.MOTOHIRO@jp.fujitsu.com> <49316CAF.2010006@redhat.com>
Message-Id: <20081130150849.8140.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Sun, 30 Nov 2008 15:30:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Reclaiming is very easy when the workload is just page cache,
> because the application will be throttled when too many page
> cache pages are dirty.
> 
> When using mmap or memory hogs writing to swap, applications
> will not be throttled by the "too many dirty pages" logic,
> but may instead end up being throttled in the direct reclaim
> path instead.
> 
> At that point direct reclaim may become a lot more common,
> making the imbalance more significant.

fair enough.


> I'll run a few tests.

Great.
I'm looking for your mail :)


> > Andrew, I hope add this mesurement result to rvr bailing out patch description too.
> 
> So far the performance numbers you have measured are very
> encouraging and do indeed suggest that the priority==DEF_PRIORITY
> thing does not make a difference.

thank you.

I believe reclaim latency reducing doesn't only improve hpc, but also
improve several multimedia and desktop application.



