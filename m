Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab0CDWJq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 17:09:46 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:47788 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435Ab0CDWJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 17:09:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HwoOORf3k0STuApPabj0MxPDTQQl5oGgkOuebqLGpsPKJyneSH7UAQ9/WnWV8H6Y2K
         AugjHTh30HkZyTo0f85At3xRasK415cLgIhLIhVM+tl573O1BvdMJkpjefH0YIiJEzJc
         LZ5KEeTppzvkmThNzx4OO+r6NZk0FQ8RvgVJw=
Date: Thu, 4 Mar 2010 23:09:43 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, Greg KH <greg@kroah.com>
Subject: Re: [RFC][PATCH 2/3] perf: Take a hot regs snapshot for trace
	events
Message-ID: <20100304220941.GC8169@nowhere>
References: <1267636046.10871.74.camel@gandalf.stny.rr.com> <1267636595.25158.93.camel@laptop> <20100304112531.GF21977@elte.hu> <1267715801.10871.191.camel@gandalf.stny.rr.com> <20100304153606.GA32496@elte.hu> <1267718131.10871.240.camel@gandalf.stny.rr.com> <20100304211741.GB3643@elte.hu> <1267738238.10871.582.camel@gandalf.stny.rr.com> <20100304213725.GA8169@nowhere> <1267740168.10871.617.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267740168.10871.617.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 04, 2010 at 05:02:48PM -0500, Steven Rostedt wrote:
> On Thu, 2010-03-04 at 22:37 +0100, Frederic Weisbecker wrote:
> 
> > > I can keep the debug/tracing/events/* as is too, where the format and id
> > > just call the same routines that the eventfs calls, but add the enable
> > > and filter to be specific to ftrace.
> > 
> > 
> > The /debug/tracing/events could contain symlinks for the format
> > files so that the rest can stay there.
> 
> Symlinks buy us nothing but headaches. This is a pseudo filesystem, we
> can use the same code that generates the file with no extra overhead.


Yeah, you're right.

