Return-Path: <linux-kernel-owner+w=401wt.eu-S1755027AbYH1SxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027AbYH1SxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 14:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752818AbYH1SxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 14:53:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:58806 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296AbYH1SxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 14:53:08 -0400
Date: Thu, 28 Aug 2008 14:53:06 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Mark Hounschell <markh@compro.net>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>, Max Krasnyansky <maxk@qualcomm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
In-Reply-To: <alpine.LFD.1.10.0808281138060.3300@nehalem.linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0808281448170.18124@gandalf.stny.rr.com>
References: <20080819103301.787700742@chello.nl> <200808290036.35817.nickpiggin@yahoo.com.au> <alpine.DEB.1.10.0808281110570.14580@gandalf.stny.rr.com> <200808290134.35093.nickpiggin@yahoo.com.au> <alpine.DEB.1.10.0808281142280.14580@gandalf.stny.rr.com>
 <alpine.LFD.1.10.0808281024060.3300@nehalem.linux-foundation.org> <48B6EB6F.2050802@compro.net> <alpine.LFD.1.10.0808281138060.3300@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 28 Aug 2008, Linus Torvalds wrote:
> 
> And I'm not really interested. Quite frankly, I suspect the "we want to 
> run something like pulseaudio with RT priorities" camp is the more common 
> one, and in that context I understand limiting SCHED_FIFO sounds perfectly 
> understandable.

The fact that it actually limits a SCHED_FIFO task group, over a single 
task thread does bother me a little.

But that said, I and others have made our complaints known, and will 
forever be documented in the halls of the Internet abyss. Thus, the 
verdict has been laid. Seems the default shall be something other than 
infinite.

I will now remain silent.

-- Steve

