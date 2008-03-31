Return-Path: <linux-kernel-owner+w=401wt.eu-S1758472AbYCaOvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758472AbYCaOvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 10:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756660AbYCaOjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 10:39:37 -0400
Received: from rtr.ca ([76.10.145.34]:3419 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756670AbYCaOjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 10:39:36 -0400
Message-ID: <47F0F7A5.10604@rtr.ca>
Date: Mon, 31 Mar 2008 10:39:33 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
Cc: Pavel Machek <pavel@suse.cz>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       jikos@suse.cz
Subject: Re: 2.6.25-rc7:  Ugh.
References: <47EBBD57.30902@rtr.ca> <20080328092428.GA2081@elf.ucw.cz> <47F00059.1010108@rtr.ca> <200803311355.06487.oliver@neukum.org>
In-Reply-To: <200803311355.06487.oliver@neukum.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum wrote:
> Am Sonntag, 30. März 2008 23:04:25 schrieb Mark Lord:
>>>> Correction there:  3GB of RAM, not 2.
>>> 3GB of RAM can be a problem. Try iommu=soft. .. but in such case
>>> rmmod/insmod of usbhid would not help...
>> ..
>>
>> Booted with mem=2GB, and USB hung again on the first suspend/resume cycle.
> 
> Are you running with CONFIG_USB_SUSPEND? If so, please try without it.
..

Funny.  One of the first posts in this thread told me to make sure
that I do use CONFIG_USB_SUSPEND (which I have been for many kernels now).

One thing I just tried, was to unload all USB stuff before suspend,
and reload on resume -- just stuck the commands into my suspend/resume script.

The machine has been 100% rock solid since then.
So I think that definitely implicates USB.

Still want USB_SUSPEND=n ?  Please explain.

Thanks
