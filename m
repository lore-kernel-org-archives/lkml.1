Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbZG2TTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbZG2TTf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 15:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753356AbZG2TTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 15:19:35 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:44273 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbZG2TTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 15:19:34 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: Frans Pop <elendil@planet.nl>
Subject: Re: [PATCH] kdesu broken
Date: Wed, 29 Jul 2009 15:19:19 -0400
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc4; KDE/4.2.4; i686; ; )
Cc: alan@lxorguk.ukuu.org.uk, torvalds@linux-foundation.org,
       hirofumi@mail.parknet.co.jp, aneesh.kumar@linux.vnet.ibm.com,
       rjw@sisk.pl, ray-lk@madrabbit.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, stern@rowland.harvard.edu
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk>
 <200907291443.13983.gene.heskett@verizon.net>
 <200907292108.15839.elendil@planet.nl>
In-reply-to: <200907292108.15839.elendil@planet.nl>
MIME-version: 1.0
Content-type: Text/Plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
Message-id: <200907291519.19567.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 July 2009, Frans Pop wrote:
>On Wednesday 29 July 2009, Gene Heskett wrote:
>> Yes, some of it will.  But thanks to fedora's broken disk partitioner,
>> something I've been screaming about for a damned decade, my /boot
>> partition isn't big enough to absorb a whole chain of those, hence the
>> fixed version request.
>
>My /boot isn't big enough for a full series either, but my $HOME is :-)
>
>The fact that the packages I create all have the same package name and
>only the package version differs, means that I do get the complete series
>but only have one version installed in /boot at any time (as installing a
>new version overwrites the version from the previous bisect iteration).
>
>No idea if you can do the same on an RPM-based system easily.

I do not normally use rpms to do that.  My makeit script handles all of that, 
keeping one old version of everything in /boot and /lib/modules that I can 
revert by hand if the new kernel is a showstopper.

Whenever I let rpm get access to my grub.conf, I always have to go back in 
with vim & fix the stanza numbers I keep track of the boots with.  Grub 
doesn't really care, but I do. :)  rpm should be so neat...

Anybody that wants this script (actually there are 2 of them), I can attach 
them, makeit and buildit26 (which unpacks and applies the patches plus running 
a make oldconfig) are about 100 lines each.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The NRA is offering FREE Associate memberships to anyone who wants them.
<https://www.nrahq.org/nrabonus/accept-membership.asp>

I just got out of the hospital after a speed reading accident.
I hit a bookmark.
		-- Steven Wright

