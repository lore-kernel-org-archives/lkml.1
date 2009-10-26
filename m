Return-Path: <linux-kernel-owner+w=401wt.eu-S1753865AbZJZQ7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbZJZQ7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 12:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753406AbZJZQ7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 12:59:37 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:56018 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbZJZQ7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 12:59:37 -0400
X-Greylist: delayed 3611 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Oct 2009 12:59:37 EDT
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: linux-kernel@vger.kernel.org
Subject: SHMEM question
Date: Mon, 26 Oct 2009 11:59:04 -0400
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5; KDE/4.3.1; i686; ; )
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Message-id: <200910261159.04995.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings;

fedora F10 system, quad core phenom, 4GB ram, ASUS M2N-SLI Deluxe mobo
kernel-2.6.32-rc5, uptime 2d 11:27 at the moment, and the system feels good.

rkhunter sent me an email this morning complaining about a data file in 
/dev/shm.

On looking at it:
[root@coyote Download]# ls -l /dev/shm
total 28
-rw-r----- 1 root root     4096 2009-10-25 12:09 mono.10594
-r-------- 1 root root 67108904 2009-10-24 00:28 pulse-shm-3880918577
-rw-rw-rw- 1 root root       16 2009-10-24 01:17 sem.ADBE_ReadPrefs_root
-rw-rw-rw- 1 root root       16 2009-10-24 01:17 sem.ADBE_REL_root
-rw-rw-rw- 1 root root       16 2009-10-24 01:17 sem.ADBE_WritePrefs_root

On grepping for SHM in the .config, I find SHMEM set to y, but about an hours 
worth of wandering around in a 'make xconfig' has failed to actually find it.

That pulse-shm-3880918577 file at over 67 megabytes is all $00 till $04000000 
into it, then there is 6 non-zero bytes and the rest is back to all balls.

Is this some indicator of a new rootkit or WTF?

It was the mono.10594 file that rkhunter-1.3.4 was concerned about.  I, since 
I can't make a mental connection between SHMEM and /dev/shm, am concerned 
about that whole tree of data which seems totally out of place in the /dev 
tree.

I hate to be a pest but Many Thanks for any enlightenment on this.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The NRA is offering FREE Associate memberships to anyone who wants them.
<https://www.nrahq.org/nrabonus/accept-membership.asp>

Microsoft is to Software as McDonalds is to Cuisine.
