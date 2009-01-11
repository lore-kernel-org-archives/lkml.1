Return-Path: <linux-kernel-owner+w=401wt.eu-S1755077AbZAKSHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077AbZAKSHs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 13:07:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbZAKSHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 13:07:39 -0500
Received: from rtr.ca ([76.10.145.34]:47352 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738AbZAKSHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 13:07:38 -0500
Message-ID: <496A3567.3090900@rtr.ca>
Date: Sun, 11 Jan 2009 13:07:35 -0500
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
Cc: Andi Kleen <andi@firstfloor.org>, Hans de Bruin <bruinjm@xs4all.nl>,
       linux-kernel@vger.kernel.org
Subject: Re: Kernelmessage to usbstick?
References: <4968F346.8060806@xs4all.nl> <873afqhixw.fsf@basil.nowhere.org> <200901102358.00984.oliver@neukum.org>
In-Reply-To: <200901102358.00984.oliver@neukum.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum wrote:
> Am Saturday 10 January 2009 23:53:15 schrieb Andi Kleen:
>> Hans de Bruin <bruinjm@xs4all.nl> writes:
>>
>>> Would it be possible to send kernel messages to an usbstick? On
>>> poweroff my laptop displays a kernel trace and a final message:
>>> poweroff[3114] exited with preempt_count 2
>>> /etc/rc.d/rc.0: line 265: 3114 Segementation fault /sbin/poweroff.
>>> I don't have a serial cable within reach, but plenty of usbsticks.
>> There's a mtdoops.c indeed, but it currently only works on
>> MTD controlled flash devices, not usb sticks.
>>
>> However usb sticks would need the USB subsystem to be running and it's
>> unlikely that will be the case really late in poweroff.  So it might
>> not help.
> 
> USB in turn needs PCI, interrupts and DMA.
..

Dunno about an oops, but I currently use a USB device to
display debug messages from the shutdown procedure,
all the way to kernel_halt().

So long as the Oops doesn't kill too much low level stuff,
it's probably feasible.  Except for the very slow write times
for many USB storage devices.
