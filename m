Return-Path: <linux-kernel-owner+w=401wt.eu-S1753170AbXDJUpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbXDJUpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 16:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753806AbXDJUpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 16:45:31 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:49194 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbXDJUp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 16:45:29 -0400
Date: Tue, 10 Apr 2007 16:45:18 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: I give up
In-reply-to: <alpine.DEB.0.83.0704100821180.20185@sigma.j-a-k-j.com>
To: linux-kernel@vger.kernel.org
Cc: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>, Olaf Hering <olaf@aepfle.de>,
       Dave Dillow <dave@thedillows.org>, Dave Jones <davej@redhat.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeff Garzik <jeff@garzik.org>
Message-id: <200704101645.20296.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200704091007.58535.gene.heskett@gmail.com>
 <200704100353.14208.gene.heskett@gmail.com>
 <alpine.DEB.0.83.0704100821180.20185@sigma.j-a-k-j.com>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 April 2007, John Anthony Kazos Jr. wrote:
>> >So fix tar to not do silly things.
>> >Kernel major:minor numbers are not stable.
>>
>> YOU Tell the tar people, they are flabbergasted that linux is
>> apparently the only unstable OS that tar can be run on.
>
>Linux is not unstable. It's developmental! Linux is like one giant
>international research project marching toward the future of computing.
>MacOS (oh, how I miss System 7.5.5), Windows (shoot me, please), BSD
>(wannabe GNU/Linux), and everything else are there just for companies to
>spend money on and idiots to drool over until Linux is ready to stand up
>and say "Yo. It's just bugfixes and improvements from here. You can put
>the Legos down now."

I don't know who you are, but that's not germane to this discussion, what 
is germane is that once the experimental label has been removed from 
something as capable of screwing up the system as the LMV stuff is, then 
there is no excuse not to give it a LANANA compatible address and quit 
screwing up peoples backup systems just because they turned on pktcdvd or 
md or some other similar option in a make xconfig.  FWIW, md, for raid 
users, should get the same treatment since raids often can have 
terrabytes of data to be backed up.

The patch to do that caught tar users totally off-guard, but once we(I) 
understood why it was done, it was obviously a good patch.  But rather 
than explaining WTF it was doing so we/I understood the reason for the 
pain, the *&%^ patch was reverted, starting the backup related screwups 
all over again from scratch.

Now this thread has a life of its own, and the noise it continues to make 
will prevent the re-application of that patch which WILL stabilize 
things, probably until hell freezes over and pigs can use it for a 
takeoff runway.

I have a fix (thanks Dave D.) worked out for MY system, and you guys can 
do as you damned well please, until you break my fix anyway.  In the 
meantime, I have backup.sh, my amdump wrapper, running every 3 hours 
around the clock without a verify stage until it has managed to update 
all 118 (about 20 megs worth) of its reference files.  I expect that to 
take 3 or 4 days.  Hopefully my drives are up to the torture, if not, 
well they aren't that precious & I CAN drop the card for more & might 
even do that yet tonight unless Circuit City or Staples think that a 
500Gb is still worth its weight in gold bar.  Yes, I spend my money 
locally where possible.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
"Don't discount flying pigs before you have good air defense."
-- jvh@clinet.FI
