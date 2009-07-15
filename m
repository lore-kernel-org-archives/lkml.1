Return-Path: <linux-kernel-owner+w=401wt.eu-S1753867AbZGOKIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbZGOKIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 06:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753443AbZGOKIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 06:08:55 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:30807 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426AbZGOKIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 06:08:54 -0400
X-Greylist: delayed 580 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Jul 2009 06:08:53 EDT
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=NgnNa4BYe58A:10 a=w4iE+TBsmj5y1WloLYF40w==:17
 a=r6rVttBYdIM1qgCwhnkA:9 a=9vL-GUva0kOrnu-Y5AcA:7
 a=pV5SmESTpSbM3mq3ec6756A75DIA:4
From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Reply-To: tfjellstrom@shaw.ca
To: linux-kernel@vger.kernel.org
Subject: Re: Possible Suspend to Ram bug?
Date: Wed, 15 Jul 2009 03:59:12 -0600
User-Agent: KMail/1.12.90 (Linux/2.6.29-2-amd64; KDE/4.3.60; x86_64; svn-990302; 2009-06-30)
Cc: Jiri Kosina <jkosina@suse.cz>
References: <200907100458.27410.tfjellstrom@shaw.ca> <200907140417.12847.tfjellstrom@shaw.ca> <alpine.LRH.2.00.0907141752580.27150@twin.jikos.cz>
In-Reply-To: <alpine.LRH.2.00.0907141752580.27150@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907150359.12187.tfjellstrom@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue July 14 2009, Jiri Kosina wrote:
> On Tue, 14 Jul 2009, Thomas Fjellstrom wrote:
> > On Fri July 10 2009, Thomas Fjellstrom wrote:
> > > I've recently gotten a new OCZ Vertex 30G SSD and have noticed that it
> > > will flip out the second time linux wakes up from "suspend to ram".
> > >
> > > The system will run fine for days or weeks, so long as it isn't waking
> > > up a second StR.
> > >
> > > Here is an example error that I get from the device (my root / device):
> > >
> > > [42018.455204] sd 0:0:0:0: [sda] Unhandled error code
> > > [42018.455208] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET
> > > driverbyte=DRIVER_OK,SUGGEST_OK
> > > [42018.455215] end_request: I/O error, dev sda, sector 12583031
> > > [42018.455221] EXT3-fs error (device sda2): ext3_get_inode_loc: unable
> > > to read inode block - inode=391005, block=1572871
> > >
> > > At that point using my / fs is pretty much impossible. Every single app
> > > fails to launch with an I/O Error, about the only command I can run in
> > > that state is "dmesg" in an existing konsole.
> > >
> > > I'm currently using 2.6.29-2-amd64 from debian, and am running on a
> > > Gigabyte MA790FXT-UD5P, with a AMD Phenom II X4 810 cpu, and 4G ram.
> > >
> > > One interesting thing to note, the file system on the Vertex SSD
> > > reports as clean to fsck on the next boot, while my /home which is on a
> > > Seagate 7200.12 drive reports with several orphaned inodes (every
> > > single time). And that's regardless if I use ALT+SYSRQ+S/U to try and
> > > sync everything. Also, ALT+SYSRQ+B doesn't work at that point, only
> > > ALT+SYSRQ+O or using the system power/reset buttons will work.
> > >
> > > I'm attaching the full log I was able to save from dmesg (over nfs,
> > > luckily that worked).
> >
> > Anyone have a clue what might be wrong?
>
> First please try to reproduce with recent kernel (2.6.30 at least,
> 2.6.31-rc3 preferrably).

I'll try with debian's 2.6.30 first. But there's a small issue with that, .30 
and .31 seem to have some performance regressions according to sites like 
phoronix.

-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
