Return-Path: <linux-kernel-owner+w=401wt.eu-S2992686AbXDDGJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992686AbXDDGJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 02:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992678AbXDDGJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 02:09:48 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:39567 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S2992686AbXDDGJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 02:09:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=Y0p+Ig+34Q27A3XW9p0H4FPp1SgjZLez56GrxWs6Mtaeenkk6kpwNtTPTyV/tPkahEqMiZD/dD3szojTooft8A9IOlRxo6alDfy6QiNcwTGqCZgLqNkBGggQiwF68645r71BJHU4F+WpRQlj1W6SazU+dCfMGP1cILCuqtrDM+Y=  ;
X-YMail-OSG: dBKHgzQVM1kjav_SJXDZPK7GoeFqdnq7GC_b0oozNx9fAAlDtOHry.GFgfZxWNl0Fci6eAtvng--
Message-ID: <46134124.2040705@yahoo.com.au>
Date: Wed, 04 Apr 2007 16:09:40 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Rik van Riel <riel@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Hugh Dickins <hugh@veritas.com>
Subject: [patches] threaded vma patches (was Re: missing madvise functionality)
References: <46128051.9000609@redhat.com>	<p73648dz5oa.fsf@bingen.suse.de>	<46128CC2.9090809@redhat.com>	<20070403172841.GB23689@one.firstfloor.org>	<20070403125903.3e8577f4.akpm@linux-foundation.org>	<4612B645.7030902@redhat.com>	<20070403202937.GE355@devserv.devel.redhat.com> <20070403144948.fe8eede6.akpm@linux-foundation.org> <4612DCC6.7000504@cosmosbay.com> <46130BC8.9050905@yahoo.com.au> <46133A8B.50203@cosmosbay.com>
In-Reply-To: <46133A8B.50203@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> Nick Piggin a écrit :
> 
>> Eric Dumazet wrote:
>>
>>>
>>> I do think such workloads might benefit from a vma_cache not shared 
>>> by all threads but private to each thread. A sequence could 
>>> invalidate the cache(s).
>>>
>>> ie instead of a mm->mmap_cache, having a mm->sequence, and each 
>>> thread having a current->mmap_cache and current->mm_sequence
>>
>>
>> I have a patchset to do exactly this, btw.
> 
> 
> Could you repost it please ?

Sure. I'll send you them privately because they're against an older
kernel.

>> Anyway what is the status of the private futex work. I don't think that
>> is very intrusive or complicated, so it should get merged ASAP (so then
>> at least we have the interface there).
>>
> 
> It seems nobody but you and me cared.

Sad. Although Ulrich did seem interested at one point I think? Ulrich,
do you agree at least with the interface that Eric is proposing? If
yes, then Andrew, do you have any objections to putting Eric's fairly
important patch at least into -mm?

-- 
SUSE Labs, Novell Inc.
