Return-Path: <linux-kernel-owner+w=401wt.eu-S1753078AbXDMLUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078AbXDMLUg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 07:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753448AbXDMLUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 07:20:36 -0400
Received: from ns1.suse.de ([195.135.220.2]:52881 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753078AbXDMLUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 07:20:36 -0400
Date: Fri, 13 Apr 2007 13:20:30 +0200
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] generic rwsems
Message-ID: <20070413112029.GD27914@wotan.suse.de>
References: <20070413100416.GC31487@wotan.suse.de> <200704131253.49301.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704131253.49301.ak@suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2007 at 12:53:49PM +0200, Andi Kleen wrote:
> On Friday 13 April 2007 12:04:16 Nick Piggin wrote:
> > OK, this patch is against 2.6.21-rc6 + Mathieu's atomic_long patches.
> > 
> > Last time this came up I was asked to get some numbers, so here are
> > some in the changelog, captured with a simple kernel module tester.
> > I got motivated again because of the MySQL/glibc/mmap_sem issue.
> > 
> > This patch converts all architectures to a generic rwsem implementation,
> > which will compile down to the same code for i386, or powerpc, for
> > example, and will allow some (eg. x86-64) to move away from spinlock
> > based rwsems.
> > 
> > Comments?
> 
> Fine for me from the x86-64 side. Some more validation with a test suite
> would be good though.

David had a test suite somewhere, so I'll give that a run.

