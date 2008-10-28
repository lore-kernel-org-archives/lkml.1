Return-Path: <linux-kernel-owner+w=401wt.eu-S1754084AbYJ1OsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbYJ1OsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 10:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbYJ1OsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 10:48:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:56265 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbYJ1OsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 10:48:05 -0400
Date: Tue, 28 Oct 2008 07:48:16 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Mike Snitzer <snitzer@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH][RFC] trace: profile likely and unlikely annotations
Message-ID: <20081028074816.04193e04@infradead.org>
In-Reply-To: <20081028143720.GD8869@mit.edu>
References: <170fa0d20810271529g3c64ae89me29ed8b65a9c3b5e@mail.gmail.com>
	<alpine.DEB.1.10.0810271918390.19731@gandalf.stny.rr.com>
	<20081028001340.GB9797@mit.edu>
	<alpine.DEB.1.10.0810272316270.802@gandalf.stny.rr.com>
	<20081028143720.GD8869@mit.edu>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2008 10:37:20 -0400
Theodore Tso <tytso@mit.edu> wrote:

> On Tue, Oct 28, 2008 at 12:12:48AM -0400, Steven Rostedt wrote:
> > 
> > Andrew Morton recently suggested having an in-kernel way to profile
> > likely and unlikely macros. This patch achieves that goal.
> 
> Maybe I'm confused, but when I read through the patch, it looks like
> that 'hit' is incremented whenever the condition is true, and 'missed'
> is incremented whenever the condition is false, correct?
> 
> Is that what you intended?  So for profile_unlikely, "missed" is good,
> and "hit" is bad, and for profile_likely, "hit" is good, and "missed"
> is bad.  That seems horribly confusing.
> 
> If that wasn't what you intended, the meaning of "hit" and "missed"
> seems to be highly confusing, either way.  Can we perhaps use some
> other terminology?  Simply using "True" and "False" would be better,
> since there's no possible confusion what the labels mean.

or "correct" and "incorrect"



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
