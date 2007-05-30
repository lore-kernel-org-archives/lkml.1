Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbXE3NSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbXE3NSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 09:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624AbXE3NSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 09:18:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39384 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449AbXE3NSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 09:18:24 -0400
Date: Wed, 30 May 2007 15:17:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Bill Huey <billh@gnuppy.monkey.org>, Jason Baron <jbaron@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/6] lock contention tracking -v4
Message-ID: <20070530131751.GA22724@elte.hu>
References: <20070530124903.882133089@chello.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070530124903.882133089@chello.nl>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Changes since -v3
>  - reshuffled code to reduce #ifdef mess

| Now at patch patches/raw_spinlock_fix.patch
| # grep "#ifdef" kernel/lockdep.c | wc -l
| 17

ok, this is unmodified lockdep.c.

| # quilt push
| Applying patch patches/lockdep-prove-locking.patch
| patching file kernel/lockdep.c
| patching file kernel/spinlock.c
|
| Now at patch patches/lockdep-prove-locking.patch
| # grep "#ifdef" kernel/lockdep.c | wc -l
| 23

this was the increase that Christoph commented on.

| # quilt push
| Applying patch patches/lockdep-reduce-ifdefs.patch
| patching file kernel/lockdep.c
| patching file kernel/lockdep_proc.c
|
| Now at patch patches/lockdep-reduce-ifdefs.patch
| # grep "#ifdef" kernel/lockdep.c | wc -l
| 11

and now it's lower than where it started out and you also put lockstat 
in! Nice! :)

	Ingo
