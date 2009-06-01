Return-Path: <linux-kernel-owner+w=401wt.eu-S1756228AbZFAXOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbZFAXOm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 19:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbZFAXOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 19:14:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56276 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752298AbZFAXOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 19:14:35 -0400
Date: Tue, 2 Jun 2009 01:14:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_counter: Provide functions for locking and
	pinning the context for a task
Message-ID: <20090601231428.GF749@elte.hu>
References: <18979.34748.755674.596386@cargo.ozlabs.ibm.com> <18979.35192.995732.609215@cargo.ozlabs.ibm.com> <20090601162109.GA8459@elte.hu> <18980.19019.158462.125715@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18980.19019.158462.125715@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Paul Mackerras <paulus@samba.org> wrote:

> Ingo Molnar writes:
> 
> > -tip testing found that these patches are causing a crash:
> 
> Argh.  What was userspace doing at the time of the crash, do you 
> know? It looks like it might have been on/off-lining a cpu, 
> judging by the stack trace.  Would there have been any counters 
> attached to the task doing there, or were there any per-cpu 
> counters active?

Yeah, indeed that box has a CPU hotplug testcase - sets cpu1 to 
offline then online.

There should be no counters active anywhere during that.

	Ingo
