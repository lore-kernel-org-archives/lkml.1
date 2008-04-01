Return-Path: <linux-kernel-owner+w=401wt.eu-S1759129AbYDAOpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759129AbYDAOpd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 10:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756639AbYDAOpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 10:45:23 -0400
Received: from mailout.planet-school.de ([194.116.187.6]:43251 "EHLO
	turbohermes.planet-school.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756323AbYDAOpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 10:45:22 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Apr 2008 10:45:21 EDT
Message-ID: <47F248EA.6070705@derklecks.de>
Date: Tue, 01 Apr 2008 16:38:34 +0200
From: =?ISO-8859-1?Q?Felix_M=F6ller?= <felix@derklecks.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Shaohua Li <shaohua.li@intel.com>, Felix M?ller <fm@opensuse.org>,
       Arthur Erhardt <erhardt@pit.physik.uni-tuebingen.de>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] ACPI PM: Restore the 2.6.24 suspend ordering
References: <200803300319.08398.rjw@sisk.pl> <200803301358.39831.rjw@sisk.pl> <20080330122838.GA7093@elf.ucw.cz> <200803301515.33922.rjw@sisk.pl> <20080401084523.GA25278@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20080401084523.GA25278@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
>>>>>> For the reasons outlined above, the change of the suspend ordering
>>>>>> should be reverted, which is done by the patch below.
>>>>> But this will break those few nvidia-based systems, no?
>>>>>
>>>>> this may have been a good idea in -rc1 days, but we are in -rc7
>>>>> now... and the patch is slightly big.
>>>> It's quite obvious, though.
>>> Yes, but breaking systems between -rc7 and final is _very_ unnice.
>> Breaking systems between 2.6.24 and 2.6.25 is even worse, which is why
>> I've posted this patch.
>>
>> IOW, we tried to fix systems that were broken with 2.6.24, but it didn't work,
>> because our "fix" broke systems that were OK with 2.6.24.  Solution: revert
>> the "fix" and go back to the design board.  That's all we can do so late in
>> the release cycle, IMO.
> 
> Well, I agree that regression from 2.6.24 is worse, but it is
> _slightly_ worse... -rcs are really expected to improve...
> 
> ...plus it no longer looks like macbook regression is caused by _PTS
> ordering?
I am the reporter from the original Novell Bug: 
https://bugzilla.novell.com/show_bug.cgi?id=374217

I just tried current git head (two hours ago) with the patch (the one 
from the beginning of this thread) from Rafael and without it. With the 
patch my MacBook does suspend without it does not.

HTH
Felix Möller
