Return-Path: <linux-kernel-owner+w=401wt.eu-S1756850AbYDCFLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850AbYDCFLP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 01:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbYDCFLC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 01:11:02 -0400
Received: from nn7.de ([85.214.94.156]:40416 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762AbYDCFLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 01:11:00 -0400
Subject: 2.6.25-rc8: WARNING: at net/ipv4/tcp_input.c:2173
	tcp_mark_head_lost+0x11d/0x150()
From: Soeren Sonnenburg <kernel@nn7.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 03 Apr 2008 07:10:56 +0200
Message-Id: <1207199456.7616.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

trying to download things, I am seeing this (ignore the tainted, it is
from madwifi and although the module is loaded the device was never
used)

Could anyone make sense of this please?

Thanks,
Soeren

------------[ cut here ]------------
WARNING: at net/ipv4/tcp_input.c:2173 tcp_mark_head_lost+0x11d/0x150()
Modules linked in: vfat fat isofs udf usb_storage coretemp rfcomm l2cap
hci_usb bluetooth xfrm_user xfrm4_tunnel tunnel4 ipcomp esp4 ah4 hfsplus
binfmt_misc fuse ebtable_broute bridge llc ebtable_nat ebt
Pid: 0, comm: swapper Tainted: P         2.6.25-rc8-sonne #24
 [<c012a654>] warn_on_slowpath+0x54/0x70
 [<c0374d05>] ? ip_output+0x75/0xd0
 [<c0373b78>] ? ip_local_out+0x18/0x20
 [<c0374f34>] ? ip_queue_xmit+0x1d4/0x3a0
 [<c011f4b7>] ? enqueue_task_fair+0x37/0x2a0
 [<c034fd62>] ? __skb_clone+0x22/0xd0
 [<c037e32d>] tcp_mark_head_lost+0x11d/0x150
 [<c0385460>] ? tcp_transmit_skb+0x410/0x7b0
 [<c0380d4b>] tcp_ack+0x171b/0x1d60
 [<c0171efa>] ? dma_pool_alloc+0xfa/0x1a0
 [<c0384434>] tcp_rcv_established+0x504/0x750
 [<c0389f93>] tcp_v4_do_rcv+0xb3/0x1f0
 [<c0377a7e>] ? __inet_lookup_established+0x17e/0x190
 [<c038b9cf>] tcp_v4_rcv+0x6bf/0x7c0
 [<c036fea9>] ip_local_deliver_finish+0xa9/0x210
 [<c03703d0>] ip_local_deliver+0x30/0xa0
 [<c036fb6f>] ip_rcv_finish+0xff/0x390
 [<c036a3a0>] ? nf_hook_slow+0xa0/0xf0
 [<c036fa70>] ? ip_rcv_finish+0x0/0x390
 [<c03702f0>] ip_rcv+0x1e0/0x290
 [<c036fa70>] ? ip_rcv_finish+0x0/0x390
 [<c0370110>] ? ip_rcv+0x0/0x290
 [<c0356bc7>] netif_receive_skb+0x247/0x2d0
 [<f88632ea>] sky2_poll+0x4ba/0xc20 [sky2]
 [<c01474a2>] ? tick_program_event+0x42/0x70
 [<c01474a2>] ? tick_program_event+0x42/0x70
 [<c03590c8>] net_rx_action+0xa8/0x130
 [<c012f7e4>] __do_softirq+0x84/0x100
 [<c012f89b>] do_softirq+0x3b/0x50
 [<c012fa15>] irq_exit+0x75/0x90
 [<c01070e5>] do_IRQ+0x45/0x80
 [<c0104c53>] common_interrupt+0x23/0x28
 [<c02a1f46>] ? acpi_idle_enter_bm+0x28a/0x2f8
 [<c033bea6>] cpuidle_idle_call+0x76/0xb0
 [<c033be30>] ? cpuidle_idle_call+0x0/0xb0
 [<c0102aef>] cpu_idle+0x6f/0x110
 [<c03e447d>] rest_init+0x5d/0x60
 =======================
---[ end trace a109db92c4e172c2 ]---
------------[ cut here ]------------


------------[ cut here ]------------
WARNING: at net/ipv4/tcp_input.c:1771 tcp_enter_frto+0x267/0x270()
Modules linked in: vfat fat isofs udf usb_storage coretemp rfcomm l2cap
hci_usb bluetooth xfrm_user xfrm4_tunnel tunnel4 ipcomp esp4 ah4 hfsplus
binfmt_misc fuse ebtable_broute bridge llc ebtable_nat ebt
Pid: 0, comm: swapper Tainted: P         2.6.25-rc8-sonne #24
 [<c012a654>] warn_on_slowpath+0x54/0x70
 [<c011e157>] ? enqueue_task+0x57/0x70
 [<c011f302>] ? __update_rq_clock+0x22/0x180
 [<c011811d>] ? read_hpet+0xd/0x20
 [<c0143194>] ? getnstimeofday+0x34/0xe0
 [<c0141338>] ? ktime_get_ts+0x48/0x50
 [<c0141359>] ? ktime_get+0x19/0x40
 [<c0383387>] tcp_enter_frto+0x267/0x270
 [<c0388ac1>] tcp_write_timer+0x301/0x690
 [<c0118829>] ? hpet_legacy_next_event+0x29/0x40
 [<c0146269>] ? clockevents_program_event+0x99/0x120
 [<c01335d5>] run_timer_softirq+0x155/0x1c0
 [<c03887c0>] ? tcp_write_timer+0x0/0x690
 [<c03f34ac>] ? _spin_unlock+0x1c/0x30
 [<c03887c0>] ? tcp_write_timer+0x0/0x690
 [<c012f7e4>] __do_softirq+0x84/0x100
 [<c012f89b>] do_softirq+0x3b/0x50
 [<c012fa15>] irq_exit+0x75/0x90
 [<c01070e5>] do_IRQ+0x45/0x80
 [<c0104c53>] common_interrupt+0x23/0x28
 [<c02a1f46>] ? acpi_idle_enter_bm+0x28a/0x2f8
 [<c033bea6>] cpuidle_idle_call+0x76/0xb0
 [<c033be30>] ? cpuidle_idle_call+0x0/0xb0
 [<c0102aef>] cpu_idle+0x6f/0x110
 [<c03e447d>] rest_init+0x5d/0x60
 =======================
---[ end trace a109db92c4e172c2 ]---
------------[ cut here ]------------


------------[ cut here ]------------
WARNING: at net/ipv4/tcp_input.c:2532 tcp_ack+0x1a6f/0x1d60()
Modules linked in: vfat fat isofs udf usb_storage coretemp rfcomm l2cap
hci_usb bluetooth xfrm_user xfrm4_tunnel tunnel4 ipcomp esp4 ah4 hfsplus
binfmt_misc fuse ebtable_broute bridge llc ebtable_nat ebt
Pid: 0, comm: swapper Tainted: P         2.6.25-rc8-sonne #24
 [<c012a654>] warn_on_slowpath+0x54/0x70
 [<c0374d05>] ? ip_output+0x75/0xd0
 [<c0373b78>] ? ip_local_out+0x18/0x20
 [<c0374f34>] ? ip_queue_xmit+0x1d4/0x3a0
 [<c034fd62>] ? __skb_clone+0x22/0xd0
 [<c0385460>] ? tcp_transmit_skb+0x410/0x7b0
 [<c038109f>] tcp_ack+0x1a6f/0x1d60
 [<c0171efa>] ? dma_pool_alloc+0xfa/0x1a0
 [<c0384434>] tcp_rcv_established+0x504/0x750
 [<c0389f93>] tcp_v4_do_rcv+0xb3/0x1f0
 [<c0377a7e>] ? __inet_lookup_established+0x17e/0x190
 [<c038b9cf>] tcp_v4_rcv+0x6bf/0x7c0
 [<c036fea9>] ip_local_deliver_finish+0xa9/0x210
 [<c03703d0>] ip_local_deliver+0x30/0xa0
 [<c036fb6f>] ip_rcv_finish+0xff/0x390
 [<c036a3a0>] ? nf_hook_slow+0xa0/0xf0
 [<c036fa70>] ? ip_rcv_finish+0x0/0x390
 [<c03702f0>] ip_rcv+0x1e0/0x290
 [<c036fa70>] ? ip_rcv_finish+0x0/0x390
 [<c0370110>] ? ip_rcv+0x0/0x290
 [<c0356bc7>] netif_receive_skb+0x247/0x2d0
 [<f88632ea>] sky2_poll+0x4ba/0xc20 [sky2]
 [<c0144acb>] ? clocksource_get_next+0x3b/0x50
 [<c01474a2>] ? tick_program_event+0x42/0x70
 [<c03590c8>] net_rx_action+0xa8/0x130
 [<c012f7e4>] __do_softirq+0x84/0x100
 [<c012f89b>] do_softirq+0x3b/0x50
 [<c012fa15>] irq_exit+0x75/0x90
 [<c01070e5>] do_IRQ+0x45/0x80
 [<c0104c53>] common_interrupt+0x23/0x28
 [<c02a1f46>] ? acpi_idle_enter_bm+0x28a/0x2f8
 [<c033bea6>] cpuidle_idle_call+0x76/0xb0
 [<c033be30>] ? cpuidle_idle_call+0x0/0xb0
 [<c0102aef>] cpu_idle+0x6f/0x110
 [<c03e447d>] rest_init+0x5d/0x60
 =======================
---[ end trace a109db92c4e172c2 ]---
------------[ cut here ]------------

