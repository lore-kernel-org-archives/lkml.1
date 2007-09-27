Return-Path: <linux-kernel-owner+w=401wt.eu-S1759084AbXI0VH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759084AbXI0VH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 17:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755892AbXI0VHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 17:07:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44371 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755513AbXI0VHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 17:07:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Dmitry Tyschenko" <dtyschenko@gmail.com>
Subject: Re: NO_HZ hangs up AMD MK-36
Date: Thu, 27 Sep 2007 23:21:51 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>
References: <a6a840cd0709271328p76ee6a22tf3b60678d6a2d455@mail.gmail.com> <200709272259.26412.rjw@sisk.pl> <a6a840cd0709271401r56d5bebes8e361994ecc5746a@mail.gmail.com>
In-Reply-To: <a6a840cd0709271401r56d5bebes8e361994ecc5746a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709272321.52514.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please don't top post.

On Thursday, 27 September 2007 23:01, Dmitry Tyschenko wrote:
> Sorry, I am newbie in linux. Hope you was talking about:
> /boot/vmlinuz-2.6.22-1-k7 root=/dev/sda5 ro nohz=off

Yes.

> But it doesn't help for Debians 2.6.22-1 (I don't have another
> prebuiled) still same problems.

So, you need to explicitly unset NO_HZ in the kernel coniguration to make
things work.

Well, in that case please wait until the 2.6.23 kernel is out and test it.
There will be some important fixes related to NO_HZ in it.

Greetings,
Rafael


> 2007/9/27, Rafael J. Wysocki <rjw@sisk.pl>:
> > On Thursday, 27 September 2007 22:28, Dmitry Tyschenko wrote:
> > > Hello,
> > >
> > > I have laptop Asus X50M. Using old Debian Etch from February.
> > > Kernel from 2.6.21 doesn't boot, hangs up just in 10seconds -  1minute
> > > after GRUB screen.
> > > I have tryed different versions of gcc (4.1.1, 4.1.2, 4.2.1) to build
> > > 2.6.22.8 kernel, but no results.
> > > But if I disable NO_HZ option 2.6.21 is working fine for me.
> > >
> > > I think this is important problem, because some of the project, Debian
> > > for example,
> > >  are building kernel with this options enabled (in
> > > linux-image-2.6.22-1-k7 package it is enabled),
> > > and some people, like me, can not use new kernels.
> > >
> > > I have attached some of my PC info, hope this can help
> >
> > You can use the "nohz=off" kernel command line switch.  Please check if it
> > works for you.
> >
> > Greetings,
> > Rafael
> >
> 
> 

-- 
"Premature optimization is the root of all evil." - Donald Knuth
