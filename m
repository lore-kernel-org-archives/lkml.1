Return-Path: <linux-kernel-owner+w=401wt.eu-S1753679AbZAEQtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679AbZAEQtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 11:49:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbZAEQs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 11:48:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:55954 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbZAEQs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 11:48:59 -0500
Date: Mon, 5 Jan 2009 11:48:56 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [PATCH] tracing/kmemtrace: normalize the raw tracer event to
 the unified tracing API
In-Reply-To: <20081230074543.GA5102@elte.hu>
Message-ID: <alpine.DEB.1.10.0901051146470.27085@gandalf.stny.rr.com>
References: <4959443f.09a1660a.44f3.2686@mx.google.com> <20081230074543.GA5102@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 30 Dec 2008, Ingo Molnar wrote:

> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> >  kernel/trace/trace_kmemtrace.c |  345 ++++++++++++++++++++++++++++++++++++++++
> 
> btw., i renamed this to kernel/trace/kmemtrace.c. Mentioning 'trace' twice 
> is enough already ;-)

Should we rename all the kernel/trace/trace_(.*)\.c to kernel/trace/\1.c ?

Although I do like the trace in the function name, because it groups them
nicely together, and keeps ftrace.c and ring_buffer.c stand out from the
rest.

-- Steve

