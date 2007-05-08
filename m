Return-Path: <linux-kernel-owner+w=401wt.eu-S967575AbXEHMIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967575AbXEHMIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 08:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967426AbXEHMIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 08:08:17 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:50259 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967424AbXEHMIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 08:08:15 -0400
Message-ID: <46406816.8030106@in.ibm.com>
Date: Tue, 08 May 2007 17:37:50 +0530
From: Srinivasa Ds <srinivasa@in.ibm.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: kernel expection generated with 2.6.21-mm1 kernel boot up
References: <463F196C.9070501@linux.vnet.ibm.com>
In-Reply-To: <463F196C.9070501@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kamalesh Babulal wrote:
> Hi,
> 
> I tried compiling and booting up with 2.6.21-mm1 kernel
> on the following machine
> 
> Architecture      :    PPC64
> CPU Type           :    POWER5 (gr)
> Machine Type    :    CHRP IBM,9117-570
> Base OS              :    Fedora Core 5
> 

> 
> Faulting instruction address: 0xc0000000000cc5e4
> 
> cpu 0x1: Vector: 300 (Data Access) at [c000000005373320]
> 
>   pc: c0000000000cc5e4: .slab_free+0x6c/0x424
> 
>   lr: c00000000002fa70: .pgtable_free_tlb+0xd0/0x140
> 
>   sp: c0000000053735a0
> 
>  msr: 8000000000009032
> 

Looks like there is a bug in SLUB implementaion for ppc64 in 2.6.21-mm1.
I unmarked CONFIG_SLUB and build the kernel, its booting cleary now.

Thanks
 Srinivasa DS
