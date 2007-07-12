Return-Path: <linux-kernel-owner+w=401wt.eu-S1757542AbXGLFsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542AbXGLFsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 01:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbXGLFsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 01:48:06 -0400
Received: from il.qumranet.com ([82.166.9.18]:41991 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbXGLFsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 01:48:04 -0400
Message-ID: <4695C092.4070609@qumranet.com>
Date: Thu, 12 Jul 2007 08:48:02 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, shaohua.li@intel.com
Subject: Re: [PATCH 1/2] SCHED: Generic hooks for trapping task preemption
References: <11841693332609-git-send-email-avi@qumranet.com>	 <11841693333159-git-send-email-avi@qumranet.com> <1184217293.6005.754.camel@localhost.localdomain>
In-Reply-To: <1184217293.6005.754.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Thu, 12 Jul 2007 08:48:02 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Wed, 2007-07-11 at 18:55 +0300, Avi Kivity wrote:
>   
>> +	fire_sched_out_preempt_hooks(current);
>>    	prepare_lock_switch(rq, next);
>>  	prepare_arch_switch(next);
>>     
>
> Damn, I just found a use for this in lguest.
>
> Any chance of handing "next" to the sched_out hook so we can optimize
> the lguest <-> lguest switch?
>
> FYI, lguest turns off PGE globally when you load the module, because
> turning it off on each guest entry v. slow.  With these hooks I can be
> far smarter...
>   

Sure thang.  Will be there in the next version.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

