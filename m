Return-Path: <linux-kernel-owner+w=401wt.eu-S1767143AbXDESEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767143AbXDESEL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 14:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767191AbXDESEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 14:04:10 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:28519 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767192AbXDESEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 14:04:08 -0400
X-ORBL: [67.117.73.34]
Date: Thu, 5 Apr 2007 14:03:36 -0400
From: Tony Lindgren <tony@atomide.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/90] Post 2.6.21 OMAP update
Message-ID: <20070405180334.GW24297@atomide.com>
References: <11757088774110-git-send-email-tony@atomide.com> <20070404182728.GK29129@atomide.com> <20070404113925.da221efc.randy.dunlap@oracle.com> <20070404184455.GL29129@atomide.com> <20070404224448.0ff60ed2@the-village.bc.nu> <20070405132144.GC24297@atomide.com> <adar6qybx4y.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adar6qybx4y.fsf@cisco.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Roland Dreier <rdreier@cisco.com> [070405 12:32]:
>  > > It would be enormously helpful if instead we got say 15 small patch sets
>  > > which are independant so that a query or NAK means 14 sets get applied
>  > > this time around not zero.
>  > 
>  > I was thinking about merging the patches together more, but the end result
>  > would not be very readable, and we would lose the original author info.
>  > 
>  > Also trying to do this 15 small patches at time would make it hard
>  > to have it all integrated within the two week merge window.
> 
> I think you misunderstood the suggestion.  The idea is that you leave
> the patches basically as-is (modulo any small tweaks required by
> reordering), but rather than one 90-patch series, you divide the
> patches up into independent subsets.  Maybe something like
> 
>  - basic OMAP fixes for bugs in core support
>  - Palm platform stuff
>  - ...other platform stuff
>  - new features
> 
> etc.  then it's easier for people to review the stuff they're
> interested in, and it's easier for at least some of the subsets to get
> applied (which reduces your backlog).

Hmm, yeah I'll see if I could group them a bit. The problem there
is that the patch series contains multiple rounds of "add and fix"
cycles. Pretty much all the non-dependant fixes have already been
applied, BTW.

Tony
