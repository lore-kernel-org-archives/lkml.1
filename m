Return-Path: <linux-kernel-owner+w=401wt.eu-S1755681AbYBIHiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681AbYBIHiV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 02:38:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbYBIHiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 02:38:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59278 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbYBIHiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 02:38:12 -0500
Date: Sat, 9 Feb 2008 08:37:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [git pull] latency tracer
Message-ID: <20080209073756.GA13141@elte.hu>
References: <20080208214522.GA31101@elte.hu> <20080208232306.6e8a8162.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080208232306.6e8a8162.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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

> On Fri, 8 Feb 2008 22:45:22 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > Linus, please pull the latency tracer tree from:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git
> > 
> > Find the shortlog below.
> > 
> > This is the latency tracer from -rt
> 
> I've never seen any of this code before and googling several of the 
> patch titles turns up this email and nothing else.

there might be some confusion here. Google for "mcount tracing utility" 
- there's 2270 hits. There's been 8 full series posted to lkml in the 
past month:

 Date: Thu, 03 Jan 2008 02:16:09 -0500
 Subject: [RFC PATCH 00/11] mcount tracing utility

 Date: Wed, 09 Jan 2008 18:29:14 -0500
 Subject: [RFC PATCH 00/22 -v2] mcount and latency tracing utility -v2

 Date: Tue, 15 Jan 2008 15:49:07 -0500
 Subject: [RFC PATCH 00/30 v3] mcount and latency tracing utility -v3

 Date: Mon, 21 Jan 2008 10:22:31 -0500
 Subject: [RFC PATCH 00/23 -v4] mcount and latency tracing utility -v4

 Date: Wed, 23 Jan 2008 11:02:36 -0500
 Subject: [PATCH 00/20 -v5] mcount and latency tracing utility -v5

 Date: Fri, 25 Jan 2008 23:21:52 -0500
 Subject: [PATCH 00/23 -v6] mcount and latency tracing utility -v6

 Date: Tue, 29 Jan 2008 22:15:21 -0500
 Subject: [PATCH 00/22 -v7] mcount and latency tracing utility -v7

 Date: Wed, 30 Jan 2008 16:03:57 -0500
 Subject: [PATCH 00/23 -v8] mcount and latency tracing utility -v8

it derives from the same latency tracer code that we wrote for -rt that 
has been around for years:

   http://people.redhat.com/mingo/latency-tracing-patches/

we renamed the concept to 'ftrace' during pre-merge cleanups, perhaps 
that is what caused you to not recognize this? (mcount is a confusing 
name and ties it to a gcc feature while there's nothing gcc specific 
about this concept.)

	Ingo
