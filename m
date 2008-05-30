Return-Path: <linux-kernel-owner+w=401wt.eu-S1754711AbYE3DgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbYE3DgE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 23:36:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752104AbYE3Dfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 23:35:52 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:4463 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbYE3Dfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 23:35:51 -0400
Date: Thu, 29 May 2008 21:37:24 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Problem activating multiple cores ONLY if I press any key before
 kernel is loaded
In-reply-to: <fa.1PYS+TVcu/Wo5ZK/nT3I4Ox2814@ifi.uio.no>
To: S K <nospamnoham@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <483F7674.7070608@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.1PYS+TVcu/Wo5ZK/nT3I4Ox2814@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

S K wrote:
> Hi,
> 
> This is 100% reproducible. I'm using a Shuttle SG33G5, Q9300 (45nm)
> and Fedora 9 with kernel 2.6.25.3-18.fc9.i686.
> 
> When the PC boots up, if I don't press any key till I see "Redhat nash
> version..." everything works fine (well, good enough).
> 
> But if I press a key during the boot and end up inside GRUB boot menu
> and choose Linux (Linux is the default), the boot hangs after the line
> "Booting the kernel." and before "Redhat nash..." is displayed.
> 
> So I went into GRUB and removed the "quiet" kernel option to see
> what's happening. I saw some errors (posted at end of email) and I
> waited for a while (1-2 mins?) and the boot continued. But only one
> core was activated. I saw several such thread on many websites and
> most suggested "noapic" and "nolapic" and some also suggested
> "acpi=off".
> 
> If I added "noapic nolapic acpi=off" using the GRUB menu, the boots
> succeeds 1 out of may be 5 times with all cores active.
> 
> Just using "acpi=off" or just "noapic nolapic" didn't help -- it could
> have been intermittent, but I didn't try these many times.
> 
> I'm mailing LKML because the "fix" given in other websites is
> intermittent and not always working.
> 
> This is a new PC and I have my old one which is my primary PC till I
> get the new one working fine. So I'm willing to do any kind of tests
> on my new PC. This might be a good test oppurtunity for kernel
> programmers.
> 
> Please let me know if there is a known fix that work all the time or
> if you are interested having your fix/patch tested on my PC.
> 
> Thanks,
> SK
> P.S: Relevant output of dmesg follows.
> 
> I see this in dmesg:
> CPU 1 irqstacks, hard=c07ba000 soft=c079a000
> Not responding.
> Inquiring remote APIC #1...
> .. APIC #1 ID: failed
> .. APIC #1 VERSION: failed
> .. APIC #1 SPIV: failed
> CPU #1 not responding - cannot use it.

Is this a USB keyboard? Might be that pressing keys before the kernel 
does the USB handoff from BIOS/SMI causes the BIOS to do something that 
screws things up..
