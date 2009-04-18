Return-Path: <linux-kernel-owner+w=401wt.eu-S1758137AbZDROTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137AbZDROTH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 10:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754621AbZDROSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 10:18:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:57900 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294AbZDROSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 10:18:54 -0400
Date: Sat, 18 Apr 2009 10:18:52 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/5] tracing/events: enable code with EVENT_TRACING not
 EVENT_TRACER
In-Reply-To: <20090418071307.GC7678@elte.hu>
Message-ID: <alpine.DEB.2.00.0904181017010.1016@gandalf.stny.rr.com>
References: <20090417211135.408179566@goodmis.org> <20090417211230.723241189@goodmis.org> <20090418071307.GC7678@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 18 Apr 2009, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > -#ifdef CONFIG_EVENT_TRACER
> > +#ifdef CONFIG_EVENT_TRACING
> 
> Hm, my crystal ball predicts many such incidents in future years to 
> come.
> 
> This:
> 
>   s/CONFIG_EVENT_TRACER/CONFIG_EVENT_TRACER_PLUGIN
> 
> might help. Or not.

The problem is that a plugin is defined (by me anyway) as something in the 
"available_tracers" file. The event tracer does not qualify as one. But I 
see the confusion with the current naming.

What about:

	s/CONFIG_EVENT_TRACER/CONFIG_ENABLE_EVENT_TRACING/

It pretty much says what it does.

??

-- Steve

