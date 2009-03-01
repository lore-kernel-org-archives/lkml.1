Return-Path: <linux-kernel-owner+w=401wt.eu-S1756377AbZCALxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377AbZCALxU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 06:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753744AbZCALxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 06:53:11 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46588 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978AbZCALxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 06:53:10 -0500
Date: Sun, 1 Mar 2009 12:52:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       jaswinder@kernel.org, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] x86: Basic AMD Support for performance
	counters, disable IRQs
Message-ID: <20090301115252.GA10079@elte.hu>
References: <tip-15112f89efb79797c0d70ce6759e2438d66d4f59@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-15112f89efb79797c0d70ce6759e2438d66d4f59@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> Commit-ID:  15112f89efb79797c0d70ce6759e2438d66d4f59
> Gitweb:     http://git.kernel.org/tip/15112f89efb79797c0d70ce6759e2438d66d4f59
> Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
> AuthorDate: Sun, 1 Mar 2009 15:02:11 +0530
> Commit:     Ingo Molnar <mingo@elte.hu>
> CommitDate: Sun, 1 Mar 2009 12:43:03 +0100
> 
> x86: Basic AMD Support for performance counters, disable IRQs
> 
> Ingo Molnar reported:
> 
> > The AMD perfcounter patches cause a crash - an Opteron system
> > spontaneous reboots at this point during early bootup:
> >
> > CPU 0/0x4 -> Node 0
> > tseg: 00cfe00000
> > CPU: Physical Processor ID: 0
> > CPU: Processor Core ID: 0
> > using C1E aware idle routine
> > AMD Performance Monitoring support detected.
> > ... num counters:    4
> > ... value mask:      0000000000000000
> > ... fixed counters:  0
> > ... counter mask:    000000000000000f
> > ACPI: Core revision 20081204
> > ftrace: converting mcount calls to 0f 1f 44 00 00
> > ftrace: allocating 16365 entries in 129 pages
> > Setting APIC routing to physical flat
> > masked ExtINT on CPU#0
> > ENABLING IO
> > [reboot]
> 
> Disable the IRQ path for now.

No, this doesnt help - it still crashes.

	Ingo
