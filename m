Return-Path: <linux-kernel-owner+w=401wt.eu-S1760604AbXJaWF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760604AbXJaWF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 18:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761542AbXJaWFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 18:05:05 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44588 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761529AbXJaWFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 18:05:01 -0400
Subject: Re: [PATCH 3/6] sched: high-res preemption tick
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Mike Galbraith <efault@gmx.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <p73bqaf2bpb.fsf@bingen.suse.de>
References: <20071031211030.310581000@chello.nl>
	 <20071031211249.142859000@chello.nl>  <p73bqaf2bpb.fsf@bingen.suse.de>
Content-Type: text/plain
Date: Wed, 31 Oct 2007 23:04:31 +0100
Message-Id: <1193868271.5911.5.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-10-31 at 22:53 +0100, Andi Kleen wrote:
> Peter Zijlstra <a.p.zijlstra@chello.nl> writes:
> 
> > Use HR-timers (when available) to deliver an accurate preemption tick.
> >
> > The regular scheduler tick that runs at 1/HZ can be too coarse when nice
> > level are used. The fairness system will still keep the cpu utilisation 'fair'
> > by then delaying the task that got an excessive amount of CPU time but try to
> > minimize this by delivering preemption points spot-on.
> 
> This might be costly when hrtimers happen to use an more expensive
> to reprogram time source. Even an APIC timer access is fairly slow. 
> And you'll potentially add the to lots of context switces.
> 
> Not sure that is a good idea for performance in general.

Well, me neither, it was just an idea, and a challenge to get
working :-)



