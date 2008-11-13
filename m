Return-Path: <linux-kernel-owner+w=401wt.eu-S1755584AbYKMAMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584AbYKMAMQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 19:12:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbYKMAL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 19:11:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:61992 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbYKMAL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 19:11:59 -0500
Date: Wed, 12 Nov 2008 19:11:57 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] tracing/function-return-tracer: Call prepare_ftrace_return
 by registers
In-Reply-To: <c62985530811121535t13a60c93y9e4c22e365ca1b34@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0811121911340.30248@gandalf.stny.rr.com>
References: <491B4F63.3090909@gmail.com> <20081112221623.GB6125@elte.hu>  <c62985530811121422w6d33de3cp506bdf1aa96efd81@mail.gmail.com>  <alpine.DEB.1.10.0811121824380.21116@gandalf.stny.rr.com> <c62985530811121535t13a60c93y9e4c22e365ca1b34@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Hmm... The whole thing is splitted in two levels: the infrastructure
> to trace on call and return (and call
> a return handler) and the higher level tracer.
> The first could be called ftrace_exit because it is waht it does.
> And the second is much more about cost evaluation of functions and so
> could be named function_cost. Its
> functions and structures could have this in their name whereas the low
> level things could have ftrace_exit in
> their name.
> 
> What do you think?

Yeah, I like that.

Ingo, what's your thought on that?

-- Steve

