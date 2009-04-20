Return-Path: <linux-kernel-owner+w=401wt.eu-S1758281AbZDTW5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758281AbZDTW5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 18:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757111AbZDTW51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 18:57:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59904 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756697AbZDTW50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 18:57:26 -0400
Date: Mon, 20 Apr 2009 18:57:24 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] tracing: use nowakeup version of commit for function
 event trace tests
In-Reply-To: <20090420224129.GB5997@nowhere>
Message-ID: <alpine.DEB.2.00.0904201855140.10097@gandalf.stny.rr.com>
References: <20090420222257.267399830@goodmis.org> <20090420222325.267573793@goodmis.org> <20090420224129.GB5997@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 21 Apr 2009, Frederic Weisbecker wrote:

> On Mon, Apr 20, 2009 at 06:22:59PM -0400, Steven Rostedt wrote:
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > The startup tests for the event tracer also runs with the function
> > tracer enabled. The "wakeup" version of the trace commit was used
> > which can grab spinlocks. If a task was preempted by an NMI
> > that called a function being traced, it could deadlock due to the
> > function tracer trying to grab the same lock.
> > 
> > Thanks to Frederic Weisbecker for pointing out where the bug was.
> > 
> > Reported-by: Ingo Molnar <mingo@elte.hu>
> > Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > ---
> 
> 
> Aah, I was about to push my version, which was the same but with
> a more weird changelog :-)
> 

I was going to let you post it, but since I was the one to write the bug, 
and it was a one-liner, and I was hitting it myself, I decided to push it. 
Otherwise I might have seen your patch's signature section:

fixed-code-f*cked-up-by: Steven Rostedt

/me was reading the conversation on IRC ;-)

-- Steve

