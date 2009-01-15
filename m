Return-Path: <linux-kernel-owner+w=401wt.eu-S1757355AbZAOA4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355AbZAOA4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 19:56:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760413AbZAOAzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 19:55:54 -0500
Received: from cantor.suse.de ([195.135.220.2]:43345 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762066AbZAOAzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 19:55:49 -0500
Date: Thu, 15 Jan 2009 01:55:47 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org,
       a.p.zijlstra@chello.nl, paulmck@linux.vnet.ibm.com, ghaskins@novell.com,
       matthew@wil.cx, andi@firstfloor.org, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-btrfs@vger.kernel.org, tglx@linutronix.de, pmorreale@novell.com,
       SDietrich@novell.com, dmitry.adamushko@gmail.com, hannes@cmpxchg.org
Subject: Re: [GIT PULL] adaptive spinning mutexes
Message-ID: <20090115005547.GE32044@wotan.suse.de>
References: <20090114183319.GA18630@elte.hu> <20090114105300.66bd014d.akpm@linux-foundation.org> <20090114190008.GA13203@elte.hu> <20090114113638.c818fcf8.akpm@linux-foundation.org> <20090114201435.GA6519@elte.hu> <20090114123017.9acf42d7.akpm@linux-foundation.org> <20090114205122.GC6519@elte.hu> <20090114130642.cf2b18b2.akpm@linux-foundation.org> <20090114211458.GD6519@elte.hu> <20090114133529.317a346c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114133529.317a346c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 01:35:29PM -0800, Andrew Morton wrote:
> You're taking a whizzy new feature which drastically changes a critical
> core kernel feature and jamming it into mainline with a vestigial
> amount of testing coverage without giving sufficient care and thought
> to the practical lessons which we have learned from doing this in the
> past.
> 
> This is a highly risky change.  It's not that the probability of
> failure is high - the problem is that the *cost* of the improbable
> failure is high.  We should seek to minimize that cost.

There is very little downside to waiting for at least the next release
cycle. What's the case for making an exception and merging it right now?
It actually still seems to be generating a lot of changes and
discussion right up until yesterday...

