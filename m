Return-Path: <linux-kernel-owner+w=401wt.eu-S1759319AbZGHKFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759319AbZGHKFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 06:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757940AbZGHKFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 06:05:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33864 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757636AbZGHKFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 06:05:21 -0400
Date: Wed, 8 Jul 2009 11:04:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: tridge@samba.org
Cc: Martin Steigerwald <Martin@lichtvoll.de>,
       Jan Engelhardt <jengelh@medozas.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Theodore Tso <tytso@mit.edu>, Rusty Russell <rusty@rustcorp.com.au>,
       Pavel Machek <pavel@ucw.cz>, john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org, James.Bottomley@hansenpartnership.com
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
Message-ID: <20090708110451.1092afa7@lxorguk.ukuu.org.uk>
In-Reply-To: <19028.3736.892828.352905@samba.org>
References: <19013.8005.541836.436991@samba.org>
	<alpine.LSU.2.00.0907062221520.27775@fbirervta.pbzchgretzou.qr>
	<19026.38137.63807.427511@samba.org>
	<200907072356.51553.Martin@lichtvoll.de>
	<19028.3736.892828.352905@samba.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>   http://samba.org/tridge/Win98-update.png
> 
> When the vendor of an operating system doesn't even bother to display
> a clean "sorry, you don't get updates any more" page for their OS then
> I think it is safe to say that the operating system is dead and
> buried.

There are lots of Win98 systems still alive out there. The "last few" in
the Win98 world is rather a lot due to the original enormous user base.

> that it should be configurable, but I don't think it leads to the
> conclusion that the patch should not be in the upstream kernel at all.

I think we already proved it had no use upstream. Vendors will remove
the code from their source tree if worried about patents so including it
in the base tree is really irrelevant. So I find your argument about this
less than convincing.

The patch serves no purpose but to confuse users and increasingly it is
shown to break systems horribly.

There might have been a limited case for a not-quite-vfat-fs "tridgefat"
etc if it was both more compatible and if the vendors would use the
option. But given its not compatible and vendors won't why bother at all ?

I also note you keep talking about vendors. This is an open list yet I
don't hear a word from the vendors you claim to represent in support of
this patch set, and saying they would enable it. Not one voice seems to
have appeared.

The decision sequence goes something like this

	- do we want to ship the feature because of patent concern
	> do not ship
	- is it less risk to remove the source from our build tree or
	  configure it out
	> remove from the tree
	- is there a functionality difference to the user between
	  removing or unconfiguring it
	> No

At that point nobody managing risk is going to do anything but remove the
code that worries them. It's additional risk with no return.


Alan
