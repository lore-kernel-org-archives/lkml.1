Return-Path: <linux-kernel-owner+w=401wt.eu-S1756254AbYJPXtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254AbYJPXtw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 19:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbYJPXtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 19:49:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:48513 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbYJPXto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 19:49:44 -0400
Subject: Re: [PATCH 1/1] edac cell: fix incorrect edac_mode
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dougthompson@xmission.com, linux-kernel@vger.kernel.org, stable@kernel.org
In-Reply-To: <20081016163532.273ea02f.akpm@linux-foundation.org>
References: <48f78434.Hj5aU4wgiL/VVJvn%dougthompson@xmission.com>
	 <20081016163532.273ea02f.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 17 Oct 2008 10:49:02 +1100
Message-Id: <1224200942.7654.29.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-16 at 16:35 -0700, Andrew Morton wrote:
> Well that sounds a bit wrong of it.
> 
> > Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Signed-off-by: Doug Thompson <dougthompson@xmission.com>
> > ---
> > 
> >  drivers/edac/cell_edac.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > --- linux-work.orig/drivers/edac/cell_edac.c  2008-10-15
> 15:35:21.000000000 +1100
> > +++ linux-work/drivers/edac/cell_edac.c       2008-10-15
> 15:35:29.000000000 +1100
> > @@ -142,7 +142,7 @@ static void __devinit cell_edac_init_csr
> >               csrow->nr_pages = (r.end - r.start + 1) >> PAGE_SHIFT;
> >               csrow->last_page = csrow->first_page + csrow->nr_pages
> - 1;
> >               csrow->mtype = MEM_XDR;
> > -             csrow->edac_mode = EDAC_FLAG_EC | EDAC_FLAG_SECDED;
> > +             csrow->edac_mode = EDAC_SECDED;
> >               dev_dbg(mci->dev,
> >                       "Initialized on node %d, chanmask=0x%x,"
> >                       " first_page=0x%lx, nr_pages=0x%x\n",
> 
> Seems to be needed in 2.6.27.x?  Applies OK to 2.6.26, 2.6.25, etc.
> 
> How far back shold we port this?

.25 sounds fine.

Cheers,
Ben.


