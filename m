Return-Path: <linux-kernel-owner+w=401wt.eu-S1756810AbZALUAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810AbZALUAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 15:00:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755951AbZALUAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 15:00:06 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:35435 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646AbZALUAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 15:00:04 -0500
Date: Mon, 12 Jan 2009 15:00:01 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/2] [RESEND] tracing: Add a new workqueue tracer
In-Reply-To: <20090112193825.GB5267@nowhere>
Message-ID: <alpine.DEB.1.10.0901121459310.28952@gandalf.stny.rr.com>
References: <4968fa12.0aa5660a.32cf.ffff8db2@mx.google.com> <alpine.DEB.1.10.0901121314190.22796@gandalf.stny.rr.com> <20090112193825.GB5267@nowhere>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 12 Jan 2009, Frederic Weisbecker wrote:
> > WARNING: usage of NR_CPUS is often wrong - consider using cpu_possible(), 
> > num_possible_cpus(), for_each_possible_cpu(), etc
> > #953: FILE: kernel/trace/trace_workqueue.c:153:
> > +	for (i = 0; i < NR_CPUS; i++) {
> > 
> > We should probably change them to for_each_possible_cpu, or online cpu.
> > 
> > -- Steve
> 
> 
> I found it very convenient because I didn't have to allocate
> my cpu list array dynamically with it :-)
> 
> I'm preparing a v2...
>  

Thanks!

-- Steve

