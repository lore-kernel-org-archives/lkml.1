Return-Path: <linux-kernel-owner+w=401wt.eu-S1758187AbXELHXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187AbXELHXP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 03:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756655AbXELHW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 03:22:59 -0400
Received: from mail26.syd.optusnet.com.au ([211.29.133.167]:36277 "EHLO
	mail26.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756435AbXELHW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 03:22:58 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Paul Jackson <pj@sgi.com>
Subject: Re: [PATCH] mm: swap prefetch improvements
Date: Sat, 12 May 2007 17:28:34 +1000
User-Agent: KMail/1.9.5
Cc: nickpiggin@yahoo.com.au, ray-lk@madrabbit.org, mingo@elte.hu,
       ck@vds.kolivas.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <200705121516.00070.kernel@kolivas.org> <20070511225111.fee05bb9.pj@sgi.com>
In-Reply-To: <20070511225111.fee05bb9.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705121728.34987.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 May 2007 15:51, Paul Jackson wrote:
> Con wrote:
> > Hmm I'm not really sure what it takes to make it cpuset aware;
> > ...
> > It is numa aware to some degree. It stores the node id and when it starts
> > prefetching it only prefetches to nodes that are suitable for prefetching
> > to ...
> > It would be absolutely trivial to add a check for 'number_of_cpusets' <=
> > 1 in  the prefetch_enabled() function. Would you like that?
>
> Hmmm ... it seems that we shadow boxing here ... trying to pick a solution
> to solve a problem when we aren't even sure we have a problem, much less
> what the problem is.
>
> That does not usually lead to the right path.
>
> Could you put some more effort into characterizing what problems
> can arise if one has prefetch and cpusets active at the same time?
>
> My first wild guess is that the only incompatibility would have been that
> prefetch might mess up NUMA placement (get pages on wrong nodes), which
> it seems you have tried to address in your current patches.  So it would
> not surprise me if there was no problem here.

Ummm this is what I've been saying for over a year now but noone has been 
listening.

> We may just have to lean on Nick some more, if he is the only one who
> understands what the problem is, to try again to explain it to us.

-- 
-ck
