Return-Path: <linux-kernel-owner+w=401wt.eu-S1761885AbXHNVyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761885AbXHNVyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 17:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757405AbXHNVaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:30:21 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:39377 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761172AbXHNVaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:30:18 -0400
Message-ID: <46C21E15.6020603@vmware.com>
Date: Tue, 14 Aug 2007 14:26:45 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Parag Warudkar <parag.warudkar@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc3 - CONFIG_VMI broken
References: <82e4877d0708140839y3550bfa6of6a369251db517f3@mail.gmail.com>
In-Reply-To: <82e4877d0708140839y3550bfa6of6a369251db517f3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Parag Warudkar wrote:
> CONFIG_VMI seems to be broken, but I am not sure when - the last
> kernel I was running was 2.6.22-rc4 which used to boot fine and use
> VMI. Current git with same configuration causes the kernel to reboot
> early. Logs below.
>
> Deselecting CONFIG_VMI and rebuilding allows the kernel to boot normally.
>
> (I am running it on VMWare workstation 6 latest release.)
>
> Thanks
>
> Parag
>
> Linux version 2.6.23-rc3 (root@ubuntu) (gcc version 4.1.2 (Ubuntu
> 4.1.2-0ubuntu4)) #4 Mon Aug 13 21:50:06 EDT 2007
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
>  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000ca000 - 00000000000cc000 (reserved)
>  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 000000001fef0000 (usable)
>  BIOS-e820: 000000001fef0000 - 000000001feff000 (ACPI data)
>  BIOS-e820: 000000001feff000 - 000000001ff00000 (ACPI NVS)
>  BIOS-e820: 000000001ff00000 - 0000000020000000 (usable)
>  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
>  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
>  BIOS-e820: 00000000fffe0000 - 0000000100000000 (reserved)
> console [earlyser0] enabled
> 0MB HIGHMEM available.
> 512MB LOWMEM available.
> found SMP MP-table at 000f6c90
> VMI: Found VMware, Inc. Hypervisor OPROM, API version 3.0, ROM version 1.0
> Reserving virtual address space above 0xfc000000
> Int 14: CR2 fc37e260  err 00000000  EIP fc37e260  CS 00000062  flags 00010006
> Stack: c0490ec7 c04913cb 00000001 00000000 fc001340 c047fff4 c04a6080 c047aa00
>
>   

Can you send me your kernel config?

Thanks,

Zach
