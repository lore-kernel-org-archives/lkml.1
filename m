Return-Path: <linux-kernel-owner+w=401wt.eu-S1755904AbZGHP2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbZGHP2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 11:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755277AbZGHP2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 11:28:05 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58731 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754056AbZGHP2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 11:28:03 -0400
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
In-Reply-To: <20090708110451.1092afa7@lxorguk.ukuu.org.uk>
References: <19013.8005.541836.436991@samba.org>
	 <alpine.LSU.2.00.0907062221520.27775@fbirervta.pbzchgretzou.qr>
	 <19026.38137.63807.427511@samba.org>
	 <200907072356.51553.Martin@lichtvoll.de>
	 <19028.3736.892828.352905@samba.org>
	 <20090708110451.1092afa7@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 10:27:58 -0500
Message-Id: <1247066878.4159.153.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-08 at 11:04 +0100, Alan Cox wrote:
> > that it should be configurable, but I don't think it leads to the
> > conclusion that the patch should not be in the upstream kernel at all.
> 
> I think we already proved it had no use upstream. Vendors will remove
> the code from their source tree if worried about patents so including it
> in the base tree is really irrelevant. So I find your argument about this
> less than convincing.

You have asserted such, but that's not proof.  If your assertion were
valid, vendors would already have removed all the msdos/vfat code, which
they haven't.

Obviously I have no idea what your ex-employer will do. I also can't
speak for Novell, but very likely what we'll do is leave the decision
for OpenSUSE up to the OpenSUSE community and likely follow the kernel
default for SLE.

> The patch serves no purpose but to confuse users and increasingly it is
> shown to break systems horribly.
> 
> There might have been a limited case for a not-quite-vfat-fs "tridgefat"
> etc if it was both more compatible and if the vendors would use the
> option. But given its not compatible and vendors won't why bother at all ?
> 
> I also note you keep talking about vendors. This is an open list yet I
> don't hear a word from the vendors you claim to represent in support of
> this patch set, and saying they would enable it. Not one voice seems to
> have appeared.

Why would vendors wish to comment?  Their position universally is that
the FAT32 patents are invalid.  However, they also recognise that
trolling with invalid patents is increasingly becoming a nasty problem
for their customers, and with TomTom Microsoft has shown willing to do
this, so anything that lowers the risk and potential costs to customers
would be a good thing for vendors.

> The decision sequence goes something like this
> 
> 	- do we want to ship the feature because of patent concern
> 	> do not ship
> 	- is it less risk to remove the source from our build tree or
> 	  configure it out
> 	> remove from the tree
> 	- is there a functionality difference to the user between
> 	  removing or unconfiguring it
> 	> No
> 
> At that point nobody managing risk is going to do anything but remove the
> code that worries them. It's additional risk with no return.

I think you might be confusing two sources of risk.  The risk of
actually infringing a real patent is what you're covering above.  The
source of risk in this case is the risk of being trolled with an invalid
patent but have to spend millions of dollars to demonstrate such if it
goes to trial.  The patch mitigates the latter risk by making it
demonstrable at a preliminary hearing that the invalid patent doesn't
read upon the kernel implementation.

James


