Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab0CCUhS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 15:37:18 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:59138 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860Ab0CCUhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 15:37:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jK8IVbHqFCx4Hd8mzcxaCR64VbU9Rbf9JuE5Td2Soyyj+DqyWYgq51NMpsrwxyCe40
         1RfSpmBSSTAD176XseqmJ/bpknJd0KTzVnW05ClwLm173UoKLT4JhuGJG0AkLt5dE0dZ
         2WopSM6A+j0WFrR1flzYPoThuPtu8O0TtQZlg=
Date: Wed, 3 Mar 2010 21:37:09 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [RFC][PATCH 2/3] perf: Take a hot regs snapshot for trace
	events
Message-ID: <20100303203706.GB5194@nowhere>
References: <1267599302-2886-1-git-send-regression-fweisbec@gmail.com> <1267599302-2886-3-git-send-regression-fweisbec@gmail.com> <1267632387.10871.59.camel@gandalf.stny.rr.com> <1267634258.25158.88.camel@laptop> <1267636046.10871.74.camel@gandalf.stny.rr.com> <1267636595.25158.93.camel@laptop> <1267638355.10871.76.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267638355.10871.76.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 12:45:55PM -0500, Steven Rostedt wrote:
> On Wed, 2010-03-03 at 18:16 +0100, Peter Zijlstra wrote:
> 
> > > This is what I actually was wondering about. Why is it a "perf only"
> > > trace point instead of a TRACE_EVENT()?
> > 
> > Because I wanted to make perf usable without having to rely on funny
> > tracepoints. That is, I am less worried about committing software
> > counters to ABI than I am about TRACE_EVENT(), which still gives me a
> > terribly uncomfortable feeling.
> > 
> > Also, building with all CONFIG_TRACE_*=n will still yield a usable perf,
> > which is something the embedded people might fancy, all that TRACE stuff
> > adds lots of code.
> 
> We could make TRACE_EVENT() into a perf only trace point with
> CONFIG_TRACE_*=n. 



Yeah.


 
> Just saying that it would be nice if ftrace could also see page faults
> and such.


Agreed, we could make it a TRACE_EVENT. IIRC, someone proposed patches
for that by the past.

That notwithstanding one of the main worries is the fact TRACE_EVENT
are less ABI-stable guaranteed.

