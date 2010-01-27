Return-Path: <linux-kernel-owner+w=401wt.eu-S1753929Ab0A0KA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab0A0KA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 05:00:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260Ab0A0KA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 05:00:27 -0500
Received: from one.firstfloor.org ([213.235.205.2]:57681 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143Ab0A0KA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 05:00:26 -0500
Date: Wed, 27 Jan 2010 11:00:22 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH RFC tip/core/rcu] accelerate grace period if last
	non-dynticked CPU
Message-ID: <20100127100022.GB12522@basil.fritz.box>
References: <20100125034816.GA14043@linux.vnet.ibm.com> <873a1sft9q.fsf@basil.nowhere.org> <20100127052050.GC6807@linux.vnet.ibm.com> <20100127094336.GA12522@basil.fritz.box> <1264585850.4283.1992.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264585850.4283.1992.camel@laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 10:50:50AM +0100, Peter Zijlstra wrote:
> On Wed, 2010-01-27 at 10:43 +0100, Andi Kleen wrote:
> > 
> > Can't you simply check that at runtime then?
> > 
> > if (num_possible_cpus() > 20) 
> >         ...
> > 
> > BTW the new small is large. This years high end desktop PC will come with 
> > upto 12 CPU threads. It would likely be challenging to find a good
> > number for 20 that holds up with the future. 
> 
> If only scalability were that easy :/

See the rest of my email...

I see you're already suffering from "Linus disease" ... only reading
the first paragraph/sentence in the email.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
