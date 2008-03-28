Return-Path: <linux-kernel-owner+w=401wt.eu-S1753941AbYC1JYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbYC1JYB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 05:24:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbYC1JXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 05:23:51 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:60372 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbYC1JXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 05:23:50 -0400
Date: Fri, 28 Mar 2008 10:24:28 +0100
From: Pavel Machek <pavel@suse.cz>
To: Mark Lord <lkml@rtr.ca>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, jikos@suse.cz
Subject: Re: 2.6.25-rc7:  Ugh.
Message-ID: <20080328092428.GA2081@elf.ucw.cz>
References: <47EBBD57.30902@rtr.ca> <47EC549D.6090705@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47EC549D.6090705@rtr.ca>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>> It is with great reluctance when I attempt moving my main "desktop"
>> over to a new kernel version -- because the USB subsystem seems to
>> break every single time.
>>
>> So today I tried 2.6.25-rc7 on it for the first time.
>> Not good.
>>
>> It boots, but just a simple suspend/resume (RAM) was enough to kill it.
>> It comes back on resume, with an X desktop again,
>> but with no USB functionality -- no mouse.
>>
>> The keyboard still works, so I dropped to a console and tried:
>>
>>   rmmod usbhid
>>   insmod usbhid
>>
>> And the console hung at 100% CPU on the insmod.
>> Back to 2.6.24.3 again, for now -- I've got work to do.
>>
>> The specs of this machine have been posted with great regularity
>> in the past, every new kernel revision it seems.   So here we go again:
>>
>> Dell Inspiron 9400 notebook, Intel Core2Duo T7400, 2GB SDRAM.
> ..
>
> Correction there:  3GB of RAM, not 2.

3GB of RAM can be a problem. Try iommu=soft. .. but in such case
rmmod/insmod of usbhid would not help...

If rmmod/insmod usbhid helps, and system is fully working after that,
then it is probably usb problem....

Is your problem fixed after latest RTC findings? If not, try to debug
insmod/rmmod of usb, first. If that does not work, it is unlikely
suspend/resume will.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
