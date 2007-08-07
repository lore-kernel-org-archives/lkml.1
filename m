Return-Path: <linux-kernel-owner+w=401wt.eu-S1761512AbXHGJwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761512AbXHGJwa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 05:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757647AbXHGJwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 05:52:18 -0400
Received: from mx2.go2.pl ([193.17.41.42]:47975 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756677AbXHGJwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 05:52:17 -0400
Date: Tue, 7 Aug 2007 11:52:46 +0200
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
Message-ID: <20070807095246.GB3223@ff.dom.local>
References: <20070726083120.GA26910@elte.hu> <20070726085523.GA3423@ff.dom.local> <20070726091254.GA8063@elte.hu> <4bacf17f0707300029g5116e70bq4808059dc8b069f1@mail.gmail.com> <20070731132037.GC1046@ff.dom.local> <4bacf17f0708060000n5a00bb77i74adc3b4b28ac42b@mail.gmail.com> <20070806070300.GA4509@elte.hu> <4bacf17f0708070046o14403089v8376a4544f72fec3@mail.gmail.com> <20070807082321.GB2120@ff.dom.local> <4bacf17f0708070237w19d184b3p7f74b53612edb9a6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4bacf17f0708070237w19d184b3p7f74b53612edb9a6@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2007 at 11:37:01AM +0200, Marcin ¦lusarz wrote:
> 2007/8/7, Jarek Poplawski <jarkao2@o2.pl>:
> > On Tue, Aug 07, 2007 at 09:46:36AM +0200, Marcin ¦lusarz wrote:
> > > Network card still locks up (tested on 2.6.22.1). I had to upload more
> > > data than usual (~350 MB vs ~1-100 MB) to trigger that bug but it
> > > might be a coincidence...
> >
> > Thanks! It's a good news after all - it would be really strange why
> > this place doesn't hit more people (it seems there is some safety
> > elsewhere for this).
> >
> > BTW: I hope, this previous Thomas' patch with Ingo's warning to resend.c
> > (with a warning), had no problems with a similar load?
> I always tested on 500-600 MB "dataset"
> 
> > PS: Marcin, if you need a break in this testing let us know!
> No, i don't need a break. I'll have more time in next weeks.

Great! So, I'll try to send a patch with _SW_RESEND in a few hours,
if Ingo doesn't prepare something for you.

Thanks,
Jarek P.
