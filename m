Return-Path: <linux-kernel-owner+w=401wt.eu-S1759900AbYBFVNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759900AbYBFVNO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 16:13:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756879AbYBFVM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 16:12:57 -0500
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:35195 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755046AbYBFVM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 16:12:56 -0500
Date: Wed, 6 Feb 2008 22:12:54 +0100
From: Christer Weinigel <christer@weinigel.se>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Cc: "David Newall" <davidn@davidnewall.com>,
       "Marcel Holtmann" <marcel@holtmann.org>, "Greg KH" <greg@kroah.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Message-ID: <20080206221254.5780a862@weinigel.se>
In-Reply-To: <84144f020802050346h2c26aac4v9841dd5bc98931a0@mail.gmail.com>
References: <20080125180232.GA4613@kroah.com>
	<20080202123710.42df1aa0@weinigel.se>
	<20080202191930.GA19826@kroah.com>
	<47A5D9CD.5070001@davidnewall.com>
	<84144f020802030743j1278ac64j2ee3e2cbc5c3fefc@mail.gmail.com>
	<47A5E67D.9040804@davidnewall.com>
	<1202058820.15090.60.camel@violet>
	<courier.47A84ADB.000047C1@hawking.rebel.net.au>
	<84144f020802050346h2c26aac4v9841dd5bc98931a0@mail.gmail.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008 13:46:08 +0200
"Pekka Enberg" <penberg@cs.helsinki.fi> wrote:

> Hi David,
> 
> Marcel Holtmann writes:
> > > You driver was meant to be running as Linux kernel module and
> > > thus it is derivative work.
> 
> On Feb 5, 2008 1:39 PM, David Newall <davidn@davidnewall.com> wrote:
> > It is precisely the fact that it is a loadable module, and does not
> > form part of the kernel, that removes the requirement to distribute
> > it under GPL.
> 
> What makes you qualified to make that statement (without giving any
> evidence)? Are you're an expert on international copyright law?

Are you?  You've made some very definite statements about copyright
law.  Things that I've been told are definitely in a gray area and not
at all as clear cut as you and the FSF likes to say.  FSF has a very
clear agenda, and taking what they say as the gospel is a big mistake.

If I link a binary .o file into a static kernel image, does that make it
a derivative work of the kernel?  It most definitely violates the GPL
in that the total is a derivative work, but does it really make the .o
file a derivative work?  What if I let the user do the linking at
runtime?  But as Alan Cox wrote, how the linking is done doesn't decide
if it is a derivative work or not, copyright law does.

So what does make it a derivative work then?

If I use an in kernel API, but from a piece of code which is external
to the kernel, is that really a derived work? If you say it is, do you
realise that you are advocating something which is very close to an API
copyright, something which I think most open source people are very
adverse to.  If API copyrights were valid, Wine, or editline, or
lesstiff would be in a lot of trouble.  

Of course, the Linux headers don't only define an API, they also
contain a lot of inline code.  But if I don't care about an extra jump,
I could write a glue layer between the Linux kernel and some
proprietary code that wraps all inline functions.  In that case, is a
module written against that glue layer a derivative work of the kernel?

If I write a glue layer that allows me to run the same driver in
userspace via libusb and directly in the kernel, and give the user a
choice to link my binary .o file either the userspace or kernel space
glue, does that make my code a derivative work of the kernel?  Most
probably not, it is independent of the kernel in that case.  

So where is the line in the sand that makes it clearly a derivative
work?  It's up to the courts to decide, and until there is a clear
and final court ruling it is a gray area.  Lawyers can guess at what
the outcome might be, and some companies are apparently willing to take
the risk that it isn't as clear cut as you think.

  /Christer



