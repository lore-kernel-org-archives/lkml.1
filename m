Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbZHQTUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbZHQTUj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 15:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbZHQTUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 15:20:38 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:46722 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753271AbZHQTUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 15:20:38 -0400
Date: Mon, 17 Aug 2009 12:20:36 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josht@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       hugh.dickins@tiscali.co.uk, benh@kernel.crashing.org
Subject: Re: [PATCH -tip/core/rcu 1/6] Cleanups and fixes for RCU in face
	of heavy CPU-hotplug stress
Message-ID: <20090817192036.GJ6760@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090815165153.GA8886@linux.vnet.ibm.com> <1250533487.2709.14.camel@josh-work.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250533487.2709.14.camel@josh-work.beaverton.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 17, 2009 at 11:24:47AM -0700, Josh Triplett wrote:
> On Sat, 2009-08-15 at 09:51 -0700, Paul E. McKenney wrote:
> > These pass tests combining rcutorture and continuous CPU-hotplug
> > operations, in other words, no sleeping between successive CPU-hotplug
> > operations.  This set does not fix the bug involving deadlocks through
> > rcutorture, kthread_stop(), and migration threads.  However, this bug
> > does not affect production systems, so should not stand in the way of
> > applying these patches.
> 
> Commit 63706172f332fd3f6e7458ebfb35fa6de9c21dc5, "kthreads: rework
> kthread_stop()", looks like it fixes kthread_stop to work concurrently.
> That may fix the issue you observed.

Very cool!!!  Given that Oleg is the author, it probably also works.  :-)

							Thanx, Paul
