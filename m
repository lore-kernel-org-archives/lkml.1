Return-Path: <linux-kernel-owner+w=401wt.eu-S1754562AbZIHONj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbZIHONj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 10:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754538AbZIHONi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 10:13:38 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:44419 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371AbZIHONi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 10:13:38 -0400
Subject: Re: [stable] [PATCH] hugetlb: restore interleaving of bootmem huge
 pages
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Eric Whitney <eric.whitney@hp.com>, Adam Litke <agl@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, David Rientjes <rientjes@google.com>,
       Andy Whitcroft <apw@canonical.com>, stable <stable@kernel.org>
In-Reply-To: <20090908103233.GA28127@csn.ul.ie>
References: <1247860154.11565.45.camel@useless.americas.hpqcorp.net>
	 <20090903203339.GB7467@kroah.com>  <20090908103233.GA28127@csn.ul.ie>
Content-Type: text/plain
Organization: HP/LKTT
Date: Tue, 08 Sep 2009 10:13:35 -0400
Message-Id: <1252419215.5214.19.camel@useless.americas.hpqcorp.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-08 at 11:32 +0100, Mel Gorman wrote:
> On Thu, Sep 03, 2009 at 01:33:39PM -0700, Greg KH wrote:
> > On Fri, Jul 17, 2009 at 03:49:14PM -0400, Lee Schermerhorn wrote:
> > > PATCH fix distribution of bootmem huge pages
> > > 
> > > Against: 2.6.31-rc3
> > > 
> > > For stable, applicable back through 2.6.27
> > > 
> > > [A version of this patch has been added to the -mm tree.  That patch
> > > won't apply cleanly to mainline nor stable trees because of function
> > > renaming.  This one should.]
> > 
> > What is the git commit id of this patch that is in Linus's tree?
> > 
> 
> I can only find it in mmotm. It doesn't appear to have been merged to
> mainline at all. Lee, what happened with this? Did it get held off until
> post-2.6.31 for merging to mainline?

Mel:

This patch, along with the interleaving of freeing persistent huge pages
are still in mmotm, awaiting the merge window.  I had sent out another
version suitable for mainline and stable--same patch with conflicts
resolved--but, apparently it didn't make mainline yet.

Lee

