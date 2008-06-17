Return-Path: <linux-kernel-owner+w=401wt.eu-S1754114AbYFQFbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbYFQFbx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 01:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbYFQFbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 01:31:43 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:52214 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751594AbYFQFbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 01:31:42 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAMjnVkh5LG+u/2dsb2JhbACtWg
X-IronPort-AV: E=Sophos;i="4.27,656,1204464600"; 
   d="scan'208";a="128137216"
Date: Tue, 17 Jun 2008 15:31:34 +1000
From: Dave Chinner <david@fromorbit.com>
To: Miquel van Smoorenburg <mikevs@xs4all.net>
Cc: Oliver Pinter <oliver.pntr@gmail.com>, lists@ku-gbr.de,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       xfs@oss.sgi.com, xfs-masters@oss.sgi.com
Subject: Re: XFS internal error xfs_trans_cancel at line 1163 of file
	fs/xfs/xfs_trans.c
Message-ID: <20080617053134.GN3700@disturbed>
Mail-Followup-To: Miquel van Smoorenburg <mikevs@xs4all.net>,
	Oliver Pinter <oliver.pntr@gmail.com>, lists@ku-gbr.de,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
	xfs@oss.sgi.com, xfs-masters@oss.sgi.com
References: <20080612123031.21594jyk6rjc1lfk@imp.ku-gbr.de> <6101e8c40806120733m3c8647ccy149eb237e2c6d027@mail.gmail.com> <1213309629.29745.8.camel@localhost.localdomain> <20080613030841.GC3700@disturbed> <1213356518.8530.5.camel@n2o.xs4all.nl> <1213631406.19372.15.camel@n2o.xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213631406.19372.15.camel@n2o.xs4all.nl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2008 at 05:50:06PM +0200, Miquel van Smoorenburg wrote:
> On Fri, 2008-06-13 at 13:28 +0200, Miquel van Smoorenburg wrote:
> > On Fri, 2008-06-13 at 13:08 +1000, Dave Chinner wrote: 
> > > On Fri, Jun 13, 2008 at 12:27:09AM +0200, Miquel van Smoorenburg wrote:
> >
> > > > Linux transit5.news.xs4all.nl 2.6.25.6 #1 SMP Wed Jun 11 10:59:10 CEST
> > > > 2008 x86_64 GNU/Linux
> > > > 
> > > > Filesystem "sda4": XFS internal error xfs_trans_cancel at line 1163 of
> > > > file fs/xfs/xfs_trans.c.  Caller 0xffffffff880f1315
> > > > Pid: 3402, comm: diablo Not tainted 2.6.25.6 #1
> > > 
> > > This commit in 2.6.26 will probably fix it.
> > > 
> > > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=75de2a91c98a6f486f261c1367fe59f5583e15a3
> > 
> > "At ENOSPC, we can get a filesystem shutdown due to a cancelling a dirty
> > transaction in xfs_mkdir or xfs_create."
> > 
> > But The filesystem is only used for 35%. It might have hit 100% somewhere in
> > the recent past though (a few reboots ago).
> > I've applied the patch to 2.6.25.6 just in case, I'll let it run over
> > the weekend to see what happens.
> 
> Well, the box has been up for 3 days now. When this problem first
> appeared it only stayed up for a day max, so I'm reasonably positive
> it's fixed.

Cool.

> The patch applies cleanly to 2.6.25.6 - perhaps it should go into
> -stable.

For a bug that's been around for more than 3 years and reported by
only a handful of ppl? I'd prefer not to....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
