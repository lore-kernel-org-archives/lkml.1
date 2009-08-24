Return-Path: <linux-kernel-owner+w=401wt.eu-S1752287AbZHXMPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbZHXMPZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 08:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750828AbZHXMPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 08:15:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:54532 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbZHXMPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 08:15:24 -0400
Subject: Re: [PATCH v3 2/4] tracing: Make syscall_(un)regfunc arch-specific
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mundt <lethal@linux-sh.org>, Frederic Weisbecker <fweisbec@gmail.com>,
       Josh Stone <jistone@redhat.com>, linux-kernel@vger.kernel.org,
       Jason Baron <jbaron@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
In-Reply-To: <20090824115241.GD10215@elte.hu>
References: <1250795373-32363-1-git-send-email-jistone@redhat.com>
	 <1250917125-6174-1-git-send-email-jistone@redhat.com>
	 <1250917125-6174-2-git-send-email-jistone@redhat.com>
	 <1250917125-6174-3-git-send-email-jistone@redhat.com>
	 <20090823211422.GG6256@nowhere> <20090824014025.GA12653@linux-sh.org>
	 <20090824084101.GE2424@elte.hu> <20090824085944.GA15330@linux-sh.org>
	 <20090824095652.GC25267@elte.hu> <20090824103251.GA18106@linux-sh.org>
	 <20090824115241.GD10215@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 24 Aug 2009 14:14:28 +0200
Message-Id: <1251116068.7538.206.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-24 at 13:52 +0200, Ingo Molnar wrote:
> * Paul Mundt <lethal@linux-sh.org> wrote:
> 
> > On Mon, Aug 24, 2009 at 11:56:52AM +0200, Ingo Molnar wrote:
> 
> > > So i'd really like you to back up your claims with facts. Your 
> > > mail is basically unsubstantiated FUD right now and i'll just 
> > > ignore you if you continue this pattern of unsubstantiated 
> > > attacks and unconstructive behavior.
> > 
> > I could sit here and itemize individual breakages all day long, 
> > but what would be the point? [...]
> 
> The point would be to prove your so far unsubstantiated (and IMO 
> unfair) attacks.

Guys, can we get over this already.. really every linux developer runs
x86, except the very few that don't. We all try to ensure we don't
accidentally break things, shit happens, deal with it.

!x86 breaking more often than x86 is a simple consequence of statistics,
if you don't like it, make your hardware sexy and send it to more
devs ;-)

Build breakages aren't a big deal, they get sorted, life moves on. If
they wouldn't get sorted there might be something to complain about, but
afaict that doesn't happen.

Paul, you put a tracing patch into the sh tree, didn't cc the tracing
folks and then found it broke when the tracing tree was added, *gosh*!?

That will happen with pretty much every other subsystem too, that's what
we have subsystem tree's for, I think enough has been arranged to
mitigate this issue in the future - lets go fix some real bugs now? :-)


