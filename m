Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177AbZGAEbC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbZGAEbC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 00:31:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750736AbZGAEaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 00:30:52 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37267 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbZGAEaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 00:30:52 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@gmail.com>
Subject: Re: Found the commit that causes the OOMs
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
       David Woodhouse <dwmw2@infradead.org>,
       David Howells <dhowells@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "Barnes, Jesse" <jesse.barnes@intel.com>
In-Reply-To: <20090701042554.GA14344@localhost>
References: <20090701131734.85D9.A69D9226@jp.fujitsu.com> <20090701042554.GA14344@localhost>
Message-Id: <20090701132757.85DC.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  1 Jul 2009 13:30:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > The question is: Why kswapd reclaims are absent here?
> > 
> > if direct reclaim isolate all pages, kswapd can't reclaim any pages.
> 
> OOM will occur in that condition. What happened before that time?

maybe yes, maybe no.
At first test, the system still have droppable file cache. if direct reclaim luckly take it,
the benchmark become successful end, I think.

Thanks.

> 
> > I believe Rik's idea solve this problem.
> 
> Me too :)
> 
> Thanks,
> Fengguang
> 



