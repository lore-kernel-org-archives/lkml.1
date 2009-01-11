Return-Path: <linux-kernel-owner+w=401wt.eu-S1753857AbZAKNb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857AbZAKNb1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 08:31:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbZAKNbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 08:31:19 -0500
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:4027 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbZAKNbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 08:31:18 -0500
X-Greylist: delayed 749 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Jan 2009 08:31:18 EST
Message-ID: <4969F1B7.906@xs4all.nl>
Date: Sun, 11 Jan 2009 14:18:47 +0100
From: Hans de Bruin <bruinjm@xs4all.nl>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Oliver Neukum <oliver@neukum.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: Kernelmessage to usbstick?
References: <4968F346.8060806@xs4all.nl> <873afqhixw.fsf@basil.nowhere.org> <200901102358.00984.oliver@neukum.org>
In-Reply-To: <200901102358.00984.oliver@neukum.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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
> 

I just found out even a serial cable would not help, since the only comm 
device in my laptop ends in a build in modem. Since there is no parallel 
printer port either I will have to use pen and paper. In the mean time, 
rc1 broke my keyboard.

-- 
Hans
