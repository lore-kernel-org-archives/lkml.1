Return-Path: <linux-kernel-owner+w=401wt.eu-S1757535AbXFOTtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbXFOTtA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 15:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752331AbXFOTsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 15:48:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39977 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbXFOTsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 15:48:52 -0400
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Daniel Hazelton <dhazelton@enter.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexandre Oliva <aoliva@redhat.com>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
In-Reply-To: <alpine.LFD.0.98.0706151118150.14121@woody.linux-foundation.org>
References: <466A3EC6.6030706@netone.net.tr>
	 <200706142144.15695.dhazelton@enter.net>
	 <1181895924.25228.319.camel@pmac.infradead.org>
	 <200706150458.29943.dhazelton@enter.net>
	 <1181899064.25228.342.camel@pmac.infradead.org>
	 <alpine.LFD.0.98.0706150846370.14121@woody.linux-foundation.org>
	 <1181930204.25228.590.camel@pmac.infradead.org>
	 <alpine.LFD.0.98.0706151118150.14121@woody.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 15 Jun 2007 20:49:15 +0100
Message-Id: <1181936955.5211.62.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-17.fc7.dwmw2.1) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-15 at 11:23 -0700, Linus Torvalds wrote:
> 
> On Fri, 15 Jun 2007, David Woodhouse wrote:
> > 
> > Actually, I don't see where it explicitly states that it only covers
> > derived work.
> 
> See "Section 0":
> 
> 	The "Program", below, refers to any such program or work, and a 
> 	"work based on the Program" means either the Program or any 
> 	derivative work under copyright law:
> 
> so yes, if you grepped for "derived work", you wouldn't have found it. The 
> exact wording used in the license is "derivative work under copyright 
> law".
> 
> So the very *definition* of the word "Program" is indeed limited by the 
> notion of "derived work" - as defined by copyright law, and NOT the GPLv2.

Yep. And §2 talks explicitly about independent and separate works when
they are distributed _with_ the Program, as part of a larger work based
on the Program.

> > The case which interests me most is when someone makes an embedded
> > device, for example a router -- and they  distribute a 'blob' of
> > firmware for it, containing both the kernel a binary-only network driver
> > module. Again we have to ask ourselves "is this a work based on the
> > kernel?". Obviously there isn't a 'right' answer outside a court of law,
> > but personally I reckon it's a fairly safe bet that it _is_ going to be
> > considered to be a work based on Linux.
> 
> Hey, I kind of disagree.
> 
> What is a DVD? It's just a "blob" of a UDF image, potentially containing 
> the Linux kernel.
> 
> How is that different from a "blob" of some other kind of image (say, a 
> cramfs or similar image) on a rom?
> 
> What makes UDF so different from cramfs? What makes a DVD so different 
> from a ROM chip? Why would copyright law care about one and not the other?

The differences are subtle, but they do exist. They're not really about
whether it's iso9660 or cramfs; it's about whether what you put on them
is a coherent work in its own right or just a bunch of bits which happen
to be thrown together onto the same medium.

And in the router case, there's little point to its existence without
the binary-only module. At least with the DVD it _can_ work without the
binary-only module. Although as I said, some distributors definitely
claim that the distribution is a 'coherent whole' too.

> So I really do _not_ think it's at all obvious. Personally, I think it's 
> exactly the same case. Others disagree, but I've never really seen a good 
> *reason* for them disagreeing.

It's a grey area, and nobody's 'right' until/unless a court decides. And
then only until/unless a higher court contradicts it. The reason I
jumped in was to point out that it isn't _just_ about whether the module
is a derived work or not. The GPL goes further than that.

-- 
dwmw2

