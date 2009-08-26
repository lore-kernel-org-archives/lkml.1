Return-Path: <linux-kernel-owner+w=401wt.eu-S1752627AbZHZSFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbZHZSFg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 14:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbZHZSFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 14:05:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36901 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513AbZHZSFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 14:05:34 -0400
Date: Wed, 26 Aug 2009 20:04:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, raz ben yehuda <raziebe@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Chris Friesen <cfriesen@nortel.com>, Mike Galbraith <efault@gmx.de>,
       riel@redhat.com, andrew motron <akpm@linux-foundation.org>,
       wiseman@macs.biu.ac.il, lkml <linux-kernel@vger.kernel.org>,
       linux-rt-users@vger.kernel.org
Subject: Re: RFC: THE OFFLINE SCHEDULER
Message-ID: <20090826180407.GA13632@elte.hu>
References: <4A943A00.9080609@nortel.com> <1251264700.7538.1178.camel@twins> <1251282598.3514.20.camel@raz> <alpine.DEB.1.10.0908260943090.9924@gentwo.org> <1251297910.1791.22.camel@maxim-laptop> <1251298443.4791.7.camel@raz> <1251300625.18584.18.camel@twins> <alpine.DEB.1.10.0908261136590.9933@gentwo.org> <1251302598.18584.31.camel@twins> <alpine.DEB.1.10.0908261211340.9933@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0908261211340.9933@gentwo.org>
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

> On Wed, 26 Aug 2009, Peter Zijlstra wrote:
> 
> > On Wed, 2009-08-26 at 11:41 -0400, Christoph Lameter wrote:
> > > On Wed, 26 Aug 2009, Peter Zijlstra wrote:
> > >
> > > > Why waste a whole cpu for something that could be done by part of one?
> > >
> > > Because of latency and performance requirements
> >
> > Latency is the only one, and yes people have been using hacks 
> > like this, I've also earlier mentioned RTAI, RTLinux and 
> > L4-Linux which basically do the same thing.
> >
> > The problem is, that its not linux, you cannot run something on 
> > a these off-cores and use the same functionality as linux, if 
> > you could it'd not be offline.
> 
> Right. We discussed this. Why are you repeating the same old 
> arguments?

The thing is, you have cut out (and have not replied to) this 
crutial bit of what Peter wrote:

> > The past year or so you've been whining about the tick latency, 
> > and I've seen exactly _0_ patches from you slimming down the 
> > work done in there, even though I pointed out some obvious 
> > things that could be done.

... which pretty much settles the issue as far as i'm concerned. If 
you were truly interested in a constructive solution to lower 
latencies in Linux you should have sent patches already for the low 
hanging fruits Peter pointed out.

	Ingo
