Return-Path: <linux-kernel-owner+w=401wt.eu-S1761324AbYBCRN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761324AbYBCRN3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 12:13:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756925AbYBCRNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 12:13:21 -0500
Received: from senator.holtmann.net ([87.106.208.187]:48167 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756533AbYBCRNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 12:13:20 -0500
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
From: Marcel Holtmann <marcel@holtmann.org>
To: David Newall <davidn@davidnewall.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Christer Weinigel <christer@weinigel.se>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <47A5E67D.9040804@davidnewall.com>
References: <20080125180232.GA4613@kroah.com>
	 <20080202123710.42df1aa0@weinigel.se>	 <20080202191930.GA19826@kroah.com>
	 <47A5D9CD.5070001@davidnewall.com>
	 <84144f020802030743j1278ac64j2ee3e2cbc5c3fefc@mail.gmail.com>
	 <47A5E67D.9040804@davidnewall.com>
Content-Type: text/plain
Date: Sun, 03 Feb 2008 18:13:40 +0100
Message-Id: <1202058820.15090.60.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

> > As there is some controversy over the definition of derived work
> > (think Linus' comments on porting a driver or a filesystem from
> > another operating system here), we use the EXPORT_SYMBOL_GPL
> > annotations as a big warning sign that what you're doing is likely to
> > be considered as a derived work.
> Let's consider a totally original USB driver.  There are an infinite
> number of them, some still to be written.

if a new drivers is originally written for Linux, then you are breaking
the GPL. There is no other way to name this. Using EXPORT_SYMBOL or
EXPORT_SYMBOL_GPL make no difference here. You driver was meant to be
running as Linux kernel module and thus it is derivative work. While
there is a gray area, but this case has always been pretty clear.

> > If the USB developers want to
> > annotate their code with EXPORT_SYMBOL_GPL, why the hell do you want
> > to argue about it?
> Have I the wrong end of the stick?  Isn't that mark restricting an
> interface to GPL _callers_?    Isn't it a technical switch that means,
> "Don't use my software if yours isn't (also) GPL"?  As such it's mere
> political rhetoric, devoid of any binding power.

What are you arguing here. It makes no difference if it is technical or
not. The EXPORT_SYMBOL_GPL gives you a clear hint that when using this
symbol, you have to obey to the GPL. Even the EXPORT_SYMBOL is protected
by the same GPL license. And thus both has the same binding power to be
used from GPL modules only.

At this point I would strongly advise to talk to lawyer since you are
obvious missing the point here.

> > If you want to
> > develop for Linux, you're most certainly better off always
> > distributing your code under the GPLv2
> 
> I agree; but let's not disadvantage applications where regulatory
> requirements prohibit GPL code, nor applications where the proprietor
> simply chooses to keep the work proprietary.  A proprietary module is
> simply a piece of software.  Many people couldn't use Linux if they
> couldn't run proprietary software on it.

First of all we are talking about kernel modules here. Not the
userspace. So stop this FUD.

> > But what I don't understand
> > is why people insist using the Linux kernel for something it clearly
> > can never really properly support (proprietary code)?
> >   
> 
> That's defeatist.  Of course the Linux kernel can properly support
> ("run") proprietary code.  It would be a miserable excuse for an
> operating system if it couldn't.

In userspace, yes, the kernel would "run" proprietary code fully legally
without any problem. As a kernel module, the only safe answer is no. And
in case of EXPORT_SYMBOL_GPL, it is pretty clear. You would obviously
violate the license.

Regards

Marcel


