Return-Path: <linux-kernel-owner+w=401wt.eu-S1758863AbYHUKwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758863AbYHUKwp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 06:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755295AbYHUKwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 06:52:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38442 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755206AbYHUKwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 06:52:35 -0400
Date: Thu, 21 Aug 2008 12:52:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: latest -git: BUG: unable to handle kernel paging request
	(numaq_tsc_disable)
Message-ID: <20080821105218.GB28331@elte.hu>
References: <19f34abd0808200828o6496cbeap75b7242845e96ef3@mail.gmail.com> <19f34abd0808200840v17a8e5d4ge60c332f864abd81@mail.gmail.com> <19f34abd0808200912y3f9cd132hee6cd7ea9852d112@mail.gmail.com> <19f34abd0808200918n54aba154ta3c06dd7fbdf383f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0808200918n54aba154ta3c06dd7fbdf383f@mail.gmail.com>
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

> > Oops, I am wrong about numaq_tsc_disable() being __init. Still, I 
> > believe that Yinghai might be able to say what's really wrong :-)
> 
> Err... No, I am confusing myself! I had already applied a patch to 
> change it to __cpuinit :-/
> 
> The good news is that the bug is now fixed. Patch attached.

applied to tip/x86/urgent - thanks Vegard!

	Ingo
