Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752517AbYLQUyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbYLQUyh (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 15:54:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbYLQUy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 15:54:27 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:44339 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbYLQUy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 15:54:26 -0500
Message-ID: <494966E3.2020506@linux.vnet.ibm.com>
Date: Wed, 17 Dec 2008 12:53:55 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: William Cohen <wcohen@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "David S. Miller" <davem@davemloft.net>,
        Robert Richter <robert.richter@amd.com>,
        Eric Dumazet <dada1@cosmosbay.com>,
        Stephane Eranian <eranian@googlemail.com>,
        Paul Mackerras <paulus@samba.org>, Peter Anvin <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        perfctr-devel@lists.sourceforge.net,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [Perfctr-devel] [patch] Performance Counters for Linux, v4
References: <20081214212829.GA9435@elte.hu> <49492210.1070007@redhat.com>
In-Reply-To: <49492210.1070007@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

William Cohen wrote:
> Ingo Molnar wrote:
>> We are pleased to announce the v4 release of our performance counters 
>> subsystem implementation. The kernel changes can be picked up from:
>>
>>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git 
>> perfcounters/core
>>
>>   (also in the master branch. There's also a kernel patch attached    
>> below.)
> 
> Machines that support virtualization are becoming very common.  How is
> this performance monitoring support going to work with virtualization
> (e.g. KVM)? Having the performance counters only work on physical
> machines would be pretty limiting.

On Power machines, the PMU counter registers are virtualized by the 
hypervisor, at the request of the OS, on a per-cpu/per-partition basis. 
  So this issue is handled transparently on Power anyway.

- Corey

Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
Beaverton, OR
503-578-3507
cjashfor@us.ibm.com

