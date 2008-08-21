Return-Path: <linux-kernel-owner+w=401wt.eu-S1758867AbYHULMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758867AbYHULMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 07:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756228AbYHULMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 07:12:08 -0400
Received: from web32606.mail.mud.yahoo.com ([68.142.207.233]:32128 "HELO
	web32606.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756095AbYHULMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 07:12:06 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Aug 2008 07:12:06 EDT
X-YMail-OSG: qetMBQEVM1lk4mM2hvvjt.H5l1qV92z60H59hMYWaKUZRPSYRrkO2f4_Y4Efh1cRkg--
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1042.48 YahooMailWebService/0.7.218.2
Date: Thu, 21 Aug 2008 04:05:21 -0700 (PDT)
From: Martin Knoblauch <knobi@knobisoft.de>
Subject: Re: XFS vs Elevators (was Re: [PATCH RFC] nilfs2: continuous snapshotting file system)
To: Dave Chinner <david@fromorbit.com>,
       Szabolcs Szakacsits <szaka@ntfs-3g.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <293210.50030.qm@web32606.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----

> From: Dave Chinner <david@fromorbit.com>
> To: Szabolcs Szakacsits <szaka@ntfs-3g.org>; Andrew Morton <akpm@linux-foundation.org>; linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; xfs@oss.sgi.com
> Sent: Thursday, August 21, 2008 10:25:32 AM
> Subject: Re: XFS vs Elevators (was Re: [PATCH RFC] nilfs2: continuous snapshotting file system)
> 
> On Thu, Aug 21, 2008 at 04:04:18PM +1000, Dave Chinner wrote:
> > On Thu, Aug 21, 2008 at 03:15:08PM +1000, Dave Chinner wrote:
> > > On Thu, Aug 21, 2008 at 05:46:00AM +0300, Szabolcs Szakacsits wrote:
> > > > On Thu, 21 Aug 2008, Dave Chinner wrote:
> > > > Everything is default.
> > > > 
> > > >   % rpm -qf =mkfs.xfs
> > > >   xfsprogs-2.9.8-7.1 
> > > > 
> > > > which, according to ftp://oss.sgi.com/projects/xfs/cmd_tars, is the 
> > > > latest stable mkfs.xfs. Its output is
> > > > 
> > > > meta-data=/dev/sda8              isize=256    agcount=4, agsize=1221440 
> blks
> > > >          =                       sectsz=512   attr=2
> > > > data     =                       bsize=4096   blocks=4885760, imaxpct=25
> > > >          =                       sunit=0      swidth=0 blks
> > > > naming   =version 2              bsize=4096  
> > > > log      =internal log           bsize=4096   blocks=2560, version=2
> > > >          =                       sectsz=512   sunit=0 blks, lazy-count=0
> > > > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > > 
> > > Ok, I thought it might be the tiny log, but it didn't improve anything
> > > here when increased the log size, or the log buffer size.
> > 
> > One thing I just found out - my old *laptop* is 4-5x faster than the
> > 10krpm scsi disk behind an old cciss raid controller.  I'm wondering
> > if the long delays in dispatch is caused by an interaction with CTQ
> > but I can't change it on the cciss raid controllers. Are you using
> > ctq/ncq on your machine?  If so, can you reduce the depth to
> > something less than 4 and see what difference that makes?
> 
> Just to point out - this is not a new problem - I can reproduce
> it on 2.6.24 as well as 2.6.26. Likewise, my laptop shows XFS
> being faster than ext3 on both 2.6.24 and 2.6.26. So the difference
> is something related to the disk subsystem on the server....
> 
Hi Dave,

 just curious - which CCISS controller and and what kind of disk configuration are you using.

Cheers
Martin

