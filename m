Return-Path: <linux-kernel-owner+w=401wt.eu-S1757944AbXIBI1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944AbXIBI1p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 04:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756818AbXIBI1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 04:27:36 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58436 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582AbXIBI1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 04:27:35 -0400
Date: Sun, 2 Sep 2007 14:10:37 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Ingo Molnar <mingo@elte.hu>
cc: Daniel Walker <dwalker@mvista.com>, Roman Zippel <zippel@linux-m68k.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       peterz@infradead.org
Subject: Re: [ANNOUNCE/RFC] Really Fair Scheduler
In-Reply-To: <20070902072029.GA24427@elte.hu>
Message-ID: <alpine.LFD.0.999.0709021349290.22654@enigma.security.iitk.ac.in>
References: <Pine.LNX.4.64.0708310139280.1817@scrub.home>
 <1188694367.11196.42.camel@dhcp193.mvista.com>
 <20070902072029.GA24427@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 2 Sep 2007, Ingo Molnar wrote:
> 
> Although it _should_ have been a net code size win, because if you look 
> at the diff you'll see that other useful things were removed as well: 
> sleeper fairness, CPU time distribution smarts, tunings, scheduler 
> instrumentation code, etc.

To be fair to Roman, he probably started development off an earlier CFS,
most probably 2.6.23-rc3-git1, if I guess correctly from his original
posting. So it's likely he missed out on some of the tunings/comments(?)
etc code that got merged after that.

> > I also ran hackbench (in a haphazard way) a few times on it vs. CFS in 
> > my tree, and RFS was faster to some degree (it varied)..
> 
> here are some actual numbers for "hackbench 50" on -rc5, 10 consecutive 
> runs fresh after bootup, Core2Duo, UP:

Again, it would be interesting to benchmark against 2.6.23-rc3-git1. And
also probably rediff vs 2.6.23-rc3-git1 and compare how the code actually
changed ... but admittedly, doing so would be utterly pointless, because
much water has flowed down the Ganges since -rc3 (misc CFS improvements,
Peter's patches that you mentioned). So a "look, I told you so" kind of
situation wouldn't really be constructive at all.

> It would be far more reviewable and objectively judgeable on an item by 
> item basis if Roman posted the finegrained patches i asked for. (which 
> patch series should be sorted in order of intrusiveness - i.e. leaving 
> the harder changes to the end of the series.)

Absolutely. And if there indeed are net improvements (be it for corner
cases) over latest CFS-rc5, while maintaining performance for the common
cases at the same time, well, that can only be a good thing.

Just my Rs. 0.02,

Satyam
