Return-Path: <linux-kernel-owner+w=401wt.eu-S1763702AbZFRMvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763702AbZFRMvb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 08:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763100AbZFRMuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 08:50:37 -0400
Received: from gate.crashing.org ([63.228.1.57]:41804 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762865AbZFRMuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 08:50:35 -0400
Cc: Ingo Molnar <mingo@elte.hu>, benh@kernel.crashing.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Message-Id: <E57BFC08-F847-463A-9D0F-55979C4B0524@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Paul Mackerras <paulus@samba.org>
In-Reply-To: <19001.31508.901222.288946@cargo.ozlabs.ibm.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Re: [PATCH 5/6] perf_counter: powerpc: Add processor back-end for MPC7450 family
Date: Thu, 18 Jun 2009 07:50:10 -0500
References: <19000.55404.103840.393470@cargo.ozlabs.ibm.com> <19000.55631.802122.696927@cargo.ozlabs.ibm.com> <34BD6A89-A05E-40CC-A495-017BFB08B796@kernel.crashing.org> <19001.31508.901222.288946@cargo.ozlabs.ibm.com>
X-Mailer: Apple Mail (2.935.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 17, 2009, at 6:24 PM, Paul Mackerras wrote:

> Kumar Gala writes:
>
>> This should be something like:
>>
>> obj64-$(CONFIG_PPC_PERF_CTRS)-$(PPC_BOOK3S_64)
>>
>>> +obj32-$(CONFIG_PPC_PERF_CTRS)	+= mpc7450-pmu.o
>>
>> obj32-$(CONFIG_PPC_PERF_CTRS)-$(PPC_BOOK3S_32)
>>
>> Or use new Kconfig types as I suggested on patch 1/6
>
> Feel free to send a patch making those changes along with adding the
> code to support the Freescale embedded PMU. :)
>
> Paul.

In looking at doing this what suggestions do you have in implementing  
perf_instruction_pointer() if we don't have the equivalent of SIAR.   
Just use regs->nip ?

- k
