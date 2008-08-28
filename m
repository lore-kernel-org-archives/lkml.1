Return-Path: <linux-kernel-owner+w=401wt.eu-S1756911AbYH1VMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbYH1VMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 17:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753825AbYH1VL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 17:11:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42240 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753563AbYH1VL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 17:11:57 -0400
Date: Thu, 28 Aug 2008 21:53:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Hounschell <markh@compro.net>, Steven Rostedt <rostedt@goodmis.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>, Max Krasnyansky <maxk@qualcomm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
Message-ID: <20080828215321.7a1fabd5@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.1.10.0808281138060.3300@nehalem.linux-foundation.org>
References: <20080819103301.787700742@chello.nl>
	<200808290036.35817.nickpiggin@yahoo.com.au>
	<alpine.DEB.1.10.0808281110570.14580@gandalf.stny.rr.com>
	<200808290134.35093.nickpiggin@yahoo.com.au>
	<alpine.DEB.1.10.0808281142280.14580@gandalf.stny.rr.com>
	<alpine.LFD.1.10.0808281024060.3300@nehalem.linux-foundation.org>
	<48B6EB6F.2050802@compro.net>
	<alpine.LFD.1.10.0808281138060.3300@nehalem.linux-foundation.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And I'm not really interested. Quite frankly, I suspect the "we want to 
> run something like pulseaudio with RT priorities" camp is the more common 
> one, and in that context I understand limiting SCHED_FIFO sounds perfectly 
> understandable.

Is there actually a reason we can't have two forms of SCHED_FIFO. For
hard RT the existing behaviour is a lot more useful and it is hard to see
how you'd emulate it.

> quite frankly, most programmers aren't "supposedly bad". And if you think 
> that the hard-RT "real man" programmers aren't bad, I really have nothing 
> to say.

"real man" programmers stare at the code in Zen contemplation and debug
by powercycling - thats one thing even hard RT processes can't beat.

Alan
