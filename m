Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067Ab0AOLF7 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 06:05:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394Ab0AOLF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 06:05:59 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:55595 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950Ab0AOLF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 06:05:58 -0500
Date: Fri, 15 Jan 2010 16:35:47 +0530
From: Maneesh Soni <maneesh@in.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        utrace-devel <utrace-devel@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 4/7] Uprobes Implementation
Message-ID: <20100115110547.GB3660@in.ibm.com>
Reply-To: maneesh@in.ibm.com
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com> <20100111122553.22050.46895.sendpatchset@srikar.in.ibm.com> <1263467394.4244.291.camel@laptop> <1263509380.4875.35.camel@localhost.localdomain> <1263546632.4244.352.camel@laptop> <20100115102645.GA22640@linux.vnet.ibm.com> <1263551607.4244.379.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263551607.4244.379.camel@laptop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 15, 2010 at 11:33:27AM +0100, Peter Zijlstra wrote:
> On Fri, 2010-01-15 at 15:56 +0530, Srikar Dronamraju wrote:
> > Hi Peter, 
> > 
> > Or there could be two threads that could be racing to
> > insert/delete a breakpoint. These synchronization issues are all handled
> > by the Uprobes layer.
> 
> Shouldn't be hard to put that in the ubp layer, right?
> 
> > Uprobes layer would need to be notified of process life-time events
> > like fork/clone/exec/exit. 
> 
> No so much the process lifetimes as the vma life times are interesting,
> placing a hook in the vm code to track that isn't too hard, 
> 

I think similar hooks were given thumbs down in the previous incarnation
of uprobes (which was implemented without utrace).  

http://lkml.indiana.edu/hypermail/linux/kernel/0603.2/1254.html

Thanks
Maneesh

-- 
Maneesh Soni
Linux Technology Center
IBM India Systems and Technology Lab,
Bangalore, India.
