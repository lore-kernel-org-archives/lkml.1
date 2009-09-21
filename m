Return-Path: <linux-kernel-owner+w=401wt.eu-S1755670AbZIUJCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670AbZIUJCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 05:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755565AbZIUJCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 05:02:35 -0400
Received: from e28smtp08.in.ibm.com ([59.145.155.8]:58235 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755562AbZIUJCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 05:02:34 -0400
Message-ID: <4AB74129.90402@in.ibm.com>
Date: Mon, 21 Sep 2009 14:32:33 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>, heiko.carstens@de.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 1/3] slqb: Do not use DEFINE_PER_CPU for per-node data
References: <1253302451-27740-1-git-send-email-mel@csn.ul.ie> <1253302451-27740-2-git-send-email-mel@csn.ul.ie> <84144f020909200145w74037ab9vb66dae65d3b8a048@mail.gmail.com> <4AB5FD4D.3070005@kernel.org> <4AB5FFF8.7000602@cs.helsinki.fi> <4AB6508C.4070602@kernel.org> <4AB739A6.5060807@in.ibm.com> <20090921084248.GC12726@csn.ul.ie>
In-Reply-To: <20090921084248.GC12726@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
>> I applied the three patches from Mel and one from Tejun.
>>     
>
> Thanks Sachin
>
> Was there any useful result from Tejun's patch applied on its own?
>   
Haven't tried with just the patch from Tejun. I will give this a try.
I might not get a chance to test this until late in the evening my time.
(Today being a holiday for me )

>> Tejun, the above hang looks exactly the same as the one
>> i have reported here :
>>
>> http://lists.ozlabs.org/pipermail/linuxppc-dev/2009-September/075791.html
>>
>> This particular hang was bisected to the following patch
>>
>> powerpc64: convert to dynamic percpu allocator
>>
>> This hang can be recreated without SLQB. So i think this is a different
>> problem. 
>>
>>     
>
> Was that bug ever resolved?
>   
The bug was still present with git9(78f28b..). With latest git
git10(ebc79c4 ..)i haven't tested it yet because of perf counter
build errors.

Thanks
-Sachin


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

