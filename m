Return-Path: <linux-kernel-owner+w=401wt.eu-S1757227AbZAMTC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227AbZAMTC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 14:02:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbZAMTCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 14:02:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38913 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292AbZAMTCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 14:02:12 -0500
Date: Tue, 13 Jan 2009 20:01:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>, Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH -v9][RFC] mutex: implement adaptive spinning
Message-ID: <20090113190142.GA2508@elte.hu>
References: <1231774622.4371.96.camel@laptop> <1231859742.442.128.camel@twins> <alpine.LFD.2.00.0901130812590.6528@localhost.localdomain> <1231863710.7141.3.camel@twins> <1231864854.7141.8.camel@twins> <alpine.LFD.2.00.0901130846320.6528@localhost.localdomain> <1231867314.7141.16.camel@twins> <20090113183310.GA10065@elte.hu> <alpine.LFD.2.00.0901131038260.6528@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901131038260.6528@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Tue, 13 Jan 2009, Ingo Molnar wrote:
> > 
> > below is the v8 -> v10 delta patch - for all who'd like to review the 
> > changes.
> 
> Hmm. This does seem to indicate that v10 lost many of the preempt 
> changes. Probably because Peter went back to v7 to create it.
> 
> I also wonder about the timing numbers - the numbers were probably done 
> with some random version and then not re-done, so the commit message is 
> not necessarily "sane" in that respect - the timings quoted don't 
> necessarily match the code committed.

yeah - i didnt take care with v10's commit log because it will be redone 
with a structural splitup anyway, instead of the current time based 
history.

	Ingo
