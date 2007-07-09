Return-Path: <linux-kernel-owner+w=401wt.eu-S1755343AbXGIOIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbXGIOIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 10:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbXGIOIC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 10:08:02 -0400
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:54278 "EHLO
	outbound1-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752519AbXGIOIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 10:08:00 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Message-ID: <46924116.1080901@amd.com>
Date: Mon, 09 Jul 2007 16:07:18 +0200
From: "Matthias Lenk" <matthias.lenk@amd.com>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: "Andi Kleen" <ak@suse.de>
cc: "Aaron Durbin" <adurbin@google.com>, linux-kernel@vger.kernel.org,
       akpm@osdl.org
Subject: Re: [PATCH] i386/x86_64: Insert HPET firmware resource after
 PCI enumeration has completed
References: <20070705222724.GA12537@google.com>
 <200707061259.36526.ak@suse.de> <468E22CF.6070602@amd.com>
In-Reply-To: <468E22CF.6070602@amd.com>
X-OriginalArrivalTime: 09 Jul 2007 14:07:17.0432 (UTC)
 FILETIME=[753B4380:01C7C232]
X-WSS-ID: 6A8C9E920X81073496-02-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi, Aaron,
I retested the patch with Andi's patch not reverted (that's the way it's 
meant to be I guess) and then it works! I can now boot with HPET enabled.

Thanks,

Matthias

Matthias Lenk wrote:
> Aaron, I tested the patch on my affected system and unfortunately it 
> did not work. The BAR1 resource still gets overridden and hence the 
> same effects as before.
>
> Thanks,
>
> Matthias
>
> Andi Kleen wrote:
>> On Friday 06 July 2007 00:27:24 Aaron Durbin wrote:
>>  
>>> Insert HPET resources after pci probing has been completed in order 
>>> to avoid
>>> resource conflicts with PCI resource reservation. With this change the
>>> HPET firmware resources will be identified, but it should also not 
>>> cause
>>> issues when the HPET address falls on a BAR in a PCI device, and the 
>>> PCI
>>> enumeration cannot reserve the resources.
>>>     
>>
>> But what advantage does it have when it's already reserved by PCI?
>>
>> That's only a cosmetic change, isn't it?  A lot of code for cosmetics.
>>
>> -Andi
>>
>>
>>   
>
>
>




