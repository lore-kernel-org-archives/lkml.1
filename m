Return-Path: <linux-kernel-owner+w=401wt.eu-S1757483AbXLGRzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483AbXLGRzs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 12:55:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbXLGRzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 12:55:36 -0500
Received: from lucidpixels.com ([75.144.35.66]:48982 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756225AbXLGRzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 12:55:35 -0500
Date: Fri, 7 Dec 2007 12:55:34 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Bill Davidsen <davidsen@tmr.com>
cc: linux-kernel@vger.kernel.org, apiszcz@solarrain.com
Subject: Re: 2.6.23.9: x86_64: floppy not working: p35 chipset
In-Reply-To: <47598CAD.40100@tmr.com>
Message-ID: <Pine.LNX.4.64.0712071254580.26042@p34.internal.lan>
References: <Pine.LNX.4.64.0712060435500.6948@p34.internal.lan>
 <47598CAD.40100@tmr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 7 Dec 2007, Bill Davidsen wrote:

> Justin Piszcz wrote:
>> Trying to format a floppy (2-3 of them) on a GA-P35-DS4 2.0 with a regular 
>> Sony floppy on Debian x86_64 with kernel 2.6.23.9:
>> 
>> # fdformat /dev/fd0
>> Could not determine current format type: No such device
>> # mformat a:
>> mformat: Could not get geometry of device (No such device)
>> #
>> 
>> # cat /proc/interrupts |grep floppy
>>   6:         38         37         39         41   IO-APIC-edge      floppy
>> 
>> # dmesg|grep -A1 fd0
>> [   52.689487] Floppy drive(s): fd0 is 1.44M
>> [   52.704661] FDC 0 is a post-1991 82077
>> 
>> During the 'attempted format'
>> 
>
>> 
>> I've tried a few different floppies, the result is the same.  The system is 
>> 64-bit only, no 32-bit emulation is enabled using a strict 64-bit-only 
>> userland.  Has anyone else gotten their floppy drive to work under 64-bit?
>> 
>> Is this just a case of a DOA floppy drive or is something else wrong?
>> 
> Maybe booting from a 32 bit live CD would help determine that. It certainly 
> was seen at boot time. Didn't get hooked to some SCSI device name by udev, 
> did it?
>
>
> -- 
> Bill Davidsen <davidsen@tmr.com>
>  "We have more to fear from the bungling of the incompetent than from
> the machinations of the wicked."  - from Slashdot
>

Retried with some other floppies and later tried the original, everything 
seems to be working now, must have been a bad floppy/some transient issue.

Justin.
