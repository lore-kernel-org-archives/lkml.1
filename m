Return-Path: <linux-kernel-owner+w=401wt.eu-S1757264AbZBFIEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264AbZBFIEU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 03:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbZBFIEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 03:04:05 -0500
Received: from ti-out-0910.google.com ([209.85.142.187]:52809 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbZBFIED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 03:04:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VnMx1NhRDN6Wv6rAVZbDyhDny+1PFOZsdvNg7dj8Jh7I1B01Q8XSMwPnT4xhiohCbN
         PVd58OyQ+3kbBB2Y9pqqDWrGHprhlQAtmnKY8+5btp8rXhK9OK+lDhJiBDMshZajpVJM
         hyqfGcDbbCo3HYmgrNi0lU/cqhA4Mo8F5Ko+s=
Date: Fri, 6 Feb 2009 17:03:54 +0900
From: MinChan Kim <minchan.kim@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/3][RFC] swsusp: shrink file cache first
Message-ID: <20090206080354.GA6516@barrios-desktop>
References: <20090206031125.693559239@cmpxchg.org> <20090206031324.004715023@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090206031324.004715023@cmpxchg.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Johannes.
I have some questions.
Just out of curiosity. :)

On Fri, Feb 06, 2009 at 04:11:28AM +0100, Johannes Weiner wrote:
> File cache pages are saved to disk either through normal writeback by
> reclaim or by including them in the suspend image written to a
> swapfile.
> 
> Writing them either way should take the same amount of time but doing
> normal writeback and unmap changes the fault behaviour on resume from
> prefault to on-demand paging, smoothening out resume and giving

What do you mean "unmap"? 
Why normal writeback and unmap chnages the fault behavior on resume ?

> previously cached pages the chance to stay out of memory completely if
> they are not used anymore.
> 
> Another reason for preferring file page eviction is that the locality
> principle is visible in fault patterns and swap might perform really
> bad with subsequent faulting of contiguously mapped pages.

Why do you think that swap might perform bad with subsequent faulting 
of contiguusly mapped page ?
You mean normal file system is faster than swap due to readahead and 
smart block of allocation ?


-- 
Kinds Regards
MinChan Kim

