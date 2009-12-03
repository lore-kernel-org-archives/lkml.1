Return-Path: <linux-kernel-owner+w=401wt.eu-S1754658AbZLCQ2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbZLCQ2L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 11:28:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753300AbZLCQ2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 11:28:10 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:23301 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbZLCQ2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 11:28:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=JFIQzBC27Y53+/4+WBHQ+jzVQfiDyTZySDoIjUQ58k/aKwH9+ru3WFRMDAlQpWIUuM
         +dYxCw8BsDwF6ttlaUJ7Bco6nAGsr1S3y5zzFziz4lln0DECV9oG/pY1oElutBfOzQGe
         q+JOA3We7mZzB0xrL7UelXZvcy39M2eDVr+Pw=
Message-ID: <4B17EA30.5030208@gmail.com>
Date: Thu, 03 Dec 2009 14:41:20 -0200
From: Bruno Barberi Gnecco <brunobg@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: BUG: Constant freezes and kernel panics on a quad core
 (with dumps)
References: <4B119D95.6090806@gmail.com> <4B119DD7.8020303@majjas.com>	 <4B1298B0.1050505@gmail.com>  <4B12A5BC.5070109@gmail.com> <1259518220.20108.36.camel@marge.simson.net>
In-Reply-To: <1259518220.20108.36.camel@marge.simson.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>> Regarding the PS, I have checked voltages with a multimeter and they are
>>> more than fine, and the wattage is enough for the system, so it'd have
>>> to be a very weird transient glitch that affects only memory access. See
>>> also below.
>> Most of the time transients will be the issue when a power supply causes 
>> problems and that can't be seen with a normal voltmeter. It's not 
>> typical for the rails to be low all the time unless the power supply is 
>> heavily overloaded.
> 
> Or stone cold dead.
> 
> You can't check any PSU with any multimeter I've ever seen unless it's a
> catastrophic failure, or as you said, so overloaded that it can't
> regulate (in which case it would have shut down if it were decent
> quality...).  Non-catastophic PSU failures are often filter problems
> that a multimeter isn't fast enough to see.  Many switchers are
> deplorably noisy, and rely on the caps at the end of the transmission
> line, so one poor quality or dried out cap on MB can screw the pooch
> too.
> 
>>> Any ideas to rule the MB out, other than "get a new one"?
>>>
>>>> Bad memory (memtest doesn't necessarily access things the same way as
>>>> the kernel)
>>> Ruled out. I replaced with a 2GB DDR2, still got the bug: "BUG: Bad page
>>> map in process".
>>>
>>>> Bad cards (pci, agp, whatever)
>>> Ruled out. The only card is the video card. I replaced it with a very
>>> old PCI board and still got error. This also pretty much rules out that
>>> the PS is underpowered, since I powered only the MB and the HD.
>>>
>>> Could it be one of the onboard things? I disabled everything but the
>>> LAN, and still got it.
>>>
>>>> Any of the above with loose connections
> 
> Pay very close attention to cleanliness.  Dust works it's way into
> connectors with vibration.  Pull ram, and reseat.  Resist the urge to
> clean any connector with anything other than no-residue contact cleaner.
> 
> Another thing to watch out for is crappy heat sink compound.  That dries
> out, doesn't conduct heat well enough.  Under load, such a problem may
> build VERY fast with modern CPU current draw.  If all else fails, pull
> your CPU heatsink, clean and re-apply fresh compound.
> 
>>> I already reconnected everything twice. Could still be a loose
>>> connection of one of the wires in the connector, but it's very very
>>> unlikely to give such a specific error on memory access.
>>>
>>>> And did I mention bad power supply?
>>> Yes you did, and I'll try to get another one to be sure, but it could
>>> still be a software bug too.
> 
> Yes, but try another unit.  PSU is THE odds on favorite for random crap
> with everything from PC hardware to very high dollar HW.  It's the point
> of maximum electrical stress.  It's also a spot where many people try to
> save money... big mistake that.
> 
> (removes HW guy hat;)

	Follow-up, with thanks to everybody who helped: I tried a different PSU and still got the 
problem, and I also got a BSOD with Windows. So it seems to be a problem with the 
motherboard or the processor.

	Thanks a lot again,
