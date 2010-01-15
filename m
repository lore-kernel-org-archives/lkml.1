Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226Ab0AOLMg (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 06:12:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756665Ab0AOLMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 06:12:34 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:56898 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847Ab0AOLMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 06:12:33 -0500
Date: Fri, 15 Jan 2010 16:42:27 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        utrace-devel <utrace-devel@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 3/7] Execution out of line (XOL)
Message-ID: <20100115111227.GB20658@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
 <20100111122545.22050.64994.sendpatchset@srikar.in.ibm.com>
 <1263467318.4244.289.camel@laptop>
 <1263508997.4875.32.camel@localhost.localdomain>
 <1263546455.4244.348.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1263546455.4244.348.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2010-01-15 10:07:35]:

> On Thu, 2010-01-14 at 14:43 -0800, Jim Keniston wrote:
> > 
> > Yeah, there's not a lot of context there.  I hope it will make more
> > sense if you read section 1.1 of Documentation/uprobes.txt (patch #6).
> > Or look at get_insn_slot() in kprobes, and understand that we're trying
> > to do something similar in uprobes, where the instruction copies have to
> > reside in the user address space of the probed process.
> 
> That's not the point, changelogs shoulnd not be this cryptic. They
> should be stand alone and descriptive of what, why and how.
> 
> If you can't be bothered writing such for something you want reviewed
> for inclusion then I might not be bothered looking at them at all.
> 

Okay shall add to the Changelog with the information providing the
context for this patch.
