Return-Path: <linux-kernel-owner+w=401wt.eu-S935210AbXHJLhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935210AbXHJLhe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 07:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762532AbXHJLhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 07:37:15 -0400
Received: from mx10.go2.pl ([193.17.41.74]:35899 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757782AbXHJLhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 07:37:13 -0400
Date: Fri, 10 Aug 2007 13:37:47 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Marcin =?iso-8859-2?Q?=A6lusarz?= <marcin.slusarz@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jean-Baptiste Vignaud <vignaud@xandmail.fr>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       shemminger <shemminger@linux-foundation.org>,
       linux-net <linux-net@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch (testing)] Re: 2.6.20->2.6.21 - networking dies after random time
Message-ID: <20070810113747.GB3757@ff.dom.local>
References: <20070807082321.GB2120@ff.dom.local> <4bacf17f0708070237w19d184b3p7f74b53612edb9a6@mail.gmail.com> <20070807095246.GB3223@ff.dom.local> <20070807121339.GA3946@ff.dom.local> <4bacf17f0708080409t116b5c84ye60dff7da51d0fdf@mail.gmail.com> <20070808114243.GC2426@ff.dom.local> <20070809091919.GB2423@ff.dom.local> <4bacf17f0708092333n17e0ba19jf2c769531610868d@mail.gmail.com> <20070810071038.GA1764@ff.dom.local> <4bacf17f0708100343r950cf90kbf826e2afc826df5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4bacf17f0708100343r950cf90kbf826e2afc826df5@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2007 at 12:43:43PM +0200, Marcin ¦lusarz wrote:
> 2007/8/10, Jarek Poplawski <jarkao2@o2.pl>:
> > (..)
> > I think, there is this one possible for your testing yet?:
> > Subject: [patch] genirq: temporary fix for level-triggered IRQ resend
> > Date: Wed, 8 Aug 2007 13:00:37 +0200
> I think I already tested this patch, but this thread is sooo big and I
> can't find my response...

I think it was very similar Ingo's patch, which after your testing
is in 2.6.23-rc2 now. I've moved return for level type irqs a little
later, and it works a new way only for "x86_64".

But, I think, now this patch is less important: if you find some time,
try mostly new Ingo's or Thomas' patches (latest possible versions).

> 
> > If it's not a great problem it would be interesting to try this with
> > different CONFIG_HZ too e.g. you could start with 100 (I guess, you
> > tested very similar thing in 2.6.23-rc2 with 1000(?) already).
> My all tests were done on 2.6.22.1

Fine! If it's not said otherwise this version should be appropriate for
most of these patches. But, please, send your current configs on next
posibility (dmesg, /proc/interrupts and .config).

Bye (till monday),
Jarek P.
