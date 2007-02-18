Return-Path: <linux-kernel-owner+w=401wt.eu-S1751334AbXBRPrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751334AbXBRPrz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 10:47:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbXBRPrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 10:47:55 -0500
Received: from mail.exanet.com ([212.143.73.109]:53237 "EHLO mr.exanet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334AbXBRPry convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 10:47:54 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: OOPS
Date: Sun, 18 Feb 2007 17:47:52 +0200
Message-ID: <A6FDE6B975803043804A49F12F49028E0F5793@hawk.exanet-il.co.il>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: OOPS
Thread-Index: AcdTdCYxuWUs8E/WT0y+UtgkWi7Nog==
From: "Menny Hamburger" <menny@exanet.com>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We are running the 2.6 kernel with the IOCB_CMD_EPOLL_WAIT code and the
NMI watchdog is triggered:

CPU:    0
EIP:    0060:[<c0323285>]    Not tainted VLI
EFLAGS: 00000087   (2.6.9-42dbg)
EIP is at __write_lock_failed+0x9/0x20
eax: c52d2d00   ebx: d9522580   ecx: 00000092   edx: c52d2d00
esi: c52d2d00   edi: 00000000   ebp: c044dcd4   esp: c044dcd0
 nmi_watchdog_tick+0xa3/0xc1
 [<c01081c5>] default_do_nmi+0x5a/0xe8
 [<c010829a>] do_nmi+0x40/0x4a
 [<c0326dd5>] nmi_stack_correct+0x1e/0x26
 [<c017a8a6>] ep_poll_callback+0x18/0xaa
 [<c011ab83>] __wake_up_common+0x35/0x55
 [<c011abd5>] __wake_up+0x32/0x43
 [<c02b458f>] sock_def_readable+0x7b/0x7d
 [<c02f3839>] udp_queue_rcv_skb+0xfc/0x29f
 [<c02f3eac>] udp_rcv+0x1a2/0x41a
 [<c02d124d>] ip_local_deliver_finish+0x7f/0x210
 [<c02c437a>] nf_hook_slow+0xe5/0x104
 [<c02d10d9>] ip_local_deliver+0x19d/0x292
 [<c02d1afd>] ip_rcv_finish+0x1e8/0x2db
 [<c02c437a>] nf_hook_slow+0xe5/0x104
 [<c02d1759>] ip_rcv+0x37b/0x537
 [<c02bad58>] netif_receive_skb+0x2e8/0x36c
 [<f884febe>] e1000_clean_rx_irq+0xc6/0x630 [e1000]
 [<f884f9e5>] e1000_clean+0xb0/0x1a5 [e1000]
 [<c02bafb2>] net_rx_action+0xc2/0x1d2
 [<c0123604>] __do_softirq+0x64/0xd2
 [<c0109989>] do_softirq+0x53/0x5b
 =======================
 [<c01091b5>] do_IRQ+0x1a5/0x1ec
 [<c0326bc8>] common_interrupt+0x18/0x20


Any suggestions?

Thanks,
Menny

