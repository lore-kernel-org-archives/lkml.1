Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932982Ab0BPPA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 10:00:27 -0500
Received: from gir.skynet.ie ([193.1.99.77]:36390 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932963Ab0BPO77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 09:59:59 -0500
Date: Tue, 16 Feb 2010 14:59:44 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Adam Litke <agl@us.ibm.com>,
       Avi Kivity <avi@redhat.com>, David Rientjes <rientjes@google.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 05/12] Memory compaction core
Message-ID: <20100216145943.GA997@csn.ul.ie>
References: <1265976059-7459-1-git-send-email-mel@csn.ul.ie> <1265976059-7459-6-git-send-email-mel@csn.ul.ie> <20100216170014.7309.A69D9226@jp.fujitsu.com> <20100216084800.GC26086@csn.ul.ie> <alpine.DEB.2.00.1002160849460.18275@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1002160849460.18275@router.home>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 16, 2010 at 08:55:46AM -0600, Christoph Lameter wrote:
> On Tue, 16 Feb 2010, Mel Gorman wrote:
> 
> > Because how do I tell in advance that the data I am migrating from DMA can
> > be safely relocated to the NORMAL zone? We don't save GFP flags. Granted,
> > for DMA, that will not matter as pages that must be in DMA will also not by
> > migratable. However, buffer pages should not get relocated to HIGHMEM for
> > example which is more likely to happen. It could be special cased but
> > I'm not aware of ZONE_DMA-related pressure problems that would make this
> > worthwhile and if so, it should be handled as a separate patch series.
> 
> Oh there are numerous ZONE_DMA pressure issues if you have ancient /
> screwed up hardware that can only operate on DMA or DMA32 memory.
> 

I've never ran into the issue. I was under the impression that the only
device that might care these days are floopy disks.

> Moving page cache pages out of the DMA zone would be good. A
> write request will cause the page to bounce back to the DMA zone if the
> device requires the page there.
> 
> But I also think that the patchset should be as simple as possible so that
> it can be merged soon.
> 

Agreed.

> > Ah, it was 2009 when I last kicked this around heavily :) I'll update
> > it.
> 
> But it was authored in 2009. May be important if patent or other
> copyright claims arise. 2009-2010?
> 

2007-2010 in that case because 2007 was when I first prototyped this.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
