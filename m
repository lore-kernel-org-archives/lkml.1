Return-Path: <linux-kernel-owner+w=401wt.eu-S1753469AbXDITt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbXDITt7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 15:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753476AbXDITt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 15:49:59 -0400
Received: from vms048pub.verizon.net ([206.46.252.48]:42009 "EHLO
	vms048pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbXDITt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 15:49:58 -0400
Date: Mon, 09 Apr 2007 15:49:51 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: I give up
In-reply-to: <17946.29660.368403.553290@smtp.charter.net>
To: linux-kernel@vger.kernel.org
Cc: "John Stoffel" <john@stoffel.org>, Jeff Garzik <jeff@garzik.org>
Message-id: <200704091549.51805.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200704091007.58535.gene.heskett@gmail.com>
 <200704091137.01336.gene.heskett@gmail.com>
 <17946.29660.368403.553290@smtp.charter.net>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 April 2007, John Stoffel wrote:
>>>>>> "Gene" == Gene Heskett <gene.heskett@gmail.com> writes:
>
>Gene> On Monday 09 April 2007, Jeff Garzik wrote:
>>> Gene Heskett wrote:
>>>> Now the 64k$ question: While running with LVM2 managed disks, is it
>>>> possible to run without dm_mod, the device-mapper?  If so, please
>>>> tell me how to achieve this.
>>>
>>> No; device mapper is the kernel portion of LVM2.
>>>
>>> Jeff, who actively avoids LVM on home computers
>
>Gene> Ya shoulda warned me.  :-)
>
>Gene> It should have lots bigger warning labels, in bright red
>Gene> self-illuminating signs, than it does.  It in fact seems to work
>Gene> well, but it is a major breakage for some common apps, like
>Gene> doing backups...
>
>>From the GNU info doc on the tar program:
>
>    Metadata stored in snapshot files include device numbers, which,
>    obviously is supposed to be a non-volatile value. However, it turns
>    out that NFS devices have undependable values when an automounter
> gets in the picture. This can lead to a great deal of spurious
> redumping in incremental dumps, so it is somewhat useless to compare
> two NFS devices numbers over time. The solution implemented currently
> is to considers all NFS devices as being equal when it comes to
> comparing directories; this is fairly gross, but there does not seem to
> be a better way to go.
>
>This to me, seems to be another borkage of the tar program.  Can you
>tell Amanda to use 'dump/restore' instead of tar instead?  Or heck,
>just move to Bacula, it's smarter than amanda/tar and it supports
>writing to DVDs, etc.  http://www.bacula.org
>
I wouldn't touch dump/restore with a 50 foot pole, particularly since I 
have serious doubts about it viability in the LVM environment.

For those of you with big tapes that can hold a complete dump of every 
partition (and partitions is the only way dump works in case some have 
forgotten), go ahead and use dump/restore.  Tar quite simply, allows one 
to break his backup files down into small enough pieces that a tape drive 
that's only 20% of the system drives size is totally usable.  I ran dds2 
tapes for a long time, and it wasn't at all unusual to have amanda fill 
those to the 95% or better mark every night for a week running, without 
ever hitting EOT.

>This tar borkness is pretty annoying, since Amanda (from the docs
>page) only keeps indexes in terms of host/filesystem/path/date,
>nothing about the major/minor (device) numbers.
>
>It just re-inforces my desire to never use Amanda again.

Your call, that's what this linux thing is all about.  But do I not recall 
your name from the amanda lists at some point in the last 8+ years?
>
>John
>john@stoffel.org

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
<Culus> OH MY GOD NOT A RANDOM QUOTE GENERATOR
<netgod> surely you didnt think that was static? how lame would that 
be? :-)
