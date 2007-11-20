Return-Path: <linux-kernel-owner+w=401wt.eu-S1761996AbXKTV1C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761996AbXKTV1C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 16:27:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757427AbXKTV0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 16:26:52 -0500
Received: from gir.skynet.ie ([193.1.99.77]:50491 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755767AbXKTV0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 16:26:51 -0500
Date: Tue, 20 Nov 2007 21:26:48 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, Lee.Schermerhorn@hp.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, rientjes@google.com,
       nacc@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 6/6] Use one zonelist that is filtered by nodemask
Message-ID: <20071120212647.GA18867@csn.ul.ie>
References: <20071109143226.23540.12907.sendpatchset@skynet.skynet.ie> <20071109143426.23540.44459.sendpatchset@skynet.skynet.ie> <Pine.LNX.4.64.0711090741120.13932@schroedinger.engr.sgi.com> <20071120141953.GB32313@csn.ul.ie> <Pine.LNX.4.64.0711201217430.26419@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711201217430.26419@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (20/11/07 12:18), Christoph Lameter didst pronounce:
> On Tue, 20 Nov 2007, Mel Gorman wrote:
> 
> > Went back and revisited this. Allocating them at boot-time is below but
> > essentially it is a silly and it makes sense to just have two zonelists
> > where one of them is for __GFP_THISNODE. Implementation wise, this involves
> > dropping the last patch in the set and the overall result is still a reduction
> > in the number of zonelists.
> 
> Allright with me. Andrew could we get this patchset merged?
> 

They will not merge cleanly with a recent tree. I expect to be ready to
post a new set when regression tests complete later this evening.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
