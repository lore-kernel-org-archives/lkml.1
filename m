Return-Path: <linux-kernel-owner+w=401wt.eu-S933749AbXCOUP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933749AbXCOUP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 16:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933758AbXCOUP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 16:15:26 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:45051 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933749AbXCOUPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 16:15:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=gZPiHxJSnFmaU/d+75omIgjRp/7I9ym8yTM0rvfczZpsZTISGCzxEoPm+GK2+V5744YFqJm8B03uuG7e0BAyCRp0Hr3wxAzvhChyRWkUFxsjhPWpKx9wyoIa5AJtpNP06VfANm7pB8sF87Bwthrx51vXiQyoaxbGnZNnAANuYDg=  ;
X-YMail-OSG: hVNx2JAVM1lefeTpxXRQAoxlrV3AJwZnwcpO85JA.uGE1UcjPL.mXa3vlaPE069Wpc4pFKLgn3mAB.yDBR.fSM7XKVvUQ8BTiMmu9bMEJH05LA8DqSp1iTQknjJlUj8tPZzv7OKmzZJ228M-
Message-ID: <45F9A954.9010400@yahoo.com.au>
Date: Fri, 16 Mar 2007 07:15:16 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Ulrich Drepper <drepper@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Ravikiran G Thirumalai <kiran@scalex86.org>,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>,
       pravin b shelar <pravin.shelar@calsoftinc.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] FUTEX : new PRIVATE futexes, SMP and NUMA improvements
References: <20060808070708.GA3931@localhost.localdomain> <200608090826.28249.dada1@cosmosbay.com> <200608090843.52893.dada1@cosmosbay.com> <200703152010.35614.dada1@cosmosbay.com>
In-Reply-To: <200703152010.35614.dada1@cosmosbay.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> Hi
> 
> I'm pleased to present these patches which improve linux futex performance and 
> scalability, on both UP, SMP and NUMA configs.
> 
> I had this idea last year but I was not understood, probably because I gave 
> not enough explanations. Sorry if this mail is really long...

Yes please, this is really nice. The mmap_sem is already overworked just
doing real mm stuff, let alone making it the central point of our "scalable"
thread synchronisation syscall.

To summarise: not only will this make futexes scale much better, but it will
also take some load off mmap_sem.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
