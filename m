Return-Path: <linux-kernel-owner+w=401wt.eu-S1763098AbXGFLLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763098AbXGFLLr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 07:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758871AbXGFLLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 07:11:40 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:48643 "EHLO
	outbound2-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758384AbXGFLLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 07:11:39 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Message-ID: <468E22CF.6070602@amd.com>
Date: Fri, 06 Jul 2007 13:09:03 +0200
From: "Matthias Lenk" <matthias.lenk@amd.com>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: "Andi Kleen" <ak@suse.de>
cc: "Aaron Durbin" <adurbin@google.com>, linux-kernel@vger.kernel.org,
       akpm@osdl.org
Subject: Re: [PATCH] i386/x86_64: Insert HPET firmware resource after
 PCI enumeration has completed
References: <20070705222724.GA12537@google.com>
 <200707061259.36526.ak@suse.de>
In-Reply-To: <200707061259.36526.ak@suse.de>
X-OriginalArrivalTime: 06 Jul 2007 11:09:03.0487 (UTC)
 FILETIME=[0FE780F0:01C7BFBE]
X-WSS-ID: 6A90FCD11A4931273-02-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Aaron, I tested the patch on my affected system and unfortunately it did 
not work. The BAR1 resource still gets overridden and hence the same 
effects as before.

Thanks,

Matthias

Andi Kleen wrote:
> On Friday 06 July 2007 00:27:24 Aaron Durbin wrote:
>   
>> Insert HPET resources after pci probing has been completed in order to avoid
>> resource conflicts with PCI resource reservation. With this change the
>> HPET firmware resources will be identified, but it should also not cause
>> issues when the HPET address falls on a BAR in a PCI device, and the PCI
>> enumeration cannot reserve the resources.
>>     
>
> But what advantage does it have when it's already reserved by PCI?
>
> That's only a cosmetic change, isn't it?  A lot of code for cosmetics.
>
> -Andi
>
>
>   




