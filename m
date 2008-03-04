Return-Path: <linux-kernel-owner+w=401wt.eu-S1758304AbYCDAfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758304AbYCDAfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 19:35:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751027AbYCDAe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 19:34:58 -0500
Received: from mail001.aei.ca ([206.123.6.130]:39374 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbYCDAe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 19:34:56 -0500
/m: spam: 3.2.1
From: Ed Tomlinson <edt@aei.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Panic 2.6.24-3 Unable to handle kernel paging request
Date: Mon, 3 Mar 2008 19:34:51 -0500
User-Agent: KMail/1.9.7
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
References: <200803010902.47997.edt@aei.ca>
In-Reply-To: <200803010902.47997.edt@aei.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="ansi_x3.4-1968"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803031934.51944.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On March 1, 2008, Ed Tomlinson wrote:

Andrew,

Is there anyone else I should be copying on this? 

TIA
Ed Tomlinson

> I have been seeing these since I installed 2.6.24.   Previous kernels (up to 2.6.23-5) have been ok.   Using the .24 kernels I get 
> from a minute to a few days of uptime.  Any ideas on what might be causing this?  
> 
> TIA,
> Ed Tomlinson
> 
> (2.6.24-gentoo-r2 + 2.6.24-3 patchset)
> grover login: [72899.939987] Unable to handle kernel paging request at 000000620000005e RIP: 
> [72899.953805]  [<000000620000005e>]
> [72899.971089] PGD 48cfa067 PUD 0 
> [72899.980552] Oops: 0010 [1] PREEMPT 
> [72899.991054] CPU 0 
> [72899.997110] Modules linked in: radeon ipv6 af_packet rfcomm l2cap snd_pcm_oss snd_mixer_oss snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device xfs hci_usb bluetooth usbhid pl2303 usbserial usbmouse ohci_hcd ehci_hcd video1394 w83627hf hwmon_vid i2c_nforce2 forcedeth sr_mod cdrom sbp2 radeonfb fb_ddc i2c_algo_bit i2c_core ohci1394 ieee1394 snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm thermal processor snd_timer snd button soundcore snd_page_alloc parport_pc parport psmouse pcspkr evdev k8temp hwmon floppy rtc unix
> [72900.139457] Pid: 0, comm: swapper Not tainted 2.6.24-gentoo-r2-crc #2
> [72900.158744] RIP: 0010:[<000000620000005e>]  [<000000620000005e>]
> [72900.176758] RSP: 0018:ffffffff8062cbb8  EFLAGS: 00010202
> [72900.192666] RAX: 000000620000005e RBX: 0000000000000002 RCX: 0000000000000136
> [72900.214034] RDX: 0000000000000011 RSI: ffffffff8062cbf0 RDI: ffff810044e90100
> [72900.235400] RBP: ffffffff8062cc90 R08: ffff810044e90100 R09: ffffffff80672000
> [72900.256768] R10: 0000000000000103 R11: 0000000000000001 R12: ffff810044e90138
> [72900.278136] R13: 0000000000000002 R14: 0000000000000000 R15: ffff810044e90100
> [72900.299504] FS:  00002af955fe21d0(0000) GS:ffffffff805ed000(0000) knlGS:00000000f7d1c6c0
> [72900.323731] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> [72900.340939] CR2: 000000620000005e CR3: 000000004b2cc000 CR4: 00000000000006e0
> [72900.362306] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [72900.383673] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [72900.405042] Process swapper (pid: 0, threadinfo ffffffff805f6000, task ffffffff805ac360)
> [72900.429268] Stack:  ffffffff80476f61 ffffffff8062cbd0 0000000080227f4d ffffffff8062cbf0
> [72900.453443]  ffffffff80242fb1 ffff810002186fc0 ffff8100021857a8 0000000000000000
> [72900.475720]  0207a8c000000000 000000005b025257 0000000000000000 0000000000000000
> [72900.497425] Call Trace:
> [72900.505301]  <IRQ>  [<ffffffff80476f61>] __xfrm_policy_check+0x461/0x5b0
> [72900.525426]  [<ffffffff80242fb1>] autoremove_wake_function+0x11/0x40
> [72900.544455]  [<ffffffff80228a84>] __wake_up+0x84/0x90
> [72900.559579]  [<ffffffff8045d51a>] __udp4_lib_lookup+0x10a/0x160
> [72900.577309]  [<ffffffff8045e6b6>] __udp4_lib_rcv+0x6a6/0x8a0
> [72900.594257]  [<ffffffff80261ed0>] mempool_free+0x30/0xe0
> [72900.610165]  [<ffffffff802b2c5b>] bio_free+0x3b/0x50
> [72900.625035]  [<ffffffff80225be0>] __enqueue_entity+0x80/0x90
> [72900.641984]  [<ffffffff8045e8c5>] udp_rcv+0x15/0x20
> [72900.656592]  [<ffffffff8043aecb>] ip_local_deliver_finish+0xbb/0x230
> [72900.675619]  [<ffffffff8043b49b>] ip_local_deliver+0x3b/0x90
> [72900.692569]  [<ffffffff8043abb4>] ip_rcv_finish+0x124/0x380
> [72900.709256]  [<ffffffff80227f5b>] wake_up_state+0xb/0x10
> [72900.725164]  [<ffffffff80237dad>] signal_wake_up+0x1d/0x20
> [72900.741593]  [<ffffffff8043b372>] ip_rcv+0x1b2/0x2a0
> [72900.756463]  [<ffffffff80416740>] netif_receive_skb+0x250/0x4b0
> [72900.774192]  [<ffffffff80418ec5>] process_backlog+0x75/0xe0
> [72900.790883]  [<ffffffff8813cbb2>] :forcedeth:nv_alloc_rx+0xc2/0x1c0
> [72900.809647]  [<ffffffff80418a12>] net_rx_action+0x152/0x240
> [72900.826337]  [<ffffffff8023249a>] __do_softirq+0x5a/0xc0
> [72900.842245]  [<ffffffff8020c89c>] call_softirq+0x1c/0x30
> [72900.858152]  [<ffffffff8020da9d>] do_softirq+0x3d/0x90
> [72900.873542]  [<ffffffff802323c8>] irq_exit+0x88/0xa0
> [72900.888410]  [<ffffffff8020de52>] do_IRQ+0x62/0xc0
> [72900.902759]  [<ffffffff8020c0c1>] ret_from_intr+0x0/0xa
> [72900.918405]  <EOI>  [<ffffffff8024c99d>] tick_nohz_stop_sched_tick+0x1ad/0x2b0
> [72900.940062]  [<ffffffff8020a7e0>] poll_idle+0x0/0x10
> [72900.954929]  [<ffffffff8020a8aa>] cpu_idle+0x2a/0x90
> [72900.969798]  [<ffffffff8047ea79>] rest_init+0x69/0x70
> [72900.984930]  [<ffffffff805f9aaa>] start_kernel+0x25a/0x2a0
> [72901.001356]  [<ffffffff805f9107>] _sinittext+0x107/0x110
> [72901.017264] 
> [72901.021732] 
> [72901.021733] Code:  Bad RIP value.
> [72901.036160] RIP  [<000000620000005e>]
> [72901.047157]  RSP <ffffffff8062cbb8>
> [72901.057606] CR2: 000000620000005e
> [72901.067547] ---[ end trace 327eafb6f155470d ]---
> 
> (2.6.24-gentoo-r2-crc)
> grover login: [85104.640970] Unable to handle kernel paging request at 0000007400000073 RIP: 
> [85104.654782]  [<0000007400000073>]
> [85104.672068] PGD 2bbbc067 PUD 0 
> [85104.681554] Oops: 0010 [1] PREEMPT 
> [85104.692058] CPU 0 
> [85104.698113] Modules linked in: radeon ipv6 af_packet rfcomm l2cap snd_pcm_oss snd_mixer_oss snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device xfs hci_usb bluetooth usbhid pl2303 usbserial usbmouse ohci_hcd ehci_hcd video1394 w83627hf hwmon_vid i2c_nforce2 forcedeth sr_mod cdrom sbp2 radeonfb fb_ddc i2c_algo_bit i2c_core thermal processor ohci1394 ieee1394 snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_timer snd parport_pc soundcore snd_page_alloc parport button floppy psmouse k8temp hwmon evdev pcspkr rtc unix
> [85104.840227] Pid: 10022, comm: atop Not tainted 2.6.24-gentoo-r2-crc #1
> [85104.859773] RIP: 0010:[<0000007400000073>]  [<0000007400000073>]
> [85104.877813] RSP: 0000:ffffffff8062cb88  EFLAGS: 00010202
> [85104.893722] RAX: 0000007400000073 RBX: 0000000000000002 RCX: 00000000000000b3
> [85104.915090] RDX: 0000000000000011 RSI: ffffffff8062cbc0 RDI: ffff81002b876a00
> [85104.936456] RBP: ffffffff8062cc60 R08: ffff81002b876a00 R09: 0000000000000000
> [85104.957823] R10: 0000000000000001 R11: 00002b6b9cbdb064 R12: ffff8100290bd380
> [85104.979191] R13: 0000000000000002 R14: ffff8100290bd380 R15: ffff81002b876a00
> [85105.000559] FS:  00002b6b9d910b00(0000) GS:ffffffff805ed000(0000) knlGS:0000000000000000
> [85105.024786] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [85105.041995] CR2: 0000007400000073 CR3: 000000002bba1000 CR4: 00000000000006e0
> [85105.063362] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [85105.084729] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [85105.106097] Process atop (pid: 10022, threadinfo ffff81004b244000, task ffff810003e91590)
> [85105.130584] Stack:  ffffffff80476d71 0000000000000000 0000000000000001 0000000000000001
> [85105.154681]  ffff81004fb03468 0000000000000082 ffffffff8062cbf8 0000000000000000
> [85105.176983]  0207a8c000000000 000000004ca3c048 0000000000000000 0000000000000000
> [85105.198714] Call Trace:
> [85105.206567]  <IRQ>  [<ffffffff80476d71>] __xfrm_policy_check+0x461/0x5b0
> [85105.226695]  [<ffffffff8045db9c>] udp_queue_rcv_skb+0x3c/0x2d0
> [85105.244155]  [<ffffffff8045e1b4>] __udp4_lib_rcv+0x384/0x8a0
> [85105.261106]  [<ffffffff803eaab9>] input_handle_event+0xb9/0x3b0
> [85105.278836]  [<ffffffff8045e6e5>] udp_rcv+0x15/0x20
> [85105.293443]  [<ffffffff8043acdb>] ip_local_deliver_finish+0xbb/0x230
> [85105.312470]  [<ffffffff803d8335>] usb_free_urb+0x15/0x20
> [85105.328378]  [<ffffffff8043b2ab>] ip_local_deliver+0x3b/0x90
> [85105.345325]  [<ffffffff8043a9c4>] ip_rcv_finish+0x124/0x380
> [85105.362016]  [<ffffffff80225bd0>] __enqueue_entity+0x80/0x90
> [85105.378962]  [<ffffffff80281481>] add_partial_tail+0x41/0x70
> [85105.395913]  [<ffffffff8043b182>] ip_rcv+0x1b2/0x2a0
> [85105.410782]  [<ffffffff80416550>] netif_receive_skb+0x250/0x4b0
> [85105.428511]  [<ffffffff80418cd5>] process_backlog+0x75/0xe0
> [85105.445203]  [<ffffffff8813cbb2>] :forcedeth:nv_alloc_rx+0xc2/0x1c0
> [85105.463965]  [<ffffffff80418822>] net_rx_action+0x152/0x240
> [85105.480656]  [<ffffffff8023248a>] __do_softirq+0x5a/0xc0
> [85105.496563]  [<ffffffff8020c89c>] call_softirq+0x1c/0x30
> [85105.512471]  [<ffffffff8020da9d>] do_softirq+0x3d/0x90
> [85105.527858]  [<ffffffff802323b8>] irq_exit+0x88/0xa0
> [85105.542728]  [<ffffffff8020de52>] do_IRQ+0x62/0xc0
> [85105.557076]  [<ffffffff8020c0c1>] ret_from_intr+0x0/0xa
> [85105.572723]  <EOI> 
> [85105.579066] 
> [85105.579066] Code:  Bad RIP value.
> [85105.593544] RIP  [<0000007400000073>]
> [85105.604540]  RSP <ffffffff8062cb88>
> [85105.614965] CR2: 0000007400000073
> [85105.625069] ---[ end trace 7ccf4561d294e7dc ]---
> [85105.638918] Kernel panic - not syncing: Aiee, killing interrupt handler!
> 
> (2.4.24 + 2.5.24-1 patchset)
> [374029.430366] Unable to handle kernel paging request at 0000006700000055 RIP: 
> [374029.444463]  [<0000006700000055>]
> [374029.462007] PGD 3f9c7067 PUD 0 
> [374029.471730] Oops: 0010 [1] PREEMPT 
> [374029.482519] CPU 0 
> [374029.488833] Modules linked in: radeon ipv6 af_packet rfcomm l2cap snd_pcm_oss snd_mixer_oss snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device xfs hci_usb bluetooth usbhid pl2303 usbserial usbmouse ohci_hcd ehci_hcd video1394 w83627hf hwmon_vid i2c_nforce2 forcedeth sr_mod cdrom sbp2 parport_pc parport ohci1394 evdev psmouse ieee1394 floppy rtc pcspkr k8temp hwmon radeonfb fb_ddc i2c_algo_bit i2c_core snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm button thermal processor snd_timer snd soundcore snd_page_alloc unix
> [374029.631467] Pid: 18369, comm: atop Not tainted 2.6.24-gentoo-crc #1
> [374029.650494] RIP: 0010:[<0000006700000055>]  [<0000006700000055>]
> [374029.668794] RSP: 0018:ffffffff8062cb88  EFLAGS: 00010206
> [374029.684962] RAX: 0000006700000055 RBX: 0000000000000002 RCX: 00000000000000c3
> [374029.706589] RDX: 0000000000000011 RSI: ffffffff8062cbc0 RDI: ffff810009f53b00
> [374029.728216] RBP: ffffffff8062cc60 R08: ffff810009f53b00 R09: 0000000000000000
> [374029.749845] R10: 0000000000000001 R11: 0000000000000000 R12: ffff81003a226000
> [374029.771472] R13: 0000000000000002 R14: ffff81003a226000 R15: ffff810009f53b00
> [374029.793099] FS:  00002b213b00eb00(0000) GS:ffffffff805ed000(0000) knlGS:00000000f6c836c0
> [374029.817585] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [374029.835054] CR2: 0000006700000055 CR3: 000000003b733000 CR4: 00000000000006e0
> [374029.856681] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [374029.878310] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [374029.899935] Process atop (pid: 18369, threadinfo ffff81003b504000, task ffff81002f94e000)
> [374029.924682] Stack:  ffffffff80477461 ffffffff8062cc40 000000008062cd74 ffffffff8062cbe0
> [374029.949065]  ffffffff80471b35 0000000000000000 ffffffff8062cc40 0000000000000000
> [374029.971576]  0207a8c000000000 00000000e685bc18 0000000000000000 0000000000000000
> [374029.993542] Call Trace:
> [374030.001679]  <IRQ>  [<ffffffff80477461>] __xfrm_policy_check+0x461/0x5b0
> [374030.022060]  [<ffffffff80471b35>] fib_lookup+0x35/0x50
> [374030.037716]  [<ffffffff80232c62>] local_bh_enable+0x42/0xb0
> [374030.054659]  [<ffffffff804373cd>] rt_intern_hash+0x36d/0x3d0
> [374030.071867]  [<ffffffff8045e28c>] udp_queue_rcv_skb+0x3c/0x2d0
> [374030.089595]  [<ffffffff8045e8a4>] __udp4_lib_rcv+0x384/0x8a0
> [374030.106808]  [<ffffffff80225c77>] enqueue_entity+0x37/0x70
> [374030.123492]  [<ffffffff8045edd5>] udp_rcv+0x15/0x20
> [374030.138359]  [<ffffffff8043b35b>] ip_local_deliver_finish+0xbb/0x230
> [374030.157647]  [<ffffffff8043b92b>] ip_local_deliver+0x3b/0x90
> [374030.174854]  [<ffffffff8043b044>] ip_rcv_finish+0x124/0x380
> [374030.191803]  [<ffffffff80225c77>] enqueue_entity+0x37/0x70
> [374030.208493]  [<ffffffff8043b802>] ip_rcv+0x1b2/0x2a0
> [374030.223625]  [<ffffffff80416bd0>] netif_receive_skb+0x250/0x4b0
> [374030.241612]  [<ffffffff80419355>] process_backlog+0x75/0xe0
> [374030.258568]  [<ffffffff88140bb2>] :forcedeth:nv_alloc_rx+0xc2/0x1c0
> [374030.277587]  [<ffffffff80418ea2>] net_rx_action+0x152/0x240
> [374030.294535]  [<ffffffff80232a2a>] __do_softirq+0x5a/0xc0
> [374030.310705]  [<ffffffff8020c87c>] call_softirq+0x1c/0x30
> [374030.326872]  [<ffffffff8020da7d>] do_softirq+0x3d/0x90
> [374030.342519]  [<ffffffff80232958>] irq_exit+0x88/0xa0
> [374030.357649]  [<ffffffff8020de32>] do_IRQ+0x62/0xc0
> [374030.372258]  [<ffffffff8020c0a1>] ret_from_intr+0x0/0xa
> [374030.388164]  <EOI>  [<ffffffff80321887>] clear_page_c+0x7/0x10
> [374030.405950]  [<ffffffff80265073>] get_page_from_freelist+0x2d3/0x4b0
> [374030.425239]  [<ffffffff802652be>] __alloc_pages+0x6e/0x3a0
> [374030.441929]  [<ffffffff8026fc86>] handle_mm_fault+0x4f6/0x790
> [374030.459395]  [<ffffffff8027004d>] get_user_pages+0x12d/0x370
> [374030.476601]  [<ffffffff8027111b>] make_pages_present+0x8b/0xc0
> [374030.494327]  [<ffffffff8027460c>] mmap_region+0x41c/0x4b0
> [374030.510759]  [<ffffffff80293f8c>] path_walk+0x1c/0x20
> [374030.526149]  [<ffffffff80210a01>] arch_get_unmapped_area+0xf1/0x280
> [374030.545177]  [<ffffffff80274dc6>] do_mmap_pgoff+0x3a6/0x3d0
> [374030.562123]  [<ffffffff80481865>] __down_write_nested+0xc5/0x100
> [374030.580373]  [<ffffffff8021085c>] sys_mmap+0x7c/0x130
> [374030.595760]  [<ffffffff8020bb8e>] system_call+0x7e/0x83
> [374030.611668] 
> [374030.616395] 
> [374030.616396] Code:  Bad RIP value.
> [374030.631341] RIP  [<0000006700000055>]
> [374030.642598]  RSP <ffffffff8062cb88>
> [374030.653307] CR2: 0000006700000055
> [374030.663888] ---[ end trace a832b9d6ae089d1c ]---
> [374030.677992] Kernel panic - not syncing: Aiee, killing interrupt handler!
> 
> I have more if they will help.
> 
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


