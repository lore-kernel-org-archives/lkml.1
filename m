Return-Path: <linux-kernel-owner+w=401wt.eu-S1756251AbZB0IDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251AbZB0IDT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 03:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754679AbZB0IDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 03:03:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38899 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754662AbZB0IDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 03:03:05 -0500
Date: Fri, 27 Feb 2009 09:02:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Langsdorf <mark.langsdorf@amd.com>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, eric@lammerts.org
Subject: Re: [PATCH][retry 2] Conform L3 Cache Index Disable to Linux
	standards From:  Eric Lammerts <eric@lammerts.org>
Message-ID: <20090227080246.GA524@elte.hu>
References: <200902201550.47415.mark.langsdorf@amd.com> <20090226163329.3a47b368.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090226163329.3a47b368.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 20 Feb 2009 15:50:47 -0600
> Mark Langsdorf <mark.langsdorf@amd.com> wrote:
> 
> > Add ABI Documentation entry and fix some /sys directory formating
> > issues with the L3 Cache Index Disable feature for future AMD
> > processors. __Add a check to disable it for family 0x10 models
> > that do not support it yet.
> 
> x86_64 allnoconfig:
> 
> arch/x86/kernel/cpu/intel_cacheinfo.c:556: warning: 'free_cache_attributes' defined but not used
> arch/x86/kernel/cpu/intel_cacheinfo.c:596: warning: 'detect_cache_attributes' defined but not used
> 
> Fixing these revealed another shower of unused functions.  
> Fixing those led to an even bigger shower.
> 
> Obviously, the code is a mess and needs some thought, 
> understanding and restructuring so that mere mortals can 
> correctly modify it.
> 
> I'll drop the patches.  Please test version 3 a bit better?

Yes. I'll pick it up into the x86 tree once it works and builds 
warning-free.

	Ingo
