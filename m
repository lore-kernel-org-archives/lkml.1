Return-Path: <linux-kernel-owner+w=401wt.eu-S1755425AbYIYWqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbYIYWqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 18:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670AbYIYWqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 18:46:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:51695 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632AbYIYWqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 18:46:35 -0400
Date: Thu, 25 Sep 2008 18:45:53 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Martin Bligh <mbligh@google.com>,
       Peter Zijlstra <peterz@infradead.org>, Martin Bligh <mbligh@mbligh.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
In-Reply-To: <20080925222548.GA28309@elte.hu>
Message-ID: <alpine.DEB.1.10.0809251840430.32742@gandalf.stny.rr.com>
References: <33307c790809241403w236f2242y18ba44982d962287@mail.gmail.com> <1222339303.16700.197.camel@lappy.programming.kicks-ass.net> <8f3aa8d60809250733q70561e6agfa3b00da83773e9f@mail.gmail.com> <1222354409.16700.215.camel@lappy.programming.kicks-ass.net>
 <alpine.LFD.1.10.0809250758400.3265@nehalem.linux-foundation.org> <33307c790809250825u567d3680w682899c111e10ed6@mail.gmail.com> <20080925153635.GA12840@elte.hu> <alpine.LFD.1.10.0809250924460.3265@nehalem.linux-foundation.org> <48DBFC7D.4050208@goop.org>
 <alpine.LFD.1.10.0809251448340.3265@nehalem.linux-foundation.org> <20080925222548.GA28309@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 26 Sep 2008, Ingo Molnar wrote:
> 
> Firstly they need a low-frequency (10khz-100khz) shared clock line 
> across all CPUs. A single line - and since it's low frequency it could 
> be overlaid on some existing data line and filtered out. That works 
> across NUMA nodes as well and physics allows it to be nanosec accurate 
> up to dozens of meters or so.

Can this possibly be true? I mean, light travels only one foot every
nanosecond. Can it really keep nanosecond accuracy up to dozens of  meters 
away? If you send the same signal to CPU1 that is 1 foot away, as well as 
send it to CPU2 that is 2 feet away. CPU2 will get that signal at least 1 
nanosec after CPU1 receives it.

Of course if the hardware is smart enough to know this topology, then it 
could account for these delays in traffic.

-- Steve

