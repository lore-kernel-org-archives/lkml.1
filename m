Return-Path: <linux-kernel-owner+w=401wt.eu-S1422791AbXDYWTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422791AbXDYWTL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 18:19:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422800AbXDYWTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 18:19:11 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:57101 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422791AbXDYWTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 18:19:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kEDy/xXanxcZfkTv0nCArw8MId8CnszeVap+HAAo3WnQtnBSqUWv8pAoTOPLaYHTXMPfQREYW2x4y2y61TR4T8jDmc3T9NkQNYsB7ml/RdJnrZ7EmlxtGBfy74p2rh+JISZKrdyhLFBvUomyt+L9v90tekODDIm2wN7r+OhAEhk=
Subject: Re: PROBLEM: Oops: 0002 [1] SMP
From: "Thiago M." =?ISO-8859-1?Q?Say=E3o?= <thiago.sayao@gmail.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <462E32C5.6020201@redhat.com>
References: <1177379292.16380.16.camel@sayao-desktop>
	 <462E32C5.6020201@redhat.com>
Content-Type: text/plain; charset=utf-8
Date: Wed, 25 Apr 2007 19:18:57 -0300
Message-Id: <1177539537.7180.3.camel@sayao-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I also got this error yesterday which seems related:

Bad pagetable: 001d [1] SMP 
Bad pagetable: 0009 [2] SMP 

Error follows:

Apr 24 20:37:15 sayao-desktop kernel: [93178.919375] vino-server:
Corrupted page table at address 2af38da4188f
Apr 24 20:37:15 sayao-desktop kernel: [93178.919389] PGD 222c4067 PUD
42355e067 BAD
Apr 24 20:37:15 sayao-desktop kernel: [93178.919400] Bad pagetable: 001d
[1] SMP 
Apr 24 20:37:15 sayao-desktop kernel: [93178.919406] CPU 1 
Apr 24 20:37:15 sayao-desktop kernel: [93178.919410] Modules linked in:
isofs iptable_filter ip_tables x_tables binfmt_misc rfcomm l2cap
bluetooth i915 drm ppdev capability commoncap acpi_cpufreq
cpufreq_userspace cpufreq_stats cpufreq_conservative cpufreq_ondemand
cpufreq_powersave freq_table asus_acpi container sbs i2c_ec i2c_core
battery video dock ac button ipv6 lp fuse snd_hda_intel snd_hda_codec
snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi
snd_rawmidi snd_seq_midi_event snd_seq psmouse snd_timer snd_seq_device
serio_raw snd af_packet iTCO_wdt iTCO_vendor_support parport_pc parport
shpchp soundcore snd_page_alloc intel_agp pcspkr pci_hotplug evdev tsdev
ext3 jbd mbcache sg sd_mod ide_cd cdrom ata_generic ata_piix libata
scsi_mod usbhid hid e100 mii generic piix ehci_hcd uhci_hcd usbcore
thermal processor fan
Apr 24 20:37:15 sayao-desktop kernel: [93178.919519] Pid: 15581, comm:
vino-server Not tainted 2.6.21-rc7-sayao #2
Apr 24 20:37:15 sayao-desktop kernel: [93178.919523] RIP:
0033:[phys_startup_64+-1920723057/2147483392]  [phys_startup_64
+-1920723057/2147483392]
Apr 24 20:37:15 sayao-desktop kernel: [93178.919534] RSP:
002b:00007fff20c86550  EFLAGS: 00010246
Apr 24 20:37:15 sayao-desktop kernel: [93178.919537] RAX:
0000000000000001 RBX: 000000000000002d RCX: 00002af38da4188f
Apr 24 20:37:15 sayao-desktop kernel: [93178.919541] RDX:
000000000000002d RSI: 0000000000000009 RDI: 00000000006c4800
Apr 24 20:37:15 sayao-desktop kernel: [93178.919544] RBP:
0000000000000009 R08: 0000000000673498 R09: 0000000000000001
Apr 24 20:37:15 sayao-desktop kernel: [93178.919548] R10:
0000000000000001 R11: 0000000000000246 R12: 00000000006c4800
Apr 24 20:37:15 sayao-desktop kernel: [93178.919552] R13:
00000000006c4800 R14: 00002af38c52c540 R15: 00002af38da41860
Apr 24 20:37:15 sayao-desktop kernel: [93178.919557] FS:
00002af3916324d0(0000) GS:ffff81003f689e40(0000) knlGS:0000000000000000
Apr 24 20:37:15 sayao-desktop kernel: [93178.919561] CS:  0010 DS: 0000
ES: 0000 CR0: 000000008005003b
Apr 24 20:37:15 sayao-desktop kernel: [93178.919565] CR2:
ffff81042355e368 CR3: 000000001f11f000 CR4: 00000000000006e0
Apr 24 20:37:15 sayao-desktop kernel: [93178.919570] Process vino-server
(pid: 15581, threadinfo ffff81001470e000, task ffff81003950d000)
Apr 24 20:37:15 sayao-desktop kernel: [93178.919573] 
Apr 24 20:37:15 sayao-desktop kernel: [93178.919574] RIP
[phys_startup_64+-1920723057/2147483392]
Apr 24 20:37:15 sayao-desktop kernel: [93178.919582]  RSP
<00007fff20c86550>
Apr 24 20:37:15 sayao-desktop kernel: [93178.919685] vino-server:
Corrupted page table at address 2af391632570
Apr 24 20:37:15 sayao-desktop kernel: [93178.919688] PGD 222c4067 PUD
42355e067 BAD
Apr 24 20:37:15 sayao-desktop kernel: [93178.919694] Bad pagetable: 0009
[2] SMP 
Apr 24 20:37:15 sayao-desktop kernel: [93178.919697] CPU 1 
Apr 24 20:37:15 sayao-desktop kernel: [93178.919700] Modules linked in:
isofs iptable_filter ip_tables x_tables binfmt_misc rfcomm l2cap
bluetooth i915 drm ppdev capability commoncap acpi_cpufreq
cpufreq_userspace cpufreq_stats cpufreq_conservative cpufreq_ondemand
cpufreq_powersave freq_table asus_acpi container sbs i2c_ec i2c_core
battery video dock ac button ipv6 lp fuse snd_hda_intel snd_hda_codec
snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi
snd_rawmidi snd_seq_midi_event snd_seq psmouse snd_timer snd_seq_device
serio_raw snd af_packet iTCO_wdt iTCO_vendor_support parport_pc parport
shpchp soundcore snd_page_alloc intel_agp pcspkr pci_hotplug evdev tsdev
ext3 jbd mbcache sg sd_mod ide_cd cdrom ata_generic ata_piix libata
scsi_mod usbhid hid e100 mii generic piix ehci_hcd uhci_hcd usbcore
thermal processor fan
Apr 24 20:37:15 sayao-desktop kernel: [93178.919777] Pid: 15581, comm:
vino-server Not tainted 2.6.21-rc7-sayao #2
Apr 24 20:37:15 sayao-desktop kernel: [93178.919780] RIP:
0010:[__get_user_8+32/44]  [__get_user_8+32/44] __get_user_8+0x20/0x2c
Apr 24 20:37:15 sayao-desktop kernel: [93178.919803] RSP:
0000:ffff81001470fd60  EFLAGS: 00010202
Apr 24 20:37:15 sayao-desktop kernel: [93178.919807] RAX:
0000000000000246 RBX: 00002af38da4188f RCX: 00002af391632570
Apr 24 20:37:15 sayao-desktop kernel: [93178.919811] RDX:
0000000000040086 RSI: 0000000000000286 RDI: ffff81003950d000
Apr 24 20:37:15 sayao-desktop kernel: [93178.919815] RBP:
00002af391632570 R08: ffff81001470e000 R09: 0000000000000000
Apr 24 20:37:15 sayao-desktop kernel: [93178.919818] R10:
0000000000000000 R11: 0000000000000006 R12: 0000000000000001
Apr 24 20:37:15 sayao-desktop kernel: [93178.919822] R13:
ffff81003950d000 R14: 0000000000000009 R15: ffff81001470ff58
Apr 24 20:37:15 sayao-desktop kernel: [93178.919827] FS:
00002af3916324d0(0000) GS:ffff81003f689e40(0000) knlGS:0000000000000000
Apr 24 20:37:15 sayao-desktop kernel: [93178.919830] CS:  0010 DS: 0000
ES: 0000 CR0: 000000008005003b
Apr 24 20:37:15 sayao-desktop kernel: [93178.919834] CR2:
ffff81042355e458 CR3: 000000001f11f000 CR4: 00000000000006e0
Apr 24 20:37:15 sayao-desktop kernel: [93178.919839] Process vino-server
(pid: 15581, threadinfo ffff81001470e000, task ffff81003950d000)
Apr 24 20:37:15 sayao-desktop kernel: [93178.919842] Stack:
ffffffff8029e8b2 0000000000040086 ffffffff802220e4 ffff81001d833650
Apr 24 20:37:15 sayao-desktop kernel: [93178.919853]  00002af38da4188f
ffff81003950d000 0000000000000001 ffff81001470ff58
Apr 24 20:37:15 sayao-desktop kernel: [93178.919860]  0000000000000009
ffff81001470ff58 ffffffff80214b89 0000000000040096
Apr 24 20:37:15 sayao-desktop kernel: [93178.919867] Call Trace:
Apr 24 20:37:15 sayao-desktop kernel: [93178.919876]  [exit_robust_list
+32/216] exit_robust_list+0x20/0xd8
Apr 24 20:37:15 sayao-desktop kernel: [93178.919890]  [__up_read+19/139]
__up_read+0x13/0x8b
Apr 24 20:37:15 sayao-desktop kernel: [93178.919918]  [do_exit+521/2194]
do_exit+0x209/0x892
Apr 24 20:37:15 sayao-desktop kernel: [93178.919934]  [__wake_up+56/81]
__wake_up+0x38/0x51
Apr 24 20:37:15 sayao-desktop kernel: [93178.919971]  [is_prefetch
+0/544] is_prefetch+0x0/0x220
Apr 24 20:37:15 sayao-desktop kernel: [93178.919995]  [do_page_fault
+860/2112] do_page_fault+0x35c/0x840
Apr 24 20:37:15 sayao-desktop kernel: [93178.920032]  [unix_ioctl
+218/229] unix_ioctl+0xda/0xe5
Apr 24 20:37:15 sayao-desktop kernel: [93178.920050]  [sock_ioctl
+528/556] sock_ioctl+0x210/0x22c
Apr 24 20:37:15 sayao-desktop kernel: [93178.920067]  [do_ioctl+33/121]
do_ioctl+0x21/0x79
Apr 24 20:37:15 sayao-desktop kernel: [93178.920113]  [error_exit+0/132]
error_exit+0x0/0x84
Apr 24 20:37:15 sayao-desktop kernel: [93178.920182] 
Apr 24 20:37:15 sayao-desktop kernel: [93178.920184] 
Apr 24 20:37:15 sayao-desktop kernel: [93178.920185] Code: 48 8b 11 31
c0 c3 48 83 e9 07 eb 00 31 d2 48 c7 c0 f2 ff ff 
Apr 24 20:37:15 sayao-desktop kernel: [93178.920204] RIP  [__get_user_8
+32/44] __get_user_8+0x20/0x2c
Apr 24 20:37:15 sayao-desktop kernel: [93178.920211]  RSP
<ffff81001470fd60>
Apr 24 20:37:15 sayao-desktop kernel: [93178.920215] Fixing recursive
fault but reboot is needed!


On Tue, 2007-04-24 at 12:39 -0400, Chuck Ebbert wrote:
> Thiago M. Sayão wrote:
> > Sometimes, randomly i get this Oops message and the system becomes
> > unstable. By unstable i mean all applications segmentation faults when i
> > execute (after the Oops). Sometimes X crashes, sometimes the machine
> > just reboots (the reboot might be other problem tho).
> > 
> > This happens with kernel 2.6.20 and with 2.6.21-rc7. Was happening with
> > 2.6.20 so i tried 2.6.21-rc7 and this also happens.
> > 
> > Apr 22 21:44:33 sayao-desktop kernel: [18641.553890] Unable to handle
> > kernel paging request at ffffffff00003e82 RIP:
> > Apr 22 21:44:33 sayao-desktop kernel: [18641.553899]  [__alloc_skb
> > +188/321] __alloc_skb+0xbc/0x141
> > Apr 22 21:44:33 sayao-desktop kernel: [18641.553911] PGD 203027 PUD 0
> > Apr 22 21:44:33 sayao-desktop kernel: [18641.553915] Oops: 0002 [1] SMP
> > Apr 22 21:44:33 sayao-desktop kernel: [18641.553919] CPU 0
> > Apr 22 21:44:33 sayao-desktop kernel: [18641.553922] Modules linked in:
> > binfmt_misc rfcomm l2cap bluetooth i915 drm ppdev capability commoncap
> > acpi_cpufreq cpufreq_userspace cpufreq_stats cpufreq_conservative
> > cpufreq_ondemand cpufreq_powersave freq_table asus_acpi container sbs
> > i2c_ec i2c_core battery video dock ac button ipv6 lp fuse snd_hda_intel
> > snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy
> > snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq psmouse
> > snd_timer snd_seq_device snd parport_pc parport shpchp serio_raw pcspkr
> > soundcore snd_page_alloc iTCO_wdt iTCO_vendor_support pci_hotplug
> > intel_agp af_packet evdev tsdev ext3 jbd mbcache sg ide_cd cdrom sd_mod
> > ata_generic usbhid hid ata_piix libata scsi_mod e100 mii ehci_hcd
> > generic piix uhci_hcd usbcore thermal processor fan
> > Apr 22 21:44:33 sayao-desktop kernel: [18641.553997] Pid: 13805, comm:
> > evolution Not tainted 2.6.21-rc7-sayao #2
> > Apr 22 21:44:33 sayao-desktop kernel: [18641.554001] RIP:
> > 0010:[__alloc_skb+188/321]  [__alloc_skb+188/321] __alloc_skb+0xbc/0x141
> > Apr 22 21:44:33 sayao-desktop kernel: [18641.554007] RSP:
> > 0018:ffff810033169bd8  EFLAGS: 00010246
> > Apr 22 21:44:33 sayao-desktop kernel: [18641.554011] RAX:
> > ffffffff00003e82 RBX: ffffffff00000002 RCX: 0000000000000000
> > Apr 22 21:44:33 sayao-desktop kernel: [18641.554014] RDX:
> > 0000000000000000 RSI: 0000000000000000 RDI: ffff81003b1bfa50
> > Apr 22 21:44:33 sayao-desktop kernel: [18641.554017] RBP:
> > 0000000000003e80 R08: 0000000000000002 R09: 0000000000000000
> > Apr 22 21:44:33 sayao-desktop kernel: [18641.554021] R10:
> > ffff81003b1bf980 R11: 00000000000000d0 R12: ffff81003b1bf980
> > Apr 22 21:44:33 sayao-desktop kernel: [18641.554024] R13:
> > ffff81003f2109c0 R14: 00000000000004d0 R15: 0000000000003e80
> > Apr 22 21:44:33 sayao-desktop kernel: [18641.554028] FS:
> > 00002ad334669ea0(0000) GS:ffffffff8052f000(0000) knlGS:0000000000000000
> > Apr 22 21:44:33 sayao-desktop kernel: [18641.554032] CS:  0010 DS: 0000
> > ES: 0000 CR0: 0000000080050033
> > Apr 22 21:44:33 sayao-desktop kernel: [18641.554035] CR2:
> > ffffffff00003e82 CR3: 0000000027bb3000 CR4: 00000000000006e0
> > Apr 22 21:44:33 sayao-desktop kernel: [18641.554039] Process evolution
> > (pid: 13805, threadinfo ffff810033168000, task ffff810009665000)
> > Apr 22 21:44:33 sayao-desktop kernel: [18641.554042] Stack:
> > 0000000009665000 ffff81002f9f5080 0000000000003e80 0000000000000000
> > Apr 22 21:44:33 sayao-desktop kernel: [18641.554049]  00000000000004d0
> > ffff810033169ce4 0000000000003e80 ffffffff803a6d82
> > Apr 22 21:44:33 sayao-desktop kernel: [18641.554055]  0000000000000000
> > 0000000000000206 ffffffff80507110 ffff810000dadc50
> > Apr 22 21:44:33 sayao-desktop kernel: [18641.554061] Call Trace:
> > Apr 22 21:44:33 sayao-desktop kernel: [18641.554086]
> > [sock_alloc_send_skb+130/478] sock_alloc_send_skb+0x82/0x1de
> > Apr 22 21:44:33 sayao-desktop kernel: [18641.554126]
> > [unix_stream_sendmsg+392/880] unix_stream_sendmsg+0x188/0x370
> > Apr 22 21:44:33 sayao-desktop kernel: [18641.554181]  [sock_aio_write
> > +293/313] sock_aio_write+0x125/0x139
> > Apr 22 21:44:33 sayao-desktop kernel: [18641.554247]  [do_sync_write
> > +207/277] do_sync_write+0xcf/0x115
> > Apr 22 21:44:33 sayao-desktop kernel: [18641.554287]
> > [autoremove_wake_function+0/48] autoremove_wake_function+0x0/0x30
> > Apr 22 21:44:33 sayao-desktop kernel: [18641.554352]  [vfs_write
> > +228/348] vfs_write+0xe4/0x15c
> > Apr 22 21:44:33 sayao-desktop kernel: [18641.554369]  [sys_write+69/121]
> > sys_write+0x45/0x79
> > Apr 22 21:44:33 sayao-desktop kernel: [18641.554393]  [system_call
> > +126/131] system_call+0x7e/0x83
> > Apr 22 21:44:33 sayao-desktop kernel: [18641.554434] 
> > Apr 22 21:44:33 sayao-desktop kernel: [18641.554436] 
> > Apr 22 21:44:33 sayao-desktop kernel: [18641.554437] Code: c7 00 01 00
> > 00 00 66 c7 40 04 00 00 66 c7 40 06 00 00 66 c7 
> > Apr 22 21:44:33 sayao-desktop kernel: [18641.554453] RIP  [__alloc_skb
> > +188/321] __alloc_skb+0xbc/0x141
> > Apr 22 21:44:33 sayao-desktop kernel: [18641.554458]  RSP
> > <ffff810033169bd8>
> > Apr 22 21:44:33 sayao-desktop kernel: [18641.554460] CR2:
> > ffffffff00003e82
> > 
> 
> It's here in /net/core/skbuff.c, line 174:
> 
>         /* make sure we initialize shinfo sequentially */
>         shinfo = skb_shinfo(skb);
> =>>     atomic_set(&shinfo->dataref, 1);
> 
> It allocated an skb with 16000 bytes of space for data.
> 
> __kmalloc_node returned address 0xffffffff00000002 for the data,
> which I don't even think is a legal address on x86_64. It doesn't
> seem to be a networking problem, the address is invalid/unmapped.
> 
> Can you post your .config ?
> 




