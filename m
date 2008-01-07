Return-Path: <linux-kernel-owner+w=401wt.eu-S1759505AbYAGXcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759505AbYAGXcr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 18:32:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758479AbYAGXcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 18:32:36 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:49102 "EHLO
	pd4mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759204AbYAGXcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 18:32:35 -0500
Date: Mon, 07 Jan 2008 17:31:58 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: MCFG ACPI patch in git-x86 causes boot regression
In-reply-to: <200801071452.15045.jbarnes@virtuousgeek.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, akpm@osdl.org, rajesh.shah@intel.com,
       greg@kroah.com
Message-id: <4782B66E.8050400@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <20080107224757.GA2336@basil.nowhere.org>
 <200801071452.15045.jbarnes@virtuousgeek.org>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Monday, January 07, 2008 2:47 Andi Kleen wrote:
>> This patch
>>
>> commit c5182babd1d0706f1294af7b8dbf64e378b066bb
>> Author: Robert Hancock <hancockr@shaw.ca>
>> Date:   Sat Jan 5 13:26:32 2008 +0100
>>
>>     x86: validate against ACPI motherboard resources
>>
>> ...
>>
>> recently added to git-x86 causes one of my Intel test systems to not
>> boot unless I specify pci=conf1.
>>
>> ...
>> ACPI: EC: Look up EC in DSDT
>> ACPI: Interpreter enabled
>> ACPI: (supports S0 S3 S4 S5)
>> ACPI: Using IOAPIC for interrupt routing
>> PCI: MCFG configuration 0: base 4026531840 segment 0 buses 0 - 127
>> PCI: MCFG area at f0000000 reserved in ACPI motherboard resources
>> PCI: Using MMCONFIG at f0000000 - f7ffffff
>> ACPI: PCI Root Bridge [PCI0] (0000:00)
>> <hang>
>>
>> The system is a SDV, but I believe production level.
>> DSDT is available at http://firstfloor.org/~andi/dsdt.dsl
>>
>> On previous kernels the MCFG was rejected because it wasn't e820
>> reserved:
> 
> Yep, this patch (as was stated many times) requires other fixes to PCI 
> probing--either disabling decode, not using mmconfig unless absolutely 
> required, or one of the other discussed changes.  I'm not sure why it 
> was pushed before one of those changes went in.

I believe that such a change is in Greg KH's tree. So -mm (with both 
trees) would probably work.
