Return-Path: <linux-kernel-owner+w=401wt.eu-S1756833AbXGKC0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833AbXGKC0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 22:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbXGKC0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 22:26:12 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34389 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750992AbXGKC0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 22:26:11 -0400
Date: Tue, 10 Jul 2007 19:26:10 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <npiggin@suse.de>
cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: queued spinlock code and results
In-Reply-To: <20070711020638.GB27475@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0707101924030.7089@schroedinger.engr.sgi.com>
References: <20070708043228.GB22397@wotan.suse.de> <p733azz16vh.fsf@bingen.suse.de>
 <Pine.LNX.4.64.0707101348020.3055@schroedinger.engr.sgi.com>
 <20070711020638.GB27475@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007, Nick Piggin wrote:

> BTW. some advanced congestion algorithms like HBO may find these ticket
> locks useful because you can see immediately how many CPUs are contending
> the lock, and spinners know how many CPUs are in front of them. That info
> could be fed into the spin backoff scheme.

That would mean having to keep a lot of status information for a spinlock. 
Gets pretty complicated.

The RT tree already converts spinlocks to sleeping locks? If we want to be 
that complicated then maybe going with one sophisticated lock type for all 
would be the solution.
