Return-Path: <linux-kernel-owner+w=401wt.eu-S1760722AbXJaWFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760722AbXJaWFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 18:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761248AbXJaWEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 18:04:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44555 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761133AbXJaWEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 18:04:06 -0400
Subject: Re: [PATCH 5/6] sched: SCHED_FIFO/SCHED_RR watchdog timer
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Mike Galbraith <efault@gmx.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Lennart Poettering <mzxreary@0pointer.de>
In-Reply-To: <p73fxzr2bv4.fsf@bingen.suse.de>
References: <20071031211030.310581000@chello.nl>
	 <20071031211249.531637000@chello.nl>  <p73fxzr2bv4.fsf@bingen.suse.de>
Content-Type: text/plain
Date: Wed, 31 Oct 2007 23:03:28 +0100
Message-Id: <1193868208.5911.3.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-10-31 at 22:49 +0100, Andi Kleen wrote:
> Peter Zijlstra <a.p.zijlstra@chello.nl> writes:
> 
> > Introduce a new rlimit that allows the user to set a runtime timeout
> > on real-time tasks. Once this limit is exceeded the task will receive
> > SIGXCPU.
> 
> Nice idea.
> 
> It would be even nicer if you could allow a couple of them. Partition
> the RT priorities into a few classes and have an own limit for each them.
> 
> A small number of classes (3-4) would be probably enough and not bloat
> the rlimits too much.
> 
> I'm thinking of the case where you have different kinds of real
> time processes. Like your mp3 player which you want to be slightly
> real time, but with a low SIGXCPU limit. 
> 
> And then something else real time which is more important and
> you would set a higher limit. etc.

But its an rlimit, it can be set per process. Not sure what multiple
classes per process would gain us, let alone how that process has to
figure out which class to use.


