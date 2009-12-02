Return-Path: <linux-kernel-owner+w=401wt.eu-S1754649AbZLBWqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbZLBWqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 17:46:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754471AbZLBWqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 17:46:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:64251 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850AbZLBWqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 17:46:40 -0500
Subject: Re: trace/events: DECLARE vs DEFINE semantic
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, wcohen@redhat.com, fweisbec@gmail.com,
       tglx@linutronix.de, jbaron@redhat.com,
       linux-tip-commits@vger.kernel.org, Christoph Hellwig <hch@lst.de>
In-Reply-To: <4B16EC06.6010706@redhat.com>
References: <tip-3a9089fd78367e2c6c815129030b790a0f5c2715@git.kernel.org>
	 <1259761934.12870.12.camel@gandalf.stny.rr.com>
	 <20091202140128.GA2611@elte.hu>
	 <1259764109.12870.37.camel@gandalf.stny.rr.com>
	 <20091202144334.GA30359@elte.hu>
	 <1259765735.12870.42.camel@gandalf.stny.rr.com>
	 <20091202162715.GB9710@Krystal>
	 <1259773888.12870.61.camel@gandalf.stny.rr.com>
	 <20091202180633.GF9710@Krystal>
	 <1259777987.12870.70.camel@gandalf.stny.rr.com>
	 <20091202190135.GA23316@Krystal>
	 <1259781578.12870.78.camel@gandalf.stny.rr.com>
	 <4B16EC06.6010706@redhat.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 02 Dec 2009 17:46:45 -0500
Message-Id: <1259794005.12870.102.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-02 at 17:36 -0500, Masami Hiramatsu wrote:

> > Or do you (or anyone else) have a better name?
> 
> How about renaming DEFINE_EVENT to TRACE_EVENT_CLASS?
> 
> DECLARE_EVENT_CLASS(y, ...)	declare an event-class y
> TRACE_EVENT_CLASS(x, y, ...)	define/declare a trace event x from event-class y
> TRACE_EVENT(x, ...)		define/declare a trace event x
> 
> Thus TRACE_EVENT_* implies that this macro will be expanded
> to both of definition and declaration.
> I don't think separating it is good idea from the viewpoint
> of maintaining code.

Hmm, what about just:

TRACE_CLASS - Declares a class
TRACE_CLASS_EVENT - defines an event for said class
TRACE_EVENT - Declares a class and defines an event (as is today)

-- Steve


