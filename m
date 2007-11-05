Return-Path: <linux-kernel-owner+w=401wt.eu-S1755307AbXKEWhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbXKEWhy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 17:37:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbXKEWhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 17:37:46 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52654 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752045AbXKEWhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 17:37:45 -0500
Date: Mon, 5 Nov 2007 14:37:31 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
cc: "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net
Subject: Re: [GIT PATCH] PCI patches for 2.6.24-rc1
In-Reply-To: <20071105221752.GA9509@suse.de>
Message-ID: <alpine.LFD.0.999.0711051432531.15101@woody.linux-foundation.org>
References: <20071105215601.GA4612@kroah.com>
 <alpine.LFD.0.999.0711051410180.15101@woody.linux-foundation.org>
 <20071105221752.GA9509@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 Nov 2007, Greg KH wrote:
> > 
> > This one is bogus:
> > 
> >     PCI: Revert "PCI: disable MSI by default on systems with Serverworks HT1000 chips"
> >     
> >     This reverts commit e3008dedff4bdc96a5f67224cd3d8d12237082a0.
> >     
> >     The real bug was an INTX issue in the tg3 ethernet chip, and
> >     cured by commit c129d962a66c76964954a98b38586ada82cf9381
> >     
> >     Signed-off-by: David S. Miller <davem@davemloft.net>
> >     Acked-by: Jeff Garzik <jgarzik@redhat.com>
> >     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> I'll defer to David on this one, as he sent it to me.

Btw, I'd also like to take the opportunitity to ask people to always 
include the explanation of the commit when you give a commit ID.

"git revert" does that for the commit it reverts, but the (bogus) commit 
ID that was apparently added by David (c129d962a) didn't get the 
explanation for it, so now it's totally impossible to match it up with 
anything at all..

So let me one more say:

 - don't just say 

	.. was cured by commit xyz

 - but add the one-liner description of the commit, something along the 
   lines of

	.. was cured by commit xyz ("PCI: Add quirk for devices which 
        disable MSI when INTX_DISABLE is set.")

so that the commit messages are readable even outside git.

		Linus
