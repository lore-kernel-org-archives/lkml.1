Return-Path: <linux-kernel-owner+w=401wt.eu-S1753437AbXC2NF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbXC2NF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 09:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbXC2NF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 09:05:26 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:36178 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753437AbXC2NFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 09:05:24 -0400
Message-ID: <460BB958.4070307@free.fr>
Date: Thu, 29 Mar 2007 15:04:24 +0200
From: John <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Lee Revell <rlrevell@joe-job.com>, mingo@elte.hu, akpm@osdl.org,
       linux-apps@vger.kernel.org, linux.kernel@free.fr
Subject: Re: 2.6.20.3-rt8 - DMA suffers excessive delay periodically
References: <46094728.40300@free.fr>	 <75b66ecd0703271341x34463c49w64bdac21a9741355@mail.gmail.com>	 <460A297A.2030200@free.fr> <75b66ecd0703280916v5a9ed49u2f2549a455e832f1@mail.gmail.com>
In-Reply-To: <75b66ecd0703280916v5a9ed49u2f2549a455e832f1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lee Revell wrote:

> John wrote:
> 
>> Would someone know how to disable SMM in this BIOS?
> 
> There's no generic way.

I understand. Would someone know how to disable SMM in the VIA Pro133T 
chipset (VT82C596B south bridge). What I/O ports do I need to write to, 
and what values should I write to these ports?

> Try disabling USB keyboard emulation and any unused peripherals.

I have disabled everything I could find in the BIOS. Serial and parallel 
ports, USB, integrated sound, APM, ACPI, booting from exotic hardware or 
from the network. To no avail :-(

> Also google "RTAI disable SMM".

I see that they have a Linux kernel module to disable SMM in Intel 
chipsets. But I didn't see the equivalent for VIA chipsets.

>>> Is this a laptop?  They are plagued with SMM problems...
>>
>> No it is an "indutrial" motherboard.
>> Although I don't know what makes it "industrial".
> 
> One would really hope that such a device would be designed for machine
> control and similar RT apps and thus free of SMM...

Indeed...

I wonder if VIA thinks their old chipsets were industrial-grade.

Regards.
