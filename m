Return-Path: <linux-kernel-owner+w=401wt.eu-S1755198AbZLBXCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198AbZLBXCh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 18:02:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755149AbZLBXCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 18:02:37 -0500
Received: from tomts13.bellnexxia.net ([209.226.175.34]:60812 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755120AbZLBXCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 18:02:36 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsAEAIp/FktGGNlG/2dsb2JhbACBTtY6hDEE
Date: Wed, 2 Dec 2009 17:57:36 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
       wcohen@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
       jbaron@redhat.com, linux-tip-commits@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>
Subject: Re: trace/events: DECLARE vs DEFINE semantic
Message-ID: <20091202225736.GA14770@Krystal>
References: <20091202144334.GA30359@elte.hu> <1259765735.12870.42.camel@gandalf.stny.rr.com> <20091202162715.GB9710@Krystal> <1259773888.12870.61.camel@gandalf.stny.rr.com> <20091202180633.GF9710@Krystal> <1259777987.12870.70.camel@gandalf.stny.rr.com> <20091202190135.GA23316@Krystal> <1259781578.12870.78.camel@gandalf.stny.rr.com> <4B16EC06.6010706@redhat.com> <1259794005.12870.102.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1259794005.12870.102.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 17:53:39 up 13:44,  4 users,  load average: 1.07, 0.93, 0.82
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Wed, 2009-12-02 at 17:36 -0500, Masami Hiramatsu wrote:
> 
> > > Or do you (or anyone else) have a better name?
> > 
> > How about renaming DEFINE_EVENT to TRACE_EVENT_CLASS?
> > 
> > DECLARE_EVENT_CLASS(y, ...)	declare an event-class y
> > TRACE_EVENT_CLASS(x, y, ...)	define/declare a trace event x from event-class y
> > TRACE_EVENT(x, ...)		define/declare a trace event x
> > 
> > Thus TRACE_EVENT_* implies that this macro will be expanded
> > to both of definition and declaration.
> > I don't think separating it is good idea from the viewpoint
> > of maintaining code.
> 
> Hmm, what about just:
> 
> TRACE_CLASS - Declares a class
> TRACE_CLASS_EVENT - defines an event for said class
> TRACE_EVENT - Declares a class and defines an event (as is today)

Yep, it looks good! It's self-descriptive and don't require to explain
what the thing is doing each time we refer to it. (however I feel a bit
sad for Fred, Wilma and Barney) ;)

For that semantic, you have my

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Thanks,

Mathieu

> 
> -- Steve
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
