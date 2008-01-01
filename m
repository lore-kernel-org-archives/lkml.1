Return-Path: <linux-kernel-owner+w=401wt.eu-S1754515AbYAAO5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbYAAO5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 09:57:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752253AbYAAO52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 09:57:28 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:56790 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185AbYAAO51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 09:57:27 -0500
Date: Tue, 1 Jan 2008 16:57:14 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] remove CONFIG_EXPERIMENTAL
Message-ID: <20080101145713.GV2360@does.not.exist>
References: <20080101134809.GK2360@does.not.exist> <20080101142623.GA3592@elte.hu> <20080101143022.664e8894@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080101143022.664e8894@the-village.bc.nu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 01, 2008 at 02:30:22PM +0000, Alan Cox wrote:
> On Tue, 1 Jan 2008 15:26:23 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Adrian Bunk <bunk@kernel.org> wrote:
> > 
> > > This patch removes the EXPERIMENTAL option and all dependencies on 
> > > EXPERIMENTAL since they are pointless.
> > 
> > agreed. CONFIG_BROKEN has real use - but CONFIG_EXPERIMENTAL is pretty 
> > pointless in the 90-days kernel development model.
> 
> Then I need a replacement equivalent for the ATA layer and all the other
> drivers using it to indicate stuff that *IS* experimental, or not yet
> known to be highly robust. Drivers are not the same as core code Ingo and
> the world driver writers live in is very different to the one you operate
> in as is clearly shown by this and by the _p discussion.
> 
> Still NAK.  As the alternative is
> 
> CONFIG_ATA_EXPERIMENTAL, CONFIG_NET_EXPERIMENTAL,
> CONFIG_VIDEO_EXPERIMENTAL, ... all being added by developers

But this alternative is actually _better_.

The point is that e.g. a user having to enable CONFIG_ATA_EXPERIMENTAL 
for getting his hardware supported does not necessarily want to see 
options for experimental congestion control algorithms that might be 
made available by CONFIG_NET_EXPERIMENTAL.

> We will also need experimental badly in future when the EU liability
> rules (and probably the US ones in a similar time scale) change so that
> liability applies to software, because then it will be very important to
> clearly label code that is experimental or development code as such.

Whatever that will imply for free software projects is something 
completely different from what our current CONFIG_EXPERIMENTAL
mess does.

> Alan

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

