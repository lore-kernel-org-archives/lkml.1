Return-Path: <linux-kernel-owner+w=401wt.eu-S1755006AbYJZOUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006AbYJZOUv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 10:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754458AbYJZOUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 10:20:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:39677 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014AbYJZOU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 10:20:29 -0400
Date: Sun, 26 Oct 2008 07:20:41 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v2][RFC] ftrace: function oprofiler
Message-ID: <20081026072041.141b46ec@infradead.org>
In-Reply-To: <1225017357.27415.5.camel@twins>
References: <alpine.DEB.1.10.0810250130020.27727@gandalf.stny.rr.com>
	<alpine.DEB.1.10.0810252049020.7650@gandalf.stny.rr.com>
	<1225017357.27415.5.camel@twins>
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

On Sun, 26 Oct 2008 11:35:57 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Sat, 2008-10-25 at 20:55 -0400, Steven Rostedt wrote:
> 
> > This is a function profiler to count the number of times a function
> > is hit.
> 
> I have to ask, _why_?
> 
> It seems like a nice enough gimmick, but is this information actually
> useful?

yes.

If you are diagnosing "my system suddenly became slow", and if you have
a baseline, a fingerprint like this can be used by less-trained people
to look up the next steps in the diagnostics.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
