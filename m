Return-Path: <linux-kernel-owner+w=401wt.eu-S1757437AbZABI3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437AbZABI3q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 03:29:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbZABI3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 03:29:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:50098 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335AbZABI3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 03:29:33 -0500
Date: Fri, 2 Jan 2009 00:28:24 -0800
From: Greg KH <gregkh@suse.de>
To: Mark Lord <lkml@rtr.ca>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: libusb broken on 2.6.28 x86_64 ?
Message-ID: <20090102082824.GA4212@suse.de>
References: <495DB4AC.50602@rtr.ca> <495DBBC1.7040202@rtr.ca> <20090102072436.GA3444@suse.de> <495DC771.9030103@rtr.ca> <20090102075835.GA3955@suse.de> <495DCD18.8060900@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <495DCD18.8060900@rtr.ca>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2009 at 03:15:20AM -0500, Mark Lord wrote:
> Greg KH wrote:
>> On Fri, Jan 02, 2009 at 02:51:13AM -0500, Mark Lord wrote:
>>> Greg KH wrote:
>>>> On Fri, Jan 02, 2009 at 02:01:21AM -0500, Mark Lord wrote:
>>>>> Mark Lord wrote:
>>> ..
>>>>> Mmm.. broken only for 64-bit userspace, it seems.
>>>>>
>>>>> I've recompiled the same app against 32-bit libs,
>>>>> and it works just fine on that 64-bit system,
>>>>> as well as on 32-bit systems.
>>>>>
>>>>> But not when compiled for pure 64-bit operation on a 64-bit system.
>>> ..
>>>> Which version of libusb, a new one was just released a few weeks ago
>>>> that fixes a lot of problems reported in the older libusb versions, and
>>>> made things much faster to boot.  You might want to check it out.
>>> ..
>>>
>>> This is with libusb-0.1-4, which has been working fine with all prior 
>>> kernels,
>>> including the 2.6.27.xx series.
>>>
>>> Userspace stuff like this is not supposed to be broken from kernel to 
>>> kernel.
>> No it shouldn't, I was thinking this was the first time you had tried
>> such a thing (64bit userspace apps.)
>> If using 2.6.27 works, then we need to fix this.
> ..
>
> Yup.  I don't really see anything likely in kernel from 2.6.27 to 2.6.28,
> other than perhaps the new "poisoning" code.  I wonder if that could be it?
>
> Kinda weird that the device works with libusb the first time it is used,
> but then fails on all subsequent runs of the same app, until replugged.
>
> But.. I can run the 32-bit compat app after a 64-bit failure,
> and *that* does work.  There's gotta be a useful clue in there somewhere.

Hm, care to run 'git bisect'?

Or do you have a simple (or complex) test program that I can run here to
do the same thing?

thanks,

greg k-h
