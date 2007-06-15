Return-Path: <linux-kernel-owner+w=401wt.eu-S1756762AbXFOSY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbXFOSY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 14:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbXFOSYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 14:24:20 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47917 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752012AbXFOSYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 14:24:19 -0400
Date: Fri, 15 Jun 2007 11:23:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>
cc: Daniel Hazelton <dhazelton@enter.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexandre Oliva <aoliva@redhat.com>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <1181930204.25228.590.camel@pmac.infradead.org>
Message-ID: <alpine.LFD.0.98.0706151118150.14121@woody.linux-foundation.org>
References: <466A3EC6.6030706@netone.net.tr>  <200706142144.15695.dhazelton@enter.net>
  <1181895924.25228.319.camel@pmac.infradead.org>  <200706150458.29943.dhazelton@enter.net>
  <1181899064.25228.342.camel@pmac.infradead.org> 
 <alpine.LFD.0.98.0706150846370.14121@woody.linux-foundation.org>
 <1181930204.25228.590.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 15 Jun 2007, David Woodhouse wrote:
> 
> Actually, I don't see where it explicitly states that it only covers
> derived work.

See "Section 0":

	The "Program", below, refers to any such program or work, and a 
	"work based on the Program" means either the Program or any 
	derivative work under copyright law:

so yes, if you grepped for "derived work", you wouldn't have found it. The 
exact wording used in the license is "derivative work under copyright 
law".

So the very *definition* of the word "Program" is indeed limited by the 
notion of "derived work" - as defined by copyright law, and NOT the GPLv2.

> The case which interests me most is when someone makes an embedded
> device, for example a router -- and they  distribute a 'blob' of
> firmware for it, containing both the kernel a binary-only network driver
> module. Again we have to ask ourselves "is this a work based on the
> kernel?". Obviously there isn't a 'right' answer outside a court of law,
> but personally I reckon it's a fairly safe bet that it _is_ going to be
> considered to be a work based on Linux.

Hey, I kind of disagree.

What is a DVD? It's just a "blob" of a UDF image, potentially containing 
the Linux kernel.

How is that different from a "blob" of some other kind of image (say, a 
cramfs or similar image) on a rom?

What makes UDF so different from cramfs? What makes a DVD so different 
from a ROM chip? Why would copyright law care about one and not the other?

So I really do _not_ think it's at all obvious. Personally, I think it's 
exactly the same case. Others disagree, but I've never really seen a good 
*reason* for them disagreeing.

		Linus
