Return-Path: <linux-kernel-owner+w=401wt.eu-S1758776AbXFOUfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776AbXFOUfO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 16:35:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756679AbXFOUe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 16:34:58 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60769 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757442AbXFOUe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 16:34:57 -0400
Date: Fri, 15 Jun 2007 13:34:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>
cc: Daniel Hazelton <dhazelton@enter.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexandre Oliva <aoliva@redhat.com>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <1181936955.5211.62.camel@shinybook.infradead.org>
Message-ID: <alpine.LFD.0.98.0706151322070.14121@woody.linux-foundation.org>
References: <466A3EC6.6030706@netone.net.tr>  <200706142144.15695.dhazelton@enter.net>
  <1181895924.25228.319.camel@pmac.infradead.org>  <200706150458.29943.dhazelton@enter.net>
  <1181899064.25228.342.camel@pmac.infradead.org> 
 <alpine.LFD.0.98.0706150846370.14121@woody.linux-foundation.org> 
 <1181930204.25228.590.camel@pmac.infradead.org> 
 <alpine.LFD.0.98.0706151118150.14121@woody.linux-foundation.org>
 <1181936955.5211.62.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 15 Jun 2007, David Woodhouse wrote:
> > 
> > What is a DVD? It's just a "blob" of a UDF image, potentially containing 
> > the Linux kernel.
> > 
> > How is that different from a "blob" of some other kind of image (say, a 
> > cramfs or similar image) on a rom?
> > 
> > What makes UDF so different from cramfs? What makes a DVD so different 
> > from a ROM chip? Why would copyright law care about one and not the other?
> 
> The differences are subtle, but they do exist. They're not really about
> whether it's iso9660 or cramfs; it's about whether what you put on them
> is a coherent work in its own right or just a bunch of bits which happen
> to be thrown together onto the same medium.

I think that's a somewhat valid argument, although I'm not really sure 
whether there is any difference between, say, a Fedora 7 "livecd", and a 
router with a cramfs filesystem in rom.

Both really work the same way, and both really are very much targeted 
towards a specific hardware platform.

Yes, it's true that a small router migth be a more *coherent* hardware 
platform than the Fedora 7 livecd is, but that's more a factor of the wild 
and crazy PC hardware culture than of the small router.

For example, what about a livecd for PPC-based hardware? Those tend to be 
much more uniform (read: I think the livecd's generally work on mac 
clones).

So it's a question of degrees of separation. Does it make a difference 
that some of these embedded images work across a whole range of (rather 
similar, but still.. not identical) routers? 

I don't really have any point, except that there is no real *technical* 
difference, and in many respects the only difference in the end really 
seems to be about "intended target device or audience" rather than 
anything else.

How can you make hard licensing decisions in situations like that? I don't 
think you really can. In fact, the OSI rules even forbid making licensing 
decisions based on things that get rather close to the differences you are 
describing (both the "not specific to a product" and "license must not 
discriminate against fields of endeavor").

It's also really really *hard* to make a choice based on a gradual scale. 
Where do you put the limit? Wherever you put it, it's going to be 
arbitrary. Is that really a good thing?

So I would at least *personally* suggest that people not look into the 
license for these kinds of things, and also that you really need to have a 
very specific case, and just basically put it in front of a judge.

At some point, *somebody* has to decide in a gray area, and I'm not saying 
that a judge is really _technically_ any better really to decide the 
issue, but at least he is hopefully _independent_ of both parties, so when 
a judge makes an arbitrary decision, the "arbitrariness" is hopefully at 
least somewhat "fair".

Hmm? 

			Linus
