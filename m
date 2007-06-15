Return-Path: <linux-kernel-owner+w=401wt.eu-S1754434AbXFOVXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434AbXFOVXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 17:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752370AbXFOVXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 17:23:44 -0400
Received: from keil-draco.com ([216.193.185.50]:50510 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbXFOVXm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 17:23:42 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Fri, 15 Jun 2007 17:23:28 -0400
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexandre Oliva <aoliva@redhat.com>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
References: <466A3EC6.6030706@netone.net.tr> <alpine.LFD.0.98.0706151118150.14121@woody.linux-foundation.org> <1181936955.5211.62.camel@shinybook.infradead.org>
In-Reply-To: <1181936955.5211.62.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706151723.28439.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 June 2007 15:49:15 David Woodhouse wrote:
> On Fri, 2007-06-15 at 11:23 -0700, Linus Torvalds wrote:
> > On Fri, 15 Jun 2007, David Woodhouse wrote:
> > > Actually, I don't see where it explicitly states that it only covers
> > > derived work.
> >
> > See "Section 0":
> >
> > 	The "Program", below, refers to any such program or work, and a
> > 	"work based on the Program" means either the Program or any
> > 	derivative work under copyright law:
> >
> > so yes, if you grepped for "derived work", you wouldn't have found it.
> > The exact wording used in the license is "derivative work under copyright
> > law".
> >
> > So the very *definition* of the word "Program" is indeed limited by the
> > notion of "derived work" - as defined by copyright law, and NOT the
> > GPLv2.
>
> Yep. And §2 talks explicitly about independent and separate works when
> they are distributed _with_ the Program, as part of a larger work based
> on the Program.

>From section 0 of the GPLv2:
The "Program", below, refers to any such program or work, and a "work based on 
the Program" means either the Program or any derivative work under copyright 
law: that is to say, a work containing the Program or a portion of it, either 
verbatim or with modifications and/or translated into another language.  
(Hereinafter, translation is included without limitation in the 
term "modification".)

In other words, the "that is to say, a work containing the Program or a 
portion of it, either verbatim or with modifications and/or translated into 
another language." is a clarification of the terms so that you do *NOT* have 
to know copyright law. However, the license, being based in copyright law, 
*CANNOT* change that law without making itself invalid. QED: What copyright 
law says is a "derivative work" is what matters, not the definition provided 
in the license.

DRH

> > > The case which interests me most is when someone makes an embedded
> > > device, for example a router -- and they  distribute a 'blob' of
> > > firmware for it, containing both the kernel a binary-only network
> > > driver module. Again we have to ask ourselves "is this a work based on
> > > the kernel?". Obviously there isn't a 'right' answer outside a court of
> > > law, but personally I reckon it's a fairly safe bet that it _is_ going
> > > to be considered to be a work based on Linux.
> >
> > Hey, I kind of disagree.
> >
> > What is a DVD? It's just a "blob" of a UDF image, potentially containing
> > the Linux kernel.
> >
> > How is that different from a "blob" of some other kind of image (say, a
> > cramfs or similar image) on a rom?
> >
> > What makes UDF so different from cramfs? What makes a DVD so different
> > from a ROM chip? Why would copyright law care about one and not the
> > other?
>
> The differences are subtle, but they do exist. They're not really about
> whether it's iso9660 or cramfs; it's about whether what you put on them
> is a coherent work in its own right or just a bunch of bits which happen
> to be thrown together onto the same medium.
>
> And in the router case, there's little point to its existence without
> the binary-only module. At least with the DVD it _can_ work without the
> binary-only module. Although as I said, some distributors definitely
> claim that the distribution is a 'coherent whole' too.
>
> > So I really do _not_ think it's at all obvious. Personally, I think it's
> > exactly the same case. Others disagree, but I've never really seen a good
> > *reason* for them disagreeing.
>
> It's a grey area, and nobody's 'right' until/unless a court decides. And
> then only until/unless a higher court contradicts it. The reason I
> jumped in was to point out that it isn't _just_ about whether the module
> is a derived work or not. The GPL goes further than that.



-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
