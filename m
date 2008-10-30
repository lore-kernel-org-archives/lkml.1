Return-Path: <linux-kernel-owner+w=401wt.eu-S1757213AbYJ3VPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213AbYJ3VPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 17:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510AbYJ3VPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 17:15:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:41067 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbYJ3VPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 17:15:21 -0400
Date: Thu, 30 Oct 2008 17:15:20 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/2] ftrace: handle NMIs safely
In-Reply-To: <20081030203434.GL27407@elte.hu>
Message-ID: <alpine.DEB.1.10.0810301714190.21031@gandalf.stny.rr.com>
References: <20081030200831.467420488@goodmis.org> <20081030203434.GL27407@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 30 Oct 2008, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > The robustness of ftrace has been the focus of the code modification 
> > in 2.6.28. There is one remaining issue that needed to be addressed. 
> > This was the case of NMIs.
> 
> applied to tip/tracing/nmisafe, thanks Steve!
> 
> this looks a lot nicer approach than either putting some sort of lock 
> into NMI context (yuck) or the disabling of NMIs (not really possible 
> in a generic way architecturally).
> 
> the impact is quite non-trivial, so i dont think this is v2.6.28 
> material.

Ingo,

Do you want me to send patches on top of these to address Andrew's 
comements? Or do you want me to resend these with the updates.

I prefer to send patches on top, that way Andrew can make sure I did his 
changes correctly ;-)

-- Steve

