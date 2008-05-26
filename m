Return-Path: <linux-kernel-owner+w=401wt.eu-S1755996AbYEZVZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbYEZVZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 17:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753989AbYEZVZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 17:25:07 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:50198 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754069AbYEZVZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 17:25:05 -0400
Message-ID: <483B2A9B.4050007@krogh.cc>
Date: Mon, 26 May 2008 23:24:43 +0200
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.26-rc4
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> You know the drill by now: another week, another -rc.

I did get this one (which I didn't on 2.6.25.2)

[42949399.810959] ck804xrom ck804xrom_init_one(): Unable to register 
resource 0x0000000000000000-0x00000000ffffffff - kernel bug?
[42949399.979924] ------------[ cut here ]------------
[42949399.979924] WARNING: at arch/x86/mm/ioremap.c:159 
__ioremap_caller+0x299/0x330()
[42949399.979924] Modules linked in: ck804xrom(+) mtd i2c_nforce2(+) 
niu(+) i2c_core serio_raw button(+) chipreg map_funcs pcspkr k8temp 
shpchp pci_hotplug evdev joydev ext3 jbd mbcache pata_amd sr_mod cdrom 
sg sd_mod usb_storage libusual pata_acpi usbhid hid mptsas ata_generic 
mptspi scsi_transport_sas mptscsih mptbase libata scsi_transport_spi 
ehci_hcd e1000 scsi_mod dock ohci_hcd usbcore dm_mirror dm_log 
dm_snapshot dm_mod thermal processor fan fuse
[42949399.979924] Pid: 5660, comm: modprobe Not tainted 2.6.26-rc4 #1
[42949399.979924]
[42949399.979924] Call Trace:
[42949399.979924]  [<ffffffff80236aa4>] warn_on_slowpath+0x64/0xa0
[42949399.979924]  [<ffffffff8034b697>] idr_get_empty_slot+0xf7/0x280
[42949399.979924]  [<ffffffff80237b4e>] printk+0x4e/0x60
[42949399.979924]  [<ffffffff80465e52>] klist_iter_exit+0x12/0x20
[42949399.979924]  [<ffffffff80223139>] __ioremap_caller+0x299/0x330
[42949399.979924]  [<ffffffffa00ee1f6>] 
:ck804xrom:init_ck804xrom+0x1f6/0x631
[42949399.979924]  [<ffffffffa00ee1f6>] 
:ck804xrom:init_ck804xrom+0x1f6/0x631
[42949399.979924]  [<ffffffff8025c23a>] sys_init_module+0x17a/0x1d00
[42949399.979924]  [<ffffffff8028c228>] vma_prio_tree_insert+0x28/0x60
[42949399.979924]  [<ffffffff8020c2bb>] system_call_after_swapgs+0x7b/0x80
[42949399.979924]
[42949399.979924] ---[ end trace 5bb785355abc57e6 ]---
[42949399.979924] ck804xrom: ioremap(00000000, 100000000) failed

-- 
Jesper
