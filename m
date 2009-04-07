Return-Path: <linux-kernel-owner+w=401wt.eu-S1759197AbZDGAa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759197AbZDGAa3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 20:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbZDGAaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 20:30:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34842 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbZDGAaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 20:30:17 -0400
Date: Mon, 6 Apr 2009 20:30:11 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, tglx@linutronix.de,
       Jason Baron <jbaron@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>, Michael Davidson <md@google.com>
Subject: Re: [PATCH 1/2 v2] tracing/syscalls: core infrastructure for syscalls
 tracing
In-Reply-To: <20090406221242.GB5936@nowhere>
Message-ID: <alpine.DEB.2.00.0904062029440.24008@gandalf.stny.rr.com>
References: <1236955332-10133-1-git-send-email-fweisbec@gmail.com> <1236955332-10133-2-git-send-email-fweisbec@gmail.com> <12c511ca0904061455k3f8a9cc8r25b7930f257ed922@mail.gmail.com> <20090406221242.GB5936@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 7 Apr 2009, Frederic Weisbecker wrote:
> > 
> > What does syscalls.h really need to pull in at this point ... is there
> > a way for it to get it without pulling in so much extra stuff?
> 
> 
> Ah, I see. I wondered somewhat when I included ftrace.h from syscall.h,
> I didn't know why it stressed me but now I understand :-)
> 
> Though this is weird that both ia32 and ia64 definitions are allowed to be
> included like that.
> 
> Anyway, I will put the syscalls tracing headers to a separate file to fix
> that, thanks for reporting this!

Yeah, probably just separate out what is needed into a file called 
syscall_trace.h ?

-- Steve

