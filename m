Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbYJ1TX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbYJ1TX2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 15:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbYJ1TXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 15:23:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54200 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbYJ1TXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 15:23:20 -0400
Date: Tue, 28 Oct 2008 10:51:39 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Arjan van de Ven <arjan@infradead.org>
cc: Theodore Tso <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
       Mike Snitzer <snitzer@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH][RFC] trace: profile likely and unlikely annotations
In-Reply-To: <20081028074816.04193e04@infradead.org>
Message-ID: <alpine.DEB.1.10.0810281050440.29482@gandalf.stny.rr.com>
References: <170fa0d20810271529g3c64ae89me29ed8b65a9c3b5e@mail.gmail.com> <alpine.DEB.1.10.0810271918390.19731@gandalf.stny.rr.com> <20081028001340.GB9797@mit.edu> <alpine.DEB.1.10.0810272316270.802@gandalf.stny.rr.com> <20081028143720.GD8869@mit.edu>
 <20081028074816.04193e04@infradead.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 28 Oct 2008, Arjan van de Ven wrote:

> On Tue, 28 Oct 2008 10:37:20 -0400
> Theodore Tso <tytso@mit.edu> wrote:
> 
> > On Tue, Oct 28, 2008 at 12:12:48AM -0400, Steven Rostedt wrote:
> > > 
> > > Andrew Morton recently suggested having an in-kernel way to profile
> > > likely and unlikely macros. This patch achieves that goal.
> > 
> > Maybe I'm confused, but when I read through the patch, it looks like
> > that 'hit' is incremented whenever the condition is true, and 'missed'
> > is incremented whenever the condition is false, correct?
> > 
> > Is that what you intended?  So for profile_unlikely, "missed" is good,
> > and "hit" is bad, and for profile_likely, "hit" is good, and "missed"
> > is bad.  That seems horribly confusing.
> > 
> > If that wasn't what you intended, the meaning of "hit" and "missed"
> > seems to be highly confusing, either way.  Can we perhaps use some
> > other terminology?  Simply using "True" and "False" would be better,
> > since there's no possible confusion what the labels mean.
> 
> or "correct" and "incorrect"

This means that the code will need to be different for both. Or at least a 
way to differentiate between the two.  Not that hard, but I wanted to make 
the code as trivial as possible.

-- Steve

