Return-Path: <linux-kernel-owner+w=401wt.eu-S965737AbXENKbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965737AbXENKbl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 06:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756335AbXENKbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 06:31:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53568 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755683AbXENKbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 06:31:32 -0400
Date: Mon, 14 May 2007 12:31:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>, efault@gmx.de, tingy@cs.umass.edu,
       linux-kernel@vger.kernel.org
Subject: Re: fair clock use in CFS
Message-ID: <20070514103120.GA23766@elte.hu>
References: <20070514083358.GA29775@in.ibm.com> <20070514102929.GL31925@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070514102929.GL31925@holomorphy.com>
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


* William Lee Irwin III <wli@holomorphy.com> wrote:

> On Mon, May 14, 2007 at 02:03:58PM +0530, Srivatsa Vaddagiri wrote:
> > 	I have been brooding over how fair clock is computed/used in
> > CFS and thought I would ask the experts to avoid wrong guesses!
> > As I understand, fair_clock is a monotonously increasing clock which
> > advances at a pace inversely proportional to the load on the runqueue.
> > If load = 1 (task), it will advance at same pace as wall clock, as 
> > load increases it advances slower than wall clock.
> > In addition, following calculations depend on fair clock: task's wait
> > time on runqueue and sleep time outside the runqueue (both reflected in
> > p->wait_run_time).
> 
> It's not hard to see that that's a mistake. [...]

please clarify - exactly what is a mistake? Thanks,

	Ingo
