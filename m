Return-Path: <linux-kernel-owner+w=401wt.eu-S1756641AbZD2GKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641AbZD2GKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 02:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754989AbZD2GKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 02:10:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51385 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752867AbZD2GKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 02:10:16 -0400
Date: Wed, 29 Apr 2009 08:09:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 5/5] ring-buffer: fix printk output
Message-ID: <20090429060955.GD6148@elte.hu>
References: <20090429044814.138790038@goodmis.org> <20090429045908.394874083@goodmis.org> <20090428222024.8db50539.akpm@linux-foundation.org> <20090429054359.GA6148@elte.hu> <20090428225541.9ca61a12.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090428225541.9ca61a12.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 29 Apr 2009 07:43:59 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > On Wed, 29 Apr 2009 00:48:19 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:
> > > 
> > > > -	printk_once(KERN_WARNING "Tracing recursion: depth[%d]:"
> > > > +	printk_once(KERN_WARNING "Tracing recursion: depth[%ld]:"
> > > 
> > > hrmph.  I didn't know that printk_once() existed, and I should 
> > > have known.  I wonder how many other people don't know.
> > 
> > Was posted to linux-next@vger.kernel.org.
> 
> Well no wonder I didn't know about it.

I (too?) think it's counter-productive that the linux-next list is 
split out of lkml. I constantly fall into that trap: i get a 
bugreport against one of our trees, i see that there's vger in the 
Cc: list and mistake it for being Cc:-ed to lkml (all our trees are 
developed on lkml and most of the bugreports come Cc:-ed to lkml) 
but in reality it's Cc:-ed to linux-next which has a much smaller 
audience. (which audience apparently does not even include you)

If this email list fragmentation and the resoluting loss of 
information bothers you too then please ask Stephen to move 
linux-next mails to lkml (i've Cc:-ed Stephen) - it's not like it's 
actually something separate ... today's linux-next messages are 
tomorrow's lkml messages. Moving linux-next mails to lkml would 
nicely improve the S/N ratio on lkml.

	Ingo
