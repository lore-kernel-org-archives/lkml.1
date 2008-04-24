Return-Path: <linux-kernel-owner+w=401wt.eu-S1762732AbYDXStw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762732AbYDXStw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 14:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753939AbYDXSto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 14:49:44 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:28601 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760160AbYDXStn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 14:49:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=svuLyTMABy2bWYHYlOwuMI1QIqby22hXHzaTjsRn1tlrgvSk7ONtnccSq6RSWZ4dzJp9zS4O+EMAEeefk+6JJGmsYr02N/CEg/BsCdyuceyE0jXHcKQ/Tlikegpu6Utj1rn35HuQLZjnuKeuwinz3pjFkVNE59fF7FvubDjJQaw=
Message-ID: <4810D12E.4030700@googlemail.com>
Date: Thu, 24 Apr 2008 20:27:58 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Ingo Molnar <mingo@redhat.com>
Subject: Re: BIOS bug, APIC version is 0 for CPU#0!
References: <480F2842.4010505@googlemail.com>
In-Reply-To: <480F2842.4010505@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:
> Hi,
> 
> I've just compiled latest linus git tree and getting now on an Q9300 Core2Quad , ASUS P5E-VM DO motherboard with BIOS Ver. 0606 , BIOS Rev. 8.12
> the BIOS bug for CPU#0 message for each processor ?!? That seems somewhat buggy ?:)
> 
> That BIOS version is beta and may be really buggy but I never got such a message on 2.6.24* nor on 2.6.25.
> 
> 
> --($:~)-- uname -a
> Linux thor 2.6.25-03530-g94bc891 #773 SMP PREEMPT Wed Apr 23 13:55:10 CEST 2008 i686 GNU/Linux
> 
> 
> ..
> 
> [    0.000000] ACPI: PM-Timer IO Port: 0x808
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> [    0.000000] BIOS bug, APIC version is 0 for CPU#0! fixing up to 0x10. (tell your hw vendor)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
> [    0.000000] BIOS bug, APIC version is 0 for CPU#0! fixing up to 0x10. (tell your hw vendor)
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
> [    0.000000] BIOS bug, APIC version is 0 for CPU#0! fixing up to 0x10. (tell your hw vendor)
> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
> [    0.000000] BIOS bug, APIC version is 0 for CPU#0! fixing up to 0x10. (tell your hw vendor)
> [    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 4, version 32, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
> [    0.000000] ACPI: HPET id: 0xffffffff base: 0xfed00000
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> 
> ...
> 
> Please let me know if you need more infos , dmesg , config etc .
> 

I don't see that message on the same kernel but built for 64bit.

...

[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0xffffffff base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information

...


So it is 32bit only ? And if yes how it is a HW bug ?


Gabriel
