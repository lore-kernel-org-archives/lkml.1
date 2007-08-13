Return-Path: <linux-kernel-owner+w=401wt.eu-S1031190AbXHMNNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031190AbXHMNNO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:13:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S970058AbXHMIiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 04:38:08 -0400
Received: from il.qumranet.com ([82.166.9.18]:52838 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S970051AbXHMIiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 04:38:05 -0400
Message-ID: <46C01877.7060007@qumranet.com>
Date: Mon, 13 Aug 2007 11:38:15 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Laurent Vivier <Laurent.Vivier@bull.net>
CC: kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [kvm-devel] [PATCH 0/2][KVM] guest time accounting
References: <46BC8B39.6050202@bull.net> <46C00FC1.1070306@qumranet.com> <46C012A8.2040908@bull.net>
In-Reply-To: <46C012A8.2040908@bull.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Vivier wrote:
>> - perhaps the new fields should be guarded by a #ifdef CONFIG_HYPERVISOR
>> (selected by CONFIG_KVM)?  that way the (minor) additional overhead is
>> only incurred if it can possibly be used.  I imagine that our canine
>> cousin will want to use this as well.
>>     
>
> There is also a CONFIG_VIRTUALIZATION and a CONFIG_VIRT_CPU_ACCOUNTING (from
> s390 and powerpc) Which one to use ?
>   

Are these options for using the kernel as a guest or host?  I'd guess 
the former.

> I'm wondering if we can have a more accurate accounting:
>
> - For the moment we add all system time since the previous entering to the VCPU
> to the guest time (and I guess there is some real system time in it ???)
>
> - Perhaps we can sum nanoseconds spent in the VCPU and add it to cpustat when
> these ns are greater than 1 ms ? (I'm trying to make something in this way)
>   

I think that it's okay to use the same method as user/system time 
accounting.  But Ingo the the right man to ask.


-- 
error compiling committee.c: too many arguments to function

