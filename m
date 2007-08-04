Return-Path: <linux-kernel-owner+w=401wt.eu-S1765843AbXHDUVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765843AbXHDUVT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 16:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbXHDUVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 16:21:12 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:14265 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282AbXHDUVL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 16:21:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=SXh+pFzkPSemzRH8tdmBc45xGBtpQSQClzKE0XzF4dUZFgTCFlcrrPn84X12lOTSmJRG9cfaeavej1U04BHyTbLezdjVHG8JnRfahYKArvf1RPHI6r0eqSIcShivJPitQ0TGN3XxTd5enBVyVmhV/S2Lkpj+Zj6W96zrvA7xT6w=
Organization: M1K0
To: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: many problems with mac80211, iwlwifi and ACPI on Santa Rosa laptop
Date: Sat, 4 Aug 2007 22:20:58 +0200
User-Agent: KMail/1.9.7
Cc: Robert Hancock <hancockr@shaw.ca>
References: <fa.v/A5H4Pm9oA6Hct919AmEbMQfJ0@ifi.uio.no> <46B4B234.9040000@shaw.ca> <200708042009.40881.Michal.Kudla@gmail.com>
In-Reply-To: <200708042009.40881.Michal.Kudla@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708042221.00858.Michal.Kudla@m1k0.com>
From: =?utf-8?q?Micha=C5=82_Kud=C5=82a?= <michal.kudla@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Again BUG at mm/slab.c

Aug  4 22:15:58 laptok wlan0: setting MTU 576
Aug  4 22:16:00 laptok r8169: eth0: link down
Aug  4 22:16:00 laptok dhcpcd[6377]: eth0: dhcpcd 3.0.16 starting
Aug  4 22:16:00 laptok dhcpcd[6377]: eth0: hardware address = 
00:1b:fc:41:a1:d8
Aug  4 22:16:00 laptok dhcpcd[6377]: eth0: broadcasting for a lease
Aug  4 22:16:07 laptok ------------[ cut here ]------------
Aug  4 22:16:07 laptok kernel BUG at mm/slab.c:1673!
Aug  4 22:16:07 laptok invalid opcode: 0000 [#1]
Aug  4 22:16:07 laptok SMP
Aug  4 22:16:07 laptok Modules linked in: nvidiafb cfbcopyarea vgastate 
cfbimgblt cfbfillrect iwl4965
Aug  4 22:16:07 laptok CPU:    1
Aug  4 22:16:07 laptok EIP:    0060:[<c015ec19>]    Not tainted VLI
Aug  4 22:16:07 laptok EFLAGS: 00010246   (2.6.22-gentoo-r2 #6)
Aug  4 22:16:07 laptok EIP is at kmem_freepages+0xb9/0xc0
Aug  4 22:16:07 laptok eax: 40000000   ebx: c16e0280   ecx: ffffffff   edx: 
00000000
Aug  4 22:16:07 laptok esi: 00000001   edi: c211f7c0   ebp: c2175f30   esp: 
c2175f20
Aug  4 22:16:07 laptok ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Aug  4 22:16:07 laptok Process events/1 (pid: 10, ti=c2174000 task=c2153580 
task.ti=c2174000)
Aug  4 22:16:07 laptok Stack: f7014000 c211f7c0 f770ee80 00000003 c2175f40 
c015ef46 c211d440 c211d450
Aug  4 22:16:07 laptok c2175f60 c015f1e7 c211d464 00000005 c211f7c0 c211d440 
c211f7c0 c201aae0
Aug  4 22:16:07 laptok c2175f7c c0160239 00000000 00000000 c2127440 c201aae0 
c0160160 c2175fa4
Aug  4 22:16:07 laptok Call Trace:
Aug  4 22:16:07 laptok [<c01039fa>] show_trace_log_lvl+0x1a/0x30
Aug  4 22:16:07 laptok [<c0103ab9>] show_stack_log_lvl+0xa9/0xd0
Aug  4 22:16:07 laptok [<c0103cc9>] show_registers+0x1e9/0x2f0
Aug  4 22:16:07 laptok [<c0103edf>] die+0x10f/0x240
Aug  4 22:16:07 laptok [<c01040a1>] do_trap+0x91/0xc0
Aug  4 22:16:07 laptok [<c0104459>] do_invalid_op+0x89/0xa0
Aug  4 22:16:07 laptok [<c045b5aa>] error_code+0x72/0x78
Aug  4 22:16:07 laptok [<c015ef46>] slab_destroy+0x26/0x70
Aug  4 22:16:07 laptok [<c015f1e7>] drain_freelist+0x57/0x90
Aug  4 22:16:07 laptok [<c0160239>] cache_reap+0xd9/0x110
Aug  4 22:16:07 laptok [<c012c178>] run_workqueue+0x78/0x100
Aug  4 22:16:07 laptok [<c012cb6d>] worker_thread+0x9d/0x100
Aug  4 22:16:07 laptok [<c012f732>] kthread+0x42/0x70
Aug  4 22:16:07 laptok [<c0103623>] kernel_thread_helper+0x7/0x14
Aug  4 22:16:07 laptok =======================
Aug  4 22:16:07 laptok Code: ff 58 5b 5e 5f 5d c3 8b 03 89 f1 f7 d9 c1 e8 1e 
89 c2 c1 e2 07 c1 e0 0a 29 d0 ba 09 00 00 00 05 80 e4 57 c0 e8 09 ee fe ff eb 
9c <
0f> 0b eb fe 8d 76 00 55 89 e5 57 89 c7 56 b8 c4 f2 57 c0 53 8b
Aug  4 22:16:07 laptok EIP: [<c015ec19>] kmem_freepages+0xb9/0xc0 SS:ESP 
0068:c2175f20


W liście datowanym na sobota, 4 sierpnia 2007, Michał Kudła pisze:
>MK W liście datowanym na sobota, 4 sierpnia 2007, Robert Hancock pisze:
>MK >RH Can you reproduce this without the binary NVIDIA module loaded?
>MK
>MK Yes,
>MK Next photo is made on kernel with nvidiafb module
>MK http://picasaweb.google.pl/Michal.Kudla/Gentoo/photo#5094907741297540418
>MK
>MK // P.S. Can I find this error in some system logs?
>MK Photos is not good for reports.
>MK



-- 
http://www.m1k0.com
