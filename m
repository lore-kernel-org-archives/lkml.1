Return-Path: <linux-kernel-owner+w=401wt.eu-S1753545AbYFRKjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbYFRKjt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 06:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751620AbYFRKjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 06:39:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55027 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482AbYFRKjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 06:39:41 -0400
Date: Wed, 18 Jun 2008 12:39:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [sched-devel, patch-rfc] rework of "prioritize
	non-migratabletasks over migratable ones"
Message-ID: <20080618103919.GH15255@elte.hu>
References: <1213138710.26530.51.camel@earth> <1213174382.31518.69.camel@twins> <b647ffbd0806110305p2be38608iadc1d2e91e3be57a@mail.gmail.com> <48563FDB.BA47.005A.0@novell.com> <b647ffbd0806161059q7048ea40id0f4235ab19d6ca0@mail.gmail.com> <1213643862.16944.142.camel@twins> <48568CCC.BA47.005A.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48568CCC.BA47.005A.0@novell.com>
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


* Gregory Haskins <ghaskins@novell.com> wrote:

> >>> On Mon, Jun 16, 2008 at  3:17 PM, in message
> <1213643862.16944.142.camel@twins>, Peter Zijlstra <a.p.zijlstra@chello.nl>
> wrote: 
> > On Mon, 2008-06-16 at 19:59 +0200, Dmitry Adamushko wrote:
> > 
> >> One way or another, we have different aritifacts (and mine have likely
> >> more) but conceptually, both "violates" POSIX if a strict round-robin
> >> scheduling is required.
> > 
> > http://www.opengroup.org/onlinepubs/009695399/functions/xsh_chap02_08.html#t
> > ag_02_08_04_01
> > 
> > Is quite strict on what FIFO should do, and I know of two points where
> > we deviate and should work to match.
> 
> Thanks for the link, Peter.  When you read that, its pretty clear that 
> this whole concept violates the standard.  Its probably best to just 
> revert the patch and be done with it.

no, there's no spec violation here - the spec is silent on SMP issues.

the spec should not be read to force a global runqueue for RT tasks. 
That would be silly beyond imagination.

so ... lets apply Dmitry's nice simplification, hm?

	Ingo
