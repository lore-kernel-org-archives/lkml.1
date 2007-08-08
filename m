Return-Path: <linux-kernel-owner+w=401wt.eu-S935114AbXHHWsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935114AbXHHWsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 18:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760032AbXHHWsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 18:48:07 -0400
Received: from il.qumranet.com ([82.166.9.18]:50144 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755873AbXHHWsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 18:48:06 -0400
Message-ID: <46BA4827.3080907@qumranet.com>
Date: Thu, 09 Aug 2007 01:48:07 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: kvm warning
References: <20070808151446.9a4eebda.akpm@linux-foundation.org> <20070808221956.GA16238@elte.hu>
In-Reply-To: <20070808221956.GA16238@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Andrew Morton <akpm@linux-foundation.org> wrote:
>
>   
>> ia64 allmodconfig says
>>
>> drivers/kvm/Kconfig:14:warning: 'select' used by config symbol 'KVM' 
>> refers to undefined symbol 'PREEMPT_NOTIFIERS'
>>     
>
> hm, why doesnt ia64 pick up kernel/Kconfig.preempt, like all the other 
> arches? Due to that ia64 also misses out on voluntary preempt and on 
> preempt-bkl.
>
>   

Even more hm, how does ia64 manage to enable kvm?  It 'depends on X86' 
at this moment.


