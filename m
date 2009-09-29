Return-Path: <linux-kernel-owner+w=401wt.eu-S1753115AbZI2XOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbZI2XOn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 19:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbZI2XOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 19:14:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44985 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbZI2XOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 19:14:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stefani Seibold <stefani@seibold.net>
Subject: Re: PCI Express-to-PCI Bridge: yenta_cardbus  no bus associated!
Date: Wed, 30 Sep 2009 01:15:54 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <1254248605.8881.1.camel@wall-e>
In-Reply-To: <1254248605.8881.1.camel@wall-e>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200909300115.54263.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding CCs.]

On Tuesday 29 September 2009, Stefani Seibold wrote:
> Hi PCI Hackers,
> 
> i have trouble with an ExpressCard PCI Express-to-PCI Bridge
> manufactured by DUEL System under X86/32 Linux kernel 2.6.31.
> 
> The kernel will recognized the Texas Instruments XIO2000(A)/XIO2200(A)
> PCI Express-to-PCI Bridge and the attached Texas Instruments PCIxx12
> Cardbus Controller, but the yenta socket driver will fail with the
> message:
> 
> yenta_cardbus 0000:0f:00.0: no bus associated! (try 'pci=assign-busses')
> 
> The output of dmesg looks like:
> 
> pci 0000:0e:00.0: supports D1 D2
> pci 0000:0f:00.0: reg 10 32bit mmio: [0x000000-0x000fff]
> pci 0000:0f:00.0: supports D1 D2
> pci 0000:0f:00.0: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:0f:00.0: PME# disabled
> pci 0000:0e:00.0: bridge io port: [0x00-0xfff]
> pci 0000:0e:00.0: bridge 32bit mmio: [0x000000-0x0fffff]
> pci 0000:0e:00.0: bridge 64bit mmio pref: [0x000000-0x0fffff]
> pci 0000:0e:00.0: PCI bridge, secondary bus 0000:0f
> pci 0000:0e:00.0:   IO window: disabled
> pci 0000:0e:00.0:   MEM window: 0xf1c00000-0xf1cfffff
> pci 0000:0e:00.0:   PREFETCH window: disabled
> decode_hpp: Could not get hotplug parameters. Use defaults
> pci 0000:0e:00.0: enabling device (0000 -> 0002)
> pci 0000:0e:00.0: setting latency timer to 64
> yenta_cardbus 0000:0f:00.0: no bus associated! (try 'pci=assign-busses')
> 
> lspci -v shows:
> 
> 0e:00.0 PCI bridge: Texas Instruments XIO2000(A)/XIO2200(A) PCI Express-to-PCI Bridge (rev 03) (prog-if 00 [Normal decode])
> 	Physical Slot: 1
> 	Flags: bus master, fast devsel, latency 0
> 	Bus: primary=0e, secondary=0f, subordinate=0f, sec-latency=64
> 	Memory behind bridge: f1c00000-f1cfffff
> 	Capabilities: [50] Power Management version 2
> 	Capabilities: [60] MSI: Enable- Count=1/16 Maskable- 64bit+
> 	Capabilities: [80] Subsystem: Device 5678:1234
> 	Capabilities: [90] Express PCI/PCI-X Bridge, MSI 00
> 	Capabilities: [100] Advanced Error Reporting
> 
> 0f:00.0 CardBus bridge: Texas Instruments PCIxx12 Cardbus Controller
> 	Subsystem: Texas Instruments Device ac48
> 	Flags: medium devsel, IRQ 255
> 	Memory at f1c00000 (32-bit, non-prefetchable) [disabled] [size=4K]
> 	Bus: primary=00, secondary=00, subordinate=00, sec-latency=0
> 	I/O window 0: 00000000-00000003 [disabled]
> 	I/O window 1: 00000000-00000003 [disabled]
> 	16-bit legacy interface ports at 0001
> 
> 
> Any idea where the problem is located or how can i fix it?
> 
> If you need further information or dumps please contact me.
