Return-Path: <linux-kernel-owner+w=401wt.eu-S1753103AbXDENWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103AbXDENWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 09:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbXDENWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 09:22:32 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:36936 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103AbXDENWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 09:22:30 -0400
X-ORBL: [67.117.73.34]
Date: Thu, 5 Apr 2007 09:21:48 -0400
From: Tony Lindgren <tony@atomide.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/90] Post 2.6.21 OMAP update
Message-ID: <20070405132144.GC24297@atomide.com>
References: <11757088774110-git-send-email-tony@atomide.com> <20070404182728.GK29129@atomide.com> <20070404113925.da221efc.randy.dunlap@oracle.com> <20070404184455.GL29129@atomide.com> <20070404224448.0ff60ed2@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070404224448.0ff60ed2@the-village.bc.nu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Alan Cox <alan@lxorguk.ukuu.org.uk> [070404 17:42]:
> > > That's only a problem when there are <too many> patches to be
> > > reviewed.  Hence, do more frequent postings of fewer patches per series.
> > > That will likely also get you more reviewers.
> > 
> > Yeah, I agree.. We've already missed two merge windows because of the
> > large patch set :( The problem is that patch set just keeps growing.
> 
> The other problem is that GIT patch sets are completely useless for
> merging and reviewing if you simply fire off a blast of 70 changesets.
> Each time you do it at least one gets queried or a NAK and the lot go in
> the bin again. Repeat 50 times...

Yeah, it is also big pain to maintain patchset this large.

> It would be enormously helpful if instead we got say 15 small patch sets
> which are independant so that a query or NAK means 14 sets get applied
> this time around not zero.

I was thinking about merging the patches together more, but the end result
would not be very readable, and we would lose the original author info.

Also trying to do this 15 small patches at time would make it hard
to have it all integrated within the two week merge window.

It would be nice to get to a situation where we only have 10 - 20 small
linux-omap patches ready for every merge window, and then send fixes
during the -rc series.

Regards,

Tony
