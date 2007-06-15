Return-Path: <linux-kernel-owner+w=401wt.eu-S1753669AbXFOHXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbXFOHXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 03:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbXFOHX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 03:23:29 -0400
Received: from paragon.brong.net ([66.232.154.163]:52976 "EHLO
	paragon.brong.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295AbXFOHX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 03:23:27 -0400
Date: Fri, 15 Jun 2007 17:23:22 +1000
From: Bron Gondwana <brong@fastmail.fm>
To: Alexandre Oliva <aoliva@redhat.com>
Cc: Bron Gondwana <brong@fastmail.fm>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070615072322.GA7594@brong.net>
References: <orhcpbjnqj.fsf@oliva.athome.lsd.ic.unicamp.br> <200706132304.21984.dhazelton@enter.net> <20070614112329.3645c397@the-village.bc.nu> <20070614103846.GA7902@elte.hu> <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br> <20070614195517.GA4933@elte.hu> <orzm329s9k.fsf@oliva.athome.lsd.ic.unicamp.br> <20070614235004.GA14952@elte.hu> <20070615041149.GA6741@brong.net> <orzm313hge.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <orzm313hge.fsf@oliva.athome.lsd.ic.unicamp.br>
Organization: brong.net
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2007 at 02:38:41AM -0300, Alexandre Oliva wrote:
> On Jun 15, 2007, Bron Gondwana <brong@fastmail.fm> wrote:
> 
> > #define Dell CFG_FAVOURITE_VENDOR
> 
> > A Dell desktop machine is a piece of hardware.  The manufacturer has the
> > source code (hypothetically) to the BIOS.  The BIOS is required for the
> > machine to boot and run Linux.
> 
> > Riddle me this (especially Alexandre, I'm just latching on to Ingo's
> > post because it has the right hook to grab) - are Dell required to give
> > out the source to the bios to enable people to have the same rights Dell
> > engineers do to modify the behaviour of the system?
> 
> What is the license for the bios?  Does it say anything about 'no
> further restrictions on the freedoms to modify and share the
> software'?

It's a necessary part of the boot process, without which Linux could
not be started.  Indeed, the Linux kernel interacts with it through a
(loosely, incompletely and frequently buggy) documented interface, much
like how binary modules interact with the linux kernel (even if they do
get loaded into the sacred ring0 execution space, ooh err)

What happens if you're debugging something you think is a bug in the
Linux kernel and then you run bang into some interactions that make you
think the bug might be in the BIOS instead.  Oh unhappy day, you don't
have access to the source code to the BIOS so you can't check.  Those
cretins at Dell (does a #define still work when it's 2 levels quoted?)
have denied your freedom to modify and debug the system they sold you
which is based _in_a_large_part_ on the GPL$mumble Linux kernel and
hence needs to be interoperable.

Regardless of your sophistry, it's a slipery slope by which Dell could
be forced to exert their corporate might back up the tree to the BIOS
vendor and get the right to release that BIOS source code to you or
stop distributing Linux on their machines. 

> Does it include any mechanisms to stop people from booting modified
> versions of the Linux that ships with the machine?

Maybe, and either way, a future update could, and you couldn't undo it
unless the BIOS flash system lets you "downgrade" again.

Bron.

