Return-Path: <linux-kernel-owner+w=401wt.eu-S933159AbZFLIp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159AbZFLIp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 04:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753561AbZFLIpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 04:45:16 -0400
Received: from gate.crashing.org ([63.228.1.57]:42662 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755581AbZFLIpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 04:45:14 -0400
Subject: Re: slab: setup allocators earlier in the boot sequence
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, mingo@elte.hu, cl@linux-foundation.org,
       akpm@linux-foundation.org
In-Reply-To: <1244793879.30512.19.camel@penberg-laptop>
References: <200906111959.n5BJxFj9021205@hera.kernel.org>
	 <1244770230.7172.4.camel@pasglop> <1244779009.7172.52.camel@pasglop>
	 <1244780756.7172.58.camel@pasglop> <1244783235.7172.61.camel@pasglop>
	 <Pine.LNX.4.64.0906120913460.26843@melkki.cs.Helsinki.FI>
	 <1244792079.7172.74.camel@pasglop>
	 <1244792745.30512.13.camel@penberg-laptop>
	 <20090612075427.GA24044@wotan.suse.de>
	 <1244793592.30512.17.camel@penberg-laptop>
	 <20090612080236.GB24044@wotan.suse.de>
	 <1244793879.30512.19.camel@penberg-laptop>
Content-Type: text/plain
Date: Fri, 12 Jun 2009 18:44:51 +1000
Message-Id: <1244796291.7172.87.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-12 at 11:04 +0300, Pekka Enberg wrote:
> Hi Nick,
> 
> On Fri, 2009-06-12 at 10:02 +0200, Nick Piggin wrote:
> > Fair enough, but this can be done right down in the synchronous
> > reclaim path in the page allocator. This will catch more cases
> > of code using the page allocator directly, and should be not
> > as hot as the slab allocator.
> 
> So you want to push the local_irq_enable() to the page allocator too? We
> can certainly do that but I think we ought to wait for Andrew to merge
> Mel's patches to mainline first, OK?

Doesn't my patch take care of all the cases in a much more simple way ?

Cheers,
Ben.


