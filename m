Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1756593AbYLPWx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593AbYLPWx1 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 17:53:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbYLPWxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 17:53:16 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48058 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbYLPWxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 17:53:16 -0500
Date: Tue, 16 Dec 2008 17:53:13 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/ftrace: use preempt_enable_no_resched_notrace
 in ring_buffer_time_stamp()
In-Reply-To: <20081216215941.GA14787@elte.hu>
Message-ID: <alpine.DEB.1.10.0812161752040.25356@gandalf.stny.rr.com>
References: <494818EA.7080807@gmail.com> <20081216212028.GP14787@elte.hu> <c62985530812161339p6296f032rdc3c74650331f3d8@mail.gmail.com> <alpine.DEB.1.10.0812161642530.25356@gandalf.stny.rr.com> <c62985530812161355l11edbb9cg6dd4e7e4291ab7b@mail.gmail.com>
 <20081216215941.GA14787@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 16 Dec 2008, Ingo Molnar wrote:
> 
> i noticed high stack-tracer overhead too. Which is understandable i guess: 
> the stack tracer keeps the mcount callbacks running all the time and can 
> save the stack backtrace of the highest-stack-usage point in time that the 
> kernel ever has hit in the past. That is a pretty powerful debug 
> capability, with appropriate costs.

I was thinking of having a way to start and stop the stack tracer. This 
way we can actually have it on by default with anything that has dynamic 
ftace. To enable it durning boot would require a kernel command line 
option. Other than that, I would have a sysctl enable it.

-- Steve

