Return-Path: <linux-kernel-owner+w=401wt.eu-S1757360AbYBGQNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360AbYBGQNu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 11:13:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbYBGQNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 11:13:41 -0500
Received: from www.tglx.de ([62.245.132.106]:56318 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbYBGQNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 11:13:39 -0500
Date: Thu, 7 Feb 2008 17:13:22 +0100
From: =?UTF-8?B?SGFucy1Kw7xyZ2Vu?= Koch <hjk@linutronix.de>
To: David Newall <davidn@davidnewall.com>
Cc: Christer Weinigel <christer@weinigel.se>,
       Marcel Holtmann <marcel@holtmann.org>,
       Diego Zuccato <diego@otello.alma.unibo.it>, Greg KH <greg@kroah.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Message-ID: <20080207171322.40eb7c95@dilbert.local>
In-Reply-To: <47AB163C.5070107@davidnewall.com>
References: <20080125180232.GA4613@kroah.com>
	<20080202123710.42df1aa0@weinigel.se>
	<20080202191930.GA19826@kroah.com>
	<47A5D895.20300@davidnewall.com>
	<47A6E742.80408@otello.alma.unibo.it>
	<47A764ED.8030605@weinigel.se>
	<1202161091.15090.84.camel@violet>
	<20080206213449.6614efea@weinigel.se>
	<20080206215442.63c94cf3@dilbert.local>
	<47AB056E.70802@davidnewall.com>
	<20080207150612.21ba60df@dilbert.local>
	<47AB163C.5070107@davidnewall.com>
Organization: Linutronix
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Fri, 08 Feb 2008 01:01:24 +1030
schrieb David Newall <davidn@davidnewall.com>:


> > It is not legally meaningless if copyright holders publicly state
> > how they interpret the license and what they consider a license
> > violation. 
> 
> Copyright-holders' opinions mean nothing.  In the particular case of
> EXPORT_SYMBOL_GPL, copyright-holders' opinions are clearly flawed
> because they make a statement about code that they do not even know
> of. 

What are you talking about? That's what every GPL-licensed library
does. By putting a library under the GPL, the copyright-holder clearly
states that he considers all programs that link against that library a
derived work. And that he therefor requires these programs to be GPL,
too, no matter if these programs already exist or not.

The LGPL exists to allow the linked program to be non-GPL, remember?
But the kernel is GPL, and not LGPL. And all these arguments that a
kernel module does not "link" against the kernel code, is therefor not
a derived work, and not bound by the GPL's restrictions, is just
artificial nonsense.

> It's equivalent to someone saying, "you are wrong," before you've
> even thought about saying something.

No. The GPL is about derived work. Derived code can obviously only
appear _after_ the original work.

> 
> > In the end, a court must decide, but lots of courts will at least
> > look at the statements the copyright holders made over the years.
> >
> >   
> >> and politically damaging.
> >>     
> >
> > That's your opinion because it's damaging _your_ political goals.
> >   
> 
> How ludicrous.  That's as much a nonsense as EXPORT_SYMBOL_GPL.  You
> have no idea what my political goals are.
> 
> Less there be further confusion: I am not an advocate for binary
> drivers.  

Nice to hear. So, if you're an advocate for open source drivers, why do
you have problems making them GPL?

> That role is reserved for others.  However that does not
> stop me from criticising something that is obviously wrong.  Stating
> that only a GPL code is permitted to use a symbol contravenes the GPL,
> because the GPL states no such requirement.  Saying that it's
> impossible for code that uses the symbol to be non-GPL (as has been
> claimed) is a lie at worst, and a hope at best.  Nobody claiming such
> a thing could know it to be true.  (It is not true.)

Using a symbol from a library means linking to it, and that creates a
derived work. Why should it be different when using kernel symbols?

Thanks,
Hans


