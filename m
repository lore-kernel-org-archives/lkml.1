Return-Path: <linux-kernel-owner+w=401wt.eu-S1753302Ab0ATKpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab0ATKpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 05:45:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120Ab0ATKpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 05:45:46 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:45926 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab0ATKpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 05:45:45 -0500
Date: Wed, 20 Jan 2010 16:15:41 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>, ananth@in.ibm.com,
       Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       utrace-devel <utrace-devel@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
Message-ID: <20100120104541.GB30109@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <84144f021001180413w76a8ca2axb0b9f07ee4dea67e@mail.gmail.com>
 <4B545146.3080001@redhat.com>
 <20100118124419.GC1628@linux.vnet.ibm.com>
 <84144f021001180451k2a84f17x3dc24796fea986c9@mail.gmail.com>
 <4B5459CA.9060603@redhat.com>
 <4B545ACF.40203@cs.helsinki.fi>
 <1263852957.2266.38.camel@localhost.localdomain>
 <4B556855.6040800@redhat.com>
 <1263923265.4998.28.camel@localhost.localdomain>
 <4B56D027.3010808@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4B56D027.3010808@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> >What does the code in the jumped-to vma do?
> 
> 1. Write a trace entry into shared memory, trap into the kernel on overflow.
> 2. Trap if a condition is satisfied (fast watchpoint implementation).
> 
> >Is the instrumentation code
> >that corresponds to the uprobe handlers encoded in an ad hoc .so?
> 
> Looks like a good idea, but it doesn't matter much to me.
> 

That looks to be a nice idea. We should certainly look into this
possibility. However can we look at this option probably a little later?

Our plan was to do one step at a time i.e have the basic uprobes in
first and target the booster (i.e jump to the next instruction without
the need for single-stepping next). 

We could look at this option of using jump instead of int3 after we are
done with the booster.  Hope that's okay.

--
Thanks and Regards
Srikar
