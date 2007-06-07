Return-Path: <linux-kernel-owner+w=401wt.eu-S933859AbXFGRd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933859AbXFGRd6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 13:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934461AbXFGRdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 13:33:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:27498 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934421AbXFGRdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 13:33:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,395,1175497200"; 
   d="scan'208";a="236712140"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Date: Thu, 7 Jun 2007 10:33:22 -0700
User-Agent: KMail/1.9.6
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <200706061229.24486.jesse.barnes@intel.com> <200706061627.46421.jesse.barnes@intel.com> <20070607085147.GC15226@one.firstfloor.org>
In-Reply-To: <20070607085147.GC15226@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706071033.22818.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 7, 2007 1:51 am Andi Kleen wrote:
> On Wed, Jun 06, 2007 at 04:27:46PM -0700, Jesse Barnes wrote:
> > On Wednesday, June 6, 2007 4:24 pm Justin Piszcz wrote:
> > > > The mem= approach though looks slightly off, but I haven't
> > > > looked at x86_64's mem= handling to see why.  From a high level
> > > > though, adjusting end_pfn is the right thing to do, since
> > > > theoretically mem= could choose to make holes in your low
> > > > memory and keep your high memory in the allocation pools
> > > > (though it's not generally implemented this way).
> > > >
> > > > Jesse
> > >
> > > Ahh, ok!  Sounds great, I will keep running the kernel with your
> > > patch without mem= and let you know if I see any issues.
> > >
> > > Chances of getting this into 2.6.22-rc5?
> >
> > I'm not sure it's appropriate for -rc5 since it mucks around with
> > some early boot ordering, but I'll leave that to Andi, since it
> > does address some real bugs people have been seeing.
>
> I don't think the patch is suitable for merging at this time. Perhaps
> if it survives some time in -mm* / 2.6.23* it could be backported
> in a later 2.6.22 stable release. But right now it definitely
> needs more testing and addressing of my review comments.
>
> > Can we add your "Tested-by:  Justin Piszcz
> > <jpiszcz@lucidpixels.com>" to the patch? :)
>
> All such headers are only for the trail of blame and do you want to
> blame Justin if anything goes wrong? Perhaps it should rather have a
> Blame-to: <whoever wrote Justin/Jesse's BIOS> but that also wouldn't
> help without concrete contact points.

I think that header would be Lame-workaround-needed-because-of: 
<bad.bios.writer@foo.bar>. :)  The idea of tested-by is to give people 
a clue about who would be able to test any changes in the area 
affected.  So far from blaming Justin, it would give him credit for all 
his testing, and let people know that he might be able to test similar 
patches in the future.  I think it's worthwhile to track that...

Jesse
