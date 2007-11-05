Return-Path: <linux-kernel-owner+w=401wt.eu-S1755212AbXKEWSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbXKEWSi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 17:18:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbXKEWSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 17:18:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42379 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbXKEWSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 17:18:30 -0500
Date: Mon, 5 Nov 2007 14:17:52 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net
Subject: Re: [GIT PATCH] PCI patches for 2.6.24-rc1
Message-ID: <20071105221752.GA9509@suse.de>
References: <20071105215601.GA4612@kroah.com> <alpine.LFD.0.999.0711051410180.15101@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0711051410180.15101@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2007 at 02:13:58PM -0800, Linus Torvalds wrote:
> On Mon, 5 Nov 2007, Greg KH wrote:
> > 
> > They are a bunch of quirk updates from David Miller, a new config item
> > to help Jeff Garzik start to cleanup the isdn drivers and let him take
> > those patches through his tree, and a few other minor bugfixes.
> 
> This one is bogus:
> 
>     PCI: Revert "PCI: disable MSI by default on systems with Serverworks HT1000 chips"
>     
>     This reverts commit e3008dedff4bdc96a5f67224cd3d8d12237082a0.
>     
>     The real bug was an INTX issue in the tg3 ethernet chip, and
>     cured by commit c129d962a66c76964954a98b38586ada82cf9381
>     
>     Signed-off-by: David S. Miller <davem@davemloft.net>
>     Acked-by: Jeff Garzik <jgarzik@redhat.com>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> It says "cured by commit c129d962a66c76964954a98b38586ada82cf9381", but no 
> such commit exists. What?
> 
> Did you mean commit ba698ad4b7e466cbb4a8bde6b9da8080ab06808d, and if so, 
> where did that c129d.. come from?

I'll defer to David on this one, as he sent it to me.

David?

greg k-h
