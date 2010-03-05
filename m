Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105Ab0CERdt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 12:33:49 -0500
Received: from mail-fx0-f227.google.com ([209.85.220.227]:57774 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648Ab0CERds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 12:33:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ndp7EHOgWuO2cmfo4pwp+GIC3I72OMeHUAxTIkTFCBAA/jXMioCC8rlZBJcjkKe08H
         ZQoXONpexnDcBKxD4UHfgMLDvopFtKVJSv9PQ838XaBk/w8MCjkPGtI52LUMfAe5YNj6
         UQnpkzxnbkgkwGz1vVkHunWyB+dVNXX9DOfj4=
Date: Fri, 5 Mar 2010 18:33:46 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>, Steven Rostedt <rostedt@goodmis.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 2/2] perf: Walk through the relevant events only
Message-ID: <20100305173342.GE5244@nowhere>
References: <1267772426-5944-1-git-send-regression-fweisbec@gmail.com> <1267772426-5944-2-git-send-regression-fweisbec@gmail.com> <1267781969.16716.55.camel@laptop> <20100305170331.GB5244@nowhere> <1267809629.4942.0.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267809629.4942.0.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 05, 2010 at 06:20:29PM +0100, Peter Zijlstra wrote:
> On Fri, 2010-03-05 at 18:03 +0100, Frederic Weisbecker wrote:
> > 
> > Now isn't the problem more in the fact that most of the swevents
> > should be tracepoints? 
> 
> No, different interface, and I don't want to require TRACE=y, I already
> utterly hate that x86 requires PERF=y.
> 

This could be reduced to the strict minimum, say CONFIG_TRACEPOINT
and some code around just to support the event ids.

Software events could be made optionals too.

I just don't like this multiplication of probe points of different
natures in a single point. That's wasteful.


> I already
> utterly hate that x86 requires PERF=y.


Me too, and it's my bad, so me double too. Sometimes I think
we should make BREAKPOINTs optional, default y. I just don't know
if something like this that has always been builtin can be made
optional.

