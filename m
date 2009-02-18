Return-Path: <linux-kernel-owner+w=401wt.eu-S1754047AbZBRDNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbZBRDNi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 22:13:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754344AbZBRDN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 22:13:27 -0500
Received: from gate.crashing.org ([63.228.1.57]:36787 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754249AbZBRDN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 22:13:26 -0500
Subject: Re: [PATCH 1/7] tracing/function-graph-tracer: make arch generic
 push pop functions
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Geoff Levand <geoffrey.levand@am.sony.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <alpine.DEB.1.10.0902172022130.14430@gandalf.stny.rr.com>
References: <20090213052358.524970112@goodmis.org>
	 <20090213053004.787392572@goodmis.org>
	 <alpine.DEB.1.10.0902162346190.30397@gandalf.stny.rr.com>
	 <20090218010039.GL25856@elte.hu>
	 <alpine.DEB.1.10.0902172022130.14430@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Wed, 18 Feb 2009 14:12:19 +1100
Message-Id: <1234926739.14060.403.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-17 at 20:24 -0500, Steven Rostedt wrote:
> > hm, but it's all ftrace bits. Could this go through the tracing 
> > tree? That's how it's generally done for most cross-arch 
> > subsystems. By having it in a separate tree we risk conflicts 
> > and various logistics problems. It's not like the PPC tree is 
> > modifying its ftrace.c file all that frequently, right?
> 
> Really doesn't matter to me which tree it goes. I figure tip would be fine 
> in compile testing, but I doubt it would get much actual machine testing.
> 
> How fast do you get changes to next? Perhaps you could take it and push it 
> out to next, where Ben could quickly get it back in for testing? Or at 
> least do that with this patch, and then Ben could apply the others on top.

Well, it did already conflict with a patch from Kumar that change the
opcodes, which I could fix easily in my tree but would have been harder
to deal with in the tracing tree...

Also, my next tree will not pull somebody else next tree, as it's a
never-rebase-will-merge tree though I have a test branch i can play with
(in which your patches currently are).

In any case, I don't care -that- much who the patches go via, it's
easier for me to fix them up when conflicts occur in powerpc land and
they will probably get more testing via my tree but it's no big deal.
 
Cheers,
Ben.


