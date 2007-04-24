Return-Path: <linux-kernel-owner+w=401wt.eu-S1422759AbXDXQjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422759AbXDXQjn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 12:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422765AbXDXQjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 12:39:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55316 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422759AbXDXQjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 12:39:42 -0400
Message-ID: <462E32C5.6020201@redhat.com>
Date: Tue, 24 Apr 2007 12:39:33 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: =?UTF-8?B?IlwiVGhpYWdvIE0uXCIgU2F5w6NvIg==?= 
	<thiago.sayao@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Oops: 0002 [1] SMP
References: <1177379292.16380.16.camel@sayao-desktop>
In-Reply-To: <1177379292.16380.16.camel@sayao-desktop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thiago M. Sayão wrote:
> Sometimes, randomly i get this Oops message and the system becomes
> unstable. By unstable i mean all applications segmentation faults when i
> execute (after the Oops). Sometimes X crashes, sometimes the machine
> just reboots (the reboot might be other problem tho).
> 
> This happens with kernel 2.6.20 and with 2.6.21-rc7. Was happening with
> 2.6.20 so i tried 2.6.21-rc7 and this also happens.
> 
> Apr 22 21:44:33 sayao-desktop kernel: [18641.553890] Unable to handle
> kernel paging request at ffffffff00003e82 RIP:
> Apr 22 21:44:33 sayao-desktop kernel: [18641.553899]  [__alloc_skb
> +188/321] __alloc_skb+0xbc/0x141
> Apr 22 21:44:33 sayao-desktop kernel: [18641.553911] PGD 203027 PUD 0
> Apr 22 21:44:33 sayao-desktop kernel: [18641.553915] Oops: 0002 [1] SMP
> Apr 22 21:44:33 sayao-desktop kernel: [18641.553919] CPU 0
> Apr 22 21:44:33 sayao-desktop kernel: [18641.553922] Modules linked in:
> binfmt_misc rfcomm l2cap bluetooth i915 drm ppdev capability commoncap
> acpi_cpufreq cpufreq_userspace cpufreq_stats cpufreq_conservative
> cpufreq_ondemand cpufreq_powersave freq_table asus_acpi container sbs
> i2c_ec i2c_core battery video dock ac button ipv6 lp fuse snd_hda_intel
> snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy
> snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq psmouse
> snd_timer snd_seq_device snd parport_pc parport shpchp serio_raw pcspkr
> soundcore snd_page_alloc iTCO_wdt iTCO_vendor_support pci_hotplug
> intel_agp af_packet evdev tsdev ext3 jbd mbcache sg ide_cd cdrom sd_mod
> ata_generic usbhid hid ata_piix libata scsi_mod e100 mii ehci_hcd
> generic piix uhci_hcd usbcore thermal processor fan
> Apr 22 21:44:33 sayao-desktop kernel: [18641.553997] Pid: 13805, comm:
> evolution Not tainted 2.6.21-rc7-sayao #2
> Apr 22 21:44:33 sayao-desktop kernel: [18641.554001] RIP:
> 0010:[__alloc_skb+188/321]  [__alloc_skb+188/321] __alloc_skb+0xbc/0x141
> Apr 22 21:44:33 sayao-desktop kernel: [18641.554007] RSP:
> 0018:ffff810033169bd8  EFLAGS: 00010246
> Apr 22 21:44:33 sayao-desktop kernel: [18641.554011] RAX:
> ffffffff00003e82 RBX: ffffffff00000002 RCX: 0000000000000000
> Apr 22 21:44:33 sayao-desktop kernel: [18641.554014] RDX:
> 0000000000000000 RSI: 0000000000000000 RDI: ffff81003b1bfa50
> Apr 22 21:44:33 sayao-desktop kernel: [18641.554017] RBP:
> 0000000000003e80 R08: 0000000000000002 R09: 0000000000000000
> Apr 22 21:44:33 sayao-desktop kernel: [18641.554021] R10:
> ffff81003b1bf980 R11: 00000000000000d0 R12: ffff81003b1bf980
> Apr 22 21:44:33 sayao-desktop kernel: [18641.554024] R13:
> ffff81003f2109c0 R14: 00000000000004d0 R15: 0000000000003e80
> Apr 22 21:44:33 sayao-desktop kernel: [18641.554028] FS:
> 00002ad334669ea0(0000) GS:ffffffff8052f000(0000) knlGS:0000000000000000
> Apr 22 21:44:33 sayao-desktop kernel: [18641.554032] CS:  0010 DS: 0000
> ES: 0000 CR0: 0000000080050033
> Apr 22 21:44:33 sayao-desktop kernel: [18641.554035] CR2:
> ffffffff00003e82 CR3: 0000000027bb3000 CR4: 00000000000006e0
> Apr 22 21:44:33 sayao-desktop kernel: [18641.554039] Process evolution
> (pid: 13805, threadinfo ffff810033168000, task ffff810009665000)
> Apr 22 21:44:33 sayao-desktop kernel: [18641.554042] Stack:
> 0000000009665000 ffff81002f9f5080 0000000000003e80 0000000000000000
> Apr 22 21:44:33 sayao-desktop kernel: [18641.554049]  00000000000004d0
> ffff810033169ce4 0000000000003e80 ffffffff803a6d82
> Apr 22 21:44:33 sayao-desktop kernel: [18641.554055]  0000000000000000
> 0000000000000206 ffffffff80507110 ffff810000dadc50
> Apr 22 21:44:33 sayao-desktop kernel: [18641.554061] Call Trace:
> Apr 22 21:44:33 sayao-desktop kernel: [18641.554086]
> [sock_alloc_send_skb+130/478] sock_alloc_send_skb+0x82/0x1de
> Apr 22 21:44:33 sayao-desktop kernel: [18641.554126]
> [unix_stream_sendmsg+392/880] unix_stream_sendmsg+0x188/0x370
> Apr 22 21:44:33 sayao-desktop kernel: [18641.554181]  [sock_aio_write
> +293/313] sock_aio_write+0x125/0x139
> Apr 22 21:44:33 sayao-desktop kernel: [18641.554247]  [do_sync_write
> +207/277] do_sync_write+0xcf/0x115
> Apr 22 21:44:33 sayao-desktop kernel: [18641.554287]
> [autoremove_wake_function+0/48] autoremove_wake_function+0x0/0x30
> Apr 22 21:44:33 sayao-desktop kernel: [18641.554352]  [vfs_write
> +228/348] vfs_write+0xe4/0x15c
> Apr 22 21:44:33 sayao-desktop kernel: [18641.554369]  [sys_write+69/121]
> sys_write+0x45/0x79
> Apr 22 21:44:33 sayao-desktop kernel: [18641.554393]  [system_call
> +126/131] system_call+0x7e/0x83
> Apr 22 21:44:33 sayao-desktop kernel: [18641.554434] 
> Apr 22 21:44:33 sayao-desktop kernel: [18641.554436] 
> Apr 22 21:44:33 sayao-desktop kernel: [18641.554437] Code: c7 00 01 00
> 00 00 66 c7 40 04 00 00 66 c7 40 06 00 00 66 c7 
> Apr 22 21:44:33 sayao-desktop kernel: [18641.554453] RIP  [__alloc_skb
> +188/321] __alloc_skb+0xbc/0x141
> Apr 22 21:44:33 sayao-desktop kernel: [18641.554458]  RSP
> <ffff810033169bd8>
> Apr 22 21:44:33 sayao-desktop kernel: [18641.554460] CR2:
> ffffffff00003e82
> 

It's here in /net/core/skbuff.c, line 174:

        /* make sure we initialize shinfo sequentially */
        shinfo = skb_shinfo(skb);
=>>     atomic_set(&shinfo->dataref, 1);

It allocated an skb with 16000 bytes of space for data.

__kmalloc_node returned address 0xffffffff00000002 for the data,
which I don't even think is a legal address on x86_64. It doesn't
seem to be a networking problem, the address is invalid/unmapped.

Can you post your .config ?

