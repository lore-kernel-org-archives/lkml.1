Return-Path: <linux-kernel-owner+w=401wt.eu-S1756331AbXKCQsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331AbXKCQsS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 12:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754710AbXKCQsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 12:48:10 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:32954 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429AbXKCQsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 12:48:09 -0400
Message-ID: <472CA62D.8050205@linux.vnet.ibm.com>
Date: Sat, 03 Nov 2007 22:17:41 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] Restore deterministic CPU accounting on powerpc
References: <18218.44089.274628.680088@cargo.ozlabs.ibm.com> <661de9470711030202x24d0186cuc96a70156ecfa23f@mail.gmail.com> <18220.24362.604297.53633@cargo.ozlabs.ibm.com>
In-Reply-To: <18220.24362.604297.53633@cargo.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras wrote:
> Balbir Singh writes:
> 
>> So, scaled accounting will not be available if
>> CONFIG_VIRT_CPU_ACCOUNTING is defined? Am I reading this correctly
> 
> No, what makes you think that?  If VIRT_CPU_ACCOUNTING=y it is the
> responsibility of the arch's account_process_tick to update the scaled
> stats.  And the powerpc version does that by calling
> account_user_time_scaled().
> 
> Paul.

I looked at the diff's and could just see the reversal of scaled
accounting. I looked at account_process_vtime(), now
account_process_tick() and things seem fine. I was mislead by the
diff.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
