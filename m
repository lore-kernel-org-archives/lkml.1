Return-Path: <linux-kernel-owner+w=401wt.eu-S1752178AbXBWJxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178AbXBWJxJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 04:53:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752176AbXBWJxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 04:53:09 -0500
Received: from [80.247.74.3] ([80.247.74.3]:41418 "EHLO tavolara.isolaweb.it"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752178AbXBWJxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 04:53:07 -0500
X-Greylist: delayed 1875 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Feb 2007 04:53:07 EST
X-Mailer: QUALCOMM Windows Eudora Version 7.1.0.9
Date: Fri, 23 Feb 2007 10:21:25 +0100
To: linux-kernel@vger.kernel.org
From: Roberto Fichera <kernel@tekno-soft.it>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-Id: <20070223091745.83C0A49803B@tavolara.isolaweb.it>
X-IsolaWeb-MailScanner-Information: Please contact the ISP for more information
X-IsolaWeb-MailScanner: Found to be clean
X-MailScanner-From: kernel@tekno-soft.it
Subject: Soft lockup detected on CPU#X
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I'm experiencing some soft lockup problem on fedora core 5 v2.6.19-1.2288.fc5 x86_64
with a dual HT Xeon 3.2GHz EMT in ASUS NCT-D mobo. This problem still happening
everytime I switch on the box, but disappear if I reboot the box by a Ctrl-Alt-Canc just after
the BIOS startup and without booting the kernel. The box stay up without any problem so far. 
Furthermore booting with noapic the box doesn't show any problem.
The bios on the motherboard has been already updated to the last available.

Does anyone have some tips to suggest?

Feb 16 13:06:14 spargi kernel: EXT3 FS on sda1, internal journal
Feb 16 13:06:14 spargi kernel: EXT3-fs: mounted filesystem with ordered data mode.
Feb 16 13:06:14 spargi kernel: Adding 4192956k swap on /dev/sda2.  Priority:-1 extents:1 across:4192956k
Feb 16 13:06:14 spargi kernel: IA-32 Microcode Update Driver: v1.14a <tigran@veritas.com>
Feb 16 13:06:14 spargi kernel: ip_tables: (C) 2000-2006 Netfilter Core Team
Feb 16 13:06:14 spargi kernel: Netfilter messages via NETLINK v0.30.
Feb 16 13:06:14 spargi kernel: ip_conntrack version 2.4 (8192 buckets, 65536 max) - 312 bytes per conntrack
Feb 16 13:06:14 spargi kernel: skge eth0: enabling interface
Feb 16 13:06:14 spargi kernel: skge eth0: Link is up at 100 Mbps, full duplex, flow control both
Feb 16 13:06:29 spargi kernel: BUG: soft lockup detected on CPU#3!
Feb 16 13:06:29 spargi kernel:
Feb 16 13:06:29 spargi kernel: Call Trace:
Feb 16 13:06:29 spargi kernel:  [<ffffffff802699c5>] show_trace+0x34/0x47
Feb 16 13:06:29 spargi kernel:  [<ffffffff802699ea>] dump_stack+0x12/0x17
Feb 16 13:06:29 spargi kernel:  [<ffffffff802b536e>] softlockup_tick+0xdb/0xf6
Feb 16 13:06:29 spargi kernel:  [<ffffffff802921d8>] update_process_times+0x42/0x68
Feb 16 13:06:29 spargi kernel:  [<ffffffff80274322>] smp_local_timer_interrupt+0x34/0x55
Feb 16 13:06:29 spargi kernel:  [<ffffffff802749d6>] smp_apic_timer_interrupt+0x51/0x69
Feb 16 13:06:29 spargi kernel:  [<ffffffff8025ccf6>] apic_timer_interrupt+0x66/0x70
Feb 16 13:06:29 spargi kernel:  [<ffffffff8026911d>] mwait_idle_with_hints+0x44/0x45
Feb 16 13:06:29 spargi kernel:  [<ffffffff80255eee>] mwait_idle+0xc/0x20
Feb 16 13:06:29 spargi kernel:  [<ffffffff80247ec6>] cpu_idle+0x8b/0xae
Feb 16 13:06:29 spargi kernel:  [<ffffffff8027412f>] start_secondary+0x462/0x471
Feb 16 13:06:29 spargi kernel:
Feb 16 13:06:29 spargi kernel: BUG: soft lockup detected on CPU#1!
Feb 16 13:06:29 spargi kernel:
Feb 16 13:06:29 spargi kernel: Call Trace:
Feb 16 13:06:29 spargi kernel:  [<ffffffff802699c5>] show_trace+0x34/0x47
Feb 16 13:06:29 spargi kernel:  [<ffffffff802699ea>] dump_stack+0x12/0x17
Feb 16 13:06:29 spargi kernel:  [<ffffffff802b536e>] softlockup_tick+0xdb/0xf6
Feb 16 13:06:29 spargi kernel:  [<ffffffff802921d8>] update_process_times+0x42/0x68
Feb 16 13:06:29 spargi kernel:  [<ffffffff80274322>] smp_local_timer_interrupt+0x34/0x55
Feb 16 13:06:29 spargi kernel:  [<ffffffff802749d6>] smp_apic_timer_interrupt+0x51/0x69
Feb 16 13:06:29 spargi kernel:  [<ffffffff8025ccf6>] apic_timer_interrupt+0x66/0x70
Feb 16 13:06:29 spargi kernel:  [<ffffffff8026911d>] mwait_idle_with_hints+0x44/0x45
Feb 16 13:06:29 spargi kernel:  [<ffffffff80255eee>] mwait_idle+0xc/0x20
Feb 16 13:06:29 spargi kernel:  [<ffffffff80247ec6>] cpu_idle+0x8b/0xae
Feb 16 13:06:29 spargi kernel:  [<ffffffff8027412f>] start_secondary+0x462/0x471
Feb 16 13:06:29 spargi kernel:
Feb 16 13:06:29 spargi kernel: BUG: soft lockup detected on CPU#0!
Feb 16 13:06:29 spargi kernel:
Feb 16 13:06:29 spargi kernel: Call Trace:
Feb 16 13:06:29 spargi kernel:  [<ffffffff802699c5>] show_trace+0x34/0x47
Feb 16 13:06:29 spargi kernel:  [<ffffffff802699ea>] dump_stack+0x12/0x17
Feb 16 13:06:29 spargi kernel:  [<ffffffff802b536e>] softlockup_tick+0xdb/0xf6
Feb 16 13:06:29 spargi kernel:  [<ffffffff802921d8>] update_process_times+0x42/0x68
Feb 16 13:06:29 spargi kernel:  [<ffffffff80274322>] smp_local_timer_interrupt+0x34/0x55
Feb 16 13:06:29 spargi kernel:  [<ffffffff802749d6>] smp_apic_timer_interrupt+0x51/0x69
Feb 16 13:06:29 spargi kernel:  [<ffffffff8025ccf6>] apic_timer_interrupt+0x66/0x70
Feb 16 13:06:29 spargi kernel:  [<ffffffff8026911d>] mwait_idle_with_hints+0x44/0x45
Feb 16 13:06:29 spargi kernel:  [<ffffffff80255eee>] mwait_idle+0xc/0x20
Feb 16 13:06:29 spargi kernel:  [<ffffffff80247ec6>] cpu_idle+0x8b/0xae
Feb 16 13:06:29 spargi kernel:  [<ffffffff806627a0>] start_kernel+0x240/0x245
Feb 16 13:06:29 spargi kernel:  [<ffffffff8066215a>] _sinittext+0x15a/0x15e
Feb 16 13:06:29 spargi kernel:


Roberto Fichera. 

