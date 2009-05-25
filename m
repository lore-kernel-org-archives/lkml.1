Return-Path: <linux-kernel-owner+w=401wt.eu-S1754205AbZEYSJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbZEYSJp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 14:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbZEYSJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 14:09:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55030 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656AbZEYSJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 14:09:35 -0400
Message-ID: <4A1ADED5.4020605@redhat.com>
Date: Mon, 25 May 2009 21:09:25 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: Huang Ying <ying.huang@intel.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v3] KVM: MCE: Add MCE support to KVM
References: <1242031695.8213.17.camel@yhuang-dev.sh.intel.com> <4A105DE2.8090200@redhat.com> <4A1AD816.1060702@siemens.com>
In-Reply-To: <4A1AD816.1060702@siemens.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kiszka wrote:
> Avi Kivity wrote:
>   
>> Huang Ying wrote:
>>     
>>> The related MSRs are emulated. MCE capability is exported via
>>> extension KVM_CAP_MCE and ioctl KVM_X86_GET_MCE_CAP_SUPPORTED.  A new
>>> vcpu ioctl command KVM_X86_SETUP_MCE is used to setup MCE emulation
>>> such as the mcg_cap. MCE is injected via vcpu ioctl command
>>> KVM_X86_SET_MCE. Extended machine-check state (MCG_EXT_P) and CMCI are
>>> not implemented.
>>>
>>>   
>>>       
>> Applied, thanks.
>>
>>     
>
> This patch breaks kvm build for 32-bit hosts.
>   

Strange, I build-test on i386.  What's your failure?

> Is the KVM MCE interface completely or only partially limited to x86-64,
> ie. can I completely #ifdef it away on 32-bit hosts (including
> KVM_CAP_MCE) or is this more complicated?
>   

I don't see any reason to limit it to x86_64?

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

