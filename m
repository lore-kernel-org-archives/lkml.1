Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbYH1PMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbYH1PMw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 11:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbYH1PMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 11:12:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:44982 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbYH1PMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 11:12:43 -0400
Date: Thu, 28 Aug 2008 11:12:41 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>, Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
In-Reply-To: <200808290036.35817.nickpiggin@yahoo.com.au>
Message-ID: <alpine.DEB.1.10.0808281110570.14580@gandalf.stny.rr.com>
References: <20080819103301.787700742@chello.nl> <20080828141513.GC31444@goodmis.org> <20080828143042.GA12644@elte.hu> <200808290036.35817.nickpiggin@yahoo.com.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 29 Aug 2008, Nick Piggin wrote:

> On Friday 29 August 2008 00:30, Ingo Molnar wrote:
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > > For this, if this time limit does kick in, we should at the very least
> > > print something out to let the user know this happened. After all,
> > > this is more of a safety net anyway, and if we are hitting the limit,
> > > the user should be notified. Perhaps even tell the user that if this
> > > behaviour is expected, to up the sysctl <var> by more.
> >
> > yeah, agreed, this is a reasonable suggestion. Peter, do you agree?
> 
> Seems reasonable. But I still think it should be disabled by default
> (it might not get caught in testing for example).

Perhaps we should default it to 1sec, that way it would be hit more often, 
and educate the users of this now feature.

-- Steve

