Return-Path: <linux-kernel-owner+w=401wt.eu-S1762676AbZJOLVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762676AbZJOLVN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 07:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758166AbZJOLVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 07:21:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53438 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757790AbZJOLVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 07:21:11 -0400
Date: Thu, 15 Oct 2009 13:19:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Josh Triplett <josh@joshtriplett.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, npiggin@suse.de, jens.axboe@oracle.com
Subject: Re: [PATCH tip/core/rcu 0/6] rcu: fix synchronize_rcu_expedited(),
	update docs, improve perf
Message-ID: <20091015111944.GA29080@elte.hu>
References: <20091014171517.GA13635@linux.vnet.ibm.com> <20091015092155.GD10546@elte.hu> <20091015093541.GA8057@feather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091015093541.GA8057@feather>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Josh Triplett <josh@joshtriplett.org> wrote:

> On Thu, Oct 15, 2009 at 11:21:55AM +0200, Ingo Molnar wrote:
> > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > This patchset contains a bug fix, a performance improvement, and 
> > > documentation updates:
> > > 
> > > o	Update Documentation/RCU/trace.txt to reflect recent changes
> > > 	(including the removal of rcupreempt.c).
> > 
> > i've applied this to the .33 queue.
> 
> I realize this only represents a documentation change, but it updates 
> the documentation to match the code in 2.6.32, which seems worth 
> doing.
> 
> > > o	Add the new rnp->blocked_tasks field to the rcuhier trace file
> > > 	in debugfs.
> > > 
> > > o	Update the Documentation/RCU/trace.txt documentation to include
> > > 	the rnp->blocked_tasks tracing.
> > 
> > i've applied these to the .33 queue as well. (both tracing and 
> > documentation is not urgent material.) I also did minor edits to the 
> > changelogs.
> 
> Those who debug RCU-related issues would disagree that having adequate 
> tracing information proves non-urgent. :) The tracing information this 
> adds proves essential for debugging issues with the new hierarchical 
> RCU.  (And the documentation patch just documents the added tracing 
> information, so both should go together as a unit; actually, perhaps 
> they should get merged.)

No, we generally dont do such changes so late in -rc's (these would hit 
upstream in -rc6 - which is too late).

People doing development will use the latest RCU tree so the practical 
impact is small. Furthermore, we had a higher than usual rate of 
post-rc1 RCU changes in this cycle already, it needs to cool down a bit.

	Ingo
