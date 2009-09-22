Return-Path: <linux-kernel-owner+w=401wt.eu-S1755839AbZIVJco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839AbZIVJco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 05:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755794AbZIVJcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 05:32:43 -0400
Received: from gir.skynet.ie ([193.1.99.77]:40474 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755489AbZIVJcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 05:32:43 -0400
Date: Tue, 22 Sep 2009 10:32:49 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>, sachinp@in.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Tejun Heo <tj@kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 3/3] slqb: Allow SLQB to be used on PPC
Message-ID: <20090922093249.GC12254@csn.ul.ie>
References: <1253549426-917-1-git-send-email-mel@csn.ul.ie> <1253549426-917-4-git-send-email-mel@csn.ul.ie> <20090922093023.GA22441@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090922093023.GA22441@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 11:30:23AM +0200, Heiko Carstens wrote:
> On Mon, Sep 21, 2009 at 05:10:26PM +0100, Mel Gorman wrote:
> > SLQB was disabled on PPC as it would stab itself in the face when running
> > on machines with CPUs on memoryless nodes. As those configurations should
> > now work, allow SLQB to be configured again on PPC.
> > 
> > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> > ---
> >  init/Kconfig |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/init/Kconfig b/init/Kconfig
> > index adc10ab..8f55fde 100644
> > --- a/init/Kconfig
> > +++ b/init/Kconfig
> > @@ -1033,7 +1033,7 @@ config SLUB
> > 
> >  config SLQB
> >  	bool "SLQB (Queued allocator)"
> > -	depends on !PPC && !S390
> > +	depends on !S390
> 
> You can remove S390 from the list independently from this patch set.
> As already mentioned SLQB works again on s390 and whatever caused the
> bug I reported a few weeks back is gone.
> 

Nice one. Thanks.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
