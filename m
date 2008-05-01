Return-Path: <linux-kernel-owner+w=401wt.eu-S1759220AbYEAKpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759220AbYEAKpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 06:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbYEAKpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 06:45:04 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:58342 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbYEAKpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 06:45:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=epVc0T0XTRbLbYNdqpw8mK4sAmlwmSjj4K+ci5elrzrPv1VZuA5dJy0tBsvYDn9GsUGmomPbwpmnz93WFdtHC0yhSge3lIIKoo48Wlj39s97sQxZ7a+/a9CrxI5pKoqWBTdj+JKfULIXcoqizTs9Cd1wnEJqwJNAZOFq4bQtNYo=
Message-ID: <48199F05.507@gmail.com>
Date: Thu, 01 May 2008 12:44:21 +0200
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080109)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: kernel BUG at mm/rmap.c:669 (during localegen)
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
From: =?ISO-8859-2?Q?Pawe=B3?= <anilatx@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/I'm not subscribed to the list, please add me to CC/

Every time I try to generate locales computer reboots or hangs. To 
ensure that's not matter of graphDrivers I checked also in runlevel 1 
and "init=/bin/bash".

Linux debby 2.6.25 #1 PREEMPT Mon Apr 28 15:18:31 CEST 2008 x86_64 GNU/Linux
gcc (GCC) 4.2.3 (Debian 4.2.3-3)

[kern.log:]
//May  1 11:20:09 debby kernel: NVRM: bad caching on address 
0xffff81003a910000: actual 0x173 != expected 0x17b

May  1 11:25:44 debby kernel: Eeek! page_mapcount(page) went negative! (-1)
May  1 11:25:44 debby kernel:   page pfn = 257d2
May  1 11:25:44 debby kernel:   page->flags = 2200000000001c
May  1 11:25:44 debby kernel:   page->count = 0
May  1 11:25:44 debby kernel:   page->mapping = 0000000000000000
May  1 11:25:44 debby kernel:   vma->vm_ops = 0x0
May  1 11:25:44 debby kernel: ------------[ cut here ]------------
May  1 11:25:44 debby kernel: kernel BUG at mm/rmap.c:669!
May  1 11:25:44 debby kernel: invalid opcode: 0000 [1] PREEMPT
May  1 11:25:44 debby kernel: CPU 0
May  1 11:25:44 debby kernel: Modules linked in: nvidia(P) 
cpufreq_ondemand ac battery vfat fat nls_base fuse psmouse analog ns558 
gameport joydev it87 hwmon_vid powernow_k8 freq_table usbhid ff_memless 
sg sr_mod cdrom ohci1394 ieee1394 snd_intel8x0 snd_ac97_codec ac97_bus 
irtty_sir snd_pcm sir_dev 8250_pnp snd_timer 8250 firewire_ohci k8temp 
irda serial_core crc_ccitt floppy snd ehci_hcd firewire_core pcspkr 
hwmon soundcore snd_page_alloc ohci_hcd skge forcedeth crc_itu_t 
pata_amd usbcore fan i2c_nforce2 thermal button processor evdev unix
May  1 11:25:44 debby kernel: Pid: 3007, comm: localedef Tainted: 
P         2.6.25 #1
May  1 11:25:44 debby kernel: RIP: 0010:[<ffffffff80270c74>]  
[<ffffffff80270c74>] page_remove_rmap+0x164/0x180
May  1 11:25:44 debby kernel: RSP: 0000:ffff81002e3e7bf8  EFLAGS: 00010246
May  1 11:25:44 debby kernel: RAX: 0000000000000000 RBX: 
ffffe200008335f0 RCX: 000000000000ffff
May  1 11:25:44 debby kernel: RDX: 00000000ffffff01 RSI: 
0000000000000000 RDI: ffffffff804ed490
May  1 11:25:44 debby kernel: RBP: ffff81002e3c35d0 R08: 
00000000ffffffff R09: 0000000000000000
May  1 11:25:44 debby kernel: R10: 0000000000000020 R11: 
0000000000000010 R12: 00007f25f926b000
May  1 11:25:44 debby kernel: R13: ffffe200008335f0 R14: 
00007f25fa45a000 R15: 0000000000007000
May  1 11:25:44 debby kernel: FS:  00007f25fa99f6e0(0000) 
GS:ffffffff80516000(0000) knlGS:0000000000000000
May  1 11:25:44 debby kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
000000008005003b
May  1 11:25:44 debby kernel: CR2: 0000000000712008 CR3: 
000000003e7c4000 CR4: 00000000000006e0
May  1 11:25:44 debby kernel: DR0: 0000000000000000 DR1: 
0000000000000000 DR2: 0000000000000000
May  1 11:25:44 debby kernel: DR3: 0000000000000000 DR6: 
00000000ffff0ff0 DR7: 0000000000000400
May  1 11:25:44 debby kernel: Process localedef (pid: 3007, threadinfo 
ffff81002e3e6000, task ffff81002e386080)
May  1 11:25:44 debby kernel: Stack:  00007f25f926a000 00007f25f9400000 
ffff81002e3fd350 ffffffff8026899f
May  1 11:25:44 debby kernel:  00007f25fa459fff 0000000000000000 
ffff81002e3e7cf8 ffffffffffffffff
May  1 11:25:44 debby kernel:  0000000000000000 ffff81002e3c35d0 
ffff81002e3e7d00 0000000100000000
May  1 11:25:44 debby kernel: Call Trace:
May  1 11:25:44 debby kernel:  [<ffffffff8026899f>] ? unmap_vmas+0x48f/0x710
May  1 11:25:44 debby kernel:  [<ffffffff8026ce4d>] ? exit_mmap+0x6d/0x110
May  1 11:25:44 debby kernel:  [<ffffffff80229dfd>] ? mmput+0x1d/0xb0
May  1 11:25:44 debby kernel:  [<ffffffff8022fed1>] ? do_exit+0x171/0x7e0
May  1 11:25:44 debby kernel:  [<ffffffff8023909d>] ? 
__dequeue_signal+0x2d/0x1e0
May  1 11:25:44 debby kernel:  [<ffffffff8023056d>] ? 
do_group_exit+0x2d/0xb0
May  1 11:25:44 debby kernel:  [<ffffffff8023a3bd>] ? 
get_signal_to_deliver+0x27d/0x390
May  1 11:25:44 debby kernel:  [<ffffffff8020a6cd>] ? 
do_notify_resume+0x10d/0x910
May  1 11:25:44 debby kernel:  [<ffffffff8042c075>] ? 
preempt_schedule_irq+0x55/0x90
May  1 11:25:44 debby kernel:  [<ffffffff8020ba86>] ? 
retint_kernel+0x26/0x30
May  1 11:25:44 debby kernel:  [<ffffffff802203b8>] ? 
do_page_fault+0x378/0x800
May  1 11:25:44 debby kernel:  [<ffffffff8031640e>] ? __up_read+0x2e/0xb0
May  1 11:25:44 debby kernel:  [<ffffffff8020ba1c>] ? 
retint_signal+0x3d/0x81
May  1 11:25:44 debby kernel:
May  1 11:25:44 debby kernel:
May  1 11:25:44 debby kernel: Code: 10 e8 71 1e fe ff 48 8b 85 90 00 00 
00 48 85 c0 74 19 48 8b 40 20 48 85 c0 74 10 48 8b 70 58 48 c7 c7 e8 ef 
49 80 e8 4c 1e fe ff <0f> 0b eb fe 48 8b 53 10 e9 65 ff ff ff 66 66 66 
66 66 66 2e 0f
May  1 11:25:44 debby kernel: RIP  [<ffffffff80270c74>] 
page_remove_rmap+0x164/0x180
May  1 11:25:44 debby kernel:  RSP <ffff81002e3e7bf8>
May  1 11:25:44 debby kernel: ---[ end trace 544a304720da22a8 ]---
May  1 11:25:44 debby kernel: Fixing recursive fault but reboot is needed!
May  1 11:25:44 debby kernel: BUG: scheduling while atomic: 
localedef/3007/0x00000003
May  1 11:25:44 debby kernel: Pid: 3007, comm: localedef Tainted: P      
D  2.6.25 #1
May  1 11:25:44 debby kernel:
May  1 11:25:44 debby kernel: Call Trace:
May  1 11:25:44 debby kernel:  [<ffffffff8042ba1c>] 
thread_return+0x141/0x215
May  1 11:25:44 debby kernel:  [<ffffffff8023051c>] do_exit+0x7bc/0x7e0
May  1 11:25:44 debby kernel:  [<ffffffff8020c224>] oops_end+0x74/0x80
May  1 11:25:44 debby kernel:  [<ffffffff8020d686>] do_invalid_op+0x86/0xa0
May  1 11:25:44 debby kernel:  [<ffffffff80270c74>] 
page_remove_rmap+0x164/0x180
May  1 11:25:44 debby kernel:  [<ffffffff80252aef>] __print_symbol+0x2f/0x50
May  1 11:25:44 debby kernel:  [<ffffffff8022d50e>] printk+0x4e/0x60
May  1 11:25:44 debby kernel:  [<ffffffff8042dc89>] error_exit+0x0/0x51
May  1 11:25:44 debby kernel:  [<ffffffff80270c74>] 
page_remove_rmap+0x164/0x180
May  1 11:25:44 debby kernel:  [<ffffffff80270c1c>] 
page_remove_rmap+0x10c/0x180
May  1 11:25:44 debby kernel:  [<ffffffff8026899f>] unmap_vmas+0x48f/0x710
May  1 11:25:44 debby kernel:  [<ffffffff8026ce4d>] exit_mmap+0x6d/0x110
May  1 11:25:44 debby kernel:  [<ffffffff80229dfd>] mmput+0x1d/0xb0
May  1 11:25:44 debby kernel:  [<ffffffff8022fed1>] do_exit+0x171/0x7e0
May  1 11:25:44 debby kernel:  [<ffffffff8023909d>] 
__dequeue_signal+0x2d/0x1e0
May  1 11:25:44 debby kernel:  [<ffffffff8023056d>] do_group_exit+0x2d/0xb0
May  1 11:25:44 debby kernel:  [<ffffffff8023a3bd>] 
get_signal_to_deliver+0x27d/0x390
May  1 11:25:44 debby kernel:  [<ffffffff8020a6cd>] 
do_notify_resume+0x10d/0x910
May  1 11:25:44 debby kernel:  [<ffffffff8042c075>] 
preempt_schedule_irq+0x55/0x90
May  1 11:25:44 debby kernel:  [<ffffffff8020ba86>] retint_kernel+0x26/0x30
May  1 11:25:44 debby kernel:  [<ffffffff802203b8>] 
do_page_fault+0x378/0x800
May  1 11:25:44 debby kernel:  [<ffffffff8031640e>] __up_read+0x2e/0xb0
May  1 11:25:44 debby kernel:  [<ffffffff8020ba1c>] retint_signal+0x3d/0x81
May  1 11:25:44 debby kernel:
May  1 11:25:44 debby kernel: Bad page state in process 'syslogd'
May  1 11:25:44 debby kernel: page:ffffe200008335f0 
flags:0x002200000000001c mapping:0000000000000000 mapcount:-1 count:0
May  1 11:25:44 debby kernel: Trying to fix it up, but a reboot is needed
May  1 11:25:44 debby kernel: Backtrace:
May  1 11:25:44 debby kernel: Pid: 3050, comm: syslogd Tainted: P      
D  2.6.25 #1
May  1 11:25:44 debby kernel:
May  1 11:25:44 debby kernel: Call Trace:
May  1 11:25:44 debby kernel:  [<ffffffff8025e4bd>] bad_page+0x6d/0xb0
May  1 11:25:44 debby kernel:  [<ffffffff8025f498>] 
get_page_from_freelist+0x4c8/0x530
May  1 11:25:44 debby kernel:  [<ffffffff8025f592>] __alloc_pages+0x92/0x390
May  1 11:25:44 debby kernel:  [<ffffffff80267dcb>] do_wp_page+0xbb/0x5e0
May  1 11:25:44 debby kernel:  [<ffffffff8026ae0b>] 
handle_mm_fault+0x67b/0x830
May  1 11:25:44 debby kernel:  [<ffffffff802203b8>] 
do_page_fault+0x378/0x800
May  1 11:25:44 debby kernel:  [<ffffffff80319000>] __put_user_4+0x20/0x30
May  1 11:25:44 debby kernel:  [<ffffffff8042dc89>] error_exit+0x0/0x51
May  1 11:25:44 debby kernel:

//May  1 11:26:44 debby kernel: klogd 1.5.0#2, log source = /proc/kmsg 
started.
