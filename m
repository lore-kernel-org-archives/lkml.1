Return-Path: <linux-kernel-owner+w=401wt.eu-S1756248AbZDPHo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248AbZDPHo7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 03:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbZDPHou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 03:44:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57981 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753099AbZDPHot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 03:44:49 -0400
Date: Thu, 16 Apr 2009 09:44:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, hpa@zytor.com, tglx@linutronix.de,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, davej@redhat.com
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
Message-ID: <20090416074406.GA4507@elte.hu>
References: <alpine.LFD.2.00.0904151013260.4132@localhost.localdomain> <49E62BD5.6090508@zytor.com> <alpine.LFD.2.00.0904151241490.4132@localhost.localdomain> <20090415.142326.97287514.davem@davemloft.net> <20090415224800.GA22425@elte.hu> <alpine.LFD.2.00.0904151608470.4042@localhost.localdomain> <20090416004430.GA22616@elte.hu> <alpine.LFD.2.00.0904151757100.4042@localhost.localdomain> <20090416014642.GA24029@elte.hu> <20090416035524.GJ21586@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090416035524.GJ21586@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Theodore Tso <tytso@mit.edu> wrote:

> On Thu, Apr 16, 2009 at 03:46:42AM +0200, Ingo Molnar wrote:
> > 
> > For similar reasons people have memos, stick-it's and other formal, 
> > automated, reflex-alike daily routine measures to make sure they 
> > dont forget to do something they all too easily forget otherwise.
> ...
> > This kind of formal measure _forces_ the extraction of this very 
> > specific type of summary on all sides of the contribution chain - 
> > and it drastically reduced the number of commits i regretted in 
> > hindsight.
> 
> The question is whether Impact: _works_ in its current form. [...]

For us, it clearly works in most cases. Does it work in _every_ 
case? No. No maintenance measure ever works in every case.

> [...]  I was came across a recent set of commits sent to you where 
> it was pathetically obvious that Impact: doesn't really help.

The thing is - none of the examples you quoted below are commits in 
any of our trees! They are email submissions to lkml, not applied 
yet anywhere. And yes, from the impact line alone it becomes clear 
that the commit log needs serious editing.

And yes, in fact it became _easier_ to me to process patches from 
that particular patch submitter you blacked out, since he started 
using impact-lines a few months ago. These bad impact lines you 
quoted are of course not usable directly in a commit log - but they 
are canaries. Plus the ones where i for example get "Impact: 
cleanup" patches from him are certainly useful.

So even this worst-case example you could possibly can come up with 
is in reality actually a success story to us!

Impact tags allow frequent contributors to pre-tag changes with a 
"this I expected to be an easy one" easily recognizable attribute. 
It is very helpful, _especially_ where there's a language barrier.

Here's an easy challenge: try inserting perfect impact lines for a 
few days into all your commits, really! :-) [ You can erase them 
after you've created them, and you dont have to admit it ever that 
you did this experiment ;-) ]

I noticed that even the best commits win a new dimension of quality 
and awareness as far as the maintainer is concerned. It also helps 
us keep our eyes on the ball all the time: constantly assessing the 
true utility and true risk of our patches.

It's truly useful, and unless you try it seriously and come back to 
us with a "I tried it, all my impact lines were perfect but it didnt 
give me any plus so i stopped doing it" i dont think you can ever 
know what you missed out on.

	Ingo
