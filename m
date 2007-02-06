Return-Path: <linux-kernel-owner+w=401wt.eu-S1752135AbXBFNlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbXBFNlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 08:41:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbXBFNlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 08:41:15 -0500
Received: from [212.12.190.119] ([212.12.190.119]:32883 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752135AbXBFNlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 08:41:15 -0500
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
Date: Tue, 6 Feb 2007 16:43:37 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200702061643.37380.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Mon, 5 Feb 2007, Zach Brown wrote:
> > For syscalls, sure.
> >
> > The kevent work incorporates Uli's desire to have more data per event. 
> > Have you read his OLS stuff?  It's been a while since I did so I've lost
> > the details of why he cares to have more.
>
> You'd still do that as _arguments_ to the system call, not as the return
> value.
>
> Also, quite frankly, I tend to find Uli over-designs things. The whole
> disease of "make things general" is a CS disease that some people take to
> extreme.
>
> The good thing about generic code is not that it solves some generic
> problem. The good thing about generics is that they mean that you can
> _avoid_ solving other problems AND HAVE LESS CODE.

Yes, that would be generic code, in the pure sense.

> But some people seem to
> think that "generic" means that you have to have tons of code to handle
> all the possible cases, and that *completely* misses the point.

That would be generic code too, but by way of functional awareness. This is 
sometimes necessary, as no pure generic code has been found.

What's important is not the generic code, but rather the correct abstraction 
of the problem-domain, regardless of it's implementation, as that can be 
conveniently hidden behind the interface.

> We want less code. The whole (and really, the _only_) point of the
> fibrils, at least as far as I'm concerned, is to *not* have special code
> for aio_read/write/whatever.

What we want is correct code, and usually that means less code in the long 
run.  

So, instead of allowing the implementation to dictate the system design, it 
may be advisable to concentrate on the design first, to achieve an abstract 
interface that is realized by an implementation second.


Thanks!

--
Al

