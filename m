Return-Path: <linux-kernel-owner+w=401wt.eu-S933092AbXDFVkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933092AbXDFVkM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 17:40:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933094AbXDFVkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 17:40:12 -0400
Received: from relay.parkline.ru ([195.24.65.16]:50030 "EHLO relay.parkline.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933092AbXDFVkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 17:40:09 -0400
X-Greylist: delayed 1216 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Apr 2007 17:40:08 EDT
Message-ID: <009201c77891$4eacffa0$d93810ac@kirya>
From: "Kirill Yushkov" <mail@kirya.ru>
To: <linux-kernel@vger.kernel.org>
Cc: <cebbert@redhat.com>
References: <20070406173603.GA82722@freefall.freebsd.org>    <46169DDA.6020008@ru.mvista.com> <50660.65.57.245.11.1175892938.squirrel@ssl.mu.org> <4616B70B.3070501@ru.mvista.com>
Subject: Re: Interrupt posted but not delivered
Date: Sat, 7 Apr 2007 01:19:48 +0400
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.3790.2826
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.2826
FL-Build: Fidolook 2002 (SL) 6.0.2800.94 - 3/3/2005 11:18:26
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Chuck!
You wrote to LKML on 2007-03-26 0:28:05:

CE> I've now seen several reports of this message from the 3Com
CE> 3c59x driver.  This seems to be a very old problem that has
CE> somehow come back starting with kernel 2.6.19 AFAICT. What
CE> could cause this?
I too have the same problem on version 2.6.20

Apr  6 18:18:14 gw kernel: NETDEV WATCHDOG: eth0: transmit timed out
Apr  6 18:18:14 gw kernel: eth0: transmit timed out, tx_status 00 status 
e681.
Apr  6 18:18:14 gw kernel:   diagnostics: net 0cf6 media 8880 dma 0000003a 
fifo 8000
Apr  6 18:18:14 gw kernel: eth0: Interrupt posted but not delivered -- IRQ 
blocked by another device?
Apr  6 18:18:14 gw kernel:   Flags; bus-master 1, dirty 63886224(0) current 
63886224(0)
Apr  6 18:18:14 gw kernel:   Transmit list 00000000 vs. ffff8100b8967200.
Apr  6 18:18:14 gw kernel:   0: @ffff8100b8967200  length 80000032 status 
00010032
Apr  6 18:18:14 gw kernel:   1: @ffff8100b89672a0  length 80000032 status 
00010032
Apr  6 18:18:14 gw kernel:   2: @ffff8100b8967340  length 8000002e status 
0001002e
Apr  6 18:18:14 gw kernel:   3: @ffff8100b89673e0  length 80000032 status 
00010032
Apr  6 18:18:14 gw kernel:   4: @ffff8100b8967480  length 80000058 status 
00010058
Apr  6 18:18:14 gw kernel:   5: @ffff8100b8967520  length 800002bc status 
000102bc
Apr  6 18:18:14 gw kernel:   6: @ffff8100b89675c0  length 80000061 status 
00010061
Apr  6 18:18:14 gw kernel:   7: @ffff8100b8967660  length 800000b3 status 
000100b3
Apr  6 18:18:14 gw kernel:   8: @ffff8100b8967700  length 800000aa status 
000100aa
Apr  6 18:18:14 gw kernel:   9: @ffff8100b89677a0  length 8000005c status 
0001005c
Apr  6 18:18:14 gw kernel:   10: @ffff8100b8967840  length 800005ac status 
000105ac
Apr  6 18:18:14 gw kernel:   11: @ffff8100b89678e0  length 800000e8 status 
000100e8
Apr  6 18:18:14 gw kernel:   12: @ffff8100b8967980  length 800005ac status 
000105ac
Apr  6 18:18:14 gw kernel:   13: @ffff8100b8967a20  length 800005ac status 
000105ac
Apr  6 18:18:14 gw kernel:   14: @ffff8100b8967ac0  length 80000062 status 
80010062
Apr  6 18:18:14 gw kernel:   15: @ffff8100b8967b60  length 8000046a status 
8001046a
Apr  6 18:18:15 gw kernel: BUG: at include/net/dst.h:154 dst_release()
Apr  6 18:18:15 gw kernel:
Apr  6 18:18:15 gw kernel: Call Trace:
Apr  6 18:18:15 gw kernel:  <IRQ>  [<ffffffff8022285f>] 
__kfree_skb+0x3f/0x120
Apr  6 18:18:15 gw kernel:  [<ffffffff80427282>] 
__neigh_event_send+0x142/0x190
Apr  6 18:18:15 gw kernel:  [<ffffffff804471c0>] ip_finish_output+0x0/0x200
Apr  6 18:18:15 gw kernel:  [<ffffffff8024c89a>] 
neigh_resolve_output+0x7a/0x1a0
Apr  6 18:18:15 gw kernel:  [<ffffffff80229c44>] ip_output+0x244/0x280
Apr  6 18:18:15 gw kernel:  [<ffffffff881198bb>] :pptp:pptp_xmit+0x6bb/0x760
Apr  6 18:18:15 gw kernel:  [<ffffffff8810254f>] 
:ppp_generic:ppp_push+0x5f/0xe0
Apr  6 18:18:15 gw kernel:  [<ffffffff881024c4>] 
:ppp_generic:ppp_send_frame+0x4e4/0x510
Apr  6 18:18:15 gw kernel:  [<ffffffff88101f77>] 
:ppp_generic:ppp_xmit_process+0x37/0xa0
Apr  6 18:18:15 gw kernel:  [<ffffffff88101d91>] 
:ppp_generic:ppp_start_xmit+0x1e1/0x210
Apr  6 18:18:15 gw kernel:  [<ffffffff80421c4e>] 
dev_hard_start_xmit+0x8e/0x140
Apr  6 18:18:15 gw kernel:  [<ffffffff804324bf>] __qdisc_run+0xff/0x1c0
Apr  6 18:18:15 gw kernel:  [<ffffffff80227845>] dev_queue_xmit+0x145/0x280
Apr  6 18:18:15 gw kernel:  [<ffffffff80447352>] 
ip_finish_output+0x192/0x200
Apr  6 18:18:15 gw kernel:  [<ffffffff8043d810>] nf_reinject+0x190/0x1e0
Apr  6 18:18:15 gw kernel:  [<ffffffff804471c0>] ip_finish_output+0x0/0x200
Apr  6 18:18:15 gw kernel:  [<ffffffff8811009a>] :imq:imq_dev_xmit+0x4a/0x60
Apr  6 18:18:15 gw kernel:  [<ffffffff80421c4e>] 
dev_hard_start_xmit+0x8e/0x140
Apr  6 18:18:15 gw kernel:  [<ffffffff804322dc>] qdisc_restart1+0xdc/0x1c0

With best regards, Kirill Yushkov.  E-mail: mail@kirya.ru 

