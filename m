Return-Path: <linux-kernel-owner+w=401wt.eu-S1752867AbZGTHsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867AbZGTHsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 03:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbZGTHse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 03:48:34 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:36697 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbZGTHsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 03:48:33 -0400
Date: Mon, 20 Jul 2009 09:48:18 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Memory Management <linux-mm@kvack.org>,
       Linux-Arch <linux-arch@vger.kernel.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Hugh Dickins <hugh@tiscali.co.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC/PATCH] mm: Pass virtual address to
 [__]p{te,ud,md}_free_tlb()
Message-ID: <20090720094818.641e6375@skybase>
In-Reply-To: <1248073873.13067.31.camel@pasglop>
References: <20090715074952.A36C7DDDB2@ozlabs.org>
	<20090715135620.GD7298@wotan.suse.de>
	<1248073873.13067.31.camel@pasglop>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jul 2009 17:11:13 +1000
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Wed, 2009-07-15 at 15:56 +0200, Nick Piggin wrote:
> > > I would like to merge the new support that depends on this in 2.6.32,
> > > so unless there's major objections, I'd like this to go in early during
> > > the merge window. We can sort out separately how to carry the patch
> > > around in -next until then since the powerpc tree will have a dependency
> > > on it.
> > 
> > Can't see any problem with that.
> 
> CC'ing Linus here. How do you want to proceed with that merge ? (IE. so
> far nobody objected to the patch itself)
> 
> IE. The patch affects all archs, though it's a trivial change every
> time, but I'll have stuff in powerpc-next that depends on it, and so I'm
> not sure what the right approach is here. Should I put it in the powerpc
> tree ?
> 
> I also didn't have any formal Ack from anybody, neither mm folks nor
> arch maintainers :-)

Well the change is trivial, it just adds another unused argument to the
macros. For the records: it still compiles on s390.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

