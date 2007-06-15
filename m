Return-Path: <linux-kernel-owner+w=401wt.eu-S1754069AbXFOR5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbXFOR5T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 13:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbXFOR5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 13:57:08 -0400
Received: from canuck.infradead.org ([209.217.80.40]:59484 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbXFOR5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 13:57:07 -0400
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Daniel Hazelton <dhazelton@enter.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexandre Oliva <aoliva@redhat.com>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
In-Reply-To: <alpine.LFD.0.98.0706150846370.14121@woody.linux-foundation.org>
References: <466A3EC6.6030706@netone.net.tr>
	 <200706142144.15695.dhazelton@enter.net>
	 <1181895924.25228.319.camel@pmac.infradead.org>
	 <200706150458.29943.dhazelton@enter.net>
	 <1181899064.25228.342.camel@pmac.infradead.org>
	 <alpine.LFD.0.98.0706150846370.14121@woody.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 15 Jun 2007 18:56:44 +0100
Message-Id: <1181930204.25228.590.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-17.fc7.dwmw2.1) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-15 at 08:58 -0700, Linus Torvalds wrote:
> The GPLv2 explicitly mentions "mere aggregation". Strictly speaking, it 
> doesn't even *have* to mention it, since it does mention in other places 
> that it only covers "derived work", and "derivation" has nothing to do 
> with "distributing two things together". But it's a good clarification.

Actually, I don't see where it explicitly states that it only covers
derived work.

On the other hand, I _do_ see where it explicitly states that in some
cases it _does_ 'infect' non-derived works. That's §2, which goes along
the lines of ... 'sections...not derived from Program' ...
'License...does...not apply...when...distribute...as separate works'.
'But..same sections as part of whole... License...extend...to each and
every part regardless of who wrote it'.

As you say, it goes on to _clarify_ that 'mere aggregation on a volume
of a storage or distribution medium' isn't what it's talking about here.

But there is _some_ class of collective work which combines entirely
non-derived work with the original GPL'd Program, and for which the GPL
requires that you release your non-derived code under the terms of the
GPL. You could argue till the cows come home about precisely what falls
into that category and what doesn't.

> So you guys are *both* right, for different cases!
> 
> The issue is simply what you mean by "part of the whole"? If you mean 
> "part of the whole kernel distribution", then yes, the kernel is one work, 
> and it is, in its entirety, under the GPLv2. But if the "part of the 
> whole" is about something like a DVD with the whole being a collection of 
> "mere aggregation", the licenses do not necessarily meld together.

Yep, those are two extremes which fall either side of the grey area and
are relatively easy to agree on... perhaps.

> Let's say that you're a Linux vendor, and you distribute a DVD with both 
> the Linux kernel binary (and all the normal modules that go with it, that 
> obviously are "part of the whole kernel") *and* say the NVidia proprietary 
> kernel module. 

A DVD with a Linux distribution isn't _quite_ the same as an arbitrary
bunch of gratis software which happens to be thrown together on a disc.
A _lot_ of work goes into making that a coherent product where
everything interoperates sanely, rather than just such an arbitrary sack
of bits.

There is at least one prominent North American Linux Vendor who has been
observed to claim that the distribution _is_ a collective work and
copyrightable in its own right -- which would mean that it _is_ a work
based on the Program, and thus that including binary-only modules in it
is not permitted. And there are other distributors who've stopped
including binary-only modules under threat of legal action (not that
_that_ necessarily means anything -- anyone can make baseless threats).

> And is the NVidia module a "derived work" or not? That's a gray area, and 
> that's really what it hinges on. I personally think it's not, but I know 
> others think it is.

If the DVD of the distribution is considered to be a work in itself; a
'work based on the Program', then it doesn't actually matter whether the
nVidia module is a derived work or not. Unless you're willing to
disregard those two paragraphs of §2 entirely?

The case which interests me most is when someone makes an embedded
device, for example a router -- and they  distribute a 'blob' of
firmware for it, containing both the kernel a binary-only network driver
module. Again we have to ask ourselves "is this a work based on the
kernel?". Obviously there isn't a 'right' answer outside a court of law,
but personally I reckon it's a fairly safe bet that it _is_ going to be
considered to be a work based on Linux. Especially as the thing would be
totally useless if you took away either part. They're both fundamental
to its operation.

> Which is why I think you're both *potentially* right. Which one of you
> is *actually* right will depend on the exact circumstances ;)

True.

-- 
dwmw2

