Return-Path: <linux-kernel-owner+w=401wt.eu-S1754353AbZIIV6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbZIIV6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 17:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbZIIV6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 17:58:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47771 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752470AbZIIV6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 17:58:44 -0400
Date: Wed, 9 Sep 2009 14:56:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: mel@csn.ul.ie, greg@kroah.com, eric.whitney@hp.com, agl@us.ibm.com,
       linux-kernel@vger.kernel.org, andi@firstfloor.org, rientjes@google.com,
       apw@canonical.com, stable@kernel.org
Subject: Re: [stable] [PATCH] hugetlb: restore interleaving of bootmem huge
 pages
Message-Id: <20090909145628.66829d5f.akpm@linux-foundation.org>
In-Reply-To: <1252419215.5214.19.camel@useless.americas.hpqcorp.net>
References: <1247860154.11565.45.camel@useless.americas.hpqcorp.net>
	<20090903203339.GB7467@kroah.com>
	<20090908103233.GA28127@csn.ul.ie>
	<1252419215.5214.19.camel@useless.americas.hpqcorp.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Sep 2009 10:13:35 -0400
Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:

> On Tue, 2009-09-08 at 11:32 +0100, Mel Gorman wrote:
> > On Thu, Sep 03, 2009 at 01:33:39PM -0700, Greg KH wrote:
> > > On Fri, Jul 17, 2009 at 03:49:14PM -0400, Lee Schermerhorn wrote:
> > > > PATCH fix distribution of bootmem huge pages
> > > > 
> > > > Against: 2.6.31-rc3
> > > > 
> > > > For stable, applicable back through 2.6.27
> > > > 
> > > > [A version of this patch has been added to the -mm tree.  That patch
> > > > won't apply cleanly to mainline nor stable trees because of function
> > > > renaming.  This one should.]
> > > 
> > > What is the git commit id of this patch that is in Linus's tree?
> > > 
> > 
> > I can only find it in mmotm. It doesn't appear to have been merged to
> > mainline at all. Lee, what happened with this? Did it get held off until
> > post-2.6.31 for merging to mainline?
> 
> Mel:
> 
> This patch, along with the interleaving of freeing persistent huge pages
> are still in mmotm, awaiting the merge window.  I had sent out another
> version suitable for mainline and stable--same patch with conflicts
> resolved--but, apparently it didn't make mainline yet.
> 

I queued the original patch for 2.6.31 and -stable.

For 2.6.32 I queued a patch which reverts this same patch to make way
for all the new stuff.

It would have been better had the 2.6.31 minipatch come out first!
