Return-Path: <linux-kernel-owner+w=401wt.eu-S1755339AbYF3PXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbYF3PXM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 11:23:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbYF3PXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 11:23:00 -0400
Received: from smtp1.riverbed.com ([206.169.144.12]:10374 "EHLO
	smtp1.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbYF3PW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 11:22:59 -0400
Date: Mon, 30 Jun 2008 08:23:40 -0700
From: Arthur Jones <ajones@riverbed.com>
To: Doug Thompson <norsk5@yahoo.com>
CC: Andi Kleen <andi@firstfloor.org>,
       "dougthompson@xmission.com" <dougthompson@xmission.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "bluesmoke-devel@lists.sourceforge.net" 
	<bluesmoke-devel@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/13] EDAC i5100 new intel chipset driver
Message-ID: <20080630152340.GH10571@ajones-laptop.nbttech.com>
References: <87r6aip2pi.fsf@basil.nowhere.org> <77374.55758.qm@web50103.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <77374.55758.qm@web50103.mail.re2.yahoo.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug, ...

On Fri, Jun 27, 2008 at 11:15:06PM -0700, Doug Thompson wrote:
> 
> --- Andi Kleen <andi@firstfloor.org> wrote:
> 
> > dougthompson@xmission.com writes:
> > >
> > > 2)  I have not yet tackled the de-interleaving of the
> > > rank/controller address space into the physical address
> > > space of the CPU.  There is nothing fundamentally missing,
> > > it is just ending up to be a lot of code, and I'd rather
> > > keep it separate for now, esp since it doesn't work yet...
> > >
> > > 3)  The code depends on a particular i5100 chip select
> > > to DIMM mainboard chip select mapping.  This mapping
> > > seems obvious to me in order to support dual and single
> > > ranked memory, but it is not unique and DIMM labels
> > > could be wrong on other mainboards.  There is no way
> > > to query this mapping that I know of.
> >
> > Since there's a non negligible probability that the output
> > of this driver is completely misleading because of (2) and (3)
> > and probably (4) too [reporting the wrong DIMMs etc.]
> > would it be possible to add some flag to EDAC that
> > warns the user that the output is not fully reliable?\
> 
> good idea.
> 
> Arthur, could you add some more text to the driver's output, before the call to the
> core's output function, doing exactly that? Explaining just what you DO know, and what you don't
> know?

Would it make sense to leave the DIMM labeling in, but
conditional on a mainboard whitelist/blacklist?  E.g., I
know the mapping on my mainboard is correct and I can get
that info from DMI.  The thing is, it's very hard to know
what DIMM went bad from the bank/rank/controller info
in the dmesg output.

What do you think?  It's a lot of work, but it may be
worth it?

Arthur

> > -Andi (who can just see people replacing the wrong DIMMs and
> > then blaming Linux)
> >
> >
> 
> 
> W1DUG
> 
> -------------------------------------------------------------------------
> Check out the new SourceForge.net Marketplace.
> It's the best place to buy or sell services for
> just about anything Open Source.
> http://sourceforge.net/services/buy/index.php
> _______________________________________________
> bluesmoke-devel mailing list
> bluesmoke-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/bluesmoke-devel
