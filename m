Return-Path: <linux-kernel-owner+w=401wt.eu-S1753353AbZLWCFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbZLWCFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 21:05:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbZLWCFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 21:05:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:59614 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433AbZLWCFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 21:05:13 -0500
Message-ID: <4B317B5E.1010500@kernel.org>
Date: Wed, 23 Dec 2009 11:07:26 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [this_cpu_xx V8 07/16] Module handling: Use this_cpu_xx to dynamically
 allocate counters
References: <20091218222617.384355422@quilx.com> <20091218222651.319887863@quilx.com> <4B2F2820.5030904@kernel.org> <alpine.DEB.2.00.0912220956340.12163@router.home>
In-Reply-To: <alpine.DEB.2.00.0912220956340.12163@router.home>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2009 12:57 AM, Christoph Lameter wrote:
> On Mon, 21 Dec 2009, Tejun Heo wrote:
> 
>>
>>> Index: linux-2.6/kernel/trace/ring_buffer.c
>>> ===================================================================
>>> --- linux-2.6.orig/kernel/trace/ring_buffer.c	2009-12-18 13:13:24.000000000 -0600
>>> +++ linux-2.6/kernel/trace/ring_buffer.c	2009-12-18 14:15:57.000000000 -0600
>>> @@ -12,6 +12,7 @@
>>>  #include <linux/hardirq.h>
>>>  #include <linux/kmemcheck.h>
>>>  #include <linux/module.h>
>>> +#include <asm/local.h>
>>
>> This doesn't belong to this patch, right?  I stripped this part out,
>> added Cc: to Rusty and applied 1, 2, 7 and 8 to percpu branch.  I'll
>> post the updated patch here. Thanks.
> 
> If you strip this part out then ringbuffer.c will no longer compile
> since it relies on the "#include <local.h>" that is removed by this patch
> from the module.h file.

Oh... alright.  I'll add that comment and drop the offending chunk and
recommit.

Thanks.

-- 
tejun
