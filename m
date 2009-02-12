Return-Path: <linux-kernel-owner+w=401wt.eu-S1759870AbZBLQ6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759870AbZBLQ6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 11:58:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756811AbZBLQ6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 11:58:16 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33727 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756806AbZBLQ6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 11:58:16 -0500
Date: Thu, 12 Feb 2009 11:58:14 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 0/7][RFC] function graph tracer port to PowerPC
In-Reply-To: <20090212164720.GA4868@nowhere>
Message-ID: <alpine.DEB.1.10.0902121157120.15469@gandalf.stny.rr.com>
References: <20090212011051.265346435@goodmis.org> <20090212015503.GA4697@nowhere> <alpine.DEB.1.10.0902121131150.15469@gandalf.stny.rr.com> <20090212164720.GA4868@nowhere>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 12 Feb 2009, Frederic Weisbecker wrote:
> 
> 
> Yes of course, I knew most of it was architecture independant but I delayed
> this TODO for future ports, and you've done it.
> 
> Thanks.
> 
> Just a micro detail: the ftrace_push/pop_return_trace are parts of
> the core of the entry/return probe, something that could be used
> by other users than the function graph tracer itself.
> 
> Perhaps it would be better to put them in kernel/trace/ftrace.c
> What do you think?

I'll go with your above method. We'll move it when it comes to that ;-)

> 
> Anyway, Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Thanks!

I'll update my repo.

-- Steve

