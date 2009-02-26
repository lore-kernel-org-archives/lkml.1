Return-Path: <linux-kernel-owner+w=401wt.eu-S1756912AbZBZQBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912AbZBZQBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 11:01:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754685AbZBZQA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 11:00:57 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:59830 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643AbZBZQA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 11:00:56 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49A6BC72.5050206@s5r6.in-berlin.de>
Date: Thu, 26 Feb 2009 16:59:46 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.19) Gecko/20081204 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net, linux-media@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Ben Backx <ben@bbackx.com>, Henrik Kurelid <henrik@kurelid.se>
Subject: Re: [git pull] DVB + ieee1394: firedtv driver
References: <tkrat.847a062a8a488f0d@s5r6.in-berlin.de> <20090226013708.GA16892@elte.hu>
In-Reply-To: <20090226013708.GA16892@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> [   13.756029] calling  fdtv_init+0x0/0xf @ 1
> [   13.760074] BUG: unable to handle kernel NULL pointer dereference at 00000054
> [   13.764023] IP: [<c0496393>] driver_find+0xf/0x24
> [   13.764023] *pde = 00000000 
> [   13.764023] Oops: 0000 [#1] SMP 
> [   13.764023] last sysfs file: 
> [   13.764023] 
> [   13.764023] Pid: 1, comm: swapper Not tainted (2.6.29-rc6-tip-01938-gdb50eec-dirty #27473) System Product Name
> [   13.764023] EIP: 0060:[<c0496393>] EFLAGS: 00010286 CPU: 0
> [   13.764023] EIP is at driver_find+0xf/0x24
> [   13.764023] EAX: 00000000 EBX: c0f8d7ac ECX: c0e4a9dd EDX: c0e4a9dd
> [   13.764023] ESI: 00000003 EDI: 00000000 EBP: f70e3f28 ESP: f70e3f28
> [   13.764023]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [   13.764023] Process swapper (pid: 1, ti=f70e3000 task=f70e8000 task.ti=f70e3000)
> [   13.764023] Stack:
> [   13.764023]  f70e3f38 c04964a5 c0f8d7a0 00000003 f70e3f48 c06eef99 c0f8d6f8 00000003
> [   13.764023]  f70e3f50 c066ac36 f70e3f5c c105c85c 34294a24 f70e3f64 c105c83a f70e3fc0
> [   13.764023]  c0101089 c105c82d 00000000 6f727200 6f632072 2d206564 00203231 f70e3fc0
> [   13.764023] Call Trace:
> [   13.764023]  [<c04964a5>] ? driver_register+0x4b/0x96
> [   13.764023]  [<c06eef99>] ? __hpsb_register_protocol+0x23/0x36
> [   13.764023]  [<c066ac36>] ? hpsb_register_protocol+0xf/0x11
> [   13.764023]  [<c105c85c>] ? fdtv_1394_init+0x20/0x42
> [   13.764023]  [<c105c83a>] ? fdtv_init+0xd/0xf
> [   13.764023]  [<c0101089>] ? do_one_initcall+0x4f/0x11f
> [   13.764023]  [<c105c82d>] ? fdtv_init+0x0/0xf
> [   13.764023]  [<c018b5d9>] ? register_irq_proc+0x87/0xa0
> [   13.764023]  [<c103231a>] ? do_initcalls+0x15/0x25
> [   13.764023]  [<c10325af>] ? kernel_init+0x0/0x97
> [   13.764023]  [<c1032346>] ? do_basic_setup+0x1c/0x1e
> [   13.764023]  [<c1032608>] ? kernel_init+0x59/0x97
> [   13.764023]  [<c011c2b3>] ? kernel_thread_helper+0x7/0x10
> [   13.764023] Code: b8 64 00 00 00 e8 10 49 cc ff e8 2e fc ff ff 85 c0 75 ed e8 eb 37 cd ff 31 c0 5d c3 55 89 e5 e8 34 5f c8 ff 89 c1 8b 42 38 89 ca <8b> 40 54 e8 6c 48 f9 ff 31 d2 85 c0 74 03 8b 50 6c 5d 89 d0 c3 
> 
> Config attached.

Thanks.
Alas I have no Linux box at hand before Saturday.  I wonder, was 
ieee1394_bus_type not yet registered (i.e. ieee1394's ieee1394_init() 
not yet called) at the moment when fdtv_init is executed?

Or what else could have been the NULL pointer dereference in driver_find?

Stefan Richter

