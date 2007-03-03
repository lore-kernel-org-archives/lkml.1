Return-Path: <linux-kernel-owner+w=401wt.eu-S965253AbXCCHBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965253AbXCCHBB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 02:01:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbXCCHBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 02:01:01 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:43803 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751187AbXCCHBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 02:01:00 -0500
Message-ID: <45E91D2B.9040004@vmware.com>
Date: Fri, 02 Mar 2007 23:00:59 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: tim.c.chen@linux.intel.com, linux-kernel@vger.kernel.org,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: Re: system call time increase when turning on CONFIG_PARAVIRT
References: <1172866274.4898.14.camel@localhost.localdomain>	 <45E89CFB.4090905@goop.org> <1172877111.8383.4.camel@localhost.localdomain> <45E8BE79.40200@goop.org>
In-Reply-To: <45E8BE79.40200@goop.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Tim Chen wrote:
>   
>> I also hope that the performance can be recovered as this option could
>> enabled in distributions' kernels in future.
>>     
>
> Yes, the intent is that running a CONFIG_PARAVIRT kernel on native
> hardware will have negligible performance hit compared to running a
> non-paravirt kernel.
>   

We can validate that claim entirely.  The way we are proceeding, the 
native code will be inlined or direct called as much as possible.  With 
the VMI-Linux code we had earlier, this mostly created <3% overhead for 
microbenchmarks (and in some cases, we actually won over the unmodified 
native code).  For macro-benchmarks, with real-world workloads, this 
reduced to immeasurable noise, never off by more than +/- 0.5% IIRC.

I believe all of this is totally achievable.  We have the technology.  
We can rebuild it.

Zach
