Return-Path: <linux-kernel-owner+w=401wt.eu-S1758133AbYD0K4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133AbYD0K4T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 06:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752732AbYD0K4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 06:56:08 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:57940 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752672AbYD0K4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 06:56:07 -0400
Date: Sun, 27 Apr 2008 12:56:38 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, viro@ZenIV.linux.org.uk
Subject: Re: CONFIG_OPTIMIZE_INLINING
Message-ID: <20080427105638.GA14866@uranus.ravnborg.org>
References: <20080426.215513.141243565.davem@davemloft.net> <20080427055943.GA16290@elte.hu> <20080427062600.GA4392@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080427062600.GA4392@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 02:26:00AM -0400, Christoph Hellwig wrote:
> On Sun, Apr 27, 2008 at 07:59:43AM +0200, Ingo Molnar wrote:
> > here, two months ago:
> > 
> >   http://lkml.org/lkml/2008/3/3/122
> > 
> > i made it x86-only due to this FUD that went against it:
> > 
> >   "messing with a global #define in a way that the results on 24 
> >    architectures with 7 different releases of gcc would be 
> >    unpredictable."
> > 
> > ... as i saw no reason why this feature, which i found rather useful, 
> > should be delayed another year or so. I'd be more than happy to promote 
> > this feature back to lib/Kconfig.debug, sparc64 interest would make that 
> > a strong argument.
> > 
> > and here is the pull request that i posted to lkml, with the full patch 
> > included as well:
> > 
> >   http://www.gossamer-threads.com/lists/linux/kernel/911104?page=last
> 
> This still does not explain why it's two commits.   It also doesn't
> explain the horrible cpp and ifdef abuse in there - having a config
> symbol in one architecture only and then a cpp symbol to prevent the ill
> effects of it in one signle architecture is simply utterly braindead,
> sorry.
> 
> This kind of thing should be discussed at least on linux-arch and input
> from at least partially wise people would have led too a much better
> solution.  Like, umm moving the option to a global config file and let
> the architecture default it to y/n where needed.

I just posted a patch to linux arch that to some extent do as you sketch above.
Then I hope some of the "partially wise" people will nack or ack or suggest
better ways to do it.

	Sam
