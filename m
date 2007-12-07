Return-Path: <linux-kernel-owner+w=401wt.eu-S1756705AbXLGSGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705AbXLGSGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 13:06:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbXLGSGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 13:06:41 -0500
Received: from mail.tmr.com ([64.65.253.246]:44476 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753811AbXLGSGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 13:06:40 -0500
Message-ID: <47598F94.6090305@tmr.com>
Date: Fri, 07 Dec 2007 13:23:16 -0500
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org, apiszcz@solarrain.com
Subject: Re: 2.6.23.9: x86_64: floppy not working: p35 chipset
References: <Pine.LNX.4.64.0712060435500.6948@p34.internal.lan> <47598CAD.40100@tmr.com> <Pine.LNX.4.64.0712071254580.26042@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0712071254580.26042@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
>
>
> On Fri, 7 Dec 2007, Bill Davidsen wrote:
>
>> Justin Piszcz wrote:
>>> Trying to format a floppy (2-3 of them) on a GA-P35-DS4 2.0 with a 
>>> regular Sony floppy on Debian x86_64 with kernel 2.6.23.9:
>>>
>>> # fdformat /dev/fd0
>>> Could not determine current format type: No such device
>>> # mformat a:
>>> mformat: Could not get geometry of device (No such device)
>>> #
>>>
>>> # cat /proc/interrupts |grep floppy
>>>   6:         38         37         39         41   IO-APIC-edge      
>>> floppy
>>>
>>> # dmesg|grep -A1 fd0
>>> [   52.689487] Floppy drive(s): fd0 is 1.44M
>>> [   52.704661] FDC 0 is a post-1991 82077
>>>
>>> During the 'attempted format'
>>>
>>
>>>
>>> I've tried a few different floppies, the result is the same.  The 
>>> system is 64-bit only, no 32-bit emulation is enabled using a strict 
>>> 64-bit-only userland.  Has anyone else gotten their floppy drive to 
>>> work under 64-bit?
>>>
>>> Is this just a case of a DOA floppy drive or is something else wrong?
>>>
>> Maybe booting from a 32 bit live CD would help determine that. It 
>> certainly was seen at boot time. Didn't get hooked to some SCSI 
>> device name by udev, did it?
>>
>>
>> -- 
>> Bill Davidsen <davidsen@tmr.com>
>>  "We have more to fear from the bungling of the incompetent than from
>> the machinations of the wicked."  - from Slashdot
>>
>
> Retried with some other floppies and later tried the original, 
> everything seems to be working now, must have been a bad floppy/some 
> transient issue.

Great! I did test that FC8 with a Fedora kernel will see and use the 
floppy. Even found a floppy to use. Now I have to figure out why I have 
a floppy with a gzipped ext2 filesystem on it. :-(
Doesn't appear to be bootable, I thought it might be SYSLINUX for an old 
system which couldn't boot from CD or USB, but that doesn't seem to be 
the case.

Anyway, glad the problem went away.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


