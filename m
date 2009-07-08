Return-Path: <linux-kernel-owner+w=401wt.eu-S1756947AbZGHOM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947AbZGHOM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 10:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbZGHOMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 10:12:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36290 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753708AbZGHOMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 10:12:17 -0400
Message-ID: <4A54A938.5030807@redhat.com>
Date: Wed, 08 Jul 2009 10:12:08 -0400
From: Peter Jones <pjones@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Dave Airlie <airlied@gmail.com>, Jeff Chua <jeff.chua.linux@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Scott James Remnant <scott@canonical.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Dave Jones <davej@redhat.com>
Subject: Re: can we move USB_DEVICEFS to non-embedded?
References: <b6a2187b0906222211i4509bc4cu39e9123cba61039a@mail.gmail.com> <20090623144221.GA29593@suse.de> <b6a2187b0906230829k308cb875r7362f184bccb1d6d@mail.gmail.com> <20090623153928.GA32604@suse.de> <21d7e9970907080354h6949b27va40fb830f612287@mail.gmail.com> <4A54A4A6.2060100@redhat.com> <4A54A538.3080407@redhat.com> <20090708140419.GA20418@suse.de>
In-Reply-To: <20090708140419.GA20418@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Wed, Jul 08, 2009 at 09:55:04AM -0400, Peter Jones wrote:
>> On 07/08/2009 09:52 AM, Peter Jones wrote:
>>> On 07/08/2009 06:54 AM, Dave Airlie wrote:
>>>
>>>> I'm not quite sure if something in the F11 initrd needs usbfs for
>>>> something (cc'ed Peter)
>>> Not a thing.
>> Actually, I take it back.  We do mount usbfs, and we examine
>> /proc/bus/usb/devices as a heuristic to try and determine if
>> all the devices have been enumerated.
> 
> How can you ever know if all devices are enumerated as you don't know
> how many devices will be showing up?

You don't, that's why I said it's a heuristic.  But basically, we have a 
timeout, and if the device list doesn't change in that amount of time, we
call it done.

It's not the best technique ever, but it does work.

>> So that could be related to what you're seeing.
> 
> That file is now available in /sys/kernel/debug/usb/devices if you
> really need it.

Oh, okay.  I can change it to use that then.

> But I would think that you do not.

Well, we pretty much do until we switch to dracut.

-- 
   Peter
