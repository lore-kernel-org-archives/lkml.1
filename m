Return-Path: <linux-kernel-owner+w=401wt.eu-S1756112AbZHFPyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112AbZHFPyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 11:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755941AbZHFPyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 11:54:51 -0400
Received: from gir.skynet.ie ([193.1.99.77]:57632 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755936AbZHFPyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 11:54:51 -0400
Date: Thu, 6 Aug 2009 16:54:51 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Larry Woodman <lwoodman@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 4/4] tracing, page-allocator: Add a postprocessing
	script for page-allocator-related ftrace events
Message-ID: <20090806155451.GC6915@csn.ul.ie>
References: <1249409546-6343-1-git-send-email-mel@csn.ul.ie> <1249409546-6343-5-git-send-email-mel@csn.ul.ie> <20090804112246.4e6d0ab1.akpm@linux-foundation.org> <4A787D84.2030207@redhat.com> <20090804121332.46df33a7.akpm@linux-foundation.org> <20090804204857.GA32092@csn.ul.ie> <1249484030.7512.42.camel@dhcp-100-19-198.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1249484030.7512.42.camel@dhcp-100-19-198.bos.redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05, 2009 at 10:53:50AM -0400, Larry Woodman wrote:
> On Tue, 2009-08-04 at 21:48 +0100, Mel Gorman wrote:
> 
> > > 
> > 
> > Adding and deleting tracepoints, rebuilding and rebooting the kernel is
> > obviously usable by developers but not a whole pile of use if
> > recompiling the kernel is not an option or you're trying to debug a
> > difficult-to-reproduce-but-is-happening-now type of problem.
> > 
> > Of the CC list, I believe Larry Woodman has the most experience with
> > these sort of problems in the field so I'm hoping he'll make some sort
> > of comment.
> > 
> 
> I am all for adding tracepoints that eliminate the need to locate a
> problem, add debug code, rebuild, reboot and retest until the real
> problem is found.  
> 
> Personally I have not seen as many problems in the page allocator as I
> have in the page reclaim code thats why the majority of my tracepoints
> were in vmscan.c 

I'd be surprised if you had, problems in page reclaim would be a lot
more obvious for a start. The page allocator happened to be where I wanted
tracepoints at the moment and I think the next patchset will act as a template
for how to introduce tracepoints which can be repeated for the reclaim points.

> However I do ACK this patch set because it provides
> the opportunity to zoom into the page allocator dynamically without
> needing to iterate through the cumbersome debug process.
> 

Thanks.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
