Return-Path: <linux-kernel-owner+w=401wt.eu-S1752153AbXGHMmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbXGHMmN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 08:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751415AbXGHMl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 08:41:59 -0400
Received: from il.qumranet.com ([82.166.9.18]:55130 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085AbXGHMl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 08:41:59 -0400
Message-ID: <4690DB9C.3010605@qumranet.com>
Date: Sun, 08 Jul 2007 15:42:04 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH 09/20] KVM: MMU: Fix Wrong tlb flush order
References: <11838956891287-git-send-email-avi@qumranet.com> <1183895689306-git-send-email-avi@qumranet.com> <20070708122137.GB30226@elte.hu>
In-Reply-To: <20070708122137.GB30226@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Avi Kivity <avi@qumranet.com> wrote:
>
>   
>> From: Shaohua Li <shaohua.li@intel.com>
>>
>> Need to flush the tlb after updating a pte, not before.
>>     
>
>   
>>  		rmap_remove(vcpu, spte);
>> -		kvm_flush_remote_tlbs(vcpu->kvm);
>>  		set_shadow_pte(spte, *spte & ~PT_WRITABLE_MASK);
>> +		kvm_flush_remote_tlbs(vcpu->kvm);
>>     
>
> hm, isnt this a must-have fix for v2.6.22 (and .21) as well?
>   

Guest SMP support is only enabled by another patch in this patchset.


-- 
error compiling committee.c: too many arguments to function

