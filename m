Return-Path: <linux-kernel-owner+w=401wt.eu-S1756167AbZDQXxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbZDQXxk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 19:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbZDQXxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 19:53:31 -0400
Received: from gw.goop.org ([64.81.55.164]:51762 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964AbZDQXxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 19:53:31 -0400
Message-ID: <49E91676.4020500@goop.org>
Date: Fri, 17 Apr 2009 16:53:26 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Theodore Tso <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH 3/5] tracing/events: add rcu locking around trace event
 prints
References: <20090416021830.556671772@goodmis.org> <20090416021928.467656424@goodmis.org> <alpine.DEB.2.00.0904171004210.14919@gandalf.stny.rr.com> <49E89E53.2010500@goop.org> <alpine.DEB.2.00.0904171142010.14919@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0904171142010.14919@gandalf.stny.rr.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> Well, this part does not get called when CREATE_TRACE_POINTS is not set. 
> And when it is called, it undefines it, so that other headers will not 
> include this part.
>   

Well, I can give it a whirl, I guess.  I've been tending towards 
emitting my tracepoint definitions into their own .c file anyway, so 
there's less chance of interference with everything else.

    J
