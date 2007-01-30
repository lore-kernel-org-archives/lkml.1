Return-Path: <linux-kernel-owner+w=401wt.eu-S965575AbXA3PCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965575AbXA3PCi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 10:02:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965580AbXA3PCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 10:02:38 -0500
Received: from mout2.freenet.de ([194.97.50.155]:53152 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965575AbXA3PCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 10:02:36 -0500
From: Karsten Wiese <fzu@wemgehoertderstaat.de>
To: linux@bohmer.net
Subject: Re: [OOPS] on 2.6.20-rc5-rt10
Date: Tue, 30 Jan 2007 16:02:33 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>
References: <3efb10970701300630w3c235233ic7613e8f74a7b4f2@mail.gmail.com>
In-Reply-To: <3efb10970701300630w3c235233ic7613e8f74a7b4f2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701301602.33989.fzu@wemgehoertderstaat.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 30. Januar 2007 15:30 schrieb Remy Bohmer:
> Hello All,
> 
> Once in a while we see the following stacktrace.
> We do not know yet the exact condition that generates this, but is
> there anyone that recognises this oops?
> 
> Kind Regards,
> 
> Remy Bohmer
> 
> 
> Jan 30 14:09:20 localhost kernel: BUG: unable to handle kernel paging
> request at virtual address 2e3277e5
> Jan 30 14:09:20 localhost kernel:  printing eip:
> Jan 30 14:09:20 localhost kernel: c0140214
> Jan 30 14:09:20 localhost kernel: *pde = 00000000
> Jan 30 14:09:20 localhost kernel: stopped custom tracer.
> Jan 30 14:09:20 localhost kernel: Oops: 0002 [#1]
> Jan 30 14:09:20 localhost kernel: PREEMPT SMP
> Jan 30 14:09:20 localhost kernel: Modules linked in: cap_over
> commoncap i2c_dev uhci_hcd i2c_i801 i2c_core ehci_hcd
> Jan 30 14:09:20 localhost kernel: CPU:    0
> Jan 30 14:09:20 localhost kernel: EIP:    0060:[<c0140214>]    Not tainted VLI
> Jan 30 14:09:20 localhost kernel: EFLAGS: 00010246   (2.6.20-rc5-rt10 #1)
> Jan 30 14:09:20 localhost kernel: EIP is at module_put+0x24/0x60
> Jan 30 14:09:20 localhost kernel: eax: 2e3277e5   ebx: f774da00   ecx:
> c1df40a0   edx: 2e327665
> Jan 30 14:09:20 localhost kernel: esi: f6e93af0   edi: 2e327665   ebp:
> f4a1bf40   esp: f4a1bf40
> Jan 30 14:09:20 localhost kernel: ds: 007b   es: 007b   ss: 0068
> preempt: 00000002
> Jan 30 14:09:20 localhost kernel: Process udevd (pid: 11594,
> ti=f4a1a000 task=f6014710 task.ti=f4a1a000)
> Jan 30 14:09:20 localhost kernel: Stack: f4a1bf54 c01a360e 00000010
> f5882ac0 f7e3f9c4 f4a1bf78 c01684f1 00000000
> Jan 30 14:09:20 localhost kernel:        00000000 f43d5c14 f7dc3c40
> f5882ac0 c1f60680 00000000 f4a1bf80 c0168629
> Jan 30 14:09:20 localhost kernel:        f4a1bf98 c01656f7 f4a1bfb0
> c1f60680 c1f60700 00000003 f4a1bfb0 c01669d9
> Jan 30 14:09:20 localhost kernel: Call Trace:
> Jan 30 14:09:20 localhost kernel:  [<c01054ca>] show_trace_log_lvl+0x1a/0x30
> Jan 30 14:09:20 localhost kernel:  [<c010559b>] show_stack_log_lvl+0xbb/0x100
> Jan 30 14:09:20 localhost kernel:  [<c01057c0>] show_registers+0x1e0/0x300
> Jan 30 14:09:20 localhost kernel:  [<c0105a05>] die+0x125/0x250
> Jan 30 14:09:20 localhost kernel:  [<c0115b75>] do_page_fault+0x145/0x610
> Jan 30 14:09:20 localhost kernel:  [<c03ee69c>] error_code+0x7c/0x84
> Jan 30 14:09:20 localhost kernel:  [<c01a360e>] sysfs_release+0x3e/0x70
> Jan 30 14:09:20 localhost kernel:  [<c01684f1>] __fput+0xa1/0x170
> Jan 30 14:09:20 localhost kernel:  [<c0168629>] fput+0x19/0x20
> Jan 30 14:09:20 localhost kernel:  [<c01656f7>] filp_close+0x47/0x70
> Jan 30 14:09:20 localhost kernel:  [<c01669d9>] sys_close+0x69/0xc0
> Jan 30 14:09:20 localhost kernel:  [<c0104472>] sysenter_past_esp+0x5f/0x85
> Jan 30 14:09:20 localhost kernel:  =======================
> Jan 30 14:09:20 localhost kernel: Code: 00 8d bf 00 00 00 00 55 85 c0
> 89 e5 89 c2 74 34 89 e0 25 00 e0 ff ff 83 40 14 01 65 a1 04 00 00 00
> c1 e0 07 8d 84 10 80 01 00 00 <ff> 08 83 3a 02 74 1b 89 e0 25 00 e0 ff
> ff 83 68 14 01 8b 40 08
> Jan 30 14:09:20 localhost kernel: EIP: [<c0140214>]
> module_put+0x24/0x60 SS:ESP 0068:f4a1bf40

I think I saw similar oopses.
Cause was a driver having freed some kmalloced struct _before_
sysfs_release had given its ok.
Happened on physical device removal or rmmod here.

      Karsten
