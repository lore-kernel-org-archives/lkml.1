Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293Ab0AOOUP (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 09:20:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932204Ab0AOOUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 09:20:14 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:34952 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191Ab0AOOUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 09:20:13 -0500
Date: Fri, 15 Jan 2010 19:50:07 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Mark Wielaard <mjw@redhat.com>,
        utrace-devel <utrace-devel@redhat.com>
Subject: Re: [RFC] [PATCH 4/7] Uprobes Implementation
Message-ID: <20100115142007.GA1628@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100111122553.22050.46895.sendpatchset@srikar.in.ibm.com>
 <1263467394.4244.291.camel@laptop>
 <1263509380.4875.35.camel@localhost.localdomain>
 <1263546632.4244.352.camel@laptop>
 <y0mvdf3en1y.fsf@fche.csb>
 <1263548124.4244.358.camel@laptop>
 <20100115131037.GP4822@redhat.com>
 <1263561930.4244.417.camel@laptop>
 <20100115133825.GQ4822@redhat.com>
 <1263563276.4244.426.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1263563276.4244.426.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > > Furthermore it requires stopping and resuming tasks and nonsense like
> > > that, that's unwanted in many cases, just run stuff from the trap site
> > > and you're done.
> > 
> > I don't know what you mean exactly.  A trap already stopped task.
> > utrace merely allows various clients to inspect/manipulate the state
> > of the task at that moment.  It does not add any context switches or
> > spurious stop/resumue operations.
> 
> Srikar seemed to suggest it needed stop/resume.
> 

If process traps, We dont need to stop/resume other threads.
uprobes needs threads to quiesce when inserting/deleting the breakpoint.
