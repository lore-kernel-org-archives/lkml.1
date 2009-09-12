Return-Path: <linux-kernel-owner+w=401wt.eu-S1751869AbZILHjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869AbZILHjc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 03:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbZILHjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 03:39:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54659 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbZILHjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 03:39:31 -0400
Date: Sat, 12 Sep 2009 09:39:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Steven Rostedt <srostedt@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Warning from ring buffer code (Was: Re: linux-next: tip tree
	build warning)
Message-ID: <20090912073906.GA3972@elte.hu>
References: <20090804161640.70817ee6.sfr@canb.auug.org.au> <1249403089.4634.139.camel@localhost.localdomain> <20090912165300.9d257283.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090912165300.9d257283.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Steve,
> 
> On Tue, 04 Aug 2009 12:24:49 -0400 Steven Rostedt <srostedt@redhat.com> wrote:
> >
> > On Tue, 2009-08-04 at 16:16 +1000, Stephen Rothwell wrote:
> > > 
> > > Today's linux-next build (powerpc ppc64_defconfig) produced these warnings:
> > > 
> > > kernel/trace/ring_buffer.c: In function 'rb_head_page_set':
> > > kernel/trace/ring_buffer.c:704: warning: initialization makes pointer from integer without a cast
> > > kernel/trace/ring_buffer.c:704: warning: initialization makes pointer from integer without a cast
> > > kernel/trace/ring_buffer.c: In function 'rb_head_page_replace':
> > > kernel/trace/ring_buffer.c:797: warning: initialization makes integer from pointer without a cast
> > > 
> > > Introduced by commit 77ae365eca895061c8bf2b2e3ae1d9ea62869739
> > > ("ring-buffer: make lockless").
> > 
> > Thanks, I'll take a look at it.
> 
> Now that this is in Linus' tree, can we have a fix for the waning, 
> please?

The first warning got fixed 1.5 months ago - the second one at line 
797 is still there but harmless - you can ignore it for now, it will 
be fixed.

	Ingo
