Return-Path: <linux-kernel-owner+w=401wt.eu-S1758191AbXJCMOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191AbXJCMOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 08:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755820AbXJCMOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 08:14:14 -0400
Received: from mx12.go2.pl ([193.17.41.142]:47786 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755788AbXJCMOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 08:14:14 -0400
Date: Wed, 3 Oct 2007 14:16:46 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       David Schwartz <davids@webmaster.com>, linux-kernel@vger.kernel.org
Subject: Re: yield
Message-ID: <20071003121646.GB3828@ff.dom.local>
References: <20071002060607.GA18588@elte.hu> <20071003080224.GB1726@ff.dom.local> <20071003081613.GA29904@elte.hu> <20071003085636.GC1726@ff.dom.local> <20071003091058.GB7802@elte.hu> <20071003095057.GD1726@ff.dom.local> <b647ffbd0710030355p116f9b36vae3f24e652921de6@mail.gmail.com> <20071003114027.GA3828@ff.dom.local> <20071003115646.GA25576@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071003115646.GA25576@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2007 at 01:56:46PM +0200, Ingo Molnar wrote:
> 
> * Jarek Poplawski <jarkao2@o2.pl> wrote:
> 
> > On Wed, Oct 03, 2007 at 12:55:34PM +0200, Dmitry Adamushko wrote:
> > ...
> > > just a quick patch, not tested and I've not evaluated all possible
> > > implications yet.
> > > But someone might give it a try with his/(her -- are even more
> > > welcomed :-) favourite sched_yield() load.
> > 
> > Of course, after some evaluation by yourself and Ingo the most 
> > interesting should be Martin's Michlmayr testing, so I hope you'll Cc 
> > him too?!
> 
> My current take on this: queue the current task right to the next 
> position in the tree (this is what this patch achieves in essence) was 
> one of the yield implementations we already tried in CFS but it didnt 
> meet the expectations of some apps. So i can only repeat my argument: 
> this is not something that can be "solved" in the way you imagine and 
> your arguments just reiterate the path that CFS has already taken in the 
> past. So please do not expect _us_ to go out and pester people. If 
> people feel so inclined, they are of course welcome to test out various 
> approaches. (they might as well try the original yield-granularity patch 
> which also makes the amount of "delay" tunable, so the ideal amount of 
> delay can be figured out. And of course they should also try the 
> existing yield flag.)

I'm terribly sorry! Of course, the last thing I would like is to
pester anybody. I simply wasn't sure you've told about the same
idea. And of course, there is no reason to go back to something
checked before.

Thanks,
Jarek P.
