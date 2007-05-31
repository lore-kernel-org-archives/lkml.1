Return-Path: <linux-kernel-owner+w=401wt.eu-S1760013AbXEaEjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760013AbXEaEjP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 00:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbXEaEjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 00:39:00 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:23148 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490AbXEaEjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 00:39:00 -0400
Date: Wed, 30 May 2007 22:38:22 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Case: 7454422: Re: Kernel 2.6.21.3 does not work with 8GB of RAM
 on Intel 965WH motherboards. (FULL DMESG)
In-reply-to: <82e4877d0705301757v580a4ca5yebe2a565f0b97552@mail.gmail.com>
To: Parag Warudkar <parag.warudkar@gmail.com>
Cc: jpiszcz@lucidpixels.com, linux-kernel@vger.kernel.org
Message-id: <465E513E.60903@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <82e4877d0705301757v580a4ca5yebe2a565f0b97552@mail.gmail.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Parag Warudkar wrote:
> Robert Hancock wrote:
> 
> 
>> 0-3319MB
>> 4096-8832MB
>>
>> leaving 64MB of memory at the top of RAM uncached. What do you want to
>> bet that something important (kernel code?) is getting loaded there..
>>
>> So essentially it's a BIOS problem, it's not setting up the MTRRs
>> properly in order to map all of RAM as cacheable. As Andi says, complain
>> to Intel.
>>
> 
> Could the BADRAM patch be useful for him?
> http://rick.vanrein.org/linux/badram/download.html has 2.6.21 version.
> It says it supports x86_64. May be using this patch he can exclude
> that RAM from being used/accessed?

I think that mem=8832M would work as well, to make the kernel use only 
the memory that is marked cacheable. (It looks like this parameter takes 
the highest memory address we want the kernel to use, not the highest 
memory amount.)

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

