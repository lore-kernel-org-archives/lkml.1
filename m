Return-Path: <linux-kernel-owner+w=401wt.eu-S1030667AbXCNGTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030667AbXCNGTO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 02:19:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030683AbXCNGTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 02:19:14 -0400
Received: from holomorphy.com ([66.93.40.71]:37923 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030667AbXCNGTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 02:19:14 -0400
Date: Tue, 13 Mar 2007 23:19:22 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: New thread RDSL, post-2.6.20 kernels and amanda (tar) miss-fires
Message-ID: <20070314061922.GR2986@holomorphy.com>
References: <200703130428.11014.gene.heskett@gmail.com> <200703132331.56140.gene.heskett@gmail.com> <20070314050721.GP2986@holomorphy.com> <200703140209.58375.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703140209.58375.gene.heskett@gmail.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wednesday 14 March 2007, William Lee Irwin III wrote:
> >On Tue, Mar 13, 2007 at 11:31:53PM -0400, Gene Heskett wrote:
> >> Now, can someone suggest a patch I can revert that might fix this? 
> >> The total number of patches between 2.6.20 and 2.6.21-rc1 will have me
> >> building kernels to bisect this till the middle of June at this rate.
> >
> >4 billion patches could be bisected in 34 boots. Between 2.6.20 and
> >2.6.21-rc1 there are only:
> >
> >$ git rev-list --no-merges v2.6.20..v2.6.21-rc1  |wc -l
> >3118
> >
> >patches, requiring 14 boots. In general ceil(log(n)/log(2))+2 boots.
> >
> >Of course, this is a little optimistic because it assumes no additional
> >breakage occurring at the various bisection points. In any event,
> >assuming (pessimistically) 10 minutes per build, this is 280 minutes or
> >4 hours and 40 minutes of build time. I estimate the process should
> >complete well before Friday of this week, never mind June.
> 
On Wed, Mar 14, 2007 at 02:09:57AM -0400, Gene Heskett wrote:
> Chuckle, sorry to disappoint you wli, on that 32 cpu Niagra Con was 
> calling 'poor equipment', maybe.
> Even using  ccache, its about 15-18 minutes per build, with another 10 to 
> edit my build script and construct the kernel tree with the proper 
> patches applied.  Then a reboot, probably 10 minutes by the time I get 
> the nvidia driver installed for the new kernel and get startx'd, then its 
> another 2 hours or a bit less for an amanda run to test it.

2 hours, 48 minutes times 13 boots (see the correction post) is 36
hours, 24 minutes. One attempt a day (24 hours instead of 2 hours, 48
minutes) yyields 2 weeks. So you're still done by April, not June.


-- wli
