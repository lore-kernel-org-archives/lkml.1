Return-Path: <linux-kernel-owner+w=401wt.eu-S1756171AbZCKOBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbZCKOBx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 10:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753646AbZCKOBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 10:01:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:61370 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574AbZCKOBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 10:01:43 -0400
Date: Wed, 11 Mar 2009 10:01:40 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] tracing: use raw spinlocks for trace_vprintk
In-Reply-To: <alpine.DEB.2.00.0903110958000.16494@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.0903111001050.16494@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0903102125250.16494@gandalf.stny.rr.com> <1236754764.22914.3680.camel@twins> <20090311071808.GA5090@nowhere> <alpine.DEB.2.00.0903110958000.16494@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 11 Mar 2009, Steven Rostedt wrote:
> 
> The above disable is exactly for NMIs. We should have preemption disabled 
> here, and we disable this per cpu. If an NMI comes in after this point, it 
> will exit the function without taking the lock. If it runs on another CPU, 
> we really don't care. That's what NMIs are for ;-)

I have not had my first cup of coffee this morning yet. I meant to say:

  That's what spinlocks are for ;-)


Bah!

-- Steve

