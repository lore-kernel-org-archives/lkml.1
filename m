Return-Path: <linux-kernel-owner+w=401wt.eu-S1757308AbZEKACg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308AbZEKACg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 20:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbZEKAC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 20:02:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:39461 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbZEKACZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 20:02:25 -0400
Date: Sun, 10 May 2009 17:00:16 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Peter Zijlstra <peterz@infradead.org>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Fabio Comolli <fabio.comolli@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] devtmpfs patches
Message-ID: <20090510170016.1e3a4d97@infradead.org>
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
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009 01:47:16 +0200
Kay Sievers <kay.sievers@vrfy.org> wrote:

> On Sun, May 10, 2009 at 23:19, Alan Cox <alan@lxorguk.ukuu.org.uk>
> wrote:
> >> /me boggles, however does one end up with that many partitions on
> >> so few disks?
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
> >        Fedora & Unbuntu & Debian & ....
> >
> >        Fedora 10 & Rawhide & Fedora 9 & ...
> >
> > for people who like to play with distros or need to test a product
> > on them
> >
> > and once you do that 16 is quite easy
> 
> That's right. Also people with virtualization, running many guest from
> individual partitions, like to do that - and 16 is nothing for them.
> :)
> 
> Some of us run the dynamic sd minors already, and it's not unlikely we
> will enable it pretty soon for the distro.
> 

I'm still missing why > 16 implies "dynamic"/..

(and it seems to be irrelevant to the devtmpfs discussion anyway since
Eric Biederman has shown that pulling the device numbers out of sysfs
is basically free... even though it'd be nice to give that some help to 
make it a nice index)



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
