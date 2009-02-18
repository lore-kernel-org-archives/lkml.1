Return-Path: <linux-kernel-owner+w=401wt.eu-S1755703AbZBRR3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703AbZBRR3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 12:29:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbZBRR30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 12:29:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59212 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266AbZBRR3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 12:29:25 -0500
Date: Wed, 18 Feb 2009 12:29:23 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Geoff Levand <geoffrey.levand@am.sony.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/7] tracing/function-graph-tracer: make arch generic
 push pop functions
In-Reply-To: <20090218125334.GA1300@elte.hu>
Message-ID: <alpine.DEB.1.10.0902181218360.11411@gandalf.stny.rr.com>
References: <20090213052358.524970112@goodmis.org> <20090213053004.787392572@goodmis.org> <alpine.DEB.1.10.0902162346190.30397@gandalf.stny.rr.com> <20090218010039.GL25856@elte.hu> <alpine.DEB.1.10.0902172243550.1360@gandalf.stny.rr.com>
 <20090218125334.GA1300@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 18 Feb 2009, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Wed, 18 Feb 2009, Ingo Molnar wrote:
> > 
> > > 
> > > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > > 
> > > > Ingo,
> > > > 
> > > > This patch is to make function graph arch generic. But since 
> > > > the PowerPC changes depend on it, we want to push it through 
> > > > the PowerPC tree. But since it touches x86 code, can you give 
> > > > an Acked-by to it?
> > > 
> > > hm, but it's all ftrace bits. Could this go through the tracing 
> > > tree? That's how it's generally done for most cross-arch 
> > > subsystems. By having it in a separate tree we risk conflicts 
> > > and various logistics problems. It's not like the PPC tree is 
> > > modifying its ftrace.c file all that frequently, right?
> > 
> > Ingo,
> > 
> > How about this. We could incorporate some of the power of git. 
> > I could make a separate branch based off of Linus's 2.6.29-rc5 
> > announcement, and apply just this patch (the ftrace generic 
> > and x86 change). If you give me your Acked-by, I'll add that 
> > too.
> > 
> > This way, both you and Ben could pull from this branch to get 
> > the one change. When it goes upstream, because it has the same 
> > SHA1, git could easily resolve it.
> 
> Sure, that's fine too - if the separate tree is semantically 
> meaningful. If it pulls in too many ftrace prerequisites i doubt 
> it's appropriate for the PPC tree.

Yeah, I'll just make a new branch based off of Linus's 2.6.29-rc5 
announcement, and add the one patch, and not touch it again. This will be 
a simple merge of one patch from a change set that is in both trees.

-- Steve

