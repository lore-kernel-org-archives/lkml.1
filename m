Return-Path: <linux-kernel-owner+w=401wt.eu-S1759624AbZATWQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759624AbZATWQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 17:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753814AbZATWQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 17:16:03 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48620 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbZATWQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 17:16:01 -0500
Date: Tue, 20 Jan 2009 23:18:08 +0100
From: Pavel Machek <pavel@suse.cz>
To: Eric Sesterhenn <snakebyte@gmx.de>
Cc: Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       linux-btrfs@vger.kernel.org
Subject: Re: Warning and BUG with btrfs and corrupted image
Message-ID: <20090120221808.GA2320@elf.ucw.cz>
References: <20090113142147.GE16333@alice> <1231857643.29164.28.camel@think.oraclecorp.com> <20090113144307.GF16333@alice> <20090118174035.GG1944@ucw.cz> <20090120063150.GC5854@alice> <20090120101119.GB10158@disturbed> <20090120101503.GC17377@alice> <20090120125944.GC10158@disturbed> <20090120173455.GC21339@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090120173455.GC21339@alice>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-01-20 18:34:55, Eric Sesterhenn wrote:
> * Dave Chinner (david@fromorbit.com) wrote:
> > On Tue, Jan 20, 2009 at 11:15:03AM +0100, Eric Sesterhenn wrote:
> > > * Dave Chinner (david@fromorbit.com) wrote:
> > > > On Tue, Jan 20, 2009 at 07:31:50AM +0100, Eric Sesterhenn wrote:
> > > > > * Pavel Machek (pavel@suse.cz) wrote:
> > > > > > Does ext2/3 and vfat survive that kind of attacks? Those are 'in
> > > > > > production' and should survive it...
> > > > > 
> > > > > I regularly (once or twice a week) test 100 corrupted images of 
> > > > > vfat, udf, msdos, swap, iso9660, ext2, ext3, ext4, minix, bfs, befs,
> > > > > hfs, hfs+, qnx4, affs and cramfs on each of my two test machines.
> > > > 
> > > > Any reason you are not testing XFS in that set?
> > > 
> > > So far the responses from xfs folks have been disappointing, if you are
> > > interested in bugreports i can send you some.
> > 
> > Sure I am.  It would be good if you could start testing XFS along
> > with all the other filesystems and report anything you find.
> 
> Ok, i wont report stuff with only xfs-internal backtraces from
> xfs_error_report() or are they interesting to you?
> 
> This occurs during mount, box is dead afterwards
> Image can be found here :
> http://www.cccmz.de/~snakebyte/xfs.11.img.bz2
> I see this every ~10 images, which makes further testing hard :)

BTW have you considered trying to run fsck.* on such images? I had lot
of fun with e2fsck/e3fsck/fsck.vfat.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
