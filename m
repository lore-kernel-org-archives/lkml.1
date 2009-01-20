Return-Path: <linux-kernel-owner+w=401wt.eu-S1760609AbZATNAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760609AbZATNAB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 08:00:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754885AbZATM7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 07:59:51 -0500
Received: from ipmail04.adl2.internode.on.net ([203.16.214.57]:3538 "EHLO
	ipmail04.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754624AbZATM7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 07:59:50 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhICAAxXdUl5LBURgWdsb2JhbACUBQEBFiK2coVz
X-IronPort-AV: E=Sophos;i="4.37,295,1231075800"; 
   d="scan'208";a="288498822"
Date: Tue, 20 Jan 2009 23:59:44 +1100
From: Dave Chinner <david@fromorbit.com>
To: Eric Sesterhenn <snakebyte@gmx.de>
Cc: Pavel Machek <pavel@suse.cz>, Chris Mason <chris.mason@oracle.com>,
       linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: Warning and BUG with btrfs and corrupted image
Message-ID: <20090120125944.GC10158@disturbed>
Mail-Followup-To: Eric Sesterhenn <snakebyte@gmx.de>,
	Pavel Machek <pavel@suse.cz>, Chris Mason <chris.mason@oracle.com>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <20090113142147.GE16333@alice> <1231857643.29164.28.camel@think.oraclecorp.com> <20090113144307.GF16333@alice> <20090118174035.GG1944@ucw.cz> <20090120063150.GC5854@alice> <20090120101119.GB10158@disturbed> <20090120101503.GC17377@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090120101503.GC17377@alice>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 11:15:03AM +0100, Eric Sesterhenn wrote:
> * Dave Chinner (david@fromorbit.com) wrote:
> > On Tue, Jan 20, 2009 at 07:31:50AM +0100, Eric Sesterhenn wrote:
> > > * Pavel Machek (pavel@suse.cz) wrote:
> > > > Does ext2/3 and vfat survive that kind of attacks? Those are 'in
> > > > production' and should survive it...
> > > 
> > > I regularly (once or twice a week) test 100 corrupted images of 
> > > vfat, udf, msdos, swap, iso9660, ext2, ext3, ext4, minix, bfs, befs,
> > > hfs, hfs+, qnx4, affs and cramfs on each of my two test machines.
> > 
> > Any reason you are not testing XFS in that set?
> 
> So far the responses from xfs folks have been disappointing, if you are
> interested in bugreports i can send you some.

Sure I am.  It would be good if you could start testing XFS along
with all the other filesystems and report anything you find.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
