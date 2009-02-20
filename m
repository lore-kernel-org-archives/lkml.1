Return-Path: <linux-kernel-owner+w=401wt.eu-S1755860AbZBTWyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbZBTWyz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 17:54:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbZBTWyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 17:54:47 -0500
Received: from casper.infradead.org ([85.118.1.10]:35844 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbZBTWyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 17:54:46 -0500
Subject: Re: [Announce] 2.6.29-rc4-rt2
From: Peter Zijlstra <peterz@infradead.org>
To: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Thomas Gleixner <tglx@tglx.de>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>
In-Reply-To: <1235168743.1052.16.camel@quadrophenia.thebigcorporation.com>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.0902122353050.16972@localhost.localdomain>
	 <1235168743.1052.16.camel@quadrophenia.thebigcorporation.com>
Content-Type: text/plain
Date: Fri, 20 Feb 2009 23:54:31 +0100
Message-Id: <1235170471.4736.44.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-20 at 14:25 -0800, Sven-Thorsten Dietrich wrote:
> On Thu, 2009-02-12 at 23:56 +0100, Thomas Gleixner wrote:
> > We are pleased to announce the first update to our new preempt-rt
> > series. It fixes the reported bugs and some more.
> > 
> FYI:
> 
> These patches in RT2:
> 
> rt-fix-ipi-kfree-introduce-ipi_softirq.patch
> rt-fix-ipi-kfree-introduce-ipi_softirq-cleanup.patch
> 
> Cause a hard-lock when running dhcp on my 8-way AMD box.
> 
> Reverting them eliminates the issue.

can you try the patches in:

http://lkml.org/lkml/2009/2/17/385
http://lkml.org/lkml/2009/2/17/384
http://lkml.org/lkml/2009/2/17/387



