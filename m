Return-Path: <linux-kernel-owner+w=401wt.eu-S1030196AbXDKTgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030196AbXDKTgs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 15:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030192AbXDKTgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 15:36:48 -0400
Received: from vms048pub.verizon.net ([206.46.252.48]:36377 "EHLO
	vms048pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030188AbXDKTgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 15:36:47 -0400
Date: Wed, 11 Apr 2007 15:29:01 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: I give up
In-reply-to: <17949.1016.199225.111768@smtp.charter.net>
To: linux-kernel@vger.kernel.org
Cc: "John Stoffel" <john@stoffel.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Olaf Hering <olaf@aepfle.de>,
       Dave Dillow <dave@thedillows.org>, Dave Jones <davej@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeff Garzik <jeff@garzik.org>
Message-id: <200704111529.01412.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200704091007.58535.gene.heskett@gmail.com>
 <Pine.LNX.4.61.0704111738370.32056@yvahk01.tjqt.qr>
 <17949.1016.199225.111768@smtp.charter.net>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 April 2007, John Stoffel wrote:
>>>>>> "Jan" == Jan Engelhardt <jengelh@linux01.gwdg.de> writes:
>
>Jan> On Apr 10 2007 23:54, Gene Heskett wrote:
>>>>>> So fix tar to not do silly things.
>>>>>> Kernel major:minor numbers are not stable.
>>>>>
>>>>> YOU Tell that to the tar/star people, they are flabbergasted that
>>>>> its not stable.  It apparently is for every other OS tar can be run
>>>>> on.
>>>>
>>>> FreeBSD also seems to be quite "dynamic".
>>>> /dev/da0 is (0,92) for the 'fixit shell' -- how about you?
>>>
>>> I don't have such a beast here.  Whats that supposed to do?
>
>Jan> Well I was just pointing out that Linux is not the only one to
>Jan> have device numbers (for promiment block-backed storage) that can
>Jan> move across reboots.
>
>I guess one work around would be to export your local filesystems via
>NFS and then have amanda back them up that way, which means gnutar
>should then ignore the devmajor and devminor numbers.
>
>Or you could just use a hack of the perl script 'tarcust' to hack the
>minor/major numbers stored in the index files, and make them match the
>current major/minor pair for each filesystem just before you do a
>backup.
>
>A total hack, but probably what I would do, since gtar should (IMNSHO)
>just ignore the devmajor/devminor and just go by the name.  It's not
>like the sysadmin can't shoot himself in the foot anyway.
>
>Or, again, get away from Amanda and tar and instead move to Bacula.
>Smarter software.
>
>John

Does Bacula not use tar for its dirty work?


-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Nobody ever died from oven crude poisoning.
