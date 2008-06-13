Return-Path: <linux-kernel-owner+w=401wt.eu-S1759374AbYFMDI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759374AbYFMDI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 23:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757191AbYFMDIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 23:08:46 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:40858 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757108AbYFMDIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 23:08:45 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAJ9+UUh5LG+u/2dsb2JhbACuZA
X-IronPort-AV: E=Sophos;i="4.27,635,1204464600"; 
   d="scan'208";a="125260641"
Date: Fri, 13 Jun 2008 13:08:41 +1000
From: Dave Chinner <david@fromorbit.com>
To: Miquel van Smoorenburg <mikevs@xs4all.net>
Cc: Oliver Pinter <oliver.pntr@gmail.com>, lists@ku-gbr.de,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       xfs@oss.sgi.com, xfs-masters@oss.sgi.com
Subject: Re: XFS internal error xfs_trans_cancel at line 1163 of file
	fs/xfs/xfs_trans.c
Message-ID: <20080613030841.GC3700@disturbed>
Mail-Followup-To: Miquel van Smoorenburg <mikevs@xs4all.net>,
	Oliver Pinter <oliver.pntr@gmail.com>, lists@ku-gbr.de,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
	xfs@oss.sgi.com, xfs-masters@oss.sgi.com
References: <20080612123031.21594jyk6rjc1lfk@imp.ku-gbr.de> <6101e8c40806120733m3c8647ccy149eb237e2c6d027@mail.gmail.com> <1213309629.29745.8.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213309629.29745.8.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2008 at 12:27:09AM +0200, Miquel van Smoorenburg wrote:
> On Thu, 2008-06-12 at 16:33 +0200, Oliver Pinter wrote:
> > add CC's
> > 
> > On 6/12/08, lists@ku-gbr.de <lists@ku-gbr.de> wrote:
> > > Hi!
> > >
> > > Today morning my server at home bailed out two times (reboot between):
> 
> > > Jun 12 07:23:40 zappa
> > > Jun 12 07:23:40 zappa xfs_force_shutdown(sda7,0x8) called from line
> > > 1164 of file fs/xfs/xfs_trans.c.  Return address = 0xffffffff802f4d8a
> > > Jun 12 07:23:40 zappa Filesystem "sda7": Corruption of in-memory data
> > > detected.  Shutting down filesystem: sda7
> > > Jun 12 07:23:40 zappa Please umount the filesystem, and rectify the
> > > problem(s)
> 
> Hmm, interesting. I'm seeing the same thing on one of my servers since I
> upgraded from 2.6.ancient (14 or so) to 2.6.25, while XFS otherwise has
> been very stable for me over the years:
> 
> Linux transit5.news.xs4all.nl 2.6.25.6 #1 SMP Wed Jun 11 10:59:10 CEST
> 2008 x86_64 GNU/Linux
> 
> Filesystem "sda4": XFS internal error xfs_trans_cancel at line 1163 of
> file fs/xfs/xfs_trans.c.  Caller 0xffffffff880f1315
> Pid: 3402, comm: diablo Not tainted 2.6.25.6 #1

This commit in 2.6.26 will probably fix it.

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=75de2a91c98a6f486f261c1367fe59f5583e15a3

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
