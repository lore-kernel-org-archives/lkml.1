Return-Path: <linux-kernel-owner+w=401wt.eu-S1757950AbYLDOqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950AbYLDOqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 09:46:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753993AbYLDOqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 09:46:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63314 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546AbYLDOqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 09:46:30 -0500
Date: Thu, 4 Dec 2008 09:46:28 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, containers@lists.osdl.org,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 3/3] ftrace: add ability to only trace swapper tasks
In-Reply-To: <m1vdu0t7tz.fsf@frodo.ebiederm.org>
Message-ID: <alpine.DEB.1.10.0812040946060.5240@gandalf.stny.rr.com>
References: <20081204052638.425740534@goodmis.org> <20081204052735.362609481@goodmis.org> <20081204001803.598063f5.akpm@linux-foundation.org> <20081204091023.GJ32594@elte.hu> <m1vdu0t7tz.fsf@frodo.ebiederm.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 4 Dec 2008, Eric W. Biederman wrote:

> Ingo Molnar <mingo@elte.hu> writes:
> 
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> >> > Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> >> 
> >> What does this patch actually do?  Is swapper currently excluded from 
> >> tracing for undisclosed reasons and this patch permits it to be traced? 
> >> If so, why was swapper thus excluded?  Or am I totally off track?
> >
> >> > +static struct pid * const ftrace_swapper_pid = (struct pid *)1;
> >> 
> >> eh?
> >
> > all side-effects of getting rid of the integer based PID namespace and 
> > replacing them with struct pid pointers.
> 
> Thanks for asking Andrew it looks like an unnecessary side effect.

Well, it was necessary without hacking fork.c ;-)

-- Steve

