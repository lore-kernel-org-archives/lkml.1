Return-Path: <linux-kernel-owner+w=401wt.eu-S968301AbXEHW3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968301AbXEHW3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 18:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032485AbXEHW3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 18:29:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:49511 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032486AbXEHW3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 18:29:40 -0400
Date: Wed, 9 May 2007 00:29:27 +0200
From: Nick Piggin <npiggin@suse.de>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] lock bitops
Message-ID: <20070508222926.GA20174@wotan.suse.de>
References: <20070508113709.GA19294@wotan.suse.de> <20070508150631.GC10562@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508150631.GC10562@parisc-linux.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 09:06:32AM -0600, Matthew Wilcox wrote:
> On Tue, May 08, 2007 at 01:37:09PM +0200, Nick Piggin wrote:
> > --
> > Introduce test_and_set_bit_lock / clear_bit_unlock bitops with lock semantics.
> > Add non-trivial for powerpc and ia64. Convert page lock, buffer lock,
> > bit_spin_lock, tasklet locks to use the new locks.
> 
> The names are a bit clumsy.  How about naming them after the effect,
> rather than the implementation?  It struck me that really these things
> are bit mutexes -- you can sleep while holding the lock.  How about
> calling them bit_mutex_trylock() and bit_mutex_unlock()?

bit_spin_trylock / bit_spin_unlock be OK? ;)
