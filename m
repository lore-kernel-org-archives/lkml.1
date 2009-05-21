Return-Path: <linux-kernel-owner+w=401wt.eu-S1755312AbZEUN3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbZEUN3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 09:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbZEUN3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 09:29:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39462 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752829AbZEUN3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 09:29:10 -0400
Message-ID: <4A155720.7050907@redhat.com>
Date: Thu, 21 May 2009 16:29:04 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       sfr@canb.auug.org.au, kvm@vger.kernel.org
Subject: Re: [PATCH] kvm: fix irqfd build failure discovered in linux-next
References: <20090521172122.bb12027c.sfr@canb.auug.org.au> <20090521130426.22997.77787.stgit@dev.haskins.net> <4A1552B1.3040502@redhat.com> <4A155669.4010506@novell.com>
In-Reply-To: <4A155669.4010506@novell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
>>>  EXTRA_CFLAGS += -Ivirt/kvm -Iarch/x86/kvm
>>> +EXTRA_CFLAGS += -DKVM_HAVE_EVENTFD
>>>  
>>>   
>>>       
>> The standard idiom for this is to use a Kconfig symbol; see for
>> example HAVE_KVM_IRQCHIP in arch/*/kvm/Kconfig.
>>     
>
> Ah, I didn't realize I could do this in such a contained manner.  I was
> afraid of polluting the top level arch/Kconfig, which is why I went this
> other route.   But I see from your example that this is not the case.  I
> will make a v2 with this change.
>   

Note the situation is not as good as it could be, as you have to 
replicate the Kconfig for each arch.  One day I'll set up 
virt/kvm/Kconfig which will set up defaults, so archs can override them.

-- 
error compiling committee.c: too many arguments to function

