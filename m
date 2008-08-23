Return-Path: <linux-kernel-owner+w=401wt.eu-S1753985AbYHWB15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbYHWB15 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 21:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbYHWB1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 21:27:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:38746 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbYHWB1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 21:27:47 -0400
Date: Fri, 22 Aug 2008 21:27:44 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: John Kacur <jkacur@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.26.3-rt3
In-Reply-To: <520f0cf10808221639k5c58dcc1p36e85f4da8f025d1@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0808222123370.5290@gandalf.stny.rr.com>
References: <1219441175.22710.22.camel@localhost.localdomain> <520f0cf10808221639k5c58dcc1p36e85f4da8f025d1@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 23 Aug 2008, John Kacur wrote:
> 
> One more patch that was missed - it was discussed here
> http://marc.info/?l=linux-rt-users&m=121846031913931&w=2
> 
> I am resending it, please consider for -rt4.
> Without it I continue to get the following type of message.
> 

Actually this was left out intentionally. The quick fix would be the one 
that Gregory Haskins suggested about not reporting when the task is bound 
to one CPU. This bothers me a little, but is probably OK for now. A task 
can still migrate from one cpu to another by the user, and this can cause 
havic if a smp_processor_id is used.

I needed to examine this a bit closer before coming up with a proper fix.

-- Steve

