Return-Path: <linux-kernel-owner+w=401wt.eu-S1761423AbZJOJpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761423AbZJOJpe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 05:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756241AbZJOJpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 05:45:34 -0400
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:53234 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222AbZJOJpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 05:45:33 -0400
Date: Thu, 15 Oct 2009 02:35:41 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, npiggin@suse.de, jens.axboe@oracle.com
Subject: Re: [PATCH tip/core/rcu 0/6] rcu: fix synchronize_rcu_expedited(),
 update docs, improve perf
Message-ID: <20091015093541.GA8057@feather>
References: <20091014171517.GA13635@linux.vnet.ibm.com>
 <20091015092155.GD10546@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091015092155.GD10546@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 15, 2009 at 11:21:55AM +0200, Ingo Molnar wrote:
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > This patchset contains a bug fix, a performance improvement, and 
> > documentation updates:
> > 
> > o	Update Documentation/RCU/trace.txt to reflect recent changes
> > 	(including the removal of rcupreempt.c).
> 
> i've applied this to the .33 queue.

I realize this only represents a documentation change, but it updates
the documentation to match the code in 2.6.32, which seems worth doing.

> > o	Add the new rnp->blocked_tasks field to the rcuhier trace file
> > 	in debugfs.
> > 
> > o	Update the Documentation/RCU/trace.txt documentation to include
> > 	the rnp->blocked_tasks tracing.
> 
> i've applied these to the .33 queue as well. (both tracing and 
> documentation is not urgent material.) I also did minor edits to the 
> changelogs.

Those who debug RCU-related issues would disagree that having adequate
tracing information proves non-urgent. :) The tracing information this
adds proves essential for debugging issues with the new hierarchical
RCU.  (And the documentation patch just documents the added tracing
information, so both should go together as a unit; actually, perhaps
they should get merged.)

- Josh Triplett
