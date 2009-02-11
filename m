Return-Path: <linux-kernel-owner+w=401wt.eu-S1757744AbZBKRaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757744AbZBKRaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 12:30:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785AbZBKRaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 12:30:04 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64803 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193AbZBKRaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 12:30:02 -0500
Date: Wed, 11 Feb 2009 12:30:00 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/8] git pull request for tip/tracing/core
In-Reply-To: <20090211171622.GA13239@elte.hu>
Message-ID: <alpine.DEB.1.10.0902111227570.15438@gandalf.stny.rr.com>
References: <20090208054955.777429253@goodmis.org> <20090209093751.GD7930@elte.hu> <20090211153650.GA19576@elte.hu> <alpine.DEB.1.10.0902111147450.15438@gandalf.stny.rr.com> <alpine.DEB.1.10.0902111158380.15438@gandalf.stny.rr.com>
 <20090211171622.GA13239@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 11 Feb 2009, Ingo Molnar wrote:
> > 
> > I just looked at alpha and arm, I'm now looking at ia64. And this could
> > be an issue, since it has 14 bits for hard irqs.
> > 
> > What would be the impact to make the preempt count a long?
> 
> Assembly code has to be audited i guess, whether it's treated as an int anywhere. 
> Should work i guess.

Before we go and make the change, Peter brought up a good point on IRC. Is 
there any reason that ia64 needs 1 << 14 IRQs?  That's 16384!

Perhaps the better solution wolud be (if possible), to simply lower the 
number of bits.

-- Steve

