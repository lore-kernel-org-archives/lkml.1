Return-Path: <linux-kernel-owner+w=401wt.eu-S1755513AbYAHAwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbYAHAwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 19:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbYAHAwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 19:52:11 -0500
Received: from smtp.nokia.com ([192.100.122.230]:23695 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbYAHAwK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 19:52:10 -0500
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: WARNING: at kernel/softirq.c:139 local_bh_enable()
Date: Mon, 7 Jan 2008 18:51:46 -0600
Message-ID: <2198383E1141814486F0B881B3260CF501D6BB66@daebe103.NOE.Nokia.com>
In-Reply-To: <2198383E1141814486F0B881B3260CF513A145@daebe103.NOE.Nokia.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: WARNING: at kernel/softirq.c:139 local_bh_enable()
Thread-Index: AchRkAAxDpCHlZG2S22sPUN2l+cIFAAAE22w
From: <Jayakrishnan.Chathu@nokia.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 08 Jan 2008 00:51:47.0103 (UTC) FILETIME=[A5554AF0:01C85190]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  
Hi,

I am running 2.6.23 kernel on a DUAL core and QUAD core i386 boxes and
after everyboot, when the ethernet traffic starts i get this warning.

All the ports in the system are e1000 and i am using the kernel e1000
driver.

Jan  7 22:31:00 localhost [warning] WARNING: at kernel/softirq.c:139
local_bh_enable() 
Jan  7 22:31:00 localhost [warning] [<c012bd0f>]
local_bh_enable+0x49/0xa9 
Jan  7 22:31:00 localhost [warning] [<c039ba1a>]
dev_queue_xmit+0x26c/0x275 
Jan  7 22:31:00 localhost [warning] [<c03cdf6c>] arp_xmit+0x4d/0x51 
Jan  7 22:31:00 localhost [warning] [<c03cd9f6>] arp_solicit+0x156/0x174

Jan  7 22:31:00 localhost [warning] [<c03a047f>]
neigh_timer_handler+0x1e0/0x224 
Jan  7 22:31:00 localhost [warning] [<c012f820>]
run_timer_softirq+0x113/0x172 
Jan  7 22:31:00 localhost [warning] [<c013b042>] WARNING: at
kernel/softirq.c:139 local_bh_enable() 
Jan  7 22:31:00 localhost [warning] hrtimer_interrupt+0x19c/0x1c4 
Jan  7 22:31:00 localhost [warning] [<c014002a>]  [<c012bd0f>]
local_bh_enable+0x49/0xa9 
Jan  7 22:31:00 localhost [warning] [<c039ba1a>]
dev_queue_xmit+0x26c/0x275 
Jan  7 22:31:00 localhost [warning] [<c03a0c05>]
neigh_resolve_output+0x12c/0x15e 
Jan  7 22:31:00 localhost [warning] [<c03a0881>]
neigh_update+0x246/0x2cb 
Jan  7 22:31:00 localhost [warning] [<c039fb21>] neigh_lookup+0xa9/0xb3 
Jan  7 22:31:00 localhost [warning] [<c03ce410>] arp_process+0x43c/0x477

Jan  7 22:31:00 localhost [warning] [<c0120b73>]
enqueue_task_fair+0x2d/0x30 
Jan  7 22:31:00 localhost [warning] tick_sched_timer+0x0/0xba 
Jan  7 22:31:00 localhost [warning] [<c03ce554>] arp_rcv+0x104/0x119 
Jan  7 22:31:00 localhost [warning] [<c03a029f>]  [<c039bda6>]
netif_receive_skb+0x1c5/0x1de 
Jan  7 22:31:00 localhost [warning] [<f897a61d>]
e1000_clean_rx_irq+0x40e/0x4ca [e1000] 
Jan  7 22:31:00 localhost [warning] [<c013bdc6>]
getnstimeofday+0x36/0x10c 
Jan  7 22:31:00 localhost [warning] neigh_timer_handler+0x0/0x224 
Jan  7 22:31:00 localhost [warning] [<c012be12>] __do_softirq+0x60/0xc1 
Jan  7 22:31:00 localhost [warning] [<f8979e34>] e1000_clean+0x74/0x119
[e1000] 
Jan  7 22:31:00 localhost [warning] [<c039bf03>]  [<c012bea4>]
net_rx_action+0x5a/0xd3 
Jan  7 22:31:00 localhost [warning] [<c012be12>] __do_softirq+0x60/0xc1 
Jan  7 22:31:00 localhost [warning] do_softirq+0x31/0x35 
Jan  7 22:31:00 localhost [warning] [<c012bea4>] do_softirq+0x31/0x35 
Jan  7 22:31:00 localhost [warning] [<c012bf03>] irq_exit+0x38/0x6b 
Jan  7 22:31:00 localhost [warning] [<c0106a1e>]  [<c012bf03>]
do_IRQ+0x80/0x93 
Jan  7 22:31:00 localhost [warning] irq_exit+0x38/0x6b 
Jan  7 22:31:00 localhost [warning] [<c01057b7>]
common_interrupt+0x23/0x28 
Jan  7 22:31:00 localhost [warning] [<c01600d8>]  [<c011a34d>]
get_swap_page+0xe7/0x215 
Jan  7 22:31:00 localhost [warning] [<c0103232>]
mwait_idle_with_hints+0x34/0x38 Jan  7 22:31:00 localhost [warning]
[<c0103236>] mwait_idle+0x0/0xa 
Jan  7 22:31:00 localhost [warning] [<c01030f2>] cpu_idle+0x98/0xb9 
Jan  7 22:31:00 localhost [warning] smp_apic_timer_interrupt+0x2c/0x35
Jan  7 22:31:00 localhost [warning] ======================= 
Jan  7 22:31:00 localhost [warning] [<c0105874>]
apic_timer_interrupt+0x28/0x30 
Jan  7 22:31:00 localhost [warning] [<c01600d8>]
get_swap_page+0xe7/0x215 
Jan  7 22:31:00 localhost [warning] [<c0103232>]
mwait_idle_with_hints+0x34/0x38 
Jan  7 22:31:00 localhost [warning] [<c0103236>] mwait_idle+0x0/0xa 
Jan  7 22:31:00 localhost [warning] [<c01030f2>] cpu_idle+0x98/0xb9 
Jan  7 22:31:00 localhost [warning] =======================


Thanks
Jayakrishnan Chathu
