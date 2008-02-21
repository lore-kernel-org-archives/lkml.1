Return-Path: <linux-kernel-owner+w=401wt.eu-S1763378AbYBUKiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763378AbYBUKiy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 05:38:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758202AbYBUKip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 05:38:45 -0500
Received: from server077.de-nserver.de ([62.27.12.245]:44203 "EHLO
	server077.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185AbYBUKim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 05:38:42 -0500
Message-ID: <47BD54A5.6060602@allied-internet.ag>
Date: Thu, 21 Feb 2008 11:38:29 +0100
From: Stefan Priebe - allied internet ag <s.priebe@allied-internet.ag>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.24.2 many WARNING: at net/ipv4/tcp_input.c / tcp_output.c
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by hostmaster@profihost.com through 85.158.179.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

Since my Update to 2.6.24.2 i get many WARNINGS like this:

[193948.797708] WARNING: at net/ipv4/tcp_output.c:1799 
tcp_simple_retransmit()
[193948.797740] Pid: 0, comm: swapper Not tainted 2.6.24.2 #3
[193948.797761]  [<c0359f20>] tcp_simple_retransmit+0x1ed/0x1f2
[193948.797789]  [<c035ddd3>] tcp_v4_err+0x4f3/0x575
[193948.797812]  [<c034239f>] ip_rt_frag_needed+0x60/0x216
[193948.797834]  [<c03414ef>] ip_route_input+0x34a/0xb8e
[193948.797855]  [<c0365d9f>] icmp_unreach+0x12f/0x3b0
[193948.797878]  [<c03281c5>] skb_checksum+0x51/0x2e7
[193948.797902]  [<c033e4b6>] nf_iterate+0x66/0x8a
[193948.797926]  [<c032ae59>] __skb_checksum_complete_head+0x18/0x5b
[193948.797948]  [<c0365502>] icmp_rcv+0x10f/0x146
[193948.797970]  [<c034375c>] ip_local_deliver_finish+0x95/0x17b
[193948.797992]  [<c034350b>] ip_rcv_finish+0xbb/0x277
[193948.798013]  [<c032dcc7>] netif_receive_skb+0x171/0x1f6
[193948.798036]  [<c03301f1>] process_backlog+0x63/0xc4
[193948.798058]  [<c032fc80>] net_rx_action+0x79/0x13a
[193948.798080]  [<c011f422>] __do_softirq+0x72/0xdf
[193948.798103]  [<c011f4c6>] do_softirq+0x37/0x39
[193948.798125]  [<c0104f29>] do_IRQ+0x40/0x77
[193948.798147]  [<c010f4d9>] smp_apic_timer_interrupt+0x5a/0x85
[193948.798170]  [<c0101542>] default_idle+0x0/0x3e
[193948.798192]  [<c0103157>] common_interrupt+0x23/0x28
[193948.798213]  [<c0101542>] default_idle+0x0/0x3e
[193948.798233]  [<c0101571>] default_idle+0x2f/0x3e
[193948.798255]  [<c0100de4>] cpu_idle+0x74/0x8d
[193948.798275]  [<c0486c1f>] start_kernel+0x2b7/0x2f8
[193948.798297]  [<c04863b9>] unknown_bootoption+0x0/0x1e6
[193948.798320]  =======================
[193949.067661] WARNING: at net/ipv4/tcp_input.c:1675 tcp_enter_frto()
[193949.067692] Pid: 0, comm: swapper Not tainted 2.6.24.2 #3
[193949.067715]  [<c0355813>] tcp_enter_frto+0x25e/0x269
[193949.067743]  [<c035ade3>] tcp_write_timer+0x2d5/0x6a2
[193949.067765]  [<c0132bd3>] clockevents_program_event+0x90/0x103
[193949.067793]  [<c012e789>] ktime_get_ts+0x11/0x3a
[193949.067817]  [<c012260a>] run_timer_softirq+0x146/0x1a6
[193949.067842]  [<c035ab0e>] tcp_write_timer+0x0/0x6a2
[193949.067867]  [<c035ab0e>] tcp_write_timer+0x0/0x6a2
[193949.067892]  [<c011f422>] __do_softirq+0x72/0xdf
[193949.067917]  [<c011f4c6>] do_softirq+0x37/0x39
[193949.067940]  [<c010f4d9>] smp_apic_timer_interrupt+0x5a/0x85
[193949.067967]  [<c0101542>] default_idle+0x0/0x3e
[193949.067989]  [<c0103214>] apic_timer_interrupt+0x28/0x30
[193949.068014]  [<c0101542>] default_idle+0x0/0x3e
[193949.068037]  [<c0101571>] default_idle+0x2f/0x3e
[193949.068065]  [<c0100de4>] cpu_idle+0x74/0x8d
[193949.068091]  [<c0486c1f>] start_kernel+0x2b7/0x2f8
[193949.068117]  [<c04863b9>] unknown_bootoption+0x0/0x1e6
[193949.068141]  =======================
[193949.811449] WARNING: at net/ipv4/tcp_input.c:1675 tcp_enter_frto()
[193949.811569] Pid: 0, comm: swapper Not tainted 2.6.24.2 #3
[193949.811645]  [<c0355813>] tcp_enter_frto+0x25e/0x269
[193949.811755]  [<c035ade3>] tcp_write_timer+0x2d5/0x6a2
[193949.811838]  [<c0132bd3>] clockevents_program_event+0x90/0x103
[193949.811938]  [<c012e789>] ktime_get_ts+0x11/0x3a
[193949.812021]  [<c012260a>] run_timer_softirq+0x146/0x1a6
[193949.812115]  [<c035ab0e>] tcp_write_timer+0x0/0x6a2
[193949.812194]  [<c035ab0e>] tcp_write_timer+0x0/0x6a2
[193949.812274]  [<c011f422>] __do_softirq+0x72/0xdf
[193949.812353]  [<c011f4c6>] do_softirq+0x37/0x39
[193949.812429]  [<c010f4d9>] smp_apic_timer_interrupt+0x5a/0x85
[193949.812522]  [<c0101542>] default_idle+0x0/0x3e
[193949.812601]  [<c0103214>] apic_timer_interrupt+0x28/0x30
[193949.812686]  [<c0101542>] default_idle+0x0/0x3e
[193949.812766]  [<c0101571>] default_idle+0x2f/0x3e
[193949.812845]  [<c0100de4>] cpu_idle+0x74/0x8d
[193949.812920]  [<c0486c1f>] start_kernel+0x2b7/0x2f8
[193949.813006]  [<c04863b9>] unknown_bootoption+0x0/0x1e6
[193949.813093]  =======================
[194131.982048] WARNING: at net/ipv4/tcp_output.c:1799 
tcp_simple_retransmit()
[194131.982094] Pid: 0, comm: swapper Not tainted 2.6.24.2 #3
[194131.982125]  [<c0359f20>] tcp_simple_retransmit+0x1ed/0x1f2
[194131.982164]  [<c035ddd3>] tcp_v4_err+0x4f3/0x575
[194131.982194]  [<c034239f>] ip_rt_frag_needed+0x60/0x216
[194131.982229]  [<c03414ef>] ip_route_input+0x34a/0xb8e
[194131.982260]  [<c0365d9f>] icmp_unreach+0x12f/0x3b0
[194131.982291]  [<c03281c5>] skb_checksum+0x51/0x2e7
[194131.982322]  [<c033e4b6>] nf_iterate+0x66/0x8a
[194131.982357]  [<c032ae59>] __skb_checksum_complete_head+0x18/0x5b
[194131.982388]  [<c0365502>] icmp_rcv+0x10f/0x146
[194131.982418]  [<c034375c>] ip_local_deliver_finish+0x95/0x17b
[194131.982450]  [<c034350b>] ip_rcv_finish+0xbb/0x277
[194131.982480]  [<c032dcc7>] netif_receive_skb+0x171/0x1f6
[194131.982512]  [<c03301f1>] process_backlog+0x63/0xc4
[194131.982542]  [<c032fc80>] net_rx_action+0x79/0x13a
[194131.982572]  [<c0129734>] __rcu_process_callbacks+0xfc/0x1b5
[194131.982609]  [<c011f422>] __do_softirq+0x72/0xdf
[194131.982640]  [<c011f4c6>] do_softirq+0x37/0x39
[194131.982670]  [<c0104f29>] do_IRQ+0x40/0x77
[194131.982700]  [<c010f4d9>] smp_apic_timer_interrupt+0x5a/0x85
[194131.982733]  [<c0101542>] default_idle+0x0/0x3e
[194131.982763]  [<c0103157>] common_interrupt+0x23/0x28
[194131.982793]  [<c0101542>] default_idle+0x0/0x3e
[194131.982824]  [<c0101571>] default_idle+0x2f/0x3e
[194131.982854]  [<c0100de4>] cpu_idle+0x74/0x8d
[194131.982884]  =======================
[194132.263479] WARNING: at net/ipv4/tcp_input.c:1675 tcp_enter_frto()
[194132.263555] Pid: 3272, comm: qpsmtpd-prefork Not tainted 2.6.24.2 #3
[194132.263617]  [<c0355813>] tcp_enter_frto+0x25e/0x269
[194132.263697]  [<c035ade3>] tcp_write_timer+0x2d5/0x6a2
[194132.263749]  [<c0132bd3>] clockevents_program_event+0x90/0x103
[194132.263811]  [<c012e789>] ktime_get_ts+0x11/0x3a
[194132.263863]  [<c012260a>] run_timer_softirq+0x146/0x1a6
[194132.263922]  [<c035ab0e>] tcp_write_timer+0x0/0x6a2
[194132.263993]  [<c035ab0e>] tcp_write_timer+0x0/0x6a2
[194132.264098]  [<c011f422>] __do_softirq+0x72/0xdf
[194132.264215]  [<c011f4c6>] do_softirq+0x37/0x39
[194132.264333]  [<c010f4d9>] smp_apic_timer_interrupt+0x5a/0x85
[194132.264412]  [<c0103214>] apic_timer_interrupt+0x28/0x30
[194132.264478]  [<c0390000>] qword_get+0x14d/0x27c
[194132.264543]  =======================
[203135.223452] WARNING: at net/ipv4/tcp_output.c:1799 
tcp_simple_retransmit()
[203135.223488] Pid: 16690, comm: qpsmtpd-prefork Not tainted 2.6.24.2 #3
[203135.223513]  [<c0359f20>] tcp_simple_retransmit+0x1ed/0x1f2
[203135.223542]  [<c035ddd3>] tcp_v4_err+0x4f3/0x575
[203135.223564]  [<c034239f>] ip_rt_frag_needed+0x60/0x216
[203135.223588]  [<c03414ef>] ip_route_input+0x34a/0xb8e
[203135.223612]  [<c0365d9f>] icmp_unreach+0x12f/0x3b0
[203135.223633]  [<c03281c5>] skb_checksum+0x51/0x2e7
[203135.223657]  [<c033e4b6>] nf_iterate+0x66/0x8a
[203135.223681]  [<c032ae59>] __skb_checksum_complete_head+0x18/0x5b
[203135.223705]  [<c0365502>] icmp_rcv+0x10f/0x146
[203135.223726]  [<c034375c>] ip_local_deliver_finish+0x95/0x17b
[203135.223750]  [<c034350b>] ip_rcv_finish+0xbb/0x277
[203135.223771]  [<c032dcc7>] netif_receive_skb+0x171/0x1f6
[203135.225137]  [<c03301f1>] process_backlog+0x63/0xc4
[203135.225162]  [<c032fc80>] net_rx_action+0x79/0x13a
[203135.225184]  [<c011f422>] __do_softirq+0x72/0xdf
[203135.225208]  [<c011f4c6>] do_softirq+0x37/0x39
[203135.225229]  [<c0104f29>] do_IRQ+0x40/0x77
[203135.225250]  [<c015b1aa>] sys_write+0x41/0x6a
[203135.225274]  [<c0103157>] common_interrupt+0x23/0x28
[203135.225297]  [<c0390000>] qword_get+0x14d/0x27c
[203135.225321]  =======================
[203135.417803] WARNING: at net/ipv4/tcp_input.c:1675 tcp_enter_frto()
[203135.417840] Pid: 0, comm: swapper Not tainted 2.6.24.2 #3
[203135.417866]  [<c0355813>] tcp_enter_frto+0x25e/0x269
[203135.417900]  [<c035ade3>] tcp_write_timer+0x2d5/0x6a2
[203135.417926]  [<c0132bd3>] clockevents_program_event+0x90/0x103
[203135.417955]  [<c012e789>] ktime_get_ts+0x11/0x3a
[203135.417979]  [<c012260a>] run_timer_softirq+0x146/0x1a6
[203135.418003]  [<c035ab0e>] tcp_write_timer+0x0/0x6a2
[203135.418025]  [<c035ab0e>] tcp_write_timer+0x0/0x6a2
[203135.418048]  [<c011f422>] __do_softirq+0x72/0xdf
[203135.418072]  [<c011f4c6>] do_softirq+0x37/0x39
[203135.418097]  [<c010f4d9>] smp_apic_timer_interrupt+0x5a/0x85
[203135.418129]  [<c0101542>] default_idle+0x0/0x3e
[203135.418152]  [<c0103214>] apic_timer_interrupt+0x28/0x30
[203135.418175]  [<c0101542>] default_idle+0x0/0x3e
[203135.418197]  [<c0101571>] default_idle+0x2f/0x3e
[203135.418220]  [<c0100de4>] cpu_idle+0x74/0x8d
[203135.418240]  [<c0486c1f>] start_kernel+0x2b7/0x2f8
[203135.418266]  [<c04863b9>] unknown_bootoption+0x0/0x1e6
[203135.418289]  =======================
[207844.523726] WARNING: at net/ipv4/tcp_output.c:1799 
tcp_simple_retransmit()
[207844.523935] Pid: 27310, comm: httpd Not tainted 2.6.24.2 #3
[207844.524089]  [<c0359f20>] tcp_simple_retransmit+0x1ed/0x1f2
[207844.524349]  [<c035ddd3>] tcp_v4_err+0x4f3/0x575
[207844.524511]  [<c034239f>] ip_rt_frag_needed+0x60/0x216
[207844.524687]  [<c03414ef>] ip_route_input+0x34a/0xb8e
[207844.524862]  [<c0365d9f>] icmp_unreach+0x12f/0x3b0
[207844.525029]  [<c03281c5>] skb_checksum+0x51/0x2e7
[207844.525207]  [<c033e4b6>] nf_iterate+0x66/0x8a
[207844.525370]  [<c032ae59>] __skb_checksum_complete_head+0x18/0x5b
[207844.525552]  [<c0365502>] icmp_rcv+0x10f/0x146
[207844.525698]  [<c034375c>] ip_local_deliver_finish+0x95/0x17b
[207844.525872]  [<c034350b>] ip_rcv_finish+0xbb/0x277
[207844.526005]  [<c032dcc7>] netif_receive_skb+0x171/0x1f6
[207844.526139]  [<c03301f1>] process_backlog+0x63/0xc4
[207844.526271]  [<c032fc80>] net_rx_action+0x79/0x13a
[207844.526405]  [<c011f422>] __do_softirq+0x72/0xdf
[207844.526538]  [<c011f4c6>] do_softirq+0x37/0x39
[207844.526669]  [<c0104f29>] do_IRQ+0x40/0x77
[207844.526796]  [<c011464f>] update_curr+0x64/0xe8
[207844.526926]  [<c0103157>] common_interrupt+0x23/0x28
[207844.527055]  [<c0117397>] finish_task_switch+0x1c/0x4e
[207844.527194]  [<c0392fb2>] schedule+0x1d0/0x671
[207844.527331]  [<c032ffd0>] net_tx_action+0x43/0xe0
[207844.527469]  [<c01227b1>] process_timeout+0x0/0x5
[207844.527600]  [<c0122a33>] __mod_timer+0x9b/0xaa
[207844.527724]  [<c0393568>] schedule_timeout+0x44/0xa1
[207844.527845]  [<c012b98c>] add_wait_queue+0xf/0x33
[207844.527969]  [<c01227b1>] process_timeout+0x0/0x5
[207844.528091]  [<c0393563>] schedule_timeout+0x3f/0xa1
[207844.528278]  [<c0165567>] do_sys_poll+0x23e/0x30e
[207844.528409]  [<c0166107>] __pollwait+0x0/0xcf
[207844.528534]  [<c0115d90>] default_wake_function+0x0/0x8
[207844.528670]  [<c0345c38>] ip_cork_release+0x19/0x79
[207844.528801]  [<c0345f3f>] ip_push_pending_frames+0x2a7/0x3bd
[207844.528932]  [<c0345ad0>] dst_output+0x0/0x7
[207844.529041]  [<c01146cc>] update_curr+0xe1/0xe8
[207844.529172]  [<c0114d72>] enqueue_entity+0x20/0x40
[207844.529297]  [<c0114da6>] enqueue_task_fair+0x14/0x29
[207844.529428]  [<c0114b79>] resched_task+0x51/0x57
[207844.529556]  [<c0115b5a>] try_to_wake_up+0x42/0x278
[207844.529694]  [<c01141f6>] __wake_up_common+0x46/0x68
[207844.529822]  [<c0115f6f>] __wake_up+0x32/0x42
[207844.529949]  [<c0327420>] sock_def_readable+0x66/0x68
[207844.530094]  [<c0328a7e>] skb_dequeue+0x45/0x4b
[207844.530218]  [<c037c921>] unix_stream_recvmsg+0x254/0x514
[207844.530366]  [<c012b7e1>] autoremove_wake_function+0x15/0x37
[207844.530505]  [<c0323416>] sock_aio_read+0xd2/0xeb
[207844.530642]  [<c015a314>] do_sync_readv_writev+0xcb/0x107
[207844.530789]  [<c015a530>] do_sync_read+0xd2/0x10e
[207844.530929]  [<c012b7cc>] autoremove_wake_function+0x0/0x37
[207844.531073]  [<c015ad93>] vfs_read+0x110/0x117
[207844.531191]  [<c01660c7>] sys_poll+0x30/0x70
[207844.531317]  [<c01027ae>] syscall_call+0x7/0xb
[207844.531438]  [<c0390000>] qword_get+0x14d/0x27c
[207844.531568]  =======================
[207844.761051] WARNING: at net/ipv4/tcp_input.c:1675 tcp_enter_frto()
[207844.761083] Pid: 0, comm: swapper Not tainted 2.6.24.2 #3
[207844.761104]  [<c0355813>] tcp_enter_frto+0x25e/0x269
[207844.761132]  [<c035ade3>] tcp_write_timer+0x2d5/0x6a2
[207844.761156]  [<c0132bd3>] clockevents_program_event+0x90/0x103
[207844.761183]  [<c012e789>] ktime_get_ts+0x11/0x3a
[207844.761205]  [<c012260a>] run_timer_softirq+0x146/0x1a6
[207844.761228]  [<c035ab0e>] tcp_write_timer+0x0/0x6a2
[207844.761250]  [<c035ab0e>] tcp_write_timer+0x0/0x6a2
[207844.761271]  [<c011f422>] __do_softirq+0x72/0xdf
[207844.761292]  [<c011f4c6>] do_softirq+0x37/0x39
[207844.761314]  [<c010f4d9>] smp_apic_timer_interrupt+0x5a/0x85
[207844.761339]  [<c0101542>] default_idle+0x0/0x3e
[207844.761361]  [<c0101542>] default_idle+0x0/0x3e
[207844.761381]  [<c0103214>] apic_timer_interrupt+0x28/0x30
[207844.761404]  [<c0101542>] default_idle+0x0/0x3e
[207844.761426]  [<c0101571>] default_idle+0x2f/0x3e
[207844.761447]  [<c0100de4>] cpu_idle+0x74/0x8d
[207844.761470]  =======================
[208181.096909] WARNING: at net/ipv4/tcp_output.c:1799 
tcp_simple_retransmit()
[208181.096947] Pid: 0, comm: swapper Not tainted 2.6.24.2 #3
[208181.096973]  [<c0359f20>] tcp_simple_retransmit+0x1ed/0x1f2
[208181.097005]  [<c035ddd3>] tcp_v4_err+0x4f3/0x575
[208181.097027]  [<c034239f>] ip_rt_frag_needed+0x60/0x216
[208181.097052]  [<c03411de>] ip_route_input+0x39/0xb8e
[208181.097079]  [<c0365d9f>] icmp_unreach+0x12f/0x3b0
[208181.097104]  [<c03281c5>] skb_checksum+0x51/0x2e7
[208181.097133]  [<c033e4b6>] nf_iterate+0x66/0x8a
[208181.097165]  [<c032ae59>] __skb_checksum_complete_head+0x18/0x5b
[208181.097191]  [<c0365502>] icmp_rcv+0x10f/0x146
[208181.097218]  [<c034375c>] ip_local_deliver_finish+0x95/0x17b
[208181.097243]  [<c034350b>] ip_rcv_finish+0xbb/0x277
[208181.097265]  [<c032dcc7>] netif_receive_skb+0x171/0x1f6
[208181.097289]  [<c03301f1>] process_backlog+0x63/0xc4
[208181.097313]  [<c032fc80>] net_rx_action+0x79/0x13a
[208181.097339]  [<c0129734>] __rcu_process_callbacks+0xfc/0x1b5
[208181.097370]  [<c011f422>] __do_softirq+0x72/0xdf
[208181.097394]  [<c011f4c6>] do_softirq+0x37/0x39
[208181.097416]  [<c0104f29>] do_IRQ+0x40/0x77
[208181.097440]  [<c010f4d9>] smp_apic_timer_interrupt+0x5a/0x85
[208181.097466]  [<c0101542>] default_idle+0x0/0x3e
[208181.097490]  [<c0103157>] common_interrupt+0x23/0x28
[208181.097515]  [<c0101542>] default_idle+0x0/0x3e
[208181.097538]  [<c0101571>] default_idle+0x2f/0x3e
[208181.097565]  [<c0100de4>] cpu_idle+0x74/0x8d
[208181.097588]  [<c0486c1f>] start_kernel+0x2b7/0x2f8
[208181.097614]  [<c04863b9>] unknown_bootoption+0x0/0x1e6
[208181.097639]  =======================
[208181.371585] WARNING: at net/ipv4/tcp_input.c:1675 tcp_enter_frto()
[208181.371653] Pid: 0, comm: swapper Not tainted 2.6.24.2 #3
[208181.371702]  [<c0355813>] tcp_enter_frto+0x25e/0x269
[208181.371770]  [<c035ade3>] tcp_write_timer+0x2d5/0x6a2
[208181.371817]  [<c0132bd3>] clockevents_program_event+0x90/0x103
[208181.371876]  [<c012e789>] ktime_get_ts+0x11/0x3a
[208181.371922]  [<c012260a>] run_timer_softirq+0x146/0x1a6
[208181.371972]  [<c035ab0e>] tcp_write_timer+0x0/0x6a2
[208181.372018]  [<c035ab0e>] tcp_write_timer+0x0/0x6a2
[208181.372065]  [<c011f422>] __do_softirq+0x72/0xdf
[208181.372114]  [<c011f4c6>] do_softirq+0x37/0x39
[208181.372159]  [<c010f4d9>] smp_apic_timer_interrupt+0x5a/0x85
[208181.372213]  [<c0101542>] default_idle+0x0/0x3e
[208181.372261]  [<c0103214>] apic_timer_interrupt+0x28/0x30
[208181.372310]  [<c0101542>] default_idle+0x0/0x3e
[208181.372357]  [<c0101571>] default_idle+0x2f/0x3e
[208181.372406]  [<c0100de4>] cpu_idle+0x74/0x8d
[208181.372454]  [<c0486c1f>] start_kernel+0x2b7/0x2f8
[208181.372509]  [<c04863b9>] unknown_bootoption+0x0/0x1e6
[208181.372556]  =======================
[220929.300388] WARNING: at net/ipv4/tcp_output.c:1799 
tcp_simple_retransmit()
[220929.300433] Pid: 12988, comm: qpsmtpd-prefork Not tainted 2.6.24.2 #3
[220929.300467]  [<c0359f20>] tcp_simple_retransmit+0x1ed/0x1f2
[220929.300514]  [<c035ddd3>] tcp_v4_err+0x4f3/0x575
[220929.300546]  [<c034239f>] ip_rt_frag_needed+0x60/0x216
[220929.300579]  [<c03411de>] ip_route_input+0x39/0xb8e
[220929.300605]  [<c0365d9f>] icmp_unreach+0x12f/0x3b0
[220929.300634]  [<c03281c5>] skb_checksum+0x51/0x2e7
[220929.300667]  [<c033e4b6>] nf_iterate+0x66/0x8a
[220929.300696]  [<c032ae59>] __skb_checksum_complete_head+0x18/0x5b
[220929.300726]  [<c0365502>] icmp_rcv+0x10f/0x146
[220929.300760]  [<c034375c>] ip_local_deliver_finish+0x95/0x17b
[220929.300790]  [<c034350b>] ip_rcv_finish+0xbb/0x277
[220929.300824]  [<c032dcc7>] netif_receive_skb+0x171/0x1f6
[220929.300858]  [<c03301f1>] process_backlog+0x63/0xc4
[220929.300885]  [<c032fc80>] net_rx_action+0x79/0x13a
[220929.300911]  [<c011f422>] __do_softirq+0x72/0xdf
[220929.300942]  [<c011f4c6>] do_softirq+0x37/0x39
[220929.300967]  [<c0104f29>] do_IRQ+0x40/0x77
[220929.301003]  [<c011f166>] sys_gettimeofday+0x22/0x58
[220929.301035]  [<c0103157>] common_interrupt+0x23/0x28
[220929.301062]  =======================
[220929.512936] WARNING: at net/ipv4/tcp_input.c:1675 tcp_enter_frto()
[220929.512971] Pid: 0, comm: swapper Not tainted 2.6.24.2 #3
[220929.512994]  [<c0355813>] tcp_enter_frto+0x25e/0x269
[220929.513023]  [<c035ade3>] tcp_write_timer+0x2d5/0x6a2
[220929.513047]  [<c0132bd3>] clockevents_program_event+0x90/0x103
[220929.514422]  [<c012e789>] ktime_get_ts+0x11/0x3a
[220929.514445]  [<c012260a>] run_timer_softirq+0x146/0x1a6
[220929.514469]  [<c035ab0e>] tcp_write_timer+0x0/0x6a2
[220929.514491]  [<c035ab0e>] tcp_write_timer+0x0/0x6a2
[220929.514513]  [<c011f422>] __do_softirq+0x72/0xdf
[220929.514536]  [<c011f4c6>] do_softirq+0x37/0x39
[220929.514557]  [<c010f4d9>] smp_apic_timer_interrupt+0x5a/0x85
[220929.514584]  [<c0101542>] default_idle+0x0/0x3e
[220929.514607]  [<c0103214>] apic_timer_interrupt+0x28/0x30
[220929.514631]  [<c0101542>] default_idle+0x0/0x3e
[220929.514653]  [<c0101571>] default_idle+0x2f/0x3e
[220929.514674]  [<c0100de4>] cpu_idle+0x74/0x8d
[220929.514697]  =======================
[231069.737285] WARNING: at net/ipv4/tcp_output.c:1799 
tcp_simple_retransmit()
[231069.737478] Pid: 31798, comm: php4 Not tainted 2.6.24.2 #3
[231069.737604]  [<c0359f20>] tcp_simple_retransmit+0x1ed/0x1f2
[231069.737762]  [<c035ddd3>] tcp_v4_err+0x4f3/0x575
[231069.737880]  [<c034239f>] ip_rt_frag_needed+0x60/0x216
[231069.738009]  [<c03411de>] ip_route_input+0x39/0xb8e
[231069.738142]  [<c0365d9f>] icmp_unreach+0x12f/0x3b0
[231069.738283]  [<c03281c5>] skb_checksum+0x51/0x2e7
[231069.738437]  [<c033e4b6>] nf_iterate+0x66/0x8a
[231069.738589]  [<c032ae59>] __skb_checksum_complete_head+0x18/0x5b
[231069.738764]  [<c0365502>] icmp_rcv+0x10f/0x146
[231069.738987]  [<c034375c>] ip_local_deliver_finish+0x95/0x17b
[231069.739127]  [<c034350b>] ip_rcv_finish+0xbb/0x277
[231069.739262]  [<c032dcc7>] netif_receive_skb+0x171/0x1f6
[231069.739401]  [<c03301f1>] process_backlog+0x63/0xc4
[231069.739544]  [<c032fc80>] net_rx_action+0x79/0x13a
[231069.739668]  [<c011f422>] __do_softirq+0x72/0xdf
[231069.739792]  [<c011f4c6>] do_softirq+0x37/0x39
[231069.739939]  [<c0104f29>] do_IRQ+0x40/0x77
[231069.740082]  [<c0103157>] common_interrupt+0x23/0x28
[231069.740217]  =======================
[231069.934813] WARNING: at net/ipv4/tcp_input.c:1675 tcp_enter_frto()
[231069.934972] Pid: 31444, comm: php4 Not tainted 2.6.24.2 #3
[231069.935103]  [<c0355813>] tcp_enter_frto+0x25e/0x269
[231069.935271]  [<c035ade3>] tcp_write_timer+0x2d5/0x6a2
[231069.935414]  [<c0128579>] insert_work+0x4c/0x6d
[231069.935552]  [<c012260a>] run_timer_softirq+0x146/0x1a6
[231069.935695]  [<c035ab0e>] tcp_write_timer+0x0/0x6a2
[231069.935833]  [<c035ab0e>] tcp_write_timer+0x0/0x6a2
[231069.935961]  [<c011f422>] __do_softirq+0x72/0xdf
[231069.936088]  [<c011f4c6>] do_softirq+0x37/0x39
[231069.936211]  [<c010f4d9>] smp_apic_timer_interrupt+0x5a/0x85
[231069.936367]  [<c0103214>] apic_timer_interrupt+0x28/0x30
[231069.936511]  =======================
[236145.193328] XFS mounting filesystem sdb6
[236145.270678] Ending clean XFS mount for filesystem: sdb6
[236145.344594] EXT2-fs warning: mounting unchecked fs, running e2fsck 
is recommended
[257285.404503] BUG: unable to handle kernel paging request at virtual 
address f8000008
[257285.404684] printing eip: c023ff03 *pde = 00000000
[257285.404795] Oops: 0000 [#1] SMP
[257285.404883] Modules linked in: ipt_REJECT xt_tcpudp iptable_filter 
ip_tables x_tables
[257285.405072]
[257285.405128] Pid: 19654, comm: qmail-pop3d Not tainted (2.6.24.2 #3)
[257285.405222] EIP: 0060:[<c023ff03>] EFLAGS: 00010296 CPU: 0
[257285.405336] EIP is at xfs_file_readdir+0x147/0x1c0
[257285.405418] EAX: 00000000 EBX: 00000196 ECX: 00000038 EDX: 00000000
[257285.405543] ESI: 00000000 EDI: f8000000 EBP: 00000000 ESP: e783df1c
[257285.405672]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[257285.405799] Process qmail-pop3d (pid: 19654, ti=e783c000 
task=eb6ba030 task.ti=e783c000)
[257285.405931] Stack: 00000196 00000000 0542eec5 00000000 00000000 
c0164e28 e783df94 f7480c40
[257285.406239]        f1a05c80 00000000 00000000 00000196 00000000 
f7fff000 00001000 00001000
[257285.406504]        0000019b 00000000 c03a5ce0 f7480c40 c4bbd680 
c0164e28 c016501d e783df94
[257285.406764] Call Trace:
[257285.406867]  [<c0164e28>] filldir64+0x0/0xc5
[257285.407015]  [<c0164e28>] filldir64+0x0/0xc5
[257285.407131]  [<c016501d>] vfs_readdir+0x6b/0x80
[257285.407255]  [<c0165095>] sys_getdents64+0x63/0xa5
[257285.407383]  [<c01027ae>] syscall_call+0x7/0xb
[257285.407514]  =======================
[257285.407589] Code: 7f 31 f6 89 1c 24 89 74 24 04 8b 44 24 18 ff 54 24 
14 85 c0 75 71 8b 4f 10 83 c1 1f 83 e1 f8 31 d2 29 4c 24 24 19 54 24 28 
01 cf <8b> 57 08 8b 4f 0c 89 54 24 2c 89 4c 24 30 83 7c 24 28 00 7f 9d
[257285.408615] EIP: [<c023ff03>] xfs_file_readdir+0x147/0x1c0 SS:ESP 
0068:e783df1c
[257285.409836] ---[ end trace 40c142678371c15e ]---
[266127.314855] WARNING: at net/ipv4/tcp_output.c:1799 
tcp_simple_retransmit()
[266127.314968] Pid: 5636, comm: httpd Tainted: G      D 2.6.24.2 #3
[266127.315053]  [<c0359f20>] tcp_simple_retransmit+0x1ed/0x1f2
[266127.315161]  [<c035ddd3>] tcp_v4_err+0x4f3/0x575
[266127.315241]  [<c034239f>] ip_rt_frag_needed+0x60/0x216
[266127.315327]  [<c03414ef>] ip_route_input+0x34a/0xb8e
[266127.315455]  [<c0365d9f>] icmp_unreach+0x12f/0x3b0
[266127.315552]  [<c03281c5>] skb_checksum+0x51/0x2e7
[266127.315642]  [<c033e4b6>] nf_iterate+0x66/0x8a
[266127.315732]  [<c032ae59>] __skb_checksum_complete_head+0x18/0x5b
[266127.315818]  [<c0365502>] icmp_rcv+0x10f/0x146
[266127.315898]  [<c034375c>] ip_local_deliver_finish+0x95/0x17b
[266127.315987]  [<c034350b>] ip_rcv_finish+0xbb/0x277
[266127.316073]  [<c02b2d3c>] speedo_tx_buffer_gc+0x82/0x1ab
[266127.316167]  [<c032dcc7>] netif_receive_skb+0x171/0x1f6
[266127.316253]  [<c03301f1>] process_backlog+0x63/0xc4
[266127.316341]  [<c032fc80>] net_rx_action+0x79/0x13a
[266127.316426]  [<c011f422>] __do_softirq+0x72/0xdf
[266127.316518]  [<c011f4c6>] do_softirq+0x37/0x39
[266127.316607]  [<c0104f29>] do_IRQ+0x40/0x77
[266127.316671]  [<c0103157>] common_interrupt+0x23/0x28
[266127.316749]  [<c032007b>] hidinput_find_field+0x3e/0xaf
[266127.316819]  [<c01600d8>] pipe_write+0x348/0x460
[266127.316883]  [<c016d15f>] __lookup_mnt+0x3f/0x58
[266127.316961]  [<c016ec10>] lookup_mnt+0x1e/0x30
[266127.317021]  [<c0160c74>] __follow_mount+0x59/0x69
[266127.317099]  [<c0160dab>] do_lookup+0x59/0x167
[266127.317173]  [<c016212b>] __link_path_walk+0x11e/0xc2d
[266127.317257]  [<c0103157>] common_interrupt+0x23/0x28
[266127.317320]  [<c016007b>] pipe_write+0x2eb/0x460
[266127.317384]  [<c0162c7f>] link_path_walk+0x45/0xbc
[266127.317450]  [<c0158ed6>] get_unused_fd_flags+0x52/0xc7
[266127.317517]  [<c0162eee>] do_path_lookup+0x73/0x1a1
[266127.317580]  [<c015b57f>] get_empty_filp+0x51/0x107
[266127.317647]  [<c016396f>] __path_lookup_intent_open+0x45/0x80
[266127.317715]  [<c0163a1e>] path_lookup_open+0x20/0x25
[266127.317778]  [<c0163af3>] open_namei+0x66/0x5a9
[266127.317839]  [<c0159179>] do_filp_open+0x25/0x40
[266127.317902]  [<c0158ed6>] get_unused_fd_flags+0x52/0xc7
[266127.317969]  [<c01591d4>] do_sys_open+0x40/0xc9
[266127.318029]  [<c0159298>] sys_open+0x1c/0x20
[266127.318086]  [<c01027ae>] syscall_call+0x7/0xb
[266127.318146]  [<c0390000>] qword_get+0x14d/0x27c
[266127.318214]  =======================
[266127.511394] WARNING: at net/ipv4/tcp_input.c:1675 tcp_enter_frto()
[266127.511491] Pid: 7210, comm: httpd Tainted: G      D 2.6.24.2 #3
[266127.511558]  [<c0355813>] tcp_enter_frto+0x25e/0x269
[266127.511649]  [<c035ade3>] tcp_write_timer+0x2d5/0x6a2
[266127.511713]  [<c0132bd3>] clockevents_program_event+0x90/0x103
[266127.511791]  [<c012e789>] ktime_get_ts+0x11/0x3a
[266127.511867]  [<c012260a>] run_timer_softirq+0x146/0x1a6
[266127.511942]  [<c035ab0e>] tcp_write_timer+0x0/0x6a2
[266127.512008]  [<c035ab0e>] tcp_write_timer+0x0/0x6a2
[266127.512071]  [<c011f422>] __do_softirq+0x72/0xdf
[266127.512132]  [<c011f4c6>] do_softirq+0x37/0x39
[266127.512189]  [<c010f4d9>] smp_apic_timer_interrupt+0x5a/0x85
[266127.512265]  [<c0103214>] apic_timer_interrupt+0x28/0x30
[266127.512333]  [<c0390000>] qword_get+0x14d/0x27c
[266127.512403]  =======================
[267457.106175] WARNING: at net/ipv4/tcp_output.c:1799 
tcp_simple_retransmit()
[267457.106238] Pid: 0, comm: swapper Tainted: G      D 2.6.24.2 #3
[267457.106288]  [<c0359f20>] tcp_simple_retransmit+0x1ed/0x1f2
[267457.106353]  [<c035ddd3>] tcp_v4_err+0x4f3/0x575
[267457.106396]  [<c034239f>] ip_rt_frag_needed+0x60/0x216
[267457.106445]  [<c03414ef>] ip_route_input+0x34a/0xb8e
[267457.106492]  [<c0365d9f>] icmp_unreach+0x12f/0x3b0
[267457.106541]  [<c03281c5>] skb_checksum+0x51/0x2e7
[267457.106591]  [<c033e4b6>] nf_iterate+0x66/0x8a
[267457.106641]  [<c032ae59>] __skb_checksum_complete_head+0x18/0x5b
[267457.106691]  [<c0365502>] icmp_rcv+0x10f/0x146
[267457.106736]  [<c034375c>] ip_local_deliver_finish+0x95/0x17b
[267457.106785]  [<c034350b>] ip_rcv_finish+0xbb/0x277
[267457.106831]  [<c032dcc7>] netif_receive_skb+0x171/0x1f6
[267457.106881]  [<c03301f1>] process_backlog+0x63/0xc4
[267457.106927]  [<c032fc80>] net_rx_action+0x79/0x13a
[267457.106972]  [<c012969e>] __rcu_process_callbacks+0x66/0x1b5
[267457.107030]  [<c011f422>] __do_softirq+0x72/0xdf
[267457.107076]  [<c011f4c6>] do_softirq+0x37/0x39
[267457.107121]  [<c0104f29>] do_IRQ+0x40/0x77
[267457.107167]  [<c010f4d9>] smp_apic_timer_interrupt+0x5a/0x85
[267457.107221]  [<c0101542>] default_idle+0x0/0x3e
[267457.107266]  [<c0103157>] common_interrupt+0x23/0x28
[267457.107311]  [<c0101542>] default_idle+0x0/0x3e
[267457.107354]  [<c0101571>] default_idle+0x2f/0x3e
[267457.107399]  [<c0100de4>] cpu_idle+0x74/0x8d
[267457.107449]  =======================
[267457.304481] WARNING: at net/ipv4/tcp_input.c:1675 tcp_enter_frto()
[267457.304574] Pid: 17277, comm: pop3passwdcheck Tainted: G      D 
2.6.24.2 #3
[267457.304649]  [<c0355813>] tcp_enter_frto+0x25e/0x269
[267457.304741]  [<c035ade3>] tcp_write_timer+0x2d5/0x6a2
[267457.304824]  [<c0132bd3>] clockevents_program_event+0x90/0x103
[267457.304932]  [<c012e789>] ktime_get_ts+0x11/0x3a
[267457.305002]  [<c012260a>] run_timer_softirq+0x146/0x1a6
[267457.305074]  [<c035ab0e>] tcp_write_timer+0x0/0x6a2
[267457.307724]  [<c035ab0e>] tcp_write_timer+0x0/0x6a2
[267457.307812]  [<c011f422>] __do_softirq+0x72/0xdf
[267457.307874]  [<c011f4c6>] do_softirq+0x37/0x39
[267457.307932]  [<c010f4d9>] smp_apic_timer_interrupt+0x5a/0x85
[267457.308015]  [<c0103214>] apic_timer_interrupt+0x28/0x30
[267457.308083]  [<c0390000>] qword_get+0x14d/0x27c
[267457.308161]  =======================

-- 
Regards,
   Stefan Priebe

