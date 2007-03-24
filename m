Return-Path: <linux-kernel-owner+w=401wt.eu-S1752998AbXCXQGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbXCXQGd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 12:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753159AbXCXQGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 12:06:33 -0400
Received: from mout1.freenet.de ([194.97.50.132]:49950 "EHLO mout1.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998AbXCXQGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 12:06:32 -0400
Message-ID: <46054C81.6060501@freenet.de>
Date: Sat, 24 Mar 2007 17:06:25 +0100
From: Patrick Ringl <patrick_@freenet.de>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH UPDATED][2] cosmetic adaption of drivers/ide/Kconfig concerning
 SATA
References: <45FC763B.1010708@freenet.de> <200703180110.51303.bzolnier@gmail.com> <45FC8847.2060209@freenet.de> <200703232250.18937.bzolnier@gmail.com>
In-Reply-To: <200703232250.18937.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> On Sunday 18 March 2007, Patrick Ringl wrote:
>   
>> Bartlomiej Zolnierkiewicz wrote:
>>
>> Hello,
>>     
>>> On Sunday 18 March 2007, Patrick Ringl wrote:
>>>       
>>>> Hello,
>>>>         
>>> Hi,
>>>
>>>       
>>>> since especially Serial ATA has it's own menu point now, I guess we can 
>>>> change the description of the deprecated SATA driver as well, since the 
>>>> new libATA subsystem is not configured through a SCSI low-level driver 
>>>> anymore, but has it's own menu point.
>>>>
>>>> The following patch is against 2.6.21-rc4:
>>>>
>>>> --- linux-2.6.20.old/drivers/ide/Kconfig	2007-03-18 00:05:11.000000000 +0100
>>>> +++ linux-2.6.20/drivers/ide/Kconfig	2007-03-18 00:09:47.000000000 +0100
>>>> @@ -103,7 +103,7 @@
>>>>   	---help---
>>>>   	  There are two drivers for Serial ATA controllers.
>>>>
>>>> -	  The main driver, "libata", exists inside the SCSI subsystem
>>>> +	  The main driver, "libata", exists inside the ATA subsystem
>>>>         
>>> Strictly speaking libata is not a separate subsystem (it still uses SCSI
>>> subsystem) and "ATA subsystem" may be misleading, since we now have:
>>>
>>> * "ATA/ATAPI/MFM/RLL support" menu for drivers/ide
>>>
>>> * "Serial ATA (prod) and Parallel ATA (experimental) drivers" menu for libata
>>>
>>> What about replacing "exists inside" into "uses" and adding info about
>>> the new menu instead?
>>>       
>> Well, that's even a better idea :-) I wasn't that sure about what to do 
>> .. it's just that it could be misleading since the new (s/p)ata drivers 
>> are not living in the scsi low-level subsystem anymore, but got their 
>> own menu point.
>>
>> Here's a different patch >:)
>>     
>
> applied
>
> [ The patch was whitespace damaged and didn't apply et all
>   so I had to manually change the Kconfig to merge your change. ]
>   
D'Oh .. Probably due to the fact that I copied it and did not attach it 
in plain/text.

 Thanks

> Thanks,
> Bart
>
>   

regards,
Patrick
