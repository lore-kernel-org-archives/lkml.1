Return-Path: <linux-kernel-owner+w=401wt.eu-S1766016AbYD3WPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766016AbYD3WPB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756384AbYD3WOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:14:51 -0400
Received: from gate.crashing.org ([63.228.1.57]:53632 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756073AbYD3WOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:14:51 -0400
Cc: Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "\"Zhang Wei\" rdunlap@xenotime.net" <Wei.Zhang@freescale.com>,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       mporter@kernel.crashing.org, benh@kernel.crashing.org,
       linuxppc-dev@ozlabs.org
Message-Id: <63DC9937-3C82-4744-8281-B9FDB941FEE1@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
In-Reply-To: <20080430151149.063920cf.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [PATCH] docbook: fix fatal rapidio yet again (and more to come)
Date: Wed, 30 Apr 2008 17:14:26 -0500
References: <Pine.LNX.4.64.0804292009000.18219@shark.he.net> <20080430113500.dfe21880.akpm@linux-foundation.org> <51A34080-7981-4958-B225-4921FC95B84A@kernel.crashing.org> <20080430121239.28492328.akpm@linux-foundation.org> <18456.60948.463017.139935@cargo.ozlabs.ibm.com> <20080430151149.063920cf.randy.dunlap@oracle.com>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 30, 2008, at 5:11 PM, Randy Dunlap wrote:
> On Thu, 1 May 2008 08:09:24 +1000 Paul Mackerras wrote:
>
>> Andrew Morton writes:
>>
>>>> Odd.  I thought Paul had picked up a docbook RapidIO patch from  
>>>> you in
>>>> the latest merge round.
>>>>
>>>
>>> Well it's more than "a" patch.  The six-week-old patch series is:
>>>
>>> rapidio-add-memory-mapping-driver-to-rapidio.patch
>>> rapidio-add-rapidio-space-allocation-bitmap-arithmetic.patch
>>> rapidio-add-fsl-rapidio-controller-memory-ops-functions.patch
>>> rapidio-add-the-rapidio-master-port-maintance-and-doorbell-window- 
>>> to-space-resources.patch
>>> rapidio-add-rapidio-proc-fs-for-memory-mapping-debugging.patch
>>> rapidio-add-the-memory-mapping-support-in-rionet-driver.patch
>>> rapidio-fix-docbook-references.patch
>>> rapidio-fix-kernel-doc-problems.patch
>>
>> What happened is that you (Andrew) sent them on to me pretty much
>> unexamined.  I took a look at them and dropped one of them because it
>> created a new /proc file.  I asked Kumar to look at them and he had
>> issues with another three of the patches, and dropping those meant
>> that all the following ones (including the fix-kernel-doc one)
>> wouldn't apply, so I dropped them too.  I applied the rest and sent
>> them to Linus.
>>
>>> (seems that I forgot to cc Jeff on the rionet change too).
>>
>> Yeah.  I nearly dropped that one too.  I probably should have. :)
>>
>>> Oh well.  If nobody puts their hand up in the next 24 hours or so  
>>> I'll just
>>> send it all in to Linus.
>>
>> Please don't.  At this stage I think the best thing is for Kumar to
>> talk to Zhang Wei (they both work for Freescale, so that should be
>> possible in theory :) and get him to rework the remaining patches as
>> required for inclusion in 2.6.27.
>
> Just to be clear, the docbook changes shouldn't wait for 2.6.27.
> There's no need for that.

Can the docbook be respun against linus's tree?

-k
