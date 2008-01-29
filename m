Return-Path: <linux-kernel-owner+w=401wt.eu-S1757845AbYA2Bam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845AbYA2Bam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 20:30:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbYA2Bad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 20:30:33 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:34921 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbYA2Bac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 20:30:32 -0500
Date: Mon, 28 Jan 2008 19:31:42 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Problem with ata layer in 2.6.24
In-reply-to: <200801281955.04459.gene.heskett@gmail.com>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Mark Lord <liml@rtr.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <479E81FE.2090604@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.YoSRdik0niRWE1jgfb9yTQPim5A@ifi.uio.no>
 <fa.ebGd1717PgKMzHUmaQOLoLkFdsI@ifi.uio.no> <479E7105.2090201@shaw.ca>
 <200801281955.04459.gene.heskett@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
> On Monday 28 January 2008, Robert Hancock wrote:
>> Gene Heskett wrote:
>>> And so far no one has tried to comment on those 2 dmesg lines I've quoted
>>> a couple of times now, here's another:
>>> [    0.000000] Nvidia board detected. Ignoring ACPI timer override.
>>> [    0.000000] If you got timer trouble try acpi_use_timer_override
>>> what the heck is that trying to tell me to do, in some sort of broken
>>> english?
>> A lot of NVIDIA-chipset motherboards have BIOS problems where they
>> include an incorrect ACPI interrupt override for the timer interrupt,
>> which tends to cause the system to fail to boot due to the timer
>> interrupt not working. The kernel normally ignores ACPI interrupt
>> overrides on the timer interrupt for NVIDIA chipsets for this reason.
>> Unfortunately on some such boards the override is actually correct and
>> needed, and so this actually causes problems. Hence the
>> acpi_use_timer_override option.
>>
>> In any case this is unlikely to have anything to do with your problem,
>> since if that was messed up you likely would never have even booted.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> 
> In this case, there seems to be a buglet.  I turned on the nvidia/amd drives 
> under the ATA section of the menu, and turned off the pata_amd under the sata 
> menu in xconfig.
> 
> But I've tried twice now and it fails to build the initrd because the pata_amd 
> module is on the missing list.  Of course its missing, I didn't have it 
> built...
> 
> Next?

Check the /etc/modprobe.conf file, a lot of distributions use this to 
generate the initrd. If there's references to pata_amd it'll try and 
include it.
