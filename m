Return-Path: <linux-kernel-owner+w=401wt.eu-S1757276AbZABH7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276AbZABH7s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 02:59:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbZABH7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 02:59:37 -0500
Received: from cantor.suse.de ([195.135.220.2]:44362 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127AbZABH7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 02:59:37 -0500
Date: Thu, 1 Jan 2009 23:58:35 -0800
From: Greg KH <gregkh@suse.de>
To: Mark Lord <lkml@rtr.ca>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: libusb broken on 2.6.28 x86_64 ?
Message-ID: <20090102075835.GA3955@suse.de>
References: <495DB4AC.50602@rtr.ca> <495DBBC1.7040202@rtr.ca> <20090102072436.GA3444@suse.de> <495DC771.9030103@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <495DC771.9030103@rtr.ca>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2009 at 02:51:13AM -0500, Mark Lord wrote:
> Greg KH wrote:
>> On Fri, Jan 02, 2009 at 02:01:21AM -0500, Mark Lord wrote:
>>> Mark Lord wrote:
> ..
>>> Mmm.. broken only for 64-bit userspace, it seems.
>>>
>>> I've recompiled the same app against 32-bit libs,
>>> and it works just fine on that 64-bit system,
>>> as well as on 32-bit systems.
>>>
>>> But not when compiled for pure 64-bit operation on a 64-bit system.
> ..
>> Which version of libusb, a new one was just released a few weeks ago
>> that fixes a lot of problems reported in the older libusb versions, and
>> made things much faster to boot.  You might want to check it out.
> ..
>
> This is with libusb-0.1-4, which has been working fine with all prior 
> kernels,
> including the 2.6.27.xx series.
>
> Userspace stuff like this is not supposed to be broken from kernel to 
> kernel.

No it shouldn't, I was thinking this was the first time you had tried
such a thing (64bit userspace apps.)

If using 2.6.27 works, then we need to fix this.

thanks,

greg k-h
