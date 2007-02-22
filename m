Return-Path: <linux-kernel-owner+w=401wt.eu-S933026AbXBVLZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933026AbXBVLZt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 06:25:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933027AbXBVLZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 06:25:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54251 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933026AbXBVLZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 06:25:48 -0500
Date: Thu, 22 Feb 2007 12:20:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Suparna Bhattacharya <suparna@in.ibm.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070222112039.GA13611@elte.hu>
References: <20070221211355.GA7302@elte.hu> <20070222100126.GA24643@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070222100126.GA24643@in.ibm.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -5.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-5.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Suparna Bhattacharya <suparna@in.ibm.com> wrote:

> > Threadlets share much of the scheduling infrastructure with syslets.
> > 
> > Syslets (small, kernel-side, scripted "syscall plugins") are still 
> > supported - they are (much...) harder to program than threadlets but 
> > they allow the highest performance. Core infrastructure libraries 
> > like glibc/libaio are expected to use syslets. Jens Axboe's FIO tool 
> > already includes support for v2 syslets, and the following patch 
> > updates FIO to
> 
> Ah, glad to see that - I was wondering if it was worthwhile to try 
> adding syslet support to aio-stress to be able to perform some 
> comparisons. [...]

i think it would definitely be worth it.

> [...] Hopefully FIO should be able to generate a similar workload, but 
> I haven't tried it yet so am not sure. Are you planning to upload some 
> results (so I can compare it with patterns I am familiar with) ?

i had no time yet to do careful benchmarks. Right now my impression from 
quick testing is that libaio performance can be exceeded via syslets. So 
it would be very interesting if you could try this too, independently of 
me.

	Ingo
