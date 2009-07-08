Return-Path: <linux-kernel-owner+w=401wt.eu-S1755940AbZGHPiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbZGHPiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 11:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754406AbZGHPiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 11:38:03 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45272 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753821AbZGHPiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 11:38:01 -0400
Date: Wed, 8 Jul 2009 16:37:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: tridge@samba.org, Martin Steigerwald <Martin@lichtvoll.de>,
       Jan Engelhardt <jengelh@medozas.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Theodore Tso <tytso@mit.edu>, Rusty Russell <rusty@rustcorp.com.au>,
       Pavel Machek <pavel@ucw.cz>, john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
Message-ID: <20090708163736.0f98e7e0@lxorguk.ukuu.org.uk>
In-Reply-To: <1247066878.4159.153.camel@mulgrave.site>
References: <19013.8005.541836.436991@samba.org>
	<alpine.LSU.2.00.0907062221520.27775@fbirervta.pbzchgretzou.qr>
	<19026.38137.63807.427511@samba.org>
	<200907072356.51553.Martin@lichtvoll.de>
	<19028.3736.892828.352905@samba.org>
	<20090708110451.1092afa7@lxorguk.ukuu.org.uk>
	<1247066878.4159.153.camel@mulgrave.site>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I think we already proved it had no use upstream. Vendors will remove
> > the code from their source tree if worried about patents so including it
> > in the base tree is really irrelevant. So I find your argument about this
> > less than convincing.
> 
> You have asserted such, but that's not proof.  If your assertion were
> valid, vendors would already have removed all the msdos/vfat code, which
> they haven't.

That represents loss of functionality for loss of risk (a trade off). If
they are going to disable stuff then they'll pull the lot (loss of risk
for free). Remember the GPL requires you provide the *sources* you used
to create the binaries, not redacted ones so if you don't want to provide
feature X for some reason you need to pull it out of your source tree
before you build.

> > 	- do we want to ship the feature because of patent concern
> > 	> do not ship
> > 	- is it less risk to remove the source from our build tree or
> > 	  configure it out
> > 	> remove from the tree
> > 	- is there a functionality difference to the user between
> > 	  removing or unconfiguring it
> > 	> No
> > 
> > At that point nobody managing risk is going to do anything but remove the
> > code that worries them. It's additional risk with no return.
> 
> I think you might be confusing two sources of risk.  The risk of
> actually infringing a real patent is what you're covering above.  The
> source of risk in this case is the risk of being trolled with an invalid
> patent but have to spend millions of dollars to demonstrate such if it
> goes to trial.  The patch mitigates the latter risk by making it
> demonstrable at a preliminary hearing that the invalid patent doesn't
> read upon the kernel implementation.

At that point we get into legal advice I can't comment on in public.
However based on previous discussions about source code and other patterns
suffice to say I don't agree.

