Return-Path: <linux-kernel-owner+w=401wt.eu-S1754076AbYI3SOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbYI3SOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 14:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbYI3SOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 14:14:40 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:58236 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753711AbYI3SOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 14:14:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhUFAJMI4khMQWq+/2dsb2JhbACBZL4hgWk
Date: Tue, 30 Sep 2008 14:14:36 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Martin Bligh <mbligh@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, od@suse.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       David Wilder <dwilder@us.ibm.com>, Tom Zanussi <zanussi@comcast.net>
Subject: Re: [RFC PATCH] LTTng relay buffer allocation, read, write
Message-ID: <20080930181436.GA19690@Krystal>
References: <20080927134012.GA11930@Krystal> <1222535419.16700.300.camel@lappy.programming.kicks-ass.net> <20080929155004.GA11029@Krystal> <1222709445.23876.70.camel@twins.programming.kicks-ass.net> <20080929203124.GA23070@Krystal> <alpine.DEB.1.10.0809291643570.8145@gandalf.stny.rr.com> <33307c790809301022q2821ecc7iabf41eb513707e0c@mail.gmail.com> <33307c790809301023v1b0755fbsab1bbfa9bfaad58@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <33307c790809301023v1b0755fbsab1bbfa9bfaad58@mail.gmail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:13:15 up 117 days, 22:53,  8 users,  load average: 0.53, 0.48,
	0.63
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Martin Bligh (mbligh@google.com) wrote:
> On Tue, Sep 30, 2008 at 10:22 AM, Martin Bligh <mbligh@google.com> wrote:
> >> A 4 byte dataless payload is useless anyway.
> >
> > Not at all convinced that's true - we used it for lots of things.
> > Start and end of irq event is one frequent example.
> >
> > Also, in a compact mode, we can record start and end of
> > syscalls like this (without parameters).
> 
> Ah, sorry, maybe I misread this. No data with no event ids, etc
> is fairly useless. 4 bytes data including space to record event ids is OK.

In Steven's scheme, the event IDs in the 4 bytes are reserved for
(useless) internal use ;) They can therefore not be used for specific
tracer event IDs, which I think is a misuse of the precious bits
otherwise available to store really useful event IDs.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
