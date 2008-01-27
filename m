Return-Path: <linux-kernel-owner+w=401wt.eu-S1760134AbYA0WTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760134AbYA0WTg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 17:19:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756854AbYA0WT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 17:19:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48321 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754466AbYA0WT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 17:19:27 -0500
Date: Sun, 27 Jan 2008 23:19:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Benjamin K. Stuhl" <benjamin.stuhl@colorado.edu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux-Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: "sched: add vslice" causes horrible interactivity under load
Message-ID: <20080127221916.GA18482@elte.hu>
References: <20080127144400.78e0aec5@colorado.edu> <20080127221422.GA17085@elte.hu> <20080127221702.GA18151@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080127221702.GA18151@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > while such delays are happening? Please enable CONFIG_SCHED_DEBUG=y 
> > and CONFIG_SCHEDSTATS=y as well before doing the dump. Also please 
> > send your .config.
> 
> another thing that might make a difference is to disable (or enable) 
> the CONFIG_FAIR_GROUP_SCHED feature in the .config.

yet another thing to tune would be to decrease the value of 
/proc/sys/kernel/sched_latency, and/or to subtract '4' from the value of 
/proc/sys/kernel/sched_features. [it defaults to 7 in v2.6.24]

	Ingo
