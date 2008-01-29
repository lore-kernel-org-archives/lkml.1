Return-Path: <linux-kernel-owner+w=401wt.eu-S1760222AbYA2AzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760222AbYA2AzW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 19:55:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbYA2AzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 19:55:08 -0500
Received: from vms048pub.verizon.net ([206.46.252.48]:39467 "EHLO
	vms048pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbYA2AzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 19:55:07 -0500
Date: Mon, 28 Jan 2008 19:55:03 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Problem with ata layer in 2.6.24
In-reply-to: <479E7105.2090201@shaw.ca>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Mark Lord <liml@rtr.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200801281955.04459.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <fa.YoSRdik0niRWE1jgfb9yTQPim5A@ifi.uio.no>
 <fa.ebGd1717PgKMzHUmaQOLoLkFdsI@ifi.uio.no> <479E7105.2090201@shaw.ca>
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 January 2008, Robert Hancock wrote:
>Gene Heskett wrote:
>> And so far no one has tried to comment on those 2 dmesg lines I've quoted
>> a couple of times now, here's another:
>> [    0.000000] Nvidia board detected. Ignoring ACPI timer override.
>> [    0.000000] If you got timer trouble try acpi_use_timer_override
>> what the heck is that trying to tell me to do, in some sort of broken
>> english?
>
>A lot of NVIDIA-chipset motherboards have BIOS problems where they
>include an incorrect ACPI interrupt override for the timer interrupt,
>which tends to cause the system to fail to boot due to the timer
>interrupt not working. The kernel normally ignores ACPI interrupt
>overrides on the timer interrupt for NVIDIA chipsets for this reason.
>Unfortunately on some such boards the override is actually correct and
>needed, and so this actually causes problems. Hence the
>acpi_use_timer_override option.
>
>In any case this is unlikely to have anything to do with your problem,
>since if that was messed up you likely would never have even booted.
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/

In this case, there seems to be a buglet.  I turned on the nvidia/amd drives 
under the ATA section of the menu, and turned off the pata_amd under the sata 
menu in xconfig.

But I've tried twice now and it fails to build the initrd because the pata_amd 
module is on the missing list.  Of course its missing, I didn't have it 
built...

Next?

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Of course it's possible to love a human being if you don't know them too well.
		-- Charles Bukowski
