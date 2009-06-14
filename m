Return-Path: <linux-kernel-owner+w=401wt.eu-S1763688AbZFNTWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763688AbZFNTWe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 15:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762553AbZFNTW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 15:22:26 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:56049 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792AbZFNTWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 15:22:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=miQBL3sV/Fsxt2GLoHQp78OYE082ZgrTvj/nMv2+Zqc+ccc9Xmp/JcL+qtlZ26h91B
         6SPXtJjkFOiKYqCd/a2Truk2Aonewb5dyNQOmSQ6F4dnd2oLn7V9ubzzO1kYEGszpdfy
         nXCCr8AH9JMFpOjucYJoH3Dd9xcr4vGwwvjRw=
Date: Sun, 14 Jun 2009 23:22:20 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Simon Holm =?iso-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: apic: native_apic_write_dummy warning
Message-ID: <20090614192220.GB4851@lenovo>
References: <1245006351.5912.174.camel@odie.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1245006351.5912.174.camel@odie.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Simon Holm Thøgersen - Sun, Jun 14, 2009 at 09:05:50PM +0200]
| Hi Cyrill
| 
| I guess you want to know about these warnings, so here you go
| 
| WARNING: at arch/x86/kernel/apic/apic.c:249 native_apic_write_dummy+0x32/0x3e()
| Hardware name:
| Modules linked in:
| Pid: 0, comm: swapper Not tainted 2.6.30-debug-03392-g44b7532 #17
| Call Trace:
|  [<c0126bed>] warn_slowpath_common+0x65/0x95
| [    0.006956]  [<c0126c2f>] warn_slowpath_null+0x12/0x15
| [    0.007031]  [<c0112269>] native_apic_write_dummy+0x32/0x3e
| [    0.007109]  [<c010e027>] intel_init_thermal+0xd3/0x178
| [    0.007185]  [<c01168ce>] ? native_read_msr_safe+0x9/0x16
| [    0.007263]  [<c0194197>] ? __kmalloc+0x117/0x123
| [    0.007338]  [<c010deb2>] mce_intel_feature_init+0x10/0x50
| [    0.007416]  [<c05ee0a4>] mcheck_init+0x1d5/0x263
| [    0.007492]  [<c05eda0a>] identify_cpu+0x369/0x378
| [    0.007569]  [<c03432ac>] ? _spin_unlock+0x3d/0x49
| [    0.007644]  [<c01cc5ff>] ? proc_register+0x150/0x161
| [    0.007721]  [<c05d2a15>] identify_boot_cpu+0xd/0x23
| [    0.007796]  [<c05d2a67>] check_bugs+0xb/0xf1
| [    0.007872]  [<c05cc966>] start_kernel+0x293/0x2a7
| [    0.008011]  [<c05cc30b>] i386_start_kernel+0x65/0x6a
| 
| 
| Simon Holm Thøgersen

Hi Simon, thanks a lot for report! Will take a look.

	-- Cyrill
