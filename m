Return-Path: <linux-kernel-owner+w=401wt.eu-S1765025AbXHJJC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765025AbXHJJC4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 05:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756794AbXHJJCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 05:02:44 -0400
Received: from mx2.go2.pl ([193.17.41.42]:60096 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757051AbXHJJCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 05:02:42 -0400
Date: Fri, 10 Aug 2007 11:03:18 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jean-Baptiste Vignaud <vignaud@xandmail.fr>,
       "marcin\.slusarz" <marcin.slusarz@gmail.com>, tglx <tglx@linutronix.de>,
       torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       shemminger <shemminger@linux-foundation.org>,
       linux-net <linux-net@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch (testing)] Re: 2.6.20->2.6.21 - networking dies after random time
Message-ID: <20070810090318.GG1764@ff.dom.local>
References: <JMJTMH$F1699B57C9B0E170ED337488612E649B@xandmail.com> <20070810083720.GE1764@ff.dom.local> <20070810084841.GA11086@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070810084841.GA11086@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2007 at 10:48:41AM +0200, Ingo Molnar wrote:
> 
> * Jarek Poplawski <jarkao2@o2.pl> wrote:
> 
> > On Fri, Aug 10, 2007 at 10:15:53AM +0200, Jean-Baptiste Vignaud wrote:
> > ...
> > > I was still testing on -rc2:
> > > Subject: [patch] genirq: temporary fix for level-triggered IRQ resend
> > > Date: Wed, 8 Aug 2007 13:00:37 +0200
> > > 
> > > For me after 1day 20hours, the network is still up, with more than 
> > > 1To of network traffic. HZ was 1000, i restart with HZ=100.
> > 
> > For me it's enough too but Thomas seems to doubt.
> 
> seem to doubt what? That rc2 fixes the symptom? That is a sure thing, 
> and we never doubted that. I think you might have misunderstood what 
> Thomas said and meant, so please just state your opinion unambiguously 
> so that we can fix any mis-communication :)
> 
> 	Ingo
> 


On 25-07-2007 02:19, Thomas Gleixner wrote:
...
> Actually we only need the resend for edge type interrupts. Level type
> interrupts come back once enable_irq() re-enables the interrupt line.
>

On 10-08-2007 10:05, Thomas Gleixner wrote:
...
> But suppressing the resend is not fixing the driver problem. The problem
> can show up with spurious interrupts and with interrupts on a shared PCI
> interrupt line at any time. It just might take weeks instead of minutes.

Maybe I miss something but it's not the same!

So, should Jean-Baptiste or Marcin test this for weeks or it's enough?

Jarek P.
