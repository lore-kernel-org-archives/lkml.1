Return-Path: <linux-kernel-owner+w=401wt.eu-S1759761AbYA2DGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759761AbYA2DGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 22:06:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754906AbYA2DGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 22:06:12 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:44225 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727AbYA2DGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 22:06:11 -0500
Date: Mon, 28 Jan 2008 19:05:05 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Greg KH <greg@kroah.com>
Cc: Tony Camuso <tcamuso@redhat.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Matthew Wilcox <matthew@wil.cx>, Loic Prylli <loic@myri.com>,
       Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Martin Mares <mj@ucw.cz>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
Message-ID: <20080128190505.5f5b1ccc@laptopd505.fenrus.org>
In-Reply-To: <20080128204431.GA15227@kroah.com>
References: <1200208085.6896.134.camel@pasglop>
	<20080113072415.GB18741@parisc-linux.org>
	<20080113090108.3224698c@laptopd505.fenrus.org>
	<20080114225225.GQ18741@parisc-linux.org>
	<20080114230448.GL9847@does.not.exist>
	<478CD8A5.5090608@myri.com>
	<20080115174643.GB28238@kroah.com>
	<20080115175641.GE18741@parisc-linux.org>
	<20080119165809.GB11553@colo.lackof.org>
	<479E1FA6.1030708@redhat.com>
	<20080128204431.GA15227@kroah.com>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2008 12:44:31 -0800
Greg KH <greg@kroah.com> wrote:

> On Mon, Jan 28, 2008 at 01:32:06PM -0500, Tony Camuso wrote:
> > Greg,
> >
> > Have you given Grant's suggestion any further consideration?
> >
> > I'd like to know how the MMCONFIG issues discussed in this thread
> > are going to be handled upstream. I have a patch implemented in
> > RHEL 5.2, but I would rather have the upstream patch implemented,
> > whatever it is.
> 
> Well, everyone still doesn't seem to agree on the proper way forward
> here, so for me to just "pick one" isn't very appropriate.
> 
> So, can we try again?

I think there's only one fundamental disagreement; and that is:
do we think that things are now totally fixed and no new major issues
will arrive after the "fix yet another mmconfig thing" patches are merged.

If the answer is no, then imho my patch is the right approach; it will limit the damage and doesn't make
the people suffer who don't need extended config space.
If the answer is yet, then my patch is not needed.

This is a judgment call; I'm skeptical, others are more optimistic that after 2 years of messing around
they have finally found the last golden fix.

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
