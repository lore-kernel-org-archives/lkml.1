Return-Path: <linux-kernel-owner+w=401wt.eu-S1755465AbYIHTqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbYIHTqz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 15:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883AbYIHTqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 15:46:45 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:23995 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058AbYIHTqo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 15:46:44 -0400
Date: Mon, 8 Sep 2008 12:46:41 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: alejandro.riveira@gmail.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Various OOps with 2.6.27-rc5
Message-Id: <20080908124641.9ec6887a.randy.dunlap@oracle.com>
In-Reply-To: <1220815296.11776.4.camel@Varda>
References: <1220815296.11776.4.camel@Varda>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 07 Sep 2008 21:21:36 +0200 Alejandro Riveira Fernández wrote:

> My kernel is tainted so maybe you want to stop reading here.
> 
> Linux Varda 2.6.27-rc5 #89 SMP PREEMPT Fri Aug 29 12:43:32 CEST 2008 x86_64 GNU/Linux
>  
> Gnu C                  4.2.3
> Gnu make               3.81
> binutils               2.18.0.20080103
> util-linux             2.13.1
> mount                  2.13.1
> module-init-tools      3.3-pre11
> e2fsprogs              1.40.8
> jfsutils               1.1.11
> reiserfsprogs          3.6.19
> pcmciautils            014
> PPP                    2.4.4
> Linux C Library        2.7
> Dynamic linker (ldd)   2.7
> Procps                 3.2.7
> Net-tools              1.60
> Kbd                    [opcion...][archivo
> Console-tools          0.2.3
> Sh-utils               6.10
> udev                   117
> wireless-tools         29
> Modules Loaded         binfmt_misc af_packet rfcomm l2cap bluetooth ipv6 pci_slot container powernow_k8 cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative nf_conntrack_ftp nf_conntrack_irc xt_tcpudp ipt_ULOG xt_limit xt_state nf_conntrack_ipv4 nf_conntrack iptable_filter ip_tables x_tables kvm_amd kvm w83627ehf hwmon_vid lp arc4 snd_hda_intel ecb crypto_blkcipher cryptomgr crypto_algapi snd_pcm_oss snd_mixer_oss snd_mpu401 snd_pcm rt2500pci rt2x00pci rt2x00lib snd_mpu401_uart snd_seq_dummy rfkill snd_seq_oss snd_seq_midi led_class snd_rawmidi snd_seq_midi_event mac80211 evdev cfg80211 k8temp pcspkr eeprom_93cx6 snd_seq usblp nvidia snd_timer snd_seq_device 8250_pnp parport_pc 8250 serial_core parport i2c_ali1535 i2c_ali15x3 snd i2c_core soundcore snd_page_alloc uli526x button sr_mod usbhid ff_memless cdrom floppy sg ata_generic ehci_hcd r8169 ohci_hcd usbcore unix thermal processor fan fuse
> 
> 00:00.0 Host bridge: ALi Corporation M1697 HTT Host Bridge
> 00:01.0 PCI bridge: ALi Corporation PCI Express Root Port
> 00:02.0 PCI bridge: ALi Corporation PCI Express Root Port
> 00:03.0 PCI bridge: ALi Corporation PCI Express Root Port
> 00:04.0 PCI bridge: ALi Corporation PCI Express Root Port
> 00:11.0 PCI bridge: ALi Corporation M5249 HTT to PCI Bridge
> 00:12.0 Ethernet controller: ALi Corporation ULi 1689,1573 integrated ethernet. (rev 60)
> 00:13.0 USB Controller: ALi Corporation USB 1.1 Controller (rev 03)
> 00:13.1 USB Controller: ALi Corporation USB 1.1 Controller (rev 03)
> 00:13.2 USB Controller: ALi Corporation USB 1.1 Controller (rev 03)
> 00:13.3 USB Controller: ALi Corporation USB 2.0 Controller (rev 01)
> 00:14.0 Audio device: ALi Corporation High Definition Audio/AC'97 Host Controller (rev 01)
> 00:15.0 ISA bridge: ALi Corporation PCI to LPC Controller (rev 10)
> 00:15.1 Bridge: ALi Corporation M7101 Power Management Controller [PMU]
> 00:16.0 IDE interface: ALi Corporation M5229 IDE (rev c7)
> 00:16.1 SATA controller: ALi Corporation ULi M5288 SATA
> 00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
> 00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
> 00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
> 00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
> 01:00.0 VGA compatible controller: nVidia Corporation G70 [GeForce 7300 GT] (rev a1)
> 05:0a.0 Network controller: RaLink RT2500 802.11g Cardbus/mini-PCI (rev 01)
> 05:0b.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8169 Gigabit Ethernet (rev 10)
> 
> The dmesg including oopses

Actually they are INFO: messages with getnstimeofday() being stuck,
similar to a few other reports on lkml.


> [    0.000000] Linux version 2.6.27-rc5 (alex@Varda) (gcc version 4.2.3 (Ubuntu 4.2.3-2ubuntu7)) #89 SMP PREEMPT Fri Aug 29 12:43:32 CEST 2008
> [    0.000000] Command line: BOOT_IMAGE=(hd0,2)/vmlinuz-2.6.27-rc5 root=UUID=ee465ea1-394d-4dd2-a5f9-a35567176c40 ro quiet splash

...

> [20979.842035] INFO: task pdflush:198 blocked for more than 120 seconds.
> [20979.842048] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [20979.842053] pdflush       D ffffffff8025b1b7     0   198      2
> [20979.842065]  ffff8800be06dab0 0000000000000046 0000000000000000 00000010bdeff780
> [20979.842074]  ffff880041c788c0 ffff8800be06da60 ffffffff805635c0 ffffffff805635c0
> [20979.842081]  ffffffff8055d000 ffffffff8055d000 ffffffff805635c0 ffffffff805635c0
> [20979.842088] Call Trace:
> [20979.842102]  [<ffffffff80246f9e>] getnstimeofday+0x38/0x95
> [20979.842111]  [<ffffffff8025b1b7>] sync_page+0x0/0x41
> [20979.842119]  [<ffffffff80410ce4>] io_schedule+0x5d/0x9f
> [20979.842126]  [<ffffffff8025b1f3>] sync_page+0x3c/0x41
> [20979.842131]  [<ffffffff80410f4b>] __wait_on_bit+0x40/0x6e
> [20979.842137]  [<ffffffff8025b405>] wait_on_page_bit+0x6c/0x72
> [20979.842145]  [<ffffffff8024269e>] wake_bit_function+0x0/0x23
> [20979.842152]  [<ffffffff802e49d4>] txLock+0x23d/0x5e5
> [20979.842161]  [<ffffffff802faa9c>] attempt_merge+0x380/0x3c2
> [20979.842168]  [<ffffffff802d482a>] diWrite+0x13a/0x43a
> [20979.842175]  [<ffffffff802e2d7f>] txCommit+0x1cf/0xeb5
> [20979.842182]  [<ffffffff802cbc6e>] jfs_commit_inode+0xa9/0xef
> [20979.842189]  [<ffffffff802cbee4>] jfs_write_inode+0x31/0x41
> [20979.842197]  [<ffffffff80299e89>] __writeback_single_inode+0x186/0x2a0
> [20979.842207]  [<ffffffff8022770f>] pick_next_task_fair+0x90/0x9f
> [20979.842213]  [<ffffffff8029a376>] generic_sync_sb_inodes+0x1cf/0x2d8
> [20979.842221]  [<ffffffff8029a649>] writeback_inodes+0x5c/0xa8
> [20979.842229]  [<ffffffff80261916>] wb_kupdate+0xa0/0x113
> [20979.842236]  [<ffffffff80261cb2>] pdflush+0x0/0x204
> [20979.842242]  [<ffffffff80261e05>] pdflush+0x153/0x204
> [20979.842249]  [<ffffffff80261876>] wb_kupdate+0x0/0x113
> [20979.842256]  [<ffffffff80242553>] kthread+0x47/0x74
> [20979.842263]  [<ffffffff8022cc6f>] schedule_tail+0x28/0x61
> [20979.842270]  [<ffffffff8020c2f9>] child_rip+0xa/0x11
> [20979.842276]  [<ffffffff8024250c>] kthread+0x0/0x74
> [20979.842281]  [<ffffffff8020c2ef>] child_rip+0x0/0x11
> [20979.842284] 
> [20979.842333] INFO: task deluge:8943 blocked for more than 120 seconds.
> [20979.842338] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [20979.842342] deluge        D ffff88003668d000     0  8943      1
> [20979.842351]  ffff880051cc9898 0000000000000082 0000000000000200 ffff880051cc9828
> [20979.842358]  ffff8800bf844540 ffff880051cc9848 ffffffff805635c0 ffffffff805635c0
> [20979.842366]  ffffffff8055d000 ffffffff8055d000 ffffffff805635c0 ffffffff805635c0
> [20979.842372] Call Trace:
> [20979.842380]  [<ffffffff80246f9e>] getnstimeofday+0x38/0x95
> [20979.842386]  [<ffffffff80410ce4>] io_schedule+0x5d/0x9f
> [20979.842392]  [<ffffffff802e1b55>] lmGroupCommit+0x113/0x15f
> [20979.842399]  [<ffffffff8022a3ee>] default_wake_function+0x0/0xe
> [20979.842406]  [<ffffffff802e38c0>] txCommit+0xd10/0xeb5
> [20979.842413]  [<ffffffff80306711>] __up_read+0x13/0x8a
> [20979.842420]  [<ffffffff802cbc6e>] jfs_commit_inode+0xa9/0xef
> [20979.842427]  [<ffffffff802decd1>] extAlloc+0x374/0x3c1
> [20979.842435]  [<ffffffff802cc13f>] jfs_get_block+0x162/0x22f
> [20979.842442]  [<ffffffff802a0820>] nobh_write_begin+0x214/0x421
> [20979.842449]  [<ffffffff802cbfdd>] jfs_get_block+0x0/0x22f
> [20979.842455]  [<ffffffff802cbb80>] jfs_write_begin+0x1b/0x20
> [20979.842462]  [<ffffffff802cbfdd>] jfs_get_block+0x0/0x22f
> [20979.842467]  [<ffffffff8025bcc8>] generic_file_buffered_write+0x147/0x686
> [20979.842474]  [<ffffffff802e64a4>] jfs_getxattr+0xd/0x12
> [20979.842482]  [<ffffffff80234fcd>] current_fs_time+0x1e/0x24
> [20979.842489]  [<ffffffff8029a774>] __mark_inode_dirty+0xdf/0x187
> [20979.842496]  [<ffffffff8025c6ef>] __generic_file_aio_write_nolock+0x342/0x376
> [20979.842504]  [<ffffffff8025c787>] generic_file_aio_write+0x64/0xc4
> [20979.842513]  [<ffffffff8027e982>] do_sync_write+0xd1/0x118
> [20979.842520]  [<ffffffff80242670>] autoremove_wake_function+0x0/0x2e
> [20979.842526]  [<ffffffff80410a2a>] thread_return+0x6a/0xbd
> [20979.842535]  [<ffffffff8027f0fb>] vfs_write+0xad/0x143
> [20979.842541]  [<ffffffff8027f5c0>] sys_write+0x45/0x6e
> [20979.842549]  [<ffffffff8020b3db>] system_call_fastpath+0x16/0x1b
> [20979.842553] 
> [21112.986033] INFO: task pdflush:198 blocked for more than 120 seconds.
> [21112.986046] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [21112.986052] pdflush       D ffffffff8025b1b7     0   198      2
> [21112.986063]  ffff8800be06dab0 0000000000000046 0000000000000000 00000010bdeff780
> [21112.986072]  ffff880041c788c0 ffff8800be06da60 ffffffff805635c0 ffffffff805635c0
> [21112.986082]  ffffffff8055d000 ffffffff8055d000 ffffffff805635c0 ffffffff805635c0
> [21112.986092] Call Trace:
> [21112.986107]  [<ffffffff80246f9e>] getnstimeofday+0x38/0x95
> [21112.986116]  [<ffffffff8025b1b7>] sync_page+0x0/0x41
> [21112.986125]  [<ffffffff80410ce4>] io_schedule+0x5d/0x9f
> [21112.986132]  [<ffffffff8025b1f3>] sync_page+0x3c/0x41
> [21112.986138]  [<ffffffff80410f4b>] __wait_on_bit+0x40/0x6e
> [21112.986146]  [<ffffffff8025b405>] wait_on_page_bit+0x6c/0x72
> [21112.986154]  [<ffffffff8024269e>] wake_bit_function+0x0/0x23
> [21112.986162]  [<ffffffff802e49d4>] txLock+0x23d/0x5e5
> [21112.986171]  [<ffffffff802faa9c>] attempt_merge+0x380/0x3c2
> [21112.986179]  [<ffffffff802d482a>] diWrite+0x13a/0x43a
> [21112.986186]  [<ffffffff802e2d7f>] txCommit+0x1cf/0xeb5
> [21112.986194]  [<ffffffff802cbc6e>] jfs_commit_inode+0xa9/0xef
> [21112.986201]  [<ffffffff802cbee4>] jfs_write_inode+0x31/0x41
> [21112.986210]  [<ffffffff80299e89>] __writeback_single_inode+0x186/0x2a0
> [21112.986220]  [<ffffffff8022770f>] pick_next_task_fair+0x90/0x9f
> [21112.986228]  [<ffffffff8029a376>] generic_sync_sb_inodes+0x1cf/0x2d8
> [21112.986236]  [<ffffffff8029a649>] writeback_inodes+0x5c/0xa8
> [21112.986244]  [<ffffffff80261916>] wb_kupdate+0xa0/0x113
> [21112.986252]  [<ffffffff80261cb2>] pdflush+0x0/0x204
> [21112.986258]  [<ffffffff80261e05>] pdflush+0x153/0x204
> [21112.986265]  [<ffffffff80261876>] wb_kupdate+0x0/0x113
> [21112.986272]  [<ffffffff80242553>] kthread+0x47/0x74
> [21112.986281]  [<ffffffff8022cc6f>] schedule_tail+0x28/0x61
> [21112.986289]  [<ffffffff8020c2f9>] child_rip+0xa/0x11
> [21112.986296]  [<ffffffff8024250c>] kthread+0x0/0x74
> [21112.986303]  [<ffffffff8020c2ef>] child_rip+0x0/0x11
> [21112.986307] 
> [21112.986355] INFO: task deluge:8943 blocked for more than 120 seconds.
> [21112.986361] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [21112.986366] deluge        D ffff88003668d000     0  8943      1
> [21112.986378]  ffff880051cc9898 0000000000000082 0000000000000200 ffff880051cc9828
> [21112.986390]  ffff8800bf844540 ffff880051cc9848 ffffffff805635c0 ffffffff805635c0
> [21112.986402]  ffffffff8055d000 ffffffff8055d000 ffffffff805635c0 ffffffff805635c0
> [21112.986413] Call Trace:
> [21112.986421]  [<ffffffff80246f9e>] getnstimeofday+0x38/0x95
> [21112.986428]  [<ffffffff80410ce4>] io_schedule+0x5d/0x9f
> [21112.986435]  [<ffffffff802e1b55>] lmGroupCommit+0x113/0x15f
> [21112.986443]  [<ffffffff8022a3ee>] default_wake_function+0x0/0xe
> [21112.986450]  [<ffffffff802e38c0>] txCommit+0xd10/0xeb5
> [21112.986459]  [<ffffffff80306711>] __up_read+0x13/0x8a
> [21112.986467]  [<ffffffff802cbc6e>] jfs_commit_inode+0xa9/0xef
> [21112.986475]  [<ffffffff802decd1>] extAlloc+0x374/0x3c1
> [21112.986483]  [<ffffffff802cc13f>] jfs_get_block+0x162/0x22f
> [21112.986491]  [<ffffffff802a0820>] nobh_write_begin+0x214/0x421
> [21112.986498]  [<ffffffff802cbfdd>] jfs_get_block+0x0/0x22f
> [21112.986506]  [<ffffffff802cbb80>] jfs_write_begin+0x1b/0x20
> [21112.986513]  [<ffffffff802cbfdd>] jfs_get_block+0x0/0x22f
> [21112.986521]  [<ffffffff8025bcc8>] generic_file_buffered_write+0x147/0x686
> [21112.986529]  [<ffffffff802e64a4>] jfs_getxattr+0xd/0x12
> [21112.986537]  [<ffffffff80234fcd>] current_fs_time+0x1e/0x24
> [21112.986545]  [<ffffffff8029a774>] __mark_inode_dirty+0xdf/0x187
> [21112.986553]  [<ffffffff8025c6ef>] __generic_file_aio_write_nolock+0x342/0x376
> [21112.986561]  [<ffffffff8025c787>] generic_file_aio_write+0x64/0xc4
> [21112.986571]  [<ffffffff8027e982>] do_sync_write+0xd1/0x118
> [21112.986579]  [<ffffffff80242670>] autoremove_wake_function+0x0/0x2e
> [21112.986586]  [<ffffffff80410a2a>] thread_return+0x6a/0xbd
> [21112.986595]  [<ffffffff8027f0fb>] vfs_write+0xad/0x143
> [21112.986603]  [<ffffffff8027f5c0>] sys_write+0x45/0x6e
> [21112.986611]  [<ffffffff8020b3db>] system_call_fastpath+0x16/0x1b
> [21112.986616] 
> [21146.272045] INFO: task syslogd:3966 blocked for more than 120 seconds.
> [21146.272057] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [21146.272063] syslogd       D ffffffff8029e5d9     0  3966      1
> [21146.272074]  ffff8800bae43978 0000000000000082 ffff8800bfa3f400 ffffffff803006f0
> [21146.272083]  ffff8800bd9deab0 ffff8800bae43928 ffffffff805635c0 ffffffff805635c0
> [21146.272091]  ffffffff8055d000 ffffffff8055d000 ffffffff805635c0 ffffffff805635c0
> [21146.272102] Call Trace:
> [21146.272117]  [<ffffffff803006f0>] as_add_request+0xc4/0x100
> [21146.272128]  [<ffffffff80246f9e>] getnstimeofday+0x38/0x95
> [21146.272138]  [<ffffffff8029e5d9>] sync_buffer+0x0/0x3f
> [21146.272147]  [<ffffffff80410ce4>] io_schedule+0x5d/0x9f
> [21146.272155]  [<ffffffff8029e614>] sync_buffer+0x3b/0x3f
> [21146.272162]  [<ffffffff80410f4b>] __wait_on_bit+0x40/0x6e
> [21146.272170]  [<ffffffff8029e5d9>] sync_buffer+0x0/0x3f
> [21146.272177]  [<ffffffff80410fe5>] out_of_line_wait_on_bit+0x6c/0x78
> [21146.272185]  [<ffffffff8024269e>] wake_bit_function+0x0/0x23
> [21146.272193]  [<ffffffff802a0982>] nobh_write_begin+0x376/0x421
> [21146.272201]  [<ffffffff802cbfdd>] jfs_get_block+0x0/0x22f
> [21146.272209]  [<ffffffff802cbb80>] jfs_write_begin+0x1b/0x20
> [21146.272216]  [<ffffffff802cbfdd>] jfs_get_block+0x0/0x22f
> [21146.272224]  [<ffffffff8025bcc8>] generic_file_buffered_write+0x147/0x686
> [21146.272233]  [<ffffffff802e64a4>] jfs_getxattr+0xd/0x12
> [21146.272242]  [<ffffffff80234fcd>] current_fs_time+0x1e/0x24
> [21146.272250]  [<ffffffff8029a774>] __mark_inode_dirty+0xdf/0x187
> [21146.272258]  [<ffffffff8025c6ef>] __generic_file_aio_write_nolock+0x342/0x376
> [21146.272264]  [<ffffffff8028e72b>] __d_lookup+0x110/0x122
> [21146.272272]  [<ffffffff80285cb8>] do_lookup+0x63/0x1c1
> [21146.272280]  [<ffffffff8025c787>] generic_file_aio_write+0x64/0xc4
> [21146.272287]  [<ffffffff8025c723>] generic_file_aio_write+0x0/0xc4
> [21146.272297]  [<ffffffff8027e868>] do_sync_readv_writev+0xc2/0x10b
> [21146.272306]  [<ffffffff802932df>] mntput_no_expire+0x21/0x119
> [21146.272314]  [<ffffffff80242670>] autoremove_wake_function+0x0/0x2e
> [21146.272322]  [<ffffffff80286c9e>] getname+0x140/0x181
> [21146.272330]  [<ffffffff802884de>] user_path_at+0x59/0x7f
> [21146.272338]  [<ffffffff8027ef10>] do_readv_writev+0xb2/0x16f
> [21146.272346]  [<ffffffff80281c14>] sys_newstat+0x28/0x31
> [21146.272354]  [<ffffffff8027f3c7>] sys_writev+0x45/0x93
> [21146.272362]  [<ffffffff8020b3db>] system_call_fastpath+0x16/0x1b
> [21146.272367] 
> [21179.558077] INFO: task deluge:8940 blocked for more than 120 seconds.
> [21179.558089] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [21179.558096] deluge        D 00000001013c6cd6     0  8940      1
> [21179.558107]  ffff880095801b28 0000000000000082 0000000000000000 0000000000792c32
> [21179.558115]  0000000300000000 ffff880095801ad8 ffffffff805635c0 ffffffff805635c0
> [21179.558126]  ffffffff8055d000 ffffffff8055d000 ffffffff805635c0 ffffffff805635c0
> [21179.558137] Call Trace:
> [21179.558155]  [<ffffffff802df240>] release_metapage+0x124/0x130
> [21179.558164]  [<ffffffff8025b1b7>] sync_page+0x0/0x41
> [21179.558173]  [<ffffffff80410ce4>] io_schedule+0x5d/0x9f
> [21179.558180]  [<ffffffff8025b1f3>] sync_page+0x3c/0x41
> [21179.558187]  [<ffffffff80410f4b>] __wait_on_bit+0x40/0x6e
> [21179.558194]  [<ffffffff8025b405>] wait_on_page_bit+0x6c/0x72
> [21179.558202]  [<ffffffff8024269e>] wake_bit_function+0x0/0x23
> [21179.558210]  [<ffffffff802e49d4>] txLock+0x23d/0x5e5
> [21179.558218]  [<ffffffff802d95ff>] read_index_page+0x4b/0x55
> [21179.558226]  [<ffffffff802ddfa6>] dtDelete+0x20a/0x8d4
> [21179.558235]  [<ffffffff80285cb8>] do_lookup+0x63/0x1c1
> [21179.558243]  [<ffffffff802857a2>] inode_permission+0x66/0xa9
> [21179.558250]  [<ffffffff802e2b9e>] txBegin+0x2ac/0x2be
> [21179.558257]  [<ffffffff80411e35>] __down_write_nested+0x34/0x9e
> [21179.558264]  [<ffffffff802cc807>] jfs_unlink+0xbf/0x317
> [21179.558271]  [<ffffffff8028654d>] vfs_unlink+0x5e/0xa3
> [21179.558279]  [<ffffffff80288007>] do_unlinkat+0xa8/0x135
> [21179.558288]  [<ffffffff8028a514>] sys_poll+0x35/0x86
> [21179.558296]  [<ffffffff8020b3db>] system_call_fastpath+0x16/0x1b
> [21179.558301] 
> [21212.844070] INFO: task gtk-window-deco:5253 blocked for more than 120 seconds.
> [21212.844083] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [21212.844088] gtk-window-de D ffffffff8025b1b7     0  5253   5250
> [21212.844099]  ffff8800a448bca8 0000000000000086 0000000000000000 ffff8800a448bd48
> [21212.844108]  ffff88009cb0c080 ffff8800a448bc58 ffffffff805635c0 ffffffff805635c0
> [21212.844119]  ffffffff8055d000 ffffffff8055d000 ffffffff805635c0 ffffffff805635c0
> [21212.844129] Call Trace:
> [21212.844144]  [<ffffffff802cbfdd>] jfs_get_block+0x0/0x22f
> [21212.844154]  [<ffffffff80246f9e>] getnstimeofday+0x38/0x95
> [21212.844162]  [<ffffffff8025b1b7>] sync_page+0x0/0x41
> [21212.844171]  [<ffffffff80410ce4>] io_schedule+0x5d/0x9f
> [21212.844178]  [<ffffffff8025b1f3>] sync_page+0x3c/0x41
> [21212.844185]  [<ffffffff80410e60>] __wait_on_bit_lock+0x3f/0x72
> [21212.844192]  [<ffffffff8025b1a3>] __lock_page+0x5e/0x64
> [21212.844200]  [<ffffffff8024269e>] wake_bit_function+0x0/0x23
> [21212.844207]  [<ffffffff8025b33c>] find_lock_page+0x30/0x50
> [21212.844215]  [<ffffffff8025d29d>] filemap_fault+0x1a2/0x3a5
> [21212.844224]  [<ffffffff802679c8>] __do_fault+0x54/0x387
> [21212.844231]  [<ffffffff80269543>] handle_mm_fault+0x373/0x6dd
> [21212.844238]  [<ffffffff80410a2a>] thread_return+0x6a/0xbd
> [21212.844248]  [<ffffffff8022038c>] do_page_fault+0x381/0x741
> [21212.844258]  [<ffffffff8027f24e>] vfs_read+0xbd/0x140
> [21212.844265]  [<ffffffff80412659>] error_exit+0x0/0x51
> [21212.844270] 
> [21246.130033] INFO: task pdflush:198 blocked for more than 120 seconds.
> [21246.130046] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [21246.130052] pdflush       D ffffffff8025b1b7     0   198      2
> [21246.130063]  ffff8800be06dab0 0000000000000046 0000000000000000 00000010bdeff780
> [21246.130072]  ffff880041c788c0 ffff8800be06da60 ffffffff805635c0 ffffffff805635c0
> [21246.130083]  ffffffff8055d000 ffffffff8055d000 ffffffff805635c0 ffffffff805635c0
> [21246.130092] Call Trace:
> [21246.130107]  [<ffffffff80246f9e>] getnstimeofday+0x38/0x95
> [21246.130116]  [<ffffffff8025b1b7>] sync_page+0x0/0x41
> [21246.130125]  [<ffffffff80410ce4>] io_schedule+0x5d/0x9f
> [21246.130132]  [<ffffffff8025b1f3>] sync_page+0x3c/0x41
> [21246.130139]  [<ffffffff80410f4b>] __wait_on_bit+0x40/0x6e
> [21246.130146]  [<ffffffff8025b405>] wait_on_page_bit+0x6c/0x72
> [21246.130154]  [<ffffffff8024269e>] wake_bit_function+0x0/0x23
> [21246.130162]  [<ffffffff802e49d4>] txLock+0x23d/0x5e5
> [21246.130171]  [<ffffffff802faa9c>] attempt_merge+0x380/0x3c2
> [21246.130180]  [<ffffffff802d482a>] diWrite+0x13a/0x43a
> [21246.130186]  [<ffffffff802e2d7f>] txCommit+0x1cf/0xeb5
> [21246.130195]  [<ffffffff802cbc6e>] jfs_commit_inode+0xa9/0xef
> [21246.130202]  [<ffffffff802cbee4>] jfs_write_inode+0x31/0x41
> [21246.130211]  [<ffffffff80299e89>] __writeback_single_inode+0x186/0x2a0
> [21246.130221]  [<ffffffff8022770f>] pick_next_task_fair+0x90/0x9f
> [21246.130229]  [<ffffffff8029a376>] generic_sync_sb_inodes+0x1cf/0x2d8
> [21246.130237]  [<ffffffff8029a649>] writeback_inodes+0x5c/0xa8
> [21246.130245]  [<ffffffff80261916>] wb_kupdate+0xa0/0x113
> [21246.130253]  [<ffffffff80261cb2>] pdflush+0x0/0x204
> [21246.130259]  [<ffffffff80261e05>] pdflush+0x153/0x204
> [21246.130266]  [<ffffffff80261876>] wb_kupdate+0x0/0x113
> [21246.130273]  [<ffffffff80242553>] kthread+0x47/0x74
> [21246.130282]  [<ffffffff8022cc6f>] schedule_tail+0x28/0x61
> [21246.130291]  [<ffffffff8020c2f9>] child_rip+0xa/0x11
> [21246.130298]  [<ffffffff8024250c>] kthread+0x0/0x74
> [21246.130305]  [<ffffffff8020c2ef>] child_rip+0x0/0x11
> [21246.130309] 
> [21246.130358] INFO: task deluge:8943 blocked for more than 120 seconds.
> [21246.130364] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [21246.130369] deluge        D ffff88003668d000     0  8943      1
> [21246.130380]  ffff880051cc9898 0000000000000082 0000000000000200 ffff880051cc9828
> [21246.130392]  ffff8800bf844540 ffff880051cc9848 ffffffff805635c0 ffffffff805635c0
> [21246.130404]  ffffffff8055d000 ffffffff8055d000 ffffffff805635c0 ffffffff805635c0
> [21246.130414] Call Trace:
> [21246.130422]  [<ffffffff80246f9e>] getnstimeofday+0x38/0x95
> [21246.130429]  [<ffffffff80410ce4>] io_schedule+0x5d/0x9f
> [21246.130436]  [<ffffffff802e1b55>] lmGroupCommit+0x113/0x15f
> [21246.130444]  [<ffffffff8022a3ee>] default_wake_function+0x0/0xe
> [21246.130451]  [<ffffffff802e38c0>] txCommit+0xd10/0xeb5
> [21246.130459]  [<ffffffff80306711>] __up_read+0x13/0x8a
> [21246.130467]  [<ffffffff802cbc6e>] jfs_commit_inode+0xa9/0xef
> [21246.130475]  [<ffffffff802decd1>] extAlloc+0x374/0x3c1
> [21246.130483]  [<ffffffff802cc13f>] jfs_get_block+0x162/0x22f
> [21246.130491]  [<ffffffff802a0820>] nobh_write_begin+0x214/0x421
> [21246.130498]  [<ffffffff802cbfdd>] jfs_get_block+0x0/0x22f
> [21246.130506]  [<ffffffff802cbb80>] jfs_write_begin+0x1b/0x20
> [21246.130513]  [<ffffffff802cbfdd>] jfs_get_block+0x0/0x22f
> [21246.130520]  [<ffffffff8025bcc8>] generic_file_buffered_write+0x147/0x686
> [21246.130527]  [<ffffffff802e64a4>] jfs_getxattr+0xd/0x12
> [21246.130536]  [<ffffffff80234fcd>] current_fs_time+0x1e/0x24
> [21246.130544]  [<ffffffff8029a774>] __mark_inode_dirty+0xdf/0x187
> [21246.130551]  [<ffffffff8025c6ef>] __generic_file_aio_write_nolock+0x342/0x376
> [21246.130559]  [<ffffffff8025c787>] generic_file_aio_write+0x64/0xc4
> [21246.130569]  [<ffffffff8027e982>] do_sync_write+0xd1/0x118
> [21246.130577]  [<ffffffff80242670>] autoremove_wake_function+0x0/0x2e
> [21246.130584]  [<ffffffff80410a2a>] thread_return+0x6a/0xbd
> [21246.130592]  [<ffffffff8027f0fb>] vfs_write+0xad/0x143
> [21246.130601]  [<ffffffff8027f5c0>] sys_write+0x45/0x6e
> [21246.130608]  [<ffffffff8020b3db>] system_call_fastpath+0x16/0x1b
> [21246.130613] 


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
