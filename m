Return-Path: <linux-kernel-owner+w=401wt.eu-S1759172AbXFGIv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759172AbXFGIv4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 04:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753747AbXFGIvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 04:51:49 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39202 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbXFGIvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 04:51:48 -0400
Date: Thu, 7 Jun 2007 10:51:47 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Message-ID: <20070607085147.GC15226@one.firstfloor.org>
References: <200706061229.24486.jesse.barnes@intel.com> <200706061620.10627.jesse.barnes@intel.com> <Pine.LNX.4.64.0706061923470.2716@p34.internal.lan> <200706061627.46421.jesse.barnes@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706061627.46421.jesse.barnes@intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 04:27:46PM -0700, Jesse Barnes wrote:
> On Wednesday, June 6, 2007 4:24 pm Justin Piszcz wrote:
> > > The mem= approach though looks slightly off, but I haven't looked
> > > at x86_64's mem= handling to see why.  From a high level though,
> > > adjusting end_pfn is the right thing to do, since theoretically
> > > mem= could choose to make holes in your low memory and keep your
> > > high memory in the allocation pools (though it's not generally
> > > implemented this way).
> > >
> > > Jesse
> >
> > Ahh, ok!  Sounds great, I will keep running the kernel with your
> > patch without mem= and let you know if I see any issues.
> >
> > Chances of getting this into 2.6.22-rc5?
> 
> I'm not sure it's appropriate for -rc5 since it mucks around with some 
> early boot ordering, but I'll leave that to Andi, since it does address 
> some real bugs people have been seeing.

I don't think the patch is suitable for merging at this time. Perhaps
if it survives some time in -mm* / 2.6.23* it could be backported
in a later 2.6.22 stable release. But right now it definitely
needs more testing and addressing of my review comments.

> Can we add your "Tested-by:  Justin Piszcz <jpiszcz@lucidpixels.com>" to 
> the patch? :)

All such headers are only for the trail of blame and do you want to blame
Justin if anything goes wrong? Perhaps it should rather have a 
Blame-to: <whoever wrote Justin/Jesse's BIOS> but that also wouldn't 
help without concrete contact points.

-ANdi
