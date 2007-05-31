Return-Path: <linux-kernel-owner+w=401wt.eu-S1755843AbXEaO4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbXEaO4p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 10:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbXEaO4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 10:56:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41408 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704AbXEaO4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 10:56:38 -0400
Date: Thu, 31 May 2007 16:55:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: john stultz <johnstul@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Sripathi Kodi <sripathik@in.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Subject: Re: [BUG] futex_unlock_pi() hurts my brain and may cause application deadlock
Message-ID: <20070531145555.GA24218@elte.hu>
References: <1180572567.6126.44.camel@localhost.localdomain> <20070531142455.GA11310@elte.hu> <1180623027.17878.2.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1180623027.17878.2.camel@localhost>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* john stultz <johnstul@us.ibm.com> wrote:

> > > --- a/kernel/futex.c
> > > +++ b/kernel/futex.c
> > > @@ -2011,6 +2011,7 @@ pi_faulted:
> > >  					 attempt);
> > >  		if (ret)
> > >  			goto out_unlock;
> > > +		uval = 0;
> > >  		goto retry_locked;
> > 
> > this looks good to me. Oleg has posted a few more fixes as well - 
> > have you tried those too?
> 
> Do you have a URL or subject line for the discussion? I'll take a look 
> and give them a whirl.

i meant to say Alexey, not Oleg :-) Here's the thread:

   http://lkml.org/lkml/2007/5/7/129

i've Cc:-ed Alexey too.

	Ingo
