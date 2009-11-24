Return-Path: <linux-kernel-owner+w=401wt.eu-S933959AbZKXSy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933959AbZKXSy4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 13:54:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933864AbZKXSy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 13:54:56 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:59626 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933859AbZKXSyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 13:54:55 -0500
Date: Tue, 24 Nov 2009 10:54:59 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Matt Mackall <mpm@selenic.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-mm@kvack.org, cl@linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>
Subject: Re: lockdep complaints in slab allocator
Message-ID: <20091124185459.GH6831@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1258729748.4104.223.camel@laptop> <1259002800.5630.1.camel@penberg-laptop> <1259003425.17871.328.camel@calx> <4B0ADEF5.9040001@cs.helsinki.fi> <1259080406.4531.1645.camel@laptop> <20091124170032.GC6831@linux.vnet.ibm.com> <1259082756.17871.607.camel@calx> <1259086459.4531.1752.camel@laptop> <20091124182506.GG6831@linux.vnet.ibm.com> <1259087511.4531.1775.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259087511.4531.1775.camel@laptop>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 07:31:51PM +0100, Peter Zijlstra wrote:
> On Tue, 2009-11-24 at 10:25 -0800, Paul E. McKenney wrote:
> 
> > Well, I suppose I could make my scripts randomly choose the memory
> > allocator, but I would rather not.  ;-)
> 
> Which is why I hope we'll soon be down to 2, SLOB for tiny systems and
> SLQB for the rest of us, having 3 in-tree and 1 pending is pure and
> simple insanity.

So I should start specifying SLOB for my TINY_RCU tests, then.

> Preferably SLQB will be small enough to also be able to get rid of SLOB,
> but I've not recently seen any data on that particular issue.

Given the existence of TINY_RCU, I would look pretty funny if I insisted
on but a single implementation of core subsystems.  ;-)

							Thanx, Paul
