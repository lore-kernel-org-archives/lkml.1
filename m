Return-Path: <linux-kernel-owner+w=401wt.eu-S1757077AbXGIRox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077AbXGIRox (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 13:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753622AbXGIRoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 13:44:46 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:47935 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbXGIRop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 13:44:45 -0400
Subject: Re: [PATCH 0/16] Pid namespaces
From: Badari Pulavarty <pbadari@gmail.com>
To: Pavel Emelianov <xemul@openvz.org>
Cc: Andrew Morton <akpm@osdl.org>, Kirill Korotaev <dev@openvz.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>
In-Reply-To: <468DF6F7.1010906@openvz.org>
References: <468DF6F7.1010906@openvz.org>
Content-Type: text/plain
Date: Mon, 09 Jul 2007 10:46:20 -0700
Message-Id: <1184003180.21234.39.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-06 at 12:01 +0400, Pavel Emelianov wrote:
> This is "submition for inclusion" of hierarchical, not kconfig
> configurable, zero overheaded ;) pid namespaces.

Not able to boot my ppc64 machine with the patchset :(

Thanks,
Badari

Unable to handle kernel paging request for data at address 0x00000000
Faulting instruction address: 0xc000000000247ce0
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=32 NUMA pSeries
Modules linked in:
NIP: c000000000247ce0 LR: c000000000107bf4 CTR: c000000000107bd0
REGS: c0000000005fb920 TRAP: 0300   Not tainted  (2.6.22-rc6-mm1)
MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 24000048  XER: 20000005
DAR: 0000000000000000, DSISR: 0000000040000000
TASK = c000000000514650[0] 'swapper' THREAD: c0000000005f8000 CPU: 0
GPR00: c0000000000bd42c c0000000005fbba0 c0000000005f8f18 0000000000000000
GPR04: 0000000000000000 c000000000645190 c00000000d025000 c00000000d024cb8
GPR08: c00000000d024d10 0000000000000000 c00000000d024cf0 0000000000000000
GPR12: 000000000000247f c000000000514d80 0000000000000000 c00000000044e438
GPR16: 4000000001c00000 c00000000044ce50 0000000000000000 0000000000000000
GPR20: c0000000004f9fd0 00000000020f9fd0 0000000000000000 c0000000005bc370
GPR24: c0000000005bc2f8 c000000000539738 0000000002000000 0000000000000000
GPR28: c00000000d024c00 0000000000000000 c00000000054a358 c00000000d024c00
NIP [c000000000247ce0] .kref_get+0x0/0x28
LR [c000000000107bf4] .proc_set_super+0x24/0x54
Call Trace:
[c0000000005fbba0] [c0000000005fbc30] 0xc0000000005fbc30 (unreliable)
[c0000000005fbc30] [c0000000000bd42c] .sget+0x34c/0x470
[c0000000005fbd00] [c000000000107da4] .proc_get_sb+0xa0/0x18c
[c0000000005fbdb0] [c0000000000bdc84] .vfs_kern_mount+0x80/0xe8
[c0000000005fbe50] [c0000000004ea1e4] .proc_root_init+0x4c/0x158
[c0000000005fbed0] [c0000000004cb9ec] .start_kernel+0x3c8/0x404
[c0000000005fbf90] [c000000000008524] .start_here_common+0x54/0x130
Instruction dump:
60000000 e8440008 7c0903a6 4e800421 e8410028 38000001 38210080 7c030378
e8010010 ebc1fff0 7c0803a6 4e800020 <80030000> 7c000034 5400d97e 0b000000
Kernel panic - not syncing: Attempted to kill the idle task!




