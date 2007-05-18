Return-Path: <linux-kernel-owner+w=401wt.eu-S1757268AbXERLSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268AbXERLSO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 07:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755116AbXERLSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 07:18:00 -0400
Received: from dedi.luli.de ([88.198.62.74]:55904 "EHLO dedi.luli.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754848AbXERLR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 07:17:59 -0400
Message-ID: <464D8B65.4040101@rootdir.de>
Date: Fri, 18 May 2007 13:17:57 +0200
From: Claas Langbehn <claas@rootdir.de>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: This kernel requires the following features not present on the
 CPU... (on a VIA C7 CPU)
References: <464C4A22.7040709@rootdir.de> <464CA006.2080501@zytor.com>
In-Reply-To: <464CA006.2080501@zytor.com>
Content-Type: multipart/mixed;
 boundary="------------060202020905080209060905"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060202020905080209060905
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

H. Peter Anvin schrieb:
> Claas Langbehn wrote:
>   
>> Now my question is:
>>
>> Would it be possible to override the BIOS settings of cx8 and nx and
>> activate it with linux anyway?
>> The CPU supports it and I don't see any reason to disable it.
>>
>>     
>
> Yes, that code is already in the git.newsetup tree.
>   

I just tried this code and it did not work. I am still getting the error 
message from the topic.
This crappy BIOS disables the CPU flags each time. I have to reactivate 
it before each boot time :(

I attached a "x86info -a -v", if it helps.


many regards,
claas

--------------060202020905080209060905
Content-Type: text/plain;
 name="VIA_C7_Esther.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="VIA_C7_Esther.txt"

x86info v1.18.  Dave Jones 2001-2006
Feedback to <davej@redhat.com>.

Found 1 CPU
MP Table:
#	APIC ID	Version	State		Family	Model	Step	Flags
#	 0	 0x11	 BSP, usable	 6	 10	 9	 0xfbff

--------------------------------------------------------------------------
eax in: 0x00000000, eax = 00000001 ebx = 746e6543 ecx = 736c7561 edx = 48727561
eax in: 0x00000001, eax = 000006a9 ebx = 00010800 ecx = 00000081 edx = 87c9bbff

eax in: 0x80000000, eax = 80000006 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000001, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00100000
eax in: 0x80000002, eax = 20202020 ebx = 20202020 ecx = 20202020 edx = 20202020
eax in: 0x80000003, eax = 56202020 ebx = 45204149 ecx = 65687473 edx = 72702072
eax in: 0x80000004, eax = 7365636f ebx = 20726f73 ecx = 30303531 edx = 007a484d
eax in: 0x80000005, eax = 00000000 ebx = 08800880 ecx = 40040140 edx = 40040140
eax in: 0x80000006, eax = 00000000 ebx = 00000000 ecx = 0080a140 edx = 00000000

eax in: 0xc0000000, eax = c0000002 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0xc0000001, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00003fcc
eax in: 0xc0000002, eax = 00000000 ebx = 08000810 ecx = 08100f13 edx = 42000000

Family: 6 Model: 10 Stepping: 9
CPU Model : VIA C3 (Esther) [C7-M]
Processor name string: VIA Esther processor 1500MHz

Feature flags:
	Onboard FPU
	Virtual Mode Extensions
	Debugging Extensions
	Page Size Extensions
	Time Stamp Counter
	Model-Specific Registers
	Physical Address Extensions
	Machine Check Architecture
	CMPXCHG8 instruction
	Onboard APIC
	SYSENTER/SYSEXIT
	Memory Type Range Registers
	Page Global Enable
	CMOV instruction
	Page Attribute Table
	CLFLUSH instruction
	ACPI via MSR
	MMX support
	FXSAVE and FXRESTORE instructions
	SSE support
	SSE2 support
	Pending Break Enable

Extended feature flags:

Instruction TLB: 8-way associative. 128 entries.
Data TLB: 8-way associative. 128 entries.
L1 Data cache:
	Size: 64Kb	4-way associative.
	lines per tag=1	line size=64 bytes.
L1 Instruction cache:
	Size: 64Kb	4-way associative.
	lines per tag=1	line size=64 bytes.
L2 (on CPU) cache:
	Size: 128Kb	10-way associative.
	lines per tag=1	line size=64 bytes.
FCR: MSR: 0x00001107=0x9f1f1ac6 : 10011111 00011111 00011010 11000110
Power management: 
MTRR registers:
MTRRcap (0xfe): 0x0000000000000508
MTRRphysBase0 (0x200): 0x0000000000000006
MTRRphysMask0 (0x201): 0x0000000fc0000800
MTRRphysBase1 (0x202): 0x000000003c000000
MTRRphysMask1 (0x203): 0x0000000ffc000800
MTRRphysBase2 (0x204): 0x00000000d8000001
MTRRphysMask2 (0x205): 0x0000000ffc000800
MTRRphysBase3 (0x206): 0x000000003bf00000
MTRRphysMask3 (0x207): 0x0000000ffff00800
MTRRphysBase4 (0x208): 0x00000000a0000001
MTRRphysMask4 (0x209): 0x00000000fc000800
MTRRphysBase5 (0x20a): 0x0000000000000000
MTRRphysMask5 (0x20b): 0x0000000000000000
MTRRphysBase6 (0x20c): 0x0000000000000000
MTRRphysMask6 (0x20d): 0x0000000000000000
MTRRphysBase7 (0x20e): 0x0000000000000000
MTRRphysMask7 (0x20f): 0x0000000000000000
MTRRfix64K_00000 (0x250): 0x0606060606060606
MTRRfix16K_80000 (0x258): 0x0606060606060606
MTRRfix16K_A0000 (0x259): 0x0000000000000000
MTRRfix4K_C8000 (0x269): 0x0505050505050505
MTRRfix4K_D0000 0x26a: 0x0000000000000000
MTRRfix4K_D8000 0x26b: 0x0000000000000000
MTRRfix4K_E0000 0x26c: 0x0000000000000000
MTRRfix4K_E8000 0x26d: 0x0000000000000000
MTRRfix4K_F0000 0x26e: 0x0404040404040404
MTRRfix4K_F8000 0x26f: 0x0404040404040400
MTRRdefType (0x2ff): 0x0000000000000c00


800MHz processor (estimate).


--------------060202020905080209060905--
