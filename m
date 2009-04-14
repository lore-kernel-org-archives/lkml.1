Return-Path: <linux-kernel-owner+w=401wt.eu-S1753837AbZDNTQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbZDNTQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 15:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbZDNTQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 15:16:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48323 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbZDNTQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 15:16:41 -0400
Date: Tue, 14 Apr 2009 21:16:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: cpu_debug.c prepare report if files are
	inappropriate or CPU is not supported
Message-ID: <20090414191622.GA797@elte.hu>
References: <1239725240.2966.4.camel@ht.satnam> <20090414165052.GA2089@elte.hu> <1239728481.2966.21.camel@ht.satnam> <20090414184222.GC11214@elte.hu> <20090414200247.1d0a8667@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090414200247.1d0a8667@lxorguk.ukuu.org.uk>
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


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > > Do you still think that boot_cpu_data.x86_vendor is better option in
> > > case for multiple CPUs.
> > 
> > yes. Assymetric SMP never really happened on x86.
> 
> It did but not between vendors. You can get away with a vendor 
> assumption but cpu type (mixed 486SX/DX, PII/PIII/Celeron) mixed 
> steppings and mixed speeds do occur. We've never supported the 
> mixed 486SX cases but the PII/PIII cases work (or at least 
> worked).

yeah - but look at the specific purpose here: we are deciding 
whether to print out state information related to major CPU 
features. Mixed steppings/speeds might happen, mixed apic / 
non-lapic not really.

	Ingo
