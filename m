Return-Path: <linux-kernel-owner+w=401wt.eu-S1755197AbYCLSLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbYCLSLW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 14:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbYCLSLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 14:11:13 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:49076 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbYCLSLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 14:11:12 -0400
Subject: Re: [BUG] 2.6.25-rc5-mm1 kernel panic with "Exception: 501 " on
	powerpc
From: Badari Pulavarty <pbadari@gmail.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <47D7D2C9.4090001@linux.vnet.ibm.com>
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>
	 <47D7D2C9.4090001@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Wed, 12 Mar 2008 10:14:36 -0800
Message-Id: <1205345676.23611.9.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-03-12 at 18:25 +0530, Kamalesh Babulal wrote:
> Hi Andrew,
> 
> The 2.6.25-rc5-mm1 kernel panics while bootup on powerpc
> 
> returning from prom_init
> Unable to handle kernel paging request for data at address 0x00000000
> Faulting instruction address: 0xc00000000000d5dc
> cpu 0x0: Vector: 300 (Data Access) at [c0000000007636e0]
>     pc: c00000000000d5dc: .do_IRQ+0x74/0x1f4
>     lr: c00000000000d5a8: .do_IRQ+0x40/0x1f4
>     sp: c000000000763960
>    msr: 8000000000001032
>    dar: 0
>  dsisr: 40000000
>   current = 0xc000000000688e60
>   paca    = 0xc000000000689900
>     pid   = 0, comm = swapper
> enter ? for help
> [c000000000763a00] c000000000004c24 hardware_interrupt_entry+0x24/0x28
> --- Exception: 501 (Hardware Interrupt) at c0000000006021b0 .free_bootmem_core+0x94/0xcc
> [link register   ] c00000000060373c .free_bootmem_with_active_regions+0x78/0xb8
> [c000000000763cf0] c000000000602610 .init_bootmem_core+0x5c/0xfc (unreliable)
> [c000000000763d80] c0000000005eb68c .do_init_bootmem+0x964/0xaf0
> [c000000000763e50] c0000000005e03b0 .setup_arch+0x1a4/0x218
> [c000000000763ee0] c0000000005d76bc .start_kernel+0xe8/0x424
> [c000000000763f90] c000000000008590 .start_here_common+0x60/0xd0

Is this only on one machine ? happens all the time ?

I ran into similar issues on rc3-mm1. rc5-mm1 seems to be working fine
for me on ppc64.

Thanks,
Badari

