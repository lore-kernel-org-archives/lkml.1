Return-Path: <linux-kernel-owner+w=401wt.eu-S1753235AbYECTLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbYECTLS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 15:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbYECTK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 15:10:57 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:61109 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbYECTKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 15:10:55 -0400
Message-ID: <481CB8B2.7030404@googlemail.com>
Date: Sat, 03 May 2008 21:10:42 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Ingo Molnar <mingo@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: BIOS bug, APIC version is 0 for CPU#0!
References: <480F2842.4010505@googlemail.com> <4810D12E.4030700@googlemail.com>
In-Reply-To: <4810D12E.4030700@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 May 2008 19:03:58.0048 (UTC) FILETIME=[70BCF600:01C8AD50]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:
> Gabriel C wrote:
>> Hi,
>>
>> I've just compiled latest linus git tree and getting now on an Q9300 Core2Quad , ASUS P5E-VM DO motherboard with BIOS Ver. 0606 , BIOS Rev. 8.12
>> the BIOS bug for CPU#0 message for each processor ?!? That seems somewhat buggy ?:)
>>
>> That BIOS version is beta and may be really buggy but I never got such a message on 2.6.24* nor on 2.6.25.
>>
>>
>> --($:~)-- uname -a
>> Linux thor 2.6.25-03530-g94bc891 #773 SMP PREEMPT Wed Apr 23 13:55:10 CEST 2008 i686 GNU/Linux
>>
>>
>> ..
>>
>> [    0.000000] ACPI: PM-Timer IO Port: 0x808
>> [    0.000000] ACPI: Local APIC address 0xfee00000
>> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
>> [    0.000000] BIOS bug, APIC version is 0 for CPU#0! fixing up to 0x10. (tell your hw vendor)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
>> [    0.000000] BIOS bug, APIC version is 0 for CPU#0! fixing up to 0x10. (tell your hw vendor)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
>> [    0.000000] BIOS bug, APIC version is 0 for CPU#0! fixing up to 0x10. (tell your hw vendor)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
>> [    0.000000] BIOS bug, APIC version is 0 for CPU#0! fixing up to 0x10. (tell your hw vendor)
>> [    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
>> [    0.000000] IOAPIC[0]: apic_id 4, version 32, address 0xfec00000, GSI 0-23
>> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
>> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
>> [    0.000000] ACPI: IRQ0 used by override.
>> [    0.000000] ACPI: IRQ2 used by override.
>> [    0.000000] ACPI: IRQ9 used by override.
>> [    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
>> [    0.000000] ACPI: HPET id: 0xffffffff base: 0xfed00000
>> [    0.000000] Using ACPI (MADT) for SMP configuration information
>>
>> ...
>>
>> Please let me know if you need more infos , dmesg , config etc .
>>
> 
> I don't see that message on the same kernel but built for 64bit.
> 
> ...
> 
> [    0.000000] ACPI: PM-Timer IO Port: 0x808
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
> [    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 4, version 0, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Setting APIC routing to flat
> [    0.000000] ACPI: HPET id: 0xffffffff base: 0xfed00000
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> 
> ...
> 
> 
> So it is 32bit only ? And if yes how it is a HW bug ?
> 

Hi all ,

I'm testing current git on 3 boxes and all got these annoying messages so far on 32bit kernels on all 3 ..
( After a quick scan on LKML posted dmesg's from current git I see a lot such messages too )

Could someone please explain why my HW is broken and why this 'BIOS bug' message is only
relevant on 32bit ? 

generic_processor_info() in apic_64.c does not have such an check. If is a HW bug then why not ?

Assuming my HW is really broken , why is this message displayed 4 times when it should be there just once for CPU#0 ?


Thx,

Gabriel C

 
