Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857AbZFMIpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbZFMIpA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 04:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750929AbZFMIov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 04:44:51 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:52577 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbZFMIot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 04:44:49 -0400
Message-ID: <4A336700.3060309@linux.vnet.ibm.com>
Date: Sat, 13 Jun 2009 01:44:48 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: perf_counters: page fault trace record
References: <4A330022.3070105@linux.vnet.ibm.com> <18995.8319.322002.917595@cargo.ozlabs.ibm.com>
In-Reply-To: <18995.8319.322002.917595@cargo.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras wrote:
> Corey Ashford writes:
> 
>> One of the tools we are working on needs to be able to look not only at counts 
>> of page faults, but where they are occurring (ip and faulting page address).
>>
>> What would you think about adding a new bit to the config record, something like:
> 
> Can't you do what you need just using a page fault software counter
> with sample_type = PERF_SAMPLE_IP | PERF_SAMPLE_ADDR and
> sample_period = 1?

I thought about that, but I was under the (incorrect?) impression that 
on Power, the PERF_SAMPLE_ADDR would be set by the value of the SDAR 
register, which wouldn't be correct for the case of a page fault.

I need to go look at the kernel code :)

- Corey

