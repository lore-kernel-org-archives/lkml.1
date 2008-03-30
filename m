Return-Path: <linux-kernel-owner+w=401wt.eu-S1755201AbYC3VEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201AbYC3VEj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 17:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754861AbYC3VE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 17:04:28 -0400
Received: from rtr.ca ([76.10.145.34]:2090 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593AbYC3VE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 17:04:27 -0400
Message-ID: <47F00059.1010108@rtr.ca>
Date: Sun, 30 Mar 2008 17:04:25 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, jikos@suse.cz
Subject: Re: 2.6.25-rc7:  Ugh.
References: <47EBBD57.30902@rtr.ca> <47EC549D.6090705@rtr.ca> <20080328092428.GA2081@elf.ucw.cz>
In-Reply-To: <20080328092428.GA2081@elf.ucw.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
>>> It is with great reluctance when I attempt moving my main "desktop"
>>> over to a new kernel version -- because the USB subsystem seems to
>>> break every single time.
>>>
>>> So today I tried 2.6.25-rc7 on it for the first time.
>>> Not good.
>>>
>>> It boots, but just a simple suspend/resume (RAM) was enough to kill it.
>>> It comes back on resume, with an X desktop again,
>>> but with no USB functionality -- no mouse.
>>>
>>> The keyboard still works, so I dropped to a console and tried:
>>>
>>>   rmmod usbhid
>>>   insmod usbhid
>>>
>>> And the console hung at 100% CPU on the insmod.
>>> Back to 2.6.24.3 again, for now -- I've got work to do.
>>>
>>> The specs of this machine have been posted with great regularity
>>> in the past, every new kernel revision it seems.   So here we go again:
>>>
>>> Dell Inspiron 9400 notebook, Intel Core2Duo T7400, 2GB SDRAM.
>> ..
>>
>> Correction there:  3GB of RAM, not 2.
> 
> 3GB of RAM can be a problem. Try iommu=soft. .. but in such case
> rmmod/insmod of usbhid would not help...
..

Booted with mem=2GB, and USB hung again on the first suspend/resume cycle.

-ml
