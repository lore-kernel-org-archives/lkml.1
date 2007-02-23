Return-Path: <linux-kernel-owner+w=401wt.eu-S932193AbXBWKah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193AbXBWKah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 05:30:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932197AbXBWKah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 05:30:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57391 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932193AbXBWKag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 05:30:36 -0500
Date: Fri, 23 Feb 2007 11:22:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Michael K. Edwards" <medwards.linux@gmail.com>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070223102253.GA22870@elte.hu>
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com> <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com> <20070222074044.GA4158@elte.hu> <20070222113148.GA3781@2ka.mipt.ru> <20070222125931.GB25788@elte.hu> <f2b55d220702221324n788506b6oee4f8ed4f168fbf1@mail.gmail.com> <20070223003018.0d244576@lxorguk.ukuu.org.uk> <f2b55d220702221847p6b28f6eehed1bb5b1b0edf9f4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2b55d220702221847p6b28f6eehed1bb5b1b0edf9f4@mail.gmail.com>
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

> On 2/22/07, Alan <alan@lxorguk.ukuu.org.uk> wrote:

> > We don't use the FPU in the kernel except in very weird cases where 
> > it makes an enormous performance difference. The threadlets also 
> > have the same page tables so they have the same %cr3 so its very 
> > cheap to switch, basically a predicted jump and some register loads
> 
> Do you not understand that real user code touches FPU state at 
> unpredictable (to the kernel) junctures?  Maybe not in a database or a 
> web server, but in the GUIs and web-based monitoring applications that 
> are 99% of the potential customers for kernel AIO?
> I have no idea what a %cr3 is, [...]

then please stop wasting Alan's time ...

	Ingo
