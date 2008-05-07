Return-Path: <linux-kernel-owner+w=401wt.eu-S932192AbYEGHOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192AbYEGHOL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 03:14:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759383AbYEGHNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 03:13:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38638 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759024AbYEGHNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 03:13:52 -0400
Date: Wed, 7 May 2008 09:13:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, venkatesh.pallipadi@intel.com,
       "Carlos R. Mafra" <crmafra2@gmail.com>
Subject: Re: x86: Clean up computation of HPET .mult variables
Message-ID: <20080507071334.GG32195@elte.hu>
References: <20080505231016.GA29072@beyonder.ift.unesp.br> <1210031888.17132.85.camel@localhost.localdomain> <20080506021321.GA4928@Pilar.virtua.com.br> <1210044218.17132.109.camel@localhost.localdomain> <20080506125920.GA26295@beyonder.ift.unesp.br> <1210090880.17132.140.camel@localhost.localdomain> <20080506205003.GA3749@beyonder.ift.unesp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080506205003.GA3749@beyonder.ift.unesp.br>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0078]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Carlos R. Mafra <crmafra2@gmail.com> wrote:

> PS: I also computed the "exact" value for hpet_clockevent.mult
> by hand and got 
> 
> hpet_clockevent.mult = 61496114.58 (exact)
> hpet_clockevent.mult = 61496114    (my patch)
> hpet_clockevent.mult = 61496110    (original)
> 
> so my patch in fact improves the accuracy (due to the fact that it 
> removes the extra do_div() to compute the frequency, which originaly 
> did not have the rounding trick.)

that's reassuring, thanks Carlos - patch is still queued up in x86.git. 
(with a v2.6.27-ish merge target, provided it all goes well.)

	Ingo
