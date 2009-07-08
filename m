Return-Path: <linux-kernel-owner+w=401wt.eu-S1759268AbZGHQJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759268AbZGHQJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 12:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759674AbZGHQGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 12:06:50 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37587 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759657AbZGHQGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 12:06:48 -0400
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: tridge@samba.org, Martin Steigerwald <Martin@lichtvoll.de>,
       Jan Engelhardt <jengelh@medozas.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Theodore Tso <tytso@mit.edu>, Rusty Russell <rusty@rustcorp.com.au>,
       Pavel Machek <pavel@ucw.cz>, john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org
In-Reply-To: <20090708163736.0f98e7e0@lxorguk.ukuu.org.uk>
References: <19013.8005.541836.436991@samba.org>
	 <alpine.LSU.2.00.0907062221520.27775@fbirervta.pbzchgretzou.qr>
	 <19026.38137.63807.427511@samba.org>
	 <200907072356.51553.Martin@lichtvoll.de>
	 <19028.3736.892828.352905@samba.org>
	 <20090708110451.1092afa7@lxorguk.ukuu.org.uk>
	 <1247066878.4159.153.camel@mulgrave.site>
	 <20090708163736.0f98e7e0@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 16:06:42 +0000
Message-Id: <1247069202.4159.212.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-08 at 16:37 +0100, Alan Cox wrote:
> > > I think we already proved it had no use upstream. Vendors will remove
> > > the code from their source tree if worried about patents so including it
> > > in the base tree is really irrelevant. So I find your argument about this
> > > less than convincing.
> > 
> > You have asserted such, but that's not proof.  If your assertion were
> > valid, vendors would already have removed all the msdos/vfat code, which
> > they haven't.
> 
> That represents loss of functionality for loss of risk (a trade off).

Precisely ... that's what this whole thread is about.  Accepting the
lawyer's argument that this patch eliminates the risk of suit under the
FAT32 patents, does the loss of functionality it comes with represent an
adequate reward?

>  If
> they are going to disable stuff then they'll pull the lot (loss of risk
> for free).

I'd agree with that, the problem is the loss of functionality ... and
actually, the best outcome for this would be to come up with a true
light weight filesystem that could replace the rather crap DOS/FAT32 one
in embedded applications based on fully free source and no patent
encumbrances and have it adopted as a universal standard for flash/USB
stick/mmc interchange.

> Remember the GPL requires you provide the *sources* you used
> to create the binaries, not redacted ones so if you don't want to provide
> feature X for some reason you need to pull it out of your source tree
> before you build.

OK, so we disagree on whether providing source code constitutes
contributory infringement.

> > > 	- do we want to ship the feature because of patent concern
> > > 	> do not ship
> > > 	- is it less risk to remove the source from our build tree or
> > > 	  configure it out
> > > 	> remove from the tree
> > > 	- is there a functionality difference to the user between
> > > 	  removing or unconfiguring it
> > > 	> No
> > > 
> > > At that point nobody managing risk is going to do anything but remove the
> > > code that worries them. It's additional risk with no return.
> > 
> > I think you might be confusing two sources of risk.  The risk of
> > actually infringing a real patent is what you're covering above.  The
> > source of risk in this case is the risk of being trolled with an invalid
> > patent but have to spend millions of dollars to demonstrate such if it
> > goes to trial.  The patch mitigates the latter risk by making it
> > demonstrable at a preliminary hearing that the invalid patent doesn't
> > read upon the kernel implementation.
> 
> At that point we get into legal advice I can't comment on in public.
> However based on previous discussions about source code and other patterns
> suffice to say I don't agree.

OK, so rather than get into a what my lawyer says versus what your
lawyer says argument, can we get back to the technical aspects of this
and leave the lawyers retained by the vendors to sort out what they
actually do?

James


