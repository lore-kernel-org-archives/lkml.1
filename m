Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbXC3VGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbXC3VGH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 17:06:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753958AbXC3VGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 17:06:06 -0400
Received: from mail.chilan.com ([82.160.212.9]:58583 "EHLO mail.chilan.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753952AbXC3VGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 17:06:04 -0400
From: "Grzegorz Chwesewicz" <grzegorz.chwesewicz@chilan.com>
To: Andi Kleen <ak@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Langsdorf <mark.langsdorf@amd.com>, Len Brown <lenb@kernel.org>,
       "Morrow, William" <William.Morrow@amd.com>,
       "Crouse, Jordan" <jordan.crouse@ldcmail.amd.com>,
       Thomas Gleixner <tglx@linutronix.de>, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Mingming Cao <cmm@us.ibm.com>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Oliver Pinter <oliver.pntr@gmail.com>,
       Sid Boyce <g3vbv@blueyonder.co.uk>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH] i386: add command line option "local_apic_timer_c2_ok"
Date: Fri, 30 Mar 2007 23:06:02 +0200
Message-Id: <20070330210534.M37380@chilan.com>
In-Reply-To: <200703300005.41800.ak@suse.de>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <200703292249.37979.ak@suse.de> <Pine.LNX.4.64.0703291410480.6730@woody.linux-foundation.org> <200703300005.41800.ak@suse.de>
X-Mailer: OpenWebMail 2.52 20061019
X-OriginatingIP: 82.160.213.5 (ceho)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2007 00:05:39 +0200, Andi Kleen wrote
> On Thursday 29 March 2007 23:16, Linus Torvalds wrote:
> > 
> > On Thu, 29 Mar 2007, Andi Kleen wrote:
> > > 
> > > Here's a patch. I don't have a system with C1E, so i only tested that
> > > the apic timer still works on a older AMD box.
> > 
> > I think this looks better than what we have now, but it would look even 
> > better if the core CPUID stuff was in arch/i386/kernel/cpu/amd.c, and we 
> > simply had X86_FEATURE_BROKEN_C1_LAPIC etc..
> > 
> > And then the apic.c code would just check
> > 
> > 	if (boot_cpu_has(X86_FEATURE_BROKEN_C1_LAPIC))
> > 		return -1;
> > 
> > or similar.
> 
> Ok fair point. Here's an updated patch.

This patch also works. If You want bootlog or output of /proc/interrupts I can
post it.

--
Greetings - CeHo - Grzegorz Chwesewicz
