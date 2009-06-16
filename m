Return-Path: <linux-kernel-owner+w=401wt.eu-S1757734AbZFPTtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734AbZFPTtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 15:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761235AbZFPTtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 15:49:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34575 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760938AbZFPTtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 15:49:00 -0400
Date: Tue, 16 Jun 2009 15:48:57 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/5] [GIT PULL] tracing/filters/ringbuffer: updates for
 2.6.31
In-Reply-To: <20090616193621.GA21246@elte.hu>
Message-ID: <alpine.DEB.2.00.0906161548110.26673@gandalf.stny.rr.com>
References: <20090616175133.317996432@goodmis.org> <20090616192821.GA12699@elte.hu> <20090616193621.GA21246@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 16 Jun 2009, Ingo Molnar wrote:

> 
> hm, there's a new build failure with this lot:
> 
> kernel/trace/ring_buffer.c:1298: error: ?event? undeclared (first use in this function)
> kernel/trace/ring_buffer.c:1298: error: (Each undeclared identifier is reported only once
> kernel/trace/ring_buffer.c:1298: error: for each function it appears in.)

Strange, I have a blank line at line 1298:

1294                 cpu_buffer->tail_page->page->time_stamp = *ts;
1295         }
1296 
1297         rb_reset_tail(cpu_buffer, tail_page, tail, length);
1298 
1299         __raw_spin_unlock(&cpu_buffer->lock);
1300         local_irq_restore(flags);
1301 

-- Steve

