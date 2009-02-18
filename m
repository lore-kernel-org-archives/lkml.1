Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbZBRMyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbZBRMyF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 07:54:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbZBRMxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 07:53:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38282 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741AbZBRMxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 07:53:54 -0500
Date: Wed, 18 Feb 2009 13:53:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Geoff Levand <geoffrey.levand@am.sony.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/7] tracing/function-graph-tracer: make arch generic
	push pop functions
Message-ID: <20090218125334.GA1300@elte.hu>
References: <20090213052358.524970112@goodmis.org> <20090213053004.787392572@goodmis.org> <alpine.DEB.1.10.0902162346190.30397@gandalf.stny.rr.com> <20090218010039.GL25856@elte.hu> <alpine.DEB.1.10.0902172243550.1360@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0902172243550.1360@gandalf.stny.rr.com>
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

> On Wed, 18 Feb 2009, Ingo Molnar wrote:
> 
> > 
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > Ingo,
> > > 
> > > This patch is to make function graph arch generic. But since 
> > > the PowerPC changes depend on it, we want to push it through 
> > > the PowerPC tree. But since it touches x86 code, can you give 
> > > an Acked-by to it?
> > 
> > hm, but it's all ftrace bits. Could this go through the tracing 
> > tree? That's how it's generally done for most cross-arch 
> > subsystems. By having it in a separate tree we risk conflicts 
> > and various logistics problems. It's not like the PPC tree is 
> > modifying its ftrace.c file all that frequently, right?
> 
> Ingo,
> 
> How about this. We could incorporate some of the power of git. 
> I could make a separate branch based off of Linus's 2.6.29-rc5 
> announcement, and apply just this patch (the ftrace generic 
> and x86 change). If you give me your Acked-by, I'll add that 
> too.
> 
> This way, both you and Ben could pull from this branch to get 
> the one change. When it goes upstream, because it has the same 
> SHA1, git could easily resolve it.

Sure, that's fine too - if the separate tree is semantically 
meaningful. If it pulls in too many ftrace prerequisites i doubt 
it's appropriate for the PPC tree.

	Ingo
