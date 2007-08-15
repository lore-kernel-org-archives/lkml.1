Return-Path: <linux-kernel-owner+w=401wt.eu-S935335AbXHOSnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935335AbXHOSnV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 14:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763180AbXHOSnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 14:43:09 -0400
Received: from smtp-103-wednesday.nerim.net ([62.4.16.103]:56956 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753739AbXHOSnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 14:43:08 -0400
Date: Wed, 15 Aug 2007 20:43:44 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Thomas Renninger <trenn@suse.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, abelay@novell.com,
       Andi Kleen <ak@suse.de>, linux-acpi <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH] (for review and testing first) Implement dynamic
 allocated array for pnp port/io resources
Message-ID: <20070815204344.42658d2b@hyperion.delvare>
In-Reply-To: <1187186605.8780.669.camel@queen.suse.de>
References: <1187186605.8780.669.camel@queen.suse.de>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Wed, 15 Aug 2007 16:03:24 +0200, Thomas Renninger wrote:
> I saw recent Lindentation patches for pnp. I expect they came in after
> -rc2?
> This one is against 2.6.23-rc2 and might not patch with latest git
> repository changes then.

It applied fine on top of 2.6.23-rc3-git1.

I've tested your patch, here are the logs I get if you're interested:

Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: ACPI device : hid PNP0C01
pnp: ACPI device : hid PNP0A03
pnp: Adding resource: 0xcf8
pnp: pnpacpi_parse_allocated_ioresource: We want port 0 - We have: 0 free ports
pnp: pnp_port_alloc: Allocated ports: SUCCESS

pnp: ACPI device : hid PNP0C02
pnp: Adding resource: 0x4000
pnp: pnpacpi_parse_allocated_ioresource: We want port 0 - We have: 0 free ports
pnp: pnp_port_alloc: Allocated ports: SUCCESS

pnp: Adding resource: 0x5000
pnp: pnpacpi_parse_allocated_ioresource: We want port 1 - We have: 8 free ports
pnp: ACPI device : hid PNP0C02
pnp: Adding resource: 0x10
pnp: pnpacpi_parse_allocated_ioresource: We want port 0 - We have: 0 free ports
pnp: pnp_port_alloc: Allocated ports: SUCCESS

pnp: Adding resource: 0x22
pnp: pnpacpi_parse_allocated_ioresource: We want port 1 - We have: 8 free ports
pnp: Adding resource: 0x44
pnp: pnpacpi_parse_allocated_ioresource: We want port 2 - We have: 8 free ports
pnp: Adding resource: 0x62
pnp: pnpacpi_parse_allocated_ioresource: We want port 3 - We have: 8 free ports
pnp: Adding resource: 0x65
pnp: pnpacpi_parse_allocated_ioresource: We want port 4 - We have: 8 free ports
pnp: Adding resource: 0x74
pnp: pnpacpi_parse_allocated_ioresource: We want port 5 - We have: 8 free ports
pnp: Adding resource: 0x91
pnp: pnpacpi_parse_allocated_ioresource: We want port 6 - We have: 8 free ports
pnp: Adding resource: 0xa2
pnp: pnpacpi_parse_allocated_ioresource: We want port 7 - We have: 8 free ports
pnp: Adding resource: 0xe0
pnp: pnpacpi_parse_allocated_ioresource: We want port 8 - We have: 8 free ports
pnp: New ports reallocated, we now have: 16
pnp: pnp_port_alloc: Allocated ports: SUCCESS

pnp: Adding resource: 0x4d0
pnp: pnpacpi_parse_allocated_ioresource: We want port 9 - We have: 16 free ports
pnp: Adding resource: 0x800
pnp: pnpacpi_parse_allocated_ioresource: We want port 10 - We have: 16 free ports
pnp: Adding resource: 0x290
pnp: pnpacpi_parse_allocated_ioresource: We want port 11 - We have: 16 free ports
pnp: ACPI device : hid PNP0200
pnp: Adding resource: 0x0
pnp: pnpacpi_parse_allocated_ioresource: We want port 0 - We have: 0 free ports
pnp: pnp_port_alloc: Allocated ports: SUCCESS

pnp: Adding resource: 0x80
pnp: pnpacpi_parse_allocated_ioresource: We want port 1 - We have: 8 free ports
pnp: Adding resource: 0x94
pnp: pnpacpi_parse_allocated_ioresource: We want port 2 - We have: 8 free ports
pnp: Adding resource: 0xc0
pnp: pnpacpi_parse_allocated_ioresource: We want port 3 - We have: 8 free ports
pnp: ACPI device : hid PNP0B00
pnp: Adding resource: 0x70
pnp: pnpacpi_parse_allocated_ioresource: We want port 0 - We have: 0 free ports
pnp: pnp_port_alloc: Allocated ports: SUCCESS

pnp: ACPI device : hid PNP0800
pnp: Adding resource: 0x61
pnp: pnpacpi_parse_allocated_ioresource: We want port 0 - We have: 0 free ports
pnp: pnp_port_alloc: Allocated ports: SUCCESS

pnp: ACPI device : hid PNP0C04
pnp: Adding resource: 0xf0
pnp: pnpacpi_parse_allocated_ioresource: We want port 0 - We have: 0 free ports
pnp: pnp_port_alloc: Allocated ports: SUCCESS

pnp: ACPI device : hid PNP0501
pnp: Adding resource: 0x3f8
pnp: pnpacpi_parse_allocated_ioresource: We want port 0 - We have: 0 free ports
pnp: pnp_port_alloc: Allocated ports: SUCCESS

pnp: ACPI device : hid PNP0400
pnp: Adding resource: 0x378
pnp: pnpacpi_parse_allocated_ioresource: We want port 0 - We have: 0 free ports
pnp: pnp_port_alloc: Allocated ports: SUCCESS

pnp: ACPI device : hid PNP0F13
pnp: ACPI device : hid PNP0303
pnp: Adding resource: 0x60
pnp: pnpacpi_parse_allocated_ioresource: We want port 0 - We have: 0 free ports
pnp: pnp_port_alloc: Allocated ports: SUCCESS

pnp: Adding resource: 0x64
pnp: pnpacpi_parse_allocated_ioresource: We want port 1 - We have: 8 free ports
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered

pnp: the driver 'system' has been registered
pnp: match found with the PnP device '00:00' and the driver 'system'
pnp: match found with the PnP device '00:02' and the driver 'system'
pnp: 00:02: ioport range 0x4000-0x407f has been reserved
pnp: 00:02: ioport range 0x5000-0x500f has been reserved
pnp: match found with the PnP device '00:03' and the driver 'system'
pnp: 00:03: ioport range 0x4d0-0x4d1 has been reserved
pnp: 00:03: ioport range 0x800-0x805 has been reserved
pnp: 00:03: ioport range 0x290-0x297 has been reserved

pnp: the driver 'serial' has been registered
pnp: match found with the PnP device '00:08' and the driver 'serial'
00:08: ttyS0 at I/O 0x3f8 (irq = 0) is a 16550A

pnp: the driver 'i8042 kbd' has been registered
pnp: match found with the PnP device '00:0b' and the driver 'i8042 kbd'
pnp: the driver 'i8042 aux' has been registered
pnp: match found with the PnP device '00:0a' and the driver 'i8042 aux'
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 0,0
PNP: PS/2 controller doesn't have KBD irq; using default 1
PNP: PS/2 controller doesn't have AUX irq; using default 12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
input: ImPS/2 Logitech Wheel Mouse as /devices/platform/i8042/serio1/input/input1

pnp: the driver 'parport_pc' has been registered
pnp: match found with the PnP device '00:09' and the driver 'parport_pc'
parport_pc 00:09: reported by Plug and Play ACPI
parport0: PC-style at 0x378 [PCSPP,TRISTATE,EPP]
lp0: using parport0 (polling).

And here's the diff of /proc/ioports after applying your patch:

--- /tmp/ioports.before	2007-08-15 20:08:17.000000000 +0200
+++ /tmp/ioports.after	2007-08-15 20:36:57.000000000 +0200
@@ -13,7 +13,8 @@
 01f0-01f7 : 0000:00:0f.0
   01f0-01f7 : ide0
 0290-0297 : f71805f
-  0295-0296 : f71805f
+  0290-0297 : pnp 00:03
+    0295-0296 : f71805f
 0376-0376 : 0000:00:0f.0
   0376-0376 : ide1
 0378-037a : parport0
@@ -21,6 +22,8 @@
 03f6-03f6 : 0000:00:0f.0
   03f6-03f6 : ide0
 03f8-03ff : serial
+04d0-04d1 : pnp 00:03
+0800-0805 : pnp 00:03
 0cf8-0cff : PCI conf1
 4000-407f : pnp 00:02
   4000-4003 : ACPI PM1a_EVT_BLK

Let me know if you want me to test anything in particular.

-- 
Jean Delvare
