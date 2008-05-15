Return-Path: <linux-kernel-owner+w=401wt.eu-S1760526AbYEOTCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760526AbYEOTCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 15:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbYEOTB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 15:01:58 -0400
Received: from mo-p07-ob.rzone.de ([81.169.146.188]:24439 "EHLO
	mo-p07-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbYEOTB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 15:01:57 -0400
X-RZG-CLASS-ID: mo07
X-RZG-AUTH: kN+8IwndbR6Uv2ejxj19QCPuh8a6M5fIB5EQYDxa6UzG74Ew5HDhXeKIRwWNv2bkJw==
Message-ID: <482C8837.3020607@au-79.de>
Date: Thu, 15 May 2008 21:00:07 +0200
From: Robert Goldner <robert@au-79.de>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Problems with mainboard INTEL D201GLY2A, pci devices only available
 with acpi=noirq
References: <fa.vWXVKBGhH014XMsboBQBMW6GFwA@ifi.uio.no> <482B9A13.2020400@shaw.ca>
In-Reply-To: <482B9A13.2020400@shaw.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock schrieb:
> Robert Goldner wrote:
>> Hi everyone,
>>
>> I use a INTEL D201GLY2A mainboard, and after serveral trys PCI devices 
>> were only useable (not visable) with the boot-parameter acpi=noirq (or 
>> noacpi). I tryed several kernel-versions (stated with 2.6.22), and no 
>> sucess without his parameter.
>> Without acpi=noirq all pci devices are deteced well, but if you want 
>> to use them, there is no response.
> 
> Do you have the latest BIOS on this board? Any nonstandard BIOS 
> settings? It looks like the board is not using APIC but the ACPI IRQ 
> information is giving out IRQs over 15, which doesn't make any sense. 
> Maybe you're running in some kind of broken/untested BIOS configuration.


Yes, it was the latest BIOS for this board, but Intel put a new to the 
Internet these days. I updated the Bios, but no change at all.
There is only one ACPI-Relevant switch in the Bios, so I don´t think 
that the Bios configuration is the problem. The only on ACPI-relevant 
option is:
"Resume from S5 by LAN". But I don´t belive that this makes the problem 
(and I tryed both: on and off). There is no way to modify/reservate 
interrups in the Bios.

It looks like very buggy ACPI-tables in the Bios.

Robert
