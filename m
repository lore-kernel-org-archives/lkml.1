Return-Path: <linux-kernel-owner+w=401wt.eu-S1764026AbZFNUlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764026AbZFNUlk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 16:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763326AbZFNUlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 16:41:22 -0400
Received: from smtp1.nimastelecom.com ([85.112.8.142]:40356 "EHLO
	smtp1.nimastelecom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762646AbZFNUlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 16:41:21 -0400
X-Greylist: delayed 616 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Jun 2009 16:41:20 EDT
Message-ID: <4A355DFF.1020503@nimastelecom.com>
Date: Sun, 14 Jun 2009 22:30:55 +0200
From: Carlos Velasco <lkml@nimastelecom.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: WARNING: at arch/x86/kernel/cpu/mtrr/generic.c:456 generic_get_mtrr+0xf6/0x130()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This sounds a bit bad...

------------[ cut here ]------------
WARNING: at arch/x86/kernel/cpu/mtrr/generic.c:456
generic_get_mtrr+0xf6/0x130()
Hardware name: ProLiant DL140 G3
mtrr: your BIOS has set up an incorrect mask, fixing it up.
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.30 #1
Call Trace:
 [<ffffffff8021e536>] ? generic_get_mtrr+0xf6/0x130
 [<ffffffff802450e8>] warn_slowpath_common+0x78/0xf0
 [<ffffffff802451e4>] warn_slowpath_fmt+0x64/0x80
 [<ffffffff805d66c3>] ? printk+0x67/0x6c
 [<ffffffff8021e536>] generic_get_mtrr+0xf6/0x130
 [<ffffffff80791aa9>] mtrr_trim_uncached_memory+0xa3/0x63a
 [<ffffffff8079136b>] ? print_fixed_last+0x3b/0x47
 [<ffffffff8078d4a4>] setup_arch+0x41c/0x6e9
 [<ffffffff8026eee7>] ? clockevents_register_notifier+0x27/0x40
 [<ffffffff807899d5>] start_kernel+0x6a/0x3d4
 [<ffffffff80789289>] x86_64_start_reservations+0x99/0xb9
 [<ffffffff80789389>] x86_64_start_kernel+0xe0/0xf2
---[ end trace 4eaa2a86a8e2da22 ]---

It happens just upon booting kernel. Hardware is a new HP Proliant DL140
G3 with latest BIOS. Something to worry about?

===
BIOS data check successful

Linux version 2.6.30 (root@Titan) (gcc version 4.3.3 (GCC) ) #1 SMP Wed
Jun 10 19:38:05 CEST 2009
Command line: BOOT_IMAGE=linux2630 ro lvm2root=/dev/vol0/root
console=tty0 console=ttyS0,57600n8r
KERNEL supported cpus:

  Intel GenuineIntel

  AMD AuthenticAMD

  Centaur CentaurHauls

BIOS-provided physical RAM map:

 BIOS-e820: 0000000000000000 - 000000000009a800 (usable)

 BIOS-e820: 000000000009a800 - 00000000000a0000 (reserved)

 BIOS-e820: 00000000000ca000 - 00000000000cc000 (reserved)

 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)

 BIOS-e820: 0000000000100000 - 00000000cff10000 (usable)

 BIOS-e820: 00000000cff10000 - 00000000cff21000 (ACPI data)

 BIOS-e820: 00000000cff21000 - 00000000cff80000 (ACPI NVS)

 BIOS-e820: 00000000cff80000 - 00000000d0000000 (reserved)

 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)

 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)

 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)

 BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)

 BIOS-e820: 0000000100000000 - 0000000130000000 (usable)

DMI present.
last_pfn = 0x130000 max_arch_pfn = 0x100000000
------------[ cut here ]------------
WARNING: at arch/x86/kernel/cpu/mtrr/generic.c:456
generic_get_mtrr+0xf6/0x130()
Hardware name: ProLiant DL140 G3
mtrr: your BIOS has set up an incorrect mask, fixing it up.
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.30 #1
Call Trace:
 [<ffffffff8021e536>] ? generic_get_mtrr+0xf6/0x130
 [<ffffffff802450e8>] warn_slowpath_common+0x78/0xf0
 [<ffffffff802451e4>] warn_slowpath_fmt+0x64/0x80
 [<ffffffff805d66c3>] ? printk+0x67/0x6c
 [<ffffffff8021e536>] generic_get_mtrr+0xf6/0x130
 [<ffffffff80791aa9>] mtrr_trim_uncached_memory+0xa3/0x63a
 [<ffffffff8079136b>] ? print_fixed_last+0x3b/0x47
 [<ffffffff8078d4a4>] setup_arch+0x41c/0x6e9
 [<ffffffff8026eee7>] ? clockevents_register_notifier+0x27/0x40
 [<ffffffff807899d5>] start_kernel+0x6a/0x3d4
 [<ffffffff80789289>] x86_64_start_reservations+0x99/0xb9
 [<ffffffff80789389>] x86_64_start_kernel+0xe0/0xf2
---[ end trace 4eaa2a86a8e2da22 ]---
last_pfn = 0xcff10 max_arch_pfn = 0x100000000
init_memory_mapping: 0000000000000000-00000000cff10000
init_memory_mapping: 0000000100000000-0000000130000000
RAMDISK: 7f9df000 - 7ffffbb7
===

Regards,
Carlos Velasco
