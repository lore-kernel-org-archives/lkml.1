Return-Path: <linux-kernel-owner+w=401wt.eu-S1754010AbYHSLog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbYHSLog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 07:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbYHSLo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 07:44:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41495 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbYHSLo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 07:44:28 -0400
Date: Tue, 19 Aug 2008 13:44:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
       x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0 of 9] x86/smp function calls: convert x86 tlb flushes
	to use function calls [POST 2]
Message-ID: <20080819114404.GA5354@elte.hu>
References: <patchbomb.1219083817@localhost> <200808191956.59898.nickpiggin@yahoo.com.au> <20080819102045.GC6722@elte.hu> <200808192108.13338.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808192108.13338.nickpiggin@yahoo.com.au>
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


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Tuesday 19 August 2008 20:20, Ingo Molnar wrote:
> > * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > > I'm especially sore about mmap because I have a customer with a
> > > database that uses a lot of mmap/munmap and those calls have slowed
> > > down something like 50%(!!) from 2.6.early to 2.6.late.
> >
> > oh, agreed that it all needs to speed up - please send testcases ...
> 
> I'm not sure if I can send the testcase I have. But this issue is 
> coming to the top of my list to investigate in mainline, so I'll check 
> out how we're doing here soon.

obviously having a repeatable testcase would jump-start any efforts to 
fix this. It doesnt have to be complex - just a .c thing kernel 
developers can run and get some quick number out of. A 50% regression 
shouldnt be too hard to reproduce even with a vastly simplified 
workload.

	Ingo
