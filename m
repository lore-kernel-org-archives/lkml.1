Return-Path: <linux-kernel-owner+w=401wt.eu-S1756784AbXFOP6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784AbXFOP6y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 11:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754203AbXFOP6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 11:58:46 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60350 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753828AbXFOP6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 11:58:46 -0400
Date: Fri, 15 Jun 2007 08:58:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>
cc: Daniel Hazelton <dhazelton@enter.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexandre Oliva <aoliva@redhat.com>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <1181899064.25228.342.camel@pmac.infradead.org>
Message-ID: <alpine.LFD.0.98.0706150846370.14121@woody.linux-foundation.org>
References: <466A3EC6.6030706@netone.net.tr>  <200706142144.15695.dhazelton@enter.net>
  <1181895924.25228.319.camel@pmac.infradead.org>  <200706150458.29943.dhazelton@enter.net>
 <1181899064.25228.342.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 15 Jun 2007, David Woodhouse wrote:

> On Fri, 2007-06-15 at 04:58 -0400, Daniel Hazelton wrote:
> > >
> > > But when you distribute the same module as part of a whole which is a
> > > work based on the kernel, the distribution of the whole must be on the
> > > terms of GPL, whose permissions for other licensees extend to the entire
> > > whole, and thus to each and every part regardless of who wrote it.
> > 
> > -ELOGIC
> 
> What's logic got to do with it? It was fairly much a direct quote from
> the licence. You have _read_ the licence, haven't you?

Actually, I suspect Daniel has read it, and is probably referring to 
another facet of the license: distribution of two things together does 
*not* imply that those two things have to both be GPLv2's.

The GPLv2 explicitly mentions "mere aggregation". Strictly speaking, it 
doesn't even *have* to mention it, since it does mention in other places 
that it only covers "derived work", and "derivation" has nothing to do 
with "distributing two things together". But it's a good clarification.

So you guys are *both* right, for different cases!

The issue is simply what you mean by "part of the whole"? If you mean 
"part of the whole kernel distribution", then yes, the kernel is one work, 
and it is, in its entirety, under the GPLv2. But if the "part of the 
whole" is about something like a DVD with the whole being a collection of 
"mere aggregation", the licenses do not necessarily meld together.

Let's say that you're a Linux vendor, and you distribute a DVD with both 
the Linux kernel binary (and all the normal modules that go with it, that 
obviously are "part of the whole kernel") *and* say the NVidia proprietary 
kernel module.

Is that the *only* way to read things? No. It's a matter of 
interpretation, and which "whole" you are talking about. The whole 
aggregation, or the whole program?

And is the NVidia module a "derived work" or not? That's a gray area, and 
that's really what it hinges on. I personally think it's not, but I know 
others think it is.

Which is why I think you're both *potentially* right. Which one of you is 
*actually* right will depend on the exact circumstances ;)

			Linus
