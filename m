Return-Path: <linux-kernel-owner+w=401wt.eu-S1760678AbZAFWix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760678AbZAFWix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:38:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758890AbZAFWb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:31:56 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36491 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760566AbZAFWbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:31:53 -0500
Date: Tue, 6 Jan 2009 14:31:50 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Gregory Haskins <ghaskins@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
Subject: Re: [PATCH][RFC]: mutex: adaptive spin
Message-ID: <20090106223150.GF6741@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1231093310.27690.5.camel@twins> <20090104184103.GE2002@parisc-linux.org> <1231242031.11687.97.camel@twins> <20090106121052.GA27232@elte.hu> <4963584A.4090805@novell.com> <20090106131643.GA15228@elte.hu> <1231248041.11687.107.camel@twins> <49636799.1010109@novell.com> <20090106214229.GD6741@linux.vnet.ibm.com> <1231278275.11687.111.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231278275.11687.111.camel@twins>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 10:44:35PM +0100, Peter Zijlstra wrote:
> On Tue, 2009-01-06 at 13:42 -0800, Paul E. McKenney wrote:
> > Preemptable RCU needs to be faster.  Got it -- and might have a way
> > to do it by eliminating the irq disabling and cutting way back on the
> > number of operations that must be performed.  It would probably still
> > be necessary to access the task structure.
> > 
> > Or is something other than the raw performance of rcu_read_lock() and
> > rcu_read_unlock() at issue here?
> 
> With Linus' mutex_spin_or_schedule() function the whole - keeping
> owner's task_struct alive issue goes away,.. now if only the thing would
> boot...

Cool!  And I can relate to the "if only the thing would boot" part.  ;-)

							Thanx, Paul
