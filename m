Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932866Ab0BPO5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 09:57:19 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:32987 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932809Ab0BPO4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 09:56:38 -0500
Date: Tue, 16 Feb 2010 08:55:46 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Mel Gorman <mel@csn.ul.ie>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Adam Litke <agl@us.ibm.com>,
       Avi Kivity <avi@redhat.com>, David Rientjes <rientjes@google.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 05/12] Memory compaction core
In-Reply-To: <20100216084800.GC26086@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.1002160849460.18275@router.home>
References: <1265976059-7459-1-git-send-email-mel@csn.ul.ie> <1265976059-7459-6-git-send-email-mel@csn.ul.ie> <20100216170014.7309.A69D9226@jp.fujitsu.com> <20100216084800.GC26086@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Feb 2010, Mel Gorman wrote:

> Because how do I tell in advance that the data I am migrating from DMA can
> be safely relocated to the NORMAL zone? We don't save GFP flags. Granted,
> for DMA, that will not matter as pages that must be in DMA will also not by
> migratable. However, buffer pages should not get relocated to HIGHMEM for
> example which is more likely to happen. It could be special cased but
> I'm not aware of ZONE_DMA-related pressure problems that would make this
> worthwhile and if so, it should be handled as a separate patch series.

Oh there are numerous ZONE_DMA pressure issues if you have ancient /
screwed up hardware that can only operate on DMA or DMA32 memory.

Moving page cache pages out of the DMA zone would be good. A
write request will cause the page to bounce back to the DMA zone if the
device requires the page there.

But I also think that the patchset should be as simple as possible so that
it can be merged soon.

> Ah, it was 2009 when I last kicked this around heavily :) I'll update
> it.

But it was authored in 2009. May be important if patent or other
copyright claims arise. 2009-2010?

