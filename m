Return-Path: <linux-kernel-owner+w=401wt.eu-S1762804AbZE1I4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762804AbZE1I4p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 04:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759222AbZE1I4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 04:56:37 -0400
Received: from gir.skynet.ie ([193.1.99.77]:58228 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759201AbZE1I4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 04:56:36 -0400
Date: Thu, 28 May 2009 09:56:35 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mingo@elte.hu, stable@kernel.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, hugh.dickins@tiscali.co.uk,
       Lee.Schermerhorn@hp.com, kosaki.motohiro@jp.fujitsu.com,
       starlight@binnacle.cx, ebmunson@us.ibm.com, agl@us.ibm.com,
       apw@canonical.com, wli@movementarian.org
Subject: Re: [PATCH 0/2] Fixes for hugetlbfs-related problems on shared
	memory
Message-ID: <20090528085635.GC10334@csn.ul.ie>
References: <1243422749-6256-1-git-send-email-mel@csn.ul.ie> <20090527131437.5870e342.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090527131437.5870e342.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 01:14:37PM -0700, Andrew Morton wrote:
> On Wed, 27 May 2009 12:12:27 +0100
> Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > The following two patches are required to fix problems reported by
> > starlight@binnacle.cx. The tests cases both involve two processes interacting
> > with shared memory segments backed by hugetlbfs.
> 
> Thanks.
> 
> Both of these address http://bugzilla.kernel.org/show_bug.cgi?id=13302, yes?
> I added that info to the changelogs, to close the loop.
> 

Yes. I'm sorry, I should have included that information in the leader. I
had a niggling feeling I was forgetting something to add to the changelog -
this was it :)

> Ingo, I'd propose merging both these together rather than routing one
> via the x86 tree, OK?
> 
> Question is: when?  Are we confident enough to merge it into 2.6.30
> now, or should we hold off for 2.6.30.1?  I guess we have a week or
> more, and if the changes do break something, we can fix that in
> 2.6.30.1 ;)
> 

FWIW, I'm reasonably confident based on libhugetlbfs regression testing that
I haven't broken something new. If they make it into 2.6.30-rc8, so much
the better. Thanks.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
