Return-Path: <linux-kernel-owner+w=401wt.eu-S932079AbXBKTVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079AbXBKTVr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 14:21:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932102AbXBKTVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 14:21:47 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:16507 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079AbXBKTVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 14:21:46 -0500
Date: Sun, 11 Feb 2007 13:20:10 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] keep track of network interface renaming
In-reply-to: <fa./pMesnnnb80P5K2iQYUkxeYCpXA@ifi.uio.no>
To: David Miller <davem@davemloft.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: lunz@falooley.org
Message-id: <45CF6C6A.1090506@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.vON9rghc4zb2B4B1Ub/ZAaRY2v8@ifi.uio.no>
 <fa.EIATc7QlHJ5coYaEARiq54/4h6A@ifi.uio.no>
 <fa.rECiNcG8qmgC5L7se1aXLWosf4E@ifi.uio.no>
 <fa./pMesnnnb80P5K2iQYUkxeYCpXA@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Jason Lunz <lunz@falooley.org>
> Date: Sun, 11 Feb 2007 13:27:05 -0500
> 
>> On Sun, Feb 11, 2007 at 09:55:52AM -0800, David Miller wrote:
>>> This is kernel log clutter.
>>>
>>> You can ask the kernel for the list of interfaces, and
>>> use even ethtool to ask what driver each interface is
>>> associated with.
>>>
>>> The patch wasn't applied because it really is not necessary.
>> I disagree completely. I'm working right now on a udev-based system that
>> does ethernet device renaming. It's quite difficult when working with
>> udev to tell exactly when and why each interface was renamed, since it's
>> typically done within initramfs where it's difficult to enable debug
>> messages. This printk helps immensely.
> 
> You can listen on a netlink socket for these events if you
> want to see when they occur.

Unfortunately that's not very practical if, as in this case, the 
renaming is being done from an initramfs. Hiding this information as we 
do now is rather user-hostile.

> 
> There is no need for this log message, it is superfluous.

I think the minimal extra output from this is well worth it. If we care 
so much about limiting dmesg output, how about getting rid of all those 
hundreds of "PM: Adding info for" messages in recent kernels..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

