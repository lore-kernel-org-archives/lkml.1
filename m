Return-Path: <linux-kernel-owner+w=401wt.eu-S1754651AbXJaGLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbXJaGLy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 02:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbXJaGLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 02:11:46 -0400
Received: from gatekeeper.ncic.ac.cn ([159.226.41.188]:63934 "HELO ac.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752499AbXJaGLp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 02:11:45 -0400
Message-ID: <47281C75.4040106@sina.com.cn>
Date: Wed, 31 Oct 2007 14:11:01 +0800
From: tgh <wwwwww4187@sina.com.cn>
User-Agent: Thunderbird 1.5.0.7 (Windows/20060909)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Andi Kleen <ak@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Andrew Morton <akpm@linux-foundation.com>
Subject: Re: [Xen-devel] [patch 30/44] xen: Add support for preemption
References: <20070716231536.937393000@xensource.com>>	<20070716232915.672717000@xensource.com>>	<4726F51C.4030709@sina.com.cn>	<4727690F.4030502@goop.org> <4727D926.6050004@sina.com.cn> <4727DC88.2020803@goop.org>
In-Reply-To: <4727DC88.2020803@goop.org>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for your reply
and what about the kernel thread in the xen hypervisor,are there some
instance of kernel threads running in the hypervisor?
I am not sure ,but somewhere I read that there is no kernel thread in
the xen hypervisor ,is it true or what about it?

Thanks in advance


Jeremy Fitzhardinge Ð´µÀ:
> tgh wrote:
>   
>> Thank for your reply
>> and I still have several questions
>>   
>>     
>>> Yes, that's the normal mode of operation. The hypervisor will timeslice
>>> multiple vcpus onto a single vcpu.
>>>   
>>>     
>>>       
>> that is ,the VM could be preempted by xen,and could xen hypervisor also
>> be preempted to reschedule other vm or xen kernel thread?and are there
>> the counterpart abstractions in xen for kernel thread in linux?
>>   
>>     
>
> Yes, a vcpu in Xen is the same as a task in the kernel. In the same way
> the kernel multiplexes multiple tasks onto your cpu(s), Xen multiplexes
> multiple vcpus onto your cpu(s). This isn't directly visible to the
> guest kernel, in the same way that user processes can't generally
> observe timeslicing.
>
>   
>>> This patch doesn't relate to that; it's whether a Xen Linux guest's
>>> kernel can be preempted to reschedule processes while running under Xen.
>>>   
>>>     
>>>       
>> that is ,the patch makes the guest's kernel, rather than xen, be able to
>> be preempted ,is it right?
>>   
>>     
>
> Yes. Previous to that change, kernel preemption was disabled when
> compiling Xen support in.
>
> J
>
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
>
>
>   

