Return-Path: <linux-kernel-owner+w=401wt.eu-S1757469AbZEKBFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469AbZEKBFA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 21:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867AbZEKBEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 21:04:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42728 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752631AbZEKBEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 21:04:50 -0400
Date: Sun, 10 May 2009 18:00:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Peter Zijlstra <peterz@infradead.org>,
       Greg KH <gregkh@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       Fabio Comolli <fabio.comolli@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] devtmpfs patches
Message-Id: <20090510180018.260bc706.akpm@linux-foundation.org>
In-Reply-To: <ac3eb2510905101647k12a1b9ck71d43933037bac48@mail.gmail.com>
References: <20090509143742.GA27663@kroah.com>
	<b637ec0b0905090810t188e39e3w92d9f4eff04011f1@mail.gmail.com>
	<20090509150853.GA32394@suse.de>
	<20090509082233.32cbb8e4@infradead.org>
	<20090509161923.GA942@suse.de>
	<20090509223454.4642753d.akpm@linux-foundation.org>
	<20090510152005.GA9461@suse.de>
	<1241980263.9562.380.camel@laptop>
	<20090510221901.30c1c5a5@lxorguk.ukuu.org.uk>
	<ac3eb2510905101647k12a1b9ck71d43933037bac48@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009 01:47:16 +0200 Kay Sievers <kay.sievers@vrfy.org> wrote:

> On Sun, May 10, 2009 at 23:19, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >> /me boggles, however does one end up with that many partitions on so few
> >> disks?
> >
> > It happens. Tejun did the extending because libata users were really
> > hitting these limits.
> >
> >> /boot
> >> /
> >> /home
> >> /usr
> >> swap
> >> /usr/local
> >> /opt
> >>
> >> and I'm seriously out of sensible ideas.
> >
> > I've seen two usual variants
> >
> > __ __ __ __Fedora & Unbuntu & Debian & ....
> >
> > __ __ __ __Fedora 10 & Rawhide & Fedora 9 & ...
> >
> > for people who like to play with distros or need to test a product on them
> >
> > and once you do that 16 is quite easy
> 
> That's right. Also people with virtualization, running many guest from
> individual partitions, like to do that - and 16 is nothing for them.
> :)
> 
> Some of us run the dynamic sd minors already, and it's not unlikely we
> will enable it pretty soon for the distro.

There are plenty of setups which have lots of partitions, but very very
few of them are booted with any frequency.

The patchset is described as saving "a few seconds" when booting a
typical distro installation?  Out of what, 100 seconds?  That's pretty
thin gruel, IMO, and doesn't obviously justify mucking up the kernel. 

A 1.5 second saving on some gadget which boots in 6 seconds would be a
lot more interesting.
