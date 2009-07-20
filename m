Return-Path: <linux-kernel-owner+w=401wt.eu-S1752590AbZGTHLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbZGTHLi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 03:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbZGTHLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 03:11:37 -0400
Received: from gate.crashing.org ([63.228.1.57]:37101 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491AbZGTHLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 03:11:36 -0400
Subject: Re: [RFC/PATCH] mm: Pass virtual address to
 [__]p{te,ud,md}_free_tlb()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Memory Management <linux-mm@kvack.org>,
       Linux-Arch <linux-arch@vger.kernel.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Hugh Dickins <hugh@tiscali.co.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20090715135620.GD7298@wotan.suse.de>
References: <20090715074952.A36C7DDDB2@ozlabs.org>
	 <20090715135620.GD7298@wotan.suse.de>
Content-Type: text/plain
Date: Mon, 20 Jul 2009 17:11:13 +1000
Message-Id: <1248073873.13067.31.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-15 at 15:56 +0200, Nick Piggin wrote:
> > I would like to merge the new support that depends on this in 2.6.32,
> > so unless there's major objections, I'd like this to go in early during
> > the merge window. We can sort out separately how to carry the patch
> > around in -next until then since the powerpc tree will have a dependency
> > on it.
> 
> Can't see any problem with that.

CC'ing Linus here. How do you want to proceed with that merge ? (IE. so
far nobody objected to the patch itself)

IE. The patch affects all archs, though it's a trivial change every
time, but I'll have stuff in powerpc-next that depends on it, and so I'm
not sure what the right approach is here. Should I put it in the powerpc
tree ?

I also didn't have any formal Ack from anybody, neither mm folks nor
arch maintainers :-)

Cheers,
Ben.


