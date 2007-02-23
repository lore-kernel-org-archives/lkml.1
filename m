Return-Path: <linux-kernel-owner+w=401wt.eu-S1750816AbXBWDnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750816AbXBWDnb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 22:43:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750819AbXBWDnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 22:43:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:33179 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbXBWDna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 22:43:30 -0500
Date: Fri, 23 Feb 2007 04:43:09 +0100
From: Nick Piggin <npiggin@suse.de>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, rostedt@goodmis.org
Subject: Re: [patch 2/2] sched: dynticks idle load balancing - v2
Message-ID: <20070223034309.GA21886@wotan.suse.de>
References: <20061213233157.GA20470@elte.hu> <20061213151926.C12795@unix-os.sc.intel.com> <20061219201247.GA12648@elte.hu> <20061219131223.E23105@unix-os.sc.intel.com> <20070116113505.GA6294@elte.hu> <20070130135709.B32010@unix-os.sc.intel.com> <20070216180335.A8744@unix-os.sc.intel.com> <20070216180842.B8744@unix-os.sc.intel.com> <20070222032654.GD12137@wotan.suse.de> <20070222143259.B14789@unix-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070222143259.B14789@unix-os.sc.intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 22, 2007 at 02:33:00PM -0800, Suresh B wrote:
> On Thu, Feb 22, 2007 at 04:26:54AM +0100, Nick Piggin wrote:
> > This is really ugly, sorry :(
> 
> hm. myself and others too thought it was a simple and nice idea.

The idea is not bad. I won't guarantee mine will be as good or better,
but I think it is sensible to try implementing the simplest approach
first, so we can get a baseline to justify more complexity against...

Your code just needs work, but if it really produces good results then
it should be able to be made into a mergeable patch.

> > My suggestion for handling this was to increase the maximum balance
> > interval for an idle CPU, and just implement a global shutdown when
> > the entire system goes idle.
> > 
> > The former should take care of the power savings issues for bare metal
> > hardware, and the latter should solve performance problems for many idle
> > SMP guests. It should take very little code to implement.
> 
> coming to max balance interval will be challenging. It needs to save
> power and at the same time respond to load changes fast enough.

Yep.

> > If that approach doesn't cut it, then at least we can have some numbers
> > to see how much better yours is so we can justify including it.
> > 
> > If you are against my approach, then I can have a try at coding it up
> > if you like?
> 
> Sure. If you can provide a patch, I will be glad to provide power and
> performance comparision numbers with both the approaches.

OK that would be good. I'll see if I can code something up by next week.

Thanks,
Nick
