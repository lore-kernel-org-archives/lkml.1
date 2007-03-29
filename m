Return-Path: <linux-kernel-owner+w=401wt.eu-S1422678AbXC2WGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422678AbXC2WGv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 18:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422676AbXC2WGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 18:06:51 -0400
Received: from mx1.suse.de ([195.135.220.2]:55885 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422672AbXC2WGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 18:06:50 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Andreas Mohr <andi@rhlx01.fht-esslingen.de>
Subject: Re: [PATCH] i386: add command line option "local_apic_timer_c2_ok"
Date: Fri, 30 Mar 2007 00:06:22 +0200
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Mark Langsdorf <mark.langsdorf@amd.com>, Len Brown <lenb@kernel.org>,
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
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <Pine.LNX.4.64.0703291410480.6730@woody.linux-foundation.org> <20070329214520.GA3185@rhlx01.hs-esslingen.de>
In-Reply-To: <20070329214520.GA3185@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703300006.24960.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 March 2007 23:45, Andreas Mohr wrote:
> Hi,
> 
> On Thu, Mar 29, 2007 at 02:16:54PM -0700, Linus Torvalds wrote:
> > 
> > 
> > On Thu, 29 Mar 2007, Andi Kleen wrote:
> > > 
> > > Here's a patch. I don't have a system with C1E, so i only tested that
> > > the apic timer still works on a older AMD box.
> > 
> > I think this looks better than what we have now, but it would look even 
> > better if the core CPUID stuff was in arch/i386/kernel/cpu/amd.c, and we 
> > simply had X86_FEATURE_BROKEN_C1_LAPIC etc..
> 
> Please don't, this would break the interface logically.

We already have several of those. And negative is much easier. 

-Andi
