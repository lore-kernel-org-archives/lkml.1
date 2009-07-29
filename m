Return-Path: <linux-kernel-owner+w=401wt.eu-S1751095AbZG2Hqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751095AbZG2Hqh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 03:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750895AbZG2Hqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 03:46:37 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:61353 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbZG2Hqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 03:46:36 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
Date: Wed, 29 Jul 2009 03:46:35 -0400
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc4; KDE/4.2.4; i686; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk>
 <200907290100.46160.gene.heskett@verizon.net>
 <20090728220843.3d353f36.akpm@linux-foundation.org>
In-reply-to: <20090728220843.3d353f36.akpm@linux-foundation.org>
MIME-version: 1.0
Content-type: Text/Plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
Message-id: <200907290346.35603.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 July 2009, Andrew Morton wrote:
>On Wed, 29 Jul 2009 01:00:45 -0400 Gene Heskett <gene.heskett@verizon.net> 
wrote:
>> Link to a tutorial plz?
>
>http://landley.net/writing/git-quick.html
>
>That used to be at http://www.kernel.org/doc/local/git-quick.html but some
>dope removed it.

The ./configure line fails, on page 2 of that document, so I moved the .config 
files from 31-rc4 into that tree, and I'm using my own script to do the build 
and install, fiddling with the version numbers to track, calling the first 
build 2.6.31-rc3.5.  The build seems to be going ok, but I had to pull in the 
firmware/radeon tree from my own 31-rc4 in order to get the firmware my script 
& the .config expects.

As my script bounces in and out of the src tree, it needs the src tree named 
consistently.  So I had to restart it a couple of times to fix all those 
gotcha's.  But now I am ready to reboot, starting with me some zz's.  The 
build didn't spit any more stuff than usual.  5 section miss-matches I've been 
looking at for over a year, and some recent adds of rnonce.data stuff that are 
fussing about not being initialized.  I'll test for good/bad in the morning.


-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The NRA is offering FREE Associate memberships to anyone who wants them.
<https://www.nrahq.org/nrabonus/accept-membership.asp>

The new Congressmen say they're going to turn the government around.  I
hope I don't get run over again.

