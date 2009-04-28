Return-Path: <linux-kernel-owner+w=401wt.eu-S1763106AbZD1Qwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763106AbZD1Qwo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 12:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761536AbZD1Qwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 12:52:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:64137 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761412AbZD1Qwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 12:52:32 -0400
Date: Tue, 28 Apr 2009 12:52:30 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, Li Zefan <lizf@cn.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: LTTng "TIF_KERNEL_TRACE"
In-Reply-To: <20090428164420.GA7337@nowhere>
Message-ID: <alpine.DEB.2.00.0904281251210.8066@gandalf.stny.rr.com>
References: <20090428132037.GA27519@Krystal> <20090428150102.GB26546@elte.hu> <20090428154046.GA32381@Krystal> <20090428163300.GD5978@nowhere> <20090428163825.GA2030@Krystal> <20090428164420.GA7337@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 28 Apr 2009, Frederic Weisbecker wrote:

> On Tue, Apr 28, 2009 at 12:38:25PM -0400, Mathieu Desnoyers wrote:
> > No, read-write lock is a "special case" where it does not deadlock if
> > you have an interrupt handler taking the read lock over another read
> > lock. It's just the write lock that _must absolutely_ disable
> > interrupts.
> 
> 
> Ah, you're right, I was thinking with spinlock rules in mind :)
> 

The only time you would want to do a read_lock_irqsave is if the 
write_lock is taken in irq context. But I do not know of any lock where 
that is the case.

-- Steve

