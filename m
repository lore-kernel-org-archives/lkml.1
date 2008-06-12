Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647AbYFLAVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbYFLAVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 20:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755917AbYFLAVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 20:21:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:37684 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215AbYFLAVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 20:21:20 -0400
Date: Wed, 11 Jun 2008 17:17:24 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: ldp/staging/driver-core (Was: Re: linux-next: Tree for June 11)
Message-ID: <20080612001724.GA8359@kroah.com>
References: <20080611193840.08a35b14.sfr@canb.auug.org.au> <20080611185527.GB5516@kroah.com> <20080612100520.43c39e3d.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080612100520.43c39e3d.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 10:05:20AM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> On Wed, 11 Jun 2008 11:55:27 -0700 Greg KH <greg@kroah.com> wrote:
> >
> > On Wed, Jun 11, 2008 at 07:38:40PM +1000, Stephen Rothwell wrote:
> > > Hi all,
> > > 
> > > Changes since next-20080610:
> > > 
> > > Dropped trees (temporary): ldp (it is unfetchable - probably something to
> > > do with the new Staging tree), block (it just has too many conflicts and
> > > breaks the powerpc build).
> > 
> > Yes, I've dropped "ldp" from my 'gregkh' set of patches/trees, they
> > should be pulled in from the -staging tree, which would be great if you
> > could add to the end of the -next tree.
> 
> I was under the impression that the stuff in the ldp tree was for
> inclusion in 2.6.27.  If so, then that tree should still exist (for
> inclusion in linux-next) or the drivers that were in the ldp tree should
> be included in some other tree(s) that is (are) included in linux-next
> (Staging is for stuff that isn't ready yet, right?).

Yes, but if there are only 1 or 2 patches that are ready to go upstream
in -next, and you are pulling the whole -staging tree in, it doesn't
make much sense to keep the two separate, so I just put them at the top
of the staging tree.

> I will try to figure out what I think about Staging today.

Thanks.

> > I've also removed some of the larger patches in the driver-core tree
> > that were causing you merge/build errors, they should be all resolved
> > now.
> 
> Thanks, but a better plan (which I hope you and Kay have considered) is
> to break up the ones that only depeneded on dev_name and dev_set_name and
> send the parts to the appropriate subsystems (since dev_name and
> dev_set_name) are both in upstream now).

That's exactly what we are going to do.  I removed them from my tree for
now to prevent these kinds of merge errors.

thanks,

greg k-h
