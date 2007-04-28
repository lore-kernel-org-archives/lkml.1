Return-Path: <linux-kernel-owner+w=401wt.eu-S932339AbXD1D0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339AbXD1D0j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 23:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932431AbXD1D0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 23:26:39 -0400
Received: from 208.65.181.93.static.etheric.net ([208.65.181.93]:58422 "EHLO
	nicotine.truxton.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339AbXD1D0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 23:26:38 -0400
X-Greylist: delayed 535 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Apr 2007 23:26:38 EDT
From: Truxton Fulton <trux@truxton.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       lee-in-berlin@web.de
Subject: Re: [Bugme-new] [Bug 8378] New: Averatec 3156X laptop doesn't  reboot with kernels > 2.6.13.5 (responsible commit found)
In-Reply-To: <20070427144434.970de79f.akpm@linux-foundation.org> (Andrew
	Morton's message of "Fri, 27 Apr 2007 14:44:34 -0700")
References: <200704271742.l3RHgPTH019561@fire-2.osdl.org>
	<20070427144434.970de79f.akpm@linux-foundation.org>
X-Prognosticator: 42
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAElBMVEUSDgpyVTOTZDz
 JooRMMRkrIRJCKOHSAAACaklEQVR4nE1Twa7jIAxkpeZeU3J/GN79NeTdS2vu6Qr//6/smCT
 a0laVGOyZMYNzY02t11spWVU3d6zJvq9KMZVSFnWTuo9FnJIBpazb9rHfn1z2/VJ+PyouzyU
 x81HzPf0v4OQr+7PmcbKr3GINRLzvL+uxP2lNOUglOkr8QT89yQvWjY6KGA5vniK13oWtIhW
 mYCXbpJFzqG2ug+O+RPKDXiXgI+9eD/Is1E2qe9faQdFP7hjmL+ulOTSpIvXwsXAIX9UA9Gn
 Yj8ynqJYfaLbR39717TnxXpLD49vUXqTpdKmebRnEQauNC8fbBElYy+i2RAk24U314Trthwd
 NCEH/ON0EQKVz6KZ3fm3NXVRa09HpMFh4Yr061wRJGNTnJfrvvD0ww9ZVPMd5CDDM1/yYcB2
 QJQwlT3kykwRmyS/MRHtvOBs9BUrxLdFzjj9fbuvtYgBHIl/uwccbB57hXFTbLgoECypLEf8
 LjqaY+QmUIU78fXMKoH0CkCW1uVGx+4inda5JTJS+dTfoD+vpnuKEkfSmOgAIHZBf0y+mrip
 b340w30Yr5h8DWhtA8MdElsWvEUmHDRD5KGKdFksDZ0ykty6bAUSERODq73BiwDyA4T0SIyt
 MfENIYEIeEEB7GgCkFSm7OsHQobdbTMjMxLT+DWV2YkPEK5YjQMEvqMATQWj7FZigGaBYfQx
 AnAHWyv4QFa5PjhZx54KomccPSK2RYp4ly8PZI9vUmLS/PbRFuXZ5NWdJh2K068i9j0xtDoF
 WABjWBRWWIrA889xXqWWQ64SKJr1KothuaP4qzp5rt2sfK3CVNRvwD3ipzBvlIAzfAAAAAEl
 FTkSuQmCC
Date: Fri, 27 Apr 2007 20:17:37 -0700
Message-ID: <m2k5vx6vce.fsf@truxton.com>
User-Agent: Gnus/5.110004 (No Gnus v0.4) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote (at Fri, 27 Apr 2007 14:44:34 -0700) :
> 
> 
> On Fri, 27 Apr 2007 10:42:25 -0700
> bugme-daemon@bugzilla.kernel.org wrote:
> 
>> http://bugzilla.kernel.org/show_bug.cgi?id=8378
>> 
>>            Summary: Averatec 3156X laptop doesn't reboot with kernels >
>>                     2.6.13.5 (responsible commit found)
>>     Kernel Version: 2.6.14 till 2.6.21
>>             Status: NEW
>>           Severity: normal
>>              Owner: power-management_other@kernel-bugs.osdl.org
>>          Submitter: lee-in-berlin@web.de
>> 
>> 
>> Most recent kernel where this bug did *NOT* occur: 2.6.13.5
>> 
>> Distribution: Debian
>> Hardware Environment: Averatec 3156X (seemingly identical to the american model
>> 3150P)
>> Software Environment:?
>> Problem Description:
>> I noticed that with recent kernels my laptop would reboot when I do an 'init 6',
>> but hang at the end of the init run. The last working vanilla kernel is
>> 2.6.13.5. With some trying and a bit of guessing I found a change to
>> include/asm-i386/mach-default/mach_reboot.h in 2.6.14 to be the culprit. It can
>> be found at:
>> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.14.y.git;a=commitdiff;h=59f4e7d572980a521b7bdba74ab71b21f5995538
>> 
>> On a 2.6.21 source tree I can revert this patch, and then rebooting works.
>> 
>> Steps to reproduce:
>> 1) On a Averatec 3156X (or 3150p?) boot to your default runlevel.
>> 2) as root, type "init 6".
>> 3) instead of rebooting, the system will hang at the end with a blank screen.
>> 
> 
> Oh dear.  We have an ugly i386 snafu here.  Thanks for doing the bisection
> - it helps enormously.
> 
> Could some brave person please pick it up and see if we can get both
> Truxton and Lee's machines working?

Hi,

I verified on my IDEQ210M that performing the old reboot sequence
followed by the new reboot sequence works for me, and I suspect that
it will work for Lee also.  Like this :

	/* old method, works on most machines */
        for (i = 0; i < 100; i++) {
                kb_wait();
                udelay(50);
                outb(0xfe, 0x64);         /* pulse reset low */
                udelay(50);
        }

	/* new method, sets the "System flag" which when set,
	   indicates successful completion of the keyboard controller
	   self-test (Basic Assurance Test, BAT).  This is needed
	   for some machines with no keyboard plugged in */
        for (i = 0; i < 100; i++) {
                kb_wait();
                udelay(50);
                outb(0x60, 0x64);         /* write Controller Command Byte */
                udelay(50);
                kb_wait();
                udelay(50);
                outb(0x14, 0x60);         /* set "System flag" */
                udelay(50);
                kb_wait();
                udelay(50);
                outb(0xfe, 0x64);         /* pulse reset low */
                udelay(50);
        }

Thanks,

-Truxton
