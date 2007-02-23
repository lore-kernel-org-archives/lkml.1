Return-Path: <linux-kernel-owner+w=401wt.eu-S932297AbXBWM0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297AbXBWM0s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 07:26:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932301AbXBWM0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 07:26:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52432 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932297AbXBWM0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 07:26:47 -0500
Date: Fri, 23 Feb 2007 13:17:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Michael K. Edwards" <medwards.linux@gmail.com>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070223121751.GA6626@elte.hu>
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com> <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com> <20070222074044.GA4158@elte.hu> <20070222113148.GA3781@2ka.mipt.ru> <20070222125931.GB25788@elte.hu> <f2b55d220702221324n788506b6oee4f8ed4f168fbf1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2b55d220702221324n788506b6oee4f8ed4f168fbf1@mail.gmail.com>
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


* Michael K. Edwards <medwards.linux@gmail.com> wrote:

> On 2/22/07, Ingo Molnar <mingo@elte.hu> wrote:

> > maybe it will, maybe it wont. Lets try? There is no true difference 
> > between having a 'request structure' that represents the current 
> > state of the HTTP connection plus a statemachine that moves that 
> > request between various queues, and a 'kernel stack' that goes in 
> > and out of runnable state and carries its processing state in its 
> > stack - other than the amount of RAM they take. (the kernel stack is 
> > 4K at a minimum - so with a million outstanding requests they would 
> > use up 4 GB of RAM. With 20k outstanding requests it's 80 MB of RAM 
> > - that's acceptable.)
> 
> This is a fundamental misconception. [...]

> The scheduler, on the other hand, has to blow and reload all of the 
> hidden state associated with force-loading the PC and wherever your 
> architecture keeps its TLS (maybe not the whole TLB, but not nothing, 
> either). [...]

please read up a bit more about how the Linux scheduler works. Maybe 
even read the code if in doubt? In any case, please direct kernel newbie 
questions to http://kernelnewbies.org/, not linux-kernel@vger.kernel.org.

	Ingo
