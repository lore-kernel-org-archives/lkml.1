Return-Path: <linux-kernel-owner+w=401wt.eu-S1757197AbXKFUal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197AbXKFUal (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 15:30:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755207AbXKFUad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 15:30:33 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:58905 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696AbXKFUac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 15:30:32 -0500
Subject: Re: mm snapshot broken-out-2007-11-06-02-32.tar.gz uploaded
From: Badari Pulavarty <pbadari@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
       Greg K-H <greg@kroah.com>
In-Reply-To: <200711061033.lA6AXrhT018804@imap1.linux-foundation.org>
References: <200711061033.lA6AXrhT018804@imap1.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 06 Nov 2007 11:32:29 -0800
Message-Id: <1194377549.26782.13.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-11-06 at 02:33 -0800, akpm@linux-foundation.org wrote:
> The mm snapshot broken-out-2007-11-06-02-32.tar.gz has been uploaded to
> 
>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-11-06-02-32.tar.gz
> 
> It contains the following patches against 2.6.24-rc1:


Getting OOPS on shutdown.

Unable to handle kernel paging request for data at address 0x600000040
Faulting instruction address: 0xc000000000341a68
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=32 NUMA pSeries
Modules linked in:
NIP: c000000000341a68 LR: c000000000341ab4 CTR: c0000000002e8904
REGS: c000000008403910 TRAP: 0300   Not tainted  (2.6.24-rc1-mm1)
MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 24002444  XER: 20000001
DAR: 0000000600000040, DSISR: 0000000040000000
TASK = c00000000dff12a0[12966] 'reboot' THREAD: c000000008400000 CPU: 3
GPR00: c000000003131480 c000000008403b90 c00000000071cb38 c00000000331c000
GPR04: 0000000000000001 0000000000000000 c0000000007dac20 c00000000000f528
GPR08: c0000000031310a8 0000000600000000 c0000000031311a8 c00000000077c760
GPR12: 0000000044002428 c000000000648c80 0000000000000001 0000000000000000
GPR16: 000000001009ba50 0000000000000000 0000000010070000 0000000000000000
GPR20: 0000000000000000 0000000000000001 0000000000000000 0000000000000000
GPR24: 0000000000000001 0000000000000000 0000000000000000 0000000000004000
GPR28: 00000000fee1dead 0000000028121969 c0000000006b2368 c000000000621bd0
NIP [c000000000341a68] .device_shutdown+0x4c/0xd4
LR [c000000000341ab4] .device_shutdown+0x98/0xd4
Call Trace:
[c000000008403b90] [c000000000341ab4] .device_shutdown+0x98/0xd4 (unreliable)
[c000000008403c10] [c000000000067780] .kernel_restart+0x40/0x98
[c000000008403c90] [c0000000000679f4] .sys_reboot+0x214/0x25c
[c000000008403e30] [c00000000000852c] syscall_exit+0x0/0x40
Instruction dump:
60000000 60000000 e9690000 e92b0008 3909ff00 7fa95800 e9280108 3be9ff00
419e0080 e9280178 2fa90000 419e0014 <e9290040> 7d034378 2fa90000 409e0020


