Return-Path: <linux-kernel-owner+w=401wt.eu-S1754245AbXJJHzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245AbXJJHzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 03:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbXJJHzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 03:55:23 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:1844 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbXJJHzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 03:55:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=eSRA+f3z/dABNazKPd6a4dcEBz81xCRdgtUsKZgxEla9hErOm271bovKkesiHjAymBIy5NsDarNo7zUawgQp9Qony39cq940HMrO7Jr0pxoTnRZMJFS627tcZj9mp99+gYuVOnJeM9+Ex4hSlW98JkDY3cPuYGwJJoQpq1W/3CQ=
Message-ID: <6e25f4cc0710100055xeeebca4ve037e56b2ef6ba6@mail.gmail.com>
Date: Wed, 10 Oct 2007 15:55:19 +0800
From: Dafu <maillist.linux@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: kernel panic when loading built-in E1000's driver.
Cc: danmei.wei@alcatel-sbell.com.cn
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

When I run linux kernel ver2.6.10 built by myself, there was a kernel
panic when loading E1000 device driver. (See the details below.)

Then I built E1000 device driver as a loadable module and insmod it in
/etc/rc.d/rc3.d, the ethernet device worked well.

I would like to know what the difference is between loadable modules
and built-in drivers to the kernel. Does anyone encounter this kind of
problems?

Thanks!
Dafu

---

Here is the log of kernel panic:

Loading vmlinuz-tpgsm.......................

Loading initrd-tpgsm.gz.........................................................

................................................................................

................................................................................

Ready..........................................................................Linux
version 2.6.10_mvlcge401-pc_target-x86_pentium3 (danmei.wei@sbardz07)
(gcc version 3.4.3 (MontaVista 3.4.3-25.0.41.0501420 2005-09-07)) #1
Fri Sep 28 09:34:29 CST 2007

BIOS-provided physical RAM map:

BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)

BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)

BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)

BIOS-e820: 0000000000100000 - 0000000020000000 (usable)

BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)

512MB LOWMEM available.

DMI 2.3 present.

ACPI: Unable to locate RSDP

Built 1 zonelists

Kernel command line: BOOT_IMAGE=vmlinuz-tpgsm ramdisk_size=400000
console=ttyS0,38400 initrd=initrd-tpgsm.gz root=/dev/ram0 ide1=noprobe
rw

Initializing CPU#0

PID hash table entries: 4096 (order: 12, 65536 bytes)

Detected 1099.841 MHz processor.

Using hrt_tsc for high-res timesource

Console: colour dummy device 80x25

Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)

Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)

Memory: 457260k/524288k available (1696k kernel code, 66484k reserved,
666k data, 192k init, 0k highmem)

Checking if this processor honours the WP bit even in supervisor mode... Ok.

Mount-cache hash table entries: 512 (order: 0, 4096 bytes)

CPU: L1 I cache: 32K, L1 D cache: 32K

CPU: L2 cache: 1024K

Intel machine check architecture supported.

Intel machine check reporting enabled on CPU#0.

mtrr: v2.0 (20020519)

CPU: Intel(R) Pentium(R) M processor 1100MHz stepping 05

Enabling fast FPU save and restore... done.

Enabling unmasked SIMD FPU exception support... done.

Checking 'hlt' instruction... OK.

spawn_desched_task(00000000)

desched cpu_callback 3/00000000

ksoftirqd started up.

desched cpu_callback 2/00000000

checking if image is initramfs...it isn't (no cpio magic); looks like an initrd

desched thread 0 started up.

Freeing initrd memory: 58779k freed

NET: Registered protocol family 16

PCI: Using configuration type 1

ACPI: Subsystem revision 20041105

ACPI: Interpreter disabled.

PCI: Probing PCI hardware

PCI: Probing PCI hardware (bus 00)

PCI quirk: region 0800-087f claimed by ICH4 ACPI/GPIO/TCO

PCI quirk: region 0480-04bf claimed by ICH4 GPIO

PCI: Transparent bridge - 0000:00:1e.0

PCI: Using IRQ router PIIX/ICH [8086/25a1] at 0000:00:1f.0

IA-32 Microcode Update Driver: v1.14 <tigran@veritas.com>

devfs: 2004-01-31 Richard Gooch (rgooch@atnf.csiro.au)

devfs: boot_options: 0x1

Initializing Cryptographic API

serio: i8042 AUX port at 0x60,0x64 irq 12

serio: i8042 KBD port at 0x60,0x64 irq 1

Serial: 8250/16550 driver $Revision: 1.90 $ 8 ports, IRQ sharing disabled

ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A

ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A

ttyS2 at I/O 0x3e8 (irq = 4) is a 16550A

ttyS3 at I/O 0x2e8 (irq = 3) is a 16550A

io scheduler noop registered

io scheduler anticipatory registered

io scheduler deadline registered

io scheduler cfq registered

RAMDISK driver initialized: 16 RAM disks of 400000K size 1024 blocksize

loop: loaded (max 8 devices)

Intel(R) PRO/1000 Network Driver - version 7.3.15

Copyright (c) 1999-2006 Intel Corporation.

PCI: Found IRQ 11 for device 0000:01:01.0

PCI: Sharing IRQ 11 with 0000:00:02.0

PCI: Sharing IRQ 11 with 0000:00:1d.0

PCI: Sharing IRQ 11 with 0000:01:01.1

e1000: 0000:01:01.0: e1000_probe: (PCI-X:66MHz:64-bit) 00:03:cc:39:06:54

e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection

PCI: Found IRQ 11 for device 0000:01:01.1

PCI: Sharing IRQ 11 with 0000:00:02.0

PCI: Sharing IRQ 11 with 0000:00:1d.0

PCI: Sharing IRQ 11 with 0000:01:01.0

e1000: 0000:01:01.1: e1000_probe: (PCI-X:66MHz:64-bit) 00:03:cc:39:06:55

e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection

mice: PS/2 mouse device common for all mice

NET: Registered protocol family 2

IP: routing cache hash table of 4096 buckets, 32Kbytes

TCP: Hash tables configured (established 131072 bind 65536)

IPv4 over IPv4 tunneling driver

ip_conntrack version 2.1 (4096 buckets, 32768 max) - 180 bytes per conntrack

ip_tables: (C) 2000-2002 Netfilter core team

NET: Registered protocol family 1

NET: Registered protocol family 17

802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>

All bugs added by David S. Miller <davem@redhat.com>

BUG: Unable to handle kernel NULL pointer dereference at virtual
address 00000000

printing eip:

00000000

*pde = 00000000

Oops: 0000 [#1]

Modules linked in:

CPU:    0

EIP:    0060:[<00000000>]    Not tainted VLI

EFLAGS: 00010246   (2.6.10_mvlcge401-pc_target-x86_pentium3)

EIP is at 0x0

eax: dc717c80   ebx: 00000000   ecx: 00000000   edx: 00000000

esi: dc718220   edi: 00000000   ebp: dc71842c   esp: dc641e48

ds: 007b   es: 007b   ss: 0068   preempt: 00010000

Process swapper (pid: 1, threadinfo=dc640000 task=dc661a00)

Stack: c021bbeb dc718220 dc717c80 dc725700 00010000 dc640000 00000001 c012fd96

       0000000b dc718000 dc641ec0 04000000 00000001 dc641ec0 0000000b 000002c0

       0000000b c034ecc0 dc725740 c012ff0f c034ecc0 dc71842c 00000046 dc641ec0

Call Trace:

[<c021bbeb>] e1000_intr+0x8b/0x150 (4)

[<c012fd96>] handle_IRQ_event+0x66/0xf0 (28)

[<c012ff0f>] __do_IRQ+0xcf/0x120 (48)

[<c01043e9>] do_IRQ+0x19/0x30 (36)

[<c0102776>] common_interrupt+0x1a/0x20 (4)

[<c02199ae>] e1000_set_multi+0x15e/0x200 (44)

[<c0216acb>] e1000_up+0x1b/0xd0 (52)

[<c0216be2>] e1000_power_up_phy+0x62/0x70 (8)

[<c0217ef6>] e1000_open+0x66/0xf0 (24)

[<c0241dad>] dev_open+0x7d/0x90 (20)

[<c024346f>] dev_change_flags+0x5f/0x150 (24)

[<c0377409>] ic_open_devs+0x189/0x2b0 (32)

[<c0377a5e>] ip_auto_config+0x5e/0x290 (32)

[<c0352893>] do_initcalls+0x53/0xd0 (28)

[<c01002c0>] init+0x0/0x110 (12)

[<c01002c0>] init+0x0/0x110 (4)

[<c01002e5>] init+0x25/0x110 (12)

[<c0100948>] kernel_thread_helper+0x0/0xb (12)

[<c010094d>] kernel_thread_helper+0x5/0xb (4)

Code:  Bad EIP value.

<0>Kernel panic - not syncing: Fatal exception in interrupt
