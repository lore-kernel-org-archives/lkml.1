Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932858Ab0CNUOt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 16:14:49 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:46828 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752982Ab0CNUOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 16:14:47 -0400
Date: Sun, 14 Mar 2010 21:14:34 +0100
From: Pavel Machek <pavel@ucw.cz>
To: marcel@holtmann.org, kernel list <linux-kernel@vger.kernel.org>,
       linux-bluetooth@vger.kernel.org
Subject: 2.6.34-rc1: bluetooth oops
Message-ID: <20100314201434.GE22059@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I got this after trying to use bnep for few minutes... Machine locked
after that, not sure if it is related.
									Pavel


Mar 13 15:01:38 amd kernel: Failure of coda_cnode_make for root: error -4
Mar 13 15:21:33 amd -- MARK --
Mar 13 15:41:33 amd -- MARK --
Mar 13 16:01:33 amd -- MARK --
Mar 13 16:21:33 amd -- MARK --
Mar 13 16:41:34 amd -- MARK --
Mar 13 17:01:34 amd -- MARK --
Mar 13 17:09:47 amd log1n[1781]: ROOT LOGIN on `tty8' 
Mar 13 17:09:55 amd pand[1961]: Bluetooth PAN daemon version 4.57
Mar 13 17:09:55 amd pand[1961]: Connecting to 00:21:BA:FF:2D:37
Mar 13 17:09:58 amd pand[1961]: bnep0 connected
Mar 13 17:09:59 amd pumpd[1979]: starting at (uptime 0 days, 2:08:43) Sat Mar 13 17:09:59 2010  
Mar 13 17:09:59 amd pumpd[1979]: configured interface bnep0
Mar 13 17:09:59 amd modprobe: FATAL: Could not load /lib/modules/2.6.34-rc1-00182-g3c96f03-dirty/modules.dep: No such file or directory 
Mar 13 17:11:02 amd modprobe: FATAL: Could not load /lib/modules/2.6.34-rc1-00182-g3c96f03-dirty/modules.dep: No such file or directory 
Mar 13 17:11:02 amd acpid: client connected from 2006[0:0] 
Mar 13 17:11:02 amd acpid: 1 client rule loaded 
Mar 13 17:11:08 amd ck-launch-session: error connecting to ConsoleKit
Mar 13 17:11:16 amd modprobe: FATAL: Could not load /lib/modules/2.6.34-rc1-00182-g3c96f03-dirty/modules.dep: No such file or directory 
Mar 13 17:11:16 amd last message repeated 7 times
Mar 13 17:12:59 amd modprobe: FATAL: Could not load /lib/modules/2.6.34-rc1-00182-g3c96f03-dirty/modules.dep: No such file or directory 
Mar 13 17:13:22 amd last message repeated 2 times
Mar 13 17:14:07 amd kernel: ------------[ cut here ]------------
Mar 13 17:14:07 amd kernel: WARNING: at net/sched/sch_generic.c:255 dev_watchdog+0x226/0x230()
Mar 13 17:14:07 amd kernel: Hardware name: 17097HU
Mar 13 17:14:07 amd kernel: NETDEV WATCHDOG: bnep0 (): transmit queue 0 timed out
Mar 13 17:14:07 amd kernel: Modules linked in:
Mar 13 17:14:07 amd kernel: Pid: 0, comm: swapper Tainted: G        W  2.6.34-rc1-00182-g3c96f03-dirty #109
Mar 13 17:14:07 amd kernel: Call Trace:
Mar 13 17:14:07 amd kernel:  [<c0698bb6>] ? dev_watchdog+0x226/0x230
Mar 13 17:14:07 amd kernel:  [<c0698bb6>] ? dev_watchdog+0x226/0x230
Mar 13 17:14:07 amd kernel:  [<c0234dbc>] warn_slowpath_common+0x6c/0xc0
Mar 13 17:14:07 amd kernel:  [<c0698bb6>] ? dev_watchdog+0x226/0x230
Mar 13 17:14:07 amd kernel:  [<c0234e56>] warn_slowpath_fmt+0x26/0x30
Mar 13 17:14:07 amd kernel:  [<c0698bb6>] dev_watchdog+0x226/0x230
Mar 13 17:14:07 amd kernel:  [<c023f0ec>] ? run_timer_softirq+0xfc/0x250
Mar 13 17:14:07 amd kernel:  [<c023f169>] run_timer_softirq+0x179/0x250
Mar 13 17:14:07 amd kernel:  [<c023f0ec>] ? run_timer_softirq+0xfc/0x250
Mar 13 17:14:07 amd kernel:  [<c0698990>] ? dev_watchdog+0x0/0x230
Mar 13 17:14:07 amd kernel:  [<c023a255>] __do_softirq+0x85/0x110
Mar 13 17:14:07 amd kernel:  [<c023a30d>] do_softirq+0x2d/0x40
Mar 13 17:14:07 amd kernel:  [<c023a4a5>] irq_exit+0x65/0x80
Mar 13 17:14:07 amd kernel:  [<c020468f>] do_IRQ+0x4f/0xc0
Mar 13 17:14:07 amd kernel:  [<c024fda2>] ? sched_clock_local+0xd2/0x170
Mar 13 17:14:07 amd kernel:  [<c02030e9>] common_interrupt+0x29/0x30
Mar 13 17:14:07 amd kernel:  [<c025007b>] ? sched_clock_idle_wakeup_event+0xb/0x30
Mar 13 17:14:07 amd kernel:  [<c03e01d3>] ? acpi_idle_enter_simple+0x13f/0x16a
Mar 13 17:14:07 amd kernel:  [<c03dfeb0>] acpi_idle_enter_bm+0xc3/0x2a7
Mar 13 17:14:07 amd kernel:  [<c05c160d>] cpuidle_idle_call+0x7d/0xc0
Mar 13 17:14:07 amd kernel:  [<c0201cad>] cpu_idle+0x4d/0x80
Mar 13 17:14:07 amd kernel:  [<c0785c6b>] rest_init+0xab/0xc0
Mar 13 17:14:07 amd kernel:  [<c0785bc0>] ? rest_init+0x0/0xc0
Mar 13 17:14:07 amd kernel:  [<c0aa08b5>] start_kernel+0x28d/0x2c7
Mar 13 17:14:07 amd kernel:  [<c0aa0404>] ? unknown_bootoption+0x0/0x1d3
Mar 13 17:14:07 amd kernel:  [<c0aa0089>] i386_start_kernel+0x89/0x8b
Mar 13 17:14:07 amd kernel: ---[ end trace a7919e7f17c0a727 ]---
Mar 13 17:14:12 amd modprobe: FATAL: Could not load /lib/modules/2.6.34-rc1-00182-g3c96f03-dirty/modules.dep: No such file or directory 
Mar 13 17:14:59 amd kernel: BUG: soft lockup - CPU#1 stuck for 61s! [kbnepd bnep0:1965]
Mar 13 17:14:59 amd kernel: Modules linked in:
Mar 13 17:14:59 amd kernel: Modules linked in:
Mar 13 17:14:59 amd kernel: 
Mar 13 17:14:59 amd kernel: Pid: 1965, comm: kbnepd bnep0 Tainted: G        W  2.6.34-rc1-00182-g3c96f03-dirty #109 17097HU/17097HU
Mar 13 17:14:59 amd kernel: EIP: 0060:[<c06e244d>] EFLAGS: 00010282 CPU: 1
Mar 13 17:14:59 amd kernel: EIP is at tcp_v4_rcv+0x19d/0x7d0
Mar 13 17:14:59 amd kernel: EAX: 00000036 EBX: f1232e20 ECX: c06cd093 EDX: f2891e00
Mar 13 17:14:59 amd kernel: ESI: f2f50f48 EDI: f2891e14 EBP: f0c29ddc ESP: f0c29da0
Mar 13 17:14:59 amd kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Mar 13 17:14:59 amd kernel: Process kbnepd bnep0 (pid: 1965, ti=f0c28000 task=f7361648 task.ti=f0c28000)
Mar 13 17:14:59 amd kernel: Stack:
Mar 13 17:14:59 amd kernel:  00005000 6702a8c0 0000c602 00000004 f0c29ddc f2f50f48 f2891e00 0000c602
Mar 13 17:14:59 amd kernel: <0> 00000004 6702a8c0 f1232e20 00000000 c081aab0 f2f50f48 f2891e00 f0c29dfc
Mar 13 17:14:59 amd kernel: <0> c06c5ba3 00000002 00000001 00000000 c06c5b20 f2f50f48 f2f50f48 f0c29e18
Mar 13 17:14:59 amd kernel: Call Trace:
Mar 13 17:14:59 amd kernel:  [<c06c5ba3>] ? ip_local_deliver_finish+0xb3/0x1c0
Mar 13 17:14:59 amd kernel:  [<c06c5b20>] ? ip_local_deliver_finish+0x30/0x1c0
Mar 13 17:14:59 amd kernel:  [<c06c5d3f>] ? ip_local_deliver+0x8f/0xa0
Mar 13 17:14:59 amd kernel:  [<c06c5af0>] ? ip_local_deliver_finish+0x0/0x1c0
Mar 13 17:14:59 amd kernel:  [<c06c55e3>] ? ip_rcv_finish+0xf3/0x370
Mar 13 17:14:59 amd kernel:  [<c06c54f0>] ? ip_rcv_finish+0x0/0x370
Mar 13 17:14:59 amd kernel:  [<c06c5a94>] ? ip_rcv+0x234/0x290
Mar 13 17:14:59 amd kernel:  [<c06c54f0>] ? ip_rcv_finish+0x0/0x370
Mar 13 17:14:59 amd kernel:  [<c0688a70>] ? netif_receive_skb+0x1b0/0x310
Mar 13 17:14:59 amd kernel:  [<c0688971>] ? netif_receive_skb+0xb1/0x310
Mar 13 17:14:59 amd kernel:  [<c0688c32>] ? process_backlog+0x62/0xa0
Mar 13 17:14:59 amd kernel:  [<c0688e4d>] ? net_rx_action+0x7d/0x100
Mar 13 17:14:59 amd kernel:  [<c023a255>] ? __do_softirq+0x85/0x110
Mar 13 17:14:59 amd kernel:  [<c023a30d>] ? do_softirq+0x2d/0x40
Mar 13 17:14:59 amd kernel:  [<c06895da>] ? netif_rx_ni+0x1a/0x20
Mar 13 17:14:59 amd kernel:  [<c0734c33>] ? bnep_session+0x2c3/0x820
Mar 13 17:14:59 amd kernel:  [<c07ad6ad>] ? _raw_spin_unlock_irq+0x1d/0x30
Mar 13 17:14:59 amd kernel:  [<c02305e0>] ? default_wake_function+0x0/0x10
Mar 13 17:14:59 amd kernel:  [<c0734970>] ? bnep_session+0x0/0x820
Mar 13 17:14:59 amd kernel:  [<c02030f6>] ? kernel_thread_helper+0x6/0x10
Mar 13 17:14:59 amd kernel: Code: b7 1f 8b 8e 88 00 00 00 85 c0 89 45 ec 0f 84 d3 01 00 00 c7 46 68 00 00 00 00 c7 46 10 00 00 00 00 8b 55 dc 8b 5d ec 0f b6 42 08 <3a> 83 45 02 00 00 0f 82 bf 00 00 00 0f b6 43 16 3c 06 0f 85 42 
Mar 13 17:14:59 amd kernel: Call Trace:
Mar 13 17:14:59 amd kernel:  [<c06c5ba3>] ip_local_deliver_finish+0xb3/0x1c0
Mar 13 17:14:59 amd kernel:  [<c06c5b20>] ? ip_local_deliver_finish+0x30/0x1c0
Mar 13 17:14:59 amd kernel:  [<c06c5d3f>] ip_local_deliver+0x8f/0xa0
Mar 13 17:14:59 amd kernel:  [<c06c5af0>] ? ip_local_deliver_finish+0x0/0x1c0
Mar 13 17:14:59 amd kernel:  [<c06c55e3>] ip_rcv_finish+0xf3/0x370
Mar 13 17:14:59 amd kernel:  [<c06c54f0>] ? ip_rcv_finish+0x0/0x370
Mar 13 17:14:59 amd kernel:  [<c06c5a94>] ip_rcv+0x234/0x290
Mar 13 17:14:59 amd kernel:  [<c06c54f0>] ? ip_rcv_finish+0x0/0x370
Mar 13 17:14:59 amd kernel:  [<c0688a70>] netif_receive_skb+0x1b0/0x310
Mar 13 17:14:59 amd kernel:  [<c0688971>] ? netif_receive_skb+0xb1/0x310
Mar 13 17:14:59 amd kernel:  [<c0688c32>] process_backlog+0x62/0xa0
Mar 13 17:14:59 amd kernel:  [<c0688e4d>] net_rx_action+0x7d/0x100
Mar 13 17:14:59 amd kernel:  [<c023a255>] __do_softirq+0x85/0x110
Mar 13 17:14:59 amd kernel:  [<c023a30d>] do_softirq+0x2d/0x40
Mar 13 17:14:59 amd kernel:  [<c06895da>] netif_rx_ni+0x1a/0x20
Mar 13 17:14:59 amd kernel:  [<c0734c33>] bnep_session+0x2c3/0x820
Mar 13 17:14:59 amd kernel:  [<c07ad6ad>] ? _raw_spin_unlock_irq+0x1d/0x30
Mar 13 17:14:59 amd kernel:  [<c02305e0>] ? default_wake_function+0x0/0x10
Mar 13 17:14:59 amd kernel:  [<c0734970>] ? bnep_session+0x0/0x820
Mar 13 17:14:59 amd kernel:  [<c02030f6>] kernel_thread_helper+0x6/0x10
Mar 13 17:16:04 amd kernel: BUG: soft lockup - CPU#1 stuck for 61s! [kbnepd bnep0:1965]
Mar 13 17:16:04 amd kernel: Modules linked in:
Mar 13 17:16:04 amd kernel: Modules linked in:
Mar 13 17:16:04 amd kernel: 
Mar 13 17:16:04 amd kernel: Pid: 1965, comm: kbnepd bnep0 Tainted: G        W  2.6.34-rc1-00182-g3c96f03-dirty #109 17097HU/17097HU
Mar 13 17:16:04 amd kernel: EIP: 0060:[<c06e244d>] EFLAGS: 00010282 CPU: 1
Mar 13 17:16:04 amd kernel: EIP is at tcp_v4_rcv+0x19d/0x7d0
Mar 13 17:16:04 amd kernel: EAX: 00000036 EBX: f1232e20 ECX: c06cd093 EDX: f2891e00
Mar 13 17:16:04 amd kernel: ESI: f2f50f48 EDI: f2891e14 EBP: f0c29ddc ESP: f0c29da0
Mar 13 17:16:04 amd kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Mar 13 17:16:04 amd kernel: Process kbnepd bnep0 (pid: 1965, ti=f0c28000 task=f7361648 task.ti=f0c28000)
Mar 13 17:16:04 amd kernel: Stack:
Mar 13 17:16:04 amd kernel:  00005000 6702a8c0 0000c602 00000004 f0c29ddc f2f50f48 f2891e00 0000c602
Mar 13 17:16:04 amd kernel: <0> 00000004 6702a8c0 f1232e20 00000000 c081aab0 f2f50f48 f2891e00 f0c29dfc
Mar 13 17:16:04 amd kernel: <0> c06c5ba3 00000002 00000001 00000000 c06c5b20 f2f50f48 f2f50f48 f0c29e18
Mar 13 17:16:04 amd kernel: Call Trace:
Mar 13 17:16:04 amd kernel:  [<c06c5ba3>] ? ip_local_deliver_finish+0xb3/0x1c0
Mar 13 17:16:04 amd kernel:  [<c06c5b20>] ? ip_local_deliver_finish+0x30/0x1c0
Mar 13 17:16:04 amd kernel:  [<c06c5d3f>] ? ip_local_deliver+0x8f/0xa0
Mar 13 17:16:04 amd kernel:  [<c06c5af0>] ? ip_local_deliver_finish+0x0/0x1c0
Mar 13 17:16:04 amd kernel:  [<c06c55e3>] ? ip_rcv_finish+0xf3/0x370
Mar 13 17:16:04 amd kernel:  [<c06c54f0>] ? ip_rcv_finish+0x0/0x370
Mar 13 17:16:04 amd kernel:  [<c06c5a94>] ? ip_rcv+0x234/0x290
Mar 13 17:16:04 amd kernel:  [<c06c54f0>] ? ip_rcv_finish+0x0/0x370
Mar 13 17:16:04 amd kernel:  [<c0688a70>] ? netif_receive_skb+0x1b0/0x310
Mar 13 17:16:04 amd kernel:  [<c0688971>] ? netif_receive_skb+0xb1/0x310
Mar 13 17:16:04 amd kernel:  [<c0688c32>] ? process_backlog+0x62/0xa0
Mar 13 17:16:04 amd kernel:  [<c0688e4d>] ? net_rx_action+0x7d/0x100
Mar 13 17:16:04 amd kernel:  [<c023a255>] ? __do_softirq+0x85/0x110
Mar 13 17:16:04 amd kernel:  [<c023a30d>] ? do_softirq+0x2d/0x40
Mar 13 17:16:04 amd kernel:  [<c06895da>] ? netif_rx_ni+0x1a/0x20
Mar 13 17:16:04 amd kernel:  [<c0734c33>] ? bnep_session+0x2c3/0x820
Mar 13 17:16:04 amd kernel:  [<c07ad6ad>] ? _raw_spin_unlock_irq+0x1d/0x30
Mar 13 17:16:04 amd kernel:  [<c02305e0>] ? default_wake_function+0x0/0x10
Mar 13 17:16:04 amd kernel:  [<c0734970>] ? bnep_session+0x0/0x820
Mar 13 17:16:04 amd kernel:  [<c02030f6>] ? kernel_thread_helper+0x6/0x10
Mar 13 17:16:04 amd kernel: Code: b7 1f 8b 8e 88 00 00 00 85 c0 89 45 ec 0f 84 d3 01 00 00 c7 46 68 00 00 00 00 c7 46 10 00 00 00 00 8b 55 dc 8b 5d ec 0f b6 42 08 <3a> 83 45 02 00 00 0f 82 bf 00 00 00 0f b6 43 16 3c 06 0f 85 42 
Mar 13 17:16:04 amd kernel: Call Trace:
Mar 13 17:16:04 amd kernel:  [<c06c5ba3>] ip_local_deliver_finish+0xb3/0x1c0
Mar 13 17:16:04 amd kernel:  [<c06c5b20>] ? ip_local_deliver_finish+0x30/0x1c0
Mar 13 17:16:04 amd kernel:  [<c06c5d3f>] ip_local_deliver+0x8f/0xa0
Mar 13 17:16:04 amd kernel:  [<c06c5af0>] ? ip_local_deliver_finish+0x0/0x1c0
Mar 13 17:16:04 amd kernel:  [<c06c55e3>] ip_rcv_finish+0xf3/0x370
Mar 13 17:16:04 amd kernel:  [<c06c54f0>] ? ip_rcv_finish+0x0/0x370
Mar 13 17:16:04 amd kernel:  [<c06c5a94>] ip_rcv+0x234/0x290
Mar 13 17:16:04 amd kernel:  [<c06c54f0>] ? ip_rcv_finish+0x0/0x370
Mar 13 17:16:04 amd kernel:  [<c0688a70>] netif_receive_skb+0x1b0/0x310
Mar 13 17:16:04 amd kernel:  [<c0688971>] ? netif_receive_skb+0xb1/0x310
Mar 13 17:16:04 amd kernel:  [<c0688c32>] process_backlog+0x62/0xa0
Mar 13 17:16:04 amd kernel:  [<c0688e4d>] net_rx_action+0x7d/0x100
Mar 13 17:16:04 amd kernel:  [<c023a255>] __do_softirq+0x85/0x110
Mar 13 17:16:04 amd kernel:  [<c023a30d>] do_softirq+0x2d/0x40
Mar 13 17:16:04 amd kernel:  [<c06895da>] netif_rx_ni+0x1a/0x20
Mar 13 17:16:04 amd kernel:  [<c0734c33>] bnep_session+0x2c3/0x820
Mar 13 17:16:04 amd kernel:  [<c07ad6ad>] ? _raw_spin_unlock_irq+0x1d/0x30
Mar 13 17:16:04 amd kernel:  [<c02305e0>] ? default_wake_function+0x0/0x10
Mar 13 17:16:04 amd kernel:  [<c0734970>] ? bnep_session+0x0/0x820
Mar 13 17:16:04 amd kernel:  [<c02030f6>] kernel_thread_helper+0x6/0x10
Mar 13 17:17:09 amd kernel: BUG: soft lockup - CPU#1 stuck for 61s! [kbnepd bnep0:1965]
Mar 13 17:17:09 amd kernel: Modules linked in:
Mar 13 17:17:09 amd kernel: Modules linked in:
Mar 13 17:17:09 amd kernel: 
Mar 13 17:17:09 amd kernel: Pid: 1965, comm: kbnepd bnep0 Tainted: G        W  2.6.34-rc1-00182-g3c96f03-dirty #109 17097HU/17097HU
Mar 13 17:17:09 amd kernel: EIP: 0060:[<c06e244d>] EFLAGS: 00010282 CPU: 1
Mar 13 17:17:09 amd kernel: EIP is at tcp_v4_rcv+0x19d/0x7d0
Mar 13 17:17:09 amd kernel: EAX: 00000036 EBX: f1232e20 ECX: c06cd093 EDX: f2891e00
Mar 13 17:17:09 amd kernel: ESI: f2f50f48 EDI: f2891e14 EBP: f0c29ddc ESP: f0c29da0
Mar 13 17:17:09 amd kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Mar 13 17:17:09 amd kernel: Process kbnepd bnep0 (pid: 1965, ti=f0c28000 task=f7361648 task.ti=f0c28000)
Mar 13 17:17:10 amd kernel: Stack:
Mar 13 17:17:10 amd kernel:  00005000 6702a8c0 0000c602 00000004 f0c29ddc f2f50f48 f2891e00 0000c602
Mar 13 17:17:10 amd kernel: <0> 00000004 6702a8c0 f1232e20 00000000 c081aab0 f2f50f48 f2891e00 f0c29dfc
Mar 13 17:17:10 amd kernel: <0> c06c5ba3 00000002 00000001 00000000 c06c5b20 f2f50f48 f2f50f48 f0c29e18
Mar 13 17:17:10 amd kernel: Call Trace:
Mar 13 17:17:10 amd kernel:  [<c06c5ba3>] ? ip_local_deliver_finish+0xb3/0x1c0
Mar 13 17:17:10 amd kernel:  [<c06c5b20>] ? ip_local_deliver_finish+0x30/0x1c0
Mar 13 17:17:10 amd kernel:  [<c06c5d3f>] ? ip_local_deliver+0x8f/0xa0
Mar 13 17:17:10 amd kernel:  [<c06c5af0>] ? ip_local_deliver_finish+0x0/0x1c0
Mar 13 17:17:10 amd kernel:  [<c06c55e3>] ? ip_rcv_finish+0xf3/0x370
Mar 13 17:17:10 amd kernel:  [<c06c54f0>] ? ip_rcv_finish+0x0/0x370
Mar 13 17:17:10 amd kernel:  [<c06c5a94>] ? ip_rcv+0x234/0x290
Mar 13 17:17:10 amd kernel:  [<c06c54f0>] ? ip_rcv_finish+0x0/0x370
Mar 13 17:17:10 amd kernel:  [<c0688a70>] ? netif_receive_skb+0x1b0/0x310
Mar 13 17:17:10 amd kernel:  [<c0688971>] ? netif_receive_skb+0xb1/0x310
Mar 13 17:17:10 amd kernel:  [<c0688c32>] ? process_backlog+0x62/0xa0
Mar 13 17:17:10 amd kernel:  [<c0688e4d>] ? net_rx_action+0x7d/0x100
Mar 13 17:17:10 amd kernel:  [<c023a255>] ? __do_softirq+0x85/0x110
Mar 13 17:17:10 amd kernel:  [<c023a30d>] ? do_softirq+0x2d/0x40
Mar 13 17:17:10 amd kernel:  [<c06895da>] ? netif_rx_ni+0x1a/0x20
Mar 13 17:17:10 amd kernel:  [<c0734c33>] ? bnep_session+0x2c3/0x820
Mar 13 17:17:10 amd kernel:  [<c07ad6ad>] ? _raw_spin_unlock_irq+0x1d/0x30
Mar 13 17:17:10 amd kernel:  [<c02305e0>] ? default_wake_function+0x0/0x10
Mar 13 17:17:10 amd kernel:  [<c0734970>] ? bnep_session+0x0/0x820
Mar 13 17:17:10 amd kernel:  [<c02030f6>] ? kernel_thread_helper+0x6/0x10
Mar 13 17:17:10 amd kernel: Code: b7 1f 8b 8e 88 00 00 00 85 c0 89 45 ec 0f 84 d3 01 00 00 c7 46 68 00 00 00 00 c7 46 10 00 00 00 00 8b 55 dc 8b 5d ec 0f b6 42 08 <3a> 83 45 02 00 00 0f 82 bf 00 00 00 0f b6 43 16 3c 06 0f 85 42 
Mar 13 17:17:10 amd kernel: Call Trace:
Mar 13 17:17:10 amd kernel:  [<c06c5ba3>] ip_local_deliver_finish+0xb3/0x1c0
Mar 13 17:17:10 amd kernel:  [<c06c5b20>] ? ip_local_deliver_finish+0x30/0x1c0
Mar 13 17:17:10 amd kernel:  [<c06c5d3f>] ip_local_deliver+0x8f/0xa0
Mar 13 17:17:10 amd kernel:  [<c06c5af0>] ? ip_local_deliver_finish+0x0/0x1c0
Mar 13 17:17:10 amd kernel:  [<c06c55e3>] ip_rcv_finish+0xf3/0x370
Mar 13 17:17:10 amd kernel:  [<c06c54f0>] ? ip_rcv_finish+0x0/0x370
Mar 13 17:17:10 amd kernel:  [<c06c5a94>] ip_rcv+0x234/0x290
Mar 13 17:17:10 amd kernel:  [<c06c54f0>] ? ip_rcv_finish+0x0/0x370
Mar 13 17:17:10 amd kernel:  [<c0688a70>] netif_receive_skb+0x1b0/0x310
Mar 13 17:17:10 amd kernel:  [<c0688971>] ? netif_receive_skb+0xb1/0x310
Mar 13 17:17:10 amd kernel:  [<c0688c32>] process_backlog+0x62/0xa0
Mar 13 17:17:10 amd kernel:  [<c0688e4d>] net_rx_action+0x7d/0x100
Mar 13 17:17:10 amd kernel:  [<c023a255>] __do_softirq+0x85/0x110
Mar 13 17:17:10 amd kernel:  [<c023a30d>] do_softirq+0x2d/0x40
Mar 13 17:17:10 amd kernel:  [<c06895da>] netif_rx_ni+0x1a/0x20
Mar 13 17:17:10 amd kernel:  [<c0734c33>] bnep_session+0x2c3/0x820
Mar 13 17:17:10 amd kernel:  [<c07ad6ad>] ? _raw_spin_unlock_irq+0x1d/0x30
Mar 13 17:17:10 amd kernel:  [<c02305e0>] ? default_wake_function+0x0/0x10
Mar 13 17:17:10 amd kernel:  [<c0734970>] ? bnep_session+0x0/0x820
Mar 13 17:17:10 amd kernel:  [<c02030f6>] kernel_thread_helper+0x6/0x10
Mar 13 17:18:15 amd kernel: BUG: soft lockup - CPU#1 stuck for 61s! [kbnepd bnep0:1965]
Mar 13 17:18:15 amd kernel: Modules linked in:
Mar 13 17:18:15 amd kernel: Modules linked in:
Mar 13 17:18:15 amd kernel: 
Mar 13 17:18:15 amd kernel: Pid: 1965, comm: kbnepd bnep0 Tainted: G        W  2.6.34-rc1-00182-g3c96f03-dirty #109 17097HU/17097HU
Mar 13 17:18:15 amd kernel: EIP: 0060:[<c06e244d>] EFLAGS: 00010282 CPU: 1
Mar 13 17:18:15 amd kernel: EIP is at tcp_v4_rcv+0x19d/0x7d0
Mar 13 17:18:15 amd kernel: EAX: 00000036 EBX: f1232e20 ECX: c06cd093 EDX: f2891e00
Mar 13 17:18:15 amd kernel: ESI: f2f50f48 EDI: f2891e14 EBP: f0c29ddc ESP: f0c29da0
Mar 13 17:18:15 amd kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Mar 13 17:18:15 amd kernel: Process kbnepd bnep0 (pid: 1965, ti=f0c28000 task=f7361648 task.ti=f0c28000)
Mar 13 17:18:15 amd kernel: Stack:
Mar 13 17:18:15 amd kernel:  00005000 6702a8c0 0000c602 00000004 f0c29ddc f2f50f48 f2891e00 0000c602
Mar 13 17:18:15 amd kernel: <0> 00000004 6702a8c0 f1232e20 00000000 c081aab0 f2f50f48 f2891e00 f0c29dfc
Mar 13 17:18:15 amd kernel: <0> c06c5ba3 00000002 00000001 00000000 c06c5b20 f2f50f48 f2f50f48 f0c29e18
Mar 13 17:18:15 amd kernel: Call Trace:
Mar 13 17:18:15 amd kernel:  [<c06c5ba3>] ? ip_local_deliver_finish+0xb3/0x1c0
Mar 13 17:18:15 amd kernel:  [<c06c5b20>] ? ip_local_deliver_finish+0x30/0x1c0
Mar 13 17:18:15 amd kernel:  [<c06c5d3f>] ? ip_local_deliver+0x8f/0xa0
Mar 13 17:18:15 amd kernel:  [<c06c5af0>] ? ip_local_deliver_finish+0x0/0x1c0
Mar 13 17:18:15 amd kernel:  [<c06c55e3>] ? ip_rcv_finish+0xf3/0x370
Mar 13 17:18:15 amd kernel:  [<c06c54f0>] ? ip_rcv_finish+0x0/0x370
Mar 13 17:18:15 amd kernel:  [<c06c5a94>] ? ip_rcv+0x234/0x290
Mar 13 17:18:15 amd kernel:  [<c06c54f0>] ? ip_rcv_finish+0x0/0x370
Mar 13 17:18:15 amd kernel:  [<c0688a70>] ? netif_receive_skb+0x1b0/0x310
Mar 13 17:18:15 amd kernel:  [<c0688971>] ? netif_receive_skb+0xb1/0x310
Mar 13 17:18:15 amd kernel:  [<c0688c32>] ? process_backlog+0x62/0xa0
Mar 13 17:18:15 amd kernel:  [<c0688e4d>] ? net_rx_action+0x7d/0x100
Mar 13 17:18:15 amd kernel:  [<c023a255>] ? __do_softirq+0x85/0x110
Mar 13 17:18:15 amd kernel:  [<c023a30d>] ? do_softirq+0x2d/0x40
Mar 13 17:18:15 amd kernel:  [<c06895da>] ? netif_rx_ni+0x1a/0x20
Mar 13 17:18:15 amd kernel:  [<c0734c33>] ? bnep_session+0x2c3/0x820
Mar 13 17:18:15 amd kernel:  [<c07ad6ad>] ? _raw_spin_unlock_irq+0x1d/0x30
Mar 13 17:18:15 amd kernel:  [<c02305e0>] ? default_wake_function+0x0/0x10
Mar 13 17:18:15 amd kernel:  [<c0734970>] ? bnep_session+0x0/0x820
Mar 13 17:18:15 amd kernel:  [<c02030f6>] ? kernel_thread_helper+0x6/0x10
Mar 13 17:18:15 amd kernel: Code: b7 1f 8b 8e 88 00 00 00 85 c0 89 45 ec 0f 84 d3 01 00 00 c7 46 68 00 00 00 00 c7 46 10 00 00 00 00 8b 55 dc 8b 5d ec 0f b6 42 08 <3a> 83 45 02 00 00 0f 82 bf 00 00 00 0f b6 43 16 3c 06 0f 85 42 
Mar 13 17:18:15 amd kernel: Call Trace:
Mar 13 17:18:15 amd kernel:  [<c06c5ba3>] ip_local_deliver_finish+0xb3/0x1c0
Mar 13 17:18:15 amd kernel:  [<c06c5b20>] ? ip_local_deliver_finish+0x30/0x1c0
Mar 13 17:18:15 amd kernel:  [<c06c5d3f>] ip_local_deliver+0x8f/0xa0
Mar 13 17:18:15 amd kernel:  [<c06c5af0>] ? ip_local_deliver_finish+0x0/0x1c0
Mar 13 17:18:15 amd kernel:  [<c06c55e3>] ip_rcv_finish+0xf3/0x370
Mar 13 17:18:15 amd kernel:  [<c06c54f0>] ? ip_rcv_finish+0x0/0x370
Mar 13 17:18:15 amd kernel:  [<c06c5a94>] ip_rcv+0x234/0x290
Mar 13 17:18:15 amd kernel:  [<c06c54f0>] ? ip_rcv_finish+0x0/0x370
Mar 13 17:18:15 amd kernel:  [<c0688a70>] netif_receive_skb+0x1b0/0x310
Mar 13 17:18:15 amd kernel:  [<c0688971>] ? netif_receive_skb+0xb1/0x310
Mar 13 17:18:15 amd kernel:  [<c0688c32>] process_backlog+0x62/0xa0
Mar 13 17:18:15 amd kernel:  [<c0688e4d>] net_rx_action+0x7d/0x100
Mar 13 17:18:15 amd kernel:  [<c023a255>] __do_softirq+0x85/0x110
Mar 13 17:18:15 amd kernel:  [<c023a30d>] do_softirq+0x2d/0x40
Mar 13 17:18:15 amd kernel:  [<c06895da>] netif_rx_ni+0x1a/0x20
Mar 13 17:18:15 amd kernel:  [<c0734c33>] bnep_session+0x2c3/0x820
Mar 13 17:18:15 amd kernel:  [<c07ad6ad>] ? _raw_spin_unlock_irq+0x1d/0x30
Mar 13 17:18:15 amd kernel:  [<c02305e0>] ? default_wake_function+0x0/0x10
Mar 13 17:18:15 amd kernel:  [<c0734970>] ? bnep_session+0x0/0x820
Mar 13 17:18:15 amd kernel:  [<c02030f6>] kernel_thread_helper+0x6/0x10
Mar 13 17:19:20 amd kernel: BUG: soft lockup - CPU#1 stuck for 61s! [kbnepd bnep0:1965]
Mar 13 17:19:20 amd kernel: Modules linked in:
Mar 13 17:19:20 amd kernel: Modules linked in:
Mar 13 17:19:20 amd kernel: 
Mar 13 17:19:20 amd kernel: Pid: 1965, comm: kbnepd bnep0 Tainted: G        W  2.6.34-rc1-00182-g3c96f03-dirty #109 17097HU/17097HU
Mar 13 17:19:20 amd kernel: EIP: 0060:[<c06e244d>] EFLAGS: 00010282 CPU: 1
Mar 13 17:19:20 amd kernel: EIP is at tcp_v4_rcv+0x19d/0x7d0
Mar 13 17:19:20 amd kernel: EAX: 00000036 EBX: f1232e20 ECX: c06cd093 EDX: f2891e00
Mar 13 17:19:20 amd kernel: ESI: f2f50f48 EDI: f2891e14 EBP: f0c29ddc ESP: f0c29da0
Mar 13 17:19:20 amd kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Mar 13 17:19:20 amd kernel: Process kbnepd bnep0 (pid: 1965, ti=f0c28000 task=f7361648 task.ti=f0c28000)
Mar 13 17:19:20 amd kernel: Stack:
Mar 13 17:19:20 amd kernel:  00005000 6702a8c0 0000c602 00000004 f0c29ddc f2f50f48 f2891e00 0000c602
Mar 13 17:19:20 amd kernel: <0> 00000004 6702a8c0 f1232e20 00000000 c081aab0 f2f50f48 f2891e00 f0c29dfc
Mar 13 17:19:20 amd kernel: <0> c06c5ba3 00000002 00000001 00000000 c06c5b20 f2f50f48 f2f50f48 f0c29e18
Mar 13 17:19:20 amd kernel: Call Trace:
Mar 13 17:19:20 amd kernel:  [<c06c5ba3>] ? ip_local_deliver_finish+0xb3/0x1c0
Mar 13 17:19:20 amd kernel:  [<c06c5b20>] ? ip_local_deliver_finish+0x30/0x1c0
Mar 13 17:19:20 amd kernel:  [<c06c5d3f>] ? ip_local_deliver+0x8f/0xa0
Mar 13 17:19:20 amd kernel:  [<c06c5af0>] ? ip_local_deliver_finish+0x0/0x1c0
Mar 13 17:19:20 amd kernel:  [<c06c55e3>] ? ip_rcv_finish+0xf3/0x370
Mar 13 17:19:20 amd kernel:  [<c06c54f0>] ? ip_rcv_finish+0x0/0x370
Mar 13 17:19:20 amd kernel:  [<c06c5a94>] ? ip_rcv+0x234/0x290
Mar 13 17:19:20 amd kernel:  [<c06c54f0>] ? ip_rcv_finish+0x0/0x370
Mar 13 17:19:20 amd kernel:  [<c0688a70>] ? netif_receive_skb+0x1b0/0x310
Mar 13 17:19:20 amd kernel:  [<c0688971>] ? netif_receive_skb+0xb1/0x310
Mar 13 17:19:20 amd kernel:  [<c0688c32>] ? process_backlog+0x62/0xa0
Mar 13 17:19:20 amd kernel:  [<c0688e4d>] ? net_rx_action+0x7d/0x100
Mar 13 17:19:20 amd kernel:  [<c023a255>] ? __do_softirq+0x85/0x110
Mar 13 17:19:20 amd kernel:  [<c023a30d>] ? do_softirq+0x2d/0x40
Mar 13 17:19:21 amd kernel:  [<c06895da>] ? netif_rx_ni+0x1a/0x20
Mar 13 17:19:21 amd kernel:  [<c0734c33>] ? bnep_session+0x2c3/0x820
Mar 13 17:19:21 amd kernel:  [<c07ad6ad>] ? _raw_spin_unlock_irq+0x1d/0x30
Mar 13 17:19:21 amd kernel:  [<c02305e0>] ? default_wake_function+0x0/0x10
Mar 13 17:19:21 amd kernel:  [<c0734970>] ? bnep_session+0x0/0x820
Mar 13 17:19:21 amd kernel:  [<c02030f6>] ? kernel_thread_helper+0x6/0x10
Mar 13 17:19:21 amd kernel: Code: b7 1f 8b 8e 88 00 00 00 85 c0 89 45 ec 0f 84 d3 01 00 00 c7 46 68 00 00 00 00 c7 46 10 00 00 00 00 8b 55 dc 8b 5d ec 0f b6 42 08 <3a> 83 45 02 00 00 0f 82 bf 00 00 00 0f b6 43 16 3c 06 0f 85 42 
Mar 13 17:19:21 amd kernel: Call Trace:
Mar 13 17:19:21 amd kernel:  [<c06c5ba3>] ip_local_deliver_finish+0xb3/0x1c0
Mar 13 17:19:21 amd kernel:  [<c06c5b20>] ? ip_local_deliver_finish+0x30/0x1c0
Mar 13 17:19:21 amd kernel:  [<c06c5d3f>] ip_local_deliver+0x8f/0xa0
Mar 13 17:19:21 amd kernel:  [<c06c5af0>] ? ip_local_deliver_finish+0x0/0x1c0
Mar 13 17:19:21 amd kernel:  [<c06c55e3>] ip_rcv_finish+0xf3/0x370
Mar 13 17:19:21 amd kernel:  [<c06c54f0>] ? ip_rcv_finish+0x0/0x370
Mar 13 17:19:21 amd kernel:  [<c06c5a94>] ip_rcv+0x234/0x290
Mar 13 17:19:21 amd kernel:  [<c06c54f0>] ? ip_rcv_finish+0x0/0x370
Mar 13 17:19:21 amd kernel:  [<c0688a70>] netif_receive_skb+0x1b0/0x310
Mar 13 17:19:21 amd kernel:  [<c0688971>] ? netif_receive_skb+0xb1/0x310
Mar 13 17:19:21 amd kernel:  [<c0688c32>] process_backlog+0x62/0xa0
Mar 13 17:19:21 amd kernel:  [<c0688e4d>] net_rx_action+0x7d/0x100
Mar 13 17:19:21 amd kernel:  [<c023a255>] __do_softirq+0x85/0x110
Mar 13 17:19:21 amd kernel:  [<c023a30d>] do_softirq+0x2d/0x40
Mar 13 17:19:21 amd kernel:  [<c06895da>] netif_rx_ni+0x1a/0x20
Mar 13 17:19:21 amd kernel:  [<c0734c33>] bnep_session+0x2c3/0x820
Mar 13 17:19:21 amd kernel:  [<c07ad6ad>] ? _raw_spin_unlock_irq+0x1d/0x30
Mar 13 17:19:21 amd kernel:  [<c02305e0>] ? default_wake_function+0x0/0x10
Mar 13 17:19:21 amd kernel:  [<c0734970>] ? bnep_session+0x0/0x820
Mar 13 17:19:21 amd kernel:  [<c02030f6>] kernel_thread_helper+0x6/0x10
Mar 13 17:19:32 amd su[2469]: pam_unix(su:auth): Couldn't open /etc/securetty: No such file or directory
Mar 13 17:19:33 amd su[2469]: pam_unix(su:auth): Couldn't open /etc/securetty: No such file or directory
Mar 13 17:19:33 amd su[2469]: unknown configuration item `FAIL_DELAY'
Mar 13 17:19:33 amd su[2469]: unknown configuration item `DIALUPS_CHECK_ENAB'
Mar 13 17:19:33 amd su[2469]: unknown configuration item `LASTLOG_ENAB'
Mar 13 17:19:33 amd su[2469]: unknown configuration item `MAIL_CHECK_ENAB'
Mar 13 17:19:33 amd su[2469]: unknown configuration item `OBSCURE_CHECKS_ENAB'
Mar 13 17:19:33 amd su[2469]: unknown configuration item `PORTTIME_CHECKS_ENAB'
Mar 13 17:19:33 amd su[2469]: unknown configuration item `QUOTAS_ENAB'
Mar 13 17:19:33 amd su[2469]: unknown configuration item `NO_PASSWORD_CONSOLE'
Mar 13 17:19:33 amd su[2469]: unknown configuration item `MOTD_FILE'
Mar 13 17:19:33 amd su[2469]: unknown configuration item `NOLOGINS_FILE'
Mar 13 17:19:33 amd su[2469]: unknown configuration item `NOLOGIN_STR'
Mar 13 17:19:33 amd su[2469]: unknown configuration item `ENV_HZ'
Mar 13 17:19:33 amd su[2469]: unknown configuration item `ULIMIT'
Mar 13 17:19:33 amd su[2469]: unknown configuration item `PASS_MIN_LEN'
Mar 13 17:19:33 amd su[2469]: unknown configuration item `SU_WHEEL_ONLY'
Mar 13 17:19:33 amd su[2469]: unknown configuration item `PASS_CHANGE_TRIES'
Mar 13 17:19:33 amd su[2469]: unknown configuration item `PASS_ALWAYS_WARN'
Mar 13 17:19:33 amd su[2469]: unknown configuration item `CHFN_AUTH'
Mar 13 17:19:33 amd su[2469]: Successful su for root by pavel
Mar 13 17:19:33 amd su[2469]: + /dev/ttyp3 pavel:root
Mar 13 17:19:33 amd su[2469]: pam_unix(su:session): session opened for user root by (uid=1000)
Mar 13 17:20:26 amd kernel: BUG: soft lockup - CPU#1 stuck for 61s! [kbnepd bnep0:1965]
Mar 13 17:20:26 amd kernel: Modules linked in:
Mar 13 17:20:26 amd kernel: Modules linked in:
Mar 13 17:20:26 amd kernel: 
Mar 13 17:20:26 amd kernel: Pid: 1965, comm: kbnepd bnep0 Tainted: G        W  2.6.34-rc1-00182-g3c96f03-dirty #109 17097HU/17097HU
Mar 13 17:20:26 amd kernel: EIP: 0060:[<c06e244d>] EFLAGS: 00010282 CPU: 1
Mar 13 17:20:26 amd kernel: EIP is at tcp_v4_rcv+0x19d/0x7d0
Mar 13 17:20:26 amd kernel: EAX: 00000036 EBX: f1232e20 ECX: c06cd093 EDX: f2891e00
Mar 13 17:20:26 amd kernel: ESI: f2f50f48 EDI: f2891e14 EBP: f0c29ddc ESP: f0c29da0
Mar 13 17:20:26 amd kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Mar 13 17:20:26 amd kernel: Process kbnepd bnep0 (pid: 1965, ti=f0c28000 task=f7361648 task.ti=f0c28000)
Mar 13 17:20:26 amd kernel: Stack:
Mar 13 17:20:26 amd kernel:  00005000 6702a8c0 0000c602 00000004 f0c29ddc f2f50f48 f2891e00 0000c602
Mar 13 17:20:26 amd kernel: <0> 00000004 6702a8c0 f1232e20 00000000 c081aab0 f2f50f48 f2891e00 f0c29dfc
Mar 13 17:20:26 amd kernel: <0> c06c5ba3 00000002 00000001 00000000 c06c5b20 f2f50f48 f2f50f48 f0c29e18
Mar 13 17:20:26 amd kernel: Call Trace:
Mar 13 17:20:26 amd kernel:  [<c06c5ba3>] ? ip_local_deliver_finish+0xb3/0x1c0
Mar 13 17:20:26 amd kernel:  [<c06c5b20>] ? ip_local_deliver_finish+0x30/0x1c0
Mar 13 17:20:26 amd kernel:  [<c06c5d3f>] ? ip_local_deliver+0x8f/0xa0
Mar 13 17:20:26 amd kernel:  [<c06c5af0>] ? ip_local_deliver_finish+0x0/0x1c0
Mar 13 17:20:26 amd kernel:  [<c06c55e3>] ? ip_rcv_finish+0xf3/0x370
Mar 13 17:20:26 amd kernel:  [<c06c54f0>] ? ip_rcv_finish+0x0/0x370
Mar 13 17:20:26 amd kernel:  [<c06c5a94>] ? ip_rcv+0x234/0x290
Mar 13 17:20:26 amd kernel:  [<c06c54f0>] ? ip_rcv_finish+0x0/0x370
Mar 13 17:20:26 amd kernel:  [<c0688a70>] ? netif_receive_skb+0x1b0/0x310
Mar 13 17:20:26 amd kernel:  [<c0688971>] ? netif_receive_skb+0xb1/0x310
Mar 13 17:20:26 amd kernel:  [<c0688c32>] ? process_backlog+0x62/0xa0
Mar 13 17:20:26 amd kernel:  [<c0688e4d>] ? net_rx_action+0x7d/0x100
Mar 13 17:20:26 amd kernel:  [<c023a255>] ? __do_softirq+0x85/0x110
Mar 13 17:20:26 amd kernel:  [<c023a30d>] ? do_softirq+0x2d/0x40
Mar 13 17:20:26 amd kernel:  [<c06895da>] ? netif_rx_ni+0x1a/0x20
Mar 13 17:20:26 amd kernel:  [<c0734c33>] ? bnep_session+0x2c3/0x820
Mar 13 17:20:26 amd kernel:  [<c07ad6ad>] ? _raw_spin_unlock_irq+0x1d/0x30
Mar 13 17:20:26 amd kernel:  [<c02305e0>] ? default_wake_function+0x0/0x10
Mar 13 17:20:26 amd kernel:  [<c0734970>] ? bnep_session+0x0/0x820
Mar 13 17:20:26 amd kernel:  [<c02030f6>] ? kernel_thread_helper+0x6/0x10
Mar 13 17:20:26 amd kernel: Code: b7 1f 8b 8e 88 00 00 00 85 c0 89 45 ec 0f 84 d3 01 00 00 c7 46 68 00 00 00 00 c7 46 10 00 00 00 00 8b 55 dc 8b 5d ec 0f b6 42 08 <3a> 83 45 02 00 00 0f 82 bf 00 00 00 0f b6 43 16 3c 06 0f 85 42 
Mar 13 17:20:26 amd kernel: Call Trace:
Mar 13 17:20:26 amd kernel:  [<c06c5ba3>] ip_local_deliver_finish+0xb3/0x1c0
Mar 13 17:20:26 amd kernel:  [<c06c5b20>] ? ip_local_deliver_finish+0x30/0x1c0
Mar 13 17:20:26 amd kernel:  [<c06c5d3f>] ip_local_deliver+0x8f/0xa0
Mar 13 17:20:26 amd kernel:  [<c06c5af0>] ? ip_local_deliver_finish+0x0/0x1c0
Mar 13 17:20:26 amd kernel:  [<c06c55e3>] ip_rcv_finish+0xf3/0x370
Mar 13 17:20:26 amd kernel:  [<c06c54f0>] ? ip_rcv_finish+0x0/0x370
Mar 13 17:20:26 amd kernel:  [<c06c5a94>] ip_rcv+0x234/0x290
Mar 13 17:20:26 amd kernel:  [<c06c54f0>] ? ip_rcv_finish+0x0/0x370
Mar 13 17:20:26 amd kernel:  [<c0688a70>] netif_receive_skb+0x1b0/0x310
Mar 13 17:20:26 amd kernel:  [<c0688971>] ? netif_receive_skb+0xb1/0x310
Mar 13 17:20:26 amd kernel:  [<c0688c32>] process_backlog+0x62/0xa0
Mar 13 17:20:26 amd kernel:  [<c0688e4d>] net_rx_action+0x7d/0x100
Mar 13 17:20:26 amd kernel:  [<c023a255>] __do_softirq+0x85/0x110
Mar 13 17:20:26 amd kernel:  [<c023a30d>] do_softirq+0x2d/0x40
Mar 13 17:20:26 amd kernel:  [<c06895da>] netif_rx_ni+0x1a/0x20
Mar 13 17:20:26 amd kernel:  [<c0734c33>] bnep_session+0x2c3/0x820
Mar 13 17:20:26 amd kernel:  [<c07ad6ad>] ? _raw_spin_unlock_irq+0x1d/0x30
Mar 13 17:20:26 amd kernel:  [<c02305e0>] ? default_wake_function+0x0/0x10
Mar 13 17:20:26 amd kernel:  [<c0734970>] ? bnep_session+0x0/0x820
Mar 13 17:20:26 amd kernel:  [<c02030f6>] kernel_thread_helper+0x6/0x10
Mar 13 17:21:31 amd kernel: BUG: soft lockup - CPU#1 stuck for 61s! [kbnepd bnep0:1965]
Mar 13 17:21:31 amd kernel: Modules linked in:
Mar 13 17:21:31 amd kernel: Modules linked in:
Mar 13 17:21:31 amd kernel: 
Mar 13 17:21:31 amd kernel: Pid: 1965, comm: kbnepd bnep0 Tainted: G        W  2.6.34-rc1-00182-g3c96f03-dirty #109 17097HU/17097HU
Mar 13 17:21:31 amd kernel: EIP: 0060:[<c06e244d>] EFLAGS: 00010282 CPU: 1
Mar 13 17:21:31 amd kernel: EIP is at tcp_v4_rcv+0x19d/0x7d0
Mar 13 17:21:31 amd kernel: EAX: 00000036 EBX: f1232e20 ECX: c06cd093 EDX: f2891e00
Mar 13 17:21:31 amd kernel: ESI: f2f50f48 EDI: f2891e14 EBP: f0c29ddc ESP: f0c29da0
Mar 13 17:21:31 amd kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Mar 13 17:21:31 amd kernel: Process kbnepd bnep0 (pid: 1965, ti=f0c28000 task=f7361648 task.ti=f0c28000)
Mar 13 17:21:31 amd kernel: Stack:
Mar 13 17:21:31 amd kernel:  00005000 6702a8c0 0000c602 00000004 f0c29ddc f2f50f48 f2891e00 0000c602
Mar 13 17:21:31 amd kernel: <0> 00000004 6702a8c0 f1232e20 00000000 c081aab0 f2f50f48 f2891e00 f0c29dfc
Mar 13 17:21:31 amd kernel: <0> c06c5ba3 00000002 00000001 00000000 c06c5b20 f2f50f48 f2f50f48 f0c29e18
Mar 13 17:21:31 amd kernel: Call Trace:
Mar 13 17:21:31 amd kernel:  [<c06c5ba3>] ? ip_local_deliver_finish+0xb3/0x1c0
Mar 13 17:21:31 amd kernel:  [<c06c5b20>] ? ip_local_deliver_finish+0x30/0x1c0
Mar 13 17:21:31 amd kernel:  [<c06c5d3f>] ? ip_local_deliver+0x8f/0xa0
Mar 13 17:21:31 amd kernel:  [<c06c5af0>] ? ip_local_deliver_finish+0x0/0x1c0
Mar 13 17:21:31 amd kernel:  [<c06c55e3>] ? ip_rcv_finish+0xf3/0x370
Mar 13 17:21:31 amd kernel:  [<c06c54f0>] ? ip_rcv_finish+0x0/0x370
Mar 13 17:21:31 amd kernel:  [<c06c5a94>] ? ip_rcv+0x234/0x290
Mar 13 17:21:31 amd kernel:  [<c06c54f0>] ? ip_rcv_finish+0x0/0x370
Mar 13 17:21:31 amd kernel:  [<c0688a70>] ? netif_receive_skb+0x1b0/0x310
Mar 13 17:21:31 amd kernel:  [<c0688971>] ? netif_receive_skb+0xb1/0x310
Mar 13 17:21:31 amd kernel:  [<c0688c32>] ? process_backlog+0x62/0xa0
Mar 13 17:21:31 amd kernel:  [<c0688e4d>] ? net_rx_action+0x7d/0x100
Mar 13 17:21:31 amd kernel:  [<c023a255>] ? __do_softirq+0x85/0x110
Mar 13 17:21:31 amd kernel:  [<c023a30d>] ? do_softirq+0x2d/0x40
Mar 13 17:21:31 amd kernel:  [<c06895da>] ? netif_rx_ni+0x1a/0x20
Mar 13 17:21:31 amd kernel:  [<c0734c33>] ? bnep_session+0x2c3/0x820
Mar 13 17:21:31 amd kernel:  [<c07ad6ad>] ? _raw_spin_unlock_irq+0x1d/0x30
Mar 13 17:21:31 amd kernel:  [<c02305e0>] ? default_wake_function+0x0/0x10
Mar 13 17:21:31 amd kernel:  [<c0734970>] ? bnep_session+0x0/0x820
Mar 13 17:21:31 amd kernel:  [<c02030f6>] ? kernel_thread_helper+0x6/0x10
Mar 13 17:21:31 amd kernel: Code: b7 1f 8b 8e 88 00 00 00 85 c0 89 45 ec 0f 84 d3 01 00 00 c7 46 68 00 00 00 00 c7 46 10 00 00 00 00 8b 55 dc 8b 5d ec 0f b6 42 08 <3a> 83 45 02 00 00 0f 82 bf 00 00 00 0f b6 43 16 3c 06 0f 85 42 
Mar 13 17:21:31 amd kernel: Call Trace:
Mar 13 17:21:31 amd kernel:  [<c06c5ba3>] ip_local_deliver_finish+0xb3/0x1c0
Mar 13 17:21:31 amd kernel:  [<c06c5b20>] ? ip_local_deliver_finish+0x30/0x1c0
Mar 13 17:21:31 amd kernel:  [<c06c5d3f>] ip_local_deliver+0x8f/0xa0
Mar 13 17:21:31 amd kernel:  [<c06c5af0>] ? ip_local_deliver_finish+0x0/0x1c0
Mar 13 17:21:31 amd kernel:  [<c06c55e3>] ip_rcv_finish+0xf3/0x370
Mar 13 17:21:31 amd kernel:  [<c06c54f0>] ? ip_rcv_finish+0x0/0x370
Mar 13 17:21:31 amd kernel:  [<c06c5a94>] ip_rcv+0x234/0x290
Mar 13 17:21:31 amd kernel:  [<c06c54f0>] ? ip_rcv_finish+0x0/0x370
Mar 13 17:21:31 amd kernel:  [<c0688a70>] netif_receive_skb+0x1b0/0x310
Mar 13 17:21:31 amd kernel:  [<c0688971>] ? netif_receive_skb+0xb1/0x310
Mar 13 17:21:31 amd kernel:  [<c0688c32>] process_backlog+0x62/0xa0
Mar 13 17:21:31 amd kernel:  [<c0688e4d>] net_rx_action+0x7d/0x100
Mar 13 17:21:32 amd kernel:  [<c023a255>] __do_softirq+0x85/0x110
Mar 13 17:21:32 amd kernel:  [<c023a30d>] do_softirq+0x2d/0x40
Mar 13 17:21:32 amd kernel:  [<c06895da>] netif_rx_ni+0x1a/0x20
Mar 13 17:21:32 amd kernel:  [<c0734c33>] bnep_session+0x2c3/0x820
Mar 13 17:21:32 amd kernel:  [<c07ad6ad>] ? _raw_spin_unlock_irq+0x1d/0x30
Mar 13 17:21:32 amd kernel:  [<c02305e0>] ? default_wake_function+0x0/0x10
Mar 13 17:21:32 amd kernel:  [<c0734970>] ? bnep_session+0x0/0x820
Mar 13 17:21:32 amd kernel:  [<c02030f6>] kernel_thread_helper+0x6/0x10
Mar 13 17:21:33 amd su[2507]: unknown configuration item `FAIL_DELAY'
Mar 13 17:21:33 amd su[2507]: unknown configuration item `DIALUPS_CHECK_ENAB'
Mar 13 17:21:33 amd su[2507]: unknown configuration item `LASTLOG_ENAB'
Mar 13 17:21:33 amd su[2507]: unknown configuration item `MAIL_CHECK_ENAB'
Mar 13 17:21:33 amd su[2507]: unknown configuration item `OBSCURE_CHECKS_ENAB'
Mar 13 17:21:33 amd su[2507]: unknown configuration item `PORTTIME_CHECKS_ENAB'
Mar 13 17:21:33 amd su[2507]: unknown configuration item `QUOTAS_ENAB'
Mar 13 17:21:33 amd su[2507]: unknown configuration item `NO_PASSWORD_CONSOLE'
Mar 13 17:21:33 amd su[2507]: unknown configuration item `MOTD_FILE'
Mar 13 17:21:33 amd su[2507]: unknown configuration item `NOLOGINS_FILE'
Mar 13 17:21:33 amd su[2507]: unknown configuration item `NOLOGIN_STR'
Mar 13 17:21:33 amd su[2507]: unknown configuration item `ENV_HZ'
Mar 13 17:21:33 amd su[2507]: unknown configuration item `ULIMIT'
Mar 13 17:21:33 amd su[2507]: unknown configuration item `PASS_MIN_LEN'
Mar 13 17:21:33 amd su[2507]: unknown configuration item `SU_WHEEL_ONLY'
Mar 13 17:21:33 amd su[2507]: unknown configuration item `PASS_CHANGE_TRIES'
Mar 13 17:21:33 amd su[2507]: unknown configuration item `PASS_ALWAYS_WARN'
Mar 13 17:21:33 amd su[2507]: unknown configuration item `CHFN_AUTH'
Mar 13 17:21:33 amd su[2507]: Successful su for root by root
Mar 13 17:21:33 amd su[2507]: + /dev/ttyp3 root:root
Mar 13 17:21:33 amd su[2507]: pam_unix(su:session): session opened for user root by (uid=0)
Mar 13 17:21:37 amd pand[2532]: Bluetooth PAN daemon version 4.57
Mar 13 17:21:37 amd pand[2532]: Connecting to 00:21:BA:FF:2D:37
Mar 13 17:21:37 amd pand[2532]: Connect to 00:21:BA:FF:2D:37 failed. File exists(17)
Mar 13 17:22:58 amd syslogd 1.5.0#5: restart.
Mar 13 17:22:58 amd kernel: klogd 1.5.0#5, log source = /proc/kmsg started.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
