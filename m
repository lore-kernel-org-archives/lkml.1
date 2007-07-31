Return-Path: <linux-kernel-owner+w=401wt.eu-S1763391AbXGaNOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763391AbXGaNOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 09:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759730AbXGaNLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 09:11:15 -0400
Received: from mx12.go2.pl ([193.17.41.142]:54702 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760391AbXGaNLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 09:11:12 -0400
Date: Tue, 31 Jul 2007 15:20:38 +0200
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
Subject: Re: 2.6.20->2.6.21 - networking dies after random time
Message-ID: <20070731132037.GC1046@ff.dom.local>
References: <alpine.LFD.0.999.0707241228291.3607@woody.linux-foundation.org> <20070724200431.GA22190@elte.hu> <1185322771.4175.102.camel@chaos> <4bacf17f0707260016x14fc1c92s628ae64353663833@mail.gmail.com> <20070726081326.GA3197@ff.dom.local> <1185437431.3227.21.camel@chaos> <20070726083120.GA26910@elte.hu> <20070726085523.GA3423@ff.dom.local> <20070726091254.GA8063@elte.hu> <4bacf17f0707300029g5116e70bq4808059dc8b069f1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4bacf17f0707300029g5116e70bq4808059dc8b069f1@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2007 at 09:29:38AM +0200, Marcin ¦lusarz wrote:
...
> ps: I retested all patches posted in this thread on top of 2.6.22.1
> and behavior from 2.6.21.3 didn't changed. My next tests will be on
> 2.6.22.x only.

Marcin,

I see you're quite busy, but if after testing this next Ingo's patch
you are alive yet, maybe you could try one more "idea"? No patch this
time, but if you could try this after adding boot option "noirqdebug"
(I'd like to be sure it's not about timinig after all).

Cheers & thanks,
Jarek P.
