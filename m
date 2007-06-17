Return-Path: <linux-kernel-owner+w=401wt.eu-S1756742AbXFQQ7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742AbXFQQ7a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 12:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754121AbXFQQ7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 12:59:22 -0400
Received: from www.osadl.org ([213.239.205.134]:45820 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754094AbXFQQ7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 12:59:21 -0400
Subject: Re: v2.6.21.4-rt11
From: Thomas Gleixner <tglx@linutronix.de>
To: Nelson Castillo <nelsoneci@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
In-Reply-To: <2accc2ff0706170949j26c391aek7ed32e0e55d9a3d1@mail.gmail.com>
References: <20070609210507.GA29194@elte.hu>
	 <2accc2ff0706170915h7cc0ce97ofc16bc33f1714567@mail.gmail.com>
	 <1182098605.8176.422.camel@chaos>
	 <2accc2ff0706170949j26c391aek7ed32e0e55d9a3d1@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 17 Jun 2007 18:59:18 +0200
Message-Id: <1182099558.8176.436.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-06-17 at 11:49 -0500, Nelson Castillo wrote:
> > > There are many choices and
> > > I don't know what is the more friendly. By friendly I mean the one that
> > > is likely to be merged and that cooperate with you.
> >
> > Which choices do you mean ?
> 
> I mean implementations. I've seen lot of them but i don't know which one
> to try (I'm new to RT and the implementation in this thread seems to
> be very nice).

Thanks :)

> > >   http://people.redhat.com/mingo/realtime-preempt/patch-2.6.21.4-rt14
> > >
> > > : undefined reference to `usecs_to_cycles'
> > > make: *** [.tmp_vmlinux1] Error 1
> >
> > Which ARM sub arch ?
> 
> sub arch AT91 -- (Atmel AT91RM9200 processor).

It lacks support for the generic timeofday and clock event layers, which
causes the compile breakage.

I take a look at the compile errors and ping somebody who is working on
support for AT91 to send out the patches ASAP.

	tglx


