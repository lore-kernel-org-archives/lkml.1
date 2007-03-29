Return-Path: <linux-kernel-owner+w=401wt.eu-S1422656AbXC2WCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422656AbXC2WCi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 18:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422652AbXC2WCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 18:02:38 -0400
Received: from smtp.osdl.org ([65.172.181.24]:40691 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422656AbXC2WCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 18:02:37 -0400
Date: Thu, 29 Mar 2007 14:56:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andreas Mohr <andi@rhlx01.fht-esslingen.de>
cc: Andi Kleen <ak@suse.de>, Mark Langsdorf <mark.langsdorf@amd.com>,
       Len Brown <lenb@kernel.org>, "Morrow, William" <William.Morrow@amd.com>,
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
In-Reply-To: <20070329214520.GA3185@rhlx01.hs-esslingen.de>
Message-ID: <Pine.LNX.4.64.0703291454380.6730@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
 <p73d52s2dvi.fsf@bingen.suse.de> <460C1B5B.4090802@amd.com>
 <200703292249.37979.ak@suse.de> <Pine.LNX.4.64.0703291410480.6730@woody.linux-foundation.org>
 <20070329214520.GA3185@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 29 Mar 2007, Andreas Mohr wrote:
> 
> Please don't, this would break the interface logically.
> X86_FEATURE_xxx usually denotes a *feature*, not a "feature"
> (Micro$oft speak for "bug" ;).

Sure, we could  make it positive instead, and I agree it would make code 
nicer to read.

> Thus, how about e.g. X86_FEATURE_LAPIC_C1_OK?

I have no trouble at all with something like that instead. Anybody willing 
to cook up a patch?

		Linus
