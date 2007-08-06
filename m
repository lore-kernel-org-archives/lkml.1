Return-Path: <linux-kernel-owner+w=401wt.eu-S1765371AbXHFNQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765371AbXHFNQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 09:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764114AbXHFNQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 09:16:21 -0400
Received: from mail.screens.ru ([213.234.233.54]:38827 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764089AbXHFNQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 09:16:20 -0400
Date: Mon, 6 Aug 2007 17:18:14 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Gregory Haskins <ghaskins@novell.com>, Daniel Walker <dwalker@mvista.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RT: Add priority-queuing and priority-inheritance to workqueue infrastructure
Message-ID: <20070806131814.GC91@tv-sign.ru>
References: <20070801201802.GA225@tv-sign.ru> <1186000468.2636.168.camel@imap.mvista.com> <20070801205053.GA263@tv-sign.ru> <1186002783.9513.228.camel@ghaskins-t60p.haskins.net> <20070801213422.GA280@tv-sign.ru> <1186005598.9513.261.camel@ghaskins-t60p.haskins.net> <20070801222201.GA316@tv-sign.ru> <1186012439.9513.321.camel@ghaskins-t60p.haskins.net> <20070802195049.GA361@tv-sign.ru> <20070806114954.GC1903@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070806114954.GC1903@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory, Ingo,

On 08/06, Ingo Molnar wrote:
> 
> * Oleg Nesterov <oleg@tv-sign.ru> wrote:
> 
> > On 08/01, Gregory Haskins wrote:
> > >
> > > On Thu, 2007-08-02 at 02:22 +0400, Oleg Nesterov wrote:
> > > 
> > > > No,
> > > 
> > > You sure are a confident one ;)
> > 
> > Yeah, this is a rare case when I am very sure I am right ;)
> > 
> > I strongly believe you guys take a _completely_ wrong approach. 
> > queue_work() should _not_ take the priority of the caller into 
> > account, this is bogus.
> 
> Oleg, i'd like to make it sure that the role of Gregory Haskins is clear 
> here: he submitted some new infrastructure into the -rt tree, and i 
> reviewed that but found it quite complex and duplicative and suggested 
> him to think about enhancing workqueues with priority properties - which 
> might or might not make sense.
> 
> It is not the intention of the -rt project to pester any upstream 
> maintainer with -rt issues if that upstream maintainer is not interested 
> in it ... so please just forget about all this if you are not interested 
> in it, we'll sort it out within -rt. Thanks,

I am not trying to sabotage these changes, and I am sorry if it looked
that way.

I jumped into this discuassion because both patches I saw (Daniel's and
Gregory's) were very wrong technically.

Yes, I still disagree with the whole idea because I hope we can make
something more simpler to solve the problem, but I must admit I don't
quite understand what the problem is.

So, please consider a noise from my side as my attempt to help. And
in fact, I am very curious about -rt tree, just I never had a time
to study it :)

Oleg.

