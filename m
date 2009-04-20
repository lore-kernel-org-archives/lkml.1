Return-Path: <linux-kernel-owner+w=401wt.eu-S1756989AbZDTTxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989AbZDTTxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 15:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754286AbZDTTxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 15:53:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45296 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbZDTTxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 15:53:14 -0400
Date: Mon, 20 Apr 2009 15:53:13 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] [GIT PULL] tracing: recursion and compile fixes
In-Reply-To: <20090420194542.GB5974@nowhere>
Message-ID: <alpine.DEB.2.00.0904201552370.26147@gandalf.stny.rr.com>
References: <20090420173819.957332585@goodmis.org> <20090420175533.GA22449@elte.hu> <20090420192803.GA25629@elte.hu> <20090420194542.GB5974@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 20 Apr 2009, Frederic Weisbecker wrote:

> On Mon, Apr 20, 2009 at 09:28:03PM +0200, Ingo Molnar wrote:
> > [   16.176013] Call Trace:
> > [   16.176013]  [<80944340>] ? printk+0x15/0x1d
> > [   16.176013]  [<803a410a>] _raw_spin_lock+0x19a/0x1b0
> > [   16.176013]  [<80947bb7>] _spin_lock_irqsave+0x57/0x70
> > [   16.176013]  [<8012b2ca>] __wake_up+0x1a/0x50
> > [   16.176013]  [<8019392f>] trace_wake_up+0x2f/0x40
> 
> 
> The function tracer, used in the selftest, uses trace_current_buffer_unlock_commit
> which in turn calls trace_wake_up.
> 
> The function tracer shouldn't call trace_wake_up() (might hold
> the rq lock already).

Ug, I meant to update that :-p


> 
> I'm preparing a fix.
> 

Thanks,

-- Steve

