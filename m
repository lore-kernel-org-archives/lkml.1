Return-Path: <linux-kernel-owner+w=401wt.eu-S1751023AbXBMK3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751023AbXBMK3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 05:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750994AbXBMK3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 05:29:22 -0500
Received: from mpemail.mpe.mpg.de ([130.183.137.110]:57804 "EHLO
	mpemail.mpe.mpg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbXBMK3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 05:29:21 -0500
From: "Martin A. Fink" <fink@mpe.mpg.de>
Organization: MPE
To: Matthias Schniedermeyer <ms@citd.de>, linux-kernel@vger.kernel.org
Subject: Re: SATA-performance: Linux vs. FreeBSD
Date: Tue, 13 Feb 2007 11:29:18 +0100
User-Agent: KMail/1.8
References: <200702121502.17130.fink@mpe.mpg.de> <200702131025.15964.fink@mpe.mpg.de> <45D19014.5080900@citd.de>
In-Reply-To: <45D19014.5080900@citd.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702131129.19270.fink@mpe.mpg.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 13. Februar 2007 11:16 schrieben Sie:
> Martin A. Fink wrote:
> > Am Dienstag, 13. Februar 2007 00:31 schrieben Sie:
> >> Martin A. Fink wrote:
> >>> I have to store big amounts of data coming from 2 digital cameras to 
disk. 
> >>> Thus I have to write blocks of around 1 MB at 30 to 50 frames per second 
> >>> for 
> >>> a long period of time. So it is important for me that the harddisk drive 
> >>> is 
> >>> reliable in the sense of "if it is capable of 50 MB/s then it should 
> >>> operate 
> >>> at this speed. Constantly."
> >> The good old handful of suggestions:
> >>
> >> - Use a dedicated disc for the task.
> > 
> > I used a dedicated disk for this task. No one else besides the task is 
writing 
> > to it!
> 
> OK.
> 
> >> - Use an empty disc so there is no fragmentation.
> > 
> > All tests were performed on empty disk!
> 
> OK.
> 
> >> - Buy a bigger disk, they have high bandwidths.
> > 
> > I have a flash disk from a manufacturer who grants me 48 MB/s. And FreeBSD 
as 
> > well as Windows reach this value. Only Linux 2.6.18 is far away from it 
(42 
> > MB/s)
> 
> Even 48MB/s is quite low.
> I've reached up to 70MB/s with a single 500GB Seagate model and even my 
older HDDs all reach 60MB/s (at least on the outer cylinders)
> But i haven't tested any "sync/fsync" in between, only after.

Please Read Carefully! I talk about flash disk, not normal harddisks. There 
are no mechanical parts in flash disks, only flash memory. And therefore 
48MB/s is excellent (compared to all other available disks)

> 
> >> - Buy a more "specialized" disc.
> > 
> > see above
> > 
> >>   for e.x.: Western Digital Raptor X(*) a 150GB, 10-KRPM S-ATA disc.
> >> - Buy several discs and use RAID 0
> >>   or alternate between discs when writing.
> > 
> > What I have to build is an application for the International Space Station 
> > ISS. I am limited with power and space. So If the disk is able to write 
> > constantly 48 MB/s then the Operating System should do this!
> 
> OK. That appears to be a serious constraint.
> Do HDDs cope well with zero gravity?

Yes and no. Yes: standard desktop HDDs are unproblematic. Laptop HDDs have 
g-force shock hardware that works on zero-g detection and thus Laptop HDDs 
can't be used in space. At least modern ones can't...

> At least the SSD won't have a problem with that. ;-)
> 
> > The problem is: FreeBSD is fast, but lacks of some special drivers. Linux 
has 
> > all drivers but access to harddisk is unpredictable and thus unreliable!
> > What can I do??
> 
> Personally i haven't had such bad write speeds in years. Taking USB 
connected and/or encrypted partitions aside.
> But on the other hand: I don't sync(fsync) until i have to.

If you don't have to - no problem. But if you use filesystem you do a fsync 
every time you close the file (and filesize is less then 1-2 GB)
> And personally i have good (and constant bandwidth) experience using XFS as 
a filesystem.
> (I have 41 HDDs with a total capacity of 10.5 TB, performance is quite 
important for me.)
> 
> Also you have skipped the information how the images "arrive" on the system 
(PCI(e) card?), that may be important for an "end to end" view of the 
problem.

Images arrive via Gigabit Ethernet. GigE Vision standard. (PCIe x4)
> 
> And what's also missing. What is "a long period of time".
> Calculating best-case with the SSD:
> 27GB divided by 30MB/s only gives a bit more than 15 Minutes.
> And worst case with 50MB/s is less than 10 Minutes.

Well. The testdrive has 27GB. The final drive will have 225 GB. And there will 
be 3 cameras and thus 3 disks. This means we talk about 140 MB/s for around 
90 minutes.
For space applications with low power but high performance this is a long 
time... ;-)
> 
> 
> 
> 
> 
> -- 
> Real Programmers consider "what you see is what you get" to be just as
> bad a concept in Text Editors as it is in women. No, the Real Programmer
> wants a "you asked for it, you got it" text editor -- complicated,
> cryptic, powerful, unforgiving, dangerous.
> 
> 

-- 
Dipl. Physiker
Martin Anton Fink
Max Planck Institute for extraterrestrial Physics
Giessenbachstrasse
85741 Garching
Germany
Tel. +49-(0)89-30000-3645
Fax. +49-(0)89-30000-3569
