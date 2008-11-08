Return-Path: <linux-kernel-owner+w=401wt.eu-S1754232AbYKHMRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232AbYKHMRd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 07:17:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbYKHMR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 07:17:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:40521 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbYKHMRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 07:17:25 -0500
Date: Sat, 8 Nov 2008 07:17:22 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 02/10] ftrace: fix boot trace sched startup
In-Reply-To: <c62985530811072012p3ae7b108ydd4ec37c57187cb5@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0811080715490.1444@gandalf.stny.rr.com>
References: <20081108034605.289816911@goodmis.org>  <20081108034748.991813249@goodmis.org> <c62985530811072012p3ae7b108ydd4ec37c57187cb5@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 8 Nov 2008, Fr?d?ric Weisbecker wrote:
> 
> BTW: I see that tracing_reset is called even on start and reset
> callback by the tracers. Wouldn't it better to do it
> only on reset? Perhaps it can even be done automatically by the
> tracing Api itself when reset is called on
> every tracers. Or perhaps there could be special cases I don't see
> where one tracer wouldn't wish to erase is entries
> on reset?

I'm maintaining the original behaviour. We can discusss whether or
not the start should also reset. I'm up for different ideas.

> 
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Thanks,

-- Steve

