Return-Path: <linux-kernel-owner+w=401wt.eu-S1756792AbYFNGbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792AbYFNGbd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 02:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbYFNGbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 02:31:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51931 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090AbYFNGbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 02:31:25 -0400
Date: Sat, 14 Jun 2008 08:31:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] kmemcheck: divide and conquer
Message-ID: <20080614063114.GA24188@elte.hu>
References: <20080613140057.GA25833@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080613140057.GA25833@damson.getinternet.no>
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


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> Hi,
> 
> I've split the main x86/mm/kmemcheck.c file and made a subdirectory of 
> many files instead.
> 
> I have included the diffstat below, but I think the patch itself is 
> too big for the mailing list. It can instead be viewed at:
> 
> http://www.kernel.org/pub/linux/kernel/people/vegard/patches/0001-kmemcheck-divide-and-conquer.patch
> 
> The RFC part: Is this a good thing to do? I personally hate the 
> 4000-line files that are so commonly found in the kernel, and 
> therefore prefer this split-up. On the other hand, C lacks namespaces, 
> which sometimes leads to some really long and ugly names just to 
> prevent clashes in the future. But it's your call, I'll just do 
> whatever it takes to get in... ;-)

it's a very nice splitup! :-) [ Any Git coordinates to pick it up? ]

such a splitup opens up for future enhancements such as the sharing of 
opcode decoding between kmemcheck, mmiotrace and KVM. It also makes the 
code easier to maintain as there's less risk of patch merge conflicts. 
And not the least, it's easier to read as well if it's split up into 
logical modules.

	Ingo
