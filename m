Return-Path: <linux-kernel-owner+w=401wt.eu-S932120AbZIBBa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120AbZIBBa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 21:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755370AbZIBBa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 21:30:27 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42167 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755480AbZIBBa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 21:30:26 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [PATCH mmotm] vmscan move pgdeactivate modification to shrink_active_list fix2
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <Pine.LNX.4.64.0909020154060.31130@sister.anvils>
References: <Pine.LNX.4.64.0908282034240.19475@sister.anvils> <Pine.LNX.4.64.0909020154060.31130@sister.anvils>
Message-Id: <20090902102048.1A98.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  2 Sep 2009 10:30:26 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> A second fix to the ill-starred
> vmscan-move-pgdeactivate-modification-to-shrink_active_list.patch
> which, once corrected to update the right counters by the first fix,
> builds up absurdly large Active counts in /proc/meminfo.
> 
> nr_rotated is not the number of pages added back to the active list
> (maybe it once was, maybe it should be again: but if so that's not
> any business for a code rearrangement patch).  shrink_active_list()
> needs to keep a separate nr_reactivated count of those.
> 
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> ---
> Or... revert the offending patch and its first fix.

Yes, The original patch author should be layoff :(

Andrew, can you please drop the patch?
I need to clean my brain and the patch need proper additional test.

I plan to resubmit it at next -rc2 or -rc3.


I'm sorry.


