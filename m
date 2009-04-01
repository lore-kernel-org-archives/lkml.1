Return-Path: <linux-kernel-owner+w=401wt.eu-S1756968AbZDAJbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968AbZDAJbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 05:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbZDAJa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 05:30:59 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:49376 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752599AbZDAJa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 05:30:58 -0400
Subject: Re: linux-next: Tree for March 30: [BUG] kmemleak page fault
From: Catalin Marinas <catalin.marinas@arm.com>
To: Matthias Kaehlcke <matthias@kaehlcke.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090330122437.GA4784@traven>
References: <20090330200145.8d0da09b.sfr@canb.auug.org.au>
	 <20090330122437.GA4784@traven>
Content-Type: text/plain
Organization: ARM Ltd
Date: Wed, 01 Apr 2009 10:30:08 +0100
Message-Id: <1238578208.14550.4.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Apr 2009 09:30:42.0401 (UTC) FILETIME=[86E47D10:01C9B2AC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-30 at 14:24 +0200, Matthias Kaehlcke wrote:
> linux-next 20090330 causes the following page fault on an edb9302
> (ARM) like board:
> 
> # Unable to handle kernel paging request at virtual address 00535447
> pgd = c56b0000
> [00535447] *pgd=00000000
> Internal error: Oops: 3 [#1] PREEMPT
> Modules linked in:
> CPU: 0    Not tainted  (2.6.29-next-20090330 #6)
> PC is at kmemleak_scan+0x158/0x3ac
> LR is at find_and_get_object+0xe0/0x104
> pc : [<c00aa5cc>]    lr : [<c00a99d8>]    psr: 00000013
> sp : c55bff78  ip : c55bff28  fp : c55bffa4
> r10: c0322718  r9 : c035fa6c  r8 : c035f048
> r7 : c035f044  r6 : 00005800  r5 : 00004981  r4 : 00093020
> r3 : 00535443  r2 : 414f4c5f  r1 : 00000001  r0 : c0400020
> Flags: nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
> Control: 0000717f  Table: 0567c000  DAC: 00000017
> Process kmemleak (pid: 343, stack limit = 0xc55be268)
[...]
> the fault is reproducible and happens some seconds after having
> finished the boot process. please tell me if you need more information
> (like the .config, ...) in order to track this down

Yes, the .config would be useful. I'm mainly interested in which slab
allocator you are using. I'm testing kmemleak mainly on ARM and haven't
seen any issues.

Thanks.

-- 
Catalin

