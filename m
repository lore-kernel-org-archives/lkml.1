Return-Path: <linux-kernel-owner+w=401wt.eu-S1759157AbXHCJAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759157AbXHCJAu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 05:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755996AbXHCJAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 05:00:37 -0400
Received: from mx10.go2.pl ([193.17.41.74]:46483 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755938AbXHCJAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 05:00:35 -0400
Date: Fri, 3 Aug 2007 11:10:08 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Gabriel C <nix.or.die@googlemail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jean-Baptiste Vignaud <vignaud@xandmail.fr>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       shemminger <shemminger@linux-foundation.org>,
       linux-net <linux-net@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, marcin.slusarz@gmail.com
Subject: Re: [patch] genirq: fix simple and fasteoi irq handlers
Message-ID: <20070803091008.GC1582@ff.dom.local>
References: <1185437431.3227.21.camel@chaos> <20070726083120.GA26910@elte.hu> <20070726085523.GA3423@ff.dom.local> <20070726091254.GA8063@elte.hu> <4bacf17f0707300029g5116e70bq4808059dc8b069f1@mail.gmail.com> <20070731155843.GA7033@elte.hu> <46B20E47.6020403@googlemail.com> <20070802201126.GA27000@elte.hu> <20070803060733.GA1582@ff.dom.local> <20070803080408.GA12222@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070803080408.GA12222@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2007 at 10:04:08AM +0200, Ingo Molnar wrote:
> 
> * Jarek Poplawski <jarkao2@o2.pl> wrote:
> 
> > I can't guarantee this is all needed to fix this bug, but I think this 
> > patch is necessary here.
> 
> hmmm ... very interesting! Now _this_ is something we'd like to see 
> tested. Could you send a patch to Marcin that also undoes the workaround 
> we have in place now, so that he could check whether ne2k-pci works fine 
> with your fix alone?

I'm not sure this is needed... Marcin got this patch, I hope, and I
don't have another possibility to contact with him. Since he managed
with this bisection and all the previous patches I don't think there
could be any problems, so:

Marcin! I'd be very glad if you could test this patch alone; this
should apply without any problems to 2.6.21 (with some offset) and
later "vanilla" versions (or try to revert Ingo's last patch with
patch -p1 -R). Please, contact me on any problems (alas not during
the weekend...).

Thanks,
Jarek P.

PS: of course, I'm very curious of this testing too, but, on the other
hand, as I've written earlier, I think this patch is needed for logical
reasons only, and it really doesn't look like it could make any damage
here.
