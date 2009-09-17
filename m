Return-Path: <linux-kernel-owner+w=401wt.eu-S1757092AbZIQLww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757092AbZIQLww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 07:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbZIQLww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 07:52:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45655 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470AbZIQLwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 07:52:51 -0400
Date: Thu, 17 Sep 2009 13:52:52 +0200
From: Nick Piggin <npiggin@suse.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Sachin Sant <sachinp@in.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, heiko.carstens@de.ibm.com, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC/PATCH] SLQB: Mark the allocator as broken PowerPC and S390
Message-ID: <20090917115252.GO18404@wotan.suse.de>
References: <1253083059.5478.1.camel@penberg-laptop> <20090917100841.GF13002@csn.ul.ie> <1253183365.4975.20.camel@penberg-laptop> <20090917105707.GA7205@csn.ul.ie> <4AB21C3D.2080202@in.ibm.com> <20090917113837.GK18404@wotan.suse.de> <84144f020909170443y5f8c3c8fo7d2a4163e636f368@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020909170443y5f8c3c8fo7d2a4163e636f368@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 02:43:38PM +0300, Pekka Enberg wrote:
> Hi Nick,
> 
> Mel Gorman wrote:
> >> >I have access to a ppc machine but not necessarily one with a memoryless
> >> >nodes
> >> >that can reproduce this problem.
> >> >
> >> >Assuming Sachin is the reporter and we are in the same company, maybe I
> >> >have access to the machine. Sachin, can you mail me privately what this
> >> >machine is called and lets see can I get some time on that machine? By
> >> >any chance, was this bisected or did it just show up when SLQB became
> >> >the default?
> 
> On Thu, Sep 17, 2009 at 04:53:41PM +0530, Sachin Sant wrote:
> >> Have sent you the access details for the machine. This bug showed
> >> up when SLQB was enabled as default in linux-next
> 
> On Thu, Sep 17, 2009 at 2:38 PM, Nick Piggin <npiggin@suse.de> wrote:
> > Maybe it will be better to hold off merging until this is
> > debugged then? If it is merged as a non-default option, then
> > I can't see it being a huge issue to merge it a bit after the
> > window? It doesn't touch anything else...
> 
> Me sending anything but bug fixes to Linus after the merge window is
> closed...? That's one scary thought!

Well, I don't know if it is much different than merging with known
bugs and expecting to resolve them. Maybe it circumvents the
_letter_ of the merge window law, but in spirit it is probably
nicer to merge after fixing the bug :)

But I'll let you decide how to proceed.
 
