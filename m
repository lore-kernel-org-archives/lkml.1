Return-Path: <linux-kernel-owner+w=401wt.eu-S1757993AbXJCL5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993AbXJCL5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 07:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755776AbXJCL5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 07:57:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57666 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754862AbXJCL5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 07:57:03 -0400
Date: Wed, 3 Oct 2007 13:56:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       David Schwartz <davids@webmaster.com>, linux-kernel@vger.kernel.org
Subject: Re: yield
Message-ID: <20071003115646.GA25576@elte.hu>
References: <20071002060607.GA18588@elte.hu> <20071003080224.GB1726@ff.dom.local> <20071003081613.GA29904@elte.hu> <20071003085636.GC1726@ff.dom.local> <20071003091058.GB7802@elte.hu> <20071003095057.GD1726@ff.dom.local> <b647ffbd0710030355p116f9b36vae3f24e652921de6@mail.gmail.com> <20071003114027.GA3828@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071003114027.GA3828@ff.dom.local>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jarek Poplawski <jarkao2@o2.pl> wrote:

> On Wed, Oct 03, 2007 at 12:55:34PM +0200, Dmitry Adamushko wrote:
> ...
> > just a quick patch, not tested and I've not evaluated all possible
> > implications yet.
> > But someone might give it a try with his/(her -- are even more
> > welcomed :-) favourite sched_yield() load.
> 
> Of course, after some evaluation by yourself and Ingo the most 
> interesting should be Martin's Michlmayr testing, so I hope you'll Cc 
> him too?!

My current take on this: queue the current task right to the next 
position in the tree (this is what this patch achieves in essence) was 
one of the yield implementations we already tried in CFS but it didnt 
meet the expectations of some apps. So i can only repeat my argument: 
this is not something that can be "solved" in the way you imagine and 
your arguments just reiterate the path that CFS has already taken in the 
past. So please do not expect _us_ to go out and pester people. If 
people feel so inclined, they are of course welcome to test out various 
approaches. (they might as well try the original yield-granularity patch 
which also makes the amount of "delay" tunable, so the ideal amount of 
delay can be figured out. And of course they should also try the 
existing yield flag.)

	Ingo
