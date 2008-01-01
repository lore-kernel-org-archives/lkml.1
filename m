Return-Path: <linux-kernel-owner+w=401wt.eu-S1754563AbYAAP5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbYAAP5B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:57:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759812AbYAAPy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:54:58 -0500
Received: from vms040pub.verizon.net ([206.46.252.40]:59774 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759809AbYAAPy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:54:56 -0500
Date: Tue, 01 Jan 2008 10:54:39 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: semi-regular plea for stable device mapping
To: linux-kernel@vger.kernel.org
Message-id: <200801011054.40512.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-disposition: inline
User-Agent: KMail/1.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings;

Yesterday I built a new kernel with most of the disk driver stuff built in.  
It boots, I'm running it now, and I now have the libata stuff being detected 
by the kernel at boot time in the same order as an F8 distro kernel does.

BUT!  This defeats a fix I've had in my modprobe.conf for over a year now that 
gave the LVM stuff a stable major device # of 238, and now my LVM major is 
back to whatever mood the kernel is in, in this particular bootup case to 
#253.

It may now be stable for a bit at that number because I see that pktcdvd has 
been given a stable address of its own, apparently with a major of 10.  That 
was the wedgie that fscked things up originally for me.  But what else lurks 
in the deep end of this experimental pool, to play piranna with us again when 
we least expect it?

IMO we've been using LVM stuffs now for a long enough period that it should 
lose its experimental status, which apparently means its enumerated from 255 
down when found, getting the first vacant address and dependent on whats 
found before it, the major number can change on a per boot basis, just for 
something as innocent as plugging in a usb hard drive enclosure.

This drives tar up a wall because it uses this device number as part of the 
file comparisons it does, and it thinks everything is therefore new and needs 
a full level 0 backup.  This is not at all practical, and requires that 
amanda be re-run many times in the next day in order for the backups to catch 
up with reality & completely confuses any scheduling amanda may have worked 
out that assure a smooth backup every night.  Litterally it can take weeks 
for this schedule to return to some semblance of smooth operation with about 
the same size of backups being done every night.

The tar people have to deal with many platforms and are convinced their method 
is the correct one, so they aren't going to change that aspect of how tar 
works just to satisfy a linux user.

To me, it seems like it is time to pull this LVM stuff out of the LANANA(sp?) 
experimental category and give it a stable home.  This should be a New Years 
Resolution for linux. :-)

In the meantime, how can I specify a major of 238 for dm-mod when its built 
in, given as an argument on the kernel command line in a grub boot stanza?

Being able to do that would give me back stable addressing for tar to work 
from.

Thanks, and I hope the 'Happy New Year' hangovers are recoverable.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
hardware stress fractures
