Return-Path: <linux-kernel-owner+w=401wt.eu-S1760000AbXHWLXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760000AbXHWLXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 07:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756024AbXHWLW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 07:22:58 -0400
Received: from gw.unix-scripts.info ([62.212.121.204]:34995 "EHLO
	gw.unix-scripts.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbXHWLW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 07:22:57 -0400
X-Greylist: delayed 454 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Aug 2007 07:22:56 EDT
Message-ID: <46CD6C40.7070403@unix-scripts.info>
Date: Thu, 23 Aug 2007 13:15:12 +0200
From: Laurent CARON <lcaron@unix-scripts.info>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070622)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: Server crashes unexpectedly
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

One of my server crashes randomly.

I suspect a filesystem corruption.

Can you please confirm this ?

Thanks

Here is the relevant part from /var/log/syslog



Aug 23 12:10:55 berlin kernel: BUG: unable to handle kernel paging
request at virtual address 74c1803d
Aug 23 12:10:55 berlin kernel: printing eip:
Aug 23 12:10:55 berlin kernel: c014fd25
Aug 23 12:10:55 berlin kernel: *pde = 00000000
Aug 23 12:10:55 berlin kernel: Oops: 0002 [#1]
Aug 23 12:10:55 berlin kernel: SMP
Aug 23 12:10:55 berlin kernel: Modules linked in: xt_helper xt_state
iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack camellia xcbc
dm_mirror hisax
Aug 23 12:10:55 berlin kernel: CPU:    1
Aug 23 12:10:55 berlin kernel: EIP:    0060:[<c014fd25>]    Not tainted VLI
Aug 23 12:10:55 berlin kernel: EFLAGS: 00010082   (2.6.22-berlin #1)
Aug 23 12:10:55 berlin kernel: EIP is at free_block+0x61/0xfb
Aug 23 12:10:55 berlin kernel: eax: df2c0000   ebx: 00000024   ecx:
d64ae080   edx: 74c18039
Aug 23 12:10:55 berlin kernel: esi: d64ae000   edi: dfe4b880   ebp:
dfe48840   esp: dff9df40
Aug 23 12:10:55 berlin kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0000
 ss: 0068
Aug 23 12:10:55 berlin kernel: Process events/1 (pid: 8, ti=dff9c000
task=dff8e540 task.ti=dff9c000)
Aug 23 12:10:55 berlin kernel: Stack: 00000009 00000000 0000000b
00000001 dfe35cd8 dfe35cd4 0000000b dfe35cc0
Aug 23 12:10:55 berlin kernel: dfe4b880 c014fe37 00000000 dfe48840
dfe4b880 dfe48840 c1413a60 00000000
Aug 23 12:10:55 berlin kernel: c0150b36 00000000 00000000 dffcd4c0
c1413a60 c0150aed c0127dd0 000000ff
Aug 23 12:10:55 berlin kernel: Call Trace:
Aug 23 12:10:55 berlin kernel: [<c014fe37>] drain_array+0x78/0x97
Aug 23 12:10:55 berlin kernel: [<c0150b36>] cache_reap+0x49/0xe5
Aug 23 12:10:55 berlin kernel: [<c0150aed>] cache_reap+0x0/0xe5
Aug 23 12:10:55 berlin kernel: [<c0127dd0>] run_workqueue+0x73/0xf5
Aug 23 12:10:55 berlin kernel: [<c01284f2>] worker_thread+0x0/0xc6
Aug 23 12:10:55 berlin kernel: [<c01285ac>] worker_thread+0xba/0xc6
Aug 23 12:10:55 berlin kernel: [<c012aaa1>]
autoremove_wake_function+0x0/0x35
Aug 23 12:10:55 berlin kernel: [<c012a9db>] kthread+0x38/0x5d
Aug 23 12:10:55 berlin kernel: [<c012a9a3>] kthread+0x0/0x5d
Aug 23 12:10:55 berlin kernel: [<c01030e7>] kernel_thread_helper+0x7/0x10
Aug 23 12:10:55 berlin kernel: =======================
Aug 23 12:10:55 berlin kernel: Code: 8b 02 25 00 40 02 00 3d 00 40 02 00
75 03 8b 52 0c 8b 02 84 c0 78 04 0f 0b eb fe 8b 72 1c 8b 54 24 28 8b 7c
95 68 8b 16 8b 46 04 <89>
 42 04 89 10 c7 06 00 01 10 00 c7 46 04 00 02 20 00 2b 4e 0c
Aug 23 12:10:55 berlin kernel: EIP: [<c014fd25>] free_block+0x61/0xfb
SS:ESP 0068:dff9df40


Thanks

Laurent
