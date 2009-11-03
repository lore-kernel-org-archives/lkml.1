Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497AbZKCR1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbZKCR1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 12:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754400AbZKCR1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 12:27:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36241 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754399AbZKCR1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 12:27:17 -0500
Date: Tue, 3 Nov 2009 18:26:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric=5FWeisbecker?= <fweisbec@gmail.com>
Subject: Re: [PATCH v2 2/7] Adding general performance benchmarking
	subcommand to perf.
Message-ID: <20091103172656.GB11535@elte.hu>
References: <20091103.195457.597119739836563839.mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091103.195457.597119739836563839.mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:

> Adding general performance benchmarking subcommand to perf.
> This patch adds bench/sched-messaging.c.
> This benchmark measures performance of scheduler and IPC mechanisms,
> and is based on hackbench by Rusty Russell.
> 
> Example of use:
> 
> % perf bench sched messaging               # Use default options
> 0.295					   # Result is time
> % perf bench sched messaging -p -l 1000 -t
> 2.265

Would be nice to standardize the options too, and offer a help line:

 perf bench sched --help

perhaps 'perf bench sched' should list all available benchmark modules, 
and print a oneliner summary about each of them?

	Ingo
