Return-Path: <linux-kernel-owner+w=401wt.eu-S1753786AbYKZAQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbYKZAQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 19:16:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbYKZAQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 19:16:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40405 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbYKZAQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 19:16:49 -0500
Date: Tue, 25 Nov 2008 19:16:47 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/3] ftrace: add function tracing to single thread
In-Reply-To: <c62985530811251602w4823d984wf744e75fe21b61af@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0811251914400.26424@gandalf.stny.rr.com>
References: <20081125223421.795046329@goodmis.org>  <20081125223456.976670734@goodmis.org> <c62985530811251602w4823d984wf744e75fe21b61af@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 26 Nov 2008, Fr?d?ric Weisbecker wrote:

> 2008/11/25 Steven Rostedt <rostedt@goodmis.org>:
> > From: Steven Rostedt <srostedt@redhat.com>
> >
> > Impact: feature to function trace a single thread
> >
> > This patch adds the ability to function trace a single thread.
> > The file:
> >
> >  /debugfs/tracing/set_ftrace_pid
> 
> 
> That's a good idea!
> 
> About the pid, I think they are unique (which is not the case for tgid
> for multiple threads).
> pid are tgid + number of the thread....
> 
> But perhaps I'm wrong....

Hmm, I can see that there could be times we would want to trace all 
threads, and times to trace only a single thread. This should default to 
the tgid.

We could echo in "t:pid" to trace per thread. and just "pid" to trace non 
all threads in a group.

-- Steve

