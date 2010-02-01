Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768Ab0BAK3u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 05:29:50 -0500
Received: from gir.skynet.ie ([193.1.99.77]:42135 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726Ab0BAK3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 05:29:49 -0500
Date: Mon, 1 Feb 2010 10:29:36 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Michail Bachmann <mb@emeraldcity.de>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: kernel BUG at mm/page_alloc.c:775
Message-ID: <20100201102935.GA21053@csn.ul.ie>
References: <201001092232.21841.mb@emeraldcity.de> <20100118120315.GD7499@csn.ul.ie> <201001210110.18569.mb@emeraldcity.de> <201001292302.04105.mb@emeraldcity.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <201001292302.04105.mb@emeraldcity.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 11:01:57PM +0100, Michail Bachmann wrote:
> > > On Tue, Jan 12, 2010 at 03:25:23PM -0600, Christoph Lameter wrote:
> > > > On Sat, 9 Jan 2010, Michail Bachmann wrote:
> > > > > [   48.505381] kernel BUG at mm/page_alloc.c:775!
> > > >
> > > > Somehow nodes got mixed up or the lookup tables for pages / zones are
> > > > not giving the right node numbers.
> > >
> > > Agreed. On this type of machine, I'm not sure how that could happen
> > > short of struct page information being corrupted. The range should
> > > always be aligned to a pageblock boundary and I cannot see how that
> > > would cross a zone boundary on this machine.
> > >
> > > Does this machine pass memtest?
> > 
> > I ran one pass with memtest86 without errors before posting this bug, but I
> > can let it run "all tests" for a while just to be sure it is not caused by
> > broken hw.
> 
> Please disregard this bug report. After running memtest for more than 10 hours 
> it found a memory error.

I'm sorry to hear it but at least the source of the bug is known.

> The funny thing is, linux found it much faster...
> 

It could be that your power supply is slightly too inefficient and the
errors only occur when all cores are active or all disks - something
Linux might do easily where as memtest does not necessarily stress the
machine enough for the power drop to happen.

> Thanks for your time.
> 

Thanks for testing and getting back to us.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
