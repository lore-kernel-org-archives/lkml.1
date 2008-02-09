Return-Path: <linux-kernel-owner+w=401wt.eu-S1755580AbYBISDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbYBISDI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 13:03:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbYBISCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 13:02:55 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:56963 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbYBISCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 13:02:54 -0500
Date: Sat, 09 Feb 2008 13:02:51 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [PATCH] Replace nvidia timer override quirk with pci id list
In-reply-to: <20080209141852.GC22569@one.firstfloor.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Prakash Punnoor <prakash@punnoor.de>, mingo@elte.hu, tglx@linutronix.de,
       lenb@kernel.org, linux-kernel@vger.kernel.org
Message-id: <200802091302.51863.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <20080207195519.GA21772@basil.nowhere.org>
 <200802090746.25310.gene.heskett@gmail.com>
 <20080209141852.GC22569@one.firstfloor.org>
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 February 2008, Andi Kleen wrote:
>> Sort of coming in in the middle of this because I just realized this may
>> have something to do with the "exception Emask" errors. I have an NF2, and
>> the
>
>exception Emask is a SATA problem. Shouldn't be caused by timer troubles.

The error stanza nearly always included a Timeout as cause.  Except of course 
for the only dmesg I actually saved, which claimed a media error.  Murphy at 
his finest. :) It got well and smartctl reports it hasn't remapped a sector, 
good clean bill of health.

>This means in theory it could be that your sata driver if compiled
>in is the first thing to use timers, but normally if the timers are
>broken you get a earlier hang somewhere else.
>
>-Andi

This has killed me both at boot time twice, once before NASH was running, and 
several times when uptimes were a day plus, but has never reappeared since 
the first time I used the acpi_user_timer_override argument, and this 
includes several boots without it including 2 complete, 2 or 3 minute power 
downs.

I HATE it when that happens. :(  Bugs you cannot duplicate even when you are 
fresh out of virgins are the worst.

If I can digress, that is what I've done all my life, 57 years of chasing 
electrons for a living now.  The most exasperating one was in a Chyron 
Character generator whose output came and went with no visible cause and 
their engineers said what I was seeing was technically impossible.  Turned 
out they had left the 2nd gate input to a 7400 they were using for an 
inverter open.  And they claimed they were digital engineers....  Spit.  But 
it took me nearly 5 years of intermittent searching through it with a scope 
probe to find it.  What I had didn't always match the schematics, which 
didn't help.  The eureka moment was when the 10 meg scope probe killed it 
completely with its additional drain to ground.

This one has my attention...

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)

"Whatever the missing mass of the universe is, I hope it's not cockroaches!"
		-- Mom
