Return-Path: <linux-kernel-owner+w=401wt.eu-S1756609AbZBRBZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609AbZBRBZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 20:25:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756532AbZBRBZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 20:25:04 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62718 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756526AbZBRBZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 20:25:01 -0500
Date: Tue, 17 Feb 2009 20:24:57 -0500 (EST)
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
In-Reply-To: <20090218010039.GL25856@elte.hu>
Message-ID: <alpine.DEB.1.10.0902172022130.14430@gandalf.stny.rr.com>
References: <20090213052358.524970112@goodmis.org> <20090213053004.787392572@goodmis.org> <alpine.DEB.1.10.0902162346190.30397@gandalf.stny.rr.com> <20090218010039.GL25856@elte.hu>
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
> > Ingo,
> > 
> > This patch is to make function graph arch generic. But since 
> > the PowerPC changes depend on it, we want to push it through 
> > the PowerPC tree. But since it touches x86 code, can you give 
> > an Acked-by to it?
> 
> hm, but it's all ftrace bits. Could this go through the tracing 
> tree? That's how it's generally done for most cross-arch 
> subsystems. By having it in a separate tree we risk conflicts 
> and various logistics problems. It's not like the PPC tree is 
> modifying its ftrace.c file all that frequently, right?

Really doesn't matter to me which tree it goes. I figure tip would be fine 
in compile testing, but I doubt it would get much actual machine testing.

How fast do you get changes to next? Perhaps you could take it and push it 
out to next, where Ben could quickly get it back in for testing? Or at 
least do that with this patch, and then Ben could apply the others on top.

-- Steve

