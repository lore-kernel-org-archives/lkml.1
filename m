Return-Path: <linux-kernel-owner+w=401wt.eu-S1759510AbYDBOjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759510AbYDBOjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 10:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759354AbYDBOi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 10:38:59 -0400
Received: from rtr.ca ([76.10.145.34]:3478 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759332AbYDBOi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 10:38:57 -0400
Message-ID: <47F39A80.9090201@rtr.ca>
Date: Wed, 02 Apr 2008 10:38:56 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
Cc: Pavel Machek <pavel@suse.cz>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       jikos@suse.cz, Alan Stern <stern@rowland.harvard.edu>,
       linux-usb@vger.kernel.org
Subject: Re: 2.6.25-rc7:  Ugh.
References: <47EBBD57.30902@rtr.ca> <200803312005.37804.oliver@neukum.org> <47F139C9.50803@rtr.ca> <200804021004.53453.oliver@neukum.org> <47F39A55.5070102@rtr.ca>
In-Reply-To: <47F39A55.5070102@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(CCing linux-usb again)
(CCing Alan Stern on this sub-thread)

Oliver Neukum wrote:
> Am Montag, 31. März 2008 21:21:45 schrieb Mark Lord:
>> Oliver Neukum wrote:
>>> But if power is cut with newer kernels and older kernels retain it, something
>>> must have changed. Can you undo the ACPI changes since the last working
>>> kernel?
>> ..
>>
>> No, that's no different.
>> This notebook always cuts +5V from USB on suspend or poweroff.
>> Regardless of kernel version.  I don't know how common this is,
>> but all of my notebooks here have always behaved this way,
>> as have most (but not all) of the larger systems.
>>
>> The two most recent PCIe motherboards I have here
>> do provide +5V standby power to USB, even when "OFF",
>> much to my annoyance and to the detriment of this planet.
>
> Very well.
>
> Mark, can you get a sysrq-t trace of your whole system when USB goes
> dead? And please enable CONFIG_USB_DEBUG. We need to do whether
> khubd and ksuspend_usbd are in state D.
..

Both of those things were already done, and results from the last time
are attached to the bugzilla report: http://bugzilla.kernel.org/show_bug.cgi?id=10345

I'll be installing -rc8 today, and see what happens there.

Cheers

