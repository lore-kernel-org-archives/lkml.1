Return-Path: <linux-kernel-owner+w=401wt.eu-S1767824AbXCJFIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767824AbXCJFIt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 00:08:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767827AbXCJFIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 00:08:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:40173 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767824AbXCJFIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 00:08:48 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: ipv6 crash in latest git
Date: Sat, 10 Mar 2007 00:07:10 -0500
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703100007.19327.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

# CONFIG_DEBUG_SHIRQ is not set

Linux version 2.6.21-rc3-ga967e127 (lenb@d975xbx2) (gcc version 4.1.2 20061115 (prerelease) (SUSE Linu7
Command line: root=/dev/sda1 console=tty0 console=ttyS0,115200n8 debug                                 
...
Starting yum-updatesd: [  OK  ]
Starting Avahi daemon... [  OK  ]
Starting HAL daemon: Unable to handle kernel NULL pointer dereference at 0000000000000100 RIP:
 [<ffffffff8033b2e5>] memcmp+0x8/0x22
PGD 0
Oops: 0000 [1] SMP
CPU 0
Modules linked in: video sbs i2c_ec i2c_core dock asus_acpi backlight rtc_cmos
Pid: 0, comm: swapper Not tainted 2.6.21-rc3-ga967e127 #21
RIP: 0010:[<ffffffff8033b2e5>]  [<ffffffff8033b2e5>] memcmp+0x8/0x22
RSP: 0018:ffffffff807bfd28  EFLAGS: 00010202
RAX: 00000000000000ff RBX: 0000000000000000 RCX: 0000000000000010
RDX: 0000000000000010 RSI: ffff810026020900 RDI: 0000000000000100
RBP: 0000000000000080 R08: ffffffff807bfe20 R09: ffff81003ecc9000
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000004
R13: ffff8100360426c0 R14: ffff810026020800 R15: ffffffff807bfe20
FS:  0000000000000000(0000) GS:ffffffff80726000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000100 CR3: 0000000036200000 CR4: 00000000000006e0
Process swapper (pid: 0, threadinfo ffffffff8075e000, task ffffffff806bb480)
Stack:  ffffffff8051f24c 0000000000000000 000000808054b7d9 ffff810026020900
 0000000000000022 0000000000000100 ffff810026020800 ffffffff80720240
 0000000000000000 ffffffff80720254 0000000000000001 ffffffff807bfe20
Call Trace:
 <IRQ>  [<ffffffff8051f24c>] fib6_add+0x9d/0x539
 [<ffffffff8051c8b5>] __ip6_ins_rt+0x32/0x47
 [<ffffffff8051db7b>] ip6_pol_route_input+0x14a/0x1d1
 [<ffffffff8051c7cc>] ip6_route_input+0x84/0x8e
 [<ffffffff80516f5b>] ipv6_rcv+0x2ac/0x365
 [<ffffffff804d0afa>] process_backlog+0x84/0x102
 [<ffffffff804d0d05>] net_rx_action+0xa8/0x166
 [<ffffffff803ba78a>] e1000_intr+0x10c/0x134
 [<ffffffff80233374>] __do_softirq+0x55/0xc3
 [<ffffffff80217fef>] ack_apic_level+0x3a/0x4c
 [<ffffffff8020a4ac>] call_softirq+0x1c/0x28
 [<ffffffff8020b7f7>] do_softirq+0x2c/0x7d
 [<ffffffff8020b986>] do_IRQ+0x13e/0x160
 [<ffffffff80208714>] mwait_idle+0x0/0x48
 [<ffffffff80209831>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff804cca78>] datagram_poll+0x0/0xc8
 [<ffffffff80208756>] mwait_idle+0x42/0x48
 [<ffffffff802086ac>] cpu_idle+0x8b/0xae
 [<ffffffff8076a759>] start_kernel+0x29b/0x2a7
 [<ffffffff8076a15c>] _sinittext+0x15c/0x160


Code: 0f b6 17 29 c2 89 d0 75 10 48 ff c7 48 ff c6 48 ff c9 48 85
RIP  [<ffffffff8033b2e5>] memcmp+0x8/0x22
 RSP <ffffffff807bfd28>
CR2: 0000000000000100
Kernel panic - not syncing: Aiee, killing interrupt handler!
