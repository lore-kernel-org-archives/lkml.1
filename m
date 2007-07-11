Return-Path: <linux-kernel-owner+w=401wt.eu-S1760073AbXGKEvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760073AbXGKEvZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 00:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbXGKEvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 00:51:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:43627 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485AbXGKEvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 00:51:17 -0400
Date: Wed, 11 Jul 2007 06:51:12 +0200
From: Nick Piggin <npiggin@suse.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: queued spinlock code and results
Message-ID: <20070711045111.GA1563@wotan.suse.de>
References: <20070708043228.GB22397@wotan.suse.de> <p733azz16vh.fsf@bingen.suse.de> <Pine.LNX.4.64.0707101348020.3055@schroedinger.engr.sgi.com> <20070711020638.GB27475@wotan.suse.de> <Pine.LNX.4.64.0707101924030.7089@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707101924030.7089@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 07:26:10PM -0700, Christoph Lameter wrote:
> On Wed, 11 Jul 2007, Nick Piggin wrote:
> 
> > BTW. some advanced congestion algorithms like HBO may find these ticket
> > locks useful because you can see immediately how many CPUs are contending
> > the lock, and spinners know how many CPUs are in front of them. That info
> > could be fed into the spin backoff scheme.
> 
> That would mean having to keep a lot of status information for a spinlock. 
> Gets pretty complicated.
 
Did you look at the implementation? It takes 2 bytes on x86 and is almost
the same code size and speed as the existing locks.


> The RT tree already converts spinlocks to sleeping locks? If we want to be 
> that complicated then maybe going with one sophisticated lock type for all 
> would be the solution.

I don't want to convert spinlocks to sleeping locks though.
