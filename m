Return-Path: <linux-kernel-owner+w=401wt.eu-S1752908AbYHRIHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbYHRIHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 04:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbYHRIHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 04:07:05 -0400
Received: from viefep31-int.chello.at ([62.179.121.49]:64209 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbYHRIHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 04:07:03 -0400
Subject: Re: [patch] mm: dirty page tracking race fix
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Nick Piggin <npiggin@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <200808181803.57730.nickpiggin@yahoo.com.au>
References: <20080818053821.GA3011@wotan.suse.de>
	 <1219045746.10800.261.camel@twins>
	 <200808181803.57730.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Mon, 18 Aug 2008 10:07:13 +0200
Message-Id: <1219046833.10800.270.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-18 at 18:03 +1000, Nick Piggin wrote:
> On Monday 18 August 2008 17:49, Peter Zijlstra wrote:
> > On Mon, 2008-08-18 at 07:38 +0200, Nick Piggin wrote:
> 
> > > It's possible to retain this optimization for page_referenced and
> > > try_to_unmap.
> >
> > s/synch/sync/ ?
> >
> > we use sync all over the kernel to mean synchonous, so why are you
> > inventing a new shorthand?
> 
> Mmm, we also use synch all over the kernel to mean synchronous,
> including in mm/, so I'm not inventing a new shorthand. sync I
> see is more common, but it's not something anybody would get
> confused about is it?

I hadn't noticed before, and my grep skillz seem to have left me in the
cold

git grep "\<synch\>" mm/* | wc -l
0

And you're right, its not something one can get confused about. So lets
just keep it unless someone else objects ;-)

