Return-Path: <linux-kernel-owner+w=401wt.eu-S1755121AbYJ3Wnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121AbYJ3Wnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 18:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbYJ3Wnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 18:43:45 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:41801 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751421AbYJ3Wno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 18:43:44 -0400
Date: Thu, 30 Oct 2008 23:43:31 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@strlen.de>
To: Pavel Machek <pavel@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       randy.dunlap@oracle.com
Subject: Re: [PATCH 1/8] Add scripts/get_maintainer.pl
Message-ID: <20081030224331.GA30814@strlen.de>
References: <1224803366-6478-1-git-send-email-joe@perches.com> <ab48bcafb1ceab1c0d53e93781605603cfabf6dc.1224802312.git.joe@perches.com> <20081027155254.a710c779.akpm@linux-foundation.org> <20081030104136.GB32389@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081030104136.GB32389@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> > Also, this:
> > 
> >  MAINTAINERS | 1096 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 1094 insertions(+), 2 deletions(-)
> > 
> > isn't practical for me or Stephen to carry, I'm afraid.  That's
> > probably the most-patched file in the kernel.  This will need to be a
> > direct you->Linus thing.
> > 
> > I think the feature is sorely needed and will prove useful.
> 
> Would you be willing to merge the scripts etc, leaving only
> MAINTAINERS file for direct merge with Linus, preferably at the -rc5
> or something?
I still think that the source files should (additionally) be parsed
somehow, too.  Something like

	/*
	 * TOPIC
	 * P: A. U. Thor <author@examp.l.e>
	 * M: lkml@kernel.org
	 */

at the beginning of a file.  The advantage is that MAINTAINERS doesn't
need to have an entry for each driver and so the F: field cannot become
inconsistent and the author doesn't need to bother getting the entry
into MAINTAINERS---just the driver file is enough.
 
Best regards
Uwe
