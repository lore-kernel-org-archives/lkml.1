Return-Path: <linux-kernel-owner+w=401wt.eu-S1754884AbYHUMJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbYHUMJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 08:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbYHUMJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 08:09:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38455 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314AbYHUMJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 08:09:09 -0400
Date: Thu, 21 Aug 2008 14:08:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>, linux-kernel@vger.kernel.org,
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
Message-ID: <20080821120828.GH5615@elte.hu>
References: <20080814194506.233473381@goodmis.org> <20080815123624.GC5285@joi> <alpine.DEB.1.10.0808150840410.1065@gandalf.stny.rr.com> <20080815133517.GA5292@joi> <20080820192849.GA5888@joi> <alpine.DEB.1.10.0808201536260.11714@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0808201536260.11714@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> > I assume this patchset won't go into .27. So is there any plan to 
> > fix it in .27?
> 
> I'm hoping that this does go into 27, since it is more reliable than 
> the current daemon approach.

it cannot really go into .27 - there's a lot of ftrace stuff piled up in 
tip/tracing/ftrace. (the script is also pretty hacky and unproven. All 
this stuff was written after the merge window.)

	Ingo
