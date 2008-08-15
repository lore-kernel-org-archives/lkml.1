Return-Path: <linux-kernel-owner+w=401wt.eu-S1758664AbYHOMvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664AbYHOMvR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 08:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753535AbYHOMvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 08:51:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:61698 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722AbYHOMvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 08:51:00 -0400
Date: Fri, 15 Aug 2008 08:50:57 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Marcin Slusarz <marcin.slusarz@gmail.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Roland McGrath <roland@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>, Bruce Duncan <bwduncan@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH v2 0/6] ftrace: to kill a daemon (small updates)
In-Reply-To: <20080815123624.GC5285@joi>
Message-ID: <alpine.DEB.1.10.0808150840410.1065@gandalf.stny.rr.com>
References: <20080814194506.233473381@goodmis.org> <20080815123624.GC5285@joi>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 15 Aug 2008, Marcin Slusarz wrote:

> On Thu, Aug 14, 2008 at 03:45:06PM -0400, Steven Rostedt wrote:
> >   Note 2: I have found that the changes here are more stable than
> >     the current daemon method, and these patches should be used.
> >     It also solves the resume from suspend to ram bug that was
> >     reported:
> > 
> >       http://lkml.org/lkml/2008/8/12/234
> >        and
> >       http://lkml.org/lkml/2008/8/12/451
> 
> I don't remember testing any patch for my bug... ;)
> 
> For which tree this patchset is?
> I tried to apply it on rc3, rc3+tip/tip and rc3+tip/master and all failed.
> 

Ah, Bruce reported the same error, and said this patch series fixed it. 
I assumed that this would fix your bug too. But if it does not, then I
need to look deeper into what you are reporting.

Could you recheck-out the latest tip/master and see if it works for you.

Thanks,

-- Steve

