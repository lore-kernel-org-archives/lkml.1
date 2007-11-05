Return-Path: <linux-kernel-owner+w=401wt.eu-S1755595AbXKEXXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595AbXKEXXz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 18:23:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754741AbXKEXXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 18:23:48 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52061
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754535AbXKEXXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 18:23:47 -0500
Date: Mon, 05 Nov 2007 15:23:47 -0800 (PST)
Message-Id: <20071105.152347.77881497.davem@davemloft.net>
To: gregkh@suse.de
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net
Subject: Re: [GIT PATCH] PCI patches for 2.6.24-rc1
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071105221752.GA9509@suse.de>
References: <20071105215601.GA4612@kroah.com>
	<alpine.LFD.0.999.0711051410180.15101@woody.linux-foundation.org>
	<20071105221752.GA9509@suse.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@suse.de>
Date: Mon, 5 Nov 2007 14:17:52 -0800

> On Mon, Nov 05, 2007 at 02:13:58PM -0800, Linus Torvalds wrote:
> > On Mon, 5 Nov 2007, Greg KH wrote:
> > > 
> > > They are a bunch of quirk updates from David Miller, a new config item
> > > to help Jeff Garzik start to cleanup the isdn drivers and let him take
> > > those patches through his tree, and a few other minor bugfixes.
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
> > 
> > It says "cured by commit c129d962a66c76964954a98b38586ada82cf9381", but no 
> > such commit exists. What?
> > 
> > Did you mean commit ba698ad4b7e466cbb4a8bde6b9da8080ab06808d, and if so, 
> > where did that c129d.. come from?
> 
> I'll defer to David on this one, as he sent it to me.

At the time I originally wrote that patch, that was the commit ID in
my net-2.6 tree, but I rebased net-2.6 before final submittion of the
tg3 patch and I didn't update the commit log for this patch to match.

Sorry.
