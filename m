Return-Path: <linux-kernel-owner+w=401wt.eu-S1750850AbZH0RBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750850AbZH0RBM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 13:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750791AbZH0RBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 13:01:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:48336 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbZH0RBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 13:01:09 -0400
Date: Thu, 27 Aug 2009 13:01:08 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Gregory Haskins <gregory.haskins@gmail.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: FTRACE: regression in 31-rc7
In-Reply-To: <4A96B55C.10001@gmail.com>
Message-ID: <alpine.DEB.2.00.0908271258250.29943@gandalf.stny.rr.com>
References: <4A96B55C.10001@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 27 Aug 2009, Gregory Haskins wrote:

> Hi Steve,
> 
> I just moved from -rc6 to -rc7, and I noticed that the function-graph
> tracer suddenly stopped working properly:  I do not see any output from
> seeming most things except a handful of interrupt related events.  I
> currently believe it may be an issue with tracing modules.
> 
> I haven't had a chance to bisect yet, but I did confirm that reverting
> the -rc7 merge restores the previous tracer behavior.  Any help/pointers
> appreciated.

First the stupid questions ;-)

Is anything set in the filter files?

set_ftrace_filter, set_ftrace_notrace, or set_graph_function.

Make sure all functions are seen in available_filter_functions.

Do you see any error messages?

Could you send me some output and more details.

Thanks,

-- Steve

