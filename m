Return-Path: <linux-kernel-owner+w=401wt.eu-S1763379AbYA2NQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763379AbYA2NQo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 08:16:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763007AbYA2NQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 08:16:25 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36312 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762997AbYA2NQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 08:16:23 -0500
Date: Tue, 29 Jan 2008 05:19:55 -0800
From: Greg KH <greg@kroah.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Arjan van de Ven <arjan@infradead.org>, Tony Camuso <tcamuso@redhat.com>,
       Grant Grundler <grundler@parisc-linux.org>, Loic Prylli <loic@myri.com>,
       Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Martin Mares <mj@ucw.cz>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
	opt-in
Message-ID: <20080129131955.GC10761@kroah.com>
References: <20080114225225.GQ18741@parisc-linux.org> <20080114230448.GL9847@does.not.exist> <478CD8A5.5090608@myri.com> <20080115174643.GB28238@kroah.com> <20080115175641.GE18741@parisc-linux.org> <20080119165809.GB11553@colo.lackof.org> <479E1FA6.1030708@redhat.com> <20080128204431.GA15227@kroah.com> <20080128190505.5f5b1ccc@laptopd505.fenrus.org> <20080129031804.GF20198@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080129031804.GF20198@parisc-linux.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2008 at 08:18:04PM -0700, Matthew Wilcox wrote:
> On Mon, Jan 28, 2008 at 07:05:05PM -0800, Arjan van de Ven wrote:
> > I think there's only one fundamental disagreement; and that is:
> > do we think that things are now totally fixed and no new major issues
> > will arrive after the "fix yet another mmconfig thing" patches are merged.
> > 
> > If the answer is no, then imho my patch is the right approach; it will limit the damage and doesn't make
> > the people suffer who don't need extended config space.
> > If the answer is yet, then my patch is not needed.
> > 
> > This is a judgment call; I'm skeptical, others are more optimistic that after 2 years of messing around
> > they have finally found the last golden fix.
> 
> I'm more optimistic because we've so severely restricted the use of
> mmconf after these patches that it's unlikely to cause problems.  I also
> hear Vista is now using mmconf, so fewer implementations are going to
> be buggy at this point.

Hahahaha, oh, that's a good one...

But what about the thousands of implementations out there that are
buggy?

I'm with Arjan here, I'm very skeptical.

Matthew, with Arjan's patch, is anything that currently works now
broken?  Why do you feel it is somehow "wrong"?

thanks,

greg k-h
