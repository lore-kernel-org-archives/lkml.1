Return-Path: <linux-kernel-owner+w=401wt.eu-S1755548AbZHYR6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbZHYR6I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 13:58:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755536AbZHYR6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 13:58:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:33929 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755518AbZHYR6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 13:58:07 -0400
Message-ID: <4A9425E4.40108@kernel.org>
Date: Tue, 25 Aug 2009 10:56:52 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: bugzilla-daemon@bugzilla.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Ricardo Jorge da Fonseca Marques Ferreira 
	<storm@sys49152.net>,
       cebbert@redhat.com
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Bug 13940] iwlagn and sky2 stopped working, ACPI-related
References: <bug-13940-13546@http.bugzilla.kernel.org/> <200908251555.n7PFt7Wt015763@demeter.kernel.org>
In-Reply-To: <200908251555.n7PFt7Wt015763@demeter.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bugzilla-daemon@bugzilla.kernel.org wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=13940
> 
> 
> Chuck Ebbert <cebbert@redhat.com> changed:
> 
>            What    |Removed                     |Added
> ----------------------------------------------------------------------------
>                  CC|                            |yinghai@kernel.org
> 
> 
> 
> 


[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
[    0.000000]  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000b5aa1000 (usable)
[    0.000000]  BIOS-e820: 00000000b5aa1000 - 00000000b5aa7000 (reserved)
[    0.000000]  BIOS-e820: 00000000b5aa7000 - 00000000b5bba000 (usable)
[    0.000000]  BIOS-e820: 00000000b5bba000 - 00000000b5c0f000 (reserved)
[    0.000000]  BIOS-e820: 00000000b5c0f000 - 00000000b5d08000 (usable)
[    0.000000]  BIOS-e820: 00000000b5d08000 - 00000000b5f0f000 (reserved)
[    0.000000]  BIOS-e820: 00000000b5f0f000 - 00000000b5f18000 (usable)
[    0.000000]  BIOS-e820: 00000000b5f18000 - 00000000b5f1f000 (reserved)
[    0.000000]  BIOS-e820: 00000000b5f1f000 - 00000000b5f65000 (usable)
[    0.000000]  BIOS-e820: 00000000b5f65000 - 00000000b5f9f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000b5f9f000 - 00000000b5fe1000 (usable)
[    0.000000]  BIOS-e820: 00000000b5fe1000 - 00000000b5fff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000b5fff000 - 00000000b6000000 (usable)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000140000000 (usable)

some devices don't get allocated resources from BIOS

[    0.819921] pci 0000:00:1f.3: reg 10 64bit mmio: [0x000000-0x0000ff]
[    0.819939] pci 0000:00:1f.3: reg 20 io port: [0x1c00-0x1c1f]
[    0.820029] pci 0000:00:1c.0: bridge io port: [0x00-0xfff]
[    0.820033] pci 0000:00:1c.0: bridge 32bit mmio: [0x000000-0x0fffff]
[    0.820041] pci 0000:00:1c.0: bridge 64bit mmio pref: [0x000000-0x0fffff]
[    0.820113] pci 0000:07:00.0: reg 10 64bit mmio: [0x000000-0x003fff]
[    0.820123] pci 0000:07:00.0: reg 18 io port: [0x00-0xff]
[    0.820203] pci 0000:07:00.0: supports D1 D2
[    0.820204] pci 0000:07:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.820213] pci 0000:07:00.0: PME# disabled
[    0.820289] pci 0000:00:1c.4: bridge io port: [0x00-0xfff]
[    0.820294] pci 0000:00:1c.4: bridge 32bit mmio: [0x000000-0x0fffff]
[    0.820301] pci 0000:00:1c.4: bridge 64bit mmio pref: [0x000000-0x0fffff]
[    0.820388] pci 0000:08:00.0: reg 10 64bit mmio: [0x000000-0x001fff]
[    0.820501] pci 0000:08:00.0: PME# supported from D0 D3hot D3cold
[    0.820510] pci 0000:08:00.0: PME# disabled
[    0.820593] pci 0000:00:1c.5: bridge io port: [0x00-0xfff]
[    0.820598] pci 0000:00:1c.5: bridge 32bit mmio: [0x000000-0x0fffff]
[    0.820605] pci 0000:00:1c.5: bridge 64bit mmio pref: [0x000000-0x0fffff]


will be in
[    0.000000] Allocating PCI resources starting at b6000000 (gap: b6000000:4a000000)

[    7.878413] sky2 driver version 1.23
[    7.884402] sky2 0000:07:00.0: enabling device (0000 -> 0003)
[    7.889483] sky2 0000:07:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    7.894502] sky2 0000:07:00.0: setting latency timer to 64
[    7.894555] sky2 0000:07:00.0: unsupported chip type 0xff
[    7.899554] sky2 0000:07:00.0: PCI INT A disabled
[    7.904379] sky2: probe of 0000:07:00.0 failed with error -95

[    8.857709] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27kds
[    8.863357] iwlagn: Copyright(c) 2003-2009 Intel Corporation
[    8.875763] iwlagn 0000:08:00.0: enabling device (0000 -> 0002)
[    8.881477] iwlagn 0000:08:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    8.887083] iwlagn 0000:08:00.0: setting latency timer to 64
[    8.887128] iwlagn 0000:08:00.0: Detected Intel Wireless WiFi Link 5100AGN REV=0xFDFFFFFF
[    8.892723]   alloc irq_desc for 22 on node 0
[    8.892726]   alloc kstat_irqs on node 0
[    9.073995] iwlagn 0000:08:00.0: Failed, HW not ready
[    9.080292] iwlagn 0000:08:00.0: PCI INT A disabled


07:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8040 PCI-E Fast Ethernet Controller (rev \
12)  Subsystem: Toshiba America Info Systems Device ff50
...
	Memory at b6000000 (64-bit, non-prefetchable) [size=16K]
	I/O ports at 2000 [size=256]
...

08:00.0 Network controller: Intel Corporation Wireless WiFi Link 5100
...
	Memory at b6100000 (64-bit, non-prefetchable) [size=8K]
...



please try to attached patch, that will increae alignment from 32M to 64M.

---
 arch/x86/kernel/e820.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -1378,8 +1378,8 @@ static unsigned long ram_alignment(resou
 	if (mb < 16)
 		return 1024*1024;
 
-	/* To 32MB for anything above that */
-	return 32*1024*1024;
+	/* To 64MB for anything above that */
+	return 64*1024*1024;
 }
 
 #define MAX_RESOURCE_SIZE ((resource_size_t)-1)
