Return-Path: <linux-kernel-owner+w=401wt.eu-S1752944AbZIGK2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944AbZIGK2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 06:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbZIGK2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 06:28:44 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:34493 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbZIGK2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 06:28:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eM9XHE+Su0I55r10kR2QoNSucBJxVQgE4oAz0HMWqRGfMZ7idjt0+dfFry213med8n
         ZpU4ZYlFaYwU9OP2oz5rUQQJwn/1FLMJLaXcm+hXJsaLeI3K5PgmOuoO4HLXJeIsE2VA
         3j0hBkXoNXdU9bzCZCpUdhFdtEihQ+2ceZIqM=
Date: Mon, 7 Sep 2009 12:28:40 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jan Blunck <jblunck@suse.de>, Ulrich Lukas <ulrich.lukas@gmx.de>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Clark Williams <williams@redhat.com>,
       linux-rt-users@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 00/18] tracing/ring-buffer: fixes for latency tracer
	[2.6.32]
Message-ID: <20090907102838.GA6393@nowhere>
References: <20090904235527.520961911@goodmis.org> <20090905150658.GA13387@ghostprotocols.net> <4de7f8a60909070320j692d746drb06bd635ca7f7c55@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4de7f8a60909070320j692d746drb06bd635ca7f7c55@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 07, 2009 at 12:20:50PM +0200, Jan Blunck wrote:
> On Sat, Sep 5, 2009 at 5:06 PM, Arnaldo Carvalho de Melo<acme@redhat.com> wrote:
> >
> > I did a quick port to tip/rt/head and couldn't reproduce the problems I
> > was experiencing, thanks!
> >
> > I've put the ported patch series at:
> >
> > http://userweb.kernel.org/~acme/rostedt-rb-rt
> >
> 
> Nice, this also seems to fix my problem with the hanging wakup
> selftest. At least the system continues to boot. However, I still get
> this:
> 
> [   13.739115] Testing tracer sched_switch: PASSED
> [   14.002071] Testing tracer function: PASSED
> [   14.158816] Testing dynamic ftrace: PASSED
> [   14.512524] Testing tracer irqsoff: PASSED
> [   14.693519] Testing tracer preemptoff: PASSED
> [   14.853519] Testing tracer preemptirqsoff: PASSED
> [   15.013506] Testing tracer wakeup:
> [   15.134004] hrtimer: interrupt too slow, forcing clock min delta to
> 27508383 ns



Ah, Ulrich Lukas also reported me such warnings. I would like to
track the reason of these messages (the hrtimer hanging detection
seems to warn too early).

Could you please send me your config, I hope I could reproduce it.

Thanks!

