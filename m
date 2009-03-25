Return-Path: <linux-kernel-owner+w=401wt.eu-S1756707AbZCYTbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbZCYTbl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 15:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbZCYTbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 15:31:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:62430 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163AbZCYTbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 15:31:33 -0400
Date: Wed, 25 Mar 2009 15:31:29 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/5][RFC] tracing: add function profiler
In-Reply-To: <20090325191147.GF5932@nowhere>
Message-ID: <alpine.DEB.2.00.0903251529380.5675@gandalf.stny.rr.com>
References: <20090325035646.662994901@goodmis.org> <20090325040832.251748832@goodmis.org> <20090325191147.GF5932@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 25 Mar 2009, Frederic Weisbecker wrote:
> > +
> > +static const struct file_operations ftrace_profile_fops = {
> > +	.open		= tracing_open_generic,
> > +	.read		= ftrace_profile_read,
> > +	.write		= ftrace_profile_write,
> > +};
> 
> 
> I should really provide such helper per stat tracer.
> 
> Say, something like:
> 
> /debug/tracing/trace_stat/name/enable
> 

No, because if you notice in the later patches, I add a per cpu tracing. 
This is standard operations, and adding too much will unnecessarily limit 
what we can do.

-- Steve

