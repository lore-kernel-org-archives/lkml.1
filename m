Return-Path: <linux-kernel-owner+w=401wt.eu-S1754934AbYBDMW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbYBDMW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 07:22:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753306AbYBDMWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 07:22:50 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44698 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753197AbYBDMWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 07:22:49 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: Re: 2.6.25-git: "x86: fix ioremap RAM check" causes - ACPI Error... Could not map memory
Date: Mon, 4 Feb 2008 13:20:46 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
References: <200802040228.39880.lenb@kernel.org>
In-Reply-To: <200802040228.39880.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802041320.47495.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 4 of February 2008, Len Brown wrote:
> My HP nx6325 started printing the ACPI Error's below starting at the commit below.

Mine too.

Thanks,
Rafael


> 266b9f8727976769e2ed2dad77ac9295f37e321e is first bad commit
> commit 266b9f8727976769e2ed2dad77ac9295f37e321e
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Wed Jan 30 13:34:06 2008 +0100
> 
>     x86: fix ioremap RAM check
> 
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
>     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> :040000 040000 8e3dfc0d4ae3145f14b684c4da844d3d0550cc3d 2b8673a61062b3548e6341c0155c35acd33a2b00 M      arch
> ...
> Initialized 29/33 Regions 0/0 Fields 63/64 Buffers 68/78 Packages (1172 nodes)
> Initializing Device/Processor/Thermal objects by executing _INI methods:....
> ACPI Error (exregion-0164): Could not map memory at 000000000000010A, size F6 [20070126]
> ACPI Exception (evregion-0420): AE_NO_MEMORY, Returned by Handler for [SystemMemory] [20070126]
> ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.C074.C241._INI] (Node ffff81001b91c180), AE_NO_MEMORY
> ACPI Exception (nsinit-0564): AE_NO_MEMORY, during \_SB_.C074.C241._INI._INI execution [20070126]
> ..
> Executed 6 _INI methods requiring 2 _STA executions (examined 120 objects)
> ACPI: Interpreter enabled
> ACPI: (supports S0 S3 S4 S5)
> ACPI: Using IOAPIC for interrupt routing
> ACPI Error (exregion-0164): Could not map memory at 0000000000000104, size FC [20070126]
> ACPI Exception (evregion-0420): AE_NO_MEMORY, Returned by Handler for [SystemMemory] [20070126]
> ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.C074.C241.C24F.C250._STA] (Node ffff81001b91c768), AE_NO_MEMORY
> ACPI Error (exregion-0164): Could not map memory at 0000000000000184, size 7C [20070126]
> ACPI Exception (evregion-0420): AE_NO_MEMORY, Returned by Handler for [SystemMemory] [20070126]
> ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.C074.C241.C251.C252._STA] (Node ffff81001b91c650), AE_NO_MEMORY
> ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
> ACPI: EC: driver started in interrupt mode
> ACPI: PCI Root Bridge [C074] (0000:00)
> PCI: Transparent bridge - 0000:00:14.4
> ACPI: PCI Interrupt Routing Table [\_SB_.C074._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.C074.C075._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.C074.C0DF._PRT]
> ACPI: PCI Interrupt Link [C125] (IRQs 10 11) *0, disabled.
> ACPI: PCI Interrupt Link [C126] (IRQs 10 11) *0, disabled.
> ACPI: PCI Interrupt Link [C127] (IRQs 10 11) *0, disabled.
> ACPI: PCI Interrupt Link [C128] (IRQs 10 11) *0, disabled.
> ACPI: PCI Interrupt Link [C129] (IRQs 10 11) *0, disabled.
> ACPI: PCI Interrupt Link [C12A] (IRQs 9) *0, disabled.
> ACPI: PCI Interrupt Link [C12B] (IRQs 10 11) *0, disabled.
> ACPI: PCI Interrupt Link [C12C] (IRQs *10 11)
> ACPI: Power Resource [C223] (off)
> ACPI: Power Resource [C1FE] (off)
> ACPI: Power Resource [C217] (on)
> ACPI: Power Resource [C34B] (off)
> ACPI: Power Resource [C34C] (off)
> ACPI: Power Resource [C34D] (off)
> ACPI: Power Resource [C34E] (off)
> Linux Plug and Play Support v0.97 (c) Adam Belay
> pnp: PnP ACPI init
> ACPI: bus type pnp registered
> ACPI Error (exregion-0164): Could not map memory at 0000000000000104, size FC [20070126]
> ACPI Exception (evregion-0420): AE_NO_MEMORY, Returned by Handler for [SystemMemory] [20070126]
> ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.C074.C241.C24F.C250._STA] (Node ffff81001b91c768), AE_NO_MEMORY
> ACPI Error (uteval-0233): Method execution failed [\_SB_.C074.C241.C24F.C250._STA] (Node ffff81001b91c768), AE_NO_MEMORY
> ACPI Error (exregion-0164): Could not map memory at 0000000000000184, size 7C [20070126]
> ACPI Exception (evregion-0420): AE_NO_MEMORY, Returned by Handler for [SystemMemory] [20070126]
> ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.C074.C241.C251.C252._STA] (Node ffff81001b91c650), AE_NO_MEMORY
> ACPI Error (uteval-0233): Method execution failed [\_SB_.C074.C241.C251.C252._STA] (Node ffff81001b91c650), AE_NO_MEMORY
> 



-- 
"Premature optimization is the root of all evil." - Donald Knuth
