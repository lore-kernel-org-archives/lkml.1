Return-Path: <linux-kernel-owner+w=401wt.eu-S1757569AbZKCBWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569AbZKCBWj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 20:22:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757507AbZKCBWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 20:22:38 -0500
Received: from gate.crashing.org ([63.228.1.57]:37290 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757463AbZKCBWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 20:22:38 -0500
Subject: Re: Filtering bits in set_pte_at()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linuxppc-dev@lists.ozlabs.org
In-Reply-To: <Pine.LNX.4.64.0911022342070.30581@sister.anvils>
References: <1256957081.6372.344.camel@pasglop>
	 <Pine.LNX.4.64.0911021256330.32400@sister.anvils>
	 <1257200367.7907.50.camel@pasglop>
	 <Pine.LNX.4.64.0911022342070.30581@sister.anvils>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Nov 2009 12:22:26 +1100
Message-ID: <1257211346.7907.60.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-02 at 23:45 +0000, Hugh Dickins wrote:
> > IE. update_mmu_cache() would be more generally useful if it took the
> > ptep instead of the pte. Of course, I'm sure some embedded archs are
> > going to cry for the added load here ... 
> > 
> > I like your idea. I'll look into doing a patch converting it and
> will
> > post it here.
> 
> Well, I wasn't proposing
> 
>                 update_mmu_cache(vma, address, ptep);
> but
>                 update_mmu_cache(vma, address, *ptep);
> 
> which may not meet your future idea, but is much less churn for now
> i.e. no change to any of the arch's update_mmu_cache(),
> just a change to some of its callsites. 

I see... but if we go that way, I think we may as well do the whole
churn... I'll have a look at how bad it is.

Cheers,
Ben.


