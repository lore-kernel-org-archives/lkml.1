Return-Path: <linux-kernel-owner+w=401wt.eu-S933332AbXCBLFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933332AbXCBLFc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 06:05:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933331AbXCBLFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 06:05:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52807 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933332AbXCBLFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 06:05:31 -0500
Date: Fri, 2 Mar 2007 11:57:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Pavel Machek <pavel@ucw.cz>,
       Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070302105713.GB15576@elte.hu>
References: <20070301095402.GA14603@elte.hu> <20070301131118.GA30228@elte.hu> <20070301133018.GB30177@2ka.mipt.ru> <200703011519.20001.dada1@cosmosbay.com> <20070301141637.GA20006@elte.hu> <20070301145454.GB12684@2ka.mipt.ru> <20070301150942.GA26025@elte.hu> <20070301153655.GB8217@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070301153655.GB8217@2ka.mipt.ru>
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


* Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:

> > > > [...] The numbers are still highly suspect - and we are already 
> > > > down from the prior claim of kevent being almost twice as fast 
> > > > to a 25% difference.
> > >
> > > Btw, there were never almost twice perfromance increase - epoll in 
> > > my tests always showed 4-5 thousands requests per second, kevent - 
> > > up to 7 thausands.
> > 
> > i'm referring to your claim in this mail of yours from 4 days ago 
> > for example:
> > 
> >   http://lkml.org/lkml/2007/2/25/116
> > 
> >  "But note, that on my athlon64 3500 test machine kevent is about 7900
> >   requests per second compared to 4000+ epoll, so expect a challenge."
> > 
> > no matter how i look at it, but 7900 is 1.9 times 4000 - which is 
> > "almost twice".
> 
> After your changes epoll increased to 5k.

Can we please stop this pointless episode of benchmarketing, where every 
mail of yours shows different results and you even deny having said 
something which you clearly said just a few days ago? At this point i 
simply cannot trust the numbers you are posting, nor is the discussion 
style you are following productive in any way in my opinion.

(you are never ever wrong, and if you are proven wrong on topic A you 
claim it is an irrelevant topic (without even admitting you were wrong 
about it) and you point to topic B claiming it's the /real/ topic you 
talked about all along. And along the way you are slandering other 
projects like epoll and threadlets, distorting the discussion. This kind 
of keep-the-ball-moving discussion style is effective in politics but 
IMO it's a waste of time when developing a kernel.)

	Ingo
