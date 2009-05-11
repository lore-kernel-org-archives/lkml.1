Return-Path: <linux-kernel-owner+w=401wt.eu-S1758679AbZEKR4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758679AbZEKR4w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 13:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758084AbZEKR40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 13:56:26 -0400
Received: from kroah.org ([198.145.64.141]:55886 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756629AbZEKR4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 13:56:25 -0400
Date: Mon, 11 May 2009 10:45:47 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Fabio Comolli <fabio.comolli@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] devtmpfs patches
Message-ID: <20090511174547.GD4534@kroah.com>
References: <b637ec0b0905090810t188e39e3w92d9f4eff04011f1@mail.gmail.com> <20090509150853.GA32394@suse.de> <20090509082233.32cbb8e4@infradead.org> <20090509161923.GA942@suse.de> <20090509223454.4642753d.akpm@linux-foundation.org> <20090510152005.GA9461@suse.de> <1241980263.9562.380.camel@laptop> <20090510221901.30c1c5a5@lxorguk.ukuu.org.uk> <ac3eb2510905101647k12a1b9ck71d43933037bac48@mail.gmail.com> <20090510180018.260bc706.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090510180018.260bc706.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 10, 2009 at 06:00:18PM -0700, Andrew Morton wrote:
> On Mon, 11 May 2009 01:47:16 +0200 Kay Sievers <kay.sievers@vrfy.org> wrote:
> 
> > On Sun, May 10, 2009 at 23:19, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > >> /me boggles, however does one end up with that many partitions on so few
> > >> disks?
> > >
> > > It happens. Tejun did the extending because libata users were really
> > > hitting these limits.
> > >
> > >> /boot
> > >> /
> > >> /home
> > >> /usr
> > >> swap
> > >> /usr/local
> > >> /opt
> > >>
> > >> and I'm seriously out of sensible ideas.
> > >
> > > I've seen two usual variants
> > >
> > > __ __ __ __Fedora & Unbuntu & Debian & ....
> > >
> > > __ __ __ __Fedora 10 & Rawhide & Fedora 9 & ...
> > >
> > > for people who like to play with distros or need to test a product on them
> > >
> > > and once you do that 16 is quite easy
> > 
> > That's right. Also people with virtualization, running many guest from
> > individual partitions, like to do that - and 16 is nothing for them.
> > :)
> > 
> > Some of us run the dynamic sd minors already, and it's not unlikely we
> > will enable it pretty soon for the distro.
> 
> There are plenty of setups which have lots of partitions, but very very
> few of them are booted with any frequency.

On the contrary, opensuse had lots of very grumpy users that had 10s of
partitions (lots of operating systems installed for testing and for
other reasons), that did not like us switching to libata which rendered
their partition setup as broken.

Hence the dynamic minors for large numbers of scsi partitions.  That
option is now enabled in the openSUSE FACTORY tree which made that user
group very happy.

> The patchset is described as saving "a few seconds" when booting a
> typical distro installation?  Out of what, 100 seconds?

5-8 seconds.

> That's pretty thin gruel, IMO, and doesn't obviously justify mucking
> up the kernel. 

No, it's a very large percentage overall.

Others are talking about getting a full Linux install up and running in
2 or less seconds, so every little bit counts now.

> A 1.5 second saving on some gadget which boots in 6 seconds would be a
> lot more interesting.

That is what we are talking about here.

thanks,

greg k-h
