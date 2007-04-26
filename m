Return-Path: <linux-kernel-owner+w=401wt.eu-S933204AbXDZH51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933204AbXDZH51 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 03:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933368AbXDZH51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 03:57:27 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:40054 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933204AbXDZH50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 03:57:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=lszsAx/UsA74M5t+TY7gRjHgt0awY9fSlcZx4ARsz3gnrbpxPudaBCyxlD216V13yrCd9fz9ECu+rhCiRTM+IKT5c4KH8qA9Fjd8ZawU+AY+ogv/bBWXg4RWDIafiQeDd45IJg3/ovUdM3TgcJK28Oc484XqTzveTsE9rM57b5U=  ;
X-YMail-OSG: ZHt50cMVM1lodZ8MXc.FlsirNaFyacVEg4FUrRb3KsGFhkVdshpwAfDqSJ50MIgeJS2ghxsTIw--
Message-ID: <46304D50.1040706@yahoo.com.au>
Date: Thu, 26 Apr 2007 16:57:20 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0704252154250.29271@schroedinger.engr.sgi.com> <m1abwvofke.fsf@ebiederm.dsl.xmission.com> <463048FE.5000600@yahoo.com.au> <Pine.LNX.4.64.0704252341560.30340@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0704252341560.30340@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Thu, 26 Apr 2007, Nick Piggin wrote:
> 
> 
>>Yeah. IMO anti-fragmentation and defragmentation is the hack, and we
>>should stay away from higher order allocations whenever possible.
> 
> 
> Right and we need to create series of other approaches that we then label 
> "non-hack" to replace it. 

I don't understand? We're talking about several utterly different designs
to approach these problems. You don't agree that one might be better than
another?


>>Hardware is built to handle many small pages efficintly, and I don't
>>understand how it could be an SGI-only issue. Sure, you may have an
>>order of magnitude or more memory than anyone else, but even my lowly
>>desktop _already_ has orders of magnitude more pages than it has TLB
>>entries or cache -- if a workload is cache-nice for me, it probably
>>will be on a 1TB machine as well, and if it is bad for the 1TB machine,
>>it is also bad on mine.
> 
> 
> There have been numbers of people that have argued the same point. Just 
> because we have developed a way of thinking to defend our traditional 4k 
> values does not make them right.
> 
> 
>>If this is instead an issue of io path or reclaim efficiency, then it
>>would be really nice to see numbers... but I don't think making these
>>fundamental paths more complex and slower is a nice way to fix it
>>(larger PAGE_SIZE would be, though).
> 
> 
> The code paths can stay the same. You can switch CONFIG_LARGE pages off
> if you do not want it and it is as it was.

That isn't a good reason to merge something. If you don't have numbers then
that just seems incredible.


> If you would have a look the patches: The code is significantly cleanup 
> and easier to read.

Cleanups are fine.

-- 
SUSE Labs, Novell Inc.
