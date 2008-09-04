Return-Path: <linux-kernel-owner+w=401wt.eu-S1757170AbYIDJH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170AbYIDJH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 05:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754033AbYIDJHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 05:07:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33380 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752326AbYIDJHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 05:07:15 -0400
Date: Thu, 4 Sep 2008 02:07:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: linux-next: Tree for September 3
In-Reply-To: <20080904015701.5959623a.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0809040203510.3452@nehalem.linux-foundation.org>
References: <20080903191619.6b6b230e.sfr@canb.auug.org.au> <20080903214634.ea17ff53.akpm@linux-foundation.org> <alpine.LFD.1.10.0809032201510.3378@nehalem.linux-foundation.org> <20080903223318.84b6ce8b.akpm@linux-foundation.org>
 <alpine.LFD.1.10.0809040045190.3378@nehalem.linux-foundation.org> <20080904012544.cabed847.akpm@linux-foundation.org> <alpine.LFD.1.10.0809040143350.3452@nehalem.linux-foundation.org> <20080904015701.5959623a.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Sep 2008, Andrew Morton wrote:
> > 
> > commit 5f17cfce5776c566d64430f543a289e5cfa4538b
> > 
> >     PCI: fix pbus_size_mem() resource alignment for CardBus controllers
> 
> Is this worth backporting into 2.6.26.x?

It's certainly at least *potentially* -stable material, but because I 
suspect that the whole yenta_allocate_resources() -> pci_setup_cardbus() 
fallback code will end up resulting in a working setup, it may not be 
worth it.  At least not until we've heard from more people..

Can you check whether your vortex cardbus thing _works_ even without the 
fix?

			Linus
