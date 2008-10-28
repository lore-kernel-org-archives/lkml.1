Return-Path: <linux-kernel-owner+w=401wt.eu-S1753873AbYJ1Slc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbYJ1Slc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 14:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbYJ1SlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 14:41:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34148 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbYJ1SlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 14:41:05 -0400
Date: Tue, 28 Oct 2008 14:41:04 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Theodore Tso <tytso@mit.edu>
cc: LKML <linux-kernel@vger.kernel.org>, Mike Snitzer <snitzer@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH][RFC] trace: profile likely and unlikely annotations
In-Reply-To: <20081028182952.GB10862@mit.edu>
Message-ID: <alpine.DEB.1.10.0810281440390.15590@gandalf.stny.rr.com>
References: <170fa0d20810271529g3c64ae89me29ed8b65a9c3b5e@mail.gmail.com> <alpine.DEB.1.10.0810271918390.19731@gandalf.stny.rr.com> <20081028001340.GB9797@mit.edu> <alpine.DEB.1.10.0810272316270.802@gandalf.stny.rr.com> <20081028143720.GD8869@mit.edu>
 <alpine.DEB.1.10.0810281045040.29482@gandalf.stny.rr.com> <20081028182952.GB10862@mit.edu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 28 Oct 2008, Theodore Tso wrote:

> On Tue, Oct 28, 2008 at 10:49:16AM -0400, Steven Rostedt wrote:
> > 
> > OK, I'm fine with changing the terminology. v2 will do:
> > 
> >   s/hit/True/
> >   s/missed/False/
> > 
> > Fine with you?
> 
> I'm OK with either that, or with Arjan's suggestion of "Correct" and
> "Incorrect" --- although that would changing a line in the definition
> of #define unlikely(x):
> 
>                     ftrace_likely_update(&______f, !______r);
> 
> Either "True" / "False" or "Correct" / "Incorrect" has the advantage
> of being unambiguous.  "Correct" / "Incorrect" has the advantage that
> people don't have to think about the fact that for
> /proc/profile_unlikely, high numbers of "False" is a good thing, where
> as for /proc/profile_likely, high numbers of "True" is a good thing.
> With "Correct" / "Incorrect" it's easier to undersatnd that high
> numbers of "Correct" is good.   
> 
> So I can see why Arjan suggested Correct/Incorrect, although I can
> live with either.

I'm almost done with v2. Using Arjan's version (Correct/Incorrect) was 
actually a trivial change.

-- Steve

