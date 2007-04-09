Return-Path: <linux-kernel-owner+w=401wt.eu-S1753424AbXDIVu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbXDIVu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbXDIVur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:50:47 -0400
Received: from nlpi012.sbcis.sbc.com ([207.115.36.41]:29713 "EHLO
	nlpi012.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbXDIVuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:50:14 -0400
X-ORBL: [67.117.73.34]
Date: Mon, 9 Apr 2007 17:49:57 -0400
From: Tony Lindgren <tony@atomide.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Roland Dreier <rdreier@cisco.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/90] Post 2.6.21 OMAP update
Message-ID: <20070409214955.GI7818@atomide.com>
References: <11757088774110-git-send-email-tony@atomide.com> <20070404182728.GK29129@atomide.com> <20070404113925.da221efc.randy.dunlap@oracle.com> <20070404184455.GL29129@atomide.com> <20070404224448.0ff60ed2@the-village.bc.nu> <20070405132144.GC24297@atomide.com> <adar6qybx4y.fsf@cisco.com> <20070405180334.GW24297@atomide.com> <20070405212713.10675e27@the-village.bc.nu> <20070406071858.GC6730@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070406071858.GC6730@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* Russell King <rmk+lkml@arm.linux.org.uk> [070406 03:19]:
> On Thu, Apr 05, 2007 at 09:27:13PM +0100, Alan Cox wrote:
> > > Hmm, yeah I'll see if I could group them a bit. The problem there
> > > is that the patch series contains multiple rounds of "add and fix"
> > > cycles. Pretty much all the non-dependant fixes have already been
> > > applied, BTW.
> > 
> > Bear in mind that it doesn't work now, so merging some stuff and being in
> > a "more merged but still not yet a tree to build OMAP from" is not a
> > regression or a problem.
> > 
> > Going back some time the PA-RISC merge occurred over several months until
> > one day it was all there.
> 
> I think Tony's problem is the volume of changes though - I think it is
> fair to say that in 2.6.18 it was fully merged and working.
> 
> Since then, for one reason or another the merge windows got missed (ISTR
> it was triggered due to me not being able to devote the full 14 days to
> kernel work during the 2.6.19 merge window due to going on holiday) which
> has resulted in subsequent merge windows being missed, and therefore the
> number of changes increasing and the problem Tony's now in.
> 
> In that respect, if it no longer "work"s now, it's technically a
> regression.

Yeah, it works, but the current omap code in the mainline kernel is still
mostly at 2.6.18 level like you mentioned.

> Clearly the real solution is for rmk never to go on holiday during a
> merge window, but I don't personally find that acceptable.  Or maybe
> human cloning, but I'm sure there's people here who think that one rmk
> is enough. ;)

Or maybe there should be a two week common code and interface merge
window, then another two weeks for merging board and driver specific
stuff?

That would make it easier to update the board and driver specific
patches to the common code and interface changes first before they
are submitted.

Regards,

Tony
