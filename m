Return-Path: <linux-kernel-owner+w=401wt.eu-S932103AbZKJWeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103AbZKJWeM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 17:34:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758534AbZKJWeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 17:34:12 -0500
Received: from n14.bullet.mail.mud.yahoo.com ([68.142.206.41]:20696 "HELO
	n14.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758530AbZKJWeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 17:34:06 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 256498.9531.bm@omp419.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=s0Gv6j/G7aZxAJ8CO3jkx53H6z7Qt59szGQUSoQThWUxUbTqOdCbm0fWV+ZvOx6Tc2EOtbBW6jY8RJeOjRirFPQ09Nmf7D6NYRNynmXatgeUzHzhkMWS4a1UyjalJY/pyZkMUoPVsc6pZyQgJDagHPx9U7lE9qjM0mOzGmwu1Ek=;
Message-ID: <663369.22104.qm@web111904.mail.gq1.yahoo.com>
X-YMail-OSG: W8cySc8VM1khTx_w8bSl5e.aaDg6OBkr8FtFMoXKes25r8mjpgTPXH3PvmZElqtx5rmQSodJXqDkL4KvEbgCCncli225X7PwNIvEzWpWcXJKL692SvN_78E.xYQ3IcAdxyUq5Rl1LLzDHp8jSwa18iMDwx1dOruUXQS30vP4IrHhpL46CEhD5BPj_2FfETLgBC.RE6bt15gW7aGG9tLvpg4LS5_agy9ImGaMVC.9vsrj4oY.pQTOlYlC.dmmlFI9hjKO
X-Mailer: YahooMailClassic/8.1.6 YahooMailWebService/0.7.361.4
Date: Tue, 10 Nov 2009 14:34:11 -0800 (PST)
From: "Chris ." <rabufans@yahoo.com>
Subject: kernel oops in 2.6.29.6
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've been getting the following oops on 2.6.29.6 every day or so on a server that handles about 200Mb of NAT and outbound routing. Right now I'm testing 2.6.31.6 to see if I get the same.

Let me know if you'd like any more information.

Regards,
 Rabu

BUG: unable to handle kernel NULL pointer dereference at 00000000000000ac
IP: [<ffffffff812f8905>] ip_rcv_finish+0x35/0x380
PGD 0 
Oops: 0000 [#1] SMP 
last sysfs file: /sys/module/nf_conntrack/parameters/hashsize
CPU 2 
Modules linked in: nfs lockd nfs_acl auth_rpcgss autofs4 ipt_REJECT ipt_LOG xt_NOTRACK iptable_raw xt_mark iptable_nat nf_nat xt_CONNMARK nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_statistic xt_MARK iptable_filter iptable_mangle ip_tables x_tables sunrpc ipv6 loop nf_conntrack ip_vs_ftp ip_vs iTCO_wdt iTCO_vendor_support pcspkr ipmi_si i5k_amb bnx2 i5000_edac edac_core igb shpchp dca
Pid: 0, comm: swapper Not tainted 2.6.29.6.x86_64 #1 ProLiant DL360 G5
RIP: 0010:[<ffffffff812f8905>]  [<ffffffff812f8905>] ip_rcv_finish+0x35/0x380
RSP: 0018:ffff88012e62bcc0  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8800c0c86020 RCX: ffff88011ea8cd80
RDX: ffff88012e6d4280 RSI: 00000000000ad2e8 RDI: ffff880127d11f00
RBP: ffff88012e62bcf0 R08: 0000000008d3c33c R09: ffff88010e6ce300
R10: 0000000000000001 R11: 0000000000000000 R12: ffff880114d8b800
R13: ffff88012b0fa000 R14: 0000000000000008 R15: ffff88012b0fa000
FS:  0000000000000000(0000) GS:ffff88012e476880(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00000000000000ac CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff88012e626000, task ffff88012e5f5880)
Stack:
 ffffffff815533c0 ffffffff815527e0 ffffffff815527e0 ffff880114d8b800
 ffff88012b0fa000 0000000000000008 ffff88012e62bd20 ffffffff812f91d7
 ffff880180000000 ffffffff815527e0 ffff880114d8b800 ffffffff81552820
Call Trace:
 <IRQ> <0> [<ffffffff812f91d7>] ip_rcv+0x207/0x300
 [<ffffffff812d5111>] netif_receive_skb+0x291/0x4e0
 [<ffffffff812d82de>] napi_gro_receive+0x2e/0x60
 [<ffffffffa0019ea8>] igb_poll+0x5b8/0xce0 [igb]
 [<ffffffff81364a79>] ? _spin_lock+0x9/0x10
 [<ffffffff810d3f1f>] ? add_partial+0x4f/0x90
 [<ffffffff812d7dd9>] net_rx_action+0xc9/0x160
 [<ffffffff810195c2>] ? native_sched_clock+0x22/0x80
 [<ffffffff81052deb>] __do_softirq+0x9b/0x150
 [<ffffffff8101379c>] call_softirq+0x1c/0x30
 [<ffffffff81015426>] do_softirq+0x56/0xa0
 [<ffffffff81052d3b>] irq_exit+0x7b/0x90
 [<ffffffff810154f6>] do_IRQ+0x86/0x100
 [<ffffffff81012f13>] ret_from_intr+0x0/0x29
 <EOI> <0> [<ffffffff811ea6ad>] ? acpi_idle_enter_bm+0x291/0x309
 [<ffffffff811ea6a5>] ? acpi_idle_enter_bm+0x289/0x309
 [<ffffffff812af062>] ? cpuidle_idle_call+0x92/0xe0
 [<ffffffff81010f67>] ? cpu_idle+0x57/0x90
 [<ffffffff8135e45c>] ? start_secondary+0x16c/0x1c0
Code: 65 e8 48 89 5d e0 49 89 fc 4c 89 6d f0 4c 89 75 f8 48 8b 47 28 8b 9f c0 00 00 00 48 03 9f d0 00 00 00 48 85 c0 0f 84 5d 01 00 00 <8b> b0 ac 00 00 00 85 f6 0f 85 4d 02 00 00 0f b6 03 83 e0 0f 0f 
RIP  [<ffffffff812f8905>] ip_rcv_finish+0x35/0x380
 RSP <ffff88012e62bcc0>
CR2: 00000000000000ac
BUG: unable to handle kernel <4>---[ end trace 83d442f9df2f6d46 ]---
Kernel panic - not syncing: Fatal exception in interrupt
NULL pointer dereference at 00000000000000ac
IP: [<ffffffff812f8905>] ip_rcv_finish+0x35/0x380
PGD 0 
Oops: 0000 [#2] SMP 
last sysfs file: /sys/module/nf_conntrack/parameters/hashsize
CPU 3 
Modules linked in: nfs lockd nfs_acl auth_rpcgss autofs4 ipt_REJECT ipt_LOG xt_NOTRACK iptable_raw xt_mark iptable_nat nf_nat xt_CONNMARK nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_statistic xt_MARK iptable_filter iptable_mangle ip_tables x_tables sunrpc ipv6 loop nf_conntrack ip_vs_ftp ip_vs iTCO_wdt iTCO_vendor_support pcspkr ipmi_si i5k_amb bnx2 i5000_edac edac_core igb shpchp dca
Pid: 0, comm: swapper Tainted: G      D    2.6.29.6.x86_64 #1 ProLiant DL360 G5
RIP: 0010:[<ffffffff812f8905>]  [<ffffffff812f8905>] ip_rcv_finish+0x35/0x380
RSP: 0018:ffff88012e663cc0  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8800c16ec020 RCX: ffff88011565a180
RDX: ffff88012e6d4280 RSI: 00000000000ad2e8 RDI: ffff880127d11f00
RBP: ffff88012e663cf0 R08: 000000008c7835dd R09: ffff880111f62480
R10: 0000000000000002 R11: 0000000000000002 R12: ffff88011556f300
R13: ffff88012b0fa000 R14: 0000000000000008 R15: ffff88012b0fa000
FS:  0000000000000000(0000) GS:ffff88012e476d00(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00000000000000ac CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff88012e65c000, task ffff88012e652c40)
Stack:
 ffffffff815533c0 ffffffff815527e0 ffffffff815527e0 ffff88011556f300
 ffff88012b0fa000 0000000000000008 ffff88012e663d20 ffffffff812f91d7
 ffff880180000000 ffffffff815527e0 ffff88011556f300 ffffffff81552820
Call Trace:
 <IRQ> <0> [<ffffffff812f91d7>] ip_rcv+0x207/0x300
 [<ffffffff812d5111>] netif_receive_skb+0x291/0x4e0
 [<ffffffff812d82de>] napi_gro_receive+0x2e/0x60
 [<ffffffffa0019ea8>] igb_poll+0x5b8/0xce0 [igb]
 [<ffffffff812d7dd9>] net_rx_action+0xc9/0x160
 [<ffffffff810195c2>] ? native_sched_clock+0x22/0x80
 [<ffffffff81052deb>] __do_softirq+0x9b/0x150
 [<ffffffff8101379c>] call_softirq+0x1c/0x30
 [<ffffffff81015426>] do_softirq+0x56/0xa0
 [<ffffffff81052d3b>] irq_exit+0x7b/0x90
 [<ffffffff810154f6>] do_IRQ+0x86/0x100
 [<ffffffff81012f13>] ret_from_intr+0x0/0x29
 <EOI> <0> [<ffffffff811ea6ad>] ? acpi_idle_enter_bm+0x291/0x309
 [<ffffffff811ea6a5>] ? acpi_idle_enter_bm+0x289/0x309
 [<ffffffff812af062>] ? cpuidle_idle_call+0x92/0xe0
 [<ffffffff81010f67>] ? cpu_idle+0x57/0x90
 [<ffffffff8135e45c>] ? start_secondary+0x16c/0x1c0
Code: 65 e8 48 89 5d e0 49 89 fc 4c 89 6d f0 4c 89 75 f8 48 8b 47 28 8b 9f c0 00 00 00 48 03 9f d0 00 00 00 48 85 c0 0f 84 5d 01 00 00 <8b> b0 ac 00 00 00 85 f6 0f 85 4d 02 00 00 0f b6 03 83 e0 0f 0f 
RIP  [<ffffffff812f8905>] ip_rcv_finish+0x35/0x380
 RSP <ffff88012e663cc0>
CR2: 00000000000000ac
BUG: unable to handle kernel NULL pointer dereference at 00000000000000ac
IP: [<ffffffff812f8905>] ip_rcv_finish+0x35/0x380
PGD 0 
Oops: 0000 [#3] SMP 
last sysfs file: /sys/module/nf_conntrack/parameters/hashsize
CPU 1 
Modules linked in: nfs lockd nfs_acl auth_rpcgss autofs4 ipt_REJECT ipt_LOG xt_NOTRACK iptable_raw xt_mark iptable_nat nf_nat xt_CONNMARK nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_statistic xt_MARK iptable_filter iptable_mangle ip_tables x_tables sunrpc ipv6 loop nf_conntrack ip_vs_ftp ip_vs iTCO_wdt iTCO_vendor_support pcspkr ipmi_si i5k_amb bnx2 i5000_edac edac_core igb shpchp dca
Pid: 0, comm: swapper Tainted: G      D    2.6.29.6.x86_64 #1 ProLiant DL360 G5
RIP: 0010:[<ffffffff812f8905>]  [<ffffffff812f8905>] ip_rcv_finish+0x35/0x380
RSP: 0018:ffff88012e5fbcc0  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8800c2109020 RCX: ffff8801102f4600
RDX: ffff88012e6d4280 RSI: 00000000000ad2e8 RDI: ffff880127d11f00
RBP: ffff88012e5fbcf0 R08: 00000000f291afc0 R09: ffff88011d9ab380
R10: 0000000000000001 R11: 0000000000000000 R12: ffff88010c076100
R13: ffff88012b0fa000 R14: 0000000000000008 R15: ffff88012b0fa000
FS:  0000000000000000(0000) GS:ffff88012e476400(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00000000000000ac CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff88012e5ee000, task ffff88012e5f1620)
Stack:
 ffffffff815533c0 ffffffff815527e0 ffffffff815527e0 ffff88010c076100
 ffff88012b0fa000 0000000000000008 ffff88012e5fbd20 ffffffff812f91d7
 ffff880180000000 ffffffff815527e0 ffff88010c076100 ffffffff81552820
Call Trace:
 <IRQ> <0> [<ffffffff812f91d7>] ip_rcv+0x207/0x300
 [<ffffffff812d5111>] netif_receive_skb+0x291/0x4e0
 [<ffffffff812d82de>] napi_gro_receive+0x2e/0x60
 [<ffffffffa0019ea8>] igb_poll+0x5b8/0xce0 [igb]
 [<ffffffff81364a79>] ? _spin_lock+0x9/0x10
 [<ffffffff810d3f1f>] ? add_partial+0x4f/0x90
 [<ffffffff812d7dd9>] net_rx_action+0xc9/0x160
 [<ffffffff810195c2>] ? native_sched_clock+0x22/0x80
 [<ffffffff81052deb>] __do_softirq+0x9b/0x150
 [<ffffffff8101379c>] call_softirq+0x1c/0x30
 [<ffffffff81015426>] do_softirq+0x56/0xa0
 [<ffffffff81052d3b>] irq_exit+0x7b/0x90
 [<ffffffff810154f6>] do_IRQ+0x86/0x100
 [<ffffffff81012f13>] ret_from_intr+0x0/0x29
 <EOI> <0> [<ffffffff811ea6ad>] ? acpi_idle_enter_bm+0x291/0x309
 [<ffffffff811ea6a5>] ? acpi_idle_enter_bm+0x289/0x309
 [<ffffffff812af062>] ? cpuidle_idle_call+0x92/0xe0
 [<ffffffff81010f67>] ? cpu_idle+0x57/0x90
 [<ffffffff8135e45c>] ? start_secondary+0x16c/0x1c0
Code: 65 e8 48 89 5d e0 49 89 fc 4c 89 6d f0 4c 89 75 f8 48 8b 47 28 8b 9f c0 00 00 00 48 03 9f d0 00 00 00 48 85 c0 0f 84 5d 01 00 00 <8b> b0 ac 00 00 00 85 f6 0f 85 4d 02 00 00 0f b6 03 83 e0 0f 0f 
RIP  [<ffffffff812f8905>] ip_rcv_finish+0x35/0x380
 RSP <ffff88012e5fbcc0>
CR2: 00000000000000ac
BUG: unable to handle kernel NULL pointer dereference at 00000000000000ac
IP: [<ffffffff812f8905>] ip_rcv_finish+0x35/0x380
PGD 0 
Oops: 0000 [#4] SMP 
last sysfs file: /sys/module/nf_conntrack/parameters/hashsize
CPU 0 
Modules linked in: nfs lockd nfs_acl auth_rpcgss autofs4 ipt_REJECT ipt_LOG xt_NOTRACK iptable_raw xt_mark iptable_nat nf_nat xt_CONNMARK nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_statistic xt_MARK iptable_filter iptable_mangle ip_tables x_tables sunrpc ipv6 loop nf_conntrack ip_vs_ftp ip_vs iTCO_wdt iTCO_vendor_support pcspkr ipmi_si i5k_amb bnx2 i5000_edac edac_core igb shpchp dca
Pid: 0, comm: swapper Tainted: G      D    2.6.29.6.x86_64 #1 ProLiant DL360 G5
RIP: 0010:[<ffffffff812f8905>]  [<ffffffff812f8905>] ip_rcv_finish+0x35/0x380
RSP: 0018:ffffffff816f4cc0  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8800c61fb020 RCX: ffff88011be68f00
RDX: ffff88012e6d4280 RSI: 00000000000ad2e8 RDI: ffff880127d11f00
RBP: ffffffff816f4cf0 R08: 000000002717843b R09: ffff8800ceee0c00
R10: 0000000000000002 R11: 0000000000000002 R12: ffff88011cdad300
R13: ffff88012b0fa000 R14: 0000000000000008 R15: ffff88012b0fa000
FS:  0000000000000000(0000) GS:ffffffff816fd000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00000000000000ac CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffffffff81556000, task ffffffff814cc360)
Stack:
 ffffffff815533c0 ffffffff815527e0 ffffffff815527e0 ffff88011cdad300
 ffff88012b0fa000 0000000000000008 ffffffff816f4d20 ffffffff812f91d7
 ffffffff80000000 ffffffff815527e0 ffff88011cdad300 ffffffff81552820
Call Trace:
 <IRQ> <0> [<ffffffff812f91d7>] ip_rcv+0x207/0x300
 [<ffffffff812d5111>] netif_receive_skb+0x291/0x4e0
 [<ffffffff812d82de>] napi_gro_receive+0x2e/0x60
 [<ffffffffa0019ea8>] igb_poll+0x5b8/0xce0 [igb]
 [<ffffffff8106d155>] ? tick_broadcast_set_event+0x15/0x20
 [<ffffffff8106d84a>] ? tick_handle_oneshot_broadcast+0xea/0x100
 [<ffffffff812d7dd9>] net_rx_action+0xc9/0x160
 [<ffffffff810195c2>] ? native_sched_clock+0x22/0x80
 [<ffffffff81052deb>] __do_softirq+0x9b/0x150
 [<ffffffff8101379c>] call_softirq+0x1c/0x30
 [<ffffffff81015426>] do_softirq+0x56/0xa0
 [<ffffffff81052d3b>] irq_exit+0x7b/0x90
 [<ffffffff810154f6>] do_IRQ+0x86/0x100
 [<ffffffff81012f13>] ret_from_intr+0x0/0x29
 <EOI> <0> [<ffffffff811ea6ad>] ? acpi_idle_enter_bm+0x291/0x309
 [<ffffffff811ea6a5>] ? acpi_idle_enter_bm+0x289/0x309
 [<ffffffff812af062>] ? cpuidle_idle_call+0x92/0xe0
 [<ffffffff81010f67>] ? cpu_idle+0x57/0x90
 [<ffffffff8134dd66>] ? rest_init+0x66/0x70
Code: 65 e8 48 89 5d e0 49 89 fc 4c 89 6d f0 4c 89 75 f8 48 8b 47 28 8b 9f c0 00 00 00 48 03 9f d0 00 00 00 48 85 c0 0f 84 5d 01 00 00 <8b> b0 ac 00 00 00 85 f6 0f 85 4d 02 00 00 0f b6 03 83 e0 0f 0f 
RIP  [<ffffffff812f8905>] ip_rcv_finish+0x35/0x380
 RSP <ffffffff816f4cc0>
CR2: 00000000000000ac
BUG: unable to handle kernel NULL pointer dereference at 00000000000000ac
IP: [<ffffffff812f8905>] ip_rcv_finish+0x35/0x380
PGD 0 
Oops: 0000 [#5] SMP 
last sysfs file: /sys/module/nf_conntrack/parameters/hashsize
CPU 7 
Modules linked in: nfs lockd nfs_acl auth_rpcgss autofs4 ipt_REJECT ipt_LOG xt_NOTRACK iptable_raw xt_mark iptable_nat nf_nat xt_CONNMARK nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_statistic xt_MARK iptable_filter iptable_mangle ip_tables x_tables sunrpc ipv6 loop nf_conntrack ip_vs_ftp ip_vs iTCO_wdt iTCO_vendor_support pcspkr ipmi_si i5k_amb bnx2 i5000_edac edac_core igb shpchp dca
Pid: 0, comm: swapper Tainted: G      D    2.6.29.6.x86_64 #1 ProLiant DL360 G5
RIP: 0010:[<ffffffff812f8905>]  [<ffffffff812f8905>] ip_rcv_finish+0x35/0x380
RSP: 0018:ffff88012e737cc0  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8800c4899020 RCX: ffff88011006d500
RDX: ffff88012e6d4280 RSI: 00000000000ad2e8 RDI: ffff880127d11f00
RBP: ffff88012e737cf0 R08: 0000000035be5139 R09: ffff88010a2a9500
R10: 0000000000000002 R11: 0000000000000002 R12: ffff88010eb17000
R13: ffff88012b0fa000 R14: 0000000000000008 R15: ffff88012b0fa000
FS:  0000000000000000(0000) GS:ffff88012e5e0f00(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00000000000000ac CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff88012e730000, task ffff88012e6fd880)
Stack:
 ffffffff815533c0 ffffffff815527e0 ffffffff815527e0 ffff88010eb17000
 ffff88012b0fa000 0000000000000008 ffff88012e737d20 ffffffff812f91d7
 ffff880180000000 ffffffff815527e0 ffff88010eb17000 ffffffff81552820
Call Trace:
 <IRQ> <0> [<ffffffff812f91d7>] ip_rcv+0x207/0x300
 [<ffffffff812d5111>] netif_receive_skb+0x291/0x4e0
 [<ffffffff812d82de>] napi_gro_receive+0x2e/0x60
 [<ffffffffa0019ea8>] igb_poll+0x5b8/0xce0 [igb]
 [<ffffffff812d7dd9>] net_rx_action+0xc9/0x160
 [<ffffffff810195c2>] ? native_sched_clock+0x22/0x80
 [<ffffffff81052deb>] __do_softirq+0x9b/0x150
 [<ffffffff8101379c>] call_softirq+0x1c/0x30
 [<ffffffff81015426>] do_softirq+0x56/0xa0
 [<ffffffff81052d3b>] irq_exit+0x7b/0x90
 [<ffffffff810154f6>] do_IRQ+0x86/0x100
 [<ffffffff81012f13>] ret_from_intr+0x0/0x29
 <EOI> <0> [<ffffffff811ea6ad>] ? acpi_idle_enter_bm+0x291/0x309
 [<ffffffff811ea6a5>] ? acpi_idle_enter_bm+0x289/0x309
 [<ffffffff812af062>] ? cpuidle_idle_call+0x92/0xe0
 [<ffffffff81010f67>] ? cpu_idle+0x57/0x90
 [<ffffffff8135e45c>] ? start_secondary+0x16c/0x1c0
Code: 65 e8 48 89 5d e0 49 89 fc 4c 89 6d f0 4c 89 75 f8 48 8b 47 28 8b 9f c0 00 00 00 48 03 9f d0 00 00 00 48 85 c0 0f 84 5d 01 00 00 <8b> b0 ac 00 00 00 85 f6 0f 85 4d 02 00 00 0f b6 03 83 e0 0f 0f 
RIP  [<ffffffff812f8905>] ip_rcv_finish+0x35/0x380
 RSP <ffff88012e737cc0>
CR2: 00000000000000ac
BUG: unable to handle kernel NULL pointer dereference at 00000000000000ac
IP: [<ffffffff812f8905>] ip_rcv_finish+0x35/0x380
PGD 0 
Oops: 0000 [#6] SMP 
last sysfs file: /sys/module/nf_conntrack/parameters/hashsize
CPU 5 
Modules linked in: nfs lockd nfs_acl auth_rpcgss autofs4 ipt_REJECT ipt_LOG xt_NOTRACK iptable_raw xt_mark iptable_nat nf_nat xt_CONNMARK nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_statistic xt_MARK iptable_filter iptable_mangle ip_tables x_tables sunrpc ipv6 loop nf_conntrack ip_vs_ftp ip_vs iTCO_wdt iTCO_vendor_support pcspkr ipmi_si i5k_amb bnx2 i5000_edac edac_core igb shpchp dca
Pid: 0, comm: swapper Tainted: G      D    2.6.29.6.x86_64 #1 ProLiant DL360 G5
RIP: 0010:[<ffffffff812f8905>]  [<ffffffff812f8905>] ip_rcv_finish+0x35/0x380
RSP: 0018:ffff88012e6cfcc0  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8800c11a1020 RCX: ffff88011f5bc000
RDX: ffff88012e6d4280 RSI: 00000000000ad2e8 RDI: ffff880127d11f00
RBP: ffff88012e6cfcf0 R08: 00000000f291afc0 R09: ffff88011ea8d200
R10: 0000000000000001 R11: 0000000000000000 R12: ffff88011a9af600
R13: ffff88012b0fa000 R14: 0000000000000008 R15: ffff88012b0fa000
FS:  0000000000000000(0000) GS:ffff88012e5e0600(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00000000000000ac CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff88012e6ca000, task ffff88012e694260)
Stack:
 ffffffff815533c0 ffffffff815527e0 ffffffff815527e0 ffff88011a9af600
 ffff88012b0fa000 0000000000000008 ffff88012e6cfd20 ffffffff812f91d7
 ffff880180000000 ffffffff815527e0 ffff88011a9af600 ffffffff81552820
Call Trace:
 <IRQ> <0> [<ffffffff812f91d7>] ip_rcv+0x207/0x300
 [<ffffffff812d5111>] netif_receive_skb+0x291/0x4e0
 [<ffffffff812d82de>] napi_gro_receive+0x2e/0x60
 [<ffffffffa0019ea8>] igb_poll+0x5b8/0xce0 [igb]
 [<ffffffff812d7dd9>] net_rx_action+0xc9/0x160
 [<ffffffff810195c2>] ? native_sched_clock+0x22/0x80
 [<ffffffff81052deb>] __do_softirq+0x9b/0x150
 [<ffffffff8101379c>] call_softirq+0x1c/0x30
 [<ffffffff81015426>] do_softirq+0x56/0xa0
 [<ffffffff81052d3b>] irq_exit+0x7b/0x90
 [<ffffffff810154f6>] do_IRQ+0x86/0x100
 [<ffffffff81012f13>] ret_from_intr+0x0/0x29
 <EOI> <0> [<ffffffff811ea6ad>] ? acpi_idle_enter_bm+0x291/0x309
 [<ffffffff811ea6a5>] ? acpi_idle_enter_bm+0x289/0x309
 [<ffffffff812af062>] ? cpuidle_idle_call+0x92/0xe0
 [<ffffffff81010f67>] ? cpu_idle+0x57/0x90
 [<ffffffff8135e45c>] ? start_secondary+0x16c/0x1c0
Code: 65 e8 48 89 5d e0 49 89 fc 4c 89 6d f0 4c 89 75 f8 48 8b 47 28 8b 9f c0 00 00 00 48 03 9f d0 00 00 00 48 85 c0 0f 84 5d 01 00 00 <8b> b0 ac 00 00 00 85 f6 0f 85 4d 02 00 00 0f b6 03 83 e0 0f 0f 
RIP  [<ffffffff812f8905>] ip_rcv_finish+0x35/0x380
 RSP <ffff88012e6cfcc0>
CR2: 00000000000000ac
BUG: unable to handle kernel NULL pointer dereference at 00000000000000ac
IP: [<ffffffff812f8905>] ip_rcv_finish+0x35/0x380
PGD 0 
Oops: 0000 [#7] SMP 
last sysfs file: /sys/module/nf_conntrack/parameters/hashsize
CPU 4 
Modules linked in: nfs lockd nfs_acl auth_rpcgss autofs4 ipt_REJECT ipt_LOG xt_NOTRACK iptable_raw xt_mark iptable_nat nf_nat xt_CONNMARK nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_statistic xt_MARK iptable_filter iptable_mangle ip_tables x_tables sunrpc ipv6 loop nf_conntrack ip_vs_ftp ip_vs iTCO_wdt iTCO_vendor_support pcspkr ipmi_si i5k_amb bnx2 i5000_edac edac_core igb shpchp dca
Pid: 0, comm: swapper Tainted: G      D    2.6.29.6.x86_64 #1 ProLiant DL360 G5
RIP: 0010:[<ffffffff812f8905>]  [<ffffffff812f8905>] ip_rcv_finish+0x35/0x380
RSP: 0018:ffff88012e69bcc0  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8800c3d5f020 RCX: ffff8800280621f8
RDX: ffff88012e6d4280 RSI: 00000000000ad2e8 RDI: ffff880127d11f00
RBP: ffff88012e69bcf0 R08: 00000000f291afc0 R09: ffff88011787d380
R10: 0000000000000001 R11: 0000000000000000 R12: ffff880100a58c00
R13: ffff88012b0fa000 R14: 0000000000000008 R15: ffff88012b0fa000
FS:  0000000000000000(0000) GS:ffff88012e5e0180(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00000000000000ac CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff88012e68c000, task ffff88012e690000)
Stack:
 ffffffff815533c0 ffffffff815527e0 ffffffff815527e0 ffff880100a58c00
 ffff88012b0fa000 0000000000000008 ffff88012e69bd20 ffffffff812f91d7
 ffff880180000000 ffffffff815527e0 ffff880100a58c00 ffffffff81552820
Call Trace:
 <IRQ> <0> [<ffffffff812f91d7>] ip_rcv+0x207/0x300
 [<ffffffff812d5111>] netif_receive_skb+0x291/0x4e0
 [<ffffffff812d82de>] napi_gro_receive+0x2e/0x60
 [<ffffffffa0019ea8>] igb_poll+0x5b8/0xce0 [igb]
 [<ffffffff812d7dd9>] net_rx_action+0xc9/0x160
 [<ffffffff810195c2>] ? native_sched_clock+0x22/0x80
 [<ffffffff81052deb>] __do_softirq+0x9b/0x150
 [<ffffffff8101379c>] call_softirq+0x1c/0x30
 [<ffffffff81015426>] do_softirq+0x56/0xa0
 [<ffffffff81052d3b>] irq_exit+0x7b/0x90
 [<ffffffff810154f6>] do_IRQ+0x86/0x100
 [<ffffffff81012f13>] ret_from_intr+0x0/0x29
 <EOI> <0> [<ffffffff811ea6ad>] ? acpi_idle_enter_bm+0x291/0x309
 [<ffffffff811ea6a5>] ? acpi_idle_enter_bm+0x289/0x309
 [<ffffffff812af062>] ? cpuidle_idle_call+0x92/0xe0
 [<ffffffff81010f67>] ? cpu_idle+0x57/0x90
 [<ffffffff8135e45c>] ? start_secondary+0x16c/0x1c0
Code: 65 e8 48 89 5d e0 49 89 fc 4c 89 6d f0 4c 89 75 f8 48 8b 47 28 8b 9f c0 00 00 00 48 03 9f d0 00 00 00 48 85 c0 0f 84 5d 01 00 00 <8b> b0 ac 00 00 00 85 f6 0f 85 4d 02 00 00 0f b6 03 83 e0 0f 0f 
RIP  [<ffffffff812f8905>] ip_rcv_finish+0x35/0x380
 RSP <ffff88012e69bcc0>
CR2: 00000000000000ac
BUG: unable to handle kernel NULL pointer dereference at 00000000000000ac
IP: [<ffffffff812f8905>] ip_rcv_finish+0x35/0x380
PGD 0 
Oops: 0000 [#8] SMP 
last sysfs file: /sys/module/nf_conntrack/parameters/hashsize
CPU 6 
Modules linked in: nfs lockd nfs_acl auth_rpcgss autofs4 ipt_REJECT ipt_LOG xt_NOTRACK iptable_raw xt_mark iptable_nat nf_nat xt_CONNMARK nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_statistic xt_MARK iptable_filter iptable_mangle ip_tables x_tables sunrpc ipv6 loop nf_conntrack ip_vs_ftp ip_vs iTCO_wdt iTCO_vendor_support pcspkr ipmi_si i5k_amb bnx2 i5000_edac edac_core igb shpchp dca
Pid: 0, comm: swapper Tainted: G      D    2.6.29.6.x86_64 #1 ProLiant DL360 G5
RIP: 0010:[<ffffffff812f8905>]  [<ffffffff812f8905>] ip_rcv_finish+0x35/0x380
RSP: 0018:ffff88012e707cc0  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8800c20c6020 RCX: ffff8800ceee1200
RDX: ffff88012e6d4280 RSI: 00000000000ad2e8 RDI: ffff880127d11f00
RBP: ffff88012e707cf0 R08: 0000000080d73476 R09: ffff880111952600
R10: 0000000000000002 R11: 0000000000000002 R12: ffff88011fc77e00
R13: ffff88012b0fa000 R14: 0000000000000008 R15: ffff88012b0fa000
FS:  0000000000000000(0000) GS:ffff88012e5e0a80(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00000000000000ac CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff88012e702000, task ffff88012e6f9620)
Stack:
 ffffffff815533c0 ffffffff815527e0 ffffffff815527e0 ffff88011fc77e00
 ffff88012b0fa000 0000000000000008 ffff88012e707d20 ffffffff812f91d7
 ffff880180000000 ffffffff815527e0 ffff88011fc77e00 ffffffff81552820
Call Trace:
 <IRQ> <0> [<ffffffff812f91d7>] ip_rcv+0x207/0x300
 [<ffffffff812d5111>] netif_receive_skb+0x291/0x4e0
 [<ffffffff812d82de>] napi_gro_receive+0x2e/0x60
 [<ffffffffa0019ea8>] igb_poll+0x5b8/0xce0 [igb]
 [<ffffffff812d7dd9>] net_rx_action+0xc9/0x160
 [<ffffffff810195c2>] ? native_sched_clock+0x22/0x80
 [<ffffffff81052deb>] __do_softirq+0x9b/0x150
 [<ffffffff8101379c>] call_softirq+0x1c/0x30
 [<ffffffff81015426>] do_softirq+0x56/0xa0
 [<ffffffff81052d3b>] irq_exit+0x7b/0x90
 [<ffffffff810154f6>] do_IRQ+0x86/0x100
 [<ffffffff81012f13>] ret_from_intr+0x0/0x29
 <EOI> <0> [<ffffffff811ea6ad>] ? acpi_idle_enter_bm+0x291/0x309
 [<ffffffff811ea6a5>] ? acpi_idle_enter_bm+0x289/0x309
 [<ffffffff812af062>] ? cpuidle_idle_call+0x92/0xe0
 [<ffffffff81010f67>] ? cpu_idle+0x57/0x90
 [<ffffffff8135e45c>] ? start_secondary+0x16c/0x1c0
Code: 65 e8 48 89 5d e0 49 89 fc 4c 89 6d f0 4c 89 75 f8 48 8b 47 28 8b 9f c0 00 00 00 48 03 9f d0 00 00 00 48 85 c0 0f 84 5d 01 00 00 <8b> b0 ac 00 00 00 85 f6 0f 85 4d 02 00 00 0f b6 03 83 e0 0f 0f 
RIP  [<ffffffff812f8905>] ip_rcv_finish+0x35/0x380
 RSP <ffff88012e69bcc0>
CR2: 00000000000000ac
BUG: unable to handle kernel NULL pointer dereference at 00000000000000ac
IP: [<ffffffff812f8905>] ip_rcv_finish+0x35/0x380
PGD 0 
Oops: 0000 [#8] SMP 
last sysfs file: /sys/module/nf_conntrack/parameters/hashsize
CPU 6 
Modules linked in: nfs lockd nfs_acl auth_rpcgss autofs4 ipt_REJECT ipt_LOG xt_NOTRACK iptable_raw xt_mark iptable_nat nf_nat xt_CONNMARK nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_statistic xt_MARK iptable_filter iptable_mangle ip_tables x_tables sunrpc ipv6 loop nf_conntrack ip_vs_ftp ip_vs iTCO_wdt iTCO_vendor_support pcspkr ipmi_si i5k_amb bnx2 i5000_edac edac_core igb shpchp dca
Pid: 0, comm: swapper Tainted: G      D    2.6.29.6.x86_64 #1 ProLiant DL360 G5
RIP: 0010:[<ffffffff812f8905>]  [<ffffffff812f8905>] ip_rcv_finish+0x35/0x380
RSP: 0018:ffff88012e707cc0  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8800c20c6020 RCX: ffff8800ceee1200
RDX: ffff88012e6d4280 RSI: 00000000000ad2e8 RDI: ffff880127d11f00
RBP: ffff88012e707cf0 R08: 0000000080d73476 R09: ffff880111952600
R10: 0000000000000002 R11: 0000000000000002 R12: ffff88011fc77e00
R13: ffff88012b0fa000 R14: 0000000000000008 R15: ffff88012b0fa000
FS:  0000000000000000(0000) GS:ffff88012e5e0a80(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00000000000000ac CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff88012e702000, task ffff88012e6f9620)
Stack:
 ffffffff815533c0 ffffffff815527e0 ffffffff815527e0 ffff88011fc77e00
 ffff88012b0fa000 0000000000000008 ffff88012e707d20 ffffffff812f91d7
 ffff880180000000 ffffffff815527e0 ffff88011fc77e00 ffffffff81552820
Call Trace:
 <IRQ> <0> [<ffffffff812f91d7>] ip_rcv+0x207/0x300
 [<ffffffff812d5111>] netif_receive_skb+0x291/0x4e0
 [<ffffffff812d82de>] napi_gro_receive+0x2e/0x60
 [<ffffffffa0019ea8>] igb_poll+0x5b8/0xce0 [igb]
 [<ffffffff812d7dd9>] net_rx_action+0xc9/0x160
 [<ffffffff810195c2>] ? native_sched_clock+0x22/0x80
 [<ffffffff81052deb>] __do_softirq+0x9b/0x150
 [<ffffffff8101379c>] call_softirq+0x1c/0x30
 [<ffffffff81015426>] do_softirq+0x56/0xa0
 [<ffffffff81052d3b>] irq_exit+0x7b/0x90
 [<ffffffff810154f6>] do_IRQ+0x86/0x100
 [<ffffffff81012f13>] ret_from_intr+0x0/0x29
 <EOI> <0> [<ffffffff811ea6ad>] ? acpi_idle_enter_bm+0x291/0x309
 [<ffffffff811ea6a5>] ? acpi_idle_enter_bm+0x289/0x309
 [<ffffffff812af062>] ? cpuidle_idle_call+0x92/0xe0
 [<ffffffff81010f67>] ? cpu_idle+0x57/0x90
 [<ffffffff8135e45c>] ? start_secondary+0x16c/0x1c0
Code: 65 e8 48 89 5d e0 49 89 fc 4c 89 6d f0 4c 89 75 f8 48 8b 47 28 8b 9f c0 00 00 00 48 03 9f d0 00 00 00 48 85 c0 0f 84 5d 01 00 00 <8b> b0 ac 00 00 00 85 f6 0f 85 4d 02 00 00 0f b6 03 83 e0 0f 0f 
RIP  [<ffffffff812f8905>] ip_rcv_finish+0x35/0x380
 RSP <ffff88012e707cc0>
CR2: 00000000000000ac



      

