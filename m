Return-Path: <linux-kernel-owner+w=401wt.eu-S1751775AbYLCNVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775AbYLCNVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 08:21:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750811AbYLCNVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 08:21:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58958 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbYLCNVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 08:21:31 -0500
Date: Wed, 3 Dec 2008 08:21:28 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Tim Bird <tim.bird@am.sony.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] tracing/function-graph-tracer: improve duration
 output
In-Reply-To: <c62985530812030511p7768dba0gce8cf84655b9ac35@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0812030821050.29045@gandalf.stny.rr.com>
References: <4935E19C.3090501@gmail.com> <4935E226.3060906@gmail.com>  <20081203081906.GH21006@elte.hu>  <alpine.DEB.1.10.0812030649480.29045@gandalf.stny.rr.com> <c62985530812030511p7768dba0gce8cf84655b9ac35@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 3 Dec 2008, Fr?d?ric Weisbecker wrote:
> 
> 
> I proposed a solution for ftrace_printk (which I planned to implement
> this evening).
> Since we are in a C-style output, that would be good  to put the ftrace_printk
> as /* C comments */ inside just below the function that called it.
> Like this:
> 
> func_that_called_ftrace_printk {
>     /* Message from ftrace_printk */
> }
> 
> This way we keep the idea of comment which comes along the role of
> ftrace_printk and we know
> which function called it, at which depth.....
> 
> Do you like it this way?

Yes definitely. I thought we already decided to do it that way ;-)

-- Steve

