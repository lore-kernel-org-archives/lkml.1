Return-Path: <linux-kernel-owner+w=401wt.eu-S1754431AbYIXFOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431AbYIXFOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 01:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbYIXFOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 01:14:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:44327 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbYIXFOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 01:14:11 -0400
Message-Id: <20080924051056.650388887@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 24 Sep 2008 01:10:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Tom Zanussi <zanussi@comcast.net>
Subject: [RFC PATCH 0/3] An Unified tracing buffer (attempt)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


   *****  RFC RFC RFC RFC ******

Note the above ;-)

We had a meeting about what we want in a unified buffer. But I can never
come up with a good design without writing code. I sat down for the last
two days and came up with this design.

I did not get to finishing the /debugfs/tracing/buffer infrastructure that
we talked about, but I pushed hard on doing enough to make ftrace happy.
I also didn't finish the event registry and all that.

I tried to keep the interface as easy as possible (see the first patch).

I'm sure there are many places that can improve here, but I wanted to
get my feet wet and come out with some code.

Note, this is probably very buggy. I just was writing what I was
thinking, and tried to keep it clean, but this is a first attempt,
and first attempts are always sucky ;-)

The first patch implements the unified trace buffer system.
The second patch does some slight clean ups to ftrace.
The third patch does major heart transplant on ftrace so that it
 now has the unified buffering system as its backend heart.

Anyway, I'm off to bed, I've spent too much time on this.

Go ahead, have a flame fest with it. It's starting to get cold where
I live, and I need to heat my house.

-- Steve

