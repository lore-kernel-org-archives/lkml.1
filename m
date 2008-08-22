Return-Path: <linux-kernel-owner+w=401wt.eu-S1757688AbYHVHxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757688AbYHVHxz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 03:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbYHVHxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 03:53:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41077 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbYHVHxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 03:53:43 -0400
Date: Fri, 22 Aug 2008 09:53:39 +0200
From: Andi Kleen <andi@firstfloor.org>
To: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: [PATCH] PCI: Document that most pci options are shared between i386 and x86-64
Message-ID: <20080822075339.GA2167@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI: Document that most pci options are shared between i386 and x86-64
    
Since the code is shared pretty much most of the pci= options are shared,
but kernel-parameters.txt marked most of them as i386 only.
    
Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index a897646..fda8faf 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -101,6 +101,7 @@ parameter is applicable:
 	X86-64	X86-64 architecture is enabled.
 			More X86-64 boot options can be found in
 			Documentation/x86_64/boot-options.txt .
+	X86	Either 32bit or 64bit x86 (same as X86-32+X86-64)
 
 In addition, the following text indicates that the option:
 
@@ -1541,7 +1542,7 @@ and is between 256 and 4096 characters. It is defined in the file
 			See also Documentation/paride.txt.
 
 	pci=option[,option...]	[PCI] various PCI subsystem options:
-		off		[X86-32] don't probe for the PCI bus
+		off		[X86] don't probe for the PCI bus
 		bios		[X86-32] force use of PCI BIOS, don't access
 				the hardware directly. Use this if your machine
 				has a non-standard PCI host bridge.
@@ -1549,9 +1550,9 @@ and is between 256 and 4096 characters. It is defined in the file
 				hardware access methods are allowed. Use this
 				if you experience crashes upon bootup and you
 				suspect they are caused by the BIOS.
-		conf1		[X86-32] Force use of PCI Configuration
+		conf1		[X86] Force use of PCI Configuration
 				Mechanism 1.
-		conf2		[X86-32] Force use of PCI Configuration
+		conf2		[X86] Force use of PCI Configuration
 				Mechanism 2.
 		noaer		[PCIE] If the PCIEAER kernel config parameter is
 				enabled, this kernel boot option can be used to
@@ -1571,37 +1572,37 @@ and is between 256 and 4096 characters. It is defined in the file
 				this option if the kernel is unable to allocate
 				IRQs or discover secondary PCI buses on your
 				motherboard.
-		rom		[X86-32] Assign address space to expansion ROMs.
+		rom		[X86] Assign address space to expansion ROMs.
 				Use with caution as certain devices share
 				address decoders between ROMs and other
 				resources.
-		norom		[X86-32,X86_64] Do not assign address space to
+		norom		[X86] Do not assign address space to
 				expansion ROMs that do not already have
 				BIOS assigned address ranges.
-		irqmask=0xMMMM	[X86-32] Set a bit mask of IRQs allowed to be
+		irqmask=0xMMMM	[X86] Set a bit mask of IRQs allowed to be
 				assigned automatically to PCI devices. You can
 				make the kernel exclude IRQs of your ISA cards
 				this way.
-		pirqaddr=0xAAAAA	[X86-32] Specify the physical address
+		pirqaddr=0xAAAAA	[X86] Specify the physical address
 				of the PIRQ table (normally generated
 				by the BIOS) if it is outside the
 				F0000h-100000h range.
-		lastbus=N	[X86-32] Scan all buses thru bus #N. Can be
+		lastbus=N	[X86] Scan all buses thru bus #N. Can be
 				useful if the kernel is unable to find your
 				secondary buses and you want to tell it
 				explicitly which ones they are.
-		assign-busses	[X86-32] Always assign all PCI bus
+		assign-busses	[X86] Always assign all PCI bus
 				numbers ourselves, overriding
 				whatever the firmware may have done.
-		usepirqmask	[X86-32] Honor the possible IRQ mask stored
+		usepirqmask	[X86] Honor the possible IRQ mask stored
 				in the BIOS $PIR table. This is needed on
 				some systems with broken BIOSes, notably
 				some HP Pavilion N5400 and Omnibook XE3
 				notebooks. This will have no effect if ACPI
 				IRQ routing is enabled.
-		noacpi		[X86-32] Do not use ACPI for IRQ routing
+		noacpi		[X86] Do not use ACPI for IRQ routing
 				or for PCI scanning.
-		use_crs		[X86-32] Use _CRS for PCI resource
+		use_crs		[X86] Use _CRS for PCI resource
 				allocation.
 		routeirq	Do IRQ routing for all PCI devices.
 				This is normally done in pci_enable_device(),

