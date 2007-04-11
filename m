Return-Path: <linux-kernel-owner+w=401wt.eu-S1030237AbXDKTje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030237AbXDKTje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 15:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030224AbXDKTje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 15:39:34 -0400
Received: from vms044pub.verizon.net ([206.46.252.44]:51847 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030190AbXDKTjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 15:39:33 -0400
Date: Wed, 11 Apr 2007 15:27:04 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: I give up
In-reply-to: <Pine.LNX.4.61.0704111738370.32056@yvahk01.tjqt.qr>
To: linux-kernel@vger.kernel.org
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, Olaf Hering <olaf@aepfle.de>,
       Dave Dillow <dave@thedillows.org>, Dave Jones <davej@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeff Garzik <jeff@garzik.org>
Message-id: <200704111527.04905.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200704091007.58535.gene.heskett@gmail.com>
 <200704102354.23766.gene.heskett@gmail.com>
 <Pine.LNX.4.61.0704111738370.32056@yvahk01.tjqt.qr>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 April 2007, Jan Engelhardt wrote:
>On Apr 10 2007 23:54, Gene Heskett wrote:
>>>>>So fix tar to not do silly things.
>>>>>Kernel major:minor numbers are not stable.
>>>>
>>>>YOU Tell that to the tar/star people, they are flabbergasted that its
>>>> not stable.  It apparently is for every other OS tar can be run on.
>>>
>>>FreeBSD also seems to be quite "dynamic".
>>>/dev/da0 is (0,92) for the 'fixit shell' -- how about you?
>>
>>I don't have such a beast here.  Whats that supposed to do?
>
>Well I was just pointing out that Linux is not the only one to have
> device numbers (for promiment block-backed storage) that can move
> across reboots.
>
Which is one more argument in favor of fixing tar, Jorg not withstanding.  
Yeah, that Jorg...  AFAIC, time & technology move on, and I believe I see 
a future where the actual device number might not be the same across a 
reboot, for reasons a hell of a lot less clear than what triggered this 
latest 3 week long battle with something so simple as making a backup.

But, its a battle we'll never win with Jorg stirring the pot, he is the 
single, most vociferous opponent of anything labeled progress that I've 
ever had the displeasure to trying to follow in his rants, and that IS 
what they are, on this and on the scsi list when I was subscribed there.

I do think that a reasoned argument could be made to Paul Eggert, for at 
least a command line option to be made available that would cause tar to 
ignore it, process it yes, but ignore it for --listed-incremental in 
particular.  Maybe even make it part of the --listed-incremental as a 
permanent feature.  For us, that would be the ideal.  It is not an issue 
for level 0's of course.

But my single voice is not going to be able to effect a campaign, its 
going to take a general consensus of all the movers and shakers of linux, 
TPTB if you will, all ganging up on Paul.  Or someone doing a patch to 
that effect, then making distro packages out of it, such as debs, rpm's, 
etc, etc.  A fork I think its called.

There is another also listed in the tar ChangeLog, but I haven't rx'd a 
response from that person although he was Cc:'d at the time.

Dave Dillow, you mentioned another routine in tar that might be an 
educational file to walk through, besides the compare.c I tried to play 
with and apparently broke, can you repeat that phrase again?  I might 
take a stick and poke around in that one too.  Maybe I can un-break 
it? :)

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Earn cash in your spare time -- blackmail your friends.
