Return-Path: <linux-kernel-owner+w=401wt.eu-S1764831AbXJFSro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764831AbXJFSro (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 14:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761858AbXJFSrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 14:47:35 -0400
Received: from mail.tmr.com ([64.65.253.246]:40919 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292AbXJFSrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 14:47:35 -0400
Message-ID: <4707D9B4.8020904@tmr.com>
Date: Sat, 06 Oct 2007 14:53:40 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Christoph Lameter <clameter@sgi.com>, Andi Kleen <ak@suse.de>,
       akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, travis@sgi.com
Subject: Re: [13/18] x86_64: Allow fallback for the stack
References: <20071004035935.042951211@sgi.com>	<20071004040004.708466159@sgi.com>	<200710041356.51750.ak@suse.de>	<Pine.LNX.4.64.0710041220010.12075@schroedinger.engr.sgi.com> <20071004153940.49bd5afc@bree.surriel.com>
In-Reply-To: <20071004153940.49bd5afc@bree.surriel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> On Thu, 4 Oct 2007 12:20:50 -0700 (PDT)
> Christoph Lameter <clameter@sgi.com> wrote:
> 
>> On Thu, 4 Oct 2007, Andi Kleen wrote:
>>
>>> We've known for ages that it is possible. But it has been always so
>>> rare that it was ignored.
>> Well we can now address the rarity. That is the whole point of the 
>> patchset.
> 
> Introducing complexity to fight a very rare problem with a good
> fallback (refusing to fork more tasks, as well as lumpy reclaim)
> somehow does not seem like a good tradeoff.
>  
>>> Is there any evidence this is more common now than it used to be?
>> It will be more common if the stack size is increased beyond 8k.
> 
> Why would we want to do such a thing?
> 
> 8kB stacks are large enough...
> 
Why would anyone need more than 640k... In addition to NUMA, who can 
tell what some future hardware might do, given that the size of memory 
is expanding as if it were covered in Moore's Law. As memory sizes 
increase someone will bump the page size again. Better to Let people 
make it as large as they feel they need and warn at build time 
performance may suck.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
