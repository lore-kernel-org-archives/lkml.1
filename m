Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277AbYHUMSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbYHUMSl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 08:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751609AbYHUMSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 08:18:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33710 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbYHUMSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 08:18:13 -0400
Date: Thu, 21 Aug 2008 14:17:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] debug: fix BUILD_BUG_ON() for non-constant expressions
Message-ID: <20080821121748.GA3384@elte.hu>
References: <20080816100948.GB19926@martell.zuzino.mipt.ru> <alpine.LFD.1.10.0808170936260.3324@nehalem.linux-foundation.org> <20080817173319.GA2450@elte.hu> <200808181109.43203.rusty@rustcorp.com.au> <20080818075459.GH30694@elte.hu> <48A9472F.908@panasas.com> <20080819133422.GA24369@elte.hu> <48AAF5F7.6040709@panasas.com> <20080820105922.GC18524@elte.hu> <48AC0EB9.3080708@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AC0EB9.3080708@panasas.com>
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


* Boaz Harrosh <bharrosh@panasas.com> wrote:

> Ingo Molnar wrote:
> > * Boaz Harrosh <bharrosh@panasas.com> wrote:
> > 
> >> If the user of virtio_has_feature() must pass a compile-time constant 
> >> then it must be converted to a MACRO, and then the BUILD_BUG_ON will 
> >> work. Or it should be changed to a BUG_ON() if fbit is a runtime 
> >> variable.
> > 
> 
> The use of __builtin_constant_p in inline functions is broken. This is 
> because it will give different results depending on the -O level used. 
> So I think that using it in the Kernel with inlines is plain broken. 
> And should be discouraged.

ok - that's convincing, so your approach is superior to my hack on 
multiple levels.

Could you please (re-)send your patch(es) with a changelog, etc., so 
that i can apply it and drop my patches?

Thanks,

	Ingo
