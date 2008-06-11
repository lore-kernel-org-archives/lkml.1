Return-Path: <linux-kernel-owner+w=401wt.eu-S1757887AbYFKDTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887AbYFKDTf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 23:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754827AbYFKDT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 23:19:27 -0400
Received: from ns1.suse.de ([195.135.220.2]:52613 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754759AbYFKDT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 23:19:27 -0400
Date: Wed, 11 Jun 2008 05:19:26 +0200
From: Nick Piggin <npiggin@suse.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org, paulus@samba.org
Subject: Re: [patch 3/7] mm: speculative page references
Message-ID: <20080611031926.GB8228@wotan.suse.de>
References: <20080605094300.295184000@nick.local0.net> <20080605094825.699347000@nick.local0.net> <Pine.LNX.4.64.0806101205480.17798@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0806101205480.17798@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 12:08:27PM -0700, Christoph Lameter wrote:
> On Thu, 5 Jun 2008, npiggin@suse.de wrote:
> 
> > +		 * do the right thing (see comments above).
> > +		 */
> > +		return 0;
> > +	}
> > +#endif
> > +	VM_BUG_ON(PageCompound(page) && (struct page *)page_private(page) != page);
> 
> This is easier written as:
> 
> == VM_BUG_ON(PageTail(page)
 
Yeah that would be nicer.


> And its also slightly incorrect since page_private(page) is not pointing 
> to the head page for PageHead(page).

I see. Thanks.
