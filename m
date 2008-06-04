Return-Path: <linux-kernel-owner+w=401wt.eu-S1756962AbYFDAnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962AbYFDAnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 20:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752334AbYFDAnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 20:43:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:37528 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413AbYFDAnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 20:43:15 -0400
Date: Wed, 4 Jun 2008 02:43:11 +0200
From: Nick Piggin <npiggin@suse.de>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       andi@firstfloor.org, apw@shadowen.org, jens.axboe@oracle.com,
       mingo@elte.hu, pbadari@us.ibm.com, shaggy@austin.ibm.com,
       tglx@linutronix.de, zach.brown@oracle.com
Subject: Re: + x86-implement-pte_special.patch added to -mm tree
Message-ID: <20080604004311.GA30863@wotan.suse.de>
References: <200806022356.m52NuRTj006330@imap1.linux-foundation.org> <19f34abd0806030853p747c01bft7b773b21e1361bcb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0806030853p747c01bft7b773b21e1361bcb@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2008 at 05:53:22PM +0200, Vegard Nossum wrote:
> On 6/3/08, akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:
> >
> >  The patch titled
> >      x86: implement pte_special
> >  has been added to the -mm tree.  Its filename is
> >      x86-implement-pte_special.patch
> 
> ...
> 
> >  ------------------------------------------------------
> >  Subject: x86: implement pte_special
> >  From: Nick Piggin <npiggin@suse.de>
> >
> >  Implement the pte_special bit for x86.  This is required to support
> >  lockless get_user_pages, because we need to know whether or not we can
> >  refcount a particular page given only its pte (and no vma).
> 
> Wait... what the heck is a "special" page? Isn't that a terrible name
> for _anything_? Or is there a tradition to the name? It sounds like it
> should be named "novma" or "autonomous" or something instead.
> Something that carries at least a little more information than
> "special". Where can I find the documentation for this bit?

It's the logical opposite of a "normal" page.

 
> Has this been discussed on LKML? Is the name a result of consensus or whim?

It has been posted many times.

