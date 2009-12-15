Return-Path: <linux-kernel-owner+w=401wt.eu-S1754177AbZLOSmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbZLOSmn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 13:42:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbZLOSml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 13:42:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:48154 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbZLOSmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 13:42:38 -0500
Message-ID: <4B27D7E9.4030105@kernel.org>
Date: Tue, 15 Dec 2009 10:39:37 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       rdreier@cisco.com, Suresh Siddha <suresh.b.siddha@intel.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: kexec boot regression
References: <20091215115052.GA28252@kernel.dk> <4B277AB2.8030107@kernel.org> <20091215121436.GB28252@kernel.dk> <4B2781AC.8020301@kernel.org> <20091215123951.GD28252@kernel.dk> <4B278734.2040704@kernel.org> <20091215141105.GK28252@kernel.dk>
In-Reply-To: <20091215141105.GK28252@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Tue, Dec 15 2009, Yinghai Lu wrote:
>>>>>>>
>>>>>> let see how BIOS mess it up again!
>>>>> Heh, I had a feeling this was coming :-)

[    0.000000] user-defined physical RAM map:

[    0.000000]  user: 0000000000000100 - 0000000000098800 (usable)

[    0.000000]  user: 0000000000098800 - 00000000000a0000 (reserved)

[    0.000000]  user: 00000000000e0000 - 0000000000100000 (reserved)

[    0.000000]  user: 0000000000100000 - 0000000078c63000 (usable)

[    0.000000]  user: 0000000078c63000 - 0000000078e77000 (ACPI NVS)

[    0.000000]  user: 0000000078e77000 - 000000007924e000 (ACPI data)

[    0.000000]  user: 000000007924e000 - 00000000792c2000 (reserved)

[    0.000000]  user: 00000000792c2000 - 00000000792d2000 (ACPI data)

[    0.000000]  user: 00000000792d2000 - 00000000792e7000 (reserved)

[    0.000000]  user: 00000000792e7000 - 0000000079301000 (ACPI data)

[    0.000000]  user: 0000000079301000 - 0000000079303000 (reserved)

[    0.000000]  user: 0000000079303000 - 0000000079305000 (ACPI data)


[    0.000000]  user: 0000000079305000 - 0000000079310000 (reserved)

[    0.000000]  user: 0000000079310000 - 0000000079314000 (ACPI data)

[    0.000000]  user: 0000000079314000 - 0000000079319000 (reserved)

[    0.000000]  user: 0000000079319000 - 0000000079336000 (ACPI data)

[    0.000000]  user: 0000000079336000 - 0000000079358000 (reserved)

[    0.000000]  user: 0000000079358000 - 0000000079388000 (ACPI data)

[    0.000000]  user: 0000000079388000 - 00000000793c9000 (reserved)

[    0.000000]  user: 00000000793c9000 - 000000007968f000 (ACPI data)

[    0.000000]  user: 000000007968f000 - 00000000796bb000 (reserved)

[    0.000000]  user: 00000000796bb000 - 00000000799d8000 (ACPI data)

[    0.000000]  user: 00000000799d8000 - 0000000079bd8000 (ACPI NVS)

[    0.000000]  user: 0000000079bd8000 - 0000000079d87000 (ACPI data)

[    0.000000]  user: 0000000079d87000 - 0000000079d8a000 (reserved)

[    0.000000]  user: 0000000079d8a000 - 0000000079dca000 (ACPI data)

[    0.000000]  user: 0000000079dca000 - 0000000079dcb000 (reserved)

[    0.000000]  user: 0000000079dcb000 - 0000000079e1c000 (ACPI data)

[    0.000000]  user: 0000000079e1c000 - 0000000079e87000 (reserved)

[    0.000000]  user: 0000000079e87000 - 000000007bd5f000 (ACPI data)

[    0.000000]  user: 000000007bd5f000 - 000000007be4f000 (reserved)

[    0.000000]  user: 000000007be4f000 - 000000007bf87000 (ACPI data)

[    0.000000]  user: 0000000100000000 - 0000001080000000 (usable)
...
[    0.000000] SRAT: Node 0 PXM 0 0-80000000

[    0.000000] SRAT: Node 0 PXM 0 100000000-480000000

[    0.000000] SRAT: Node 2 PXM 1 480000000-880000000

[    0.000000] SRAT: Node 1 PXM 2 880000000-c80000000

[    0.000000] SRAT: Node 3 PXM 3 c80000000-1080000000

[    0.000000] ACPI: [SRAT:0x01] ignored 16 entries of 32 found

[    0.000000] NUMA: Using 31 for the hash shift.

[    0.000000] SRAT: PXMs only cover 49035MB of your 65419MB e820 RAM. Not used.

[    0.000000] SRAT: SRAT not used.

[    0.000000] No NUMA configuration found

so SRAT is broken?

        if (max_entries && count > max_entries) {
                printk(KERN_WARNING PREFIX "[%4.4s:0x%02x] ignored %i entries of "
                       "%i found\n", id, entry_id, count - max_entries, count);
        }
...

or what is your CONFIG_NODES_SHIFT? 3? can you try to set it to 6?

[   13.018720] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0x80000000-0x8fffffff] (base 0x80000000)

[   13.100724] [Firmware Bug]: PCI: MMCONFIG at [mem 0x80000000-0x8fffffff] not reserved in ACPI motherboard resources

[   13.112475] PCI: not using MMCONFIG

[   13.206650] ACPI: No dock devices found.

so mmconf is not used...<ask BIOS fix it please!>

then we get 

[   13.990335] IOH bus: [00, 00]

[   13.993707] IOH bus: 00 index 0 io port: [0, fff]

[   13.999023] IOH bus: 00 index 1 mmio: [0, ffffff]

[   14.004335] IOH bus: 00 index 2 mmio: [0, 3ffffff]

please check

[PATCH] x86/pci: intel ioh bus num reg accessing fix

it is above 0x100, so if mmconf is not enable, need to skip it

Reported-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/pci/intel_bus.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6/arch/x86/pci/intel_bus.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/intel_bus.c
+++ linux-2.6/arch/x86/pci/intel_bus.c
@@ -49,6 +49,10 @@ static void __devinit pci_root_bus_res(s
 	u64 mmioh_base, mmioh_end;
 	int bus_base, bus_end;
 
+	/* some sys doesn't get mmconf enabled */
+	if (dev->cfg_size < 0x200)
+		return;
+
 	if (pci_root_num >= PCI_ROOT_NR) {
 		printk(KERN_DEBUG "intel_bus.c: PCI_ROOT_NR is too small\n");
 		return;
