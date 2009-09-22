Return-Path: <linux-kernel-owner+w=401wt.eu-S1755938AbZIVKYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938AbZIVKYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 06:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755311AbZIVKYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 06:24:10 -0400
Received: from gir.skynet.ie ([193.1.99.77]:40720 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755099AbZIVKYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 06:24:10 -0400
Date: Tue, 22 Sep 2009 11:24:16 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       heiko.carstens@de.ibm.com, sachinp@in.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Tejun Heo <tj@kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC PATCH 0/3] Fix SLQB on memoryless configurations V2
Message-ID: <20090922102415.GF12254@csn.ul.ie>
References: <1253549426-917-1-git-send-email-mel@csn.ul.ie> <20090921174656.GS12726@csn.ul.ie> <alpine.DEB.1.10.0909211349530.3106@V090114053VZO-1> <20090921180739.GT12726@csn.ul.ie> <alpine.DEB.1.10.0909211412050.3106@V090114053VZO-1> <20090922100540.GD12254@csn.ul.ie> <1253614875.30406.12.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1253614875.30406.12.camel@penberg-laptop>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 01:21:15PM +0300, Pekka Enberg wrote:
> Hi Mel,
> 
> On Tue, 2009-09-22 at 11:05 +0100, Mel Gorman wrote:
> > I'm going to punt the decision on this one to Pekka or Nick. My feeling
> > is leave it enabled for NUMA so it can be identified if it gets fixed
> > for some other reason - e.g. the stalls are due to a per-cpu problem as
> > stated by Sachin and SLQB happens to exasperate the problem.
> 
> Can I have a tested patch that uses MAX_NUMNODES to allocate the
> structs, please? We can convert SLQB over to per-cpu allocator if the
> memoryless node issue is resolved.
> 

Patch set in the process of testing. Should have something in a few
hours.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
