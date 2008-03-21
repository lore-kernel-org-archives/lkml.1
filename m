Return-Path: <linux-kernel-owner+w=401wt.eu-S1757298AbYCUMyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbYCUMyS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 08:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754724AbYCUMyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 08:54:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39587 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753098AbYCUMyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 08:54:04 -0400
Date: Fri, 21 Mar 2008 13:53:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: ak@suse.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, markus.t.metzger@gmail.com,
       suresh.b.siddha@intel.com, roland@redhat.com, akpm@linux-foundation.org,
       mtk.manpages@gmail.com, eranian@googlemail.com
Subject: Re: [patch] x86, ptrace: support pebs in ds.c and disable ptrace
	and ds support
Message-ID: <20080321125338.GB27245@elte.hu>
References: <20080312125318.A15510@sedona.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080312125318.A15510@sedona.ch.intel.com>
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


* Markus Metzger <markus.t.metzger@intel.com> wrote:

> Polish the ds.h interface and add support for PEBS.
> 
> Guard DS support and the ptrace interface to BTS by CONFIG macros;
> disabled per default.
> 
> Ds.c is meant to be the resource allocator for per-thread and per-cpu
> BTS and PEBS recording.
> It is used by ptrace to provide execution tracing of debugged tasks.
> It will be used by utrace for the same purpose.
> It will be used by profilers (e.g. perfmon2).
> It may be used by kernel debuggers to provide a kernel execution trace.

we could apply this if Roland Acks it - but i guess a precondition for 
that is to not include more ptrace extensions and to also start working 
on utrace support for it. Ptrace is something we want to reduce usage 
of, not extend.

	Ingo
