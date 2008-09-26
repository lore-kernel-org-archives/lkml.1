Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889AbYIZKmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbYIZKmK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 06:42:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753786AbYIZKly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 06:41:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:43256 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbYIZKlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 06:41:53 -0400
Date: Fri, 26 Sep 2008 06:41:49 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Martin Bligh <mbligh@google.com>,
       Peter Zijlstra <peterz@infradead.org>, Martin Bligh <mbligh@mbligh.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
In-Reply-To: <48DC73C2.5080309@goop.org>
Message-ID: <alpine.DEB.1.10.0809260641010.17102@gandalf.stny.rr.com>
References: <alpine.LFD.1.10.0809241027251.3265@nehalem.linux-foundation.org> <33307c790809241403w236f2242y18ba44982d962287@mail.gmail.com> <1222339303.16700.197.camel@lappy.programming.kicks-ass.net> <8f3aa8d60809250733q70561e6agfa3b00da83773e9f@mail.gmail.com>
 <1222354409.16700.215.camel@lappy.programming.kicks-ass.net> <alpine.LFD.1.10.0809250758400.3265@nehalem.linux-foundation.org> <33307c790809250825u567d3680w682899c111e10ed6@mail.gmail.com> <20080925153635.GA12840@elte.hu> <alpine.LFD.1.10.0809250924460.3265@nehalem.linux-foundation.org>
 <48DBFC7D.4050208@goop.org> <alpine.LFD.1.10.0809251448340.3265@nehalem.linux-foundation.org> <48DC1338.6050107@goop.org> <alpine.DEB.1.10.0809251848170.32742@gandalf.stny.rr.com> <48DC3A89.9020407@goop.org> <alpine.DEB.1.10.0809252132410.8454@gandalf.stny.rr
 .com> <48DC43D7.5010008@goop.org> <alpine.DEB.1.10.0809252212480.8454@gandalf.stny.rr.com> <48DC73C2.5080309@goop.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 25 Sep 2008, Jeremy Fitzhardinge wrote:
> >
> > Hmm, the beginning of each patch will need to record the global tsc, as 
> > well as this information. Simply because in overwrite mode, we do not want 
> > to lose it if the producer is faster than te consumer.
> >   
> 
> Each patch?  Page?

Yep, s/patch/page/. I was already half asleep when I replied. ;)

-- Steve

