Return-Path: <linux-kernel-owner+w=401wt.eu-S1762913AbZFLIQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762913AbZFLIQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 04:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758169AbZFLIQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 04:16:15 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:54403 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508AbZFLIQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 04:16:13 -0400
Message-ID: <4A320ECC.6000107@in.ibm.com>
Date: Fri, 12 Jun 2009 13:46:12 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PowerPC] 2.6.30-git3 build break : perf counters
References: <4A31ECCD.7030805@in.ibm.com> <1244788494.5554.1.camel@ht.satnam>
In-Reply-To: <1244788494.5554.1.camel@ht.satnam>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
> Please check this patch :
>
> [PATCH] powerpc: perf_counter fix performance counter event types
>
> Fix compilation warnings :
>  CC      arch/powerpc/kernel/power7-pmu.o
> arch/powerpc/kernel/power7-pmu.c:297: error: PERF_COUNT_CPU_CYCLES undeclared here (not in a function)
> arch/powerpc/kernel/power7-pmu.c:297: error: array index in initializer not of integer type
> arch/powerpc/kernel/power7-pmu.c:297: error: (near initialization for power7_generic_events)
> arch/powerpc/kernel/power7-pmu.c:298: error: PERF_COUNT_INSTRUCTIONS undeclared here (not in a function)
> arch/powerpc/kernel/power7-pmu.c:298: error: array index in initializer not of integer type
> ......<SNIP>......
>
> Reported-by: Sachin Sant <sachinp@in.ibm.com>
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>   
Yes this fixed the build error.

Thanks
-Sachin


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

