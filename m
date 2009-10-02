Return-Path: <linux-kernel-owner+w=401wt.eu-S1757260AbZJBIJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260AbZJBIJ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 04:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754482AbZJBIJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 04:09:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43213 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753447AbZJBIJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 04:09:53 -0400
Message-ID: <4AC5B59E.3050608@suse.de>
Date: Fri, 02 Oct 2009 13:41:10 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, Neil Brown <neilb@suse.de>,
       Miklos Szeredi <mszeredi@suse.cz>, Wouter Verhelst <w@uter.be>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, trond.myklebust@fys.uio.no
Subject: Re: [PATCH 03/31] mm: expose gfp_to_alloc_flags()
References: <1254405903-15760-1-git-send-email-sjayaraman@suse.de> <alpine.DEB.1.00.0910011355230.32006@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.1.00.0910011355230.32006@chino.kir.corp.google.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> On Thu, 1 Oct 2009, Suresh Jayaraman wrote:
> 
>> From: Peter Zijlstra <a.p.zijlstra@chello.nl> 
>>
>> Expose the gfp to alloc_flags mapping, so we can use it in other parts
>> of the vm.
>>
>> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
> 
> Nack, these flags are internal to the page allocator and exporting them to 
> generic VM code is unnecessary.

Yes, you're right.

> The only bit you actually use in your patchset is ALLOC_NO_WATERMARKS to 
> determine whether a particular allocation can use memory reserves.  I'd 
> suggest adding a bool function that returns whether the current context is 
> given access to reserves including your new __GFP_MEMALLOC flag and 
> exporting that instead.

Makes sense and Neil already posted a patch citing the suggested
changes, will incorporate the change.

Thanks,

-- 
Suresh Jayaraman
