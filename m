Return-Path: <linux-kernel-owner+w=401wt.eu-S1758559AbZAGO5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559AbZAGO5B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 09:57:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754046AbZAGO4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 09:56:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51749 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798AbZAGO4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 09:56:47 -0500
Date: Wed, 7 Jan 2009 15:56:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Chris Mason <chris.mason@oracle.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: Btrfs for mainline
Message-ID: <20090107145621.GB23455@elte.hu>
References: <1230722935.4680.5.camel@think.oraclecorp.com> <1231093310.27690.5.camel@twins> <20090104184103.GE2002@parisc-linux.org> <200901060147.24285.nickpiggin@yahoo.com.au> <1231173015.4290.129.camel@think.oraclecorp.com> <20090107130742.GD3529@elte.hu> <20090107132447.GR2002@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107132447.GR2002@parisc-linux.org>
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


* Matthew Wilcox <matthew@wil.cx> wrote:

> On Wed, Jan 07, 2009 at 02:07:42PM +0100, Ingo Molnar wrote:
> > * Chris Mason <chris.mason@oracle.com> wrote:
> > > All of this is a long way of saying the btrfs locking scheme is far from 
> > > perfect.  I'll look harder at the loop and ways to get rid of it.
> > 
> > <ob'plug>
> > 
> > adaptive spinning mutexes perhaps? Such as:
> 
> Um, I don't know how your mail client does threading, but mine shows 
> Peter's message introducing the adaptive spinning mutexes as a reply to 
> one of Chris' messages in the btrfs thread.
>
> Chris is just saying he'll look at other ways to not need the spinning 
> mutexes.

But those are not the same spinning mutexes. Chris wrote his mail on Jan 
05, Peter his first mail about spin-mutexes on Jan 06, as a reaction to 
Chris's mail.

My reply links back the discussion to the original analysis from Chris 
pointing out that it would be nice to try BTRFS with plain mutexes plus 
Peter's patch - instead of throwing away BTRFS's locking design or 
anything intrusive like that.

Where's the problem? :)

	Ingo
