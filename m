Return-Path: <linux-kernel-owner+w=401wt.eu-S1755890AbZBUA6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbZBUA6R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 19:58:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754540AbZBUA6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 19:58:00 -0500
Received: from rv-out-0506.google.com ([209.85.198.238]:20558 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535AbZBUA57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 19:57:59 -0500
Subject: Re: [Announce] 2.6.29-rc4-rt2
From: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Thomas Gleixner <tglx@tglx.de>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>
In-Reply-To: <1235170471.4736.44.camel@laptop>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.0902122353050.16972@localhost.localdomain>
	 <1235168743.1052.16.camel@quadrophenia.thebigcorporation.com>
	 <1235170471.4736.44.camel@laptop>
Content-Type: text/plain
Date: Fri, 20 Feb 2009 16:57:54 -0800
Message-Id: <1235177874.1052.33.camel@quadrophenia.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-20 at 23:54 +0100, Peter Zijlstra wrote:
> On Fri, 2009-02-20 at 14:25 -0800, Sven-Thorsten Dietrich wrote:
> > On Thu, 2009-02-12 at 23:56 +0100, Thomas Gleixner wrote:
> > > We are pleased to announce the first update to our new preempt-rt
> > > series. It fixes the reported bugs and some more.
> > > 
> > FYI:
> > 
> > These patches in RT2:
> > 
> > rt-fix-ipi-kfree-introduce-ipi_softirq.patch
> > rt-fix-ipi-kfree-introduce-ipi_softirq-cleanup.patch
> > 
> > Cause a hard-lock when running dhcp on my 8-way AMD box.
> > 
> > Reverting them eliminates the issue.
> 
> can you try the patches in:
> 
> http://lkml.org/lkml/2009/2/17/385
> http://lkml.org/lkml/2009/2/17/384
> http://lkml.org/lkml/2009/2/17/387
> 
> 
> 

These work with 2.6.29-rc4-rt2.

Also fixes serial console stall.

I applied them before RT and had to tweak these patches:

preempt-realtime-ipi-call-lock-raw.patch
preempt-realtime-x86_64.patch

Thanks!

Sven



