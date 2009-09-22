Return-Path: <linux-kernel-owner+w=401wt.eu-S1754392AbZIVNVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392AbZIVNVW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 09:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753119AbZIVNVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 09:21:21 -0400
Received: from gir.skynet.ie ([193.1.99.77]:36810 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633AbZIVNVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 09:21:21 -0400
Date: Tue, 22 Sep 2009 14:21:27 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>
Cc: heiko.carstens@de.ibm.com, sachinp@in.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Tejun Heo <tj@kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 0/3] Fix SLQB on memoryless configurations V3
Message-ID: <20090922132126.GC25965@csn.ul.ie>
References: <1253624054-10882-1-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1253624054-10882-1-git-send-email-mel@csn.ul.ie>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 01:54:11PM +0100, Mel Gorman wrote:
> Changelog since V2
>   o Turned out that allocating per-cpu areas for node ids on ppc64 just
>     wasn't stable. This series statically declares the per-node data. This
>     wastes memory but it appears to work.
> 
> Currently SLQB is not allowed to be configured on PPC and S390 machines as
> CPUs can belong to memoryless nodes. SLQB does not deal with this very well
> and crashes reliably.
> 

GACK. Sorry about the 1/4, 2/4, 3/4 problem. There are only three
patches in this set. I dropped the last patch which was related to the
SLQB corruption problem because it didn't appear to help and didn't fix
up the number. Sorry.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
