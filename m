Return-Path: <linux-kernel-owner+w=401wt.eu-S1752021AbZHZTdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbZHZTdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 15:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbZHZTdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 15:33:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44492 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbZHZTdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 15:33:36 -0400
Date: Wed, 26 Aug 2009 21:32:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, raz ben yehuda <raziebe@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Chris Friesen <cfriesen@nortel.com>, Mike Galbraith <efault@gmx.de>,
       riel@redhat.com, andrew motron <akpm@linux-foundation.org>,
       wiseman@macs.biu.ac.il, lkml <linux-kernel@vger.kernel.org>,
       linux-rt-users@vger.kernel.org
Subject: Re: RFC: THE OFFLINE SCHEDULER
Message-ID: <20090826193252.GA14721@elte.hu>
References: <1251282598.3514.20.camel@raz> <alpine.DEB.1.10.0908260943090.9924@gentwo.org> <1251297910.1791.22.camel@maxim-laptop> <1251298443.4791.7.camel@raz> <1251300625.18584.18.camel@twins> <alpine.DEB.1.10.0908261136590.9933@gentwo.org> <1251302598.18584.31.camel@twins> <alpine.DEB.1.10.0908261211340.9933@gentwo.org> <20090826180407.GA13632@elte.hu> <alpine.DEB.1.10.0908261509580.9933@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0908261509580.9933@gentwo.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <cl@linux-foundation.org> wrote:

> On Wed, 26 Aug 2009, Ingo Molnar wrote:
> 
> > The thing is, you have cut out (and have not replied to) this
> > crutial bit of what Peter wrote:
> >
> > > > The past year or so you've been whining about the tick latency,
> > > > and I've seen exactly _0_ patches from you slimming down the
> > > > work done in there, even though I pointed out some obvious
> > > > things that could be done.
> >
> > ... which pretty much settles the issue as far as i'm concerned. 
> > If you were truly interested in a constructive solution to lower 
> > latencies in Linux you should have sent patches already for the 
> > low hanging fruits Peter pointed out.
> 
> The noise latencies were already reduced in years earlier to the 
> mininum (f.e. the work on slab queue cleaning). Certainly more 
> could be done there but that misses the point.

Peter suggested various improvements to the timer tick related 
latencies _you_ were complaining about earlier this year. Those 
latencies sure were not addressed 'years earlier'.

If you are unwilling to reduce the very latencies you apparently 
cared and complained about then you dont have much real standing to 
complain now.

( If you on the other hand were approaching this issue with 
  pragmatism and with intellectual honesty, if you were at the end 
  of a string of patches that gradually improved latencies but 
  couldnt get them below a certain threshold, and if scheduler 
  developers couldnt give you any ideas what else to improve, and 
  _then_ suggested some other solution, you might have a point.
  You are far away from being able to claim that. )

Really, it's a straightforward application of Occam's Razor to the 
scheduler. We go for the simplest solution first, and try to help 
more people first, before going for some specialist hack.

> The point of the OFFLINE scheduler is to completely eliminate the 
> OS disturbances by getting rid of *all* OS processing on some 
> cpus.
> 
> For some reason scheduler developers seem to be threatened by this 
> idea and they go into bizarre lines of arguments to avoid the 
> issue. Its simple and doable and the scheduler will still be there 
> after we do this.

If you meant to include me in that summary categorization, i dont 
feel 'threatened' by any such patches (why would i? They dont seem 
to have sharp teeth nor any apparent poison fangs) - i simply concur 
with the reasons Peter listed that it is a technically inferior 
solution.

	Ingo
