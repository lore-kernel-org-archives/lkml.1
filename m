Return-Path: <linux-kernel-owner+w=401wt.eu-S933966AbZFOUi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933966AbZFOUi7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 16:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755158AbZFOUiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 16:38:52 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:60767 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbZFOUiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 16:38:51 -0400
Message-ID: <4A36B15E.80806@linux.vnet.ibm.com>
Date: Mon, 15 Jun 2009 13:38:54 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: perf_counters: page fault trace record
References: <4A330022.3070105@linux.vnet.ibm.com> <18995.8319.322002.917595@cargo.ozlabs.ibm.com> <4A336700.3060309@linux.vnet.ibm.com> <18995.28357.164575.925080@cargo.ozlabs.ibm.com> <20090613100916.GA9959@elte.hu>
In-Reply-To: <20090613100916.GA9959@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Paul Mackerras <paulus@samba.org> wrote:
> 
>> Corey Ashford writes:
>>
>>> Paul Mackerras wrote:
>>>> Can't you do what you need just using a page fault software 
>>>> counter with sample_type = PERF_SAMPLE_IP | PERF_SAMPLE_ADDR 
>>>> and sample_period = 1?
>>> I thought about that, but I was under the (incorrect?) 
>>> impression that on Power, the PERF_SAMPLE_ADDR would be set by 
>>> the value of the SDAR register, which wouldn't be correct for 
>>> the case of a page fault.
>> No, the PERF_SAMPLE_ADDR value only comes from SDAR for a hardware 
>> counter overflow event.  For the page-fault software counter the 
>> PERF_SAMPLE_ADDR value will always be the faulting address.
> 
> Corey, could you please add support for it in 'perf'? We dont want 
> such sw-counter features to be in the kernel code without matching 
> support in tools/perf/.
> 
> While user data symbols wont be resolved, if we have a 
> --target-address switch in perf record we could see the faulting 
> frequency (and the fault coverage - and ordering as well) of shared 
> libraries, in perf report and perf annotate.
> 
> This would be a very useful facility.
> 
> Thanks,
> 
> 	Ingo

I'll see what I can do.  This will be my first time modifying perf, so expect 
that I won't do things the way you prefer the first couple of go-arounds :)

Regards,

- Corey


