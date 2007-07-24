Return-Path: <linux-kernel-owner+w=401wt.eu-S1756886AbXGXFfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbXGXFfa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 01:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbXGXFfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 01:35:20 -0400
Received: from il.qumranet.com ([82.166.9.18]:57834 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbXGXFfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 01:35:18 -0400
Message-ID: <46A58F88.9050906@qumranet.com>
Date: Tue, 24 Jul 2007 08:35:04 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: kvm-devel <kvm-devel@lists.sourceforge.net>,
       lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC 1/8]KVM: fix bugs in kvm sched integration patch
References: <1185173492.2645.65.camel@sli10-conroe.sh.intel.com>	 <46A48713.9080404@qumranet.com> <1185241544.24201.15.camel@sli10-conroe.sh.intel.com>
In-Reply-To: <1185241544.24201.15.camel@sli10-conroe.sh.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Tue, 24 Jul 2007 08:35:04 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohua Li wrote:
>>
>>> 1. vmcs_readl/vmcs_writel are called with preempt enabled
>>>  
>>>       
>> Why is that bad?
>>     
> 1. raw_smp_processor_id()
> 2. migrate to other cpu
> 3. current->kvm_vcpu->cpu != the cpu id of step 1.
> you will see the warning.
>   

Ah, that code is gone from preempt-hooks, hence I didn't understand you.

The current version of the patchset does not change
vmcs_readl/vmcs_writel.  So I think everything is safe.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

