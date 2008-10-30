Return-Path: <linux-kernel-owner+w=401wt.eu-S1757841AbYJ3Rs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841AbYJ3Rs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 13:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbYJ3Rst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 13:48:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49514 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835AbYJ3Rst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 13:48:49 -0400
Subject: Re: Deadline scheduling (was: Re: Rearranging layout of code in
 the scheduler)
From: Peter Zijlstra <peterz@infradead.org>
To: faggioli@gandalf.sssup.it
Cc: henrik@austad.us, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>, fabio@gandalf.sssup.it,
       Michael Trimarchi <trimarchimichael@yahoo.it>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       "gregory.haskins" <gregory.haskins@gmail.com>
In-Reply-To: <1225387034.7803.182.camel@twins>
References: <200810281634.11285.henrik@austad.us>
	 <1225212627.15763.16.camel@lappy.programming.kicks-ass.net>
	 <20081030174925.36023f19jy3o832t@feanor.sssup.it>
	 <1225387034.7803.182.camel@twins>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 30 Oct 2008 18:48:03 +0100
Message-Id: <1225388883.7803.217.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-30 at 18:17 +0100, Peter Zijlstra wrote:

> Personally I'd like to see the full priority inversion issue solved by
> something like the proxy execution protocol, however the SMP extension
> thereof seems to be a tad expensive - found a book on graph theory, all
> that remains is finding time to read it :-)
> 
> The advantage of proxy execution is that its fully invariant to the
> schedule function and thus even works for proportional fair schedulers
> and any kind of scheduler hierarchy.

Basically the problem that I'm looking at is:

Given a directed acyclic graph G, with entry nodes E (those who don't
have an inbound edge) and exit nodes X (those without an outbound edge)
then given an exit node x of X, split the graph into G1 and G2 so that
G1 contains x and all paths leading to it.


