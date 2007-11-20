Return-Path: <linux-kernel-owner+w=401wt.eu-S1757529AbXKTOrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529AbXKTOrY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 09:47:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753466AbXKTOrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 09:47:17 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:3829 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbXKTOrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 09:47:16 -0500
Date: Tue, 20 Nov 2007 14:46:59 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, nfs@lists.sourceforge.net,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: mm snapshot broken-out-2007-11-20-01-45.tar.gz -- powerpc panic
Message-ID: <20071120144659.GC12066@shadowen.org>
References: <200711200953.lAK9qxjO030444@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711200953.lAK9qxjO030444@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have one powerpc machine which managed to compile this snapshot!  It
paniced on boot as below, might be nfs so copied them.  General results
are popping out on TKO.

-apw

Freeing initrd memory: 1224k freed
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
Unable to handle kernel paging request for data at address 0x00000050
Faulting instruction address: 0xc000000000113b64
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=32 NUMA pSeries
Modules linked in:
NIP: c000000000113b64 LR: c000000000113b44 CTR: 0000000000000000
REGS: C00000077E0679D0 TRAP: 0300   Not tainted  (2.6.24-rc3-mm1-autokern1)
MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 24004044  XER: 20000000
DAR: 0000000000000050, DSISR: 0000000040000000
TASK = C00000077E062000[1] 'swapper' THREAD: C00000077E064000 CPU: 0
GPR00: 0000000000000000 c00000077e067c50 c0000000006c5650 0000000000000001 
GPR04: c00000077e625bdc 0000000000000005 c000000000501ad4 c000000000731d18 
GPR08: 0000000000000000 0000000000000000 c00000077e625b40 0000000000000001 
GPR12: 0000000024004044 c0000000005fd000 0000000000000000 0000000000000000 
GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000 
GPR20: 4000000003a00000 0000000004300000 0000000003fb94a8 0000000000132000 
GPR24: 0000000003fb9718 0000000000000000 c0000000005b6e70 0000000000000000 
GPR28: 0000000000000005 c00000077e625b40 c000000000652e48 c00000077e625c50 
NIP [c000000000113b64] .remove_proc_entry+0xac/0x234
LR [c000000000113b44] .remove_proc_entry+0x8c/0x234
Call Trace:
[c00000077e067c50] [c000000000113b44] .remove_proc_entry+0x8c/0x234 (unreliable)
[c00000077e067d10] [c00000000048bf28] .cache_unregister+0x108/0x1b4
[c00000077e067d90] [c0000000001ca988] .nfsd_export_shutdown+0x50/0xa4
[c00000077e067e10] [c0000000005a712c] .init_nfsd+0x108/0x13c
[c00000077e067ea0] [c000000000582438] .kernel_init+0x224/0x3fc
[c00000077e067f90] [c000000000026204] .kernel_thread+0x4c/0x68
Instruction dump:
e8bf0000 e8810090 7f83e378 4bfffd25 2f830000 419e0018 ebbf0000 e81d0050 
f81f0000 38000000 f81d0050 e93f0000 <e8090050> 3be90050 2fa00000 409effc4 
Kernel panic - not syncing: Attempted to kill init!
