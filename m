Return-Path: <linux-kernel-owner+w=401wt.eu-S937035AbXHOXRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937035AbXHOXRm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 19:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933974AbXHOXRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 19:17:24 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:56466 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932738AbXHOXRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 19:17:22 -0400
Message-ID: <46C3897A.6060106@nortel.com>
Date: Wed, 15 Aug 2007 17:17:14 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: dual Xeon hyperthread system only showing up as 2 cpus
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Aug 2007 23:17:18.0441 (UTC) FILETIME=[6CA65D90:01C7DF92]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi all,

I've got a system that has two hyperthread-capable Xeons.  If I boot it 
with 2.6.10 it shows up as 4 cpus, but with 2.6.14 it only shows 2 cpus.

The relevent boot logs are:

2.6.10:

DMI 2.3 present.
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 15:2 APIC version 20
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x06] enabled)
Processor #6 15:2 APIC version 20
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
Processor #1 15:2 APIC version 20
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x07] enabled)
Processor #7 15:2 APIC version 20
Using ACPI for processor (LAPIC) configuration information
Intel MultiProcessor Specification v1.4
     Virtual Wire compatibility mode.
<snip>
Processors: 4


2.6.14:

DMI 2.3 present.
Intel MultiProcessor Specification v1.4
     Virtual Wire compatibility mode.
OEM ID: INTEL    Product ID: KingsCanyonC APIC at: 0xFEE00000
Processor #0 15:2 APIC version 20
Processor #6 15:2 APIC version 20
<snip>
Processors: 2


The 2.6.14 config file includes:
CONFIG_MPENTIUM4=y
CONFIG_X86_CMPXCHG=y
CONFIG_X86_XADD=y
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
# CONFIG_HPET_TIMER is not set
CONFIG_SMP=y
CONFIG_NR_CPUS=4
# CONFIG_SCHED_SMT is not set
CONFIG_PREEMPT_NONE=y
CONFIG_PREEMPT_BKL=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_TSC=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_NONFATAL=y
CONFIG_X86_MCE_P4THERMAL=y
CONFIG_MICROCODE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y


Anyone have any ideas?

Chris


