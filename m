Return-Path: <linux-kernel-owner+w=401wt.eu-S1754371AbYJCADO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371AbYJCADO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 20:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbYJCAC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 20:02:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60224 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337AbYJCAC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 20:02:59 -0400
Date: Thu, 2 Oct 2008 20:02:57 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Chris Friesen <cfriesen@nortel.com>
cc: Ingo Molnar <mingo@elte.hu>, Linux kernel <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [bug report] sched: stop_machine() usage causes load balancer
 to misbehave
In-Reply-To: <48E55FE5.40108@nortel.com>
Message-ID: <alpine.DEB.1.10.0810022001250.26504@gandalf.stny.rr.com>
References: <48E55FE5.40108@nortel.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2 Oct 2008, Chris Friesen wrote:

> I mentioned before that ftrace (specifically the ftraced daemon) seems to be
> interfering with the load balancer.  After some experimenting, it appears that
> any regular calls to stop_machine() will end up confusing the load balancer.
> 
> As an experiment, I disabled ftraced (which would normally result in correct
> load balancing) but added a single kernel thread which simply runs the
> following loop, where "chrisd2" is a dummy function.


Chris,

Thanks for looking into this. I don't have an answer for your question, 
but I'll work harder to get the MCOUNT_REC working in PPC.

Does this happen with x86 too?

-- Steve
